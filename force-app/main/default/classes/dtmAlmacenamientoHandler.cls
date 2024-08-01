public class dtmAlmacenamientoHandler {
    public static void handleAfterUpdate(List<QuoteLineItem> newQuoteLineItems) {
        List<QuoteLineItem> qliToUpdate = new List<QuoteLineItem>();
        List<QuoteLineItem> qliToInsert = new List<QuoteLineItem>();
        for (QuoteLineItem qli : newQuoteLineItems) {
            QuoteLineItem oldQli = (QuoteLineItem) Trigger.oldMap.get(qli.Id);
            if (qli.vlocity_cmt__AttributeSelectedValues__c != oldQli.vlocity_cmt__AttributeSelectedValues__c) {
                creaPartidas(qli, qliToUpdate,qliToInsert);
            }
        }
        
        if (!qliToUpdate.isEmpty()) {
            update qliToUpdate;
        }
        
        if (!qliToInsert.isEmpty()) {
            insert qliToInsert;
        }
    }
    
    private static void creaPartidas(QuoteLineItem qli, List<QuoteLineItem> qliToUpdate,List<QuoteLineItem> qliToInsert) {
        Map<String, Object> datos = obtenerCapacidad(qli);
        Integer valorGb = (Integer) datos.get('capacidad');
        String descripcion = (String) datos.get('descripcion');
        switch on descripcion{
            when 'Transferencia (GB)' {
                if (valorGb != null) {
                    Integer valorGB2=valorGB-5;
                    if (valorGB2 <= 10235) {
                        actualizar5A10TB(qli, qliToUpdate, valorGB2);
                    } else {
                        actualizar5A10TB(qli, qliToUpdate, 10235);
                        valorGB2 -= 10235;
                        if (valorGB2 > 40960) {
                            crea40TB(qli, qliToInsert, 40960);
                            valorGB2 -= 40960;
                            if (valorGB2 > 102400) {
                                crea100TB(qli, qliToInsert, 102400);
                                valorGB2 -= 102400;
                                crea350TB(qli, qliToInsert, valorGB2);
                            } else {
                                crea100TB(qli, qliToInsert, valorGB2);
                            }
                        } else {
                            crea40TB(qli, qliToInsert, valorGB2);
                        }
                    }
                }
            }
            
            when 'Almacenamiento (GB)'{
                if (valorGb != null) {
                    if (valorGb <= 51200) {
                        System.debug('creo con menor');
                        actualizar50TB(qli, qliToUpdate, valorGb);
                    } else {
                        System.debug('Actualizo');
                        actualizar50TB(qli, qliToUpdate, 51200);
                        valorGb -= 51200;
                        if (valorGb > 460800) {
                            System.debug('Entro en siguientes 500');
                            creaSiguientes450(qli, qliToInsert, 460800);
                            valorGb -= 460800;
                            creaArriba500(qli, qliToInsert, valorGb);
                        } else {
                            System.debug('Entro en siguientes 450');
                            creaSiguientes450(qli, qliToInsert, valorGb);
                        }
                    }
                }
            }
        }
        
    }
    
    private static Map<String, Object> obtenerCapacidad(QuoteLineItem qli) {
        Integer capacidad = null;
        if (qli.vlocity_cmt__AttributeSelectedValues__c != null) {
            Map<String, Object> parsedValue = (Map<String, Object>) JSON.deserializeUntyped(qli.vlocity_cmt__AttributeSelectedValues__c);
            capacidad = (Integer) parsedValue.get('ATT_ALMACENAMIENTO_NUBE_CAPACIDAD');
        }
        Map<String, Object> resultado = new Map<String, Object>();
        resultado.put('capacidad', capacidad);
        resultado.put('descripcion', qli.Description);
        return resultado;
    }
    
    private static void actualizar50TB(QuoteLineItem qli, List<QuoteLineItem> qliToUpdate,Integer Quantity) {
        List<QuoteLineItem> primeros50 = [SELECT Id,Product2Id,Quantity FROM QuoteLineItem WHERE QuoteId = :qli.QuoteId AND Product2.vlocity_cmt__SpecificationType__c = 'Product' AND Product2.ProductCode='AlMACENAMIENTOGB_50TB' LIMIT 1];
        System.debug('Entro a actualizar 50'+primeros50);
        if (!primeros50.isEmpty()) {
            primeros50[0].Quantity = Quantity;
            qliToUpdate.add(primeros50[0]);
        }
    }
    private static void actualizar5A10TB(QuoteLineItem qli, List<QuoteLineItem> qliToUpdate,Integer Quantity) {
        List<QuoteLineItem> p5A10TB = [SELECT Id,Product2Id,Quantity FROM QuoteLineItem WHERE QuoteId = :qli.QuoteId AND Product2.vlocity_cmt__SpecificationType__c = 'Product' AND Product2.ProductCode='TRANSFERENCIAS_5GB_10TB' LIMIT 1];
        if (!p5A10TB.isEmpty()) {
            p5A10TB[0].Quantity = Quantity;
            qliToUpdate.add(p5A10TB[0]);
        }
    }
    
    private static void creaArriba500(QuoteLineItem qli, List<QuoteLineItem> qliToInsert,Integer Quantity) {
        List<QuoteLineItem> productoPadre = [SELECT Id,Product2Id,vlocity_cmt__BillingAccountId__c,vlocity_cmt__RootItemId__c FROM QuoteLineItem WHERE QuoteId = :qli.QuoteId AND Product2.vlocity_cmt__SpecificationType__c = 'Offer' LIMIT 1];
        List<QuoteLineItem> productoAgrupador = [SELECT Id,Product2Id FROM QuoteLineItem WHERE QuoteId = :qli.QuoteId AND Product2.vlocity_cmt__SpecificationType__c = 'Product' AND Product2.ProductCode='AlMACENAMIENTOGB' LIMIT 1];
        QuoteLineItem parentId = [SELECT Id,Product2Id,vlocity_cmt__ParentItemId__c FROM QuoteLineItem WHERE QuoteId = :qli.QuoteId AND Product2.vlocity_cmt__SpecificationType__c = 'Product' AND Product2.ProductCode='AlMACENAMIENTOGB_50TB' LIMIT 1];
        List<Product2> arriba500 = [SELECT Id FROM Product2 WHERE Name='Arriba de 500TB/mes' LIMIT 1];
        List<Pricebook2> precioLista = [SELECT Id,Name FROM Pricebook2 WHERE Name= 'Standard Price Book' and IsActive=true LIMIT 1];
        List<PricebookEntry> precioEntradaArriba500 = [SELECT Id FROM PricebookEntry WHERE Product2Id =:arriba500 AND Pricebook2Id=:precioLista];
        
        if (!productoPadre.isEmpty() && !productoAgrupador.isEmpty() && !arriba500.isEmpty() && !precioLista.isEmpty() && !precioEntradaArriba500.isEmpty() && parentId != null) {
            System.debug('Entro a crear');
            String productHierarchyPath2 = productoPadre[0].Product2Id + '<' +productoAgrupador[0].Product2Id+ '<' +arriba500[0].Id;
            QuoteLineItem newQuoteLineItem2 = new QuoteLineItem();
            newQuoteLineItem2.QuoteId = qli.QuoteId;
            newQuoteLineItem2.vlocity_cmt__BillingAccountId__c=productoPadre[0].vlocity_cmt__BillingAccountId__c;
            newQuoteLineItem2.vlocity_cmt__ServiceAccountId__c=productoPadre[0].vlocity_cmt__BillingAccountId__c;
            newQuoteLineItem2.Product2Id = arriba500[0].Id;
            newQuoteLineItem2.vlocity_cmt__Product2Id__c = arriba500[0].Id;
            newQuoteLineItem2.Quantity = Quantity;
            newQuoteLineItem2.vlocity_cmt__UsageQuantity__c =1;
            newQuoteLineItem2.UnitPrice = qli.UnitPrice;
            newQuoteLineItem2.vlocity_cmt__EffectiveQuantity__c = Quantity;
            newQuoteLineItem2.vlocity_cmt__LineNumber__c = '0001.0001.0003';
            newQuoteLineItem2.vlocity_cmt__Action__c='Add';
            newQuoteLineItem2.vlocity_cmt__ProvisioningStatus__c = 'New';
            newQuoteLineItem2.vlocity_cmt__CurrencyPaymentMode__c ='Currency';
            newQuoteLineItem2.vlocity_cmt__SequenceNumber__c =30;
            newQuoteLineItem2.vlocity_cmt__RootItemId__c = productoPadre[0].vlocity_cmt__RootItemId__c;
            newQuoteLineItem2.vlocity_cmt__ProductHierarchyPath__c =productHierarchyPath2;
            newQuoteLineItem2.vlocity_cmt__ParentItemId__c=parentId.vlocity_cmt__ParentItemId__c;
            newQuoteLineItem2.PricebookEntryId = precioEntradaArriba500[0].Id;
            System.debug('newQuoteLineItem2 '+newQuoteLineItem2);
            qliToInsert.add(newQuoteLineItem2);
        }else{
            System.debug('productoPadre.isEmpty(): ' + productoPadre.isEmpty());
            System.debug('productoAgrupador.isEmpty(): ' + productoAgrupador.isEmpty());
            System.debug('arriba500.isEmpty(): ' + arriba500.isEmpty());
            System.debug('precioLista.isEmpty(): ' + precioLista.isEmpty());
            System.debug('precioEntradaArriba500.isEmpty(): ' + precioEntradaArriba500.isEmpty());
            System.debug('parentId: ' + parentId);
        }
    }
    
    private static void creaSiguientes450(QuoteLineItem qli, List<QuoteLineItem> qliToInsert,Integer Quantity) {
        List<QuoteLineItem> productoPadre = [SELECT Id,Product2Id,vlocity_cmt__BillingAccountId__c,vlocity_cmt__RootItemId__c FROM QuoteLineItem WHERE QuoteId = :qli.QuoteId AND Product2.vlocity_cmt__SpecificationType__c = 'Offer' LIMIT 1];
        System.debug('productoPadre '+productoPadre);
        List<QuoteLineItem> productoAgrupador = [SELECT Id,Product2Id FROM QuoteLineItem WHERE QuoteId = :qli.QuoteId AND Product2.vlocity_cmt__SpecificationType__c = 'Product' AND Product2.ProductCode='AlMACENAMIENTOGB' LIMIT 1];
        System.debug('productoAgrupador '+productoAgrupador);
        QuoteLineItem parentId = [SELECT Id,Product2Id,vlocity_cmt__ParentItemId__c FROM QuoteLineItem WHERE QuoteId = :qli.QuoteId AND Product2.vlocity_cmt__SpecificationType__c = 'Product' AND Product2.ProductCode='AlMACENAMIENTOGB_50TB' LIMIT 1];
        List<Product2> siguientes450 = [SELECT Id FROM Product2 WHERE Name='Siguientes 450TB/mes' LIMIT 1];
        List<Pricebook2> precioLista = [SELECT Id,Name FROM Pricebook2 WHERE Name= 'Standard Price Book' and IsActive=true LIMIT 1];
        List<PricebookEntry> precioEntradaSiguientes450 = [SELECT Id FROM PricebookEntry WHERE Product2Id =:siguientes450 AND Pricebook2Id=:precioLista];
        
        
        if (!productoPadre.isEmpty() && !productoAgrupador.isEmpty() && !siguientes450.isEmpty() && !precioLista.isEmpty() && !precioEntradaSiguientes450.isEmpty() && parentId != null) {
            System.debug('Entro a crear');
            String productHierarchyPath1 = productoPadre[0].Product2Id + '<' +productoAgrupador[0].Product2Id+ '<' +siguientes450[0].Id;
            QuoteLineItem newQuoteLineItem1 = new QuoteLineItem();
            newQuoteLineItem1.QuoteId = qli.QuoteId;
            newQuoteLineItem1.vlocity_cmt__BillingAccountId__c=productoPadre[0].vlocity_cmt__BillingAccountId__c;
            newQuoteLineItem1.vlocity_cmt__ServiceAccountId__c=productoPadre[0].vlocity_cmt__BillingAccountId__c;
            newQuoteLineItem1.Product2Id = siguientes450[0].Id;
            newQuoteLineItem1.vlocity_cmt__Product2Id__c = siguientes450[0].Id;
            newQuoteLineItem1.Quantity = Quantity;
            newQuoteLineItem1.vlocity_cmt__UsageQuantity__c =1;
            newQuoteLineItem1.UnitPrice = qli.UnitPrice;
            newQuoteLineItem1.vlocity_cmt__EffectiveQuantity__c = Quantity;
            newQuoteLineItem1.vlocity_cmt__LineNumber__c = '0001.0001.0002';
            newQuoteLineItem1.vlocity_cmt__Action__c='Add';
            newQuoteLineItem1.vlocity_cmt__ProvisioningStatus__c = 'New';
            newQuoteLineItem1.vlocity_cmt__CurrencyPaymentMode__c ='Currency';
            newQuoteLineItem1.vlocity_cmt__SequenceNumber__c =20;
            newQuoteLineItem1.vlocity_cmt__RootItemId__c = productoPadre[0].vlocity_cmt__RootItemId__c;
            newQuoteLineItem1.vlocity_cmt__ProductHierarchyPath__c = productHierarchyPath1;
            newQuoteLineItem1.vlocity_cmt__ParentItemId__c=parentId.vlocity_cmt__ParentItemId__c;
            newQuoteLineItem1.PricebookEntryId = precioEntradaSiguientes450[0].Id;
            System.debug('newQuoteLineItem1 '+newQuoteLineItem1);
            qliToInsert.add(newQuoteLineItem1);
        }else{
            System.debug('productoPadre.isEmpty(): ' + productoPadre.isEmpty());
            System.debug('productoAgrupador.isEmpty(): ' + productoAgrupador.isEmpty());
            System.debug('siguientes450.isEmpty(): ' + siguientes450.isEmpty());
            System.debug('precioLista.isEmpty(): ' + precioLista.isEmpty());
            System.debug('precioEntradaSiguientes450.isEmpty(): ' + precioEntradaSiguientes450.isEmpty());
            System.debug('parentId: ' + parentId);
        }
    }
    
    private static void crea40TB(QuoteLineItem qli, List<QuoteLineItem> qliToInsert,Integer Quantity) {
        List<QuoteLineItem> productoPadre = [SELECT Id,Product2Id,vlocity_cmt__BillingAccountId__c,vlocity_cmt__RootItemId__c FROM QuoteLineItem WHERE QuoteId = :qli.QuoteId AND Product2.vlocity_cmt__SpecificationType__c = 'Offer' LIMIT 1];
        List<QuoteLineItem> productoAgrupador = [SELECT Id,Product2Id FROM QuoteLineItem WHERE QuoteId = :qli.QuoteId AND Product2.vlocity_cmt__SpecificationType__c = 'Product' AND Product2.ProductCode='AlMACENAMIENO_TRANSFERENCIA' LIMIT 1];
        QuoteLineItem parentId = [SELECT Id,Product2Id,vlocity_cmt__ParentItemId__c FROM QuoteLineItem WHERE QuoteId = :qli.QuoteId AND Product2.vlocity_cmt__SpecificationType__c = 'Product' AND Product2.ProductCode='TRANSFERENCIAS_5GB_10TB' LIMIT 1];
        List<Product2> q40TB = [SELECT Id FROM Product2 WHERE Name='Transferencias 40TB' LIMIT 1];
        List<Pricebook2> precioLista = [SELECT Id,Name FROM Pricebook2 WHERE Name= 'Standard Price Book' and IsActive=true LIMIT 1];
        List<PricebookEntry> precioEntradaq40TB = [SELECT Id FROM PricebookEntry WHERE Product2Id =:q40TB AND Pricebook2Id=:precioLista];
        
        String productHierarchyPath2 = productoPadre[0].Product2Id + '<' +productoAgrupador[0].Product2Id+ '<' +q40TB[0].Id;
        QuoteLineItem newQuoteLineItem2 = new QuoteLineItem();
        newQuoteLineItem2.QuoteId = qli.QuoteId;
        newQuoteLineItem2.vlocity_cmt__BillingAccountId__c=productoPadre[0].vlocity_cmt__BillingAccountId__c;
        newQuoteLineItem2.vlocity_cmt__ServiceAccountId__c=productoPadre[0].vlocity_cmt__BillingAccountId__c;
        newQuoteLineItem2.Product2Id = q40TB[0].Id;
        newQuoteLineItem2.vlocity_cmt__Product2Id__c = q40TB[0].Id;
        newQuoteLineItem2.Quantity = Quantity;
        newQuoteLineItem2.vlocity_cmt__UsageQuantity__c =1;
        newQuoteLineItem2.UnitPrice = qli.UnitPrice;
        newQuoteLineItem2.vlocity_cmt__EffectiveQuantity__c = Quantity;
        newQuoteLineItem2.vlocity_cmt__LineNumber__c = '0001.0001.0004';
        newQuoteLineItem2.vlocity_cmt__Action__c='Add';
        newQuoteLineItem2.vlocity_cmt__ProvisioningStatus__c = 'New';
        newQuoteLineItem2.vlocity_cmt__CurrencyPaymentMode__c ='Currency';
        newQuoteLineItem2.vlocity_cmt__SequenceNumber__c =40;
        newQuoteLineItem2.vlocity_cmt__RootItemId__c = productoPadre[0].vlocity_cmt__RootItemId__c;
        newQuoteLineItem2.vlocity_cmt__ProductHierarchyPath__c =productHierarchyPath2;
        newQuoteLineItem2.vlocity_cmt__ParentItemId__c=parentId.vlocity_cmt__ParentItemId__c;
        newQuoteLineItem2.PricebookEntryId = precioEntradaq40TB[0].Id;

        qliToInsert.add(newQuoteLineItem2);
    }
    
    private static void crea100TB(QuoteLineItem qli, List<QuoteLineItem> qliToInsert,Integer Quantity) {
        List<QuoteLineItem> productoPadre = [SELECT Id,Product2Id,vlocity_cmt__BillingAccountId__c,vlocity_cmt__RootItemId__c FROM QuoteLineItem WHERE QuoteId = :qli.QuoteId AND Product2.vlocity_cmt__SpecificationType__c = 'Offer' LIMIT 1];
        List<QuoteLineItem> productoAgrupador = [SELECT Id,Product2Id FROM QuoteLineItem WHERE QuoteId = :qli.QuoteId AND Product2.vlocity_cmt__SpecificationType__c = 'Product' AND Product2.ProductCode='AlMACENAMIENO_TRANSFERENCIA' LIMIT 1];
        QuoteLineItem parentId = [SELECT Id,Product2Id,vlocity_cmt__ParentItemId__c FROM QuoteLineItem WHERE QuoteId = :qli.QuoteId AND Product2.vlocity_cmt__SpecificationType__c = 'Product' AND Product2.ProductCode='TRANSFERENCIAS_5GB_10TB' LIMIT 1];
        List<Product2> q100TB = [SELECT Id FROM Product2 WHERE Name='Transferencias 100TB' LIMIT 1];
        List<Pricebook2> precioLista = [SELECT Id,Name FROM Pricebook2 WHERE Name= 'Standard Price Book' and IsActive=true LIMIT 1];
        List<PricebookEntry> precioEntradaq100TB = [SELECT Id FROM PricebookEntry WHERE Product2Id =:q100TB AND Pricebook2Id=:precioLista];
        
        String productHierarchyPath1 = productoPadre[0].Product2Id + '<' +productoAgrupador[0].Product2Id+ '<' +q100TB[0].Id;
        QuoteLineItem newQuoteLineItem1 = new QuoteLineItem();
        newQuoteLineItem1.QuoteId = qli.QuoteId;
        newQuoteLineItem1.vlocity_cmt__BillingAccountId__c=productoPadre[0].vlocity_cmt__BillingAccountId__c;
        newQuoteLineItem1.vlocity_cmt__ServiceAccountId__c=productoPadre[0].vlocity_cmt__BillingAccountId__c;
        newQuoteLineItem1.Product2Id = q100TB[0].Id;
        newQuoteLineItem1.vlocity_cmt__Product2Id__c = q100TB[0].Id;
        newQuoteLineItem1.Quantity = Quantity;
        newQuoteLineItem1.vlocity_cmt__UsageQuantity__c =1;
        newQuoteLineItem1.UnitPrice = qli.UnitPrice;
        newQuoteLineItem1.vlocity_cmt__EffectiveQuantity__c = Quantity;
        newQuoteLineItem1.vlocity_cmt__LineNumber__c = '0001.0001.0005';
        newQuoteLineItem1.vlocity_cmt__Action__c='Add';
        newQuoteLineItem1.vlocity_cmt__ProvisioningStatus__c = 'New';
        newQuoteLineItem1.vlocity_cmt__CurrencyPaymentMode__c ='Currency';
        newQuoteLineItem1.vlocity_cmt__SequenceNumber__c =50;
        newQuoteLineItem1.vlocity_cmt__RootItemId__c = productoPadre[0].vlocity_cmt__RootItemId__c;
        newQuoteLineItem1.vlocity_cmt__ProductHierarchyPath__c = productHierarchyPath1;
        newQuoteLineItem1.vlocity_cmt__ParentItemId__c=parentId.vlocity_cmt__ParentItemId__c;
        newQuoteLineItem1.PricebookEntryId = precioEntradaq100TB[0].Id;
        
        qliToInsert.add(newQuoteLineItem1);
    }
    
    private static void crea350TB(QuoteLineItem qli, List<QuoteLineItem> qliToInsert,Integer Quantity) {
        List<QuoteLineItem> productoPadre = [SELECT Id,Product2Id,vlocity_cmt__BillingAccountId__c,vlocity_cmt__RootItemId__c FROM QuoteLineItem WHERE QuoteId = :qli.QuoteId AND Product2.vlocity_cmt__SpecificationType__c = 'Offer' LIMIT 1];
        List<QuoteLineItem> productoAgrupador = [SELECT Id,Product2Id FROM QuoteLineItem WHERE QuoteId = :qli.QuoteId AND Product2.vlocity_cmt__SpecificationType__c = 'Product' AND Product2.ProductCode='AlMACENAMIENO_TRANSFERENCIA' LIMIT 1];
        QuoteLineItem parentId = [SELECT Id,Product2Id,vlocity_cmt__ParentItemId__c FROM QuoteLineItem WHERE QuoteId = :qli.QuoteId AND Product2.vlocity_cmt__SpecificationType__c = 'Product' AND Product2.ProductCode='TRANSFERENCIAS_5GB_10TB' LIMIT 1];
        List<Product2> q350TB = [SELECT Id FROM Product2 WHERE Name='Transferencias 350TB' LIMIT 1];
        List<Pricebook2> precioLista = [SELECT Id,Name FROM Pricebook2 WHERE Name= 'Standard Price Book' and IsActive=true LIMIT 1];
        List<PricebookEntry> precioEntradaq350TB = [SELECT Id FROM PricebookEntry WHERE Product2Id =:q350TB AND Pricebook2Id=:precioLista];
        
        String productHierarchyPath3 = productoPadre[0].Product2Id + '<' +productoAgrupador[0].Product2Id+ '<' +q350TB[0].Id;
        QuoteLineItem newQuoteLineItem1 = new QuoteLineItem();
        newQuoteLineItem1.QuoteId = qli.QuoteId;
        newQuoteLineItem1.vlocity_cmt__BillingAccountId__c=productoPadre[0].vlocity_cmt__BillingAccountId__c;
        newQuoteLineItem1.vlocity_cmt__ServiceAccountId__c=productoPadre[0].vlocity_cmt__BillingAccountId__c;
        newQuoteLineItem1.Product2Id = q350TB[0].Id;
        newQuoteLineItem1.vlocity_cmt__Product2Id__c = q350TB[0].Id;
        newQuoteLineItem1.Quantity = Quantity;
        newQuoteLineItem1.vlocity_cmt__UsageQuantity__c =1;
        newQuoteLineItem1.UnitPrice = qli.UnitPrice;
        newQuoteLineItem1.vlocity_cmt__EffectiveQuantity__c = Quantity;
        newQuoteLineItem1.vlocity_cmt__LineNumber__c = '0001.0001.0006';
        newQuoteLineItem1.vlocity_cmt__Action__c='Add';
        newQuoteLineItem1.vlocity_cmt__ProvisioningStatus__c = 'New';
        newQuoteLineItem1.vlocity_cmt__CurrencyPaymentMode__c ='Currency';
        newQuoteLineItem1.vlocity_cmt__SequenceNumber__c =60;
        newQuoteLineItem1.vlocity_cmt__RootItemId__c = productoPadre[0].vlocity_cmt__RootItemId__c;
        newQuoteLineItem1.vlocity_cmt__ProductHierarchyPath__c = productHierarchyPath3;
        newQuoteLineItem1.vlocity_cmt__ParentItemId__c=parentId.vlocity_cmt__ParentItemId__c;
        newQuoteLineItem1.PricebookEntryId = precioEntradaq350TB[0].Id;
        
        qliToInsert.add(newQuoteLineItem1);
    }
}