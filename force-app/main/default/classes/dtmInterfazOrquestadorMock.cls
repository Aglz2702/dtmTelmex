@isTest
    global class dtmInterfazOrquestadorMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('"data":{"statusCode":200,"codigoRespuesta":"00","mensajeRespuesta":"exito","errores":[],"resellerId":100001,"folioId":"o2139-321k2-21ku1-9oi33"}}');
        res.setStatusCode(200);
        return res;
    }
}