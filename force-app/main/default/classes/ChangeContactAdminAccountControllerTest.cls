@IsTest 
public with sharing class ChangeContactAdminAccountControllerTest{
     
     @IsTest
      public static void ChangeContactAdminAccountControllerTest() {
      
        Account acc = TestDataFactory.createNoInformaAccount();
            
       
                
        Contact cnt = new Contact();
        cnt.FirstName = 'test';
        cnt.LastName = 'Test';
        cnt.Email= 'Test@test.com';
        cnt.TipoDocumento__c = 'DNi';
        cnt.Documento__c = 'Test';
        cnt.Calle__c = 'Test';
        cnt.Nombre_de_cuenta_WEB__c = 'Test';
        cnt.Facebook__c = 'Test';
        cnt.Twitter__c = 'Test';
        cnt.AccountId = acc.id;
        
        insert cnt;
        
        Contact cnt2 = new Contact();
        cnt2.FirstName = 'test';
        cnt2.LastName = 'Test';
        cnt2.Email= 'Test2@test.com';
        cnt2.TipoDocumento__c = 'DNi';
        
        cnt2.AccountId = acc.id;
        
        insert cnt2;
        
        
      
        ApexPages.StandardController std = new ApexPages.StandardController(cnt);

        ChangeContactAdminAccountController controller = new ChangeContactAdminAccountController(std);
        
        controller.value= 'test';
        controller.search();
        
        controller.idSelected = cnt2.id;
        controller.save();
        
        

        
        controller.save();
        
        
      }
      
}