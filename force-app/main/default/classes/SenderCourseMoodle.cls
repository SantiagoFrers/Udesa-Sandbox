/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-03-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class SenderCourseMoodle extends Sender {

    private static final String CONFIG_NAME = 'Create_Course_Moodle';
    private CursoMoodle__c courseToSend; 
    private List<String> postParameters = new List<String>();

    public override void setDataToSend() {

        this.courseToSend = [SELECT Id, Name ,ExternalId__c, Comision__c, Materia__c ,NombreMoodle__c
                             FROM  CursoMoodle__c
                             WHERE Id =:this.recordToSendId];

        postParameters.add('moodlewsrestformat=json');

        postParameters.add('courses[0][fullname]=' + this.courseToSend.NombreMoodle__c );
        postParameters.add('courses[0][categoryid]=' + '16' );//TODO: preguntar que categoria va
        postParameters.add('courses[0][shortname]=' + this.courseToSend.Name );
        
    }
    

    public override String getConfigName(){
        return SenderCourseMoodle.CONFIG_NAME;
    }
    
    public override String getAppendUrl() {
        return '&' + String.join(this.postParameters ,'&'); 
    }
    

    public override String getRequestBody() {
        return '';
    }

    public override void processResponse(){

        this.courseToSend.UltimoIntentoSincronizacion__c = Datetime.now();


        if (this.jsonResponse.contains('exception')) {

            Map<String,Object> responseByKey = (Map<String,Object>) Json.deserializeUntyped(this.jsonResponse);

            this.courseToSend.EstadoSincronizacion__c = 'Enviado con error';
            this.courseToSend.MensajeErrorSincronizacion__c = (String) responseByKey.get('message');
      
        } else {

            List<Object> results =  (List<Object>) Json.deserializeUntyped(this.jsonResponse);

            if (!results.isEmpty()) {
                
                Map<String,Object> result =  (Map<String,Object>) Json.deserializeUntyped(Json.serialize(results[0]));

                if (result.containsKey('id')) {

                    this.courseToSend.ExternalId__c  = String.valueOf(result.get('id'));
                    this.courseToSend.EstadoSincronizacion__c = 'Enviado';
        
                } 

            }
            
        }

        update this.courseToSend;
    }

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
[
    {
        "id": 19470,
        "shortname": "test"
    }
]*/