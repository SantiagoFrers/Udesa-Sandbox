public without sharing class SendPostulacionesBecaSIGEDU {

    
    public static void sendPostulacion(Set<Id> idPostulaciones){
         
        for(Id i:idPostulaciones){
            generateRequest(i);   
        }
              
    }
  //  private static void generateRequest(Id Idpostulacion , String nroOrden, String estado, Date fecha, Boolean pagoMatricula){

    @future(callout=true)
    private static void generateRequest(Id idPostulacion){
        
        Postulaciones__c postulacion = [SELECT id , Nro_de_orden__c,Etapa_Postulaci_n__c,BecasSincronizadasSIGEDUMensajeError__c,BecasSincronizadasSIGEDU__c,
                                                (SELECT id, Beca__c, Beca__r.ID_BECA_SIGEDU__c,BecaOtorgada__c,Estado__c,Alojamiento_Otorgado__c,Comit_m_s_reciente__c ,Comit_m_s_reciente__r.Name
                                                 FROM Becas__r
                                                 WHERE EnviarSigedu__c = true)
                                                FROM Postulaciones__c WHERE id =:Idpostulacion];

        String nroOrden = postulacion.Nro_de_orden__c;
    
        Datos datos = new Datos();

        for(Becas__c b : postulacion.Becas__r){
            Beca beca = new Beca();

            beca.id_beca = (Integer)b.Beca__r.ID_BECA_SIGEDU__c;
            beca.porcentaje = (Integer) b.BecaOtorgada__c;
            beca.estado = b.Estado__c;
            beca.alojamiento = b.Alojamiento_Otorgado__c;
            beca.nombre_comite = b.Comit_m_s_reciente__r.Name;
            beca.id_comite = b.Comit_m_s_reciente__c;

            datos.becas.add(beca);
        }

        List<String> parameters = new List<String>();
        parameters.add(nroOrden);

        String jsonDatos = JSON.serialize(datos);

        System.debug('datos = ' + jsonDatos);
        //cambiar
        HTTPResponse res = HTTPUtil.DoRequest('BecasOtorgadas',null,jsonDatos,parameters,'');
      
        System.debug('response' + res);
        System.debug(res.getBody());
      
        if(res.getStatusCode() >= 200 && res.getStatusCode() < 300){
            postulacion.BecasSincronizadasSIGEDU__c = 'ENVIADO';
            postulacion.BecasSincronizadasSIGEDUMensajeError__c = '';
        }else {
            postulacion.BecasSincronizadasSIGEDU__c = 'ERROR';
            postulacion.BecasSincronizadasSIGEDUMensajeError__c = res.getBody();          
        }

        PostulacionTriggerMethods.send = false;
        
        update postulacion;
    }

    public class Beca{
        public Integer id_beca {get;set;}
        public Integer porcentaje {get;set;}
        public String estado {get;set;}
        public Boolean alojamiento {get;set;}
        public String nombre_comite {get;set;}
        public String id_comite {get;set;}
    }

    public class Datos{
        public List<Beca> becas {get;set;}

        public Datos(){
            becas = new List<Beca> ();
        }
    }


}