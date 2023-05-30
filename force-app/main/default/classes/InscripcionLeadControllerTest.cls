@isTest
public class InscripcionLeadControllerTest {
	
    public static testMethod void testLeadCase() {
        TestLeadCheck.insertSettings();
        Account noInforma = TestDataFactory.createNoInformaAccount();
        Localidad__c loc = new Localidad__c(name = 'loc1', Pa_s__c = 'pais', Provincia__c = 'pcia', Zona_local__c = 'zona');
        insert loc;
        Localidad__c loc2 = new Localidad__c(name = 'loc2', Pa_s__c = 'pais', Provincia__c = 'pcia', Zona_local__c = 'zona');
        insert loc2;
        
        Actividad__c actividad1 = TestDataFactory.createActivity('1','Aprendiendo a Elegir','11/10/2012');
        Curso__c curso1 = TestDataFactory.createCourse('1');

        Lead creada = TestDataFactory.createOneLeadForCase();
		InscripcionLeadController controller = new InscripcionLeadController();
        Lead lead = new Lead();
        lead.FirstName = 'test';
        lead.LastName = 'test';
        lead.Email = 'test@test.com';
        controller.optUno = '1 ';
        controller.optUno = '2 ';
        controller.optUno = '3 ';
        lead.ActividadID__c = actividad1.id;
        lead.CursoID__c = curso1.id;
        lead.Company  = 'test';
        controller.lead = lead;
        controller.save();
        
        controller.getLocalidades();
		controller.getPcias();
        
        controller = new InscripcionLeadController();
        Lead lead2 = new Lead();
        lead2.FirstName = 'test';
        lead2.LastName = 'test';
        lead2.Email = 'test@test.com';
        controller.optUno = '1 ';
        controller.optUno = '2 ';
        controller.optUno = '3 ';
        lead2.ActividadID__c = actividad1.id;
        lead2.CursoID__c = curso1.id;
        lead2.CaseDescription__c = 'tes';
        lead2.CaseReason__c = 'test';
        lead2.CaseSubject__c = 'fa';
        lead2.CaseType__c = 'test';
        lead2.Company  = 'test';
        controller.lead = lead2;
        controller.save();
    }
    
}