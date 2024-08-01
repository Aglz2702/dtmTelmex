global class dtmRecibirContratacionGisWrapper {
    global class dtmRecibirContratacionGisWrapperRequest {
        global String idCotizacionSF {get;set;}
        global List<Producto> Productos {get;set;}  
    }
    global class Producto{
        global String productoId {get;set;}
        global String folioGis {get;set;}
        global String oa {get;set;}
        global List<Sku> skus {get;set;}
    }
    global class Sku{
        global String sku {get;set;}
    }
    global class dtmRecibirContratacionGisWrapperResponse {
        global Boolean exito {get;set;}
        global String mensaje {get;set;}
        global Integer codigoError {get;set;}
    }

}