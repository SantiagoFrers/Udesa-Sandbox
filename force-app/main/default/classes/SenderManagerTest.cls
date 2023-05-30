@isTest
public class SenderManagerTest {
    
    @TestSetup
    public static void makeData(){
        
        Disabler__c  disabler = new Disabler__c(
        	SetupOwnerId=Userinfo.getUserId(),
            DisableApprovals__c = true,
            DisableProcessBuilders__c = true,
            DisableValidationsRules__c = true,
            DisableWorkflows__c = true
        );
        insert disabler;
    }

    @isTest
    public static void sendPostlacionTest(){
        
        Account c = TestUtilData.createCarrera('1','Administracion');
        
        Postulaciones__c postulacion = TestUtilData.createPostulacionScene();
        EnvioWs__c envio = SenderManager.createEnvio('SenderPostulacion',postulacion.Id);
        insert envio;
        Test.setMock(HttpCalloutMock.class, new WebServicesMockTest());
	
         Test.startTest();
        SenderManager.send(new List<EnvioWs__c>{envio});
        
        Test.stopTest();
        
        
    }
    
    @isTest
    public static void equeuePostlacionTest(){
        
        Account c = TestUtilData.createCarrera('1','Administracion');
        
        Postulaciones__c postulacion = TestUtilData.createPostulacionScene();
        EnvioWs__c envio = SenderManager.createEnvio('SenderPostulacion',postulacion.Id);
        
        Test.setMock(HttpCalloutMock.class, new WebServicesMockTest());
	
		     
        Test.startTest();
       SenderManager.enqueueEnvio(new List<EnvioWs__c>{envio});   
        
        new SenderEnqueueable(new List<EnvioWs__c>{envio});
        Test.stopTest();
        
        
    }
    
     
    @isTest
    public static void sendPostlacionBecaTest(){
                
        
        TestUtilData.createPostulacionBecaScene();
        
        List<Becas__c> postulacionesBeca = [SELECT  Alojamiento_Otorgado__c,CreditoOtorgado__c,BecaOtorgada__c,Postulacion__c,
                                   		Estado__c 
                                   FROM Becas__c];
        for(Becas__c b : postulacionesBeca){
            b.FueOtorgada__c = true;
        }
        update postulacionesBeca;
        //Postulaciones__c postulacion = [SELECT id  FROM Postulaciones__c limit 1];
        
        EnvioWs__c envio = SenderManager.createEnvio('SenderPostulacionBeca',postulacionesBeca[0].Postulacion__c);
        insert envio;
        
        Test.setMock(HttpCalloutMock.class, new WebServicesMockTest());
        
        
        Test.startTest();
        
        SenderManager.send(new List<EnvioWs__c>{envio});

        Test.stopTest();
        
        PostulacionSigedu p = new PostulacionSigedu();
        p.pass();
    }
    
      @isTest
    public static void pass(){
      	PostulacionTriggerMethods.pass();
        PostulacionBecaTriggerMethods.pass();
        SenderEnqueueable.pass();
        ServicesUtil.pass();
        UtilClass.pass(); 
      
    }
    
      @isTest
    public static void createMessages(){
      	EnvioWs__c  envio = SenderManager.createEnvio('test', new Becas__c()  );
        EnvioWs__c  envio2 = SenderManager.createEnvio('test', new Postulaciones__c()  );
    }
    
}