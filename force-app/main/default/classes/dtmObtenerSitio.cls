@SuppressWarnings('PMD.AvoidGlobalModifier')
global class dtmObtenerSitio {

    global class dtmObtenerSitioResponse {
        global String mensaje {get;set;}
        global Integer codigoErr {get;set;}
        global List<sitio> sitios {get;set;}
        global Integer statusCode {get;set;}
        global String nCon {get;set;}
        
        global Map<String, Object> toMap() {
            Map<String, Object> mapa = new Map<String, Object>();
            mapa.put('mensaje', mensaje);
            mapa.put('codigoErr', codigoErr);
            mapa.put('statusCode', statusCode);
            if (sitios != null) {
                List<Map<String, Object>> sitiosList = new List<Map<String, Object>>();
                for (sitio e : sitios) {
                    sitiosList.add(e.toMap());
                }
                mapa.put('sitios', sitiosList);
            }
            return mapa;
        }
    }
    global class sitio {
        global String sitioId {get;set;}
        global String sitioNombre {get;set;}
        
        public Map<String, Object> toMap() {
            Map<String, Object> mapa2 = new Map<String, Object>();
            mapa2.put('sitioId', sitioId);
            mapa2.put('sitioNombre', sitioNombre);
            mapa2.put('ncon', sitioId+' '+sitioNombre);
            return mapa2;
        }
    }

    global static dtmObtenerSitioResponse procesarSolicitud(Map<String, Object> entradaDatos) {
        System.debug('Entrada  de '+entradaDatos);
        String jsonRequest = JSON.serialize(entradaDatos);
        dtmObtenerSitioResponse respuesta = new dtmObtenerSitioResponse();
        dtmObtenerSitio.dtmObtenerSitioResponse responses = dtmObtenerSitioController.integrarConEndpointExterno(entradaDatos);
        
        if (responses.statusCode==200) {
            respuesta.statusCode = responses.statusCode;
            respuesta.mensaje = responses.mensaje;
            respuesta.sitios = responses.sitios;
        } else{
            respuesta.statusCode = responses.statusCode;
            respuesta.mensaje = responses.mensaje;
            respuesta.codigoErr = responses.codigoErr;
            dtmObtenerSitio.guardaErrores(jsonRequest, respuesta);
        }
        System.debug('Se envia respuesta: '+respuesta);
        return respuesta;
    }
    
    public static void guardaErrores(String jsonEntrada,dtmObtenerSitio.dtmObtenerSitioResponse respuesta){
        String mensajeError = 'codigoError: '+respuesta.codigoErr +' Mensaje: '+respuesta.mensaje;
        Integer codigoEstatus = respuesta.StatusCode;
        vlocity_cmt__VlocityErrorLogEntry__c errorNew = new vlocity_cmt__VlocityErrorLogEntry__c();
        errorNew.vlocity_cmt__Action__c = 'POST';
        errorNew.vlocity_cmt__ErrorCode__c = String.valueOf(codigoEstatus);
        errorNew.vlocity_cmt__ErrorMessage__c = mensajeError;
        errorNew.vlocity_cmt__ErrorTime__c = Datetime.Now();
        errorNew.vlocity_cmt__ErrorType__c = 'Callout Error';
        errorNew.vlocity_cmt__InputData__c = jsonEntrada;
        errorNew.Name = 'Obtener Sitios GIS';
        errorNew.vlocity_cmt__ObjectName__c = 'Quote';
        errorNew.vlocity_cmt__SourceType__c = 'Omniscript';
        Insert errorNew;
        System.debug('Id de registro: '+errorNew.Id); 
    }
}