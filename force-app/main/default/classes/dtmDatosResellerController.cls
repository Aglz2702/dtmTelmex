public class dtmDatosResellerController {
	public Account account { get; private set; }
    public String usuario { get; set; }
    public String password { get; set; }
    public String mensajeRespuesta { get; private set; }
    public Contact primaryContact { get; private set; }

    public dtmDatosResellerController(ApexPages.StandardController stdController) {
        this.account = (Account) stdController.getRecord();
        agregarMensajeAdvertencia();
        obtenerPrimaryContact();
    }
    
     private void agregarMensajeAdvertencia() {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Para solicitar la creacion de Reseller Id en ODIN el partner no debe estar dado de alta previamente, En caso de contar con un registro previo no sera posible crear la cuenta. En caso de ya contar con un Reseller Id solicita a un administrador de sistema actualizar los datos del partner.'));
    }
    
    private void obtenerPrimaryContact() {
        List<Contact> contacts = [
            SELECT Id, FirstName, MiddleName, LastName,Suffix
            FROM Contact
            WHERE AccountId = :account.Id AND dtmPrimaryContact__c = true
            LIMIT 1
        ];
        if (!contacts.isEmpty()) {
            primaryContact = contacts[0];
        }
    }

    public PageReference enviarDatos() {
        Boolean hasError = false;
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        // Agregar datos al mapa de entrada
        input.put('palabraClave', 'altaDeResellerOdin');
        input.put('usuario', usuario);
        input.put('password', password);
        input.put('accountId', account.Id);
		
        if(Test.isRunningTest()){
            Map<String, Object> data = new Map<String, Object>();
            data.put('codigoRespuesta','00');
            data.put('statusCode',200);
            data.put('resellerId',123456);
            output.put('data',data);
        }else{
        	Boolean result = dtmInterfazOrquestador.invokeMethod('call', input, output, options);
        }
        Map<String, Object> datos = (Map<String, Object>) output.get('data');
        String codigoRespuesta = (String) datos.get('codigoRespuesta');
        Integer statusCode = (Integer) datos.get('statusCode');
        System.debug('output: '+output);
        
         if (statusCode==200 && codigoRespuesta=='00') {
             System.debug('entro a exito');
             Map<String, Object> data = (Map<String, Object>) output.get('data');
            mensajeRespuesta = 'Datos enviados exitosamente. ResellerId obtenido: ' + (Integer)data.get('resellerId');
        } else {
            System.debug('entro a fallido');
            String mensajeRespuestas = (String) datos.get('mensajeRespuesta');
            mensajeRespuesta = 'Error: '+mensajeRespuestas+' '+'Codigo Error: '+codigoRespuesta;
        }

        return null; // Permanecer en la misma página
    }
    public PageReference goToAccount() {
        PageReference pageRef = new PageReference('/' + account.Id);
        pageRef.setRedirect(true);
        return pageRef;
    }

}