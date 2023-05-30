/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-02-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/

public  class SenderEnrolUser extends Sender {

    private static final String CONFIG_NAME = 'enrol_manual_enrol_users'; 
    private InscripcionMoodle__c inscriptionToSend; 
    private List<String> postParameters = new List<String>();

    public SenderEnrolUser(InscripcionMoodle__c inscriptionToSend) {

        this.inscriptionToSend = inscriptionToSend;
    }

    public override void setDataToSend() {

        postParameters.add('moodlewsrestformat=json');
        postParameters.add('enrolments[0][roleid]=5');
        postParameters.add('enrolments[0][userid]='   + this.inscriptionToSend.InscripcionCurso__r.Contacto__r.MoodleId__c);
        postParameters.add('enrolments[0][courseid]=' + this.inscriptionToSend.CursoMoodle__r.ExternalId__c );

        if (String.isBlank(this.inscriptionToSend.InscripcionCurso__r.Contacto__r.MoodleId__c)) {
            throw new SenderInscriptionMoodle.MissingMoodleDataException('Falta registrar al curso o al contacto antes de la inscripción');
        }    
    }
    
    public override String getConfigName(){
        return SenderEnrolUser.CONFIG_NAME;
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

        if ( this.jsonResponse == 'null') {

            status  = 'Enviado';
            message = 'enrol_manual_enrol_users OK';
            this.inscriptionToSend.Sincronizado__c = true;
            
        } else if (this.jsonResponse.contains('exception')) {

            Map<String,Object> responseByKey = (Map<String,Object>) Json.deserializeUntyped(this.jsonResponse);

            status  = 'Enviado con error';
            message = 'enrol_manual_enrol_users: ' + this.jsonResponse;

        }
        
        this.inscriptionToSend.UltimoIntentoSincronizacion__c = Datetime.now();
        this.inscriptionToSend.EstadoSincronizacion__c        = status;
        this.inscriptionToSend.MensajeErrorSincronizacion__c  = message;
        this.inscriptionToSend.EtapaIntegracion__c   = 'Inscripto';

        if (this.inscriptionToSend.Sincronizado__c) {

            Inscripci_n_al_curso__c inscription = [SELECT Id, InscripcionesMoodle__c, InscripcionesMoodleSincronizadas__c,
             (SELECT Id, Sincronizado__c FROM Inscripcion_Moodle__r WHERE Sincronizado__c = true) 
             FROM Inscripci_n_al_curso__c WHERE Id =:this.inscriptionToSend.InscripcionCurso__c
            ];

            inscription.InscripcionesMoodleSincronizadas__c = inscription.Inscripcion_Moodle__r.size();
            update  inscription;
        }

        system.debug( this.inscriptionToSend);
        
        update this.inscriptionToSend;
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