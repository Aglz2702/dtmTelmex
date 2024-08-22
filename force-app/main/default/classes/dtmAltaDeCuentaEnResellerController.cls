global class dtmAltaDeCuentaEnResellerController {
    public static final String NOMBRE_SERVICIO = 'dtmAltaDeCuentaEnReseller';
    global static dtmAltaDeCuentaEnReseller.dtmAltaDeCuentaEnResellerResponse integrarConEndpointExterno(String jsonInput){
        String endpoint = dtmUtility.getEndpoint(NOMBRE_SERVICIO);
        String accessToken = '';
        Http https = new Http();
        HttpRequest request = new HttpRequest();
        //String endpoint = 'https://39905f41-1ec7-4d10-bd5b-b08f9485c34c.mock.pstmn.io/altaEnReseller';//Poner endpoint
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
        request.setTimeout(120000);
        request.setBody(jsonInput);
        HttpResponse response = https.send(request);
        dtmAltaDeCuentaEnReseller.dtmAltaDeCuentaEnResellerResponse respuesta;
        
        if (response.getStatusCode() == 200) {
            respuesta = (dtmAltaDeCuentaEnReseller.dtmAltaDeCuentaEnResellerResponse) JSON.deserialize(response.getBody(), dtmAltaDeCuentaEnReseller.dtmAltaDeCuentaEnResellerResponse.class);
            System.debug('Response received V2: ' + respuesta);
        } else {
            respuesta = (dtmAltaDeCuentaEnReseller.dtmAltaDeCuentaEnResellerResponse) JSON.deserialize(response.getBody(), dtmAltaDeCuentaEnReseller.dtmAltaDeCuentaEnResellerResponse.class);
        }
        respuesta.statusCode = response.getStatusCode(); // Asignar el código de estado
        return respuesta;
    }
}