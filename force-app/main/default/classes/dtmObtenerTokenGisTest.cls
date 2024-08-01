@isTest
public with sharing class dtmObtenerTokenGisTest {
   
    @isTest
    static  void testGetCallout() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpTokenGIS());
        String token = dtmObtenerTokenGis.getToken();
        Test.stopTest();
        System.assertEquals('RYTJUKGHKF445665U', token);
    }
 
    private class MockHttpTokenGIS implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"access_token": "RYTJUKGHKF445665U","token_type": "Bearer","expires_in": 86400}');
            response.setStatusCode(200);
            return response;
        }
    }
   
}