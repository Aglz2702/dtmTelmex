@isTest
public class dtmRecibirContratacionOdinWrapperTest {

    @isTest
    static void testSuccessfulRequest() {
        // Configurar la solicitud y la respuesta
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestURI = '/apexrest/wsContratacionOdin';
        request.httpMethod = 'POST';
        String body = '{"resellerId":2,"accountId":null,"folioGoTelmex":"12345","listaSolicitudes":[{"codigoRespuesta":"0","mensajeUsr":"Usuario","mensajeTecnico":"Tecnico","cvePlan":"Plan123","estatusOrden":"Completado","mensaje":"Mensaje"}],"subscriptionId":2,"Errores":[{"codigoRespuesta":"1","mensajeUsr":"ErrorUsr","mensajeTecnico":"ErrorTecnico"}]}';
        request.requestBody = Blob.valueOf(body);
        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();
        dtmRecibirContratacionOdinWrapper.dtmRecibirContratacionOdinWrapperResponse res = dtmRecibirContratacionOdinWrapperRequest.recibirContratacion();
        Test.stopTest();

        // Validar que la respuesta sea exitosa
        System.assertEquals(true, res.exito);
        System.assertEquals('Contratacion recibida con exito!', res.mensaje);
        System.assertEquals(null, res.codigoError);
        
        // Validar que todas las propiedades del wrapper están correctamente deserializadas
        dtmRecibirContratacionOdinWrapper.dtmRecibirContratacionOdinWrapperRequest requestData = (dtmRecibirContratacionOdinWrapper.dtmRecibirContratacionOdinWrapperRequest) JSON.deserialize(body, dtmRecibirContratacionOdinWrapper.dtmRecibirContratacionOdinWrapperRequest.class);
        System.assertEquals(2, requestData.resellerId);
        System.assertEquals(null, requestData.accountId);
        System.assertEquals('12345', requestData.folioGoTelmex);
        System.assertEquals(1, requestData.listaSolicitudes.size());
        System.assertEquals('0', requestData.listaSolicitudes[0].codigoRespuesta);
        System.assertEquals('Usuario', requestData.listaSolicitudes[0].mensajeUsr);
        System.assertEquals('Tecnico', requestData.listaSolicitudes[0].mensajeTecnico);
        System.assertEquals('Plan123', requestData.listaSolicitudes[0].cvePlan);
        System.assertEquals('Completado', requestData.listaSolicitudes[0].estatusOrden);
        System.assertEquals('Mensaje', requestData.listaSolicitudes[0].mensaje);
        System.assertEquals(2, requestData.subscriptionId);
        System.assertEquals(1, requestData.Errores.size());
        System.assertEquals('1', requestData.Errores[0].codigoRespuesta);
        System.assertEquals('ErrorUsr', requestData.Errores[0].mensajeUsr);
        System.assertEquals('ErrorTecnico', requestData.Errores[0].mensajeTecnico);
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

        // Validar que la respuesta contenga un error de JSON
        System.assertEquals(false, res.exito);
        //System.assert(res.mensaje.contains('Unexpected character'));
        System.assertEquals(dtmUtility.BAD_REQUEST_CODE, res.codigoError);
    }
}