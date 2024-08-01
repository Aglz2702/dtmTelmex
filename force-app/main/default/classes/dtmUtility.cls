public class dtmUtility {
    public static final String BAD_REQUEST_MSJ = 'JSON MALFORMADO: ESPERADO ';
    public static final String INTERNAL_ERROR_MSJ = 'ERROR INTERNO ';
    public static final Integer BAD_REQUEST_CODE = 400;
    public static final Integer INTERNAL_ERROR_CODE = 500;
    
    public static String getEndpoint(String nombreURL){
        try{
            dtmRutaIntegracion__mdt ruta = dtmRutaIntegracion__mdt.getInstance(nombreURL); 
            return ruta.dtmEndpoint__c;
        }catch(Exception ex){
            return null;
        }
    } 
}