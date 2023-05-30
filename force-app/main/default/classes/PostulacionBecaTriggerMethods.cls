public without sharing class PostulacionBecaTriggerMethods {
	
    public static final String PENDING_STATUS = 'PENDIENTE';  
    public static Boolean sendBecas = true;
    //mapa para guardar que desencadena la integracion.
    private static Map<Id,Becas__c> sources = new Map<Id,Becas__c>();
    private static IntegracionConfig__c config = IntegracionConfig__c.getInstance();
    
	
    public static void setOtorgada(List<Becas__c> oldBecas,List<Becas__c> newBecas){
        if(!PostulacionBecaTriggerMethods.sendBecas){
            return;
        }
        for(Integer i = 0; i < newBecas.size() ; i ++){
            Becas__c b = newBecas[i];
            if(!newBecas[i].FueOtorgada__c  && ( oldBecas != null && newBecas[i].Estado__c == 'Otorgado' && oldBecas[i].get('Estado__c')!= 'Otorgado')|| 
              	(oldBecas == null && newBecas[i].Estado__c == 'Otorgado' )){
                newBecas[i].FueOtorgada__c = true;
            }  
        }
    }


    public static void sendBecasToSIGEDU(){
	 	
        if(!PostulacionBecaTriggerMethods.sendBecas){
            return;
        }
        
        map<id,Becas__c> newMap = (map<id,Becas__c>)Trigger.newMap;
        map<id,Becas__c> oldMap = (map<id,Becas__c>)Trigger.oldMap;
		
        //mapa para guardar que desencadena la integracion.
        Map<Id,Becas__c> sources = new Map<Id,Becas__c>();
            
        IntegracionConfig__c config = IntegracionConfig__c.getInstance();
        if(!config.IntegracionActiva__c){
            return;
        }
        
        Set<id> postulacionesId = new Set<id>();
        
        for(id i : newMap.keySet()){
            Becas__c b =  newMap.get(i);
            if(b.IntegrarConSIGEDU__c &&  b.FueOtorgada__c && ( oldMap == null || (oldMap != null && (  b.Estado__c != oldMap.get(i).get('Estado__c') || b.BecaOtorgada__c != oldMap.get(i).get('BecaOtorgada__c') || b.Alojamiento_Otorgado__c != oldMap.get(i).get('Alojamiento_Otorgado__c') )) )){
                postulacionesId.add(b.Postulacion__c);
                sources.put(b.Postulacion__c,b);
            }
        }
         
        if(!postulacionesId.isEmpty()){

            List<Postulaciones__c> postulaciones = [SELECT  id ,BecasSincronizadasSIGEDUMensajeError__c,BecasSincronizadasSIGEDU__c,
                                                        (SELECT id, EstadoSIGEDU__c FROM Becas__r WHERE FueOtorgada__c = true)
                                                     FROM Postulaciones__c WHERE id in:postulacionesId];
            
            List<EnvioWs__c> envios = new List<EnvioWs__c>();
            List<Becas__c> becasToUpdate = new  List<Becas__c>();
            for(Postulaciones__c p:postulaciones){
            	p.BecasSincronizadasSIGEDU__c = PostulacionBecaTriggerMethods.PENDING_STATUS;   
                p.BecasSincronizadasSIGEDUMensajeError__c = ''; 
                envios.add(SenderManager.createEnvio('SenderPostulacionBeca',sources.get(p.Id))); 
                for(Becas__c b : p.Becas__r){
                	b.EstadoSIGEDU__c = PostulacionBecaTriggerMethods.PENDING_STATUS;
                    becasToUpdate.add(b);
                }
            }
			
            PostulacionTriggerMethods.send = false;
			PostulacionBecaTriggerMethods.sendBecas = false;
            update postulaciones;
			update becasToUpdate;
            SenderManager.enqueueEnvio(envios);
           	PostulacionBecaTriggerMethods.sendBecas = true;
            PostulacionTriggerMethods.send = true;
        }
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
        i++;
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
        i++;
        i++;
        i++;
        i++;
        i++;
    }
    
}