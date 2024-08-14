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
            
            when 'llamarCalcularPrecios'{
                List<Object> arguments = (List<Object>)inputs.get('arguments');
                System.debug('Argumentos ..' + arguments);


            }
            when else {
                
            }
         }
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
    
      public static  void calculateTotalPrice(Id quoteId) {
       Decimal totalPrice = 0;
       // Mapas para almacenar los productos hijos, nietos y bisnietos
       Map<Id, List<QuoteLineItem>> childItemsMap = new Map<Id, List<QuoteLineItem>>(); //child child
       Map<Id, List<QuoteLineItem>> grandchildItemsMap = new Map<Id, List<QuoteLineItem>>();//child rack
       Map<Id, List<QuoteLineItem>> greatGrandchildItemsMap = new Map<Id, List<QuoteLineItem>>();//rack
       List<String> quoteLineItemParentId = new List<String>();
          List<String> quoteLineItemChildId = new List<String>();
       // Obtener todos los QuoteLineItems relacionados en una sola consulta
       List<QuoteLineItem> partidas =[SELECT Id,Description,Quantity,vlocity_cmt__AssetReferenceId__c,vlocity_cmt__ParentItemId__c,vlocity_cmt__BaseRecurringCharge__c 
                                                   FROM QuoteLineItem WHERE QuoteId =:quoteId  and Description LIKE 'Rack%' 
                                             		];
        System.debug('Productos Padre: '+partidas);
        for(QuoteLineItem p:partidas){
            quoteLineItemParentId.add(p.vlocity_cmt__AssetReferenceId__c);
            greatGrandchildItemsMap.put(p.vlocity_cmt__AssetReferenceId__c,new List<QuoteLineItem>());
             
        }
        System.debug('racks ids asset: '+quoteLineItemParentId);
        List<QuoteLineItem> childOfRacks=[SELECT Id,Description,Quantity,vlocity_cmt__AssetReferenceId__c,vlocity_cmt__ParentItemId__c,vlocity_cmt__BaseRecurringCharge__c 
                                                   FROM QuoteLineItem WHERE QuoteId=:quoteId AND vlocity_cmt__ParentItemId__c IN:quoteLineItemParentId ];
          System.debug('ids partidas hijos'+childOfRacks);
          System.debug('size primer capa hijos de rack: '+childOfRacks.size());
          Id parentAssetId='';
          for(QuoteLineItem p:childOfRacks){
              parentAssetId=p.vlocity_cmt__ParentItemId__c;
              quoteLineItemChildId.add(p.vlocity_cmt__AssetReferenceId__c);
              if(greatGrandchildItemsMap.containsKey(parentAssetId)){
                  grandchildItemsMap.get(parentAssetId).add(p);
                  
              }
        }
        System.debug('racks ids asset: '+quoteLineItemChildId);
          List<QuoteLineItem> childOfChildRacks=[SELECT Id,Description,Quantity,vlocity_cmt__AssetReferenceId__c,vlocity_cmt__ParentItemId__c,vlocity_cmt__BaseRecurringCharge__c 
                                                   FROM QuoteLineItem WHERE QuoteId=:quoteId AND vlocity_cmt__ParentItemId__c IN:quoteLineItemChildId ];   
          System.debug('ids partidas hijos de hijosRack'+childOfChildRacks);
          System.debug('size segunda capa hijos de hijos rack: '+childOfChildRacks.size());
        
          
    }
      
}