@isTest
public class dtmDatosResellerControllerTest {

    @testSetup
    static void setupTestData() {
        Account testAccount = new Account(Name = 'Test Account',dtmIdResellerOdin__c=123456,dtmSubCuentaMaestra__c='0A12345',dtmEmailCorporativo__c='test@test.com',dtmTelefonoFijo__c='2222222222',dtmDireccionFiscal__PostalCode__s='90500',dtmDireccionFiscal__StateCode__s='PB',dtmDireccionFiscal__City__s='Puebla');
        insert testAccount;

        Contact primaryContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            AccountId = testAccount.Id,
            dtmPrimaryContact__c = true
        );
        insert primaryContact;
    }

    @isTest
    static void testConstructor() {
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        ApexPages.StandardController stdController = new ApexPages.StandardController(testAccount);
        dtmDatosResellerController controller = new dtmDatosResellerController(stdController);
        List<ApexPages.Message> messages = ApexPages.getMessages();
    }

    @isTest
    static void testObtenerPrimaryContact() {
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        ApexPages.StandardController stdController = new ApexPages.StandardController(testAccount);
        dtmDatosResellerController controller = new dtmDatosResellerController(stdController);

    }

    @isTest
    static void testEnviarDatos() {
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(testAccount);

        dtmDatosResellerController controller = new dtmDatosResellerController(stdController);
        controller.usuario = 'testUser';
        controller.password = 'testPassword';

        Test.startTest();
        PageReference result = controller.enviarDatos();
        Test.stopTest();
    }

    @isTest
    static void testEnviarDatosConErrores() {
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        ApexPages.StandardController stdController = new ApexPages.StandardController(testAccount);

        dtmDatosResellerController controller = new dtmDatosResellerController(stdController);
        controller.usuario = '';
        controller.password = '';

        Test.startTest();
        PageReference result = controller.enviarDatos();
        Test.stopTest();
        System.assertEquals(null, result);
        
        List<ApexPages.Message> messages = ApexPages.getMessages();
    }

    @isTest
    static void testGoToAccount() {
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        ApexPages.StandardController stdController = new ApexPages.StandardController(testAccount);
        dtmDatosResellerController controller = new dtmDatosResellerController(stdController);

        PageReference pageRef = controller.goToAccount();
        System.assertEquals('/' + testAccount.Id, pageRef.getUrl());
        System.assertEquals(true, pageRef.getRedirect());
    }  
}