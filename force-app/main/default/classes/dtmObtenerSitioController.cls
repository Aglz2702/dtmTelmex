global class dtmObtenerSitioController {
    public static final String NOMBRE_SERVICIO = 'dtmObtenerSitios';
    global static dtmObtenerSitio.dtmObtenerSitioResponse integrarConEndpointExterno(Map<String, Object> jsonInput) {
        String endpoint = dtmUtility.getEndpoint(NOMBRE_SERVICIO);
        String body = JSON.serialize(jsonInput);
        Http https = new Http();
        HttpRequest request = new HttpRequest();
        String accessToken = dtmObtenerTokenGis.getToken();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'Bearer ' + accessToken);
        request.setBody(body);
        HttpResponse response = https.send(request);
        dtmObtenerSitio.dtmObtenerSitioResponse respuesta;
        
        if (response.getStatusCode() == 200) {
            respuesta = (dtmObtenerSitio.dtmObtenerSitioResponse) JSON.deserialize(response.getBody(), dtmObtenerSitio.dtmObtenerSitioResponse.class);
            System.debug('Response received V2: ' + respuesta);
        } else {
            respuesta = (dtmObtenerSitio.dtmObtenerSitioResponse) JSON.deserialize(response.getBody(), dtmObtenerSitio.dtmObtenerSitioResponse.class);
        }
        respuesta.statusCode = response.getStatusCode(); // Asignar el código de estado
        return respuesta;
}
}