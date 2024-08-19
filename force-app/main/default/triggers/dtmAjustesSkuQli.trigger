trigger dtmAjustesSkuQli on QuoteLineItem (after insert, after update) {

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
                quoteLineItemIdToUpdate.add(qli.Id);
            }
        }
    }

    if (quoteLineItemIdToUpdate.isEmpty()) {
        System.debug('No hay registros para actualizar.');
        return;
    }

        List<QuoteLineItem> lineItems = [
        SELECT Id, Product2.Name,Product2.ProductCode,Product2.vlocity_cmt__SpecificationType__c, vlocity_cmt__AttributeSelectedValues__c, 
               Product2.dtmSistemaContratacionActual__c, dtmSKUContratacion__c, dtmSKURenta__c, 
               QuoteId, Product2.StockKeepingUnit, Product2.dtmProductSkuContratacion__c,Quote.dtmAttributeLineItem__c 
        FROM QuoteLineItem 
        WHERE Id IN :quoteLineItemIdToUpdate];

        String quoteIds= '';  
        for(QuoteLineItem items1 : lineItems){
                quoteIds = items1.QuoteId;
        }

        List<QuoteLineItem> produPadre =[SELECT id,Product2.ProductCode,Quote.dtmAttributeLineItem__c,Product2.vlocity_cmt__SpecificationType__c FROM QuoteLineItem WHERE QuoteId=:quoteIds];
        
    String plazoSeleccionado= '';
    String productCodePadre = '';  
    for(QuoteLineItem items2 : produPadre){
        if(items2.Product2.vlocity_cmt__SpecificationType__c == 'Offer'){
            plazoSeleccionado = items2.Quote.dtmAttributeLineItem__c;
            productCodePadre = items2.Product2.ProductCode;
        }
    }

    List<QuoteLineItem> lineItemsToUpdate = new List<QuoteLineItem>();

    for (QuoteLineItem item : lineItems) {
        if (item.Product2.vlocity_cmt__SpecificationType__c != 'Offer') {
            String skuContracionNuevo = '';
            String skuRentaNuevo = '';

            if (item.Product2.dtmSistemaContratacionActual__c == 'GIS') {
                switch on item.Product2.ProductCode {
                    when 'CONECTIVIDAD_ICREAIII' {
                        Map<String, Object> parsedValue = (Map<String, Object>) JSON.deserializeUntyped(item.vlocity_cmt__AttributeSelectedValues__c);
                        String attCendatTipo = (String) parsedValue.get('ATT_CDATOS_TIPO_CONECTIVIDAD_ICREAIII');
                        if (attCendatTipo != null) {
                            String[] partes = attCendatTipo.split(' ');
                            String velocidadIcreaV = partes[partes.size() - 1];
                            if(velocidadIcreaV!='1000'){
                                skuRentaNuevo = item.Product2.StockKeepingUnit + velocidadIcreaV+'M-R';
                            }else{
                                skuRentaNuevo = item.Product2.StockKeepingUnit +'1G-R';
                            }  
                        }
                    }
                    when 'CONECTIVIDAD_ICREAV' {
                        Map<String, Object> parsedValue = (Map<String, Object>) JSON.deserializeUntyped(item.vlocity_cmt__AttributeSelectedValues__c);
                        String attCdatosTipoConectividad = (String) parsedValue.get('ATT_CENDAT_TIPO');
                        if (attCdatosTipoConectividad != null) {
                            String[] partes = attCdatosTipoConectividad.split(' ');
                            String velocidadIcrea3 = partes[partes.size() - 1];
                            if(velocidadIcrea3!='1000'){
                                skuRentaNuevo = item.Product2.StockKeepingUnit + velocidadIcrea3+'M-R';
                            }else{
                                skuRentaNuevo = item.Product2.StockKeepingUnit +'1G-R';
                            }
                        }
                    }
                    when 'LIC_ANALITICOS', 'LIC_ANALITICOS_MERCADOTECNIA', 'LIC_ANALITICOS_LOCALIZACION' {
                        String[] partes = plazoSeleccionado.split(' ');
                        String plazofinal = String.valueOf(partes[0]);
                        if (plazofinal != null) {
                            skuContracionNuevo = item.Product2.dtmProductSkuContratacion__c + plazofinal + 'M';
                            skuRentaNuevo = item.Product2.StockKeepingUnit + plazofinal + 'M';
                        }
                    }
                    when 'APH5760CP', 'APH5761CP', 'APH5761R11CP', 'APH6760R51ECP' {
                        String[] partes = plazoSeleccionado.split(' ');
                        String plazofinal = String.valueOf(partes[0]);
                        if (plazofinal != null) {
                            skuContracionNuevo = item.Product2.dtmProductSkuContratacion__c + plazofinal;
                            skuRentaNuevo = item.Product2.StockKeepingUnit + plazofinal;
                        }
                    }
                    when 'CCAruba9004', 'CCAruba7010', 'APAruba303HCS', 'APAruba505S' {
                        String[] partes = plazoSeleccionado.split(' ');
                        String plazofinal = String.valueOf(partes[0]);
                        if (plazofinal != null) {
                            skuContracionNuevo = item.Product2.dtmProductSkuContratacion__c + plazofinal;
                            skuRentaNuevo = item.Product2.StockKeepingUnit + plazofinal;
                        }
                    }
                    when 'SDWANX67 Meraki', 'SDWANX68 Meraki', 'SDWANX95 Meraki' {
                        String[] partes = plazoSeleccionado.split(' ');
                        String plazofinal = String.valueOf(partes[0]);
                        if (plazofinal != null) {
                            skuContracionNuevo = item.Product2.dtmProductSkuContratacion__c + plazofinal;
                            skuRentaNuevo = item.Product2.StockKeepingUnit + plazofinal;
                        }
                    }
                    when else {
                        skuContracionNuevo = item.Product2.dtmProductSkuContratacion__c;
                        skuRentaNuevo = item.Product2.StockKeepingUnit;
                    }
                }
            } else if (item.Product2.dtmSistemaContratacionActual__c == 'ODIN') {
                System.debug('Entrando en ODIN para: ' + item.Product2.Name);

                switch on item.Product2.ProductCode {
                    when 'PR_GESTION_OS' {
                        Map<String, Object> parsedValue = (Map<String, Object>) JSON.deserializeUntyped(item.vlocity_cmt__AttributeSelectedValues__c);
                        String sistemaOperativo = (String) parsedValue.get('ATT_SERVSEG_TIPOSO');
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
                    when 'DOMINIO'{
                        if(productCodePadre=='CORREO_NEGOCIO'){
                            skuRentaNuevo = 'TRHPL';
                        }else{
                            skuRentaNuevo = 'TRT1P';
                        }   
                    }
                    when 'ADM TIMBRES','Timbres Nomina'{
                        skuContracionNuevo = item.Product2.dtmProductSkuContratacion__c;
                    }
                    when 'NOI ASISTENTE'{
                        skuRentaNuevo = item.Product2.dtmProductSkuContratacion__c;
                    }
                    when 'Premium','SERVSEG-PLATA','CO-SERVSEG-ORO','CO-SERVSEG-PLATINO','TR036'{
                        skuContracionNuevo = item.Product2.dtmProductSkuContratacion__c;
                        skuRentaNuevo = item.Product2.StockKeepingUnit;
                    }
                    when else {
                        skuRentaNuevo = item.Product2.dtmProductSkuContratacion__c;
                    }
                }
            }

            item.dtmSKUContratacion__c = skuContracionNuevo;
            item.dtmSKURenta__c = skuRentaNuevo;
            lineItemsToUpdate.add(item);
        }
    }
    if (!lineItemsToUpdate.isEmpty()) {
        update lineItemsToUpdate;
    }
}