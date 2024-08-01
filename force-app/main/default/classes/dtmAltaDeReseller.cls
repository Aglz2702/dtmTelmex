@SuppressWarnings('PMD.AvoidGlobalModifier')
global class dtmAltaDeReseller {
    global class dtmAltaDeResellerResponse {
        global String codigoRespuesta {get;set;}
        global String mensajeRespuesta {get;set;}
        global List<error> errores {get;set;}
        global Integer resellerId {get;set;}
        global String folioId {get;set;}
        global Integer statusCode {get;set;}
        
        global  Map<String, Object> toMap() {
            Map<String, Object> mapa = new Map<String, Object>();
            mapa.put('codigoRespuesta', codigoRespuesta);
            mapa.put('mensajeRespuesta', mensajeRespuesta);
            mapa.put('resellerId', resellerId);
            mapa.put('folioId', folioId);
            mapa.put('statusCode', statusCode);
            if (errores != null) {
                List<Map<String, Object>> erroresList = new List<Map<String, Object>>();
                for (error e : errores) {
                    erroresList.add(e.toMap());
                }
                mapa.put('errores', erroresList);
            }
            return mapa;
        }
    }
    
    global class error {
        global String error {get;set;}
        
        public Map<String, Object> toMap() {
            Map<String, Object> mapa2 = new Map<String, Object>();
            mapa2.put('error', error);
            return mapa2;
        }
    }
    
    global static dtmAltaDeResellerResponse procesarSolicitud(String entradaDatos) {
        String idContacto = entradaDatos;
        String user = 'test';
        String pass = 'test';
        Integer idSistema = 1;
        
        Contact cuenta = [SELECT FirstName,MiddleName,LastName,HomePhone,dtmTelefonoTrabajo__c,Email,Account.Name,dtmUsuario__c,dtmContrasena__c,dtmResellerId__c FROM Contact WHERE id=:idContacto];
        
        String jsonRequest = '{';
        jsonRequest +='"idSistema":"'+idSistema+'",';
        jsonRequest +='"telefono":"'+cuenta.HomePhone+'",';
        jsonRequest +='"usuario":"'+cuenta.dtmUsuario__c+'",';
        jsonRequest +='"password":"'+cuenta.dtmContrasena__c+'",';
        jsonRequest +='"nombreEmpresa":"'+cuenta.Account.Name+'",';
        jsonRequest +='"nombre":"'+cuenta.FirstName+' '+cuenta.MiddleName+'",';
        jsonRequest +='"apPaterno":"'+cuenta.MiddleName+'",';
        jsonRequest +='"apMaterno":"'+cuenta.LastName+'",';
        jsonRequest +='"correo":"'+cuenta.Email+'",';
        jsonRequest +='"telContacto":"'+cuenta.dtmTelefonoTrabajo__c+'"';
        jsonRequest +='}';

    	System.debug('El request a enviar es:'+jsonRequest);
    	dtmAltaDeReseller.dtmAltaDeResellerResponse respuesta = new dtmAltaDeReseller.dtmAltaDeResellerResponse();
        dtmAltaDeReseller.dtmAltaDeResellerResponse responses = dtmAltaDeResellerController.integrarConEndpointExterno(jsonRequest);
    	
    	if (responses.statusCode==200 && responses.codigoRespuesta=='00') {
            respuesta.statusCode = responses.statusCode;
            respuesta.codigoRespuesta = responses.codigoRespuesta;
            respuesta.mensajeRespuesta = responses.mensajeRespuesta;
            respuesta.resellerId = responses.resellerId;
            respuesta.folioId = responses.folioId;
            cuenta.dtmResellerId__c = responses.resellerId;
            update cuenta;
        } else{
            respuesta.statusCode = responses.statusCode;
            respuesta.codigoRespuesta = responses.codigoRespuesta;
            respuesta.mensajeRespuesta = responses.mensajeRespuesta;
            respuesta.errores = responses.errores;
            dtmAltaDeReseller.guardaErrores(jsonRequest, respuesta);
        }
    
        return respuesta;
    }
    
    public static void guardaErrores(String jsonEntrada,dtmAltaDeReseller.dtmAltaDeResellerResponse respuesta){
        String mensajeError = 'codigoError: '+respuesta.errores +' Mensaje: '+respuesta.mensajeRespuesta;
        Integer codigoEstatus = respuesta.StatusCode;
        vlocity_cmt__VlocityErrorLogEntry__c errorNew = new vlocity_cmt__VlocityErrorLogEntry__c();
        errorNew.vlocity_cmt__Action__c = 'POST';
        errorNew.vlocity_cmt__ErrorCode__c = String.valueOf(codigoEstatus);
        errorNew.vlocity_cmt__ErrorMessage__c = mensajeError;
        errorNew.vlocity_cmt__ErrorTime__c = Datetime.Now();
        errorNew.vlocity_cmt__ErrorType__c = 'Callout Error';
        errorNew.vlocity_cmt__InputData__c = jsonEntrada;
        errorNew.Name = 'Alta de Reseller';
        errorNew.vlocity_cmt__ObjectName__c = 'Quote';
        errorNew.vlocity_cmt__SourceType__c = 'Omniscript';
        Insert errorNew;
        System.debug('Id de registro: '+errorNew.Id); 
    }
}