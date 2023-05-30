@isTest
public class InscripcionMassiveLeadControllerTest {
	
    public static testMethod void testLeadCase() {
        TestLeadCheck.insertSettings();
        
        Localidad__c loc = new Localidad__c(name = 'loc1', Pa_s__c = 'pais', Provincia__c = 'pcia', Zona_local__c = 'zona');
        insert loc;
        Localidad__c loc2 = new Localidad__c(name = 'loc2', Pa_s__c = 'pais', Provincia__c = 'pcia', Zona_local__c = 'zona');
        insert loc2;
        
        Actividad__c actividad1 = TestDataFactory.createActivity('1','Aprendiendo a Elegir','11/10/2012');
		
        Lead lead = new Lead();
        lead.FirstName = 'test';
        lead.LastName = 'test';
        lead.Email = 'test@test.com';
        lead.Phone = '123212312';
        lead.NumeroDocumento__c = '12123';
        
        
       
        ApexPages.currentPage().getParameters().put('id',actividad1.id);
        
        InscripcionMassiveLeadController  controller = new InscripcionMassiveLeadController();
        
        controller.passTest();
        controller.getLocalidades();
		controller.getPcias();
        
        
    }
}