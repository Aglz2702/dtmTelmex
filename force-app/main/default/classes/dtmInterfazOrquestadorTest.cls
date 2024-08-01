@IsTest
public class dtmInterfazOrquestadorTest {
    @IsTest
    static void testObtenerSitioGis() {
        Map<String, Object> input = new Map<String, Object>();
        input.put('palabraClave', 'obtenerSitioGis');
        input.put('cuce', '123');
        input.put('quoteId', '456');
        input.put('accountId', '789');
        
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Test.startTest();
        Boolean result = dtmInterfazOrquestador.invokeMethod('call', input, output, options);
        Test.stopTest();
    }

    @IsTest
    static void testContratacionGis() {
        Map<String, Object> input = new Map<String, Object>();
        input.put('palabraClave', 'contratacionGis');
        input.put('quoteId', '456');
        
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Test.startTest();
        Boolean result = dtmInterfazOrquestador.invokeMethod('call', input, output, options);
        Test.stopTest();
    }

    @IsTest
    static void testListaDeProductosOdin() {
        Map<String, Object> input = new Map<String, Object>();
        input.put('palabraClave', 'listaDeProductosOdin');
        
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Test.startTest();
        Boolean result = dtmInterfazOrquestador.invokeMethod('call', input, output, options);
        Test.stopTest();
    }

    @IsTest
    static void testAltaDeResellerOdin() {
        Map<String, Object> input = new Map<String, Object>();
        input.put('palabraClave', 'altaDeResellerOdin');
        input.put('accountId', '789');
        
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Test.startTest();
        Boolean result = dtmInterfazOrquestador.invokeMethod('call', input, output, options);
        Test.stopTest();
    }

    @IsTest
    static void testAltaDeCuentaResellerOdin() {
        Map<String, Object> input = new Map<String, Object>();
        input.put('palabraClave', 'altaDeCuentaResellerOdin');
        input.put('accountId', '789');
        
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Test.startTest();
        Boolean result = dtmInterfazOrquestador.invokeMethod('call', input, output, options);
        Test.stopTest();
    }

    @IsTest
    static void testValidaDominioOdin() {
        Map<String, Object> input = new Map<String, Object>();
        input.put('palabraClave', 'validaDominioOdin');
        
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Test.startTest();
        Boolean result = dtmInterfazOrquestador.invokeMethod('call', input, output, options);
        Test.stopTest();
    }

    @IsTest
    static void testTomaDePedidoOdin() {
        Map<String, Object> input = new Map<String, Object>();
        input.put('palabraClave', 'tomaDePedidoOdin');
        input.put('quoteId', '456');
        
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Test.startTest();
        Boolean result = dtmInterfazOrquestador.invokeMethod('call', input, output, options);
        Test.stopTest();
    }

    @IsTest
    static void testEnviarContratacionNmp() {
        Map<String, Object> input = new Map<String, Object>();
        input.put('palabraClave', 'enviarContratacionNmp');
        input.put('quoteId', '456');
        
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Test.startTest();
        Boolean result = dtmInterfazOrquestador.invokeMethod('call', input, output, options);
        Test.stopTest();
    }

    @IsTest
    static void testPalabraClaveInvalida() {
        Map<String, Object> input = new Map<String, Object>();
        input.put('palabraClave', 'palabraClaveInvalida');
        
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Test.startTest();
        Boolean result = dtmInterfazOrquestador.invokeMethod('call', input, output, options);
        Test.stopTest();
    }
}