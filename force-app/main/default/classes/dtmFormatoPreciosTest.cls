@isTest
public class dtmFormatoPreciosTest {

    @isTest
    static void testInvokeMethod() {
        dtmFormatoPrecios formatoPrecios = new dtmFormatoPrecios();
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        List<Object> arguments = new List<Object>{ '1234.567' };
        input.put('arguments', arguments);
        formatoPrecios.invokeMethod('formatearNumero', input, output, options);
        String result = (String) output.get('result');
        System.assertEquals('1,234.56', result, 'El número formateado es incorrecto');
    }

    @isTest
    static void testFormatearNumero() {
        String result = dtmFormatoPrecios.formatearNumero(null);
        System.assertEquals('', result, 'El número formateado debería ser una cadena vacía');
        result = dtmFormatoPrecios.formatearNumero('1234.567');
        System.assertEquals('1,234.56', result, 'El número formateado es incorrecto');
        result = dtmFormatoPrecios.formatearNumero('1234');
        System.assertEquals('1,234.00', result, 'El número formateado es incorrecto');
        result = dtmFormatoPrecios.formatearNumero('1234.5');
        System.assertEquals('1,234.50', result, 'El número formateado es incorrecto');
        result = dtmFormatoPrecios.formatearNumero('1234.56');
        System.assertEquals('1,234.56', result, 'El número formateado es incorrecto');
        result = dtmFormatoPrecios.formatearNumero('1234.56789');
        System.assertEquals('1,234.56', result, 'El número formateado es incorrecto');
    }

    @isTest
    static void testCall() {
        dtmFormatoPrecios formatoPrecios = new dtmFormatoPrecios();
        Map<String, Object> args = new Map<String, Object>();
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        List<Object> arguments = new List<Object>{ '1234.567' };
        input.put('arguments', arguments);
        args.put('input', input);
        args.put('output', output);
        args.put('options', options);
        Object result = formatoPrecios.call('formatearNumero', args);
        String formattedResult = (String) output.get('result');
        System.assertEquals('1,234.56', formattedResult, 'El número formateado es incorrecto');
    }

    @isTest
    static void testInvokeMethod_llamarCalcularPrecios() {
        dtmFormatoPrecios formatoPrecios = new dtmFormatoPrecios();
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        List<Object> arguments = new List<Object>{ 'testArgument' };
        input.put('arguments', arguments);
        Boolean result = formatoPrecios.invokeMethod('llamarCalcularPrecios', input, output, options);
        System.assert(result, 'El método llamarCalcularPrecios no se ejecutó correctamente');
    }

    @isTest
    static void testInvokeMethod_unknownMethod() {
        dtmFormatoPrecios formatoPrecios = new dtmFormatoPrecios();
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        List<Object> arguments = new List<Object>{ 'testArgument' };
        input.put('arguments', arguments);
        Boolean result = formatoPrecios.invokeMethod('unknownMethod', input, output, options);
        System.assert(result, 'El método unknownMethod no se ejecutó correctamente');
    }
}