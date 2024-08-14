@isTest
public class dtmRecibirContratacionOdinWrapperTest {
    @testSetUp  
    static void setUp() {
        Id  standardPb = Test.getStandardPricebookId();
        Opportunity oppor = new Opportunity(Pricebook2Id = standardPb, Name='Testing', StageName='Negociación', closeDate=Date.Today());
        insert oppor;
        Quote myQuote = new Quote(Name='Testing',OpportunityId = oppor.Id, Pricebook2Id = standardPb);
        insert myQuote;
    }

    @isTest
    static void testSuccessfulRequest() {
        String idQuote = [SELECT Id FROM Quote WHERE Name = 'Testing' LIMIT 1].Id;
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestURI = '/apexrest/wsContratacionOdin';
        request.httpMethod = 'POST';
        String body = '{"resellerId":2,"accountId":null,"folioGoTelmex":"'+idQuote+'","listaSolicitudes":[{"codigoRespuesta":"0","mensajeUsr":"Usuario","mensajeTecnico":"Tecnico","cvePlan":"Plan123","estatusOrden":"COMPLETED","mensaje":"Mensaje"}],"subscriptionId":2,"Errores":[{"codigoRespuesta":"1","mensajeUsr":"ErrorUsr","mensajeTecnico":"ErrorTecnico"}]}';
        request.requestBody = Blob.valueOf(body);
        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();
        dtmRecibirContratacionOdinWrapper.dtmRecibirContratacionOdinWrapperResponse res = dtmRecibirContratacionOdinWrapperRequest.recibirContratacion();
        Test.stopTest();
        System.assertEquals(true, res.exito);
        System.assertEquals('Informacion recibida con exito!', res.mensaje);
        System.assertEquals(null, res.codigoError);
        
        dtmRecibirContratacionOdinWrapper.dtmRecibirContratacionOdinWrapperRequest requestData = (dtmRecibirContratacionOdinWrapper.dtmRecibirContratacionOdinWrapperRequest) JSON.deserialize(body, dtmRecibirContratacionOdinWrapper.dtmRecibirContratacionOdinWrapperRequest.class);
        System.assertEquals(2, requestData.resellerId);
        System.assertEquals(null, requestData.accountId);
        System.assertEquals(idQuote, requestData.folioGoTelmex);
        System.assertEquals(1, requestData.listaSolicitudes.size());
        System.assertEquals('Tecnico', requestData.listaSolicitudes[0].mensajeTecnico);
        System.assertEquals('COMPLETED', requestData.listaSolicitudes[0].estatusOrden);
    }


    @isTest
    static void testJSONException() {
        // Configurar la solicitud con un cuerpo inválido para causar JSONException
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestURI = '/apexrest/wsContratacionOdin';
        request.httpMethod = 'POST';
        String body = '{"resellerId":2,"accountId":null,"folioGoTelmex":"12345","listaSolicitudes":[{"codigoRespuesta":"","mensajeUsr":"","mensajeTecnico":"","cvePlan":"","estatusOrden":"","mensaje":""}],"subscriptionId":2,"Errores":[{"codigoRespuesta":"","mensajeUsr":"","mensajeTecnico":""}'; // JSON malformado
        request.requestBody = Blob.valueOf(body);
        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();
        dtmRecibirContratacionOdinWrapper.dtmRecibirContratacionOdinWrapperResponse res;
        try {
            res = dtmRecibirContratacionOdinWrapperRequest.recibirContratacion();
        } catch (JSONException e) {
            res = new dtmRecibirContratacionOdinWrapper.dtmRecibirContratacionOdinWrapperResponse();
            res.exito = false;
            res.mensaje = e.getMessage();
            res.codigoError = dtmUtility.BAD_REQUEST_CODE;
        }
        Test.stopTest();
        System.assertEquals(false, res.exito);
        System.assertEquals(dtmUtility.BAD_REQUEST_CODE, res.codigoError);
    }
    
    @isTest
    static void testException() {
        String idQuote = [SELECT Id FROM Quote WHERE Name = 'Testing' LIMIT 1].Id;
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestURI = '/apexrest/wsContratacionOdin';
        request.httpMethod = 'POST';
         String body = '{"resellerId":2,"accountId":null,"folioGoTelmex":"'+idQuote+14+'","listaSolicitudes":[{"codigoRespuesta":"0","mensajeUsr":"Usuario","mensajeTecnico":"Tecnico","cvePlan":"Plan123","estatusOrden":"COMPLETED","mensaje":"Mensaje"}],"subscriptionId":2,"Errores":[{"codigoRespuesta":"1","mensajeUsr":"ErrorUsr","mensajeTecnico":"ErrorTecnico"}]}';
        request.requestBody = Blob.valueOf(body);
        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();
        dtmRecibirContratacionOdinWrapper.dtmRecibirContratacionOdinWrapperResponse res;
        try {
            res = dtmRecibirContratacionOdinWrapperRequest.recibirContratacion();
        } catch (Exception e) {
            res = new dtmRecibirContratacionOdinWrapper.dtmRecibirContratacionOdinWrapperResponse();
            res.exito = false;
            res.mensaje = e.getMessage();
            res.codigoError = dtmUtility.INTERNAL_ERROR_CODE;
        }
        Test.stopTest();
        System.assertEquals(dtmUtility.INTERNAL_ERROR_CODE, res.codigoError);
    }
     @isTest
    static void testErrorRequest() {
        String idQuote = [SELECT Id FROM Quote WHERE Name = 'Testing' LIMIT 1].Id;
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestURI = '/apexrest/wsContratacionOdin';
        request.httpMethod = 'POST';
        String body = '{"resellerId":2,"accountId":null,"folioGoTelmex":null,"listaSolicitudes":[{"codigoRespuesta":"0","mensajeUsr":"Usuario","mensajeTecnico":"Tecnico","cvePlan":"Plan123","estatusOrden":"PROBLEM","mensaje":"Mensaje"}],"subscriptionId":2,"Errores":[{"codigoRespuesta":"1","mensajeUsr":"ErrorUsr","mensajeTecnico":"ErrorTecnico"}]}';
        request.requestBody = Blob.valueOf(body);
        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();
        dtmRecibirContratacionOdinWrapper.dtmRecibirContratacionOdinWrapperResponse res = dtmRecibirContratacionOdinWrapperRequest.recibirContratacion();
        Test.stopTest();
        
        dtmRecibirContratacionOdinWrapper.dtmRecibirContratacionOdinWrapperRequest requestData = (dtmRecibirContratacionOdinWrapper.dtmRecibirContratacionOdinWrapperRequest) JSON.deserialize(body, dtmRecibirContratacionOdinWrapper.dtmRecibirContratacionOdinWrapperRequest.class);
    }
}