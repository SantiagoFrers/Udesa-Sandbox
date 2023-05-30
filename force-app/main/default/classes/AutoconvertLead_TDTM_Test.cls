@isTest
public class AutoconvertLead_TDTM_Test {

    @isTest
    public static void convertLead(){
        
       // first retrieve default EDA trigger handlers
       List<hed.TDTM_Global_API.TdtmToken> tokens = hed.TDTM_Global_API.getTdtmConfig();

       // Create our trigger handler using the constructor
    	tokens.add(new hed.TDTM_Global_API.TdtmToken('AutoconvertLead_TDTM', 'Lead', 'AfterInsert;AfterUpdate;AfterDelete', 2.00));

       // Pass trigger handler config to set method for this test run
        hed.TDTM_Global_API.setTdtmConfig(tokens);

        
        Lead l = new Lead();
        l.company = 'test';
        l.lastName = 'test';
        l.Email = 'ets@asd.com';
        insert l;
        
        l.Convertir__c = true;
        
        update l;
        
        
    }
}