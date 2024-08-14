@isTest
public class dtmRecibirContratacionGisTest {
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
        request.requestURI = '/apexrest/wsContratacion';
        request.httpMethod = 'POST';
        String body = '{"idCotizacionSF":"'+idQuote+'","Productos":[{"productoId":"1","folioGis":"G123","oa":"OA1","skus":[{"sku":"SKU1"}]}]}';
        request.requestBody = Blob.valueOf(body);
        RestContext.request = request;
        RestContext.response = response;
        
        Test.startTest();
        dtmRecibirContratacionGisWrapper.dtmRecibirContratacionGisWrapperResponse res = dtmRecibirContratacionGisWrapperRequest.recibirContratacion();
        Test.stopTest();
        
        System.assertEquals('Informacion recibida con exito!', res.mensaje);
        System.assertEquals(null, res.codigoError);
        
        dtmRecibirContratacionGisWrapper.dtmRecibirContratacionGisWrapperRequest requestData = (dtmRecibirContratacionGisWrapper.dtmRecibirContratacionGisWrapperRequest) JSON.deserialize(body, dtmRecibirContratacionGisWrapper.dtmRecibirContratacionGisWrapperRequest.class);
        System.assertEquals(idQuote, requestData.idCotizacionSF);
        System.assertEquals(1, requestData.Productos.size());
        System.assertEquals('OA1', requestData.Productos[0].oa);
    }
    @isTest
    static void testErrorRequest() {
        String idQuote = [SELECT Id FROM Quote WHERE Name = 'Testing' LIMIT 1].Id;
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestURI = '/apexrest/wsContratacion';
        request.httpMethod = 'POST';
        String body = '{"idCotizacionSF":null,"Productos":[{"productoId":"1","folioGis":"G123","oa":null,"skus":[{"sku":"SKU1"}]}]}';
        request.requestBody = Blob.valueOf(body);
        RestContext.request = request;
        RestContext.response = response;
        
        Test.startTest();
        dtmRecibirContratacionGisWrapper.dtmRecibirContratacionGisWrapperResponse res = dtmRecibirContratacionGisWrapperRequest.recibirContratacion();
        Test.stopTest();
                
        dtmRecibirContratacionGisWrapper.dtmRecibirContratacionGisWrapperRequest requestData = (dtmRecibirContratacionGisWrapper.dtmRecibirContratacionGisWrapperRequest) JSON.deserialize(body, dtmRecibirContratacionGisWrapper.dtmRecibirContratacionGisWrapperRequest.class);
    }
    
    @isTest
    static void testJSONException() {
        String idQuote = [SELECT Id FROM Quote WHERE Name = 'Testing' LIMIT 1].Id;
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestURI = '/apexrest/wsContratacion';
        request.httpMethod = 'POST';
        String body = '{"idCotizacionSF":"12345","Productos":[{"productoId":"1","folioGis":"G123","oa":"OA1","skus":[{"sku":"SKU1"}]}'; // JSON malformado
        request.requestBody = Blob.valueOf(body);
        RestContext.request = request;
        RestContext.response = response;
        
        Test.startTest();
        dtmRecibirContratacionGisWrapper.dtmRecibirContratacionGisWrapperResponse res;
        try {
            res = dtmRecibirContratacionGisWrapperRequest.recibirContratacion();
        } catch (JSONException e) {
            res = new dtmRecibirContratacionGisWrapper.dtmRecibirContratacionGisWrapperResponse();
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
        request.requestURI = '/apexrest/wsContratacion';
        request.httpMethod = 'POST';
        String body = '{"idCotizacionSF":"'+idQuote+1+'","Productos":[{"productoId":"1","folioGis":"G123","oa":"OA1","skus":[{"sku":"SKU1"}]}]}';
        request.requestBody = Blob.valueOf(body);
        RestContext.request = request;
        RestContext.response = response;
        
        Test.startTest();
        dtmRecibirContratacionGisWrapper.dtmRecibirContratacionGisWrapperResponse res;
        try {
            res = dtmRecibirContratacionGisWrapperRequest.recibirContratacion();
        } catch (Exception e) {
            res = new dtmRecibirContratacionGisWrapper.dtmRecibirContratacionGisWrapperResponse();
            res.exito = false;
            res.mensaje = e.getMessage();
            res.codigoError = dtmUtility.INTERNAL_ERROR_CODE;
        }
        Test.stopTest();
        System.assertEquals(false, res.exito);
        System.assertEquals(dtmUtility.INTERNAL_ERROR_CODE, res.codigoError);
    }
    
}