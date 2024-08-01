@isTest
public class dtmObtenerTokenNmpTest {

   
    @isTest
    static  void testGetCallout() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpTokenNmp());
       // String token = dtmObtenerTokenNmp.getToken();
        Test.stopTest();
        //System.assertEquals('Thisisatest', token);
    }
 
    private class MockHttpTokenNmp implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"access_token": "Thisisatest","token_type": "Bearer","expires_in": 86400}');
            response.setStatusCode(200);
            return response;
        }
    }
   

}