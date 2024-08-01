@isTest
public class dtmRecibirContratacionGisTest {

    @isTest
    static void testSuccessfulRequest() {
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestURI = '/apexrest/wsContratacion';
        request.httpMethod = 'POST';
        String body = '{"idCotizacionSF":"12345","Productos":[{"productoId":"1","folioGis":"G123","oa":"OA1","skus":[{"sku":"SKU1"}]}]}';
        request.requestBody = Blob.valueOf(body);
        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();
        dtmRecibirContratacionGisWrapper.dtmRecibirContratacionGisWrapperResponse res = dtmRecibirContratacionGisWrapperRequest.recibirContratacion();
        Test.stopTest();

        System.assertEquals(true, res.exito);
        System.assertEquals('Contratacion recibida con exito!', res.mensaje);
        System.assertEquals(null, res.codigoError);
        
        dtmRecibirContratacionGisWrapper.dtmRecibirContratacionGisWrapperRequest requestData = (dtmRecibirContratacionGisWrapper.dtmRecibirContratacionGisWrapperRequest) JSON.deserialize(body, dtmRecibirContratacionGisWrapper.dtmRecibirContratacionGisWrapperRequest.class);
        System.assertEquals('12345', requestData.idCotizacionSF);
        System.assertEquals(1, requestData.Productos.size());
        System.assertEquals('1', requestData.Productos[0].productoId);
        System.assertEquals('G123', requestData.Productos[0].folioGis);
        System.assertEquals('OA1', requestData.Productos[0].oa);
        System.assertEquals(1, requestData.Productos[0].skus.size());
        System.assertEquals('SKU1', requestData.Productos[0].skus[0].sku);
    }

    @isTest
    static void testJSONException() {
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
}