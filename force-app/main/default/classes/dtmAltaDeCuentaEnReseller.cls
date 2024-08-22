@SuppressWarnings('PMD.AvoidGlobalModifier')
global class dtmAltaDeCuentaEnReseller {
    global class dtmAltaDeCuentaEnResellerResponse {
        global String codigoRespuesta {get;set;}
        global String mensajeRespuesta {get;set;}
        global List<error> errores {get;set;}
        global Integer accountId {get;set;}
        global String folioId {get;set;}
        global Integer statusCode {get;set;}
        
        global Map<String, Object> toMap() {
            Map<String, Object> mapa = new Map<String, Object>();
            mapa.put('codigoRespuesta', codigoRespuesta);
            mapa.put('mensajeRespuesta', mensajeRespuesta);
            mapa.put('accountId', accountId);
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
    
    global static dtmAltaDeCuentaEnResellerResponse procesarSolicitud(String entradaDatos) {
        String idAccount = entradaDatos;
        
        Account cuenta = [SELECT id,dtmIdResellerOdin__c,dtmIdCuentaODIN__c,dtmSubCuentaMaestra__c,Name,dtmDireccionCompletaFiscal__c,dtmTelefonoFijo__c,dtmEmailCorporativo__c,dtmDireccionFiscal__PostalCode__s,dtmDireccionFiscal__City__s,dtmDireccionFiscal__StateCode__s FROM Account WHERE id=:idAccount];
        System.debug('cuenta '+cuenta);
        Contact contactoDatos = [SELECT FirstName,MiddleName,LastName,Suffix FROM Contact WHERE AccountId=:idAccount AND dtmPrimaryContact__c=true];
        System.debug('contactoDatos '+contactoDatos);
        String jsonRequest = '{';
        jsonRequest +='"resellerId":"'+cuenta.dtmIdResellerOdin__c+'",';
        jsonRequest +='"subCtaMaestra":"'+cuenta.dtmSubCuentaMaestra__c+'",';
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
        jsonRequest +='"telContacto":"'+cuenta.dtmTelefonoFijo__c+'",';
        jsonRequest +='"codigoPostal":"'+cuenta.dtmDireccionFiscal__PostalCode__s+'",';
        String direccion = cuenta.dtmDireccionCompletaFiscal__c;
        String direccionSinAcentos = dtmAltaDeCuentaEnReseller.eliminarAcentos(direccion);
        jsonRequest +='"direccion":"'+direccionSinAcentos+'",';
        Switch on cuenta.dtmDireccionFiscal__StateCode__s{
            when 'ME'{
                jsonRequest +='"cveEstado":"MX",';
            }
            when 'PB'{
                jsonRequest +='"cveEstado":"PU",';
            }
            when 'QE'{
                jsonRequest +='"cveEstado":"QT",';
            }
            when 'CH'{
                jsonRequest +='"cveEstado":"CP",';
            }
            when else{
                jsonRequest +='"cveEstado":"'+cuenta.dtmDireccionFiscal__StateCode__s+'",';
            }
        }
        String localidad = cuenta.dtmDireccionFiscal__City__s;
        String localidadSinAcentos = dtmAltaDeCuentaEnReseller.eliminarAcentos(localidad);
        jsonRequest +='"localidad":"'+localidadSinAcentos+'"';
        jsonRequest +='}';
    
        System.debug('El request a enviar es:'+jsonRequest);
    	dtmAltaDeCuentaEnReseller.dtmAltaDeCuentaEnResellerResponse respuesta = new dtmAltaDeCuentaEnReseller.dtmAltaDeCuentaEnResellerResponse();
        dtmAltaDeCuentaEnReseller.dtmAltaDeCuentaEnResellerResponse responses = dtmAltaDeCuentaEnResellerController.integrarConEndpointExterno(jsonRequest);
    	
    	if (responses.statusCode==200 && responses.codigoRespuesta=='00') {
            respuesta.statusCode = responses.statusCode;
            respuesta.codigoRespuesta = responses.codigoRespuesta;
            respuesta.mensajeRespuesta = responses.mensajeRespuesta;
            respuesta.accountId = responses.accountId;
            respuesta.folioId = responses.folioId;
            respuesta.statusCode = responses.statusCode;
            cuenta.dtmIdCuentaODIN__c = responses.accountId;
            update cuenta;
        } else{
            respuesta.statusCode = 400;
            respuesta.codigoRespuesta = responses.codigoRespuesta;
            respuesta.mensajeRespuesta = responses.mensajeRespuesta;
            respuesta.errores = responses.errores;
            dtmAltaDeCuentaEnReseller.guardaErrores(jsonRequest, respuesta);
        }
    
        return respuesta;
    }
    
    public static void guardaErrores(String jsonEntrada,dtmAltaDeCuentaEnReseller.dtmAltaDeCuentaEnResellerResponse respuesta){
        String mensajeError = 'codigoError: '+respuesta.errores +' Mensaje: '+respuesta.mensajeRespuesta;
        Integer codigoEstatus = respuesta.StatusCode;
        vlocity_cmt__VlocityErrorLogEntry__c errorNew = new vlocity_cmt__VlocityErrorLogEntry__c();
        errorNew.vlocity_cmt__Action__c = 'POST';
        errorNew.vlocity_cmt__ErrorCode__c = String.valueOf(codigoEstatus);
        errorNew.vlocity_cmt__ErrorMessage__c = mensajeError;
        errorNew.vlocity_cmt__ErrorTime__c = Datetime.Now();
        errorNew.vlocity_cmt__ErrorType__c = 'Callout Error';
        errorNew.vlocity_cmt__InputData__c = jsonEntrada;
        errorNew.Name = 'Alta de Cuenta en Reseller';
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