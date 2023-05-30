@IsTest public with sharing class FormularioBecasControllerTest {
     
    @IsTest public static void newContact() {
    
        Account acc = TestDataFactory.createNoInformaAccount();
        
        FormularioBecasController controller = new FormularioBecasController();
        
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
        cnt.Localidad__c = l.id;
        cnt.Calle__c = 'Test';
        cnt.Nombre_de_cuenta_WEB__c = 'Test';
        cnt.Facebook__c = 'Test';
        cnt.Twitter__c = 'Test';
        cnt.Materias_por_Carrera__c = 'Test';
        
        controller.cnt = cnt;
        
        controller.save();
        
        controller.getPcias();
      
        controller = new FormularioBecasController();
        controller.cnt = cnt;
        controller.save();
        
       
    }
           
       
        
        
       
    
}