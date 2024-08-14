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
                    System.debug('oa: '+data.Productos[0].oa);
                    if(data.Productos[0].oa == null){
                        dtmRecibirContratacionGisWrapperRequest.guardaErrores(body,data);
                    }else{
                        Quote coti = [SELECT id,dtmOa__c,Name FROM Quote WHERE Id=:data.idCotizacionSF];
                        coti.dtmOa__c= data.Productos[0].oa;
                        
                        update coti;
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
        dtmRecibirContratacionGisWrapper.dtmRecibirContratacionGisWrapperResponse responsePayload = new dtmRecibirContratacionGisWrapper.dtmRecibirContratacionGisWrapperResponse();
        responsePayload.exito = success;
        responsePayload.mensaje = message;
        responsePayload.codigoError = errorCode;
        return responsePayload; 
    }
    
    public static void guardaErrores(String body,dtmRecibirContratacionGisWrapper.dtmRecibirContratacionGisWrapperRequest respuesta){
        Integer codigoEstatus = 500;
        vlocity_cmt__VlocityErrorLogEntry__c errorNew = new vlocity_cmt__VlocityErrorLogEntry__c();
        errorNew.vlocity_cmt__Action__c = 'POST';
        errorNew.vlocity_cmt__ErrorCode__c = String.valueOf(codigoEstatus);
        errorNew.vlocity_cmt__ErrorMessage__c = 'No se recibinio niguna orden de aprovisionamiento';
        errorNew.vlocity_cmt__ErrorTime__c = Datetime.Now();
        errorNew.vlocity_cmt__ErrorType__c = 'Callout Error';
        errorNew.vlocity_cmt__InputData__c = body;
        errorNew.Name = 'Recepcion de contratacion GIS';
        errorNew.vlocity_cmt__ObjectName__c = 'Quote';
        errorNew.vlocity_cmt__SourceType__c = 'Servicio Rest';
        Insert errorNew;
        System.debug('Id de registro: '+errorNew.Id); 
    }

}