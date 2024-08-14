@isTest
public class dtmValidaDominioTest {

    @isTest
    static void validaDominio()
        { 
            Map<String,Object> mapaEnviar = new Map<String,Object>();
            mapaEnviar.put('validar', 'DOMINIO');
            mapaEnviar.put('nombre', 'tet');
            mapaEnviar.put('valor', '.com');
            dtmValidaDominio.dtmValidaDominioResponse myResponse = new dtmValidaDominio.dtmValidaDominioResponse();
            
            test.StartTest();
            test.setMock(HttpCalloutMock.class,new dtmMockHttpToken());
            Test.setMock(HttpCalloutMock.class, new dtmMockHttpExito()); 
            dtmValidaDominio.dtmValidaDominioResponse response = dtmValidaDominio.procesarSolicitud(mapaEnviar);
            myResponse.toMap();
            
            test.StopTest();
        }
    @isTest
    static void validaDominio2()
        { 
            Map<String,Object> mapaEnviar = new Map<String,Object>();
            mapaEnviar.put('validar', 'DOMINIO');
            mapaEnviar.put('nombre', 'tet');
            mapaEnviar.put('valor', '.org');
            dtmValidaDominio.dtmValidaDominioResponse myResponse = new dtmValidaDominio.dtmValidaDominioResponse();
            
            test.StartTest();
            test.setMock(HttpCalloutMock.class,new dtmMockHttpToken());
            Test.setMock(HttpCalloutMock.class, new dtmMockHttpExito()); 
            dtmValidaDominio.dtmValidaDominioResponse response = dtmValidaDominio.procesarSolicitud(mapaEnviar);
            myResponse.toMap();
            
            test.StopTest();
        }
    @isTest
    static void validaDominio3()
        { 
            Map<String,Object> mapaEnviar = new Map<String,Object>();
            mapaEnviar.put('validar', 'DOMINIO');
            mapaEnviar.put('nombre', 'tet');
            mapaEnviar.put('valor', '.net');
            dtmValidaDominio.dtmValidaDominioResponse myResponse = new dtmValidaDominio.dtmValidaDominioResponse();
            
            test.StartTest();
            test.setMock(HttpCalloutMock.class,new dtmMockHttpToken());
            Test.setMock(HttpCalloutMock.class, new dtmMockHttpExito()); 
            dtmValidaDominio.dtmValidaDominioResponse response = dtmValidaDominio.procesarSolicitud(mapaEnviar);
            myResponse.toMap();
            
            test.StopTest();
        }
    @isTest
    static void validaDominio4()
        { 
            Map<String,Object> mapaEnviar = new Map<String,Object>();
            mapaEnviar.put('validar', 'DOMINIO');
            mapaEnviar.put('nombre', 'tet');
            mapaEnviar.put('valor', '.com.mx');
            dtmValidaDominio.dtmValidaDominioResponse myResponse = new dtmValidaDominio.dtmValidaDominioResponse();
            
            test.StartTest();
            test.setMock(HttpCalloutMock.class,new dtmMockHttpToken());
            Test.setMock(HttpCalloutMock.class, new dtmMockHttpExito()); 
            dtmValidaDominio.dtmValidaDominioResponse response = dtmValidaDominio.procesarSolicitud(mapaEnviar);
            myResponse.toMap();
            
            test.StopTest();
        }
    
    @isTest
    static void validaDominio5()
        { 
            Map<String,Object> mapaEnviar = new Map<String,Object>();
            mapaEnviar.put('validar', 'DOMINIO');
            mapaEnviar.put('nombre', 'tet');
            mapaEnviar.put('valor', '.mx');
            dtmValidaDominio.dtmValidaDominioResponse myResponse = new dtmValidaDominio.dtmValidaDominioResponse();
            
            test.StartTest();
            test.setMock(HttpCalloutMock.class,new dtmMockHttpToken());
            Test.setMock(HttpCalloutMock.class, new dtmMockHttpExito()); 
            dtmValidaDominio.dtmValidaDominioResponse response = dtmValidaDominio.procesarSolicitud(mapaEnviar);
            myResponse.toMap();
            
            test.StopTest();
        }
    @isTest
    static void validaDominioWrong()
        { 
            Map<String,Object> mapaEnviar = new Map<String,Object>();
            mapaEnviar.put('validar', 'DOMINIO');
            mapaEnviar.put('nombre', 'tet');
            mapaEnviar.put('valor', '.com');
            dtmValidaDominio.dtmValidaDominioResponse myResponse = new dtmValidaDominio.dtmValidaDominioResponse();
            test.StartTest();
            test.setMock(HttpCalloutMock.class,new dtmMockHttpToken());
            Test.setMock(HttpCalloutMock.class, new dtmMockHttpTokenWrong()); 
            dtmValidaDominio.dtmValidaDominioResponse response = dtmValidaDominio.procesarSolicitud(mapaEnviar);
            myResponse.toMap();
            test.StopTest();
        }
    @isTest
    static void validaDominioCorreo()
        { 
            Map<String,Object> mapaEnviar = new Map<String,Object>();
            mapaEnviar.put('validar', 'CORREO');
            mapaEnviar.put('nombre', 'tet');
            mapaEnviar.put('valor', '.com');
            dtmValidaDominio.dtmValidaDominioResponse myResponse = new dtmValidaDominio.dtmValidaDominioResponse();
            
            test.StartTest();
            test.setMock(HttpCalloutMock.class,new dtmMockHttpToken());
            Test.setMock(HttpCalloutMock.class, new dtmMockHttpExito()); 
            dtmValidaDominio.dtmValidaDominioResponse response = dtmValidaDominio.procesarSolicitud(mapaEnviar);
            myResponse.toMap();
            
            test.StopTest();
        }
    
    private class dtmMockHttpExito implements HttpCalloutMock {
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{ "codigoRespuesta":"00", "mensajeRespuesta":"Dominio disponible.", "errores": [] }');
            response.setStatusCode(200);
            
            return response;
        }
    }
    private class dtmMockHttpTokenWrong implements HttpCalloutMock {
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{ "codigoRespuesta":"01", "mensajeRespuesta":"Dominio no disponible.", "errores": [{"error":"error"},{"error":"error2"}] }');
            response.setStatusCode(400);
            return response;
        }
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
}