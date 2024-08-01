@IsTest
public class dtmAjustesSkuQliTest {
    
    @IsTest
    static void testInsertQuoteLineItem() {
        // Preparar datos de prueba
        Product2 product = new Product2(Name = 'Conectividad ICREA V', 
                                        vlocity_cmt__SpecificationType__c = 'Other',
                                        dtmSistemaContratacionActual__c = 'GIS',
                                        StockKeepingUnit = 'SKUICV');
        insert product;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = pricebookId;
        standardPrice.Product2Id = product.Id;
        standardPrice.UnitPrice = 1000;
        standardPrice.IsActive = true;
        insert standardPrice;
        
        Account acc = new Account(Name = 'test');
        insert acc;
        
        Opportunity opp = new Opportunity(Name='Test', AccountId=acc.Id, StageName='Negociación', CloseDate=System.today());
        insert opp;
        
        Quote quote = new Quote(Name = 'Test Quote', Pricebook2Id = pricebookId, OpportunityId = opp.Id);
        insert quote;
        
        QuoteLineItem qli = new QuoteLineItem(QuoteId = quote.Id, PricebookEntryId = standardPrice.Id, UnitPrice = 100, Quantity = 1,
                                              vlocity_cmt__AttributeSelectedValues__c = '{"ATT_CENDAT_TIPO": "Tipo 10"}');
        
        Test.startTest();
        insert qli;
        Test.stopTest();
        
        qli = [SELECT Id, Product2.StockKeepingUnit,dtmSKUContratacion__c, dtmSKURenta__c FROM QuoteLineItem WHERE Id = :qli.Id];
        System.assertEquals('SKUICV', qli.Product2.StockKeepingUnit);
    }
    
    
    @IsTest
    static void testUpdateQuoteLineItem() {
        Product2 product = new Product2(Name = 'Conectividad ICREA V', 
                                        vlocity_cmt__SpecificationType__c = 'Other',
                                        dtmSistemaContratacionActual__c = 'GIS',
                                        StockKeepingUnit = 'SKUICV');
        insert product;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = pricebookId;
        standardPrice.Product2Id = product.Id;
        standardPrice.UnitPrice = 1000;
        standardPrice.IsActive = true;
        insert standardPrice;
        
        Account acc = new Account(Name = 'test');
        insert acc;
        
        Opportunity opp = new Opportunity(Name='Test', AccountId=acc.Id, StageName='Negociación', CloseDate=System.today());
        insert opp;
        
        Quote quote = new Quote(Name = 'Test Quote', Pricebook2Id = pricebookId, OpportunityId = opp.Id);
        insert quote;
        
        QuoteLineItem qli = new QuoteLineItem(QuoteId = quote.Id, PricebookEntryId = standardPrice.Id,Product2Id = product.Id, UnitPrice = 100, Quantity = 1,
                                              vlocity_cmt__AttributeSelectedValues__c = '{"ATT_CENDAT_TIPO": "Tipo 10"}');
        insert qli;
        
        Test.startTest();
        qli.vlocity_cmt__AttributeSelectedValues__c = '{"ATT_CENDAT_TIPO": "Tipo 20"}';
        update qli;
        Test.stopTest();
        
        qli = [SELECT Id, Product2.StockKeepingUnit,dtmSKUContratacion__c, dtmSKURenta__c FROM QuoteLineItem WHERE Id = :qli.Id];
        System.assertEquals('SKUICV', qli.Product2.StockKeepingUnit);
    }
    
    @IsTest
    static void testInsertQuoteLineItemOdin() {
        // Preparar datos de prueba
        Product2 product = new Product2(Name = 'Gestión de sistema operativo', 
                                        vlocity_cmt__SpecificationType__c = 'Other',
                                        dtmSistemaContratacionActual__c = 'ODIN',
                                        StockKeepingUnit = 'SKUODIN');
        insert product;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = pricebookId;
        standardPrice.Product2Id = product.Id;
        standardPrice.UnitPrice = 1000;
        standardPrice.IsActive = true;
        insert standardPrice;
        
        Account acc = new Account(Name = 'test');
        insert acc;
        
        Opportunity opp = new Opportunity(Name='Test', AccountId=acc.Id, StageName='Negociación', CloseDate=System.today());
        insert opp;
        
        Quote quote = new Quote(Name = 'Test Quote', Pricebook2Id = pricebookId, OpportunityId = opp.Id);
        insert quote;
        
        QuoteLineItem qli = new QuoteLineItem(QuoteId = quote.Id, PricebookEntryId = standardPrice.Id,Product2Id = product.Id, UnitPrice = 100, Quantity = 1,
                                              vlocity_cmt__AttributeSelectedValues__c = '{"ATT_SERVSEG_TIPOSO": "Windows"}');
        
        Test.startTest();
        insert qli;
        Test.stopTest();
        
        qli = [SELECT Id, Product2.StockKeepingUnit,dtmSKUContratacion__c, dtmSKURenta__c FROM QuoteLineItem WHERE Id = :qli.Id];
        System.assertEquals('SKUODIN', qli.Product2.StockKeepingUnit);
    }
    
    @IsTest
    static void testUpdateQuoteLineItemOdin() {
        // Preparar datos de prueba
        Product2 product = new Product2(Name = 'Gestión de sistema operativo', 
                                        vlocity_cmt__SpecificationType__c = 'Other',
                                        dtmSistemaContratacionActual__c = 'ODIN',
                                        StockKeepingUnit = 'SKUODIN');
        insert product;
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = pricebookId;
        standardPrice.Product2Id = product.Id;
        standardPrice.UnitPrice = 1000;
        standardPrice.IsActive = true;
        insert standardPrice;
        
        Account acc = new Account(Name = 'test');
        insert acc;
        
        Opportunity opp = new Opportunity(Name='Test', AccountId=acc.Id, StageName='Negociación', CloseDate=System.today());
        insert opp;
        
        Quote quote = new Quote(Name = 'Test Quote', Pricebook2Id = pricebookId, OpportunityId = opp.Id);
        insert quote;
        
        QuoteLineItem qli = new QuoteLineItem(QuoteId = quote.Id, PricebookEntryId = standardPrice.Id,Product2Id = product.Id, UnitPrice = 100, Quantity = 1,
                                              vlocity_cmt__AttributeSelectedValues__c = '{"ATT_SERVSEG_TIPOSO": "Windows"}');
        insert qli;
        
        Test.startTest();
        qli.vlocity_cmt__AttributeSelectedValues__c = '{"ATT_SERVSEG_TIPOSO": "Linux"}';
        update qli;
        Test.stopTest();
        
        qli = [SELECT Id, Product2.StockKeepingUnit,dtmSKUContratacion__c, dtmSKURenta__c FROM QuoteLineItem WHERE Id = :qli.Id];
        System.assertEquals('SKUODIN', qli.Product2.StockKeepingUnit);   
    }
    @IsTest
    static void testInsertQuoteLineItemICREAIII() {
        // Preparar datos de prueba
        Product2 product = new Product2(Name = 'Conectividad ICREA III', 
                                        vlocity_cmt__SpecificationType__c = 'Other',
                                        dtmSistemaContratacionActual__c = 'GIS',
                                        StockKeepingUnit = 'SKUICREAIII');
        insert product;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = pricebookId;
        standardPrice.Product2Id = product.Id;
        standardPrice.UnitPrice = 1000;
        standardPrice.IsActive = true;
        insert standardPrice;
        
        Account acc = new Account(Name = 'test');
        insert acc;
        
        Opportunity opp = new Opportunity(Name='Test', AccountId=acc.Id, StageName='Negociación', CloseDate=System.today());
        insert opp;
        
        Quote quote = new Quote(Name = 'Test Quote', Pricebook2Id = pricebookId, OpportunityId = opp.Id);
        insert quote;
        
        QuoteLineItem qli = new QuoteLineItem(QuoteId = quote.Id, PricebookEntryId = standardPrice.Id, Product2Id = product.Id, UnitPrice = 100, Quantity = 1,
                                              vlocity_cmt__AttributeSelectedValues__c = '{"ATT_CDATOS_TIPO_CONECTIVIDAD_ICREAIII": "Tipo 30"}');
        
        Test.startTest();
        insert qli;
        Test.stopTest();
        
        qli = [SELECT Id, Product2.StockKeepingUnit, dtmSKUContratacion__c, dtmSKURenta__c FROM QuoteLineItem WHERE Id = :qli.Id];
        System.assertEquals('SKUICREAIII', qli.Product2.StockKeepingUnit);
    }

    @IsTest
    static void testUpdateQuoteLineItemICREAIII() {
        Product2 product = new Product2(Name = 'Conectividad ICREA III', 
                                        vlocity_cmt__SpecificationType__c = 'Other',
                                        dtmSistemaContratacionActual__c = 'GIS',
                                        StockKeepingUnit = 'SKUICREAIII');
        insert product;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = pricebookId;
        standardPrice.Product2Id = product.Id;
        standardPrice.UnitPrice = 1000;
        standardPrice.IsActive = true;
        insert standardPrice;
        
        Account acc = new Account(Name = 'test');
        insert acc;
        
        Opportunity opp = new Opportunity(Name='Test', AccountId=acc.Id, StageName='Negociación', CloseDate=System.today());
        insert opp;
        
        Quote quote = new Quote(Name = 'Test Quote', Pricebook2Id = pricebookId, OpportunityId = opp.Id);
        insert quote;
        
        QuoteLineItem qli = new QuoteLineItem(QuoteId = quote.Id, PricebookEntryId = standardPrice.Id, Product2Id = product.Id, UnitPrice = 100, Quantity = 1,
                                              vlocity_cmt__AttributeSelectedValues__c = '{"ATT_CDATOS_TIPO_CONECTIVIDAD_ICREAIII": "Tipo 30"}');
        insert qli;
        
        Test.startTest();
        qli.vlocity_cmt__AttributeSelectedValues__c = '{"ATT_CDATOS_TIPO_CONECTIVIDAD_ICREAIII": "Tipo 40"}';
        update qli;
        Test.stopTest();
        
        qli = [SELECT Id, Product2.StockKeepingUnit, dtmSKUContratacion__c, dtmSKURenta__c FROM QuoteLineItem WHERE Id = :qli.Id];
        System.assertEquals('SKUICREAIII', qli.Product2.StockKeepingUnit);
    }
    
    @IsTest
    static void testInsertQuoteLineItemLicencia() {
        // Preparar datos de prueba
        Product2 product = new Product2(Name = 'Licencia Analiticos', 
                                        vlocity_cmt__SpecificationType__c = 'Other',
                                        dtmSistemaContratacionActual__c = 'GIS',
                                        StockKeepingUnit = 'SKULICENCIA');
        insert product;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = pricebookId;
        standardPrice.Product2Id = product.Id;
        standardPrice.UnitPrice = 1000;
        standardPrice.IsActive = true;
        insert standardPrice;
        
        Account acc = new Account(Name = 'test');
        insert acc;
        
        Opportunity opp = new Opportunity(Name='Test', AccountId=acc.Id, StageName='Negociación', CloseDate=System.today());
        insert opp;
        
        Quote quote = new Quote(Name = 'Test Quote', Pricebook2Id = pricebookId, OpportunityId = opp.Id);
        insert quote;
        
        QuoteLineItem qli = new QuoteLineItem(QuoteId = quote.Id, PricebookEntryId = standardPrice.Id, Product2Id = product.Id, UnitPrice = 100, Quantity = 1,
                                              vlocity_cmt__AttributeSelectedValues__c = '{"ATT_PLAZO": "12"}');
        
        Test.startTest();
        insert qli;
        Test.stopTest();
        
        qli = [SELECT Id, Product2.StockKeepingUnit, dtmSKUContratacion__c, dtmSKURenta__c FROM QuoteLineItem WHERE Id = :qli.Id];
        System.assertEquals('SKULICENCIA', qli.Product2.StockKeepingUnit);
    }

    @IsTest
    static void testUpdateQuoteLineItemLicencia() {
        Product2 product = new Product2(Name = 'Licencia Analiticos', 
                                        vlocity_cmt__SpecificationType__c = 'Other',
                                        dtmSistemaContratacionActual__c = 'GIS',
                                        StockKeepingUnit = 'SKULICENCIA');
        insert product;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = pricebookId;
        standardPrice.Product2Id = product.Id;
        standardPrice.UnitPrice = 1000;
        standardPrice.IsActive = true;
        insert standardPrice;
        
        Account acc = new Account(Name = 'test');
        insert acc;
        
        Opportunity opp = new Opportunity(Name='Test', AccountId=acc.Id, StageName='Negociación', CloseDate=System.today());
        insert opp;
        
        Quote quote = new Quote(Name = 'Test Quote', Pricebook2Id = pricebookId, OpportunityId = opp.Id);
        insert quote;
        
        QuoteLineItem qli = new QuoteLineItem(QuoteId = quote.Id, PricebookEntryId = standardPrice.Id, Product2Id = product.Id, UnitPrice = 100, Quantity = 1,
                                              vlocity_cmt__AttributeSelectedValues__c = '{"ATT_PLAZO": "12"}');
        insert qli;
        
        Test.startTest();
        qli.vlocity_cmt__AttributeSelectedValues__c = '{"ATT_PLAZO": "24"}';
        update qli;
        Test.stopTest();
        
        qli = [SELECT Id, Product2.StockKeepingUnit, dtmSKUContratacion__c, dtmSKURenta__c FROM QuoteLineItem WHERE Id = :qli.Id];
        System.assertEquals('SKULICENCIA', qli.Product2.StockKeepingUnit);
    }
    
    @IsTest
    static void testInsertQuoteLineItemAccesPoint() {
        // Preparar datos de prueba
        Product2 product = new Product2(Name = 'Access Point Huawei 5760', 
                                        vlocity_cmt__SpecificationType__c = 'Other',
                                        dtmSistemaContratacionActual__c = 'GIS',
                                        StockKeepingUnit = 'SKU_acces');
        insert product;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = pricebookId;
        standardPrice.Product2Id = product.Id;
        standardPrice.UnitPrice = 1000;
        standardPrice.IsActive = true;
        insert standardPrice;
        
        Account acc = new Account(Name = 'test');
        insert acc;
        
        Opportunity opp = new Opportunity(Name='Test', AccountId=acc.Id, StageName='Negociación', CloseDate=System.today());
        insert opp;
        
        Quote quote = new Quote(Name = 'Test Quote', Pricebook2Id = pricebookId, OpportunityId = opp.Id);
        insert quote;
        
        QuoteLineItem qli = new QuoteLineItem(QuoteId = quote.Id, PricebookEntryId = standardPrice.Id, Product2Id = product.Id, UnitPrice = 100, Quantity = 1,
                                              vlocity_cmt__AttributeSelectedValues__c = '{"ATT_PLAZO": "12"}');
        
        Test.startTest();
        insert qli;
        Test.stopTest();
        
        qli = [SELECT Id, Product2.StockKeepingUnit, dtmSKUContratacion__c, dtmSKURenta__c FROM QuoteLineItem WHERE Id = :qli.Id];
        System.assertEquals('SKU_acces', qli.Product2.StockKeepingUnit);
    }

    @IsTest
    static void testUpdateQuoteLineItemAccesPoint() {
        Product2 product = new Product2(Name = 'Access Point Huawei 5760', 
                                        vlocity_cmt__SpecificationType__c = 'Other',
                                        dtmSistemaContratacionActual__c = 'GIS',
                                        StockKeepingUnit = 'SKU_acces');
        insert product;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = pricebookId;
        standardPrice.Product2Id = product.Id;
        standardPrice.UnitPrice = 1000;
        standardPrice.IsActive = true;
        insert standardPrice;
        
        Account acc = new Account(Name = 'test');
        insert acc;
        
        Opportunity opp = new Opportunity(Name='Test', AccountId=acc.Id, StageName='Negociación', CloseDate=System.today());
        insert opp;
        
        Quote quote = new Quote(Name = 'Test Quote', Pricebook2Id = pricebookId, OpportunityId = opp.Id);
        insert quote;
        
        QuoteLineItem qli = new QuoteLineItem(QuoteId = quote.Id, PricebookEntryId = standardPrice.Id, Product2Id = product.Id, UnitPrice = 100, Quantity = 1,
                                              vlocity_cmt__AttributeSelectedValues__c = '{"ATT_PLAZO": "24"}');
        insert qli;
        
        Test.startTest();
        qli.vlocity_cmt__AttributeSelectedValues__c = '{"ATT_PLAZO": "24"}';
        update qli;
        Test.stopTest();
        
        qli = [SELECT Id, Product2.StockKeepingUnit, dtmSKUContratacion__c, dtmSKURenta__c FROM QuoteLineItem WHERE Id = :qli.Id];
        System.assertEquals('SKU_acces', qli.Product2.StockKeepingUnit);
    }

    @IsTest
    static void testInsertQuoteLineItemCoUbicacion() {
        // Preparar datos de prueba
        Product2 product = new Product2(Name = 'Co-Ubicación (Triara) ICREA III', 
                                        vlocity_cmt__SpecificationType__c = 'Other',
                                        dtmSistemaContratacionActual__c = 'GIS',
                                        StockKeepingUnit = 'SKU_CoU');
        insert product;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = pricebookId;
        standardPrice.Product2Id = product.Id;
        standardPrice.UnitPrice = 1000;
        standardPrice.IsActive = true;
        insert standardPrice;
        
        Account acc = new Account(Name = 'test');
        insert acc;
        
        Opportunity opp = new Opportunity(Name='Test', AccountId=acc.Id, StageName='Negociación', CloseDate=System.today());
        insert opp;
        
        Quote quote = new Quote(Name = 'Test Quote', Pricebook2Id = pricebookId, OpportunityId = opp.Id);
        insert quote;
        
        QuoteLineItem qli = new QuoteLineItem(QuoteId = quote.Id, PricebookEntryId = standardPrice.Id, Product2Id = product.Id, UnitPrice = 100, Quantity = 1,
                                              vlocity_cmt__AttributeSelectedValues__c = '{"ATT_CENDAT_TIPORACK": "Rack 1/8 de 72\'"}');
        
        Test.startTest();
        insert qli;
        Test.stopTest();
        
        qli = [SELECT Id, Product2.StockKeepingUnit, dtmSKUContratacion__c, dtmSKURenta__c FROM QuoteLineItem WHERE Id = :qli.Id];
        System.assertEquals('SKU_CoU', qli.Product2.StockKeepingUnit);
    }

    @IsTest
    static void testUpdateQuoteLineItemCoUbicacion() {
        Product2 product = new Product2(Name = 'Co-Ubicación (Triara) ICREA III', 
                                        vlocity_cmt__SpecificationType__c = 'Other',
                                        dtmSistemaContratacionActual__c = 'GIS',
                                        StockKeepingUnit = 'SKU_CoU');
        insert product;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = pricebookId;
        standardPrice.Product2Id = product.Id;
        standardPrice.UnitPrice = 1000;
        standardPrice.IsActive = true;
        insert standardPrice;
        
        Account acc = new Account(Name = 'test');
        insert acc;
        
        Opportunity opp = new Opportunity(Name='Test', AccountId=acc.Id, StageName='Negociación', CloseDate=System.today());
        insert opp;
        
        Quote quote = new Quote(Name = 'Test Quote', Pricebook2Id = pricebookId, OpportunityId = opp.Id);
        insert quote;
        
        QuoteLineItem qli = new QuoteLineItem(QuoteId = quote.Id, PricebookEntryId = standardPrice.Id, Product2Id = product.Id, UnitPrice = 100, Quantity = 1,
                                              vlocity_cmt__AttributeSelectedValues__c = '{"ATT_CENDAT_TIPORACK": "Rack 1/8 de 72\'"}');
        insert qli;
        
        Test.startTest();
        qli.vlocity_cmt__AttributeSelectedValues__c = '{"ATT_CENDAT_TIPORACK": "Rack 1/4 de 72\'"}';
        update qli;
        Test.stopTest();
        
        qli = [SELECT Id, Product2.StockKeepingUnit, dtmSKUContratacion__c, dtmSKURenta__c FROM QuoteLineItem WHERE Id = :qli.Id];
        System.assertEquals('SKU_CoU', qli.Product2.StockKeepingUnit);

    }
    
    @IsTest
    static void testInsertQuoteLineItemControladora() {
        // Preparar datos de prueba
        Product2 product = new Product2(Name = 'Controladora Central Aruba 9004', 
                                        vlocity_cmt__SpecificationType__c = 'Other',
                                        dtmSistemaContratacionActual__c = 'GIS',
                                        StockKeepingUnit = 'SKU_con');
        insert product;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = pricebookId;
        standardPrice.Product2Id = product.Id;
        standardPrice.UnitPrice = 1000;
        standardPrice.IsActive = true;
        insert standardPrice;
        
        Account acc = new Account(Name = 'test');
        insert acc;
        
        Opportunity opp = new Opportunity(Name='Test', AccountId=acc.Id, StageName='Negociación', CloseDate=System.today());
        insert opp;
        
        Quote quote = new Quote(Name = 'Test Quote', Pricebook2Id = pricebookId, OpportunityId = opp.Id);
        insert quote;
        
        QuoteLineItem qli = new QuoteLineItem(QuoteId = quote.Id, PricebookEntryId = standardPrice.Id, Product2Id = product.Id, UnitPrice = 100, Quantity = 1,
                                              vlocity_cmt__AttributeSelectedValues__c = '{"ATT_PLAZO": "12"}');
        
        Test.startTest();
        insert qli;
        Test.stopTest();
        
        qli = [SELECT Id, Product2.StockKeepingUnit, dtmSKUContratacion__c, dtmSKURenta__c FROM QuoteLineItem WHERE Id = :qli.Id];
        System.assertEquals('SKU_con', qli.Product2.StockKeepingUnit);
    }

    @IsTest
    static void testUpdateQuoteLineItemControladora() {
        Product2 product = new Product2(Name = 'Controladora Central Aruba 9004', 
                                        vlocity_cmt__SpecificationType__c = 'Other',
                                        dtmSistemaContratacionActual__c = 'GIS',
                                        StockKeepingUnit = 'SKU_con');
        insert product;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = pricebookId;
        standardPrice.Product2Id = product.Id;
        standardPrice.UnitPrice = 1000;
        standardPrice.IsActive = true;
        insert standardPrice;
        
        Account acc = new Account(Name = 'test');
        insert acc;
        
        Opportunity opp = new Opportunity(Name='Test', AccountId=acc.Id, StageName='Negociación', CloseDate=System.today());
        insert opp;
        
        Quote quote = new Quote(Name = 'Test Quote', Pricebook2Id = pricebookId, OpportunityId = opp.Id);
        insert quote;
        
        QuoteLineItem qli = new QuoteLineItem(QuoteId = quote.Id, PricebookEntryId = standardPrice.Id, Product2Id = product.Id, UnitPrice = 100, Quantity = 1,
                                              vlocity_cmt__AttributeSelectedValues__c = '{"ATT_PLAZO": "24"}');
        insert qli;
        
        Test.startTest();
        qli.vlocity_cmt__AttributeSelectedValues__c = '{"ATT_PLAZO": "24"}';
        update qli;
        Test.stopTest();
        
        qli = [SELECT Id, Product2.StockKeepingUnit, dtmSKUContratacion__c, dtmSKURenta__c FROM QuoteLineItem WHERE Id = :qli.Id];
        System.assertEquals('SKU_con', qli.Product2.StockKeepingUnit);
    }
    
    @IsTest
    static void testInsertQuoteLineItemSeguridad() {
        // Preparar datos de prueba
        Product2 product = new Product2(Name = 'MX67 CON SEGURIDAD AVANZADA (Sucursal)', 
                                        vlocity_cmt__SpecificationType__c = 'Other',
                                        dtmSistemaContratacionActual__c = 'GIS',
                                        StockKeepingUnit = 'SKU_seg');
        insert product;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = pricebookId;
        standardPrice.Product2Id = product.Id;
        standardPrice.UnitPrice = 1000;
        standardPrice.IsActive = true;
        insert standardPrice;
        
        Account acc = new Account(Name = 'test');
        insert acc;
        
        Opportunity opp = new Opportunity(Name='Test', AccountId=acc.Id, StageName='Negociación', CloseDate=System.today());
        insert opp;
        
        Quote quote = new Quote(Name = 'Test Quote', Pricebook2Id = pricebookId, OpportunityId = opp.Id);
        insert quote;
        
        QuoteLineItem qli = new QuoteLineItem(QuoteId = quote.Id, PricebookEntryId = standardPrice.Id, Product2Id = product.Id, UnitPrice = 100, Quantity = 1,
                                              vlocity_cmt__AttributeSelectedValues__c = '{"ATT_PLAZO": "12"}');
        
        Test.startTest();
        insert qli;
        Test.stopTest();
        
        qli = [SELECT Id, Product2.StockKeepingUnit, dtmSKUContratacion__c, dtmSKURenta__c FROM QuoteLineItem WHERE Id = :qli.Id];
        System.assertEquals('SKU_seg', qli.Product2.StockKeepingUnit);
    }

    @IsTest
    static void testUpdateQuoteLineItemSeguridad() {
        Product2 product = new Product2(Name = 'MX67 CON SEGURIDAD AVANZADA (Sucursal)', 
                                        vlocity_cmt__SpecificationType__c = 'Other',
                                        dtmSistemaContratacionActual__c = 'GIS',
                                        StockKeepingUnit = 'SKU_seg');
        insert product;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = pricebookId;
        standardPrice.Product2Id = product.Id;
        standardPrice.UnitPrice = 1000;
        standardPrice.IsActive = true;
        insert standardPrice;
        
        Account acc = new Account(Name = 'test');
        insert acc;
        
        Opportunity opp = new Opportunity(Name='Test', AccountId=acc.Id, StageName='Negociación', CloseDate=System.today());
        insert opp;
        
        Quote quote = new Quote(Name = 'Test Quote', Pricebook2Id = pricebookId, OpportunityId = opp.Id);
        insert quote;
        
        QuoteLineItem qli = new QuoteLineItem(QuoteId = quote.Id, PricebookEntryId = standardPrice.Id, Product2Id = product.Id, UnitPrice = 100, Quantity = 1,
                                              vlocity_cmt__AttributeSelectedValues__c = '{"ATT_PLAZO": "24"}');
        insert qli;
        
        Test.startTest();
        qli.vlocity_cmt__AttributeSelectedValues__c = '{"ATT_PLAZO": "24"}';
        update qli;
        Test.stopTest();
        
        qli = [SELECT Id, Product2.StockKeepingUnit, dtmSKUContratacion__c, dtmSKURenta__c FROM QuoteLineItem WHERE Id = :qli.Id];
        System.assertEquals('SKU_seg', qli.Product2.StockKeepingUnit);
    }
    
    @IsTest
    static void testInsertQuoteLineItemOtros() {
        Product2 product = new Product2(Name = 'test', 
                                        vlocity_cmt__SpecificationType__c = 'Other',
                                        dtmSistemaContratacionActual__c = 'GIS',
                                        dtmProductSkuContratacion__c='test2',
                                        StockKeepingUnit = 'SKU_test');
        insert product;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = pricebookId;
        standardPrice.Product2Id = product.Id;
        standardPrice.UnitPrice = 1000;
        standardPrice.IsActive = true;
        insert standardPrice;
        
        Account acc = new Account(Name = 'test');
        insert acc;
        
        Opportunity opp = new Opportunity(Name='Test', AccountId=acc.Id, StageName='Negociación', CloseDate=System.today());
        insert opp;
        
        Quote quote = new Quote(Name = 'Test Quote', Pricebook2Id = pricebookId, OpportunityId = opp.Id);
        insert quote;
        
        QuoteLineItem qli = new QuoteLineItem(QuoteId = quote.Id, PricebookEntryId = standardPrice.Id, Product2Id = product.Id, UnitPrice = 100, Quantity = 1,
                                              vlocity_cmt__AttributeSelectedValues__c = '{"ATT_PLAZO": "24"}');
        Test.startTest();
        insert qli;
        Test.stopTest();
        
        qli = [SELECT Id, Product2.StockKeepingUnit, dtmSKUContratacion__c, dtmSKURenta__c FROM QuoteLineItem WHERE Id = :qli.Id];
        System.assertEquals('SKU_test', qli.Product2.StockKeepingUnit);
    }
    @IsTest
    static void testInsertQuoteLineItemOtrosOdin() {
        Product2 product = new Product2(Name = 'test', 
                                        vlocity_cmt__SpecificationType__c = 'Other',
                                        dtmSistemaContratacionActual__c = 'ODIN',
                                        dtmProductSkuContratacion__c='test22',
                                        StockKeepingUnit = 'SKU_test2');
        insert product;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = pricebookId;
        standardPrice.Product2Id = product.Id;
        standardPrice.UnitPrice = 1000;
        standardPrice.IsActive = true;
        insert standardPrice;
        
        Account acc = new Account(Name = 'test');
        insert acc;
        
        Opportunity opp = new Opportunity(Name='Test', AccountId=acc.Id, StageName='Negociación', CloseDate=System.today());
        insert opp;
        
        Quote quote = new Quote(Name = 'Test Quote', Pricebook2Id = pricebookId, OpportunityId = opp.Id);
        insert quote;
        
        QuoteLineItem qli = new QuoteLineItem(QuoteId = quote.Id, PricebookEntryId = standardPrice.Id, Product2Id = product.Id, UnitPrice = 100, Quantity = 1,
                                              vlocity_cmt__AttributeSelectedValues__c = '{"ATT_PLAZO": "24"}');
        Test.startTest();
        insert qli;
        Test.stopTest();
        
        qli = [SELECT Id, Product2.StockKeepingUnit, dtmSKUContratacion__c, dtmSKURenta__c FROM QuoteLineItem WHERE Id = :qli.Id];
        System.assertEquals('SKU_test2', qli.Product2.StockKeepingUnit);
    }
}