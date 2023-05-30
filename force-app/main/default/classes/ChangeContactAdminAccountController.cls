public with sharing class ChangeContactAdminAccountController {

    public String value {get;set;}
    public Id idSelected {get;set;}
    public Contact ctc {get;set;}
    public List<Contact> contacts{get;set;}
    
    public ChangeContactAdminAccountController(ApexPages.StandardController controller) {
        ctc = (Contact)controller.getRecord();
        value = '';
        contacts = new List<Contact>();
    }

    public PageReference search(){
        if(value == '' || ctc == null )
            return null;
            
        contacts = new List<Contact>();
        
        string query = 'FIND :value in all fields returning Contact(name,email,AccountId )';
        
        Search.SearchResults searchResult = Search.find(query );
        List<Search.SearchResult> searchResults = searchResult.get('Contact'); 
     
        for (Search.SearchResult s: searchResults ) {
            if(s.getSObject().id != ctc.id)
                contacts.add((Contact)s.getSObject()); 
        }
   
        return null;
    }
    
     public PageReference save(){
         
         ctc.AccountId = idSelected;
         
         try{
             update ctc;
         }catch(Exception ex){
             
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,ex.getMessage()));
             system.debug(ex.getMessage());
             return null;
         }
         
         return  new PageReference('/' + ctc.Id);
     }
    
}