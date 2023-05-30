/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class InscripcionUdesaCampControllerTest {

    static testMethod void myUnitTest() {
         
        // TO DO: implement unit test
        
        TestLeadCheck.insertSettings();
        Account noInforma = TestDataFactory.createNoInformaAccount();
        Localidad__c loc = new Localidad__c(name = 'loc1', Pa_s__c = 'pais', Provincia__c = 'pcia', Zona_local__c = 'zona');
        insert loc;
        Localidad__c loc2 = new Localidad__c(name = 'loc2', Pa_s__c = 'pais', Provincia__c = 'pcia', Zona_local__c = 'zona');
        insert loc2;
        
        Campaign camp =  new Campaign();
        camp.IsActive = true;
        camp.Name = 'test';
        
        insert camp;
        InscripcionUdesaCampController controller = new InscripcionUdesaCampController();
        
        controller.idCampaign = camp.id;
        
        
        
        Contact ct  = new Contact();
        ct.email = 'test@test.com';
        ct.lastname = 'test';
        
        insert ct;
        
        Lead representante = new Lead();
        representante.FirstName = 'test';
        representante.LastName = 'test';
        representante.Email = 'test@test.com';
        representante.Nombre_de_cuenta_web__c = 'test';
        
        controller.representante = representante;
        
        Lead integrante1 = new Lead();
        integrante1.FirstName = 'test';
        integrante1.LastName = 'test';
        integrante1.Email = 'test@test2.com';
        integrante1.Nombre_de_cuenta_web__c = 'test';
        
        controller.integrante1 = integrante1;
        
        Lead integrante2 = new Lead();
        integrante2.FirstName = 'test';
        integrante2.LastName = 'test';
        integrante2.Email = 'test@test3.com';
        integrante2.Nombre_de_cuenta_web__c = 'test';
         
        controller.integrante2 = integrante2;
        
        Lead integrante3 = new Lead();
        integrante3.FirstName = 'test';
        integrante3.LastName = 'test';
        integrante3.Email = 'test@test4.com';
        integrante3.Nombre_de_cuenta_web__c = 'test';
        
        controller.integrante3 = integrante3;
        
        Lead mentor = new Lead();
        mentor.FirstName = 'test';
        mentor.LastName = 'test';
        mentor.Email = 'test@test5.com';
        mentor.Nombre_de_cuenta_web__c = 'test';
        
        controller.mentor = mentor;
        
        controller.save();
        
        
        representante = new Lead();
        representante.FirstName = 'test';
        representante.LastName = 'test';
        representante.Email = 'test11@test11.com1';
        representante.Nombre_de_cuenta_web__c = 'test';
        
        controller.representante = representante;
        
        integrante1 = new Lead();
        integrante1.FirstName = 'test';
        integrante1.LastName = 'test';
        integrante1.Email = 'test@test2.com2';
        integrante1.Nombre_de_cuenta_web__c = 'test';
        
        controller.integrante1 = integrante1;
        
        integrante2 = new Lead();
        integrante2.FirstName = 'test';
        integrante2.LastName = 'test';
        integrante2.Email = 'test@test3.com';
        integrante2.Nombre_de_cuenta_web__c = 'test';
         
        integrante2 = integrante2;
        
        integrante3 = new Lead();
        integrante3.FirstName = 'test';
        integrante3.LastName = 'test';
        integrante3.Email = 'test@test35.com4';
        integrante3.Nombre_de_cuenta_web__c = 'test';
        
        controller.integrante3 = integrante3;
        
        mentor = new Lead();
        mentor.FirstName = 'test';
        mentor.LastName = 'test';
        mentor.Email = 'test@test45.com5';
        mentor.Nombre_de_cuenta_web__c = 'test';
        
        controller.mentor = mentor;
        
    }
}