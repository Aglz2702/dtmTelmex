@isTest
public class dtmListadoProductosOdinTest {
    
    @isTest 
    static void emptyJson(){
        Map<String, Object> entradaDatos = new Map<String,Object>();
        dtmListadoProductosOdin.Recurso Recurso = new dtmListadoProductosOdin.Recurso();  
        dtmListadoProductosOdin.error error = new dtmListadoProductosOdin.error();  
        dtmListadoProductosOdin.PropiedadAdicional PropiedadAdicional = new dtmListadoProductosOdin.PropiedadAdicional();  
        dtmListadoProductosOdin.Suscripcion Suscripcion = new dtmListadoProductosOdin.Suscripcion();  
        dtmListadoProductosOdin.dtmListadoProductosOdinResponse myResponse= new dtmListadoProductosOdin.dtmListadoProductosOdinResponse();
        test.setMock(HttpCalloutMock.class, new MockHttp());
        test.StartTest();
        Suscripcion.toMap();
        PropiedadAdicional.toMap();
        error.toMap();
        Recurso.toMap();
        dtmListadoProductosOdin.procesarSolicitud(entradaDatos);
        myResponse.toMap();
        test.StopTest();
    }
    
    @isTest
    static void emptyJsonWrongCode(){
        Map<String, Object> entradaDatos = new Map<String,Object>();
        dtmListadoProductosOdin.dtmListadoProductosOdinResponse myResponse= new dtmListadoProductosOdin.dtmListadoProductosOdinResponse();
        test.setMock(HttpCalloutMock.class, new MockHttpWrong());
        test.StartTest(); 
        myResponse = dtmListadoProductosOdin.procesarSolicitud(entradaDatos);
        dtmListadoProductosOdin.guardaErrores('json', myResponse);
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
            response.setBody('{"Suscripcion":[{"accountId":"123","cvePlan":"name"}]}');
            response.setStatusCode(100);
            return response;
        }
    }
}