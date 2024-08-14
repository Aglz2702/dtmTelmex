global class dtmRecibirContratacionOdinWrapper {
    global class dtmRecibirContratacionOdinWrapperRequest {
        global Integer resellerId {get;set;}
        global Integer accountId {get;set;}
        global String folioGoTelmex {get;set;}
        global List<ListaSolicitud> listaSolicitudes {get;set;}
    }
    global class ListaSolicitud {
        global String mensajeTecnico {get;set;}
        global String estatusOrden {get;set;}
        global String subscriptionId {get;set;}
    }
    global class dtmRecibirContratacionOdinWrapperResponse {
        global Boolean exito {get;set;}
        global String mensaje {get;set;}
        global Integer codigoError {get;set;}
    }

}