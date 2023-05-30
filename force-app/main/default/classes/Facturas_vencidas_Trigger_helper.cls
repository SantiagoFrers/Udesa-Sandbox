public class Facturas_vencidas_Trigger_helper {

    public static void updateAccountContactLookup(List<Facturas_vencidas__c> fvs){

		// map to store client number and account or contact id        
		Map<String, String> clientMap = new Map<String, String>();
        
        for(Facturas_vencidas__c fv : fvs){
            clientMap.put(fv.Cliente__c, null);
            clientMap.put(fv.Responsable_de_Cobranza__c, null);
        }
        
    	// put all found client numbers in map with corresponding contact ids
        for(Contact c : [SELECT Id, Numero_de_cuenta__c FROM Contact WHERE Numero_de_cuenta__c IN :clientMap.keySet()]){
            clientMap.put(c.Numero_de_cuenta__c, c.Id);
        }
        
        // put all found client numbers in map with corresponding account ids
        for(Account a : [SELECT Id, Numero_de_cuenta__c FROM Account WHERE Numero_de_cuenta__c IN :clientMap.keySet()]){
            clientMap.put(a.Numero_de_cuenta__c, a.Id);
        }
        
        
        // update facturas vencidas with account and contact lookup
        for(Facturas_vencidas__c fv : fvs){
            
            fv.Account__c=null;
            fv.Contact__c=null;
            
            if(clientMap.get(fv.Cliente__c)!=null){
                if(clientMap.get(fv.Cliente__c).left(3)=='001'){
                    fv.Account__c=clientMap.get(fv.Cliente__c);
                }
                if(clientMap.get(fv.Cliente__c).left(3)=='003'){
                    fv.Contact__c=clientMap.get(fv.Cliente__c);
                }
            }
            
            if(clientMap.get(fv.Responsable_de_Cobranza__c)!=null){
                if(clientMap.get(fv.Responsable_de_Cobranza__c).left(3)=='001'){
                    fv.Account__c=clientMap.get(fv.Responsable_de_Cobranza__c);
                }
                if(clientMap.get(fv.Responsable_de_Cobranza__c).left(3)=='003'){
                    fv.Contact__c=clientMap.get(fv.Responsable_de_Cobranza__c);
                }
            }
        }
    }
}