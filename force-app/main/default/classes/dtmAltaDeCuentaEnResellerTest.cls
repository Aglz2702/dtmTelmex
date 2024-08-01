@isTest
public class dtmAltaDeCuentaEnResellerTest {
@testSetUp  
    static void setUp()
    {
        Account myAccountTest = new Account();
        myAccountTest.Name='Testing';
    	insert myAccountTest;
    }
    
     @isTest
    static void altaDeCuentaEnReseller()  
    {
       	dtmAltaDeCuentaEnReseller.dtmAltaDeCuentaEnResellerResponse myResponse = new dtmAltaDeCuentaEnReseller.dtmAltaDeCuentaEnResellerResponse();
        Account myAccount = [SELECT Id,Name,dtmTelefonoFijo__c FROM Account WHERE Name='Testing' LIMIT 1];
       Test.setMock(HttpCalloutMock.class, new dtmMockHttpToken()); 
        
        Test.startTest();
        dtmAltaDeCuentaEnReseller.procesarSolicitud(myAccount.Id);
        myResponse.toMap();
        Test.stopTest();
        
    }
    @isTest
      static void altaDeCuentaEnResellerWrong()  
    {
       	dtmAltaDeCuentaEnReseller.dtmAltaDeCuentaEnResellerResponse myResponse = new dtmAltaDeCuentaEnReseller.dtmAltaDeCuentaEnResellerResponse();
         dtmAltaDeCuentaEnReseller.error myError= new dtmAltaDeCuentaEnReseller.error();
        Account myAccount = [SELECT Id,Name,dtmTelefonoFijo__c FROM Account WHERE Name='Testing' LIMIT 1];
       Test.setMock(HttpCalloutMock.class, new dtmMockHttpTokenWrong()); 
        
        Test.startTest();
        dtmAltaDeCuentaEnReseller.procesarSolicitud(myAccount.Id);
        myResponse.toMap();
        myError.toMap();
        Test.stopTest();
        
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