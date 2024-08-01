global with sharing  class dtmFormatoPrecios  implements Callable{
   public Object call(String action, Map<String, Object> args) {

        Map<String, Object> input = (Map<String, Object>)args.get('input');
        Map<String, Object> output = (Map<String, Object>)args.get('output');
        Map<String, Object> options = (Map<String, Object>)args.get('options');

        return invokeMethod(action, input, output, options);
    }
    public Boolean invokeMethod(String methodName, Map<String, Object> inputs, Map<String, Object> output, Map<String, Object> options){
         String result;


         switch on methodName {
            when 'formatearNumero'{
                List<Object> arguments = (List<Object>)inputs.get('arguments');
                String precio = (String)arguments[0];
                ///Decimal precios = (Decimal)arguments;
                System.debug('valor de entrada: '+precio);
                result =formatearNumero(precio);
                output.put('result',result );
                System.debug('result'+result);
            }
            when 'remplazarSaltoLinea'{

                List<Object> arguments = (List<Object>)inputs.get('arguments');
                String value = (String)arguments[0];
                result =remplazarSaltoLinea(value);
                output.put('result',result );

            }
            when 'llamarCalcularPrecios'{
                List<Object> arguments = (List<Object>)inputs.get('arguments');
                System.debug('Argumentos ..' + arguments);


            }
            when else {
                
            }
         }


    /**  if (methodName == 'formatearNumero'){
            
            List<Object> arguments = (List<Object>)inputs.get('arguments');
            String precio = (String)arguments[0];
            ///Decimal precios = (Decimal)arguments;
            System.debug('valor de entrada: '+precio);
           	result =formatearNumero(precio);
            output.put('result',result );
            System.debug('result'+result);

        }else if(methodName =='remplazarSaltoLinea'){
            
            List<Object> arguments = (List<Object>)inputs.get('arguments');
            String value = (String)arguments[0];
            result =remplazarSaltoLinea(value);
            output.put('result',result );

        } */
        return true;
    }


	public static String formatearNumero(String numero) {
        if (numero == null) {
            return '';
        }
        Decimal precio =Decimal.valueOf(numero);
        String numeroFormateado = String.valueOf(precio.format());
        //String numeroFormateado =numero;
        if (numeroFormateado.contains('.')) {
            String[] partes = numeroFormateado.split('\\.');
            String parteEntera = partes[0];
            String parteDecimal = partes.size() > 1 ? partes[1] : '00';
            if (parteDecimal.length() == 1) {
                parteDecimal += '0';
            } else if (parteDecimal.length() > 2) {
                parteDecimal = parteDecimal.substring(0, 2);
            }
            
            return parteEntera + '.' + parteDecimal;
        } else {
            return numeroFormateado + '.00';
        }
    }
    
     public static String remplazarSaltoLinea(String value) {
         if (value == null) {
            return '';
        }
         else{
            String textoFormateado = value.replace('\r\n', '<br>');
        	return textoFormateado;
         }   
    }

/**    public static String calcularPrecios(String value){
        
    } */
}