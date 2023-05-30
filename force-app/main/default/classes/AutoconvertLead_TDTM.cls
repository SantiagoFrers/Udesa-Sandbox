/**
 * @description       : trigger to convert lead with convert field in true
**/
global with sharing class AutoconvertLead_TDTM extends hed.TDTM_Runnable {

// the Trigger Handler’s Run method we must provide
global override hed.TDTM_Runnable.DmlWrapper run(List<SObject> newlist, List<SObject> oldlist,
    hed.TDTM_Runnable.Action triggerAction, Schema.DescribeSObjectResult objResult) {

    hed.TDTM_Runnable.dmlWrapper dmlWrapper = new hed.TDTM_Runnable.DmlWrapper();
    
    if (triggerAction == hed.TDTM_Runnable.Action.AfterUpdate) {

        List<Id> leadsToConvertId = new List<Id>();


        for(Integer i = 0 ; i < newlist.size() ; i++){
            if(oldlist[i].get('Convertir__c') == false && newlist[i].get('Convertir__c') == true){
                leadsToConvertId.add(newlist[i].Id);
            }
        }
        if(!leadsToConvertId.isEmpty()){
            list<Database.LeadConvert> leadConverts = new list<Database.LeadConvert>();

            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            for(Id leadId : leadsToConvertId){
                Database.LeadConvert lc = new database.LeadConvert();
                lc.setLeadId(leadId);
                lc.setConvertedStatus(convertStatus.MasterLabel);
                //Database.ConvertLead(lc,true);
                lc.setDoNotCreateOpportunity(true);
                leadConverts.add(lc);
            }
            Database.LeadConvertResult[] lcrList = Database.convertLead(leadConverts, true);
        } 
    
    
    }
    return dmlWrapper;
}


}