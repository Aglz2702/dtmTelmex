@isTest
public class dtmTomaPedidoOdinTest {

    @testSetUp
    static void SetUp()
    {
        Id  standardPb = Test.getStandardPricebookId();
        Account myAccountTest = new Account();
        myAccountTest.Name = 'Testingggggggggg';
        myAccountTest.dtmIdCuentaODIN__c=123456;
        myAccountTest.dtmIdResellerOdin__c=654321;
        insert myAccountTest;
        
        Pricebook2 pbk1 = new Pricebook2 (Name='Test Pricebook Entry 1',Description='Test Pricebook Entry 1', isActive=true);
        insert pbk1;

        Product2 produPadre = new Product2(Name='ASPEL',dtmLegacyName__c='ASPEL', IsActive=true,vlocity_cmt__SpecificationType__c = 'Offer',vlocity_cmt__SpecificationSubType__c='Bundle');
        insert produPadre;
        Product2 produSae = new Product2(Name='ASPEL SAE',dtmLegacyName__c='SAE', IsActive=true,vlocity_cmt__SpecificationType__c = 'Product',vlocity_cmt__SpecificationSubType__c='Simple');
        insert produSae;
        Product2 produFacture = new Product2(Name='ASPEL FACTURE',dtmLegacyName__c='FACTURE', IsActive=true,vlocity_cmt__SpecificationType__c = 'Product',vlocity_cmt__SpecificationSubType__c='Simple');
        insert produFacture;
        Product2 produNoiAsistente = new Product2(Name='ASPEL NOI ASISTENTE',dtmLegacyName__c='NOIASISTENTE', IsActive=true,vlocity_cmt__SpecificationType__c = 'Product',vlocity_cmt__SpecificationSubType__c='Simple');
        insert produNoiAsistente;
        Product2 produAdm = new Product2(Name='ASPEL ADM',dtmLegacyName__c='ADM', IsActive=true,vlocity_cmt__SpecificationType__c = 'Product',vlocity_cmt__SpecificationSubType__c='Simple');
        insert produAdm;
        Product2 produNoiAdmTimbres = new Product2(Name='ASPEL ADM TIMBRES',dtmLegacyName__c='ADM_TIMBRES', IsActive=true,vlocity_cmt__SpecificationType__c = 'Product',vlocity_cmt__SpecificationSubType__c='Simple');
        insert produNoiAdmTimbres;
        Product2 produSellado = new Product2(Name='ASPEL SELLADO',dtmLegacyName__c='SELLADO', IsActive=true,vlocity_cmt__SpecificationType__c = 'Product',vlocity_cmt__SpecificationSubType__c='Simple');
        insert produSellado;

        PricebookEntry pbe = new PricebookEntry (Product2Id=produPadre.id,Pricebook2ID=standardPb,UnitPrice=50, isActive=true,UseStandardPrice = false);
        insert pbe;
        
       
        Opportunity opp = new Opportunity(Pricebook2Id = standardPb,Name='Testing',CloseDate=system.today(), StageName = 'Negociación');
        insert opp;

        Quote qt = new Quote(Name='Testingggggggggg',OpportunityId=opp.id,Pricebook2Id = standardPb );
        insert qt;

        QuoteLineItem qliPadre = new QuoteLineItem(QuoteId=qt.id,PriceBookEntryID=pbe.id,Quantity=4, UnitPrice =pbe.UnitPrice, Product2Id=produPadre.Id,dtmRFC__c='test909090');
		insert qliPadre;
        QuoteLineItem qliproduSae= new QuoteLineItem(QuoteId=qt.id,PriceBookEntryID=pbe.id,Quantity=4, UnitPrice =pbe.UnitPrice, Product2Id=produSae.Id,dtmRFC__c='test909090',vlocity_cmt__AttributeSelectedValues__c='{"ATT_ASPEL_USUARIOS":"3"}');
		insert qliproduSae;
        QuoteLineItem qliproduFacture = new QuoteLineItem(QuoteId=qt.id,PriceBookEntryID=pbe.id,Quantity=4, UnitPrice =pbe.UnitPrice, Product2Id=produFacture.Id,dtmRFC__c='test909090',vlocity_cmt__AttributeSelectedValues__c='{"ATT_ASPEL_FACTURE_EMPRESAS":"2 a 99"}');
		insert qliproduFacture;
        QuoteLineItem qliproduNoiAsistente = new QuoteLineItem(QuoteId=qt.id,PriceBookEntryID=pbe.id,Quantity=4, UnitPrice =pbe.UnitPrice, Product2Id=produNoiAsistente.Id,dtmRFC__c='test909090',vlocity_cmt__AttributeSelectedValues__c='{"ATT_ASPEL_NOI_EMPRESAS":"De 26-50"}');
		insert qliproduNoiAsistente;
        QuoteLineItem qliproduAdm = new QuoteLineItem(QuoteId=qt.id,PriceBookEntryID=pbe.id,Quantity=4, UnitPrice =pbe.UnitPrice, Product2Id=produAdm.Id,dtmRFC__c='test909090',vlocity_cmt__AttributeSelectedValues__c='{"ATT_ASPEL_USUARIOS_ADM":"Basica"}');
		insert qliproduAdm;
        QuoteLineItem qliproduNoiAdmTimbres = new QuoteLineItem(QuoteId=qt.id,PriceBookEntryID=pbe.id,Quantity=4, UnitPrice =pbe.UnitPrice, Product2Id=produNoiAdmTimbres.Id,dtmRFC__c='test909090',vlocity_cmt__AttributeSelectedValues__c='{"ATT_ASPEL_ADM_PAQUETE":"50 CFDI"}');
		insert qliproduNoiAdmTimbres;
        QuoteLineItem qliproduSellado = new QuoteLineItem(QuoteId=qt.id,PriceBookEntryID=pbe.id,Quantity=4, UnitPrice =pbe.UnitPrice, Product2Id=produSellado.Id,dtmRFC__c='test909090',vlocity_cmt__AttributeSelectedValues__c='{"ATT_ASPEL_TIMBRES":"1000 CFDI"}');
		insert qliproduSellado;
        
        
        Product2 produT1 = new Product2(Name='Tienda en línea',dtmLegacyName__c='T1PAGINAS', IsActive=true,vlocity_cmt__SpecificationType__c = 'Offer',vlocity_cmt__SpecificationSubType__c='Bundle');
        insert produT1;
        Product2 produAvazado = new Product2(Name='Avanzado',dtmLegacyName__c='AVANZADO', IsActive=true,vlocity_cmt__SpecificationType__c = 'Product',vlocity_cmt__SpecificationSubType__c='Simple');
        insert produAvazado;
        Product2 produDominio = new Product2(Name='Dominio',dtmLegacyName__c='DOMINIO', ProductCode='DOMINIO',IsActive=true,vlocity_cmt__SpecificationType__c = 'Product',vlocity_cmt__SpecificationSubType__c='Simple');
        insert produDominio;
        
         PricebookEntry pbe2 = new PricebookEntry (Product2Id=produT1.id,Pricebook2ID=standardPb,UnitPrice=50, isActive=true,UseStandardPrice = false);
        insert pbe2;

        Quote qT1 = new Quote(Name='Testing2',OpportunityId=opp.id,Pricebook2Id = standardPb );
        insert qT1;
        
        QuoteLineItem qliproduT1= new QuoteLineItem(QuoteId=qT1.id,PriceBookEntryID=pbe2.id,Quantity=1, UnitPrice =pbe2.UnitPrice, Product2Id=produT1.Id,dtmRFC__c='test909090',vlocity_cmt__AttributeSelectedValues__c='{"ATT_TIENDA_TIPO":"Plus","ATT_DOM_ACTUAL":null,"ATT_CNEG_POSEE_DOMINIO":"No"}');
		insert qliproduT1;
        QuoteLineItem qliproduAvazado = new QuoteLineItem(QuoteId=qT1.id,PriceBookEntryID=pbe2.id,Quantity=1, UnitPrice =pbe2.UnitPrice, Product2Id=produAvazado.Id,dtmRFC__c='test909090');
		insert qliproduAvazado;
        QuoteLineItem qliproduDominio = new QuoteLineItem(QuoteId=qT1.id,PriceBookEntryID=pbe2.id,Quantity=1, UnitPrice =pbe2.UnitPrice, Product2Id=produDominio.Id,dtmRFC__c='test909090',vlocity_cmt__AttributeSelectedValues__c='{"ATT_DOM_TIPO":".com.mx","ATT_DOM_NOMBRE":"compufacilrapido","ATT_PLAZO":"12 MESES"}');
		insert qliproduDominio;
        
        
        Product2 produCorreoNegocio = new Product2(Name='Correo Negocio',dtmLegacyName__c='CORREO', IsActive=true,vlocity_cmt__SpecificationType__c = 'Offer',vlocity_cmt__SpecificationSubType__c='Bundle');
        insert produCorreoNegocio;
        Product2 produ10Cuentas = new Product2(Name='10 Cuentas',dtmLegacyName__c='10_CUENTAS', ProductCode='CUENTAS_ADICIONALES',IsActive=true,vlocity_cmt__SpecificationType__c = 'Product',vlocity_cmt__SpecificationSubType__c='Bundle');
        insert produ10Cuentas;
        Product2 produCuentasAdicionales = new Product2(Name='Cuentas Adicionales',dtmLegacyName__c='CUENTAS_ADICIONALES',ProductCode='CUENTAS_ADICIONALES', IsActive=true,vlocity_cmt__SpecificationType__c = 'Product',vlocity_cmt__SpecificationSubType__c='Simple');
        insert produCuentasAdicionales;
        Product2 produDominioC = new Product2(Name='Dominio',dtmLegacyName__c='DOMINIO',ProductCode='DOMINIO', IsActive=true,vlocity_cmt__SpecificationType__c = 'Product',vlocity_cmt__SpecificationSubType__c='Simple');
        insert produDominioC;
        
        PricebookEntry pbe3 = new PricebookEntry (Product2Id=produCorreoNegocio.id,Pricebook2ID=standardPb,UnitPrice=50, isActive=true,UseStandardPrice = false);
        insert pbe3;

        Quote qCorreo = new Quote(Name='Testing3',OpportunityId=opp.id,Pricebook2Id = standardPb );
        insert qCorreo;
        
        QuoteLineItem qliproduCorreoNegocio= new QuoteLineItem(QuoteId=qCorreo.id,PriceBookEntryID=pbe3.id,Quantity=1, UnitPrice =pbe3.UnitPrice, Product2Id=produCorreoNegocio.Id,dtmRFC__c='test909090',vlocity_cmt__AttributeSelectedValues__c='{"ATT_CNEG_NUMERO_CUENTAS":"10 cuentas","ATT_CNEG_POSEE_DOMINIO":"No","ATT_DOM_ACTUAL":"test,com.mx"}');
		insert qliproduCorreoNegocio;
        QuoteLineItem qliprodu10Cuentas = new QuoteLineItem(QuoteId=qCorreo.id,PriceBookEntryID=pbe3.id,Quantity=1, UnitPrice =pbe3.UnitPrice, Product2Id=produ10Cuentas.Id,dtmRFC__c='test909090');
		insert qliprodu10Cuentas;
        QuoteLineItem qliproduCuentasAdicionaless = new QuoteLineItem(QuoteId=qCorreo.id,PriceBookEntryID=pbe3.id,Quantity=1, UnitPrice =pbe3.UnitPrice, Product2Id=produCuentasAdicionales.Id,dtmRFC__c='test909090');
		insert qliproduCuentasAdicionaless;
        QuoteLineItem qliproduDominioC = new QuoteLineItem(QuoteId=qCorreo.id,PriceBookEntryID=pbe3.id,Quantity=1, UnitPrice =pbe3.UnitPrice, Product2Id=produDominioC.Id,dtmRFC__c='test909090',vlocity_cmt__AttributeSelectedValues__c='{"ATT_DOM_TIPO":".com.mx","ATT_DOM_NOMBRE":"test1","ATT_PLAZO":"12 MESES"}');
		insert qliproduDominioC;
    }
    
    @isTest
    	static void sendQuote()
            {
                Quote coti = [SELECT Id,dtmCuentaPartnerId__c FROM Quote WHERE Name = 'Testing2' LIMIT 1];
               dtmTomaPedidoOdin.dtmTomaPedidoOdinResponse myResponse = new dtmTomaPedidoOdin.dtmTomaPedidoOdinResponse();
                
                test.StartTest();
                Test.setMock(HttpCalloutMock.class, new dtmMockHttpToken()); 
        		Test.setMock(HttpCalloutMock.class, new dtmMockHttpExito()); 
                dtmTomaPedidoOdin.dtmTomaPedidoOdinResponse response = dtmTomaPedidoOdin.procesarSolicitud(coti.Id);
                myResponse.toMap();
                test.StopTest();
            }
    @isTest
    	static void sendQuoteT1()
            {
                Quote coti2 = [SELECT Id,dtmCuentaPartnerId__c FROM Quote WHERE Name = 'Testingggggggggg' LIMIT 1];
               dtmTomaPedidoOdin.dtmTomaPedidoOdinResponse myResponse = new dtmTomaPedidoOdin.dtmTomaPedidoOdinResponse();
                
                test.StartTest();
                Test.setMock(HttpCalloutMock.class, new dtmMockHttpToken()); 
        		Test.setMock(HttpCalloutMock.class, new dtmMockHttpExito()); 
                dtmTomaPedidoOdin.dtmTomaPedidoOdinResponse response = dtmTomaPedidoOdin.procesarSolicitud(coti2.Id);
                myResponse.toMap();
                test.StopTest();
            }
    
    @isTest
    	static void sendQuoteCorreo()
            {
                Quote coti3 = [SELECT Id,dtmCuentaPartnerId__c FROM Quote WHERE Name = 'Testing3' LIMIT 1];
               dtmTomaPedidoOdin.dtmTomaPedidoOdinResponse myResponse = new dtmTomaPedidoOdin.dtmTomaPedidoOdinResponse();
                
                test.StartTest();
                Test.setMock(HttpCalloutMock.class, new dtmMockHttpToken()); 
        		Test.setMock(HttpCalloutMock.class, new dtmMockHttpExito()); 
                dtmTomaPedidoOdin.dtmTomaPedidoOdinResponse response = dtmTomaPedidoOdin.procesarSolicitud(coti3.Id);
                myResponse.toMap();
                test.StopTest();
            }
    
    @isTest
    static void sendQuoteWrongCode()
            {
                Quote coti = [SELECT Id FROM Quote WHERE Name = 'Testingggggggggg' LIMIT 1];
               	dtmTomaPedidoOdin.dtmTomaPedidoOdinResponse myResponse = new dtmTomaPedidoOdin.dtmTomaPedidoOdinResponse();
                
                test.StartTest();
                test.setMock(HttpCalloutMock.class, new dtmMockHttpToken()); 
        		Test.setMock(HttpCalloutMock.class, new MockHttpWrong()); 
                dtmTomaPedidoOdin.dtmTomaPedidoOdinResponse response = dtmTomaPedidoOdin.procesarSolicitud(coti.Id);
                myResponse.toMap();
                test.StopTest();
            }
    
    @isTest
    static void emptyJsonWrongCode400(){
        Quote coti = [SELECT Id FROM Quote WHERE Name = 'Testingggggggggg' LIMIT 1];
       	dtmTomaPedidoOdin.dtmTomaPedidoOdinResponse myResponse= new dtmTomaPedidoOdin.dtmTomaPedidoOdinResponse();
        test.StartTest();
        Test.setMock(HttpCalloutMock.class, new dtmMockHttpToken()); 
        Test.setMock(HttpCalloutMock.class, new MockHttpWrong400()); 
        dtmTomaPedidoOdin.dtmTomaPedidoOdinResponse Response = dtmTomaPedidoOdin.procesarSolicitud(coti.Id);
        myResponse.toMap();
        test.StopTest();
    }
    
    
       private class dtmMockHttpToken implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"access_token": "test","token_type": "Bearer","expires_in": 86400}');
            response.setStatusCode(200);
            
            return response;
        }
    }
      private class dtmMockHttpExito implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{ "codigoRespuesta": "00", "mensajeRespuesta": "Exito", "errores": [], "folioId": "744fca3b-b9c9-4f54-a039-555555555556", "folioGoTelmex": "ABC123450123456789" }');
            response.setStatusCode(200);
            return response;
        }
    }
    
    private class MockHttpWrong implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{ "codigoRespuesta": "99", "mensajeRespuesta": "Error", "errores": [], "folioId": "744fca3b-b9c9-4f54-a039-555555555556", "folioGoTelmex": "ABC123450123456789" }');
            response.setStatusCode(200);
            return response;
        }
    }
    
    private class MockHttpWrong400 implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{ "codigoRespuesta": "99", "mensajeRespuesta": "Exito", "errores": [], "folioId": "744fca3b-b9c9-4f54-a039-555555555556", "folioGoTelmex": "ABC123450123456789" }');
            response.setStatusCode(400);
            return response;
        }
    }
}