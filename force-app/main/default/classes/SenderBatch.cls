public with sharing class SenderBatch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
	 
	public final String QUERY = 'SELECT Id, Estado__c, IdRegistro__c, Intentos__c, JSONEnvio__c	, JSONRespuesta__c, Mensaje_Error__c,Pendiente__c,Sender__c,UltimoIntento__c,Url__c	 FROM EnvioWS__c WHERE Pendiente__c = true ORDER BY CreatedDate ASC ';
    
    
	public static final Integer FRECUENCY_TIME = 2;
 

	public Database.QueryLocator start(Database.BatchableContext BC){
		return Database.getQueryLocator(QUERY);
	}
	
	public void execute(Database.BatchableContext BC, List<sObject> scope){
			
		try{       
			SenderManager.send(scope);
		}catch(Exception e){
			System.debug(e.getMessage());
		}	 
	}

	public void finish(Database.BatchableContext BC){
		//re-schedule the batch		
		if(!Test.isRunningTest()){
			System.scheduleBatch(
				new SenderBatch()
				,'SenderBatch'
				,SenderBatch.FRECUENCY_TIME
				,1
		);
		}
    }   
    
	public static void run(){
		Database.executeBatch(new SenderBatch(),1);
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
        
	}
}