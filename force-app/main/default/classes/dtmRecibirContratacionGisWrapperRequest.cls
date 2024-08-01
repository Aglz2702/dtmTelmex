@RestResource(urlMapping='/wsContratacion/*')
global with sharing class dtmRecibirContratacionGisWrapperRequest {
    
    @HttpPost
    global static dtmRecibirContratacionGisWrapper.dtmRecibirContratacionGisWrapperResponse recibirContratacion(){ 
        Boolean success = false;
        String message = '';
        Integer errorCode;
        
        if(RestContext.request != null){
            String body = System.RestContext.request.requestBody.toString();
            
            if(String.isNotBlank(body)){
                try{
                    dtmRecibirContratacionGisWrapper.dtmRecibirContratacionGisWrapperRequest data = (dtmRecibirContratacionGisWrapper.dtmRecibirContratacionGisWrapperRequest)JSON.deserialize(body,dtmRecibirContratacionGisWrapper.dtmRecibirContratacionGisWrapperRequest.class);
					System.debug('Se recibio '+data);
                    Quote coti = [SELECT id,dtmOa__c,Name FROM Quote WHERE Id=:data.idCotizacionSF];
                    coti.dtmOa__c= data.Productos[0].oa;
                    
                    update coti;
                    success = true;
                    message = 'Informacion recibida con exito!';
                }catch(JSONException e){
                    success = false;
                    errorCode = dtmUtility.BAD_REQUEST_CODE;
                    message = dtmUtility.BAD_REQUEST_MSJ +'/Linea de codigo: '+e.getLineNumber()+' /Causa: '+e.getCause()+' /Descripcion de error encontrado en JSON: '+e.getMessage();
                }catch(Exception e){
                    success = false;
                    errorCode = dtmUtility.INTERNAL_ERROR_CODE;
                    message = dtmUtility.INTERNAL_ERROR_MSJ +'/Linea de codigo: '+e.getLineNumber()+' /Causa: '+e.getCause()+' /Descripcion de error: '+e.getMessage();
                }
            }
        }
        dtmRecibirContratacionGisWrapper.dtmRecibirContratacionGisWrapperResponse responsePayload = new dtmRecibirContratacionGisWrapper.dtmRecibirContratacionGisWrapperResponse();
        responsePayload.exito = success;
        responsePayload.mensaje = message;
        responsePayload.codigoError = errorCode;
        return responsePayload;
        
    }

}