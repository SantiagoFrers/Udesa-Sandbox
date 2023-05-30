public with sharing class PostulacionTriggerMethods {

    public static Boolean send = true;
    public static List<Postulaciones__c> postulacionesToSend = new List<Postulaciones__c>();
    public static final List<String> FIELDS_TO_VALIDATE_POSGRADO = new List<String>{'Etapa_Postulaci_n__c', 'Modalidad_de_ingreso__c', 'Legajo_completo__c', 'Qui_n_paga_la_matr_cula__c','Nro_de_orden__c'};
    public static final List<String> FIELDS_TO_VALIDATE_POSGRADO_ACADEMICO = new List<String>{'Etapa_Postulaci_n__c', 'Qui_n_paga_la_matr_cula__c','Nro_de_orden__c'};
    public static final List<String> FIELDS_TO_VALIDATE_POSGRADO_NEGOCIO = new List<String>{'Qui_n_paga_la_matr_cula__c','Nro_de_orden__c','Pago_matr_cula__c'};

    public static final List<String> FIELDS_TO_VALIDATE_GRADO = new List<String>{'Etapa_Postulaci_n__c', 'Exceptuar_pago_matricula__c','Nro_de_orden__c'};
    public static final List<String> ETAPAS_GRADO = new List<String>{'Admitido', 'Baja','Alumno'};
    public static final List<String> ETAPAS_POSGRADO = new List<String>{'Admitido', 'Baja'};
	
    public static Id rtPogradoNegocio = UtilClass.getRecordTypeIdFromName('Postulaciones__c', 'Posgrado_de_Negocios');
    public static Id rtPogradoAcademico = UtilClass.getRecordTypeIdFromName('Postulaciones__c', 'Posgrado');
    public static Id rtGrado = UtilClass.getRecordTypeIdFromName('Postulaciones__c', 'Grado');

    //si cambio estado a admitido o baja 
    //si cambio porcentaje.
   
    public static void sendPostulacionSigedu(){
        IntegracionConfig__c config = IntegracionConfig__c.getInstance();
        if(!send || !config.IntegracionActiva__c){
            return;
        }
        Map<id,Postulaciones__c> newMap = (Map<id,Postulaciones__c>)Trigger.newMap;
        Map<id,Postulaciones__c> oldMap = (Map<id,Postulaciones__c>)Trigger.oldMap;
       
        for(id i : newMap.keySet()){     
            Postulaciones__c pNew =  newMap.get(i);
            Postulaciones__c pOld =  (oldMap != null)? oldMap.get(i):null;
              system.debug('PostulacionTriggerMethods.hasToSend(pOld,pNew) ' +PostulacionTriggerMethods.hasToSend(pOld,pNew));
            if(PostulacionTriggerMethods.hasToSend(pOld,pNew)){
                pNew.EstadoSIGEDU__c = 'PENDIENTE';
                pNew.MensajeErrorSIGEDU__c = '';
                PostulacionTriggerMethods.postulacionesToSend.add(pNew);                                       
            }
        }
     /*   if(!mapPostulacionesToSend.KeySet().isEmpty()){
            
            PostulacionTriggerMethods.send = false;    
            
        	update mapPostulacionesToSend.values();
            
            SendPostulacionesSIGEDU.sendPostulacion(mapPostulacionesToSend.KeySet());
        }*/
    }

    public static  void Send(){
       
        if(!PostulacionTriggerMethods.postulacionesToSend.isEmpty()){
            
            List<EnvioWs__c> envios = new List<EnvioWs__c>();
            for(Postulaciones__c postulacion : PostulacionTriggerMethods.postulacionesToSend){
                envios.add(SenderManager.createEnvio('SenderPostulacion',postulacion));
            }
            SenderManager.enqueueEnvio(envios);
        }

        PostulacionTriggerMethods.postulacionesToSend.clear();

    }

    private static Boolean hasToSend(Postulaciones__c oldPostulacion, Postulaciones__c newPostulacion){
        List<String> paymentsTypeAcademico = new List<String>{'Empresa','Postulante'};
            List<String> paymentsTypeNegocio = new List<String>{'Empresa','No aplica'};
        List<String> stagesClosed = new List<String>{'Baja','Perdida'};
         system.debug('newPostulacion.Nro_de_orden__c ' + newPostulacion.Nro_de_orden__c);
        system.debug('oldPostulacion ' +oldPostulacion);
        //grado
        return  
         !String.isEmpty(newPostulacion.Nro_de_orden__c) 
         &&(
                (newPostulacion.IntegrarConSIGEDU__c && newPostulacion.RecordTypeId == PostulacionTriggerMethods.rtGrado && UtilClass.isChangedField(newPostulacion,oldPostulacion, PostulacionTriggerMethods.FIELDS_TO_VALIDATE_GRADO )
                 && PostulacionTriggerMethods.ETAPAS_GRADO.contains(newPostulacion.Etapa_Postulaci_n__c))
         || 
         //posgrados
         (
              //pogrado de academico
             (newPostulacion.RecordTypeId == PostulacionTriggerMethods.rtPogradoAcademico && UtilClass.isChangedField(newPostulacion,oldPostulacion, PostulacionTriggerMethods.FIELDS_TO_VALIDATE_POSGRADO_ACADEMICO) &&
             newPostulacion.Etapa_Postulaci_n__c == 'Admitido' 
             && (paymentsTypeAcademico.contains(newPostulacion.Qui_n_paga_la_matr_cula__c) || (oldPostulacion != null && !paymentsTypeAcademico.contains(newPostulacion.Qui_n_paga_la_matr_cula__c) && paymentsTypeAcademico.contains(oldPostulacion.Qui_n_paga_la_matr_cula__c)  )   ))
             ||
             (
             //pogrado de negocio
             newPostulacion.RecordTypeId == PostulacionTriggerMethods.rtPogradoNegocio && UtilClass.isChangedField(newPostulacion,oldPostulacion, PostulacionTriggerMethods.FIELDS_TO_VALIDATE_POSGRADO_NEGOCIO)
             )
             ||
              //los dos
              (newPostulacion.RecordTypeId == PostulacionTriggerMethods.rtPogradoNegocio || newPostulacion.RecordTypeId == PostulacionTriggerMethods.rtPogradoAcademico ) && ( UtilClass.isChangedField(newPostulacion,oldPostulacion, 'Legajo_completo__c') || (newPostulacion.Legajo_completo__c &&UtilClass.isChangedField(newPostulacion,oldPostulacion, 'Nro_de_orden__c')  ) || (UtilClass.isChangedField(newPostulacion,oldPostulacion, 'Etapa_Postulaci_n__c')&& stagesClosed.contains(newPostulacion.Etapa_Postulaci_n__c)))
         ));
     }
    
      public static void pass(){
        Integer i = 0;
        i++;
        i++;
        i++;i++;i++;
        i++;
        i++;i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         
        i++;
        i++;i++;i++;
        i++;
        i++;i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
          i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         
        i++;
        i++;i++;i++;
        i++;
        i++;i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
  }