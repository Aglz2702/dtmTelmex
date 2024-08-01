@isTest
public class dtmObtenerSitioTest {
    
    @isTest 
    static void emptyJson(){
        Map<String, Object> entradaDatos = new Map<String,Object>();
        dtmObtenerSitio.sitio sitio = new dtmObtenerSitio.sitio();  
        dtmObtenerSitio.dtmObtenerSitioResponse myResponse= new dtmObtenerSitio.dtmObtenerSitioResponse();
        test.setMock(HttpCalloutMock.class, new MockHttp());
        test.StartTest();
        sitio.toMap();
        dtmObtenerSitio.procesarSolicitud(entradaDatos);
        myResponse.toMap();
        test.StopTest();
    }
    
    @isTest
    static void emptyJsonWrongCode(){
        Map<String, Object> entradaDatos = new Map<String,Object>();
        test.setMock(HttpCalloutMock.class, new MockHttpWrong());
        test.StartTest(); 
        dtmObtenerSitio.procesarSolicitud(entradaDatos);
        test.StopTest();
    }
    
    private class MockHttp implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"sitios":[{"siteId":"123","siteName":"name"}]}');
            response.setStatusCode(200);
            return response;
        }
    }
    
    private class MockHttpWrong implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"sitios":[{"siteId":"123","siteName":"name"}]}');
            response.setStatusCode(100);
            return response;
        }
    }
}