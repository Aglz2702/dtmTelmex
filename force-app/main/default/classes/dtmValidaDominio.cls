global class dtmValidaDominio {  
    global class dtmValidaDominioResponse {
        global String codigoRespuesta {get;set;}
        global String mensajeRespuesta {get;set;}
        global List<error> errores {get;set;}
        global Integer statusCode {get;set;}
        global Integer statusCodeAuxiliar {get;set;}
        global Map<String, Object> toMap() {
            Map<String, Object> mapa = new Map<String, Object>();
            mapa.put('codigoRespuesta', codigoRespuesta);
            mapa.put('mensajeRespuesta', mensajeRespuesta);
            mapa.put('statusCode', statusCode);
            mapa.put('statusCodeAuxiliar', statusCodeAuxiliar);
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
        global Map<String, Object> toMap() {
            Map<String, Object> mapa4 = new Map<String, Object>();
            mapa4.put('error', error);
            return mapa4;
        }
    }
    
    global static dtmValidaDominioResponse procesarSolicitud(Map<String, Object> entradaDatos) {
        String validar = (String) entradaDatos.get('validar');
        String nombre = (String) entradaDatos.get('nombre');
        System.debug('nombre:'+nombre);
        String valor = (String) entradaDatos.get('valor');
        System.debug('valor:'+valor);
        
        // Crear el nuevo mapa con la estructura deseada
        Map<String, Object> nuevoMapa = new Map<String, Object>();
        nuevoMapa.put('validar', validar);
        
        List<Map<String, Object>> parametros = new List<Map<String, Object>>();
        Map<String, Object> parametro = new Map<String, Object>();
        if(validar=='DOMINIO'){
            switch on valor{
                when '.com'{
                    parametro.put('nombre', 'DOMINIO_COM');
                }
                when '.org'{
                    parametro.put('nombre', 'DOMINIO_ORG');
                }
                when '.net'{
                    parametro.put('nombre', 'DOMINIO_NET');
                }
                when '.com.mx'{
                    parametro.put('nombre', 'DOMINIO_COM.MX');
                }
                when '.mx'{
                    parametro.put('nombre', 'DOMINIO_MX');
                }
            }
            //parametro.put('nombre', valor);
            parametro.put('valor', nombre);
        }else{
            parametro.put('nombre', nombre);
            parametro.put('valor', valor);
        }
        parametros.add(parametro);
        
        nuevoMapa.put('parametros', parametros);
        
        String jsonRequest = JSON.serialize(nuevoMapa);
        System.debug('Request a enviar jsonRequest: '+jsonRequest);
        dtmValidaDominioResponse respuesta = new dtmValidaDominioResponse();
        dtmValidaDominio.dtmValidaDominioResponse responses = dtmValidaDominioController.integrarConEndpointExterno(jsonRequest);
        if (responses.statusCode==200 && responses.codigoRespuesta=='00') {
            respuesta.statusCode = responses.statusCode;
            respuesta.statusCodeAuxiliar = 200;
            respuesta.mensajeRespuesta = responses.mensajeRespuesta;
            respuesta.codigoRespuesta = responses.codigoRespuesta;
        } else{
            respuesta.statusCode = responses.statusCode;
            respuesta.statusCodeAuxiliar = 400;
            respuesta.mensajeRespuesta = responses.mensajeRespuesta;
            respuesta.codigoRespuesta = responses.codigoRespuesta;
            respuesta.errores = responses.errores;
            dtmValidaDominio.guardaErrores(jsonRequest, respuesta);
        }
        System.debug('Se envia respuesta: '+respuesta);
        return respuesta;
    }
    public static void guardaErrores(String jsonEntrada,dtmValidaDominio.dtmValidaDominioResponse respuesta){
        String mensajeError = 'codigoError: '+respuesta.codigoRespuesta +' Mensaje: '+respuesta.mensajeRespuesta;
        Integer codigoEstatus = respuesta.StatusCode;
        vlocity_cmt__VlocityErrorLogEntry__c errorNew = new vlocity_cmt__VlocityErrorLogEntry__c();
        errorNew.vlocity_cmt__Action__c = 'POST';
        errorNew.vlocity_cmt__ErrorCode__c = String.valueOf(codigoEstatus);
        errorNew.vlocity_cmt__ErrorMessage__c = mensajeError;
        errorNew.vlocity_cmt__ErrorTime__c = Datetime.Now();
        errorNew.vlocity_cmt__ErrorType__c = 'Callout Error';
        errorNew.vlocity_cmt__InputData__c = jsonEntrada;
        errorNew.Name = 'Valida Dominio';
        errorNew.vlocity_cmt__ObjectName__c = 'Quote';
        errorNew.vlocity_cmt__SourceType__c = 'Omniscript';
        Insert errorNew;
        System.debug('Id de registro: '+errorNew.Id); 
    }

}