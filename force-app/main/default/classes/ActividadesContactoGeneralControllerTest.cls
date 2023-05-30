@isTest
public class ActividadesContactoGeneralControllerTest {

    
    public static testMethod void testPadre() {
        
        TestLeadCheck.insertSettings();

        Localidad__c loc = new Localidad__c(name = 'loc1', Pa_s__c = 'pais', Provincia__c = 'pcia', Zona_local__c = 'zona');
        insert loc;
        Localidad__c loc2 = new Localidad__c(name = 'loc2', Pa_s__c = 'pais', Provincia__c = 'pcia', Zona_local__c = 'zona');
        insert loc2;
        
        Actividad__c actividad1 = TestDataFactory.createActivity('1','Aprendiendo a Elegir','11/10/2012');
        Actividad__c actividad2 = TestDataFactory.createActivity('2','Aprendiendo a Elegir2','11/10/2012');

        ActividadesContactoGeneralController controller = new ActividadesContactoGeneralController();
        
        controller.optPersona = 'Padre';
        
        Lead lead = new Lead();
        lead.FirstName = 'test';
        lead.LastName = 'test';
        lead.Email = 'test@test.com';
        lead.mobilePhone = '1232312';
        
        Lead leadHijo = new Lead();
        leadHijo.FirstName = 'test';
        leadHijo.LastName = 'test';
        leadHijo.Email = 'test2@test.com';
               
        
        controller.lead = lead;
        controller.leadHijo = leadHijo;
        
        List<String> acts = new List<String>{actividad1.id,actividad2.id};
        
        controller.actividades = acts;
        
        controller.save();
        
        controller.getLocalidades();
        controller.getPcias();
        
        List<Contact> cts = [SELECT id FROM Contact];
      
        System.assertNotEquals(null,cts);
        
    }
    public static testMethod void testCol() {
        
        TestLeadCheck.insertSettings();

        Localidad__c loc = new Localidad__c(name = 'loc1', Pa_s__c = 'pais', Provincia__c = 'pcia', Zona_local__c = 'zona');
        insert loc;
        Localidad__c loc2 = new Localidad__c(name = 'loc2', Pa_s__c = 'pais', Provincia__c = 'pcia', Zona_local__c = 'zona');
        insert loc2;
        
        Actividad__c actividad1 = TestDataFactory.createActivity('1','Aprendiendo a Elegir','11/10/2012');
        Actividad__c actividad2 = TestDataFactory.createActivity('2','Aprendiendo a Elegir2','11/10/2012');

        ApexPages.currentPage().getParameters().put('actividades',actividad1.id + ';' + actividad2.id);
        ActividadesContactoGeneralController controller = new ActividadesContactoGeneralController();
        
        controller.optPersona = 'Col';
        
        Lead lead = new Lead();
        lead.FirstName = 'test';
        lead.LastName = 'test';
        lead.Email = 'test@test.com';
        lead.CargoColegio__c = 'CARGO';
        lead.Localidad__c = loc.id;
        lead.Nombre_de_cuenta_web__c = 'ada';
        
        controller.leadProf = lead;
        
          
        List<String> acts = new List<String>{actividad1.id,actividad2.id};
        
        controller.actividades = acts;
        
        controller.save();
        
        controller.getLocalidades();
        controller.getPcias();
        
        List<Contact> cts = [SELECT id FROM Contact];
      
        System.assertNotEquals(null,cts);
        
    }
}