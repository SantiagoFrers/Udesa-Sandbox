@isTest
private class SyncSymposiumEventsSchedulableTEST {
    public static String CRON_EXP = '0 0 0 18 5 ? 2022';
    
    static testmethod void SyncSymposiumEventsSchedulableTEST_Method(){
        Test.startTest();
        String JobId = System.schedule ('SyncSymposiumEvents1', CRON_EXP, new SyncSymposiumEventsSchedulable());
        CronTrigger ct= [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                        FROM CronTrigger
                        WHERE id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals('2022-05-18 00:00:00', String.valueOf(ct.NextFireTime));
        Test.stopTest();
    }

}