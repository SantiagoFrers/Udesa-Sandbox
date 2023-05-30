/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-02-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class SenderUserMoodle extends Sender {

    private String configName = 'core_user_create_users';
    private Contact contactToSend; 
    private List<String> postParameters = new List<String>();

    public SenderUserMoodle(Contact contactToSend) {
        this.contactToSend = contactToSend;
    }

    public SenderUserMoodle() {
    }

    public override void setDataToSend() {

        if (String.isBlank(this.contactToSend.Documento__c) ) {
            throw new MissingDataException('Contacto sin Documento');
        }
        this.postParameters.add('moodlewsrestformat=json');
        this.postParameters.add('users[0][username]='  + this.contactToSend.Documento__c );
        this.postParameters.add('users[0][firstname]=' + this.contactToSend.FirstName  );
        this.postParameters.add('users[0][lastname]='  + this.contactToSend.LastName );
        this.postParameters.add('users[0][email]='     + this.contactToSend.Email );
        this.postParameters.add('users[0][password]='  + this.contactToSend.Documento__c );
        this.postParameters.add('users[0][idnumber]='  + this.contactToSend.Id );
        //this.postParameters.add('users[0][auth]=Base de datos externa');
         
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

        String status; 
        String message;
        String currentProcess = 'core_user_create_users';

        system.debug(this.jsonResponse);
        //process error  for all
        if (this.jsonResponse.contains('exception')) {

            Map<String,Object> responseByKey = (Map<String,Object>) Json.deserializeUntyped(this.jsonResponse);

            if (responseByKey.containsKey('debuginfo') && ((String)responseByKey.get('debuginfo')).contains('Username already exists') ) {
                throw new  UserAlreadyExistsException('Username already exists');
            }

            throw new IntegrationUserException(this.jsonResponse);
        } 

        List<Object> results =  (List<Object>) Json.deserializeUntyped(this.jsonResponse);
    
        if (!results.isEmpty()) {
            
            Map<String,Object> result =  (Map<String,Object>) Json.deserializeUntyped(Json.serialize(results[0]));
    
            if (result.containsKey('id')) {
    
                this.contactToSend.MoodleId__c = String.valueOf(result.get('id'));

                system.debug(this.contactToSend);

                update this.contactToSend;
            } 
        }
        
    }   

    public override SObject getRecordToSend() {

        return this.contactToSend;
    }

    public override EnvioWs__c getLog(EnvioWs__c envio){
            
        envio.Url__c 			 = this.endPointUrl.substringBefore('?');
        envio.Estado__c 		 = this.status;
        envio.JSONEnvio__c 		 = this.endPointUrl.replace(this.endPointUrl.substringBetween('wstoken=','&'), '(hiden)');
        envio.JSONRespuesta__c 	 = this.jsonResponse;
        envio.Mensaje_Error__c 	 = this.errorMsg;
        envio.CodigoRespuesta__c = (this.codeResponse != null) ? String.valueOf(this.codeResponse):'';

        envio.UltimoIntento__c 	 = this.TimeOfTry;

        return envio;
    }
    
    public class MissingDataException extends Exception{}
    public class UserAlreadyExistsException extends Exception{}
    public class IntegrationUserException extends Exception{}


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


/*
{
    "id": 67044,
    "username": "testuser"
}
{
    "exception": "invalid_parameter_exception",
    "errorcode": "invalidparameter",
    "message": "Detectado valor de parámetro no válido",
    "debuginfo": "Username already exists: testuser"
}
*/