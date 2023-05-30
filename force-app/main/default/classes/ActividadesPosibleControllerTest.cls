@IsTest 
public with sharing class ActividadesPosibleControllerTest{
     
     @IsTest
      public static void FormularioActividadesControllerTest() {
      
        Account acc = TestDataFactory.createNoInformaAccount();
     
        id devRecordTypeId = Schema.SObjectType.Actividad__c.getRecordTypeInfosByName().get('Posible').getRecordTypeId();
        
        Actividad__c actividad = new Actividad__c();
        actividad.Cargado_por__c = 'Test';
        actividad.recordTypeId = devRecordTypeId;
        actividad.Active__c = true;
        insert actividad;
        system.debug(devRecordTypeId );
        
        ActividadesPosibleController controller = new  ActividadesPosibleController();
                
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
        controller.optUno  = 'Abogacia';
        controller.optDos  = 'Eco';
        controller.optTres  = 'Adm';
        controller.cnt = cnt;
        controller.consulta.description = '22';
        
        controller.getLocalidades();
        controller.save();
        system.debug(controller.mapOpts);
        for(String k:controller.mapOpts.keySet()){    
            for(ActividadesPosibleController.ActivityOption act :  controller.mapOpts.get(k)){
                act.wish = true;
            }
        }
        
        controller.save();
        
        Contact c;
        try{
         c =  [SELECT id,Email FROM Contact Limit 1];
        }catch(exception ex){}
        
        system.AssertNotEquals(c,null);
        system.AssertEquals(c.Email,'test@test.com');
        
        List<wish__c> wishes = [SELECT id, Contact__c,Case__c FROM Wish__c WHERE Contact__c =: c.id];
        system.AssertNotEquals(wishes ,null);
         
         
        Actividad__c actividad2 = new Actividad__c();
        actividad2.Cargado_por__c = 'Test2222';
        actividad2.recordTypeId = devRecordTypeId;
        actividad2.Active__c = true;
        insert actividad2;
      
        controller = new ActividadesPosibleController();
        
        controller.cnt = cnt;
        
        controller.getPcias();
        
        for(String k:controller.mapOpts.keySet()){    
            for(ActividadesPosibleController.ActivityOption act :  controller.mapOpts.get(k)){
                act.wish = true;
            }
        }
        
        
        controller.save();
      }
      
}