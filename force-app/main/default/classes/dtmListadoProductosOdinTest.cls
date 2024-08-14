@isTest
public class dtmListadoProductosOdinTest {
    
    @testSetUp  
    static void setUp() {
        Id  standardPb = Test.getStandardPricebookId();
        Account myAccountTest = new Account();
        myAccountTest.Name = 'Testingggggggggg';
        myAccountTest.dtmIdCuentaODIN__c=123456;
        myAccountTest.dtmIdResellerOdin__c=654321;
        insert myAccountTest;
        
        Contact contacto = new Contact();
        contacto.AccountId =myAccountTest.Id;
        contacto.FirstName = 'test';
        contacto.LastName = 'test';
        contacto.Email = 'test@test.com';
        contacto.Department = 'test';
        contacto.HomePhone = '5656565656';
        contacto.Phone = '6767676767';
        contacto.Department = 'test';
        contacto.dtmJefeInmediato__c = 'test test test';
        insert contacto;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'test';
        opp.dtmCuentaPartner__c=myAccountTest.Id;
        opp.Pricebook2Id = standardPb;
        opp.StageName='Negociación';
        opp.closeDate=Date.Today();
        insert opp;
        
        Quote cotizacion = new Quote();
        cotizacion.OpportunityId=opp.Id;
        cotizacion.Name='Testingggggggggg';
        insert cotizacion; 
        system.debug('Cotizacion:'+ cotizacion);
        
        Product2 produ = new Product2(Name='Aspel',dtmLegacyName__c='Aspel', IsActive=true,vlocity_cmt__SpecificationType__c = 'Offer');
        insert produ;
        PricebookEntry pbe = new PricebookEntry (Product2Id=produ.id,Pricebook2ID=standardPb,UnitPrice=50, isActive=true,UseStandardPrice = false);
        insert pbe;
        QuoteLineItem item = new QuoteLineItem(QuoteId = cotizacion.Id, PriceBookEntryID=pbe.id,Quantity=1,dtmCodigoISOMoneda__c='MXN', UnitPrice =pbe.UnitPrice, Product2Id=produ.id);
        insert item;
    }
    
    @isTest 
    static void emptyJson(){
        
        Quote coti = [SELECT Id,dtmCuentaPartnerId__c FROM Quote WHERE Name = 'Testingggggggggg' LIMIT 1];
        System.debug('coti: '+coti.dtmCuentaPartnerId__c);
        dtmListadoProductosOdin.dtmListadoProductosOdinResponse myResponse= new dtmListadoProductosOdin.dtmListadoProductosOdinResponse();
        
        test.StartTest();
        Test.setMock(HttpCalloutMock.class, new dtmMockHttpToken()); 
        Test.setMock(HttpCalloutMock.class, new dtmMockHttpExito()); 
        dtmListadoProductosOdin.dtmListadoProductosOdinResponse Response = dtmListadoProductosOdin.procesarSolicitud(coti.Id);
        myResponse.toMap();
        test.StopTest();
    }
    
    @isTest
    static void emptyJsonWrongCode(){
        Quote coti = [SELECT Id FROM Quote WHERE Name = 'Testingggggggggg' LIMIT 1];
        dtmListadoProductosOdin.dtmListadoProductosOdinResponse myResponse= new dtmListadoProductosOdin.dtmListadoProductosOdinResponse();
        test.StartTest();
        Test.setMock(HttpCalloutMock.class, new dtmMockHttpToken()); 
        Test.setMock(HttpCalloutMock.class, new MockHttpWrong()); 
        dtmListadoProductosOdin.dtmListadoProductosOdinResponse Response = dtmListadoProductosOdin.procesarSolicitud(coti.Id);
        myResponse.toMap();
        test.StopTest();
    }
    @isTest
    static void emptyJsonWrongCode400(){
        Quote coti = [SELECT Id FROM Quote WHERE Name = 'Testingggggggggg' LIMIT 1];
        dtmListadoProductosOdin.dtmListadoProductosOdinResponse myResponse= new dtmListadoProductosOdin.dtmListadoProductosOdinResponse();
        test.StartTest();
        Test.setMock(HttpCalloutMock.class, new dtmMockHttpToken()); 
        Test.setMock(HttpCalloutMock.class, new MockHttpWrong400()); 
        dtmListadoProductosOdin.dtmListadoProductosOdinResponse Response = dtmListadoProductosOdin.procesarSolicitud(coti.Id);
        myResponse.toMap();
        test.StopTest();
    }
    
    private class dtmMockHttpExito implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{ "codigoRespuesta":"00", "mensajeRespuesta":"exito", "errores":[ ], "listadoSuscripciones":[ { "accountId":1015311, "subscriptionId":1054369, "nombreSuscripcion":"ASPEL", "cvePlan":"ASPEL", "planId":3502, "status":"ACTIVE", "servStatus":"ACTIVE", "fechaInicio":"2024-03-06T02:03:51Z", "listaRecursos":[ { "cveRecurso":"SELLADO_10000", "nombreRecurso":"Aspel Sellado 10,000 timbres", "status":"INSTALLED", "incluido":0.0, "adicional":1.0 }, { "cveRecurso":"SAE", "nombreRecurso":"Aspel SAE", "status":"INSTALLED", "incluido":0.0, "adicional":1.0 } ], "listaPropiedadesAdicionales":[ { "nombre":"activation_param_RFC", "valor":"VAME7511289G9" } ] } ] }');
            response.setStatusCode(200);
            return response;
        }
    }
    
    private class MockHttpWrong implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{ "codigoRespuesta":"LSPAR-13", "mensajeRespuesta":"error", "errores":[ ], "listadoSuscripciones":[ { "accountId":1015311, "subscriptionId":1054369, "nombreSuscripcion":"ASPEL", "cvePlan":"ASPEL", "planId":3502, "status":"ACTIVE", "servStatus":"ACTIVE", "fechaInicio":"2024-03-06T02:03:51Z", "listaRecursos":[ { "cveRecurso":"SELLADO_10000", "nombreRecurso":"Aspel Sellado 10,000 timbres", "status":"INSTALLED", "incluido":0.0, "adicional":1.0 }, { "cveRecurso":"SAE", "nombreRecurso":"Aspel SAE", "status":"INSTALLED", "incluido":0.0, "adicional":1.0 } ], "listaPropiedadesAdicionales":[ { "nombre":"activation_param_RFC", "valor":"VAME7511289G9" } ] } ] }');
            response.setStatusCode(200);
            return response;
        }
    }
    private class MockHttpWrong400 implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{ "codigoRespuesta":"LSPAR-13", "mensajeRespuesta":"error", "errores":[ ], "listadoSuscripciones":[ { "accountId":1015311, "subscriptionId":1054369, "nombreSuscripcion":"ASPEL", "cvePlan":"ASPEL", "planId":3502, "status":"ACTIVE", "servStatus":"ACTIVE", "fechaInicio":"2024-03-06T02:03:51Z", "listaRecursos":[ { "cveRecurso":"SELLADO_10000", "nombreRecurso":"Aspel Sellado 10,000 timbres", "status":"INSTALLED", "incluido":0.0, "adicional":1.0 }, { "cveRecurso":"SAE", "nombreRecurso":"Aspel SAE", "status":"INSTALLED", "incluido":0.0, "adicional":1.0 } ], "listaPropiedadesAdicionales":[ { "nombre":"activation_param_RFC", "valor":"VAME7511289G9" } ] } ] }');
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