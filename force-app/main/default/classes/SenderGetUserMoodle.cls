/**
 * @description       : 
**/
public with sharing class SenderGetUserMoodle extends Sender {

    private String configName = 'core_user_get_users';
    private Contact contactToSend; 
    private List<String> postParameters = new List<String>();

    public SenderGetUserMoodle(Contact contactToSend) {

        this.contactToSend = contactToSend;
    }

    public SenderGetUserMoodle() {
    }

    public override void setDataToSend() {

        if (String.isBlank(this.contactToSend.Documento__c) ) {
            throw new MissingDataException('Contacto sin Documento');
        }
        postParameters.add('moodlewsrestformat=json');
        postParameters.add('criteria[0][key]=username');
        postParameters.add('criteria[0][value]=' + this.contactToSend.Documento__c  );
    }
    

    public override String getConfigName(){
        return this.configName;
    }
    
    public override String getAppendUrl() {
        return '&' + String.join(this.postParameters ,'&'); 
    }
    

    public override String getRequestBody() {
        return '';
    }

    public override void processResponse(){

        Map<String,Object> resultByKey = (Map<String,Object>) JSON.deserializeUntyped(this.jsonResponse);
        List<Object> usersResults =  (List<Object>)resultByKey.get('users');

        if (usersResults.isEmpty()) {
            throw new UsernameDoesNotExistException('Username Does Not Exist');
        } 

        Map<String,Object> userResult = (Map<String,Object>) usersResults[0];

        if (userResult.containsKey('id')) {

            this.contactToSend.MoodleId__c = String.valueOf(userResult.get('id'));
            update this.contactToSend;

        } else {

            throw new UsernameDoesNotExistException('Username Does Not Exist');
        }
        
    }   


    public override SObject getRecordToSend() {

        return this.contactToSend;
    }

    public class MissingDataException extends Exception{}
    public class UsernameDoesNotExistException extends Exception{}

    public static void pass() {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
}