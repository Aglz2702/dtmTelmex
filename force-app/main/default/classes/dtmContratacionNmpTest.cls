@isTest
public class dtmContratacionNmpTest {
    @testSetUp  
    static void setUp(){
        Id  standardPb = Test.getStandardPricebookId();
        String recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        Account acc = new Account(Name='test',dtmTelefonoFijo__c = '1234567890',dtmTelefonoFacturacion__c='5656565656',dtmEmailCorporativo__c = 'test@test.com',RecordTypeId=recordTypeId);
        insert acc;
        Opportunity oppor = new Opportunity(Pricebook2Id = standardPb, Name='Testing', StageName='New', closeDate=Date.Today(),AccountId=acc.Id,dtmCuentaPartner__c=acc.Id);
        insert oppor;
        Quote myQuote = new Quote(Name='Testing',OpportunityId = oppor.Id, Pricebook2Id = standardPb);
        insert myQuote;
        Product2 prod = new Product2(Name='Sala 10 Participantes', IsActive=true,ProductCode = 'VDC01',vlocity_cmt__SpecificationType__c='Product');
        insert prod;
        PricebookEntry pbe = new PricebookEntry (Product2Id=prod.id,Pricebook2ID=standardPb,UnitPrice=50, isActive=true,UseStandardPrice = false);
        insert pbe;
        QuoteLineItem item = new QuoteLineItem(QuoteId = myQuote.Id, PriceBookEntryID=pbe.id,Quantity=1, UnitPrice=pbe.UnitPrice, Product2Id=prod.Id);
        insert item;
    }
    
    @isTest 
    static void emptyJson(){
        String entradaDatos = [SELECT Id FROM Quote WHERE Name = 'Testing' LIMIT 1].Id;
        dtmContratacionNmp.dtmContratacionNmpResponse myResponse= new dtmContratacionNmp.dtmContratacionNmpResponse();
        test.setMock(HttpCalloutMock.class, new MockHttp());
        test.StartTest();
        dtmContratacionNmp.procesarSolicitud(entradaDatos);
        myResponse.toMap();
        test.StopTest();
    }
    
    @isTest
    static void emptyJsonWrongCode(){
        String entradaDatos = [SELECT Id FROM Quote WHERE Name = 'Testing' LIMIT 1].Id;
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