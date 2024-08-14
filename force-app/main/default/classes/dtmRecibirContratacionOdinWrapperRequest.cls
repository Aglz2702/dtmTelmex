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
                    System.debug('Se recibio '+data);
                    if(data.listaSolicitudes[0].estatusOrden=='COMPLETED'){
                        Quote coti = [SELECT id,dtmOa__c,Name FROM Quote WHERE Id=:data.folioGoTelmex];
                        coti.dtmOa__c = data.listaSolicitudes[0].subscriptionId;
                        update coti;
                    }else{
                        dtmRecibirContratacionOdinWrapperRequest.guardaErrores(body, data);
                    }
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
        dtmRecibirContratacionOdinWrapper.dtmRecibirContratacionOdinWrapperResponse responsePayload = new dtmRecibirContratacionOdinWrapper.dtmRecibirContratacionOdinWrapperResponse();
        responsePayload.exito = success;
        responsePayload.mensaje = message;
        responsePayload.codigoError = errorCode;
        return responsePayload;  
    }
    
    public static void guardaErrores(String body,dtmRecibirContratacionOdinWrapper.dtmRecibirContratacionOdinWrapperRequest respuesta){
        String mensajeError = 'Error: '+respuesta.listaSolicitudes[0].estatusOrden +' Mensaje: '+respuesta.listaSolicitudes[0].mensajeTecnico;
        Integer codigoEstatus = 500;
        vlocity_cmt__VlocityErrorLogEntry__c errorNew = new vlocity_cmt__VlocityErrorLogEntry__c();
        errorNew.vlocity_cmt__Action__c = 'POST';
        errorNew.vlocity_cmt__ErrorCode__c = String.valueOf(codigoEstatus);
        errorNew.vlocity_cmt__ErrorMessage__c = mensajeError;
        errorNew.vlocity_cmt__ErrorTime__c = Datetime.Now();
        errorNew.vlocity_cmt__ErrorType__c = 'Callout Error';
        errorNew.vlocity_cmt__InputData__c = body;
        errorNew.Name = 'Recepcion de contratacion ODIN';
        errorNew.vlocity_cmt__ObjectName__c = 'Quote';
        errorNew.vlocity_cmt__SourceType__c = 'Servicio Rest';
        Insert errorNew;
        System.debug('Id de registro: '+errorNew.Id); 
    }

}