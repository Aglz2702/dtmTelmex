global class dtmValidaDominioController {
    public static final String NOMBRE_SERVICIO = 'dtmValidaDomino';
    global static dtmValidaDominio.dtmValidaDominioResponse integrarConEndpointExterno(String jsonInput){
        //String endpoint = dtmUtility.getEndpoint(NOMBRE_SERVICIO);
        String accessToken = '';
        Http https = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = 'https://0cad41c4-3382-4ea1-bb57-06af99112535.mock.pstmn.io/validaDominio';
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
        request.setBody(jsonInput);
        HttpResponse response = https.send(request);
        System.debug('response: '+response);
        dtmValidaDominio.dtmValidaDominioResponse respuesta;
        if (response.getStatusCode() == 200) {
            respuesta = (dtmValidaDominio.dtmValidaDominioResponse) JSON.deserialize(response.getBody(), dtmValidaDominio.dtmValidaDominioResponse.class);
            System.debug('Response received V2: ' + respuesta);
        } else {
            respuesta = (dtmValidaDominio.dtmValidaDominioResponse) JSON.deserialize(response.getBody(), dtmValidaDominio.dtmValidaDominioResponse.class);
        }
        respuesta.statusCode = response.getStatusCode(); // Asignar el código de estado
        return respuesta;
    }

}