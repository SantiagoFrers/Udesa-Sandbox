global with sharing class Disabler_TDTM extends hed.TDTM_Runnable {


    // the Trigger Handler’s Run method we must provide
    global override hed.TDTM_Runnable.DmlWrapper run(List<SObject> newlist, List<SObject> oldlist,
        
        hed.TDTM_Runnable.Action triggerAction, Schema.DescribeSObjectResult objResult) {

        DisablerManager.checkAndDisableTriggers();

        return null;
    }
    
    
    }