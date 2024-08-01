global class dtmTomaPedidoOdinController {
    public static final String NOMBRE_SERVICIO = 'dtmContratacionOdin';
    global static dtmTomaPedidoOdin.dtmTomaPedidoOdinResponse integrarConEndpointExterno(String jsonInput) {
        String endpoint = dtmUtility.getEndpoint(NOMBRE_SERVICIO);
        Http https = new Http();
        HttpRequest request = new HttpRequest();
        //String endpoint = 'https://00681d31-b133-473c-98dc-83d82fa975b8.mock.pstmn.io/tomaPedidoOdin';
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        String accessToken = dtmObtenerTokenOdin.getToken();
        system.debug('accessToken'+accessToken);
        request.setHeader('token', accessToken);
        request.setTimeout(120000); // timeout in milliseconds
        request.setBody(jsonInput);
        HttpResponse response = https.send(request);
        dtmTomaPedidoOdin.dtmTomaPedidoOdinResponse respuesta;
        
        if (response.getStatusCode() == 200) {
            respuesta = (dtmTomaPedidoOdin.dtmTomaPedidoOdinResponse) JSON.deserialize(response.getBody(), dtmTomaPedidoOdin.dtmTomaPedidoOdinResponse.class);
            System.debug('Response received V2: ' + respuesta);
        } else {
            respuesta = (dtmTomaPedidoOdin.dtmTomaPedidoOdinResponse) JSON.deserialize(response.getBody(), dtmTomaPedidoOdin.dtmTomaPedidoOdinResponse.class);
        }
        respuesta.statusCode = response.getStatusCode(); // Asignar el código de estado
        return respuesta;
}
    }