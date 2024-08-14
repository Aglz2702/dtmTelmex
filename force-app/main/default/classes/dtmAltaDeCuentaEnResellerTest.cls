@isTest
public class dtmAltaDeCuentaEnResellerTest {

    @testSetUp  
    static void setUp() {
        Account myAccountTest = new Account();
        myAccountTest.Name = 'Testingggggggggg';
        myAccountTest.dtmIdResellerOdin__c = 12334;
        myAccountTest.dtmSubCuentaMaestra__c = 'Ao000';
        myAccountTest.dtmEmailCorporativo__c = 'test@test.com';
        myAccountTest.dtmTelefonoFijo__c = '2323232323';
        myAccountTest.dtmDireccionFiscal__PostalCode__s = '12345';
        myAccountTest.dtmDireccionFiscal__StateCode__s = 'PB';
        myAccountTest.dtmDireccionFiscal__City__s = 'CDMX';
        insert myAccountTest;
        
        Contact contactoDatos = new Contact();
        contactoDatos.FirstName = 'Fulanito';
        contactoDatos.LastName = 'Test';
        contactoDatos.Suffix = 'Test';
        contactoDatos.dtmPrimaryContact__c = true;
        contactoDatos.AccountId = myAccountTest.Id;
        insert contactoDatos;
    }
    
    @isTest
    static void altaDeCuentaEnResellerExito() {
        dtmAltaDeCuentaEnReseller.dtmAltaDeCuentaEnResellerResponse myResponse = new dtmAltaDeCuentaEnReseller.dtmAltaDeCuentaEnResellerResponse();
        Account myAccount = [SELECT Id FROM Account WHERE Name = 'Testingggggggggg' LIMIT 1];

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new dtmMockHttpToken()); 
        Test.setMock(HttpCalloutMock.class, new dtmMockHttpExito()); 
        dtmAltaDeCuentaEnReseller.dtmAltaDeCuentaEnResellerResponse response = dtmAltaDeCuentaEnReseller.procesarSolicitud(myAccount.Id);

        // Validar que la respuesta es correcta y que el código ejecuta el bloque if de éxito
        System.assertEquals(200, response.statusCode, 'El código de estado debería ser 200');
        System.assert(response.codigoRespuesta != null, 'El código de respuesta no debería ser nulo');
        System.assertEquals('00', response.codigoRespuesta, 'El código de respuesta debería ser 00');
        System.assert(response.folioId != null, 'El folioId no debería ser nulo');
        System.assertEquals(1001, response.accountId, 'El accountId debería ser 1001');
        
        // Validar que el campo en Account se actualizó correctamente
        Account updatedAccount = [SELECT dtmIdCuentaODIN__c FROM Account WHERE Id = :myAccount.Id];
        System.assertEquals(1001, updatedAccount.dtmIdCuentaODIN__c, 'El campo dtmIdCuentaODIN__c debería ser 1001');
		myResponse.toMap();
        Test.stopTest();
    }

    @isTest
    static void altaDeCuentaEnResellerError() {
        dtmAltaDeCuentaEnReseller.dtmAltaDeCuentaEnResellerResponse myResponse = new dtmAltaDeCuentaEnReseller.dtmAltaDeCuentaEnResellerResponse();
         dtmAltaDeCuentaEnReseller.error myError= new dtmAltaDeCuentaEnReseller.error();
        Account myAccount = [SELECT Id FROM Account WHERE Name = 'Testingggggggggg' LIMIT 1];

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new dtmMockHttpToken()); 
        Test.setMock(HttpCalloutMock.class, new dtmMockHttpTokenWrong()); 
        dtmAltaDeCuentaEnReseller.dtmAltaDeCuentaEnResellerResponse response = dtmAltaDeCuentaEnReseller.procesarSolicitud(myAccount.Id);

        // Validar que la respuesta maneja correctamente el error y ejecuta el bloque else
        System.assertEquals(400, response.statusCode, 'El código de estado debería ser 400');
        System.assert(response.errores != null, 'La lista de errores no debería ser nula');
        System.assertEquals('99', response.codigoRespuesta, 'El código de respuesta debería ser 99');
        System.assertEquals('Test Error', response.errores[0].error, 'El error debería ser "Test Error"');
		myResponse.toMap();
        myError.toMap();
        Test.stopTest();
    }
    
    
    // Mocks para los HTTP Callouts
    private class dtmMockHttpExito implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"codigoRespuesta": "00", "mensajeRespuesta": "Success", "accountId": 1001, "folioId": "ABC123", "statusCode": 200}');
            response.setStatusCode(200);
            return response;
        }
    }

    private class dtmMockHttpTokenWrong implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"codigoRespuesta": "99", "mensajeRespuesta": "Error", "errores": [{"error": "Test Error"}], "statusCode": 400}');
            response.setStatusCode(400);
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