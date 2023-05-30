public with sharing class DisablerManager {
    

    public static Boolean disableChecked = false;


    public static Boolean isDisabledTrigger(){

        Disabler__c disabler = Disabler__c.getInstance();

        return disabler.DisableTriggers__c;
    }


    public static void checkAndDisableTriggers() {

        if (!DisablerManager.disableChecked) {

            if (DisablerManager.isDisabledTrigger()) {
        
                for (hed.TDTM_Global_API.TdtmToken tdtmToken : hed.TDTM_Global_API.getTdtmConfig()) {       

                  
                            tdtmToken.active = false;
                        
                        
                    }
                }

            DisablerManager.disableChecked = true;
       }
    }
     
    
}