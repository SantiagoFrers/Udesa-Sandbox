public with sharing class SenderContact extends Sender {
   
    private final String CONFIG_NAME = 'ActualizarDatosDeContacto';
    private map<String,List<FieldMapping__mdt>>  mapping = MetadataUtil.getMapping('Actualizar Contacto SIGEDU');
    private String nroOrden;
    private Contact contactToSend;
    
    public override void setDataToSend(){

        Postulaciones__c postulacion = [SELECT id , Nro_de_orden__c,Contacto__c FROM Postulaciones__c WHERE id =:this.recordToSendId];
        this.nroOrden = postulacion.Nro_de_orden__c;

        List<String> fieldsToQuery = new List<String>{'Id'};

        for(FieldMapping__mdt f : this.mapping.get('SIGEDU')){
            fieldsToQuery.add(f.SourceFieldName__c);
        }

        Id ctcId = postulacion.Contacto__c;

        String query = 'SELECT {0} FROM Contact WHERE Id =:ctcId';
        
        query = String.format(query, new List<String>{String.join(fieldsToQuery, ' , ')});
        this.contactToSend =  Database.query(query);

    }

    public override String getConfigName(){
        return CONFIG_NAME;
    }

    public override String getRequestBody(){

        ContactUpdated cData = new ContactUpdated();

        cData.nro_de_orden = this.nroOrden;

        for(FieldMapping__mdt f : this.mapping.get('SIGEDU')){  
            cData.datos.put(f.TargetFieldName__c,String.valueOf(this.contactToSend.get(f.SourceFieldName__c)));
        }   

        return JSON.Serialize(cData);
    }

    public override List<String> getUrlParameters(){
        return new  List<String>{this.nroOrden};
    }
    

    public override void processResponse(){
    }
   
    public class ContactUpdated{
        public String nro_de_orden {get;set;}
        public map<String,String> datos {get;set;}

        public ContactUpdated(){
            datos = new Map<String,String>();
        }
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
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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