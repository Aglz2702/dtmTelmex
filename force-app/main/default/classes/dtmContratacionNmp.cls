@SuppressWarnings('PMD.AvoidGlobalModifier')
global class dtmContratacionNmp {
    global class dtmContratacionNmpResponse {
        global String codigo {get;set;}
        global String folio {get;set;}
        global String mensajeError {get;set;}
        global Integer statusCode {get;set;}
        global Integer statusCodeAuxiliar {get;set;}
        
        global Map<String, Object> toMap() {
            Map<String, Object> mapa = new Map<String, Object>();
            mapa.put('codigo', codigo);
            mapa.put('folio', folio);
            mapa.put('statusCode', statusCode);
            mapa.put('mensajeError', mensajeError);
            mapa.put('statusCodeAuxiliar', statusCodeAuxiliar);
            return mapa;
    }
}
    global static dtmContratacionNmpResponse procesarSolicitud(String entradaDatos) {
        String idQuote = entradaDatos;
        String producto = '';
        
        Quote cotizacion = [SELECT dtmFolioNmp__c,dtmMensajeError__c,Opportunity.dtmCuentaPartner__c FROM Quote WHERE Id=:idQuote];
        Account cuentaPartner = [SELECT id,Name,dtmTelefonoFacturacion__c,dtmEmailCorporativo__c,dtmTelefonoFijo__c FROM Account WHERE Id=:Cotizacion.Opportunity.dtmCuentaPartner__c];
        List<QuoteLineItem> productos = [SELECT id,Quantity,Product2.Name,Product2.ProductCode FROM QuoteLineItem WHERE QuoteId=:idQuote AND Product2.vlocity_cmt__SpecificationType__c='Product'];
        
        String[] partes = productos[0].Product2.Name.split(' ');
        String numParticipantes = partes[1];
        
        String jsonRequest ='{';
        jsonRequest +='"telefono":"'+cuentaPartner.dtmTelefonoFacturacion__c+'",';
        jsonRequest +='"producto":"'+productos[0].Product2.ProductCode+'",';
        jsonRequest += '"datosAdicionales": [';
        jsonRequest += '{';
        jsonRequest +='"nombreDato":"nombre",';
        jsonRequest +='"valorDato":"'+cuentaPartner.Name+'"';
        jsonRequest += '},';
        jsonRequest += '{';
        jsonRequest +='"nombreDato":"apellidos",';
        jsonRequest +='"valorDato":"'+cuentaPartner.dtmTelefonoFijo__c+'"';
        jsonRequest += '},';
        jsonRequest += '{';
        jsonRequest +='"nombreDato":"correo",';
        jsonRequest +='"valorDato":"'+cuentaPartner.dtmEmailCorporativo__c+'"';
        jsonRequest += '},';
        jsonRequest += '{';
        jsonRequest +='"nombreDato":"numParticipantes",';
        jsonRequest +='"valorDato":"'+numParticipantes+'"';
        jsonRequest += '}';
        jsonRequest += ']';
        jsonRequest +='}';
        
        System.debug('El request a enviar es:'+jsonRequest);
        dtmContratacionNmp.dtmContratacionNmpResponse respuesta = new dtmContratacionNmp.dtmContratacionNmpResponse();
        dtmContratacionNmp.dtmContratacionNmpResponse responses = dtmContratacionNmpController.integrarConEndpointExterno(jsonRequest);
        String mensajeErr = '';
        if (responses.statusCode==200 && responses.codigo=='000') {
            respuesta.statusCodeAuxiliar = 200;
            respuesta.statusCode = responses.statusCode;
            respuesta.codigo = responses.codigo;
            respuesta.folio = responses.folio;
            cotizacion.dtmFolioNmp__c = responses.folio;
            update cotizacion;
        } else{
            respuesta.statusCode = responses.statusCode;
            respuesta.statusCodeAuxiliar = 400;
            respuesta.codigo = responses.codigo;
            respuesta.folio = responses.folio;
            switch on responses.codigo{
                When '001'{
                    mensajeErr = 'ERROR EN CONTRATACIÓN: CODIGO '+responses.codigo;
                }
                When '002'{
                    mensajeErr = 'PALABRAS RESERVADAS: CODIGO '+responses.codigo;
                }
                When '003'{
                    mensajeErr = 'CAMPOS OBLIGATORIOS VACIOS: CODIGO '+responses.codigo;
                }
                When '004'{
                    mensajeErr = 'IP NO AUTORIZADA PARA CONSUMO: CODIGO '+responses.codigo;
                }
                When '005'{
                    mensajeErr = 'TOKEN INVALIDO: CODIGO '+responses.codigo;
                }
                When '707'{
                    mensajeErr = 'SIN RESPUESTA DE LA CONTRATACIÓN: CODIGO '+responses.codigo;
                }
                When '706'{
                    mensajeErr = 'DATOS DE ENTRADA AL SERVICIO SON VACÍOS: CODIGO '+responses.codigo;
                }
                When '713'{
                    mensajeErr = 'PRODUCTO NO VÁLIDO: CODIGO '+responses.codigo;
                }
                When '700'{
                    mensajeErr = 'ERROR GENÉRICO DEL APLICATIVO: CODIGO '+responses.codigo;
                }
                when else{
                    mensajeErr = 'TRANSACCION NO EXITOSA: CODIGO '+responses.codigo;
                }
            }
            respuesta.mensajeError = mensajeErr;
            dtmContratacionNmp.guardaErrores(jsonRequest, respuesta,idQuote);
            cotizacion.dtmMensajeError__c = mensajeErr;
            update cotizacion;
        }
        return respuesta;
    }
    
    public static void guardaErrores(String jsonEntrada,dtmContratacionNmp.dtmContratacionNmpResponse respuesta,Id idQuote){
        String mensajeError = 'codigoError: '+respuesta.codigo+' mensajeError: '+respuesta.mensajeError;
        Integer codigoEstatus = respuesta.StatusCode;
        vlocity_cmt__VlocityErrorLogEntry__c errorNew = new vlocity_cmt__VlocityErrorLogEntry__c();
        errorNew.vlocity_cmt__Action__c = 'POST';
        errorNew.vlocity_cmt__ErrorCode__c = String.valueOf(codigoEstatus);
        errorNew.vlocity_cmt__ErrorMessage__c = respuesta.mensajeError;
        errorNew.vlocity_cmt__ErrorTime__c = Datetime.Now();
        errorNew.vlocity_cmt__ErrorType__c = 'Callout Error: '+respuesta.codigo;
        errorNew.vlocity_cmt__InputData__c = jsonEntrada;
        errorNew.Name = 'Contratacion NMP';
        errorNew.vlocity_cmt__ObjectName__c = 'Quote';
        errorNew.vlocity_cmt__SourceType__c = 'Omniscript';
        errorNew.dtmCotizacion__c = idQuote;
        Insert errorNew;
        System.debug('Id de registro: '+errorNew.Id); 
    }
}