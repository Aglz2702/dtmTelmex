@SuppressWarnings('PMD.AvoidGlobalModifier')
global class dtmContratacionGis {
    global class dtmContratacionGisResponse {
        global String userMenssage {get;set;}
        global String severety {get;set;}
        global List<String> errors {get;set;}
        global Integer statusCode {get;set;}
        global Integer id {get;set;}
        
        global Map<String, Object> toMap() {
            Map<String, Object> mapa = new Map<String, Object>();
            mapa.put('userMenssage', userMenssage);
            mapa.put('severety', severety);
            mapa.put('statusCode', statusCode);
            mapa.put('id', id);
            if (errors != null) {
                mapa.put('errors', errors);
            }
            return mapa;
        }
    }
    
    global static dtmContratacionGisResponse procesarSolicitud(String entradaDatos) {
        String idQuote = entradaDatos;
        String movimiento = 'ALTA';
        Integer direccionamiento = 1; //duro por ahora
        Integer plazoFijo36 = 36;
        
        Quote cotizacion = [SELECT Name, dtmFolioGis__c,dtmMensajeError__c,Account.dtmRFC__c, Account.dtmCuentaMaestra__c, Account.dtmCUCE__c, Opportunity.dtmIdentificadorOpp__c, Opportunity.dtmCUPID__r.Name FROM Quote WHERE Id=:idQuote];
        System.debug('Cotizacion: ' + cotizacion);
        List<QuoteLineItem> productos = [SELECT id, Product2.dtmLegacyName__c, Quantity, dtmNombresitio__c, vlocity_cmt__AttributeSelectedValues__c, vlocity_cmt__RecurringCharge__c, vlocity_cmt__OneTimeCharge__c, dtmCodigoISOMoneda__c, Product2.Id, Product2.Name, Product2.vlocity_cmt__SpecificationType__c, Product2.ProductCode, Product2.dtmEmpresaPrestaServicios__c, Product2.StockKeepingUnit, Product2.dtmProductSkuContratacion__c, Product2.dtmPlataforma__c FROM QuoteLineItem WHERE QuoteId=:idQuote];
        System.debug('productos: ' + productos);
        List<QuoteLineItem> productosHijos = [SELECT id,Product2.dtmLegacyName__c,vlocity_cmt__RecurringCharge__c, vlocity_cmt__OneTimeCharge__c, Quantity, dtmNombresitio__c, Product2.Id, Product2.vlocity_cmt__SpecificationType__c,Product2.vlocity_cmt__SpecificationSubType__c, Product2.ProductCode,Product2.Name, Product2.StockKeepingUnit, Product2.dtmProductSkuContratacion__c, Product2.dtmPlataforma__c FROM QuoteLineItem WHERE QuoteId=:idQuote AND Product2.vlocity_cmt__SpecificationType__c = 'Product'];
        System.debug('productosHijos: ' + productosHijos);
        
        String jsonRequest = '{';
        jsonRequest += '"idCotizacionSf":"' + cotizacion.Id + '",';
        jsonRequest += '"rfcClienteFinal":"' + cotizacion.Account.dtmRFC__c + '",';
        jsonRequest += '"oportunidad":"' + cotizacion.Opportunity.dtmIdentificadorOpp__c + '",';
        jsonRequest += '"cuce":"' + cotizacion.Account.dtmCUCE__c + '",';
        jsonRequest += '"cupId":' + Integer.valueOf(cotizacion.Opportunity.dtmCUPID__r.Name) + ',';
        jsonRequest += '"cuentaMaestra":"' + cotizacion.Account.dtmCuentaMaestra__c + '",';
        jsonRequest += '"productos": [';
        System.debug('jsonRequest '+jsonRequest);
        
        List<String> productosJsonList = new List<String>();
        
        for (Integer i = 0; i < productos.size(); i++) {
            QuoteLineItem item = productos[i];
            if (item.Product2.vlocity_cmt__SpecificationType__c == 'Offer') {
                String productoJson = '{';
                productoJson += '"productoId": "' + item.Product2.Id + '",';
                productoJson += '"empresa": "' + item.Product2.dtmEmpresaPrestaServicios__c + '",';
                productoJson += '"movimiento": "' + movimiento + '",';
                productoJson += '"plataforma": "' + item.Product2.dtmPlataforma__c + '",';
                productoJson += '"producto": "' + item.Product2.dtmLegacyName__c + '",';
                if (item.Product2.Name == 'Internet Directo Negocio') {
                    String[] sitioss = item.dtmNombresitio__c.split(' ');
                    Integer sitio = Integer.valueOf(sitioss[0]);
                    productoJson += '"sitio": ' + sitio + ',';
                }else{
                    productoJson += '"sitio": null,';
                }
                System.debug('productoJson: '+productoJson);
                switch on item.Product2.Name {
                    when 'Centro de Datos de Alta Disponibilidad','SD WAN Telmex'{
                        Map<String, Object> parsedValue = (Map<String, Object>) JSON.deserializeUntyped(item.vlocity_cmt__AttributeSelectedValues__c);
                        String valoresPlazo = (String) parsedValue.get('ATT_PLZ_12M_24M_36M');
                        String[] plazos = valoresPlazo.split(' ');
                        Integer plazo = Integer.valueOf(plazos[0]);
                        productoJson += '"plazo": ' + plazo + ',';
                    }
                    when 'Wifi Avanzado','Wifi Corporativo en sucursales / casa'{
                        Map<String, Object> parsedValue = (Map<String, Object>) JSON.deserializeUntyped(item.vlocity_cmt__AttributeSelectedValues__c);
                        String valoresPlazo = (String) parsedValue.get('ATT_INT_12M_24M_36M)');
                        String[] plazos = valoresPlazo.split(' ');
                        Integer plazo = Integer.valueOf(plazos[0]);
                        productoJson += '"plazo": ' + plazo + ',';
                    }
                    when 'Internet Directo Negocio'{
                        Map<String, Object> parsedValue = (Map<String, Object>) JSON.deserializeUntyped(item.vlocity_cmt__AttributeSelectedValues__c);
                        String valoresPlazo = (String) parsedValue.get('ATT_INT_12M_24M_36M)');
                        String[] plazos = valoresPlazo.split(' ');
                        Integer plazo = Integer.valueOf(plazos[0]);
                        productoJson += '"plazo": ' + plazo + ',';
                    }
                    when 'CUAD Negocio','CUAD TELMEX','Monitoreo Infinitum'{
                        productoJson += '"plazo": ' + plazoFijo36 + ',';
                    }
                    when 'Wifi Analítico'{
                        System.debug('Entro a wifi analitico');
                        Map<String, Object> parsedValue = (Map<String, Object>) JSON.deserializeUntyped(item.vlocity_cmt__AttributeSelectedValues__c);
                        String valoresPlazo = (String) parsedValue.get('ATT_WIFIANALITICO_PLAZO');
                        String[] plazos = valoresPlazo.split(' ');
                        System.debug('plazos: '+plazos);
                        Integer plazo = Integer.valueOf(plazos[0]);
                        System.debug('plazo: '+plazo);
                        productoJson += '"plazo": ' + plazo + ',';
                        System.debug('productoJson: '+productoJson);
                    }
                }
                productoJson += '"cantidad": ' + Integer.valueOf(item.Quantity) + ',';
                System.debug('productoJson: '+productoJson);
                if(item.dtmCodigoISOMoneda__c=='MXN'){
                    productoJson += '"tipoMoneda": "PES",';
                }else{
                    productoJson += '"tipoMoneda": "USD",';
                }
                productoJson += '"anchoBanda": ' + 0 + ','; //IDN
                
                if (item.Product2.Name == 'Internet Directo Negocio') {
                    productoJson += '"direccionamiento": ' + direccionamiento + ',';
                } else {
                    productoJson += '"direccionamiento": null,';
                }
                System.debug('productoJson: '+productoJson);
                productoJson += '"skus":[';
                List<String> skusJsonList = new List<String>();
                for (Integer j = 0; j < productosHijos.size(); j++) { 
                    QuoteLineItem item2 = productosHijos[j];
                    if(item2.Product2.vlocity_cmt__SpecificationSubType__c!='Bundle'){
                        String skuJson = '{';
                        if (item.Product2.Name == 'Internet Directo Negocio') {
                            skuJson += '"skuTipo":"' + item2.Product2.dtmLegacyName__c + '",';
                        } else {
                            skuJson += '"skuTipo":null,';
                        }
                        switch on item.Product2.Name{
                            when 'Wifi Avanzado','Wifi Corporativo en sucursales / casa'{
                                Map<String, Object> parsedValue = (Map<String, Object>) JSON.deserializeUntyped(item.vlocity_cmt__AttributeSelectedValues__c);
                                String valoresPlazo = (String) parsedValue.get('ATT_INT_12M_24M_36M)');
                                String[] plazos = valoresPlazo.split(' ');
                                Integer plazo = Integer.valueOf(plazos[0]);
                                skuJson += '"skuRenta":"' + item2.Product2.StockKeepingUnit + plazo+'",';
                                skuJson += '"skuContratacion":"' + item2.Product2.dtmProductSkuContratacion__c + plazo+'",';
                            }
                            when 'SD WAN Telmex'{
                                Map<String, Object> parsedValue = (Map<String, Object>) JSON.deserializeUntyped(item.vlocity_cmt__AttributeSelectedValues__c);
                                String valoresPlazo = (String) parsedValue.get('ATT_PLZ_12M_24M_36M');
                                String[] plazos = valoresPlazo.split(' ');
                                Integer plazo = Integer.valueOf(plazos[0]);
                                skuJson += '"skuRenta":"' + item2.Product2.StockKeepingUnit + plazo+'",';
                                skuJson += '"skuContratacion":"' + item2.Product2.dtmProductSkuContratacion__c + plazo +'",';
                            }
                            when 'Wifi Analítico'{
                                Map<String, Object> parsedValue = (Map<String, Object>) JSON.deserializeUntyped(item.vlocity_cmt__AttributeSelectedValues__c);
                                String valoresPlazo = (String) parsedValue.get('ATT_WIFIANALITICO_PLAZO');
                                String[] plazos = valoresPlazo.split(' ');
                                Integer plazo = Integer.valueOf(plazos[0]);
                                skuJson += '"skuRenta":"' + item2.Product2.StockKeepingUnit + plazo+'M'+'",';
                                skuJson += '"skuContratacion":"' + item2.Product2.dtmProductSkuContratacion__c + plazo+'M'+'",';
                            }
                            when else{
                                skuJson += '"skuRenta":"' + item2.Product2.StockKeepingUnit + '",';
                                skuJson += '"skuContratacion":"' + item2.Product2.dtmProductSkuContratacion__c + '",';
                            }
                        }
                        System.debug('skuJson '+skuJson);
                        Decimal redondearRenta = item2.vlocity_cmt__RecurringCharge__c;
                        Decimal redondearContratacion = item2.vlocity_cmt__OneTimeCharge__c;

                        Decimal redondeadoRenta = redondearRenta.setScale(2);
                        Decimal redondeadoContratacion = redondearContratacion.setScale(2);

                        skuJson += '"precioRenta":' + redondeadoRenta + ',';
                        skuJson += '"precioContratacion":' + redondeadoContratacion + ',';
                        if (item.Product2.Name == 'Internet Directo Negocio') {
                            skuJson += '"sitio": null,';
                        }else{
                            String[] sitioss2 = item2.dtmNombresitio__c.split(' ');
                            String sitio2 = sitioss2[0];
                            skuJson += '"sitio": ' + sitio2 + ',';
                        }
                        skuJson += '"cantidad":' + Integer.ValueOf(item2.Quantity);
                        skuJson += '}';
                        
                        skusJsonList.add(skuJson);
                    }
                }
                
                productoJson += String.join(skusJsonList, ',');
                productoJson += ']}';
                productosJsonList.add(productoJson);
            }
        }
        
        jsonRequest += String.join(productosJsonList, ',');
        jsonRequest += ']}';
        
        System.debug('El request a enviar es:' + jsonRequest);
        
        dtmContratacionGis.dtmContratacionGisResponse respuesta = new dtmContratacionGis.dtmContratacionGisResponse();
        dtmContratacionGis.dtmContratacionGisResponse responses = dtmContratacionGisController.integrarConEndpointExterno(jsonRequest);
        
        if (responses.statusCode==200) {
            respuesta.statusCode = responses.statusCode;
            respuesta.id = responses.id;
            cotizacion.dtmFolioGis__c = String.valueOf(responses.id);
            update cotizacion;
        } else{
            respuesta.statusCode = responses.statusCode;
            respuesta.userMenssage = responses.userMenssage;
            respuesta.severety = responses.severety;
            respuesta.errors = responses.errors;
            dtmContratacionGis.guardaErrores(jsonRequest, respuesta);
            cotizacion.dtmMensajeError__c = responses.userMenssage;
            update cotizacion;
        }
        System.debug('Se envia respuesta: '+respuesta);
        return respuesta;
    }
    public static void guardaErrores(String jsonEntrada,dtmContratacionGis.dtmContratacionGisResponse respuesta){
        Map<String, Object> valores = (Map<String, Object>) JSON.deserializeUntyped(jsonEntrada);
        String cotizacionId = (String) valores.get('idCotizacionSf');
        String mensajeError = 'codigoError: '+respuesta.severety +' Mensaje: '+respuesta.userMenssage+' Errores: '+respuesta.errors;
        Integer codigoEstatus = respuesta.StatusCode;
        vlocity_cmt__VlocityErrorLogEntry__c errorNew = new vlocity_cmt__VlocityErrorLogEntry__c();
        errorNew.vlocity_cmt__Action__c = 'POST';
        errorNew.vlocity_cmt__ErrorCode__c = String.valueOf(codigoEstatus);
        errorNew.vlocity_cmt__ErrorMessage__c = mensajeError;
        errorNew.vlocity_cmt__ErrorTime__c = Datetime.Now();
        errorNew.vlocity_cmt__ErrorType__c = 'Callout Error';
        errorNew.vlocity_cmt__InputData__c = jsonEntrada;
        errorNew.Name = 'Contratacion GIS';
        errorNew.vlocity_cmt__ObjectName__c = 'Quote';
        errorNew.vlocity_cmt__SourceType__c = 'Omniscript';
        errorNew.dtmCotizacion__c = cotizacionId;
        Insert errorNew;
        System.debug('Id de registro: '+errorNew.Id); 
    }
}