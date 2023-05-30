@isTest
public with sharing class Disabler_Test {
  

    @isTest
    public static void disable(){

       // first retrieve default EDA trigger handlers
       List<hed.TDTM_Global_API.TdtmToken> tokens = hed.TDTM_Global_API.getTdtmConfig();

       // Create our trigger handler using the constructor
    	tokens.add(new hed.TDTM_Global_API.TdtmToken('Disabler_TDTM', 'Lead', 'BeforeInsert;BeforeUpdate', 2.00));

       // Pass trigger handler config to set method for this test run
        hed.TDTM_Global_API.setTdtmConfig(tokens);

        
        Lead l = new Lead();
        l.company = 'test';
        l.lastName = 'test';
        l.Email = 'ets@asd.com';
        insert l;
        
    }


}