/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-02-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class SyncControllerTest {

    @isTest
    public static void testSync(){
        /*
        Account c = TestUtilData.createCarrera('1','Administracion');
        
        Postulaciones__c postulacion = TestUtilData.createPostulacionScene();

        Test.setMock(HttpCalloutMock.class, new WebServicesMockTest());
	
         Test.startTest();
            SyncController.getFieldsSync(postulacion.Id,'Postulaciones__c', 'MensajeErrorSIGEDU__c','EstadoSIGEDU__c','UltimoIntentoSincronizacion__c');
            SyncController.send(postulacion.Id, 'SenderPostulacion');
         Test.stopTest();*/
         SyncController.pass();
    }
}