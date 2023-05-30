@IsTest 
public with sharing class FormularioActPadresControllerTest{
     
     @IsTest
      public static void FormularioActividadesPadresControllerTest() {
      
        Account acc = TestDataFactory.createNoInformaAccount();
     
        
        Actividad__c actividad = new Actividad__c();
        actividad.Cargado_por__c = 'Test';
        insert actividad;
        
        ApexPages.currentPage().getParameters().put('id',actividad.id);
        
        FormularioActividadesPadresController controller = new FormularioActividadesPadresController();
                
        Contact cnt = new Contact();
        cnt.FirstName = 'test';
        cnt.LastName = 'Test';
        cnt.Email= 'Test@test.com';
          
        Case consulta = new Case();
        consulta.description = 'dsadasd';
        
        controller.consulta = consulta;
        controller.case_type = 'sd';
        controller.case_reason = 'asd';
        controller.case_subject = 'asda';
      	
        
        controller.cntPadre = cnt ;
        
        Contact cnt2 = new Contact();
        cnt2.FirstName = 'test';
        cnt2.LastName = 'Test';
        cnt2.Email= 'Test3@test.com';

        controller.cntHijo = cnt2;
        
        controller.save();
        
        List<Contact> c = [SELECT id FROM Contact];
        
        system.AssertNotEquals(c,null);

        Asistencia_a_Actividades__c asistencia = [SELECT id, Comentarios__c, Contacto__c FROM Asistencia_a_Actividades__c WHERE Contacto__c in: c];
        system.AssertNotEquals(asistencia ,null);

      }
      
}