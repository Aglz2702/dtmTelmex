@isTest
public class dtmAlmacenamientoHandlerTest {

    @testSetup
    static void setupTestData() {
        // Crear los productos necesarios
        Product2 productPadre = new Product2(Name = 'Almacenamiento en la nube', ProductCode = 'TRBAN', dtmSistemaContratacionActual__c = 'ODIN', vlocity_cmt__SpecificationType__c = 'Offer', StockKeepingUnit = 'SKUICV');
        insert productPadre;

        Product2 productAgrupador = new Product2(Name = 'Almacenamiento en la nube GB', ProductCode = 'AlMACENAMIENTOGB', dtmSistemaContratacionActual__c = 'ODIN', vlocity_cmt__SpecificationType__c = 'Product', StockKeepingUnit = 'SKUICR');
        insert productAgrupador;

        Product2 productPrimeros = new Product2(Name = 'Primeros 50TB/mes', ProductCode = 'AlMACENAMIENTOGB_50TB', dtmSistemaContratacionActual__c = 'ODIN', vlocity_cmt__SpecificationType__c = 'Product', StockKeepingUnit = 'SKUICO');
        insert productPrimeros;

        Product2 product500 = new Product2(Name = 'Arriba de 500TB/mes', ProductCode = 'ALMACENAMIENTOGB_500TB', dtmSistemaContratacionActual__c = 'ODIN', vlocity_cmt__SpecificationType__c = 'Product', StockKeepingUnit = 'SKUICQ');
        insert product500;

        Product2 productTransferencia = new Product2(Name = 'Transferencia GB', ProductCode = 'TRANSFERENCIAS_5GB_10TB', dtmSistemaContratacionActual__c = 'ODIN', vlocity_cmt__SpecificationType__c = 'Product', StockKeepingUnit = 'SKUICT');
        insert productTransferencia;

        // Obtener la Pricebook estándar
        Id standardPricebookId = Test.getStandardPricebookId();

        // Crear entradas en PricebookEntry
        PricebookEntry pbePadre = new PricebookEntry(Product2Id = productPadre.Id, Pricebook2Id = standardPricebookId, UnitPrice = 1000, IsActive = true);
        insert pbePadre;

        PricebookEntry pbeAgrupador = new PricebookEntry(Product2Id = productAgrupador.Id, Pricebook2Id = standardPricebookId, UnitPrice = 1000, IsActive = true);
        insert pbeAgrupador;

        PricebookEntry pbe500 = new PricebookEntry(Product2Id = product500.Id, Pricebook2Id = standardPricebookId, UnitPrice = 1000, IsActive = true);
        insert pbe500;

        PricebookEntry pbeTransferencia = new PricebookEntry(Product2Id = productTransferencia.Id, Pricebook2Id = standardPricebookId, UnitPrice = 1000, IsActive = true);
        insert pbeTransferencia;

        // Crear cuenta, oportunidad y cotización
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Opportunity opp = new Opportunity(Name = 'Test Opportunity', AccountId = acc.Id, StageName = 'Negociación', CloseDate = System.today());
        insert opp;

        Quote quote = new Quote(Name = 'Test Quote', Pricebook2Id = standardPricebookId, OpportunityId = opp.Id);
        insert quote;

        // Crear líneas de cotización (QuoteLineItems)
        QuoteLineItem qliAlmacenamiento = new QuoteLineItem(QuoteId = quote.Id, PricebookEntryId = pbePadre.Id, Quantity = 1, UnitPrice = 1000, Product2Id = productPadre.Id, 
            Description = 'Almacenamiento en la nube GB');
        insert qliAlmacenamiento;
        

        QuoteLineItem qliTransferencia = new QuoteLineItem(QuoteId = quote.Id, PricebookEntryId = pbeTransferencia.Id, Quantity = 1, UnitPrice = 1000, Product2Id = productTransferencia.Id, 
            Description = 'Transferencia GB');
        insert qliTransferencia;
    }

    @isTest
    static void testAlmacenamientoEnLaNubeGB() {
        // Obtener el QuoteLineItem con descripción 'Almacenamiento en la nube GB'
        QuoteLineItem qli = [SELECT Id, Description, vlocity_cmt__AttributeSelectedValues__c FROM QuoteLineItem WHERE Description = 'Almacenamiento en la nube GB' LIMIT 1];

        // Ejecutar lógica de prueba
        Test.startTest();
        qli.vlocity_cmt__AttributeSelectedValues__c = '{"ATT_ALMACENAMIENTO_NUBE_CAPACIDAD": 600000}';
        update qli;
        Test.stopTest();

        // Verificar resultados esperados
        QuoteLineItem updatedQli = [SELECT Id, Product2.StockKeepingUnit, dtmSKUContratacion__c, dtmSKURenta__c FROM QuoteLineItem WHERE Id = :qli.Id];
        System.assertEquals('SKUICV', updatedQli.Product2.StockKeepingUnit, 'El SKU del producto padre debería ser SKUICV');
    }

    @isTest
    static void testTransferenciaGB() {
        // Obtener el QuoteLineItem con descripción 'Transferencia GB'
        QuoteLineItem qli = [SELECT Id, Description, vlocity_cmt__AttributeSelectedValues__c FROM QuoteLineItem WHERE Description = 'Transferencia GB' LIMIT 1];

        // Ejecutar lógica de prueba
        Test.startTest();
        qli.vlocity_cmt__AttributeSelectedValues__c = '{"ATT_ALMACENAMIENTO_NUBE_CAPACIDAD": 600000}';
        update qli;
        Test.stopTest();

        // Verificar resultados esperados
        QuoteLineItem updatedQli = [SELECT Id, Product2.StockKeepingUnit, dtmSKUContratacion__c, dtmSKURenta__c FROM QuoteLineItem WHERE Id = :qli.Id];
        System.assertEquals('SKUICT', updatedQli.Product2.StockKeepingUnit, 'El SKU del producto de transferencia debería ser SKUICT');
    }
}