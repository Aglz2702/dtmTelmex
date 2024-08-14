@isTest
public class dtmAltaDeResellerTest  {
    @testSetUp  
    static void setUp()
    {
        Account myAccountTest = new Account();
        myAccountTest.Name='Testingggggggggg';
        myAccountTest.dtmTelefonoFacturacion__c='2342323222';
        myAccountTest.dtmEmailCorporativo__c='test@test.com';
        myAccountTest.dtmTelefonoFijo__c='2342323223';
        Insert myAccountTest;
        
        Contact myContact = new Contact();
        myContact.AccountId=myAccountTest.Id;
        myContact.FirstName = 'Test';
        myContact.LastName = 'Test';
        myContact.Suffix= 'Test';
        myContact.Email = 'test@test.com';
        myContact.HomePhone = '2323232323';
        myContact.Phone = '7878787878';
        myContact.dtmTelefonoTrabajo__c ='6767676767';
        myContact.dtmJefeInmediato__c = 'Pedrito Test';
        myContact.Department = 'test';
        myContact.dtmPrimaryContact__c=true;
        Insert myContact;
        
    }
    
    @isTest
    static void altaDeReseller()  
    {
        dtmAltaDeReseller.dtmAltaDeResellerResponse myResponse = new dtmAltaDeReseller.dtmAltaDeResellerResponse();
        Account myAccount = [SELECT Id FROM Account WHERE Name = 'Testingggggggggg' LIMIT 1];
        Map<String,Object> mapaEnviar = new Map<String,Object>();
        mapaEnviar.put('accountId', myAccount.id);
        mapaEnviar.put('usuario', 'usuariotest');
        mapaEnviar.put('password', 'passwordtest');
        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new dtmMockHttpToken()); 
        Test.setMock(HttpCalloutMock.class, new dtmMockHttpExito()); 
        dtmAltaDeReseller.dtmAltaDeResellerResponse response = dtmAltaDeReseller.procesarSolicitud(mapaEnviar);
        myResponse.toMap();
        Test.stopTest();
        
    }
    @isTest
    static void altaDeResellerWrongStatusCode()  
    {
        dtmAltaDeReseller.dtmAltaDeResellerResponse myResponse = new dtmAltaDeReseller.dtmAltaDeResellerResponse();
        Account myAccount = [SELECT Id FROM Account WHERE Name = 'Testingggggggggg' LIMIT 1];
        Map<String,Object> mapaEnviar = new Map<String,Object>();
        mapaEnviar.put('accountId', myAccount.id);
        mapaEnviar.put('usuario', 'usuariotest');
        mapaEnviar.put('password', 'passwordtest');
        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new dtmMockHttpToken()); 
        Test.setMock(HttpCalloutMock.class, new dtmMockHttpTokenWrong()); 
        dtmAltaDeReseller.dtmAltaDeResellerResponse response = dtmAltaDeReseller.procesarSolicitud(mapaEnviar);
        myResponse.toMap();
        Test.stopTest();
        
    }
    private class dtmMockHttpExito implements HttpCalloutMock {
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{ "codigoRespuesta": "00", "mensajeRespuesta": "EXITO", "errores": null, "resellerId": 1016424, "folioId": "6d1ca5e9-4d80-49cc-81e1-cb5fe97e5df0" }');
            response.setStatusCode(200);
            
            return response;
        }
    }
    
    private class dtmMockHttpTokenWrong implements HttpCalloutMock {
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{ "codigoRespuesta": "01", "mensajeRespuesta": "error", "errores": null, "resellerId": 1016424, "folioId": "6d1ca5e9-4d80-49cc-81e1-cb5fe97e5df0" }');
            response.setStatusCode(100);
            return response;
        }
    }
    
    private class dtmMockHttpToken implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"access_token": "simulatedAccessToken","token_type": "Bearer","expires_in": 86400}');
            response.setStatusCode(200);
            return response;
        }
    }
    
    
    
}