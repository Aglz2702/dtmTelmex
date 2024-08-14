global class dtmContratacionGisController {
    public static final String NOMBRE_SERVICIO = 'dtmContratacionGis';
    global static dtmContratacionGis.dtmContratacionGisResponse integrarConEndpointExterno(String jsonInput) {
        String endpoint = dtmUtility.getEndpoint(NOMBRE_SERVICIO);
        Http https = new Http();
        HttpRequest request = new HttpRequest();
        String accessToken = dtmObtenerTokenGis.getToken();
        //String endpoint = 'https://384a95d0-cd4e-4ea3-94d9-96480b4ba46f.mock.pstmn.io/ContratacionGis';
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'Bearer ' + accessToken);
        request.setBody(jsonInput);
        HttpResponse response = https.send(request);
        dtmContratacionGis.dtmContratacionGisResponse respuesta;
        
        if (response.getStatusCode() == 200) {
            respuesta = (dtmContratacionGis.dtmContratacionGisResponse) JSON.deserialize(response.getBody(), dtmContratacionGis.dtmContratacionGisResponse.class);
            System.debug('Response received V2: ' + respuesta);
        } else {
            respuesta = (dtmContratacionGis.dtmContratacionGisResponse) JSON.deserialize(response.getBody(), dtmContratacionGis.dtmContratacionGisResponse.class);
        }
        respuesta.statusCode = response.getStatusCode(); // Asignar el código de estado
        return respuesta;
}
}