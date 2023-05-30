@isTest
public class SenderBatchTest {

     @isTest
    public static void testSender(){
        SenderBatch bt = new SenderBatch(); 
        SenderBatch.run();
        SenderBatch.pass();
    }
}