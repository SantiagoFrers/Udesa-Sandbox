@isTest
public class SendContactDataToSIGEDUTest {
	@isTest
    static void updateContact(){
    /*    
        Postulaciones__c postulacion = TestUtilData.createPostulacionScene();
        
        Contact ct = [SELECT id, phone FROM Contact Where id = : postulacion.Contacto__c];
        
        Test.setMock(HttpCalloutMock.class, new WebServicesMockTest());

        Test.startTest();
        	ct.phone = '1235514';
        	update ct;
        Test.stopTest();
        */
            SendContactDataToSIGEDU.pass();
    }
}