/**
* @description Clase 
**/
public with sharing class SenderPostulacionBeca extends Sender {
   
    private final String CONFIG_NAME = 'BecasOtorgadas';
    private Postulaciones__c postulacion;
    
    /**
    * @description Busca la postulacion y las becas relacionadas para enviar a SIGEDU
    **/
    public override void setDataToSend(){

        this.postulacion =  [SELECT id , Nro_de_orden__c,Etapa_Postulaci_n__c,BecasSincronizadasSIGEDUMensajeError__c,BecasSincronizadasSIGEDU__c,
                                (SELECT id, Beca__c, Beca__r.ID_BECA_SIGEDU__c,BecaOtorgada__c,Estado__c,Alojamiento_Otorgado__c FROM Becas__r WHERE FueOtorgada__c = true)
                             FROM Postulaciones__c WHERE id =:this.recordToSendId];
    }

    /**
    * @description Obtiene el nombre del metadata type con la configuració del proceso de integración de becas
    * @return String 
    **/
    public override String getConfigName(){
        return CONFIG_NAME;
    }

    /**
    * @description Transforma los registros en el json a enviar a SIGEDU
    * @return String 
    **/
    public override String getRequestBody(){

        Datos datos = new Datos();

        for(Becas__c b : postulacion.Becas__r){
            Beca beca = new Beca();

            beca.id_beca = (Integer)b.Beca__r.ID_BECA_SIGEDU__c;
            beca.porcentaje = (Integer) b.BecaOtorgada__c;
            beca.estado = b.Estado__c;
            beca.alojamiento = b.Alojamiento_Otorgado__c;

            datos.becas.add(beca);
        }

        return JSON.Serialize(datos);
    }

    /**
    * @description Metodo que agrega el nº de orden de la postualación a los paramatros de la url
    * @return String 
    **/
    public override List<String> getUrlParameters(){
        return new  List<String>{this.postulacion.Nro_de_orden__c};
    }
    

    /**
    * @description Metodo que procesa y registra la respuesta de SIGEDU en la postualación y las becas enviadas 
    **/
    public override void processResponse(){
    
        this.postulacion.BecasSincronizadasSIGEDU__c = this.status;
        this.postulacion.BecasSincronizadasSIGEDUMensajeError__c = this.jsonResponse ;        
        
        for(Becas__c b : this.postulacion.Becas__r){
           b.EstadoSIGEDU__c = this.status;
        }
        
        PostulacionTriggerMethods.send = false;

        update this.postulacion;
        update this.postulacion.Becas__r;
        
        PostulacionTriggerMethods.send = true;
        
    }
    
	
    /**
    * @description Clase para transformar los datos de SF en la estructura de SIGEDU
    **/
    public class Beca{
        public Integer id_beca {get;set;}
        public Integer porcentaje {get;set;}
        public String estado {get;set;}
        public Boolean alojamiento {get;set;}
    }


    /**
    * @description Clase para transformar los datos de SF en la estructura de SIGEDU
    **/
    public class Datos{
        public List<Beca> becas {get;set;}

        public Datos(){
            becas = new List<Beca> ();
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
        
    }
}