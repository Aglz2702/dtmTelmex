public class dtmDatosAltaResellerController {
    public Account account { get; private set; }
    public String mensajeRespuesta { get; private set; }
    public Contact primaryContact { get; private set; }

    public dtmDatosAltaResellerController(ApexPages.StandardController stdController) {
        this.account = (Account) stdController.getRecord();
        agregarMensajeAdvertencias();
        obtenerPrimaryContact();
    }
    
     private void agregarMensajeAdvertencias() {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Para solicitar la Alta de Cuenta en Reseller de ODIN el partner no debe estar dada de alta previamente, En caso de contar con un registro en ODIN no sera posible dar de alta la cuenta. En caso de ya contar con una cuenta dada de alta en su reseller Id solicita a un administrador de sistema actualizar los datos del partner.'));
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
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        // Agregar datos al mapa de entrada
        input.put('palabraClave', 'altaDeCuentaResellerOdin');
        input.put('accountId', account.Id);

        Boolean result = dtmInterfazOrquestador.invokeMethod('call', input, output, options);
        Map<String, Object> datos = (Map<String, Object>) output.get('data');
        String codigoRespuesta = (String) datos.get('codigoRespuesta');
        Integer statusCode = (Integer) datos.get('statusCode');
        System.debug('output: '+output);
        
         if (statusCode==200 && codigoRespuesta=='00') {
             Map<String, Object> data = (Map<String, Object>) output.get('data');
            mensajeRespuesta = 'Datos enviados exitosamente. AccountId obtenido: ' + (Integer)data.get('accountId');
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