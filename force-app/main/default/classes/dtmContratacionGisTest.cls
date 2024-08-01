@isTest 
public class dtmContratacionGisTest {
  
    @testSetUp  
    static void setUp(){
        Id  standardPb = Test.getStandardPricebookId();
        Account acc = new Account(Name = 'test',dtmCuentaMaestra__c='test');
        insert acc;
        dtmProyecto__c proy = new dtmProyecto__c(Name='77888');
        insert proy;
        Opportunity oppor = new Opportunity(Pricebook2Id = standardPb, Name='Testing', StageName='Negociación', closeDate=Date.Today(),dtmCUPID__c=proy.id);
        insert oppor;
        Quote myQuote = new Quote(Name='Testing',OpportunityId = oppor.Id, Pricebook2Id = standardPb);
        insert myQuote;
        Product2 prod = new Product2(Name='test1', IsActive=true,vlocity_cmt__SpecificationType__c = 'Offer',dtmEmpresaPrestaServicios__c='UNINET',dtmPlataforma__c='GPON');
        insert prod;
        Product2 prodHijo = new Product2(Name='test12', IsActive=true,vlocity_cmt__SpecificationType__c = 'Product',dtmEmpresaPrestaServicios__c='UNINET',dtmPlataforma__c='GPON',StockKeepingUnit='787822',dtmProductSkuContratacion__c='788888');
        insert prodHijo;
        PricebookEntry pbe = new PricebookEntry (Product2Id=prod.id,Pricebook2ID=standardPb,UnitPrice=50, isActive=true,UseStandardPrice = false);
        insert pbe;
        QuoteLineItem item = new QuoteLineItem(QuoteId = myQuote.Id, PriceBookEntryID=pbe.id,Quantity=4,dtmCodigoISOMoneda__c='MXN', UnitPrice =pbe.UnitPrice, Product2Id=prod.id);
        insert item;
        QuoteLineItem itemHijo = new QuoteLineItem(QuoteId = myQuote.Id, PriceBookEntryID=pbe.id,Quantity=1,dtmCodigoISOMoneda__c='MXN', UnitPrice =pbe.UnitPrice, Product2Id=prodHijo.id,vlocity_cmt__RecurringCharge__c=9,vlocity_cmt__OneTimeCharge__c=2,dtmNombresitio__c='788899 Test');
        insert itemHijo;
    }
    
    @isTest 
    static void emptyJson(){
        String entradaDatos = [SELECT Id FROM Quote WHERE Name = 'Testing' LIMIT 1].Id;
        dtmContratacionGis.dtmContratacionGisResponse myResponse= new dtmContratacionGis.dtmContratacionGisResponse();
        test.setMock(HttpCalloutMock.class, new MockHttp());
        test.StartTest();
        dtmContratacionGis.procesarSolicitud(entradaDatos);
        myResponse.toMap();
        test.StopTest();
    }
    
    @isTest
    static void emptyJsonWrongCode(){
        String entradaDatos = [SELECT Id FROM Quote WHERE Name = 'Testing' LIMIT 1].Id;
        test.setMock(HttpCalloutMock.class, new MockHttpWrong());
        test.StartTest(); 
		dtmContratacionGis.procesarSolicitud(entradaDatos);
		test.StopTest();
    }

    private class MockHttp implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
             response.setBody('{"statusCode":200,"id":12345}');
            response.setStatusCode(200);
            return response;
        }
    }
    
    private class MockHttpWrong implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"statusCode":400,"userMenssage":"Error occurred","severety":"HIGH","errors":["error1","error2"]}');
            response.setStatusCode(100);
            return response;
        }
    }
}