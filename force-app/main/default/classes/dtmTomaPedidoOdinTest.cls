@isTest
public class dtmTomaPedidoOdinTest {

    @testSetUp
    static void SetUp()
    {
         //get standard pricebookId

        Id  standardPb = Test.getStandardPricebookId();

        Pricebook2 pbk1 = new Pricebook2 (Name='Test Pricebook Entry 1',Description='Test Pricebook Entry 1', isActive=true);

        insert pbk1;

        Product2 prod = new Product2(Name='test1',Family='Liner', IsActive=true,vlocity_cmt__SpecificationType__c = 'Product');

        insert prod;

        PricebookEntry pbe = new PricebookEntry (Product2Id=prod.id,Pricebook2ID=standardPb,UnitPrice=50, isActive=true,UseStandardPrice = false);

        insert pbe;

        Opportunity opp = new Opportunity(Pricebook2Id = standardPb,Name='Testing',CloseDate=system.today(),

                                          StageName = 'New');

        insert opp;

        Quote qt = new Quote(Name='test quote',OpportunityId=opp.id,Pricebook2Id = standardPb );

        insert qt;

        QuoteLineItem qliliner = new QuoteLineItem(QuoteId=qt.id,PriceBookEntryID=pbe.id,Quantity=4, UnitPrice =pbe.UnitPrice);

		insert qliliner;
    }
    
    @isTest
    	static void sendQuote()
            {
               dtmTomaPedidoOdin.dtmTomaPedidoOdinResponse myResponse = new dtmTomaPedidoOdin.dtmTomaPedidoOdinResponse();
                dtmTomaPedidoOdin.error myError= new   dtmTomaPedidoOdin.error();
                Test.setMock(HttpCalloutMock.class, new dtmMockHttpToken());
                Quote entradaDatos = [SELECT Id,Name FROM Quote LIMIT 1]; 
                test.StartTest();
                dtmTomaPedidoOdin.procesarSolicitud(entradaDatos.Id);
                myResponse.toMap();
                myError.toMap();
                test.StopTest();
            }
    @isTest
    static void sendQuoteWrongCode()
            {
               dtmTomaPedidoOdin.dtmTomaPedidoOdinResponse myResponse = new dtmTomaPedidoOdin.dtmTomaPedidoOdinResponse();
                Test.setMock(HttpCalloutMock.class, new dtmMockHttpTokenWrong());
                Quote entradaDatos = [SELECT Id,Name FROM Quote LIMIT 1]; 
                test.StartTest();
                dtmTomaPedidoOdin.procesarSolicitud(entradaDatos.Id);
                myResponse.toMap();
                test.StopTest();
            }
       private class dtmMockHttpToken implements HttpCalloutMock {
         // Implement this interface method
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"access_token": "test","token_type": "Bearer","expires_in": 86400}');
            response.setStatusCode(200);
            
            return response;
        }
    }
      private class dtmMockHttpTokenWrong implements HttpCalloutMock {
         // Implement this interface method
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"access_token": "test","token_type": "Bearer","expires_in": 86400}');
            response.setStatusCode(100);
            
            return response;
        }
    }
}