@isTest
public class dtmValidaDominioTest {

    @isTest
    static void validaDominio()
        { 
            Map<String, Object> entradaDatos = new Map<String, Object>();
            dtmValidaDominio.dtmValidaDominioResponse myResponse = new dtmValidaDominio.dtmValidaDominioResponse();
            test.setMock(HttpCalloutMock.class,new dtmMockHttpToken());
            test.StartTest();
            dtmValidaDominio.procesarSolicitud(entradaDatos);
            myResponse.toMap();
            
            test.StopTest();
        }
    @isTest
    static void validaDominioWrong()
        { 
            Map<String, Object> entradaDatos = new Map<String, Object>();
            dtmValidaDominio.dtmValidaDominioResponse myResponse = new dtmValidaDominio.dtmValidaDominioResponse();
            test.setMock(HttpCalloutMock.class,new dtmMockHttpTokenWrong());
            test.StartTest();
            dtmValidaDominio.procesarSolicitud(entradaDatos);
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