public with sharing class SenderPostulacion extends Sender {
   
    
    private Id rtPogradoNegocio = UtilClass.getRecordTypeIdFromName('Postulaciones__c', 'Posgrado_de_Negocios');
    private Id rtPogradoAcademico = UtilClass.getRecordTypeIdFromName('Postulaciones__c', 'Posgrado');
    private Id rtGrado = UtilClass.getRecordTypeIdFromName('Postulaciones__c', 'Grado');

    private final String CONFIG_NAME = 'ActualizarEstadoPostulacion';

    private Postulaciones__c postulacion;
    
    public override void setDataToSend(){

        this.postulacion = [SELECT id ,Contacto__c, Nro_de_orden__c,EstadoSIGEDU__c,UltimoIntentoSincronizacion__c,FechaCambioEstadoSIGEDU__c,Etapa_Postulaci_n__c,MensajeErrorSIGEDU__c,
                                    Fecha_de_Admisi_n__c,Fecha_Baja_Postulaci_n__c,Motivo_Baja_de_Postulaci_n__c,Pago_del_arancel_de_inscripci_n__c,Exceptuar_pago_matricula__c,
                                    Oferta_Acad_mica__r.Id_Sigedu__c ,Condicion_de_cursada__c,Legajo_completo__c,Qui_n_paga_la_matr_cula__c,ExceptuarPagoMatriculaFormula__c,RecordTypeId
                                FROM Postulaciones__c WHERE id =: this.recordToSendId];

    }

    public override String getConfigName(){
        return CONFIG_NAME;
    }

    public override String getRequestBody(){
      
        map<String,String> cData = new map<String,String>();

        PostulacionSigedu datos = new PostulacionSigedu();

        datos.nroDeOrden = this.postulacion.Nro_de_orden__c;
        datos.fecha = String.valueOf( this.postulacion.FechaCambioEstadoSIGEDU__c);
        datos.estado =  this.postulacion.Etapa_Postulaci_n__c;
        datos.pago_matricula =  this.postulacion.ExceptuarPagoMatriculaFormula__c;
        datos.inicio_cursada =  this.postulacion.Oferta_Acad_mica__r.Id_Sigedu__c;
        
      
        if(this.postulacion.RecordTypeId ==  this.rtGrado){
         
            datos.getExamenes( this.postulacion.Contacto__c );
           
        }else{
            datos.legajo_completo = this.postulacion.Legajo_completo__c;
            datos.Modalidad_de_ingreso = this.postulacion.Condicion_de_cursada__c  ;
            datos.Quien_paga_la_matricula =this.postulacion.Qui_n_paga_la_matr_cula__c;
            //PostulacionSigedu datos;
        }
       

        return JSON.Serialize(datos);
    }

    public override List<String> getUrlParameters(){
        return new  List<String>{this.postulacion.Nro_de_orden__c};
    }
    

    public override void processResponse(){
        
        this.postulacion.UltimoIntentoSincronizacion__c = this.timeOfTry;
        this.postulacion.EstadoSIGEDU__c = this.status;
        this.postulacion.MensajeErrorSIGEDU__c = this.jsonResponse ;        
        
        PostulacionTriggerMethods.send = false;
        update postulacion;
    }

}