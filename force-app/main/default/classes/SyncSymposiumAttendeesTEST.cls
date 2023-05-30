@isTest
private class SyncSymposiumAttendeesTEST {
    

    @isTest static void testGetCallout() {
        
        Campaign testCampaign = new Campaign();
		testCampaign.Symposium_ID__c = 1769;
        testCampaign.Create_New_Attendees_As__c = 'Contact';
		testCampaign.name= 'TEST';
        testCampaign.IsActive = true;
        insert testCampaign; 
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SyncSymposiumAttendeesHttpCalloutMock());
        List<Stage_Event_Attendees__c> li = SyncSymposiumAttendees.SyncAttendees(testCampaign, 1);
        Test.stopTest();
         
    }

    @isTest static void testbatch() {

        Campaign testCampaign = new Campaign();
		testCampaign.Symposium_ID__c = 1769;
        testCampaign.Create_New_Attendees_As__c = 'Contact';
		testCampaign.name= 'TEST';
        testCampaign.IsActive = true;
        insert testCampaign;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SyncSymposiumAttendeesHttpCalloutMock());
        Id btchid = SyncSymposiumAttendees.executeBatchJob(testCampaign.Id);
        SyncSymposiumAttendees.getBatchJobStatus(btchid);
        Test.stopTest();

    }

}