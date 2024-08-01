global class dtmAltaDeResellerController {
    public static final String NOMBRE_SERVICIO = 'dtmAltaDeReseller';
    global static dtmAltaDeReseller.dtmAltaDeResellerResponse integrarConEndpointExterno(String jsonInput){
        //String endpoint = dtmUtility.getEndpoint(NOMBRE_SERVICIO);
        Http https = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = 'https://00681d31-b133-473c-98dc-83d82fa975b8.mock.pstmn.io/tomaPedidoOdin';//Poner endpoint
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        String accessToken = dtmObtenerTokenOdin.getToken();
        system.debug('accessToken'+accessToken);
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