@isTest 
public class dtmContratacionGisTest {
  
    @testSetUp  
    static void setUp(){
        Id  standardPb = Test.getStandardPricebookId();
        Account acc = new Account(Name = 'test',dtmCuentaMaestra__c='test');
        insert acc;
        Account acc2 = new Account(Name = 'testing',dtmCuentaMaestra__c='testing2');
        insert acc2;
        Account acc3 = new Account(Name = 'testing3',dtmCuentaMaestra__c='testing23');
        insert acc3;
        Account acc4 = new Account(Name = 'testing4',dtmCuentaMaestra__c='testing234');
        insert acc4;
        Account acc5 = new Account(Name = 'testing45',dtmCuentaMaestra__c='testing234');
        insert acc5;
        Account acc6 = new Account(Name = 'testing456',dtmCuentaMaestra__c='testing2346');
        insert acc6;
        dtmProyecto__c proy = new dtmProyecto__c(Name='77888');
        insert proy;
        dtmProyecto__c proy2 = new dtmProyecto__c(Name='778882');
        insert proy2;
        dtmProyecto__c proy3 = new dtmProyecto__c(Name='7788821');
        insert proy3;
        dtmProyecto__c proy4 = new dtmProyecto__c(Name='7788823');
        insert proy4;
        dtmProyecto__c proy5 = new dtmProyecto__c(Name='77888234');
        insert proy5;
        dtmProyecto__c proy6 = new dtmProyecto__c(Name='778882345');
        insert proy6;
        Opportunity oppor = new Opportunity(AccountId=acc.Id, Pricebook2Id = standardPb, Name='Testing', StageName='Negociación', closeDate=Date.Today(),dtmCUPID__c=proy.id);
        insert oppor;
        Opportunity oppor2 = new Opportunity(AccountId=acc2.Id,Pricebook2Id = standardPb, Name='Testing21', StageName='Negociación', closeDate=Date.Today(),dtmCUPID__c=proy2.id);
        insert oppor2;
        Opportunity oppor3 = new Opportunity(AccountId=acc3.Id,Pricebook2Id = standardPb, Name='Testing22', StageName='Negociación', closeDate=Date.Today(),dtmCUPID__c=proy3.id);
        insert oppor3;
        Opportunity oppor4 = new Opportunity(AccountId=acc4.Id,Pricebook2Id = standardPb, Name='Testing2233', StageName='Negociación', closeDate=Date.Today(),dtmCUPID__c=proy4.id);
        insert oppor4;
        Opportunity oppor5 = new Opportunity(AccountId=acc5.Id,Pricebook2Id = standardPb, Name='Testing22334', StageName='Negociación', closeDate=Date.Today(),dtmCUPID__c=proy5.id);
        insert oppor5;
        Opportunity oppor6 = new Opportunity(AccountId=acc6.Id,Pricebook2Id = standardPb, Name='Testing2233466', StageName='Negociación', closeDate=Date.Today(),dtmCUPID__c=proy6.id);
        insert oppor6;
        
        /*WIFI*/
        List<QuoteLineItem> listaPartidasWA = new List<QuoteLineItem>();
        Quote myQuoteWA = new Quote(Name='Test WIFI',OpportunityId = oppor2.Id, Pricebook2Id = standardPb);
        insert myQuoteWA;
        
        Product2 prodWA = new Product2(Name='Wifi Avanzado', IsActive=true,vlocity_cmt__SpecificationType__c = 'Offer',vlocity_cmt__SpecificationSubType__c='Bundle',dtmEmpresaPrestaServicios__c='UNINET',dtmPlataforma__c='GPON');
        insert prodWA;
        
        Product2 prodAccesPoint = new Product2(Name='Access Point Huawei 5760 CON POE', IsActive=true,vlocity_cmt__SpecificationType__c = 'Product',vlocity_cmt__SpecificationSubType__c='Simple',StockKeepingUnit='UNR.CUAD.TX.EB11',dtmProductSkuContratacion__c='UNC.CUAD.TX.EB1');
        insert prodAccesPoint;
        
        PricebookEntry pbprodWA = new PricebookEntry (Product2Id=prodWA.id,Pricebook2ID=standardPb,UnitPrice=50, isActive=true,UseStandardPrice = false);
        insert pbprodWA;
        
        QuoteLineItem itemprodWA= new QuoteLineItem(QuoteId = myQuoteWA.Id, PriceBookEntryID=pbprodWA.id,Quantity=1,dtmCodigoISOMoneda__c='USD', UnitPrice =pbprodWA.UnitPrice, Product2Id=pbprodWA.id, dtmNombresitio__c='70153230 TRAGER LOS REYES',vlocity_cmt__AttributeSelectedValues__c='{"ATT_INT_12M_24M_36M)":"36 Meses"}');
        listaPartidasWA.add(itemprodWA);
        
        QuoteLineItem itemprodAccesPoint = new QuoteLineItem(QuoteId = myQuoteWA.Id, PriceBookEntryID=pbprodWA.id,Quantity=1,dtmCodigoISOMoneda__c='USD', UnitPrice =pbprodWA.UnitPrice, Product2Id=prodAccesPoint.id,dtmNombresitio__c='70153230 TRAGER LOS REYES',vlocity_cmt__RecurringCharge__c=100.222,vlocity_cmt__OneTimeCharge__c=100.222);
        listaPartidasWA.add(itemprodAccesPoint);
        insert listaPartidasWA;
        /*WIFI*/
        
        /*WIFIANALITICO*/
        List<QuoteLineItem> listaPartidasWAnalatico = new List<QuoteLineItem>();
        Quote myQuoteWAnalitico = new Quote(Name='Test WIFIANALITICO',OpportunityId = oppor5.Id, Pricebook2Id = standardPb);
        insert myQuoteWAnalitico;
        
        Product2 prodWAnalitico = new Product2(Name='Wifi Analítico', IsActive=true,vlocity_cmt__SpecificationType__c = 'Offer',vlocity_cmt__SpecificationSubType__c='Bundle',dtmEmpresaPrestaServicios__c='UNINET',dtmPlataforma__c='GPON');
        insert prodWAnalitico;
        
        Product2 prodLicenciaAnaliticos = new Product2(Name='Licencia Analíticos', IsActive=true,vlocity_cmt__SpecificationType__c = 'Product',vlocity_cmt__SpecificationSubType__c='Simple',StockKeepingUnit='UNR.CUAD.TX.EB111',dtmProductSkuContratacion__c='UNC.CUAD.TX.EB11');
        insert prodLicenciaAnaliticos;
        
        PricebookEntry pbprodWAnalitico= new PricebookEntry (Product2Id=prodWAnalitico.id,Pricebook2ID=standardPb,UnitPrice=50, isActive=true,UseStandardPrice = false);
        insert pbprodWAnalitico;
        
        QuoteLineItem itemprodWAnalitico= new QuoteLineItem(QuoteId = myQuoteWAnalitico.Id, PriceBookEntryID=pbprodWAnalitico.id,Quantity=1,dtmCodigoISOMoneda__c='USD', UnitPrice =pbprodWAnalitico.UnitPrice, Product2Id=prodWAnalitico.id, dtmNombresitio__c='70153230 TRAGER LOS REYES',vlocity_cmt__AttributeSelectedValues__c='{"ATT_WIFIANALITICO_PLAZO":"36 Meses"}');
        listaPartidasWAnalatico.add(itemprodWAnalitico);
        
        QuoteLineItem itemprodLicenciaAnaliticos = new QuoteLineItem(QuoteId = myQuoteWAnalitico.Id, PriceBookEntryID=pbprodWAnalitico.id,Quantity=1,dtmCodigoISOMoneda__c='USD', UnitPrice =pbprodWAnalitico.UnitPrice, Product2Id=prodLicenciaAnaliticos.id,dtmNombresitio__c='70153230 TRAGER LOS REYES',vlocity_cmt__RecurringCharge__c=100.222,vlocity_cmt__OneTimeCharge__c=100.222);
        listaPartidasWAnalatico.add(itemprodLicenciaAnaliticos);
        insert listaPartidasWAnalatico;
        /*WIFIANALITICO*/
        
        /*IDN*/
        Quote myQuote = new Quote(Name='TestingIdn',OpportunityId = oppor.Id, Pricebook2Id = standardPb);
        insert myQuote;
        Product2 prod = new Product2(Name='Internet Directo Negocio', IsActive=true,vlocity_cmt__SpecificationType__c = 'Offer',vlocity_cmt__SpecificationSubType__c='Bundle',dtmEmpresaPrestaServicios__c='UNINET',dtmPlataforma__c='GPON');
        insert prod;
        Product2 prodAgrupador = new Product2(Name='10 MB', IsActive=true,vlocity_cmt__SpecificationType__c = 'Product',vlocity_cmt__SpecificationSubType__c='Bundle',dtmEmpresaPrestaServicios__c='UNINET',dtmPlataforma__c='GPON');
        insert prodAgrupador;
        
        Product2 prodServicioRenta = new Product2(Name='Servicio Renta', IsActive=true,vlocity_cmt__SpecificationType__c = 'Product',vlocity_cmt__SpecificationSubType__c='Simple',StockKeepingUnit='UNR_IDATA-50MB1');
        insert prodServicioRenta;
        Product2 prodServicioContratacion = new Product2(Name='Servicio Contratación', IsActive=true,vlocity_cmt__SpecificationType__c = 'Product',vlocity_cmt__SpecificationSubType__c='Simple',dtmProductSkuContratacion__c='UNC_IDATA-50MB');
        insert prodServicioContratacion;
        
        Product2 prodEquipoRenta = new Product2(Name='Equipo Renta', IsActive=true,vlocity_cmt__SpecificationType__c = 'Product',vlocity_cmt__SpecificationSubType__c='Simple',StockKeepingUnit='UNR_IDN.AR6111');
        insert prodEquipoRenta;
        Product2 prodEquipoContratacion = new Product2(Name='Equipo Contratación', IsActive=true,vlocity_cmt__SpecificationType__c = 'Product',vlocity_cmt__SpecificationSubType__c='Simple',dtmProductSkuContratacion__c='UNC_IDN.AR611');
        insert prodEquipoContratacion;
        
        Product2 prodPexaRenta = new Product2(Name='PEXA Renta', IsActive=true,vlocity_cmt__SpecificationType__c = 'Product',vlocity_cmt__SpecificationSubType__c='Simple',StockKeepingUnit='UNR_SA.PADM.WAN1');
        insert prodPexaRenta;
        Product2 prodPexaContratacion = new Product2(Name='PEXA Contratación', IsActive=true,vlocity_cmt__SpecificationType__c = 'Product',vlocity_cmt__SpecificationSubType__c='Simple',dtmProductSkuContratacion__c='UNC_SA.PADM.WAN');
        insert prodPexaContratacion;
        
        PricebookEntry pbe = new PricebookEntry (Product2Id=prod.id,Pricebook2ID=standardPb,UnitPrice=50, isActive=true,UseStandardPrice = false);
        insert pbe;
        QuoteLineItem item = new QuoteLineItem(QuoteId = myQuote.Id, PriceBookEntryID=pbe.id,Quantity=4,dtmCodigoISOMoneda__c='MXN', UnitPrice =pbe.UnitPrice, Product2Id=prod.id, dtmNombresitio__c='70153230 TRAGER LOS REYES',dtmModalidad__c='Bajo Demanda',dtmDireccionamiento__c='3', vlocity_cmt__AttributeSelectedValues__c='{"ATT_IDN_VELOCIDAD":null,"ATT_INT_12M_24M_36M)":"24 Meses"}');
        insert item;
        QuoteLineItem itemAgrupador = new QuoteLineItem(QuoteId = myQuote.Id, PriceBookEntryID=pbe.id,Quantity=1,dtmCodigoISOMoneda__c='MXN', UnitPrice =pbe.UnitPrice, Product2Id=prodAgrupador.id,dtmNombresitio__c='70153230 TRAGER LOS REYES',dtmModalidad__c='Bajo Demanda',dtmDireccionamiento__c='3');
        insert itemAgrupador;
        
        QuoteLineItem itemServicioRenta = new QuoteLineItem(QuoteId = myQuote.Id, PriceBookEntryID=pbe.id,Quantity=1,dtmCodigoISOMoneda__c='MXN', UnitPrice =pbe.UnitPrice, Product2Id=prodServicioRenta.id,dtmNombresitio__c='70153230 TRAGER LOS REYES',dtmModalidad__c='Bajo Demanda',dtmDireccionamiento__c='3',vlocity_cmt__RecurringCharge__c=0.1);
        insert itemServicioRenta;
        QuoteLineItem itemServicioContratacion = new QuoteLineItem(QuoteId = myQuote.Id, PriceBookEntryID=pbe.id,Quantity=1,dtmCodigoISOMoneda__c='MXN', UnitPrice =pbe.UnitPrice, Product2Id=prodServicioContratacion.id,dtmNombresitio__c='70153230 TRAGER LOS REYES',dtmModalidad__c='Bajo Demanda',dtmDireccionamiento__c='3',vlocity_cmt__OneTimeCharge__c=0.1);
        insert itemServicioContratacion;
        
        QuoteLineItem itemEquipoRenta = new QuoteLineItem(QuoteId = myQuote.Id, PriceBookEntryID=pbe.id,Quantity=1,dtmCodigoISOMoneda__c='MXN', UnitPrice =pbe.UnitPrice, Product2Id=prodEquipoRenta.id,dtmNombresitio__c='70153230 TRAGER LOS REYES',dtmModalidad__c='Bajo Demanda',dtmDireccionamiento__c='3',vlocity_cmt__RecurringCharge__c=0.1);
        insert itemEquipoRenta;
        QuoteLineItem itemEquipoContratacion = new QuoteLineItem(QuoteId = myQuote.Id, PriceBookEntryID=pbe.id,Quantity=1,dtmCodigoISOMoneda__c='MXN', UnitPrice =pbe.UnitPrice, Product2Id=prodEquipoContratacion.id,dtmNombresitio__c='70153230 TRAGER LOS REYES',dtmModalidad__c='Bajo Demanda',dtmDireccionamiento__c='3',vlocity_cmt__OneTimeCharge__c=0.1);
        insert itemEquipoContratacion;
        
        QuoteLineItem itemPexaRenta = new QuoteLineItem(QuoteId = myQuote.Id, PriceBookEntryID=pbe.id,Quantity=1,dtmCodigoISOMoneda__c='MXN', UnitPrice =pbe.UnitPrice, Product2Id=prodPexaRenta.id,dtmNombresitio__c='70153230 TRAGER LOS REYES',dtmModalidad__c='Bajo Demanda',dtmDireccionamiento__c='3',vlocity_cmt__RecurringCharge__c=0.1);
        insert itemPexaRenta;
        QuoteLineItem itemPexaContratacion = new QuoteLineItem(QuoteId = myQuote.Id, PriceBookEntryID=pbe.id,Quantity=1,dtmCodigoISOMoneda__c='MXN', UnitPrice =pbe.UnitPrice, Product2Id=prodPexaContratacion.id,dtmNombresitio__c='70153230 TRAGER LOS REYES',dtmModalidad__c='Bajo Demanda',dtmDireccionamiento__c='3',vlocity_cmt__OneTimeCharge__c=0.1);
        insert itemPexaContratacion;
        system.debug('myQuote: '+myQuote);
        /*IDN*/
        
        /*IDN2*/
        List<QuoteLineItem> listaPartida2 = new List<QuoteLineItem>();
        Quote myQuote2 = new Quote(Name='TestingIdn2',OpportunityId = oppor4.Id, Pricebook2Id = standardPb);
        insert myQuote2;
        Product2 prod2 = new Product2(Name='Internet Directo Negocio', IsActive=true,vlocity_cmt__SpecificationType__c = 'Offer',vlocity_cmt__SpecificationSubType__c='Bundle',dtmEmpresaPrestaServicios__c='UNINET',dtmPlataforma__c='GPON');
        insert prod2;
        Product2 prodAgrupador2 = new Product2(Name='20 MB', IsActive=true,vlocity_cmt__SpecificationType__c = 'Product',vlocity_cmt__SpecificationSubType__c='Bundle',dtmEmpresaPrestaServicios__c='UNINET',dtmPlataforma__c='GPON');
        insert prodAgrupador2;
        
        Product2 prodServicioRenta2 = new Product2(Name='Servicio Renta', IsActive=true,vlocity_cmt__SpecificationType__c = 'Product',vlocity_cmt__SpecificationSubType__c='Simple',StockKeepingUnit='UNR_IDATA-50MB12');
        insert prodServicioRenta2;
        Product2 prodServicioContratacion2 = new Product2(Name='Servicio Contratación', IsActive=true,vlocity_cmt__SpecificationType__c = 'Product',vlocity_cmt__SpecificationSubType__c='Simple',dtmProductSkuContratacion__c='UNC_IDATA-50MB2');
        insert prodServicioContratacion2;
        
        Product2 prodEquipoRenta2 = new Product2(Name='Equipo Renta', IsActive=true,vlocity_cmt__SpecificationType__c = 'Product',vlocity_cmt__SpecificationSubType__c='Simple',StockKeepingUnit='UNR_IDN.AR61112');
        insert prodEquipoRenta2;
        Product2 prodEquipoContratacion2 = new Product2(Name='Equipo Contratación', IsActive=true,vlocity_cmt__SpecificationType__c = 'Product',vlocity_cmt__SpecificationSubType__c='Simple',dtmProductSkuContratacion__c='UNC_IDN.AR6112');
        insert prodEquipoContratacion2;
        
        Product2 prodPexaRenta2 = new Product2(Name='PEXA Renta', IsActive=true,vlocity_cmt__SpecificationType__c = 'Product',vlocity_cmt__SpecificationSubType__c='Simple',StockKeepingUnit='UNR_SA.PADM.WAN12');
        insert prodPexaRenta2;
        Product2 prodPexaContratacion2 = new Product2(Name='PEXA Contratación', IsActive=true,vlocity_cmt__SpecificationType__c = 'Product',vlocity_cmt__SpecificationSubType__c='Simple',dtmProductSkuContratacion__c='UNC_SA.PADM.WAN2');
        insert prodPexaContratacion2;
        
        PricebookEntry pbe2 = new PricebookEntry (Product2Id=prod2.id,Pricebook2ID=standardPb,UnitPrice=10, isActive=true,UseStandardPrice = false);
        insert pbe2;
        QuoteLineItem item2 = new QuoteLineItem(QuoteId = myQuote2.Id, PriceBookEntryID=pbe2.id,Quantity=1,dtmCodigoISOMoneda__c='MXN', UnitPrice =pbe2.UnitPrice, Product2Id=prod2.id, dtmNombresitio__c='70153230 TRAGER LOS REYES',dtmModalidad__c='Bajo Demanda',dtmDireccionamiento__c='3', vlocity_cmt__AttributeSelectedValues__c='{"ATT_IDN_VELOCIDAD":null,"ATT_INT_12M_24M_36M)":"24 Meses"}');
        listaPartida2.add(item2);
        QuoteLineItem itemAgrupador2 = new QuoteLineItem(QuoteId = myQuote2.Id, PriceBookEntryID=pbe2.id,Quantity=1,dtmCodigoISOMoneda__c='MXN', UnitPrice =pbe2.UnitPrice, Product2Id=prodAgrupador2.id,dtmNombresitio__c='70153230 TRAGER LOS REYES',dtmModalidad__c='Bajo Demanda',dtmDireccionamiento__c='1');
        listaPartida2.add(itemAgrupador2);
        
        QuoteLineItem itemServicioRenta2 = new QuoteLineItem(QuoteId = myQuote2.Id, PriceBookEntryID=pbe2.id,Quantity=1,dtmCodigoISOMoneda__c='MXN', UnitPrice =pbe2.UnitPrice, Product2Id=prodServicioRenta2.id,dtmNombresitio__c='70153230 TRAGER LOS REYES',dtmModalidad__c='Bajo Demanda',dtmDireccionamiento__c='3',vlocity_cmt__RecurringCharge__c=0.1);
        listaPartida2.add(itemServicioRenta2);
        QuoteLineItem itemServicioContratacion2 = new QuoteLineItem(QuoteId = myQuote2.Id, PriceBookEntryID=pbe2.id,Quantity=1,dtmCodigoISOMoneda__c='MXN', UnitPrice =pbe2.UnitPrice, Product2Id=prodServicioContratacion2.id,dtmNombresitio__c='70153230 TRAGER LOS REYES',dtmModalidad__c='Bajo Demanda',dtmDireccionamiento__c='3',vlocity_cmt__OneTimeCharge__c=0.1);
        listaPartida2.add(itemServicioContratacion2);
        
        QuoteLineItem itemEquipoRenta2 = new QuoteLineItem(QuoteId = myQuote2.Id, PriceBookEntryID=pbe2.id,Quantity=1,dtmCodigoISOMoneda__c='MXN', UnitPrice =pbe2.UnitPrice, Product2Id=prodEquipoRenta2.id,dtmNombresitio__c='70153230 TRAGER LOS REYES',dtmModalidad__c='Bajo Demanda',dtmDireccionamiento__c='3',vlocity_cmt__RecurringCharge__c=0.1);
        listaPartida2.add(itemEquipoRenta2);
        QuoteLineItem itemEquipoContratacion2 = new QuoteLineItem(QuoteId = myQuote2.Id, PriceBookEntryID=pbe2.id,Quantity=1,dtmCodigoISOMoneda__c='MXN', UnitPrice =pbe2.UnitPrice, Product2Id=prodEquipoContratacion2.id,dtmNombresitio__c='70153230 TRAGER LOS REYES',dtmModalidad__c='Bajo Demanda',dtmDireccionamiento__c='3',vlocity_cmt__OneTimeCharge__c=0.1);
        listaPartida2.add(itemEquipoContratacion2);
        
        QuoteLineItem itemPexaRenta2 = new QuoteLineItem(QuoteId = myQuote2.Id, PriceBookEntryID=pbe2.id,Quantity=1,dtmCodigoISOMoneda__c='MXN', UnitPrice =pbe2.UnitPrice, Product2Id=prodPexaRenta2.id,dtmNombresitio__c='70153230 TRAGER LOS REYES',dtmModalidad__c='Bajo Demanda',dtmDireccionamiento__c='3',vlocity_cmt__RecurringCharge__c=0.1);
        listaPartida2.add(itemPexaRenta2);
        QuoteLineItem itemPexaContratacion2 = new QuoteLineItem(QuoteId = myQuote2.Id, PriceBookEntryID=pbe2.id,Quantity=1,dtmCodigoISOMoneda__c='MXN', UnitPrice =pbe2.UnitPrice, Product2Id=prodPexaContratacion2.id,dtmNombresitio__c='70153230 TRAGER LOS REYES',dtmModalidad__c='Bajo Demanda',dtmDireccionamiento__c='3',vlocity_cmt__OneTimeCharge__c=0.1);
        listaPartida2.add(itemPexaContratacion2);
        insert listaPartida2;
        /*IDN2*/
        
        /*SDWAN*/
        List<QuoteLineItem> listaPartida = new List<QuoteLineItem>();
        Quote myQuoteSD = new Quote(Name='TestSD',OpportunityId = oppor3.Id, Pricebook2Id = standardPb);
        insert myQuoteSD;
        
        Product2 prodSD = new Product2(Name='SD WAN Telmex', IsActive=true,vlocity_cmt__SpecificationType__c = 'Offer',vlocity_cmt__SpecificationSubType__c='Simple');
        insert prodSD;

        Product2 prodMx67SD = new Product2(Name='MX67 CON SEGURIDAD AVANZADA', IsActive=true,vlocity_cmt__SpecificationType__c = 'Product',vlocity_cmt__SpecificationSubType__c='Simple',StockKeepingUnit='909090',dtmProductSkuContratacion__c='919191');
        insert prodMx67SD;
        
        PriceBookEntry pre = new PriceBookEntry(
            IsActive = true,
            PriceBook2Id = Test.getStandardPricebookId(), 
            Product2Id = prodMx67SD.Id , 
            UnitPrice=0);
        insert pre;
        PricebookEntry pbeSD = new PricebookEntry (Product2Id=prodSD.id,Pricebook2ID=standardPb,UnitPrice=1, isActive=true,UseStandardPrice = false);
        insert pbeSD;
        
        QuoteLineItem itemSD = new QuoteLineItem(QuoteId = myQuoteSD.Id, PriceBookEntryID=pbeSD.id,Quantity=1,dtmCodigoISOMoneda__c='MXN', UnitPrice =pbeSD.UnitPrice, Product2Id=prodSD.id, dtmNombresitio__c='701532312222 test',vlocity_cmt__AttributeSelectedValues__c='{"ATT_PLZ_12M_24M_36M":"24 meses"}');
        listaPartida.add(itemSD);
        QuoteLineItem itemMx67 = new QuoteLineItem(QuoteId = myQuoteSD.Id, PriceBookEntryID=pre.id,Quantity=1,dtmCodigoISOMoneda__c='MXN', UnitPrice =pre.UnitPrice, Product2Id=prodMx67SD.id,dtmNombresitio__c='7015323122222 test',vlocity_cmt__RecurringCharge__c=1.1233,vlocity_cmt__OneTimeCharge__c=7.8122);
        listaPartida.add(itemMx67);
        insert listaPartida;
        system.debug('myQuoteSD: '+myQuoteSD);
        /*SDWAN*/
        
        /*CENTRODATOS*/
        List<QuoteLineItem> listaPartidasCentro = new List<QuoteLineItem>();
        Quote myQuoteCentro = new Quote(Name='TestCentro',OpportunityId = oppor6.Id, Pricebook2Id = standardPb);
        insert myQuoteCentro;
        
        Product2 prodCentro = new Product2(Name='Centro de Datos de Alta Disponibilidad', IsActive=true,vlocity_cmt__SpecificationType__c = 'Offer',vlocity_cmt__SpecificationSubType__c='Bundle',dtmEmpresaPrestaServicios__c='UNINET',dtmPlataforma__c='GPON');
        insert prodCentro;
        
        Product2 prodCoubicacion = new Product2(Name='Co-Ubicación (Triara) ICREA V', IsActive=true,vlocity_cmt__SpecificationType__c = 'Product',vlocity_cmt__SpecificationSubType__c='Simple',StockKeepingUnit='UNR.CUAD.TX.EB112',dtmProductSkuContratacion__c='UNC.CUAD.TX.EB12');
        insert prodCoubicacion;
        
        PricebookEntry pbprodCentro = new PricebookEntry (Product2Id=prodCentro.id,Pricebook2ID=standardPb,UnitPrice=50, isActive=true,UseStandardPrice = false);
        insert pbprodCentro;
        
        QuoteLineItem itemprodCentro= new QuoteLineItem(QuoteId = myQuoteCentro.Id, PriceBookEntryID=pbprodCentro.id,Quantity=1,dtmCodigoISOMoneda__c='USD', UnitPrice =pbprodCentro.UnitPrice, Product2Id=prodCentro.id, dtmNombresitio__c='70153230 TRAGER LOS REYES',vlocity_cmt__AttributeSelectedValues__c='{"ATT_WIFIOBJECT_PLAZO":"36 Meses"}');
        listaPartidasCentro.add(itemprodCentro);
        
        QuoteLineItem itemprodCoubicacion = new QuoteLineItem(QuoteId = myQuoteCentro.Id, PriceBookEntryID=pbprodCentro.id,Quantity=1,dtmCodigoISOMoneda__c='USD', UnitPrice =pbprodCentro.UnitPrice, Product2Id=prodCoubicacion.id,dtmNombresitio__c='70153230 TRAGER LOS REYES',vlocity_cmt__RecurringCharge__c=100.222,vlocity_cmt__OneTimeCharge__c=100.222);
        listaPartidasCentro.add(itemprodCoubicacion);
        insert listaPartidasCentro;
        /*CENTRODATOS*/
    }
    @isTest 
    static void emptyJsonSD(){
        String entradaDatos3 = [SELECT Id FROM Quote WHERE Name = 'TestSD' LIMIT 1].Id;
        dtmContratacionGis.dtmContratacionGisResponse myResponse3= new dtmContratacionGis.dtmContratacionGisResponse();
        test.setMock(HttpCalloutMock.class, new MockHttp());
        test.StartTest();
        dtmContratacionGis.procesarSolicitud(entradaDatos3);
        myResponse3.toMap();
        test.StopTest();
    }
    @isTest 
    static void emptyJsonCentro(){
        String entradaDatos9 = [SELECT Id FROM Quote WHERE Name = 'TestCentro' LIMIT 1].Id;
        dtmContratacionGis.dtmContratacionGisResponse myResponse9= new dtmContratacionGis.dtmContratacionGisResponse();
        test.setMock(HttpCalloutMock.class, new MockHttp());
        test.StartTest();
        dtmContratacionGis.procesarSolicitud(entradaDatos9);
        myResponse9.toMap();
        test.StopTest();
    }
    
    @isTest 
    static void emptyJson(){
        String entradaDatos = [SELECT Id FROM Quote WHERE Name = 'TestingIdn' LIMIT 1].Id;
        dtmContratacionGis.dtmContratacionGisResponse myResponse= new dtmContratacionGis.dtmContratacionGisResponse();
        test.setMock(HttpCalloutMock.class, new MockHttp());
        test.StartTest();
        dtmContratacionGis.procesarSolicitud(entradaDatos);
        myResponse.toMap();
        test.StopTest();
    }
    @isTest 
    static void emptyJson6(){
        String entradaDatos6 = [SELECT Id FROM Quote WHERE Name = 'TestingIdn2' LIMIT 1].Id;
        dtmContratacionGis.dtmContratacionGisResponse myResponse6= new dtmContratacionGis.dtmContratacionGisResponse();
        test.setMock(HttpCalloutMock.class, new MockHttp());
        test.StartTest();
        dtmContratacionGis.procesarSolicitud(entradaDatos6);
        myResponse6.toMap();
        test.StopTest();
    }
    @isTest 
    static void emptyJson7(){
        String entradaDatos7 = [SELECT Id FROM Quote WHERE Name = 'Test WIFIANALITICO' LIMIT 1].Id;
        dtmContratacionGis.dtmContratacionGisResponse myResponse7= new dtmContratacionGis.dtmContratacionGisResponse();
        test.setMock(HttpCalloutMock.class, new MockHttp());
        test.StartTest();
        dtmContratacionGis.procesarSolicitud(entradaDatos7);
        myResponse7.toMap();
        test.StopTest();
    }
    @isTest 
    static void emptyJsonWifi(){
        String entradaDatos2 = [SELECT Id FROM Quote WHERE Name = 'Test WIFI' LIMIT 1].Id;
        dtmContratacionGis.dtmContratacionGisResponse myResponse2= new dtmContratacionGis.dtmContratacionGisResponse();
        test.setMock(HttpCalloutMock.class, new MockHttp());
        test.StartTest();
        dtmContratacionGis.procesarSolicitud(entradaDatos2);
        myResponse2.toMap();
        test.StopTest();
    }
    
    @isTest
    static void emptyJsonWrongCode(){
        String entradaDatos = [SELECT Id FROM Quote WHERE Name = 'TestingIdn' LIMIT 1].Id;
        test.setMock(HttpCalloutMock.class, new MockHttpWrong());
        test.StartTest(); 
		dtmContratacionGis.procesarSolicitud(entradaDatos);
		test.StopTest();
    }

    private class MockHttp implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
             response.setBody('{"statusCode":200,"id":12345}');
            response.setStatusCode(200);
            return response;
        }
    }
    
    private class MockHttpWrong implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"statusCode":400,"userMenssage":"Error occurred","severety":"HIGH","errors":["error1","error2"]}');
            response.setStatusCode(100);
            return response;
        }
    }
}