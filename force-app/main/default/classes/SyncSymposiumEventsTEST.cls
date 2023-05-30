@isTest
private class SyncSymposiumEventsTEST {
    
    @isTest static void testGetCallout() {
        
        Test.setMock(HttpCalloutMock.class, new SyncSymposiumEventsHttpCalloutMock()); 
        SyncSymposiumEvents.SyncEvents();       
        Stage_Event__c stageEventTest = [SELECT Id, SymposiumId__c from Stage_Event__c WHERE title__c = 'TEST' LIMIT 1];
        System.assertEquals(1769, stageEventTest.SymposiumId__c);
         
    }   

}