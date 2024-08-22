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
    
    global static dtmAltaDeResellerResponse procesarSolicitud(Map<String, Object>  entradaDatos) {
        String accountId = (String) entradaDatos.get('accountId');
        System.debug(accountId);
        String usuario = (String) entradaDatos.get('usuario');
        System.debug(usuario);
        String pass = (String) entradaDatos.get('password');
        System.debug(pass);
        Integer idSistema = 1;
        
        //Contact cuenta = [SELECT FirstName,MiddleName,LastName,HomePhone,dtmTelefonoTrabajo__c,Email,Account.Name,dtmUsuario__c,dtmContrasena__c,dtmResellerId__c FROM Contact WHERE id=:accountId];
        //String jsonRequest='{"test":"test"}';
    	Account cuenta = [SELECT id,Name,dtmTelefonoFacturacion__c,dtmEmailCorporativo__c,dtmTelefonoFijo__c,dtmIdResellerOdin__c FROM Account WHERE Id=:accountId];
        Contact contactoDatos = [SELECT FirstName,MiddleName,LastName,Suffix FROM Contact WHERE AccountId=:accountId AND dtmPrimaryContact__c=true];

        String jsonRequest = '{';
        jsonRequest +='"idSistema":'+idSistema+',';
        jsonRequest +='"telefono":"'+cuenta.dtmTelefonoFacturacion__c+'",';
        jsonRequest +='"usuario":"'+usuario+'",';
        jsonRequest +='"password":"'+pass+'",';
        jsonRequest +='"nombreEmpresa":"'+cuenta.Name+'",';
        if(contactoDatos.MiddleName!=null){
            String nombre = contactoDatos.FirstName;
        	String nombreSinAcentos = dtmAltaDeCuentaEnReseller.eliminarAcentos(nombre);
            String nombreSecundario = contactoDatos.MiddleName;
        	String nombreSecundarioSinAcentos = dtmAltaDeCuentaEnReseller.eliminarAcentos(nombreSecundario);
            jsonRequest +='"nombre":"'+nombreSinAcentos+' '+nombreSecundarioSinAcentos+'",';
        }else{
            String nombre = contactoDatos.FirstName;
        	String nombreSinAcentos = dtmAltaDeCuentaEnReseller.eliminarAcentos(nombre);
            jsonRequest +='"nombre":"'+nombreSinAcentos+'",';
        }
        String apPaterno = contactoDatos.LastName;
        String apPaternoSinAcentos = dtmAltaDeCuentaEnReseller.eliminarAcentos(apPaterno);
        jsonRequest +='"apPaterno":"'+apPaternoSinAcentos+'",';
        String apMaterno = contactoDatos.Suffix;
        String apMaternoSinAcentos = dtmAltaDeCuentaEnReseller.eliminarAcentos(apMaterno);
        jsonRequest +='"apMaterno":"'+apMaternoSinAcentos+'",';
        jsonRequest +='"correo":"'+cuenta.dtmEmailCorporativo__c+'",';
        jsonRequest +='"telContacto":"'+cuenta.dtmTelefonoFijo__c+'"';
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
            cuenta.dtmIdResellerOdin__c = responses.resellerId;
            update cuenta;
        } else{
            respuesta.statusCode = 400;
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
    
    public static String eliminarAcentos(String textoConAcentos) {
       if (textoConAcentos == null) {
           return null;
       }
       // Reemplazar acentos comunes
       textoConAcentos = textoConAcentos.replaceAll('[áàäâã]', 'a');
       textoConAcentos = textoConAcentos.replaceAll('[éèëê]', 'e');
       textoConAcentos = textoConAcentos.replaceAll('[íìïî]', 'i');
       textoConAcentos = textoConAcentos.replaceAll('[óòöôõ]', 'o');
       textoConAcentos = textoConAcentos.replaceAll('[úùüû]', 'u');
       textoConAcentos = textoConAcentos.replaceAll('ñ', 'n');
       textoConAcentos = textoConAcentos.replaceAll('ç', 'c');
       textoConAcentos = textoConAcentos.replaceAll('[ÁÀÄÂÃ]', 'A');
       textoConAcentos = textoConAcentos.replaceAll('[ÉÈËÊ]', 'E');
       textoConAcentos = textoConAcentos.replaceAll('[ÍÌÏÎ]', 'I');
       textoConAcentos = textoConAcentos.replaceAll('[ÓÒÖÔÕ]', 'O');
       textoConAcentos = textoConAcentos.replaceAll('[ÚÙÜÛ]', 'U');
       textoConAcentos = textoConAcentos.replaceAll('Ñ', 'N');
       textoConAcentos = textoConAcentos.replaceAll('Ç', 'C');
       return textoConAcentos;
   }
}