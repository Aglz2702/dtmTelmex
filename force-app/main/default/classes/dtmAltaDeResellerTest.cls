@isTest
public with sharing class dtmAltaDeResellerTest  {
    @testSetUp  
    static void setUp()
    {
        Account myAccountTest = new Account();
        myAccountTest.Name='Testing';
    	Insert myAccountTest;

        Contact myContact = new Contact();
        myContact.AccountId=myAccountTest.Id;
        myContact.FirstName = 'Test';
        myContact.MiddleName= 'Test';
        myContact.LastName = 'Test';
        myContact.dtmUsuario__c = 'Test';
        myContact.dtmContrasena__c = 'Test';
        myContact.Email = 'test@test.com';
        myContact.HomePhone = '2323232323';
        myContact.Phone = '7878787878';
        myContact.dtmJefeInmediato__c = 'Pedrito Test';
        myContact.Department = 'test';
        Insert myContact;

    }
    
    @isTest
    static void altaDeReseller()  
    {
       
        Contact cuenta = [SELECT Id,FirstName,MiddleName,LastName,HomePhone,dtmTelefonoTrabajo__c,Email,Account.Name,dtmUsuario__c,dtmContrasena__c,dtmResellerId__c FROM Contact WHERE FirstName='Test' LIMIT 1];
       Test.setMock(HttpCalloutMock.class, new dtmMockHttpToken()); 
        dtmAltaDeReseller.dtmAltaDeResellerResponse myResponse = new dtmAltaDeReseller.dtmAltaDeResellerResponse();
        Test.startTest();
        dtmAltaDeReseller.procesarSolicitud(cuenta.Id);
        myResponse.toMap();
        Test.stopTest();
        
    }
    @isTest
    static void altaDeResellerWrongStatusCode()  
    {
        Contact cuenta = [SELECT Id,FirstName,MiddleName,LastName,HomePhone,dtmTelefonoTrabajo__c,Email,Account.Name,dtmUsuario__c,dtmContrasena__c,dtmResellerId__c FROM Contact WHERE FirstName='Test' LIMIT 1];
       Test.setMock(HttpCalloutMock.class, new dtmMockHttpTokenWrong()); 
        Test.startTest();
        dtmAltaDeReseller.procesarSolicitud(cuenta.Id);
        dtmAltaDeReseller.dtmAltaDeResellerResponse respuesta;
        Test.stopTest();
        
    }
    private class dtmMockHttpToken implements HttpCalloutMock {
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
            response.setBody('{ "codigoRespuesta": "01", "mensajeRespuesta": "EXITO", "errores": null, "resellerId": 1016424, "folioId": "6d1ca5e9-4d80-49cc-81e1-cb5fe97e5df0" }');
            response.setStatusCode(200);
            return response;
        }
    }
    
  
    
}