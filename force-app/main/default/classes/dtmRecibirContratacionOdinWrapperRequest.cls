@RestResource(urlMapping='/wsContratacionOdin')
global class dtmRecibirContratacionOdinWrapperRequest {
    
    @HttpPost
    global static dtmRecibirContratacionOdinWrapper.dtmRecibirContratacionOdinWrapperResponse recibirContratacion(){
        Boolean success = false;
        String message = '';
        Integer errorCode;
        
        if(RestContext.request != null){
            String body = System.RestContext.request.requestBody.toString();
            
            if(String.isNotBlank(body)){
                try{
                    dtmRecibirContratacionOdinWrapper.dtmRecibirContratacionOdinWrapperRequest data = (dtmRecibirContratacionOdinWrapper.dtmRecibirContratacionOdinWrapperRequest)JSON.deserialize(body,dtmRecibirContratacionOdinWrapper.dtmRecibirContratacionOdinWrapperRequest.class);
					Quote coti = [SELECT id,dtmOa__c,Name FROM Quote WHERE Id=:data.folioGoTelmex];
                    coti.dtmOa__c = data.listaSolicitudes[0].subscriptionId;
                    update coti;
                    System.debug('Se recibio '+data);
                    success = true;
                    message = 'Contratacion recibida con exito!';
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
        dtmRecibirContratacionOdinWrapper.dtmRecibirContratacionOdinWrapperResponse responsePayload = new dtmRecibirContratacionOdinWrapper.dtmRecibirContratacionOdinWrapperResponse();
        responsePayload.exito = success;
        responsePayload.mensaje = message;
        responsePayload.codigoError = errorCode;
        return responsePayload;
        
    }

}