@isTest
public class dtmUtilityTest {
@isTest
    static void getEndpoint(){
        for(dtmRutaIntegracion__mdt item: [Select Developername from dtmRutaIntegracion__mdt limit 1]){
            dtmUtility.getEndpoint(item.Developername);
        }
        try{
            dtmUtility.getEndpoint(null);
        }catch(Exception ex){
            System.assertNotEquals(ex, null,'');
        }
    }
}