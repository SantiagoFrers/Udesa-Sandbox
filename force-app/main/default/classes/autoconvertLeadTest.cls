@isTest
private class autoconvertLeadTest {
    
    public static testMethod void autoconvertLeadTest(){

        TestLeadCheck.insertSettings();
        
        Lead l = new Lead(FirstName = 'Testo', LastName ='Tester', Email='tester@test.vto',company='test');
        Insert l;
        
        Test.startTest();
        autoconvertLead acl = new autoconvertLead();
        acl.convertTest(l.Id);
        Test.stopTest();
    }

}