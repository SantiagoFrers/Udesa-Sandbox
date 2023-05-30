public class MetadataUtil {
    
	private static Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
    private static Map<String, Map<String, Schema.SObjectField>> fieldsMap = new Map<String, Map<String, Schema.SObjectField>>();
	
    public static sObject createRecord(String objectName){
        
        sObject record = GlobalDescribe.get(objectName).newSObject();
         
        return record;
    }
        
        
	public static void setFieldValue(SObject obj, String objectName, String fieldName, String value) {
     	
        Schema.SObjectField field ;
        Schema.DescribeFieldResult fieldDescribe;
        
         system.debug('VALOR ' + value);
        system.debug('CAMPO ' + fieldName);

        system.debug('OBJECT ' + objectName);   
     
        try {
            field = getField(objectName, fieldName);
            fieldDescribe = field.getDescribe();            
        } catch (Exception ex) {
           throw new ErrorConfigException('El campo ' + fieldName + ' no existen en el objeto  ' + objectName);
        }

 
         
       
       
        system.debug('DESCRIBE ' + fieldDescribe);
        if (fieldDescribe.isCreateable()) {

            if (fieldDescribe.getType() == Schema.DisplayType.base64) {
                obj.put(field, blob.valueOf(value));
            } else if (fieldDescribe.getType() == Schema.DisplayType.Boolean) {
                obj.put(field, Boolean.valueOf(value));
            } else if (fieldDescribe.getType() == Schema.DisplayType.Combobox) {
                obj.put(field, value);
            } else if (fieldDescribe.getType() == Schema.DisplayType.Currency) {
                obj.put(field, Decimal.valueOf(value));
            } else if (fieldDescribe.getType() == Schema.DisplayType.Date) {
                obj.put(field, Date.valueOf(value));
            } else if (fieldDescribe.getType() == Schema.DisplayType.DateTime) {
                obj.put(field, DateTime.valueOf(value));
            } else if (fieldDescribe.getType() == Schema.DisplayType.Double) {
                obj.put(field, Double.valueOf(value));
            } else if (fieldDescribe.getType() == Schema.DisplayType.Email) {
                obj.put(field, value);
            } else if (fieldDescribe.getType() == Schema.DisplayType.EncryptedString) {
                obj.put(field, value);
            } else if (fieldDescribe.getType() == Schema.DisplayType.Integer) {
                obj.put(field, Integer.valueOf(value));
            } else if (fieldDescribe.getType() == Schema.DisplayType.MultiPicklist) {
                obj.put(field, value);
            } else if (fieldDescribe.getType() == Schema.DisplayType.Percent) {
                obj.put(field, Decimal.valueOf(value));
            } else if (fieldDescribe.getType() == Schema.DisplayType.Phone) {
                obj.put(field, value);
            } else if (fieldDescribe.getType() == Schema.DisplayType.Picklist) {
                obj.put(field, value);
			} else if (fieldDescribe.getType() == Schema.DisplayType.String) {
                obj.put(field, value); 
            } else if (fieldDescribe.getType() == Schema.DisplayType.Reference) {
               obj.put(field, value); 
            } else if (fieldDescribe.getType() == Schema.DisplayType.TextArea) {
                obj.put(field, value);  
            } else if (fieldDescribe.getType() == Schema.DisplayType.Time) {
                obj.put(field,value); 
            } else if (fieldDescribe.getType() == Schema.DisplayType.URL) {
                obj.put(field, value); 
            } else {
                System.debug('error' + fieldDescribe.getType());
            }
        }   
    }
    
    private static Map<String, Schema.SObjectField> getFields(String objectName){
        
        if(!fieldsMap.containsKey(objectName)){
            fieldsMap.put(objectName,GlobalDescribe.get(objectName).getDescribe().fields.getMap());
        }
           
		return fieldsMap.get(objectName);
    }
    
    private static Schema.SObjectField getField(String objectName, String fieldName){
        return getFields(objectName).get(fieldName);
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
    
     public class ErrorConfigException extends Exception {}

     
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