global class dtmRecibirContratacionOdinWrapper {
    global class dtmRecibirContratacionOdinWrapperRequest {
        global Integer resellerId {get;set;}
        global Integer accountId {get;set;}
        global String folioGoTelmex {get;set;}
        global List<ListaSolicitud> listaSolicitudes {get;set;}
        global Integer subscriptionId {get;set;}
        global List<error> Errores {get;set;}
    }
    global class ListaSolicitud {
        global String codigoRespuesta {get;set;}
        global String mensajeUsr {get;set;}
        global String mensajeTecnico {get;set;}
        global String cvePlan {get;set;}
        global String tipoSolicitud {get;set;}
        global String mensaje {get;set;}
        global String estatusOrden {get;set;}
        global String subscriptionId {get;set;}
    }
     global class error {
        global String codigoRespuesta {get;set;}
        global String mensajeUsr {get;set;}
        global String mensajeTecnico {get;set;}
    }
    global class dtmRecibirContratacionOdinWrapperResponse {
        global Boolean exito {get;set;}
        global String mensaje {get;set;}
        global Integer codigoError {get;set;}
    }

}