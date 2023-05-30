public class udesaSendEmail {
    
    @InvocableMethod
    public static void sendUdeSAEmail(List<List<String>> params){
        
        /**OrgWideEmailAddress sender = [Select Id,DisplayName,Address from OrgWideEmailAddress where DisplayName = :params.get(0).get(1)];*/
        CampaignMember receiver = [Select Id,Email,LeadId,ContactId,LeadOrContactId,CampaignId from CampaignMember where Id = :params.get(0).get(2)];
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = :params.get(0).get(0)];
        
        Messaging.SingleEmailMessage message = Messaging.renderStoredEmailTemplate(emailTemplate.Id, receiver.LeadOrContactId, receiver.Id);
        
        /**message.setOrgWideEmailAddressId(sender.I);*/
        message.setOrgWideEmailAddressId(params.get(0).get(1));
        message.setUseSignature(false); 
        message.setBccSender(false); 
        message.setSaveAsActivity(false); 
        message.toAddresses = new String[] {receiver.Email};
            
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
        if (results[0].success)
        {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: ' +  results[0].errors[0].message);
        }

    }
}