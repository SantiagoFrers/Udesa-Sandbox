@isTest
public class ContactTriggerTest{


    static testMethod void testEmailValidatorAGPosibles(){
        
        RecordType  rt = [SELECT Id FROM RecordType WHERE DeveloperName='AG_Posibles' and IsActive= true];
        
        Contact c1 = new Contact(Email='test1@contacto.com',recordTypeId = rt.id, LastName= 'contacto 1 ');   
        insert c1;

        Contact c2 = new Contact(Email='test1@contacto.com',recordTypeId = rt.id, LastName= 'contacto 2');
        try{
            insert c2;
        }catch(Exception ex){}
        
        system.AssertEquals(c2.id,null);
        
        Contact c3 = new Contact(Email='test3@contacto.com', LastName= 'contacto 3 ');
        
        try{
            insert c3;
        }catch(Exception ex){}
        
        
        system.AssertNotEquals(c3.id,null);     
        
        Contact c4 =  new Contact(Email='test4@contacto.com',recordTypeId = rt.id, LastName= 'contacto 4');
        try{
            insert c4;
        }catch(Exception ex){}
                
        system.AssertNotEquals(c4.id,null);      
    }
}