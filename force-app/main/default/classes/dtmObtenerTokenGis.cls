public with sharing class dtmObtenerTokenGis  {
    public static final String NOMBRE_SERVICIO = 'dtmTokenGis';
    public static String getToken(){
        String accessToken;
        Http https = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = dtmUtility.getEndpoint(NOMBRE_SERVICIO);
        request.setHeader('Content-Type','application/json');
        String body = '{';
        body += '"username": "' + System.Label.dtmUserGis + '",';
        body += '"password": "' + System.Label.dtmPassGis + '"';
        body += '}';
        request.setBody(body);
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        System.debug('El request: '+request);
        httpResponse response = https.send(request);
        if (response.getStatusCode() == 200) {
            Map<String, Object> tokenResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            accessToken = (String) tokenResponse.get('token');
            System.debug('token '+accessToken);
        } else {
            System.debug('Error al obtener el token de acceso: ' + response.getStatusCode()+' '+response);
        }
        return accessToken;
    }
}