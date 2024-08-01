public class Telmex_CreacionCUPController {
    private final Opportunity opp;
    public String vTexto { get; set; }
    
    public Telmex_CreacionCUPController(ApexPages.StandardController stdController) {
        this.opp = (Opportunity)stdController.getRecord();
        this.vTexto = '';
    }
    
    public PageReference CupNuevo() {
        Map<String, Object> input = new Map<String, Object>();
        input.put('ContextId', opp.Id);

        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        try {
            Telmex_CreationCUP.invokeMethod('getCUP', input, output, options);

            if (output.containsKey('errorMessage')) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, (String)output.get('errorMessage')));
            } else if (output.containsKey('successMessage')) {
                vTexto = (String)output.get('successMessage');
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, (String)output.get('successMessage')));
            }
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error al invocar el método getCUP: ' + e.getMessage()));
        }

        return null;
    }
    public PageReference goToOpportunity() {
        PageReference pageRef = new PageReference('/' + opp.Id);
        pageRef.setRedirect(true);
        return pageRef;
    }
}