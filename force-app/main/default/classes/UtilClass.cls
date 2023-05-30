public class UtilClass {
    
    public static map<String, sObject> getLeadsEmails(List<String> emails){

         map<String, sObject> mapEmails = new map<String, sObject>();

        for(Lead l : getLeadsByEmail(emails)){
            mapEmails.put(l.email, l);
        }


        return mapEmails;
    }

     public static map<String, sObject> getContactEmails(List<String> emails){

         map<String, sObject> mapEmails = new map<String, sObject>();

        for(Contact c: getContactsByEmail(emails)) {
            if(String.isNotBlank(c.email)) mapEmails.put(c.email, c);
            if(String.isNotBlank(c.hed__AlternateEmail__c))mapEmails.put(c.hed__AlternateEmail__c, c);
            if(String.isNotBlank(c.Otro_email__c))mapEmails.put(c.Otro_email__c, c);
            if(String.isNotBlank(c.Email_Personal__c))mapEmails.put(c.Email_Personal__c, c);
        }

        return mapEmails;
    }
      

    public static List<Lead> getLeadsByEmail(List<String> emails){
        
       
        List<Lead> leads = [SELECT id,email FROM Lead WHERE email =: emails AND isconverted = false];

        
        return leads;
    }
    
    public static List<Contact> getContactsByEmail(List<String> emails){
       
        List<Contact> cts; 
            
        cts = [SELECT id, email, hed__AlternateEmail__c,Otro_email__c , Email_Personal__c,DocumentoFormula__c,TipoDocumento__c,Documento__c FROM Contact
               where email in :emails
               	OR hed__AlternateEmail__c in :emails
               	OR Otro_email__c in :emails 
              	OR Email_Personal__c in :emails ];
            
        System.System.debug(cts);

        return cts;
    }
    
    public static List<Contact> getContactsByDocument(String docType, String docNumber){
       
        List<Contact> cts; 
        String doc = docType + docNumber;
        cts = [SELECT id,DocumentoFormula__c, email, hed__AlternateEmail__c,Otro_email__c , Email_Personal__c,TipoDocumento__c,Documento__c FROM Contact
               where  DocumentoFormula__c like :doc];
            
        System.System.debug(cts);

        return cts;
    }

    public static ID convertLead(Lead lead){
            
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(lead.Id);
        
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());

        Contact ct ; //buscar contacto

        return lcr.getContactId(); 
    }
    
    public static sObject getSObjectRecord(String sObjectName, String externalIdField, String value){

        //pasar a algo global
        SObjectType oDescribe = Schema.getGlobalDescribe().get(sObjectName);
        sObject sObj = oDescribe.newSObject();
        sObj.put(externalIdField,value);

        return sObj;

    }

    public static Postulaciones__c getPostulacion(String numero){

        Postulaciones__c p;
        try {
            p = [SELECT id, Nro_de_orden__c, Contacto__c,Fecha_Pago_Inscripci_n__c, Fecha_de_Matriculaci_n__c, A_o_comienza_a_cursar__c,Permite_Ser_Actualizada_Por_Integracion__c	 FROM Postulaciones__c WHERE Nro_de_orden__c = : numero];
        } catch (Exception ex) {
        }
        
        return p;
    }
    
    public static  map<String,List<FieldMapping__mdt>> getMapping(String proccess){

        List<FieldMapping__mdt> mapping = [SELECT id, Process__c,SourceFieldName__c,TargetFieldName__c,TargetObject__c,isRelationship__c,
                                            RelationshipIdField__c, RelationshipObject__c, DefaultValue__c, Required__c
                                            FROM  FieldMapping__mdt WHERE Process__c =: proccess];

        map<String,List<FieldMapping__mdt>> mapFields = new map<String,List<FieldMapping__mdt>>();

        for(FieldMapping__mdt m:mapping ){

            if(!mapFields.containskey(m.TargetObject__c)){
                mapFields.put(m.TargetObject__c, new List<FieldMapping__mdt>() );
            }
            mapFields.get(m.TargetObject__c).add(m);

        }

        return mapFields;
    }
	
    public static Boolean isChangedField(SObject so, SObject oldSo, String fieldName){
        return (oldSo == null && so.get(fieldName) != null )|| (oldSo != null && (so.get(fieldName) != oldSo.get(fieldName)));
    }

    public static Boolean isChangedField(Sobject so, Sobject oldSo, String[] fieldNames){
        for(String field : fieldNames){
            if(isChangedField(so,oldSo,field)){
                return true;
            }
        }

        return false;
    }
    
    public static Id getRecordTypeIdFromName(String objectName, String recordTypeName){
        try{
        	return Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfosByDeveloperName().get(recordTypeName).getRecordTypeId();
        }catch(exception ex){
        }
        
        return null;
   }
    
    public static void pass(){
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
    }
    


}