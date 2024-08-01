global class dtmContratacionNmpController {
    public static final String NOMBRE_SERVICIO = 'dtmContratacionNmp';
    global static dtmContratacionNmp.dtmContratacionNmpResponse integrarConEndpointExterno(String jsonInput){
        Map<String, Object> valores = (Map<String, Object>) JSON.deserializeUntyped(jsonInput);
        String telefono = (String) valores.get('telefono');
        String endpoint = dtmUtility.getEndpoint(NOMBRE_SERVICIO);
        Http https = new Http();
        HttpRequest request = new HttpRequest();
        String accessToken = dtmObtenerTokenNmp.getToken(telefono);
        System.debug('accessToken '+accessToken);
        //String endpoint = 'https://bb7d52f6-1a80-4566-b2d9-9cf628b4d7fb.mock.pstmn.io/ContratacionNMP';
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'Bearer ' + accessToken);
        request.setTimeout(120000); // timeout in milliseconds
        request.setBody(jsonInput);
        HttpResponse response = https.send(request);
        dtmContratacionNmp.dtmContratacionNmpResponse respuesta;
        if (response.getStatusCode() == 200) {
            respuesta = (dtmContratacionNmp.dtmContratacionNmpResponse) JSON.deserialize(response.getBody(), dtmContratacionNmp.dtmContratacionNmpResponse.class);
            System.debug('Response received V2: ' + respuesta);
        } else {
            respuesta = (dtmContratacionNmp.dtmContratacionNmpResponse) JSON.deserialize(response.getBody(), dtmContratacionNmp.dtmContratacionNmpResponse.class);
        	System.debug('Response received V2: ' + respuesta);
        }
        respuesta.statusCode = response.getStatusCode(); // Asignar el código de estado
        return respuesta;
    }

}