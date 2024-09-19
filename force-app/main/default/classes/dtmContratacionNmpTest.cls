@isTest
public class dtmContratacionNmpTest {
    @testSetUp  
    static void setUp(){
        Id  standardPb = Test.getStandardPricebookId();
        String recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        Account acc = new Account(Name='testqqqq',dtmTelefonoFijo__c = '1234567810',dtmTelefonoFacturacion__c='5656565657',dtmEmailCorporativo__c = 'test7@test.com',RecordTypeId=recordTypeId);
        insert acc;
        Opportunity oppor = new Opportunity(Pricebook2Id = standardPb, Name='Testing', StageName='New', closeDate=Date.Today(),AccountId=acc.Id,dtmCuentaPartner__c=acc.Id);
        insert oppor;
        Quote myQuote = new Quote(Name='Testing2',OpportunityId = oppor.Id, Pricebook2Id = standardPb);
        insert myQuote;
        Product2 prodPadre = new Product2(Name='Videoconferencia', IsActive=true,ProductCode = 'PR_VIDEOCONFERENCIA',vlocity_cmt__SpecificationType__c='Offer');
        insert prodPadre;
        Product2 prod = new Product2(Name='Sala 10000 Participantes', IsActive=true,ProductCode = 'VDC01000',vlocity_cmt__SpecificationType__c='Product');
        insert prod;
        PricebookEntry pbePadre = new PricebookEntry (Product2Id=prod.id,Pricebook2ID=standardPb,UnitPrice=50, isActive=true,UseStandardPrice = false);
        insert pbePadre;
        PricebookEntry pbe = new PricebookEntry (Product2Id=prodPadre.id,Pricebook2ID=standardPb,UnitPrice=50, isActive=true,UseStandardPrice = false);
        insert pbe;
        QuoteLineItem itemPadre = new QuoteLineItem(QuoteId = myQuote.Id, PriceBookEntryID=pbePadre.id,Quantity=1, UnitPrice=pbePadre.UnitPrice, Product2Id=prodPadre.Id);
        insert itemPadre;
        QuoteLineItem item = new QuoteLineItem(QuoteId = myQuote.Id, PriceBookEntryID=pbe.id,Quantity=1, UnitPrice=pbe.UnitPrice, Product2Id=prod.Id);
        insert item;
    }
    
    @isTest 
    static void emptyJson(){
        String entradaDatos = [SELECT Id FROM Quote WHERE Name = 'Testing2' LIMIT 1].Id;
        dtmContratacionNmp.dtmContratacionNmpResponse myResponse= new dtmContratacionNmp.dtmContratacionNmpResponse();
        test.setMock(HttpCalloutMock.class, new MockHttp());
        test.StartTest();
        dtmContratacionNmp.procesarSolicitud(entradaDatos);
        myResponse.toMap();
        test.StopTest();
    }
    
    @isTest
    static void emptyJsonWrongCode(){
        String entradaDatos = [SELECT Id FROM Quote WHERE Name = 'Testing2' LIMIT 1].Id;
        test.setMock(HttpCalloutMock.class, new MockHttpWrong());
        test.StartTest(); 
		dtmContratacionNmp.procesarSolicitud(entradaDatos);
		test.StopTest();
    }

    private class MockHttp implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{ "statusCodeAuxiliar": 200, "mensajeError": null, "statusCode": 200, "folio": "52000011552079", "codigo": "000" }');
            response.setStatusCode(200);
            return response;
        }
    }
    
    private class MockHttpWrong implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{ "statusCodeAuxiliar": 400, "mensajeError": null, "statusCode": 400, "folio": "52000011552079", "codigo": "000" }');
            response.setStatusCode(100);
            return response;
        }
    }

}