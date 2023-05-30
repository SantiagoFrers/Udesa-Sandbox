public class autoconvertLead {
    
    @invocableMethod
    public static void convert(List<String> Leads){
            
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(Leads[0]);
        
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        lc.setDoNotCreateOpportunity(TRUE);
        
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
    }
    
    public void convertTest(String LeadId){
        List<String> lList = new List<String>();
        lList.add(LeadId);
        convert(lList);
    }
}