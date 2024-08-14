global class dtmRecibirContratacionGisWrapper {
    global class dtmRecibirContratacionGisWrapperRequest {
        global String idCotizacionSF {get;set;}
        global List<Producto> Productos {get;set;}  
    }
    global class Producto{
        global String oa {get;set;}
    }
    global class dtmRecibirContratacionGisWrapperResponse {
        global Boolean exito {get;set;}
        global String mensaje {get;set;}
        global Integer codigoError {get;set;}
    }

}