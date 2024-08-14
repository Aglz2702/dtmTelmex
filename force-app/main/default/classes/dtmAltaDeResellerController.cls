global class dtmAltaDeResellerController {
    public static final String NOMBRE_SERVICIO = 'dtmAltaDeReseller';
    global static dtmAltaDeReseller.dtmAltaDeResellerResponse integrarConEndpointExterno(String jsonInput){
        //String endpoint = dtmUtility.getEndpoint(NOMBRE_SERVICIO);
        String accessToken = '';
        Http https = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = 'https://a5f2e6e9-7e43-415a-a16e-b035516ec12c.mock.pstmn.io/altacuentaReseller';//Poner endpoint
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        if(Test.isRunningTest()){
            accessToken = 'jjkwejkwkjehwjehjwhekwe';
        }else{
            accessToken = dtmObtenerTokenOdin.getToken();
        system.debug('accessToken'+accessToken);
        }
        request.setHeader('token', accessToken);
        request.setTimeout(120000); // timeout in milliseconds
        request.setBody(jsonInput);
        HttpResponse response = https.send(request);
        dtmAltaDeReseller.dtmAltaDeResellerResponse respuesta;
        
        if (response.getStatusCode() == 200) {
            respuesta = (dtmAltaDeReseller.dtmAltaDeResellerResponse) JSON.deserialize(response.getBody(), dtmAltaDeReseller.dtmAltaDeResellerResponse.class);
            System.debug('Response received V2: ' + respuesta);
        } else {
            respuesta = (dtmAltaDeReseller.dtmAltaDeResellerResponse) JSON.deserialize(response.getBody(), dtmAltaDeReseller.dtmAltaDeResellerResponse.class);
        }
        respuesta.statusCode = response.getStatusCode(); // Asignar el código de estado
        return respuesta;
    }
}