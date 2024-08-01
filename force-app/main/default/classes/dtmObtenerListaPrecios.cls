public class dtmObtenerListaPrecios {

    public static void prueba(String IdQuote){
        QuoteLineItem qLine=[SELECT Id FROM QuoteLineItem WHERE QuoteId =:IdQuote];
    }
}