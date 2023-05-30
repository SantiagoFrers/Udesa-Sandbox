@isTest
private class SyncSymposiumEventsQueueableTEST {
    
    static testmethod void SyncSymposiumEventsQueueableTEST_TestMethod(){
       Test.setMock(HttpCalloutMock.class, new SyncSymposiumEventsHttpCalloutMock());                
       Test.startTest();
       SyncSymposiumEventsQueueable updater = new SyncSymposiumEventsQueueable();
       System.enqueueJob(updater);
       Test.stopTest(); 
       Stage_Event__c stageEventTest = [SELECT Id, SymposiumId__c from Stage_Event__c WHERE title__c = 'TEST' LIMIT 1];
       System.assertEquals(1769, stageEventTest.SymposiumId__c);  
    }

}