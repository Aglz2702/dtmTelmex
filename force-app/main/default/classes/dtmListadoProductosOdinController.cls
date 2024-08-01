global class dtmListadoProductosOdinController {
    public static final String NOMBRE_SERVICIO = 'dtmListaProductosOdin';
    global static dtmListadoProductosOdin.dtmListadoProductosOdinResponse integrarConEndpointExterno(String jsonInput) {
        String endpoint = dtmUtility.getEndpoint(NOMBRE_SERVICIO);
        Http https = new Http();
        HttpRequest request = new HttpRequest();
        //String endpoint = 'https://356dafa1-a57b-4e56-836f-80a49440dcbc.mock.pstmn.io/listaProductos';
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        String accessToken = dtmObtenerTokenOdin.getToken();
        system.debug('accessToken'+accessToken);
        request.setHeader('token', accessToken);
        request.setTimeout(120000);
        request.setBody(jsonInput);
        HttpResponse response = https.send(request);
        dtmListadoProductosOdin.dtmListadoProductosOdinResponse respuesta;

        if (response.getStatusCode() == 200) {
            respuesta = (dtmListadoProductosOdin.dtmListadoProductosOdinResponse) JSON.deserialize(response.getBody(), dtmListadoProductosOdin.dtmListadoProductosOdinResponse.class);
            System.debug('Response received V2: ' + respuesta);
        } else {
            respuesta = (dtmListadoProductosOdin.dtmListadoProductosOdinResponse) JSON.deserialize(response.getBody(), dtmListadoProductosOdin.dtmListadoProductosOdinResponse.class);
        }
        respuesta.statusCode = response.getStatusCode(); // Asignar el código de estado
        return respuesta;
    }
}