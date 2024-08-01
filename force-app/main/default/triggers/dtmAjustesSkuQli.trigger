trigger dtmAjustesSkuQli on QuoteLineItem (after insert, after update) {
    System.debug('Entrando en el trigger');

    Set<Id> quoteLineItemIdToUpdate = new Set<Id>();

    if (Trigger.isInsert) {
        for (QuoteLineItem newQuoteLineItem : Trigger.new) {
            System.debug('Procesando nueva inserción: ' + newQuoteLineItem.Id);
            quoteLineItemIdToUpdate.add(newQuoteLineItem.Id);
        }
    }

    if (Trigger.isUpdate) {
        for (QuoteLineItem qli : Trigger.new) {
            QuoteLineItem oldQli = Trigger.oldMap.get(qli.Id);
            if (qli.vlocity_cmt__AttributeSelectedValues__c != oldQli.vlocity_cmt__AttributeSelectedValues__c) {
                System.debug('Procesando actualización: ' + qli.Id);
                quoteLineItemIdToUpdate.add(qli.Id);
            }
        }
    }

    if (quoteLineItemIdToUpdate.isEmpty()) {
        System.debug('No hay registros para actualizar.');
        return;
    }

    List<QuoteLineItem> lineItems = [
        SELECT Id, Product2.Name, Product2.vlocity_cmt__SpecificationType__c, vlocity_cmt__AttributeSelectedValues__c, 
               Product2.dtmSistemaContratacionActual__c, dtmSKUContratacion__c, dtmSKURenta__c, 
               QuoteId, Product2.StockKeepingUnit, Product2.dtmProductSkuContratacion__c 
        FROM QuoteLineItem 
        WHERE Id IN :quoteLineItemIdToUpdate
    ];

    List<QuoteLineItem> lineItemsToUpdate = new List<QuoteLineItem>();

    for (QuoteLineItem item : lineItems) {
        System.debug('Procesando QuoteLineItem: ' + item.Id);

        if (item.Product2.vlocity_cmt__SpecificationType__c != 'Offer') {
            String skuContracionNuevo = '';
            String skuRentaNuevo = '';

            if (item.Product2.dtmSistemaContratacionActual__c == 'GIS') {
                System.debug('Entrando en GIS para: ' + item.Product2.Name);

                switch on item.Product2.Name {
                    when 'Conectividad ICREA V' {
                        Map<String, Object> parsedValue = (Map<String, Object>) JSON.deserializeUntyped(item.vlocity_cmt__AttributeSelectedValues__c);
                        String attCendatTipo = (String) parsedValue.get('ATT_CENDAT_TIPO');
                        System.debug('attCendatTipo: ' + attCendatTipo);
                        if (attCendatTipo != null) {
                            String[] partes = attCendatTipo.split(' ');
                            String velocidadIcreaV = partes[partes.size() - 1];
                            skuRentaNuevo = item.Product2.StockKeepingUnit + velocidadIcreaV;
                        }
                    }
                    when 'Conectividad ICREA III' {
                        Map<String, Object> parsedValue = (Map<String, Object>) JSON.deserializeUntyped(item.vlocity_cmt__AttributeSelectedValues__c);
                        String attCdatosTipoConectividad = (String) parsedValue.get('ATT_CDATOS_TIPO_CONECTIVIDAD_ICREAIII');
                        System.debug('attCdatosTipoConectividad: ' + attCdatosTipoConectividad);
                        if (attCdatosTipoConectividad != null) {
                            String[] partes = attCdatosTipoConectividad.split(' ');
                            String velocidadIcrea3 = partes[partes.size() - 1];
                            skuRentaNuevo = item.Product2.StockKeepingUnit + velocidadIcrea3;
                        }
                    }
                    when 'Co-Ubicación (Triara) ICREA III', 'Co-Ubicación (Triara) ICREA V' {
                        System.debug('Entrando a Co-ubicación');
                        Map<String, Object> parsedValue = (Map<String, Object>) JSON.deserializeUntyped(item.vlocity_cmt__AttributeSelectedValues__c);
                        String velocidadIcrea3 = (String) parsedValue.get('ATT_CENDAT_TIPORACK');
                        System.debug('velocidadIcrea3: ' + velocidadIcrea3);
                        if (velocidadIcrea3 != null) {
                            switch on velocidadIcrea3 {
                                when 'Rack 1/8 de 72\'' {
                                    skuRentaNuevo = item.Product2.StockKeepingUnit + '18RA-R';
                                }
                                when 'Rack 1/4 de 72\'' {
                                    skuRentaNuevo = item.Product2.StockKeepingUnit + '14RA-R';
                                }
                                when 'Rack 1/2 de 72\'' {
                                    skuRentaNuevo = item.Product2.StockKeepingUnit + '12RA-R';
                                }
                                when 'Rack 1 de 72\'' {
                                    skuRentaNuevo = item.Product2.StockKeepingUnit + '1RA-R';
                                }
                            }
                        }
                    }
                    when 'Licencia Analiticos', 'Licencia Analiticos y Mercadotecnia', 'Licencia Presencia y Localización' {
                        Map<String, Object> parsedValue = (Map<String, Object>) JSON.deserializeUntyped(item.vlocity_cmt__AttributeSelectedValues__c);
                        String plazo = (String) parsedValue.get('ATT_PLAZO');
                        System.debug('plazo: ' + plazo);
                        if (plazo != null) {
                            skuContracionNuevo = item.Product2.dtmProductSkuContratacion__c + plazo + 'M';
                            skuRentaNuevo = item.Product2.StockKeepingUnit + plazo + 'M';
                        }
                    }
                    when 'Access Point Huawei 5760', 'Access Point Huawei 5761', 'Access Point Huawei 5761R', 'Access Point Huawei 6760R' {
                        Map<String, Object> parsedValue = (Map<String, Object>) JSON.deserializeUntyped(item.vlocity_cmt__AttributeSelectedValues__c);
                        String plazo = (String) parsedValue.get('ATT_PLAZO');
                        System.debug('plazo: ' + plazo);
                        if (plazo != null) {
                            skuContracionNuevo = item.Product2.dtmProductSkuContratacion__c + plazo;
                            skuRentaNuevo = item.Product2.StockKeepingUnit + plazo;
                        }
                    }
                    when 'Controladora Central Aruba 9004', 'Controladora Central Aruba 7010', 'Access Point Aruba 303H Casa - Sucursal', 'Access Point Aruba 505 Sucursal' {
                        Map<String, Object> parsedValue = (Map<String, Object>) JSON.deserializeUntyped(item.vlocity_cmt__AttributeSelectedValues__c);
                        String plazo = (String) parsedValue.get('ATT_PLAZO');
                        System.debug('plazo: ' + plazo);
                        if (plazo != null) {
                            skuContracionNuevo = item.Product2.dtmProductSkuContratacion__c + plazo;
                            skuRentaNuevo = item.Product2.StockKeepingUnit + plazo;
                        }
                    }
                    when 'MX67 CON SEGURIDAD AVANZADA (Sucursal)', 'MX68 CON SEGURIDAD AVANZADA (Sucursal)', 'MX95 CON SEGURIDAD AVANZADA (Sucursal)' {
                        Map<String, Object> parsedValue = (Map<String, Object>) JSON.deserializeUntyped(item.vlocity_cmt__AttributeSelectedValues__c);
                        String plazo = (String) parsedValue.get('ATT_PLAZO');
                        System.debug('plazo: ' + plazo);
                        if (plazo != null) {
                            skuContracionNuevo = item.Product2.dtmProductSkuContratacion__c + plazo;
                            skuRentaNuevo = item.Product2.StockKeepingUnit + plazo;
                        }
                    }
                    when else {
                        skuContracionNuevo = item.Product2.dtmProductSkuContratacion__c;
                        skuRentaNuevo = item.Product2.StockKeepingUnit;
                    }
                }
            } else if (item.Product2.dtmSistemaContratacionActual__c == 'ODIN') {
                System.debug('Entrando en ODIN para: ' + item.Product2.Name);

                switch on item.Product2.Name {
                    when 'Gestión de sistema operativo' {
                        Map<String, Object> parsedValue = (Map<String, Object>) JSON.deserializeUntyped(item.vlocity_cmt__AttributeSelectedValues__c);
                        String sistemaOperativo = (String) parsedValue.get('ATT_SERVSEG_TIPOSO');
                        System.debug('sistemaOperativo: ' + sistemaOperativo);
                        if (sistemaOperativo != null) {
                            switch on sistemaOperativo{
                            when 'Windows'{
                                skuRentaNuevo = item.Product2.StockKeepingUnit+'WIN-R';
                            }
                            when 'Linux'{
                                skuRentaNuevo = item.Product2.StockKeepingUnit+'LNX-R';
                            }
                        }
                        }
                    }
                    when else {
                        skuContracionNuevo = item.Product2.dtmProductSkuContratacion__c;
                        skuRentaNuevo = item.Product2.StockKeepingUnit;
                    }
                }
            }

            item.dtmSKUContratacion__c = skuContracionNuevo;
            item.dtmSKURenta__c = skuRentaNuevo;
            lineItemsToUpdate.add(item);

            System.debug('Actualizando QuoteLineItem: ' + item.Id + ' con SKUContratacion: ' + skuContracionNuevo + ' y SKURenta: ' + skuRentaNuevo);
        }
    }

    if (!lineItemsToUpdate.isEmpty()) {
        System.debug('Registros a actualizar: ' + lineItemsToUpdate);
        update lineItemsToUpdate;
    }
}