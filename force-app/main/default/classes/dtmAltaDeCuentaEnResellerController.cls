global class dtmAltaDeCuentaEnResellerController {
    global static dtmAltaDeCuentaEnReseller.dtmAltaDeCuentaEnResellerResponse integrarConEndpointExterno(String jsonInput){
        Http https = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = 'https://960d622d-75f3-480d-b955-44c943f04287.mock.pstmn.io/obtenerServicio';//Poner endpoint
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
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