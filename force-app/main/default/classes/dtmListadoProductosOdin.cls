@SuppressWarnings('PMD.AvoidGlobalModifier')
global class dtmListadoProductosOdin {
    
    global class dtmListadoProductosOdinResponse {
        global String codigoRespuesta {get;set;}
        global String mensajeRespuesta {get;set;}
        global Integer statusCode {get; set;}
        
        global Map<String, Object> toMap() {
            Map<String, Object> mapa = new Map<String, Object>();
            mapa.put('codigoRespuesta', codigoRespuesta);
            mapa.put('mensajeRespuesta', mensajeRespuesta);
            mapa.put('statusCode', statusCode);
            return mapa;
    }
}

    global static dtmListadoProductosOdinResponse procesarSolicitud(String entradaDatos) {
        String idQuote = entradaDatos;

        Quote cotizacion = [SELECT Id,dtmCuentaPartnerId__c FROM Quote WHERE Id=:idQuote];
        Account cuentaPartner = [SELECT id,Name,dtmIdCuentaODIN__c,dtmIdResellerOdin__c FROM Account WHERE id=:cotizacion.dtmCuentaPartnerId__c];
        QuoteLineItem produPadre = [SELECT id,dtmRFC__c,Product2.Id,Product2.ProductCode,Product2.Name,Product2.vlocity_cmt__SpecificationType__c,Product2.dtmLegacyName__c FROM QuoteLineItem WHERE QuoteId=:idQuote AND Product2.vlocity_cmt__SpecificationType__c='Offer'];

        String jsonRequest ='{';
        jsonRequest += '"listaParametros": [';
        jsonRequest += '{';
        jsonRequest +='"parametro":"resellerId",';
        jsonRequest +='"valor":"'+String.valueOf(cuentaPartner.dtmIdResellerOdin__c)+'"';
        jsonRequest += '},';
        jsonRequest += '{';
        jsonRequest +='"parametro":"accountId",';
        jsonRequest +='"valor":"'+String.valueOf(cuentaPartner.dtmIdCuentaODIN__c)+'"';
        jsonRequest += '},';
        jsonRequest += '{';
        jsonRequest +='"parametro":"cveProducto",';
        jsonRequest +='"valor":"'+produPadre.Product2.dtmLegacyName__c +'"';
        jsonRequest += '},';
        jsonRequest += '{';
        jsonRequest +='"parametro":"status",';
        jsonRequest +='"valor":"ACTIVE"';
        jsonRequest += '}';
        jsonRequest += ']';
        jsonRequest +='}';
        
        System.debug('El request a enviar es:'+jsonRequest);
        
        dtmListadoProductosOdinResponse respuesta = new dtmListadoProductosOdinResponse();
        dtmListadoProductosOdin.dtmListadoProductosOdinResponse responses = dtmListadoProductosOdinController.integrarConEndpointExterno(jsonRequest);
        if (responses.statusCode==200) {
            respuesta.statusCode = responses.statusCode;
            
            if(responses.codigoRespuesta=='LSPAR-13'){
                respuesta.codigoRespuesta = '13';
                respuesta.mensajeRespuesta = 'Consulta sin suscriptiones cloud .';
            }else{
                respuesta.codigoRespuesta = '00';
                respuesta.mensajeRespuesta = 'Ya cuenta con suscripciones de este producto activas';
            }
        } else{
            respuesta.statusCode = responses.statusCode;
            respuesta.codigoRespuesta = responses.codigoRespuesta;
            respuesta.mensajeRespuesta = responses.mensajeRespuesta;
            dtmListadoProductosOdin.guardaErrores(jsonRequest, respuesta,idQuote);
        }
        System.debug('Se envia respuesta: '+respuesta);
        return respuesta;
    }
    public static void guardaErrores(String jsonEntrada,dtmListadoProductosOdin.dtmListadoProductosOdinResponse respuesta,Id idQuote){
        String mensajeError = 'codigoError: '+respuesta.codigoRespuesta +' Mensaje: '+respuesta.mensajeRespuesta;
        Integer codigoEstatus = respuesta.StatusCode;
        vlocity_cmt__VlocityErrorLogEntry__c errorNew = new vlocity_cmt__VlocityErrorLogEntry__c();
        errorNew.vlocity_cmt__Action__c = 'POST';
        errorNew.vlocity_cmt__ErrorCode__c = String.valueOf(codigoEstatus);
        errorNew.vlocity_cmt__ErrorMessage__c = mensajeError;
        errorNew.vlocity_cmt__ErrorTime__c = Datetime.Now();
        errorNew.vlocity_cmt__ErrorType__c = 'Callout Error';
        errorNew.vlocity_cmt__InputData__c = jsonEntrada;
        errorNew.Name = 'Listado de Productos Odin';
        errorNew.vlocity_cmt__ObjectName__c = 'Quote';
        errorNew.vlocity_cmt__SourceType__c = 'Omniscript';
        errorNew.dtmCotizacion__c = idQuote;
        Insert errorNew;
        System.debug('Id de registro: '+errorNew.Id); 
    }
}