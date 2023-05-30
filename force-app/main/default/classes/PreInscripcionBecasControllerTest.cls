@isTest 
public with sharing class PreInscripcionBecasControllerTest {
  
    // Utility method that can be called by Apex tests to create price book entries.
    static testmethod void test() {
        
        PreInscripcionBecasController controller = new PreInscripcionBecasController();
        
        ApexPages.currentPage().getParameters().put('tipo','AAAA');
        
        Localidad__c l = new Localidad__c();
        l.Pa_s__c = 'p';
        l.Provincia__c = 'p';
        
        insert l;
        
        Contact cnt = new Contact();
        cnt.FirstName = 'test';
        cnt.LastName = 'Test';
        cnt.Email= 'Test@test.com';
        cnt.TipoDocumento__c = 'DNi';
        cnt.Documento__c = 'Test';
        cnt.HomePhone= 'Test';
        cnt.MobilePhone = 'Test';
        cnt.Localidad__c = l.id;
        cnt.Calle__c = 'Test';
        cnt.Nombre_de_cuenta_WEB__c = 'Test';
        cnt.Facebook__c = 'Test';
        cnt.Twitter__c = 'Test';
        cnt.Materias_por_Carrera__c = 'Test';
        
        Becas__c beca = new Becas__c();
        beca.Como_se_enter__c = 'test';
        beca.MejorPromedio__c = true;
        beca.Comentarios__c = 'test';
        
        controller.beca = beca;
        controller.cnt = cnt;
        
        controller.guardar();
        
        Contact cnt2 = new Contact();
        cnt2 .FirstName = 'test';
        cnt2 .LastName = 'Test';
        cnt2 .Email= 'Test@test.com';
        cnt2 .TipoDocumento__c = 'DNi';
        cnt2 .Documento__c = 'Test';
        cnt2 .HomePhone= 'Test';
        cnt2 .MobilePhone = 'Test';
        cnt2 .Localidad__c = l.id;
        cnt2 .Calle__c = 'Test';
        cnt2 .Nombre_de_cuenta_WEB__c = 'Test';
        cnt2 .Facebook__c = 'Test';
        cnt2 .Twitter__c = 'Test';
        cnt2 .Materias_por_Carrera__c = 'Test';    
        controller.cnt = cnt2;
        
        Becas__c beca2 = new Becas__c();
        beca2.Como_se_enter__c = 'test';
        beca2.MejorPromedio__c = true;
        beca2.Comentarios__c = 'test';
        controller.beca = beca2;
        
        controller.guardar();
        
        controller.getLocalidades();
   //     controller.buscarPciasLocalidad();

    }

}