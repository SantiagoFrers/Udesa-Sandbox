public class ContactTrigger{


    public static void validateEmailAGPosibles(List<Contact> contactsList){
       
        List<String> emails = new List<String>();
  
        for(Contact c: contactsList){ 
            if( c.Email != null && c.Email.trim() != '')
                emails.add(c.Email);
        }
   
        
        if(emails.size()>0){
     
            List<Contact> cnts;
            
            try{
                cnts = [SELECT id, Email FROM Contact Where Email in :emails];        
            }catch(Exception ex){
            }
            
            if(cnts !=null){
                map<String, Contact> mapEmailContacts = new map<String, Contact>();
                
                for(Contact c:cnts){
                    mapEmailContacts.put(c.Email, c);    
                }
                
                for(Contact c:contactsList){
	            	if(c.Email != null){
	                	Contact aux = mapEmailContacts.get(c.Email);
	                      
	                    if(aux != null && (c.id == null || c.id != aux.id)){
	                        c.Email.addError(Label.ContactoErrorEmailDuplicado);
	                    }
	            	}
                }
            }       
        }
    }

}