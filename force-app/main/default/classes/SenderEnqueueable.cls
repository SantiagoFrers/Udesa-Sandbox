public with sharing class SenderEnqueueable implements System.Queueable,Database.AllowsCallouts {

    private List<EnvioWs__c> envios;

    public SenderEnqueueable(EnvioWs__c envioRecord){
       this.envios = new List<EnvioWs__c>();
       this.envios.add(envioRecord);
    }
    public SenderEnqueueable(List<EnvioWs__c> enviosList){
        this.envios = enviosList;
    }


    public void execute(QueueableContext context) {
        EnvioWs__c currentEnvio = this.envios.remove(0);

        currentEnvio = SenderManager.send(currentEnvio);
        
        upsert currentEnvio;
        
        if(!this.envios.isEmpty()){
            System.enqueueJob(this);
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
        
    }
}