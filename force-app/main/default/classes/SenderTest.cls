@isTest
public class SenderTest {

    @isTest
    public static void testSender(){
        
        Type t = Type.forName('SenderPostulacion');
            Postulaciones__c postulacion = TestUtilData.createPostulacionScene();
        
        WebServicesMockTest ws = new WebServicesMockTest();
        ws.error = true;
        
         Test.setMock(HttpCalloutMock.class, ws);
        
        Sender sender = (Sender)t.newInstance();
        sender.setRecord(postulacion.Id);
        sender.send();
        
        
         sender.getLog();
    }
}