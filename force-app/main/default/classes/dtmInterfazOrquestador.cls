global class dtmInterfazOrquestador implements vlocity_cmt.VlocityOpenInterface{
    
    public static Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> output, Map<String, Object> options) { 
        Boolean result = true;
        try{
            call(input, output, options);                          
        } catch(Exception e) {
            result = false;
        }   
        return result;
    }
    public static void call(Map<String, Object> input, Map<String, Object> output, Map<String, Object> options){
        System.debug('Se recibio en args: '+input);
        String palabraClave = (String) input.get('palabraClave');
        String cuce = (String) input.get('cuce');
        String quoteId = (String) input.get('quoteId');
        String accountId = (String) input.get('accountId');
        system.debug('cuce: '+cuce);
        
        Map<String, Object> resultadoMap = new Map<String, Object>();
        switch on palabraClave {
            when 'obtenerSitioGis'{
                dtmObtenerSitio.dtmObtenerSitioResponse resultado = dtmObtenerSitio.procesarSolicitud(input);
                System.debug('Se obtuvo el resultado de la integración: ' + resultado);
                resultadoMap.putAll(resultado.toMap());
            }
            when 'contratacionGis'{
               dtmContratacionGis.dtmContratacionGisResponse resultado = dtmContratacionGis.procesarSolicitud(quoteId);
                System.debug('Se obtuvo el resultado de la integración: ' + resultado);
                resultadoMap.putAll(resultado.toMap());
            }
            when 'listaDeProductosOdin'{
                dtmListadoProductosOdin.dtmListadoProductosOdinResponse resultado = dtmListadoProductosOdin.procesarSolicitud(quoteId);
                System.debug('Se obtuvo el resultado de la integración: ' + resultado);
                resultadoMap.putAll(resultado.toMap());
            }
            when 'altaDeResellerOdin'{
                dtmAltaDeReseller.dtmAltaDeResellerResponse resultado = dtmAltaDeReseller.procesarSolicitud(accountId);
                System.debug('Se obtuvo el resultado de la integración: ' + resultado);
                resultadoMap.putAll(resultado.toMap());
            }
            when 'altaDeCuentaResellerOdin'{
                dtmAltaDeCuentaEnReseller.dtmAltaDeCuentaEnResellerResponse resultado = dtmAltaDeCuentaEnReseller.procesarSolicitud(accountId);
                System.debug('Se obtuvo el resultado de la integración: ' + resultado);
                resultadoMap.putAll(resultado.toMap());
            }
            when 'validaDominioOdin'{
                dtmValidaDominio.dtmValidaDominioResponse resultado = dtmValidaDominio.procesarSolicitud(input);
                System.debug('Se obtuvo el resultado de la integración: ' + resultado);
                resultadoMap.putAll(resultado.toMap());
            }
            when 'tomaDePedidoOdin'{
                dtmTomaPedidoOdin.dtmTomaPedidoOdinResponse resultado = dtmTomaPedidoOdin.procesarSolicitud(quoteId);
                System.debug('Se obtuvo el resultado de la integración: ' + resultado);
                resultadoMap.putAll(resultado.toMap()); 
            }
            when 'enviarContratacionNmp'{
                dtmContratacionNmp.dtmContratacionNmpResponse resultado = dtmContratacionNmp.procesarSolicitud(quoteId);
                System.debug('Se obtuvo el resultado de la integración: ' + resultado);
                resultadoMap.putAll(resultado.toMap()); 
            }
            when else{
                System.debug('Palabra clave no válida: ' + palabraClave);
                resultadoMap.put('error', 'Palabra clave no válida: ' + palabraClave);
            }
            
        }
        output.put('data', resultadoMap);
        
    }
    
}