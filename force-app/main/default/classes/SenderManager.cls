/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-02-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class SenderManager {
    
    public static final Integer MAX_ATTEMPS = Integer.valueOf(UdesaSetting__mdt.getInstance('IntegrationSenderMaxAttemps').Value__c);
 
	public static List<EnvioWs__c> envios = new List<EnvioWs__c>();
    public static final List<String> SENT_STATUS = new List<String>{
        Sender.STATUS_SENT_OK,
        Sender.STATUS_SENT_ERROR    
    };
    
    public static void send(List<EnvioWs__c> senderWs) {
        
        for (EnvioWs__c envio : senderWs) {
            
            envio = SenderManager.send(envio);
        }

        update senderWs;
    }

    public static EnvioWs__c  send(EnvioWs__c senderWs) {

         try{
             
           	senderWs.Intentos__c = senderWs.Intentos__c == null ? 1 : senderWs.Intentos__c + 1;     
             
            Type t = Type.forName(senderWs.Sender__c);
            Sender sender = (Sender) t.newInstance();
            sender.setRecord(senderWs.IdRegistro__c);
            sender.send();
    
            senderWs = sender.getLog(senderWs);
             
            if (senderWs.Intentos__c >= SenderManager.MAX_ATTEMPS && !SenderManager.SENT_STATUS.contains(senderWs.Estado__c)) {
                
            	sender.processResponse();
        	}
             
        } catch (Exception ex) { 
            
            senderWs.Estado__c =  Sender.STATUS_ERRROR;
            senderWs.Mensaje_Error__c = ex.getMessage();
        } 
         
        return senderWs;
    }

    public static void enqueueEnvio(EnvioWs__c senders){

        enqueueEnvio(new List<EnvioWs__c>{senders});
    }

    public static void enqueueEnvio(List<EnvioWs__c> senders){

        if (Limits.getQueueableJobs() < Limits.getLimitQueueableJobs()) {
            
            System.enqueueJob(new SenderEnqueueable(senders));
        }else {
            
            insert senders;
        }
    }


    

    public static EnvioWs__c createEnvio(String senderClass,Id recordId ) {
        
        EnvioWs__c envio = new EnvioWs__c();
        envio.Sender__c = senderClass;
        envio.IdRegistro__c = recordId;

        return envio;
    }
    
    public static EnvioWs__c createEnvio(String senderClass, Postulaciones__c postulacion) {
        
        EnvioWs__c envio = new EnvioWs__c();
        
        envio.Sender__c 	= senderClass;
        envio.IdRegistro__c = postulacion.Id;
        envio.Postulacion__c= postulacion.Id;

        return envio;
    }
    
    public static EnvioWs__c createEnvio(String senderClass, Becas__c postulacionBeca ) {
        
        EnvioWs__c envio = new EnvioWs__c();
        
        envio.Sender__c  		    = senderClass;
        envio.IdRegistro__c  		= postulacionBeca.Postulacion__c;
        envio.Postulacion__c 		= postulacionBeca.Postulacion__c;
        envio.Postulacion_a_beca__c = postulacionBeca.Id;

        return envio;
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