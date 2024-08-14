@isTest
public class dtmAlmacenamientoHandlerTest {

    @testSetup
    static void setupTestData() {
        // Crear los productos necesarios
        Product2 productPadre = new Product2(Name = 'Almacenamiento en la nube', ProductCode = 'TRBAN', dtmSistemaContratacionActual__c = 'ODIN', vlocity_cmt__SpecificationType__c = 'Offer', StockKeepingUnit = 'SKUICV');
        insert productPadre;
        
        Product2 produSolicitud = new Product2(Name = 'Solicitudes', ProductCode = 'SOLICITUDES', dtmSistemaContratacionActual__c = 'ODIN', vlocity_cmt__SpecificationType__c = 'Product',vlocity_cmt__SpecificationSubType__c='Simple', StockKeepingUnit = 'SKUICRT');
        insert produSolicitud;

        Product2 productoAlmacenamiento = new Product2(Name = 'Almacenamiento (GB)', ProductCode = 'AlMACENAMIENTOGB', dtmSistemaContratacionActual__c = 'ODIN', vlocity_cmt__SpecificationType__c = 'Product',vlocity_cmt__SpecificationSubType__c='Simple', StockKeepingUnit = 'SKUICY');
        insert productoAlmacenamiento;

        Product2 productoAlmacenamientoPrimeros50 = new Product2(Name = 'Primeros 50TB/mes', ProductCode = 'AlMACENAMIENTOGB_50TB', dtmSistemaContratacionActual__c = 'ODIN', vlocity_cmt__SpecificationType__c = 'Product',vlocity_cmt__SpecificationSubType__c='Simple', StockKeepingUnit = 'SKUICO');
        insert productoAlmacenamientoPrimeros50;
        
        Product2 productoAlmacenamientoSiguientes450 = new Product2(Name = 'Siguientes 450TB/mes', ProductCode = 'AlMACENAMIENTOGB_450TB', dtmSistemaContratacionActual__c = 'ODIN', vlocity_cmt__SpecificationType__c = 'Product',vlocity_cmt__SpecificationSubType__c='Simple', StockKeepingUnit = 'SKUICTTTZ');
        insert productoAlmacenamientoSiguientes450;

        Product2 productoAlmacenamientoArriba500 = new Product2(Name = 'Arriba de 500TB/mes', ProductCode = 'AlMACENAMIENTOGB_500TB', dtmSistemaContratacionActual__c = 'ODIN', vlocity_cmt__SpecificationType__c = 'Product', StockKeepingUnit = 'SKUICQ');
        insert productoAlmacenamientoArriba500;

        Product2 productTransferencia = new Product2(Name = 'Transferencia (GB)', ProductCode = 'ALMACENAMIENO_TRANSFERENCIA', dtmSistemaContratacionActual__c = 'ODIN', vlocity_cmt__SpecificationType__c = 'Product',vlocity_cmt__SpecificationSubType__c='Simple', StockKeepingUnit = 'SKUICT');
        insert productTransferencia;
        
        Product2 productTransferencia5gb = new Product2(Name = 'Transferencias 5 GB', ProductCode = 'TRANSFERENCIAS_5GB', dtmSistemaContratacionActual__c = 'ODIN', vlocity_cmt__SpecificationType__c = 'Product',vlocity_cmt__SpecificationSubType__c='Simple', StockKeepingUnit = 'SKUICTT');
        insert productTransferencia5gb;
        
        Product2 productTransferencia5A10 = new Product2(Name = 'Transferencias 5GB A 10TB', ProductCode = 'TRANSFERENCIAS_5GB_10TB', dtmSistemaContratacionActual__c = 'ODIN', vlocity_cmt__SpecificationType__c = 'Product',vlocity_cmt__SpecificationSubType__c='Simple', StockKeepingUnit = 'SKUICTTT');
        insert productTransferencia5A10;
        
        Product2 productTransferencia40 = new Product2(Name = 'Transferencias 40TB', ProductCode = 'TRANSFERENCIAS_40TB', dtmSistemaContratacionActual__c = 'ODIN', vlocity_cmt__SpecificationType__c = 'Product',vlocity_cmt__SpecificationSubType__c='Simple', StockKeepingUnit = 'SKUICTTUU');
        insert productTransferencia40;
        
        Product2 productTransferencia100 = new Product2(Name = 'Transferencias 100TB', ProductCode = 'TRANSFERENCIAS_100TB', dtmSistemaContratacionActual__c = 'ODIN', vlocity_cmt__SpecificationType__c = 'Product',vlocity_cmt__SpecificationSubType__c='Simple', StockKeepingUnit = 'SKUICTTTPP');
        insert productTransferencia100;
        
        Product2 productTransferencia350 = new Product2(Name = 'Transferencias 350TB', ProductCode = 'TRANSFERENCIAS_350TB', dtmSistemaContratacionActual__c = 'ODIN', vlocity_cmt__SpecificationType__c = 'Product',vlocity_cmt__SpecificationSubType__c='Simple', StockKeepingUnit = 'SKUICTTTQQ');
        insert productTransferencia350;

        Id standardPricebookId = Test.getStandardPricebookId();
        Pricebook2 listaEntrada = new Pricebook2(Name='Standard Price Book',IsActive=true);
        insert listaEntrada;
		
        PricebookEntry pbeStandarPadre = new PricebookEntry(Product2Id = productPadre.Id, Pricebook2Id = standardPricebookId, UnitPrice = 1000, IsActive = true);
        insert pbeStandarPadre;
        PricebookEntry pbePadre = new PricebookEntry(Product2Id = productPadre.Id, Pricebook2Id = listaEntrada.Id, UnitPrice = 1000, IsActive = true);
        insert pbePadre;
        
        PricebookEntry pbeStandarSolicitud = new PricebookEntry(Product2Id = produSolicitud.Id, Pricebook2Id = standardPricebookId, UnitPrice = 1000, IsActive = true);
        insert pbeStandarSolicitud;
        PricebookEntry pbeSolicitud = new PricebookEntry(Product2Id = produSolicitud.Id, Pricebook2Id = listaEntrada.Id, UnitPrice = 1000, IsActive = true);
        insert pbeSolicitud;

        PricebookEntry pbeStandarAlmacenamiento = new PricebookEntry(Product2Id = productoAlmacenamiento.Id, Pricebook2Id = standardPricebookId, UnitPrice = 1000, IsActive = true);
        insert pbeStandarAlmacenamiento;
        PricebookEntry pbeAlmacenamiento = new PricebookEntry(Product2Id = productoAlmacenamiento.Id, Pricebook2Id = listaEntrada.Id, UnitPrice = 1000, IsActive = true);
        insert pbeAlmacenamiento;

        PricebookEntry pbeStandarPrimeros50 = new PricebookEntry(Product2Id = productoAlmacenamientoPrimeros50.Id, Pricebook2Id = standardPricebookId, UnitPrice = 1000, IsActive = true);
        insert pbeStandarPrimeros50;
        PricebookEntry pbePrimeros50 = new PricebookEntry(Product2Id = productoAlmacenamientoPrimeros50.Id, Pricebook2Id = listaEntrada.Id, UnitPrice = 1000, IsActive = true);
        insert pbePrimeros50;
        
        PricebookEntry pbeStandarSiguientes450 = new PricebookEntry(Product2Id = productoAlmacenamientoSiguientes450.Id, Pricebook2Id = standardPricebookId, UnitPrice = 1000, IsActive = true);
        insert pbeStandarSiguientes450;
        PricebookEntry pbeSiguientes450 = new PricebookEntry(Product2Id = productoAlmacenamientoSiguientes450.Id, Pricebook2Id = listaEntrada.Id, UnitPrice = 1000, IsActive = true);
        insert pbeSiguientes450;
        
        PricebookEntry pbeStandarArriba500 = new PricebookEntry(Product2Id = productoAlmacenamientoArriba500.Id, Pricebook2Id = standardPricebookId, UnitPrice = 1000, IsActive = true);
        insert pbeStandarArriba500;
        PricebookEntry pbeArriba500 = new PricebookEntry(Product2Id = productoAlmacenamientoArriba500.Id, Pricebook2Id = listaEntrada.Id, UnitPrice = 1000, IsActive = true);
        insert pbeArriba500;

        PricebookEntry pbeStandarTransferencia = new PricebookEntry(Product2Id = productTransferencia.Id, Pricebook2Id = standardPricebookId, UnitPrice = 1000, IsActive = true);
        insert pbeStandarTransferencia;
        PricebookEntry pbeTransferencia = new PricebookEntry(Product2Id = productTransferencia.Id, Pricebook2Id = listaEntrada.Id, UnitPrice = 1000, IsActive = true);
        insert pbeTransferencia;
        
        PricebookEntry pbeStandarTransferencia5 = new PricebookEntry(Product2Id = productTransferencia5gb.Id, Pricebook2Id = standardPricebookId, UnitPrice = 1000, IsActive = true);
        insert pbeStandarTransferencia5;
        PricebookEntry pbeTransferencia5 = new PricebookEntry(Product2Id = productTransferencia5gb.Id, Pricebook2Id = listaEntrada.Id, UnitPrice = 1000, IsActive = true);
        insert pbeTransferencia5;
        
        PricebookEntry pbeStandarTransferencia5A10 = new PricebookEntry(Product2Id = productTransferencia5A10.Id, Pricebook2Id = standardPricebookId, UnitPrice = 1000, IsActive = true);
        insert pbeStandarTransferencia5A10;
        PricebookEntry pbeTransferencia5A10 = new PricebookEntry(Product2Id = productTransferencia5A10.Id, Pricebook2Id = listaEntrada.Id, UnitPrice = 1000, IsActive = true);
        insert pbeTransferencia5A10;
        
        PricebookEntry pbeStandarTransferencia40 = new PricebookEntry(Product2Id = productTransferencia40.Id, Pricebook2Id = standardPricebookId, UnitPrice = 1000, IsActive = true);
        insert pbeStandarTransferencia40;
        PricebookEntry pbeTransferencia40 = new PricebookEntry(Product2Id = productTransferencia40.Id, Pricebook2Id = listaEntrada.Id, UnitPrice = 1000, IsActive = true);
        insert pbeTransferencia40;
        
        PricebookEntry pbeStandarTransferencia100 = new PricebookEntry(Product2Id = productTransferencia100.Id, Pricebook2Id = standardPricebookId, UnitPrice = 1000, IsActive = true);
        insert pbeStandarTransferencia100;
        PricebookEntry pbeTransferencia100 = new PricebookEntry(Product2Id = productTransferencia100.Id, Pricebook2Id = listaEntrada.Id, UnitPrice = 1000, IsActive = true);
        insert pbeTransferencia100;
        
        PricebookEntry pbeStandarTransferencia350 = new PricebookEntry(Product2Id = productTransferencia350.Id, Pricebook2Id = standardPricebookId, UnitPrice = 1000, IsActive = true);
        insert pbeStandarTransferencia350;
        PricebookEntry pbeTransferencia350 = new PricebookEntry(Product2Id = productTransferencia350.Id, Pricebook2Id = listaEntrada.Id, UnitPrice = 1000, IsActive = true);
        insert pbeTransferencia350;
        
        

        // Crear cuenta, oportunidad y cotización
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Opportunity opp = new Opportunity(Name = 'Test Opportunity', AccountId = acc.Id, StageName = 'Negociación', CloseDate = System.today());
        insert opp;

        Quote quote = new Quote(Name = 'Test Quote', Pricebook2Id = listaEntrada.Id, OpportunityId = opp.Id);
        insert quote;
        
        QuoteLineItem qliPadre = new QuoteLineItem(QuoteId = quote.Id, PricebookEntryId = pbePadre.Id, Quantity = 1, UnitPrice = 1000, Product2Id = productPadre.Id,vlocity_cmt__BillingAccountId__c=acc.Id,vlocity_cmt__RootItemId__c='1234567');
        insert qliPadre;
        
         QuoteLineItem qliAlmacenamiento = new QuoteLineItem(QuoteId = quote.Id, PricebookEntryId = pbeAlmacenamiento.Id, Quantity = 1, UnitPrice = 1000, Product2Id = productoAlmacenamiento.Id, Description = 'Almacenamiento (GB)',vlocity_cmt__AttributeSelectedValues__c = '{"ATT_ALMACENAMIENTO_NUBE_CAPACIDAD": 0}');
        insert qliAlmacenamiento;
        
        QuoteLineItem qliAlmacenamientoPrimeros50 = new QuoteLineItem(QuoteId = quote.Id, PricebookEntryId = pbePrimeros50.Id, Quantity = 1, UnitPrice = 1000, Product2Id = productoAlmacenamientoPrimeros50.Id,vlocity_cmt__ParentItemId__c='9876543');
        insert qliAlmacenamientoPrimeros50;
		
        QuoteLineItem qliTransferencia = new QuoteLineItem(QuoteId = quote.Id, PricebookEntryId = pbeTransferencia.Id, Quantity = 1, UnitPrice = 1000, Product2Id = productTransferencia.Id, Description = 'Transferencia (GB)',vlocity_cmt__AttributeSelectedValues__c = '{"ATT_ALMACENAMIENTO_NUBE_CAPACIDAD": 0}');
        insert qliTransferencia;

		QuoteLineItem qliTransferencia5A10 = new QuoteLineItem(QuoteId = quote.Id, PricebookEntryId = pbeTransferencia5A10.Id, Quantity = 1, UnitPrice = 1000, Product2Id = productTransferencia5A10.Id,vlocity_cmt__ParentItemId__c='987654');
        insert qliTransferencia5A10;

        
    }

    @isTest
    static void testAlmacenamientoEnLaNubeGB() {
        QuoteLineItem qli = [SELECT Id, Description, vlocity_cmt__AttributeSelectedValues__c FROM QuoteLineItem WHERE Description = 'Almacenamiento (GB)' LIMIT 1];

        // Ejecutar lógica de prueba
        Test.startTest();
        qli.vlocity_cmt__AttributeSelectedValues__c = '{"ATT_ALMACENAMIENTO_NUBE_CAPACIDAD": 600000}';
        update qli;
        Test.stopTest();

        // Verificar resultados esperados
        QuoteLineItem updatedQli = [SELECT Id, Product2.StockKeepingUnit, dtmSKUContratacion__c, dtmSKURenta__c FROM QuoteLineItem WHERE Id = :qli.Id];
        System.assertEquals('SKUICY', updatedQli.Product2.StockKeepingUnit, 'El SKU del producto padre debería ser SKUICV');
    }

    @isTest
    static void testTransferenciaGB() {
        // Obtener el QuoteLineItem con descripción 'Transferencia GB'
        QuoteLineItem qli = [SELECT Id, Description, vlocity_cmt__AttributeSelectedValues__c FROM QuoteLineItem WHERE Description = 'Transferencia (GB)' LIMIT 1];

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