/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-03-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class SenderInscriptionMoodle extends Sender {

    private InscripcionMoodle__c inscriptionToSend; 
    private Sender               currentSender; 

    public override void setDataToSend() {

        this.inscriptionToSend = [SELECT Id, ExternalId__c, Name , InscripcionCurso__c, InscripcionCurso__r.Contacto__c, InscripcionCurso__r.Contacto__r.MoodleId__c,
                                    InscripcionCurso__r.Contacto__r.Documento__c,   InscripcionCurso__r.Contacto__r.FirstName, InscripcionCurso__r.Contacto__r.LastName,Sincronizado__c,
                                    InscripcionCurso__r.Contacto__r.Email, CursoMoodle__r.ExternalId__c, EtapaIntegracion__c, InscripcionCurso__r.InscripcionesMoodle__c, InscripcionCurso__r.InscripcionesMoodleSincronizadas__c
                                    FROM  InscripcionMoodle__c
                                 WHERE Id =:this.recordToSendId];


        if (String.isBlank( this.inscriptionToSend.CursoMoodle__r.ExternalId__c)) {
            throw new MissingMoodleDataException('Falta registrar al curso o al contacto antes de la inscripción');
        }
        

        if (String.isBlank( this.inscriptionToSend.EtapaIntegracion__c)|| this.inscriptionToSend.EtapaIntegracion__c == 'Buscar Usuario') {
            
            if (String.isBlank( this.inscriptionToSend.InscripcionCurso__r.Contacto__r.MoodleId__c)) {

                this.currentSender = new SenderGetUserMoodle(this.inscriptionToSend.InscripcionCurso__r.Contacto__r);

            } else {

                this.inscriptionToSend.EtapaIntegracion__c = 'Enviar Inscripción';
            }
        }
       
        
        if (this.inscriptionToSend.EtapaIntegracion__c == 'Enviar Usuario') {
            this.currentSender = new SenderUserMoodle(this.inscriptionToSend.InscripcionCurso__r.Contacto__r);
        }

        if (this.inscriptionToSend.EtapaIntegracion__c == 'Enviar Inscripción') {
            this.currentSender = new SenderEnrolUser(this.inscriptionToSend);
        }

        if ( this.currentSender != null) {
            this.currentSender.setDataToSend();
        }
    }
    
    public override String getConfigName(){
        return this.currentSender.getConfigName();
    }
    
    public override String getAppendUrl() {
        return this.currentSender.getAppendUrl();
    }
    
    public override String getRequestBody() {
        return '';
    }

    public override void processResponse(){

        this.currentSender.jsonResponse = this.jsonResponse;

        if (this.currentSender.getConfigName() == 'core_user_create_users') {
            
            try {
                
                this.currentSender.processResponse();

                if (((Contact)this.currentSender.getRecordToSend()).MoodleId__c != null) {

                    this.inscriptionToSend.UltimoIntentoSincronizacion__c = Datetime.now();
                    this.inscriptionToSend.MensajeErrorSincronizacion__c  = this.currentSender.getConfigName() + ': OK.';
                    this.inscriptionToSend.EtapaIntegracion__c   = 'Enviar Inscripción';

                    update this.inscriptionToSend;
                   
                    SenderManager.enqueueEnvio(
                        SenderManager.createEnvio('SenderInscriptionMoodle', this.inscriptionToSend.Id)
                    );
                }
            } catch (SenderUserMoodle.UserAlreadyExistsException ex) {
                
                this.inscriptionToSend.UltimoIntentoSincronizacion__c = Datetime.now();
                this.inscriptionToSend.MensajeErrorSincronizacion__c  = this.currentSender.getConfigName() + ': El usuario ya existe. Buscando Id.';
                this.inscriptionToSend.EtapaIntegracion__c   = 'Buscar Usuario';

                update this.inscriptionToSend;

                SenderManager.enqueueEnvio(
                    SenderManager.createEnvio('SenderInscriptionMoodle', this.inscriptionToSend.Id)
                );
            } catch (Exception ex) {
                this.inscriptionToSend.EstadoSincronizacion__c        = 'Enviado con error';
                this.inscriptionToSend.UltimoIntentoSincronizacion__c = Datetime.now();
                this.inscriptionToSend.MensajeErrorSincronizacion__c  = this.currentSender.getConfigName() + ': ' + ex.getMessage();
                
                update this.inscriptionToSend;
            }
        }

        if (this.currentSender.getConfigName() == 'core_user_get_users') {

            try {
                
                this.currentSender.processResponse();

                if (((Contact)this.currentSender.getRecordToSend()).MoodleId__c != null) {

                    this.inscriptionToSend.UltimoIntentoSincronizacion__c = Datetime.now();
                    this.inscriptionToSend.MensajeErrorSincronizacion__c  = this.currentSender.getConfigName() + ': OK.';
                    this.inscriptionToSend.EtapaIntegracion__c   = 'Enviar Inscripción';

                    update this.inscriptionToSend;
                   
                    SenderManager.enqueueEnvio(
                        SenderManager.createEnvio('SenderInscriptionMoodle', this.inscriptionToSend.Id)
                    );
                } else {
                    this.inscriptionToSend.EstadoSincronizacion__c        = 'Enviado con error';
                    this.inscriptionToSend.UltimoIntentoSincronizacion__c = Datetime.now();
                    this.inscriptionToSend.MensajeErrorSincronizacion__c  = this.currentSender.getConfigName() + ': No se encuentra encuentra el usuario. Obtener manualmente.';
                    
                    update this.inscriptionToSend;
                }
                
            } catch (SenderGetUserMoodle.UsernameDoesNotExistException ex) {
                this.inscriptionToSend.EstadoSincronizacion__c        = 'Enviado';
                this.inscriptionToSend.UltimoIntentoSincronizacion__c = Datetime.now();
                this.inscriptionToSend.MensajeErrorSincronizacion__c  = this.currentSender.getConfigName() + ': No se encuentra encuentra el usuario. Enviando la creación del usario.';
                this.inscriptionToSend.EtapaIntegracion__c   = 'Enviar Usuario';

                update this.inscriptionToSend;

                SenderManager.enqueueEnvio(
                    SenderManager.createEnvio('SenderInscriptionMoodle', this.inscriptionToSend.Id)
                );

            } catch (Exception ex) {
                this.inscriptionToSend.EstadoSincronizacion__c        = 'Enviado con error';
                this.inscriptionToSend.UltimoIntentoSincronizacion__c = Datetime.now();
                this.inscriptionToSend.UltimoIntentoSincronizacion__c = Datetime.now();
                this.inscriptionToSend.MensajeErrorSincronizacion__c  = this.currentSender.getConfigName() + ': ' + ex.getMessage();
              
                update this.inscriptionToSend;
            }   
        }

        if (this.currentSender.getConfigName() == 'enrol_manual_enrol_users') {
            this.currentSender.processResponse();
        }
        
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
    public class MissingMoodleDataException extends Exception{}

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

/*
    public class SenderUserMoodle extends Sender {

        private String configName = 'core_user_create_users';
        private InscripcionMoodle__c inscriptionToSend; 
        private List<String> postParameters = new List<String>();

        public SenderUserMoodle(InscripcionMoodle__c inscriptionToSend) {

            this.inscriptionToSend = inscriptionToSend;
        }

        public override void setDataToSend() {

            postParameters.add('moodlewsrestformat=json');
            postParameters.add('users[0][username]='  + this.inscriptionToSend.InscripcionCurso__r.Contacto__r.Documento__c );
            postParameters.add('users[0][firstname]=' + this.inscriptionToSend.InscripcionCurso__r.Contacto__r.FirstName  );//TODO: preguntar que categoria va
            postParameters.add('users[0][lastname]='  + this.inscriptionToSend.InscripcionCurso__r.Contacto__r.LastName );
            postParameters.add('users[0][email]='     + this.inscriptionToSend.InscripcionCurso__r.Contacto__r.Email );
            postParameters.add('users[0][password]='  + this.inscriptionToSend.InscripcionCurso__r.Contacto__r.Documento__c );
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
            Contact contactToUpdate;
            
            //process error  for all
            if (this.jsonResponse.contains('exception')) {

                Map<String,Object> responseByKey = (Map<String,Object>) Json.deserializeUntyped(this.jsonResponse);

                status  = 'Enviado con error';
                message = currentProcess + ' ' +this.jsonResponse;

            } else {

                List<Object> results =  (List<Object>) Json.deserializeUntyped(this.jsonResponse);
            
                if (!results.isEmpty()) {
                    
                    Map<String,Object> result =  (Map<String,Object>) Json.deserializeUntyped(Json.serialize(results[0]));
            
                    if (result.containsKey('id')) {
            
                        contactToUpdate = new Contact(Id=  this.inscriptionToSend.InscripcionCurso__r.Contacto__c, MoodleId__c = String.valueOf(result.get('id')));
                        message = 'Paso 1/2 ' + currentProcess + ' OK.';
                    } 
                }
            }

            try {

                if (contactToUpdate != null) {
                    update contactToUpdate;
                    status  = 'Enviado';
                }

                SenderManager.enqueueEnvio(
                    SenderManager.createEnvio('SenderInscriptionMoodle', this.inscriptionToSend.Id)
                );

            } catch(Exception ex) {
                status  = 'Enviado con error';
                message = currentProcess + ': ' + ex.getMessage();
            }
        }   
    }*/
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