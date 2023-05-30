@isTest
public class udesaSendEmailTest {
    
    public static testMethod void sendTest(){
        
        Campaign testCampaign = new Campaign();
        testCampaign.Name = 'testCampaign';
        insert(testCampaign);
        
        Lead testLead = new Lead();
        testLead.LastName = 'Lehmann';
        testLead.Email = 'mlehmann@salesforce.com';
        testLead.Company = 'Lehmann Enterprises';
        testLead.Status = 'Abrir';
        insert(testLead);
        System.debug('Lead ID:'+testLead.Id);
        
        CampaignMember testMember = new CampaignMember();
        testMember.CampaignId = testCampaign.Id;
        testMember.LeadId = testLead.Id;
        testMember.Status = 'Interesado';
        insert(testMember);
        System.debug('CampaignMember Id: '+testMember.Id);
        
        /**OrgWideEmailAddress testOrg = [SELECT Id, Address FROM OrgWideEmailAddress WHERE DisplayName = 'Udesa IT SF'];
        */
        /**
        EmailTemplate testTemplate = new EmailTemplate();
        testTemplate.Body = 'abcd1234';
        testTemplate.Name = 'TestEmail Template';
        insert(testTemplate);*/
        
        List<String> testList= new List<String>();
        EmailTemplate tmpTemplate = [SELECT Name FROM EmailTemplate LIMIT 1];
        testList.add(tmpTemplate.Name);
        OrgWideEmailAddress tmpOWEA = [SELECT Id FROM OrgWideEmailAddress LIMIT 1];
        testList.add(tmpOWEA.Id);
        testList.add(testMember.Id);
        System.debug(testList);
        
        Test.startTest();
        List<List<String>> paramTemp = New List<List<String>>();
        paramTemp.add(testList);
        udesaSendEmail.sendUdeSAEmail(paramTemp);
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();
        System.assertEquals(1, invocations,'An Email has not been send.');
    }

}