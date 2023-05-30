public without sharing class SendPostulacionesSIGEDU {

   
    public static void sendPostulacion(Set<String> postulaciones){
        
        for(String id:postulaciones){
            generateRequest(id);   
        }           
    }
  //  private static void generateRequest(Id Idpostulacion , String nroOrden, String estado, Date fecha, Boolean pagoMatricula){

    @future(callout=true)
    private static void generateRequest(Id Idpostulacion){
        
        Postulaciones__c postulacion = [SELECT id ,Contacto__c, Nro_de_orden__c,EstadoSIGEDU__c,FechaCambioEstadoSIGEDU__c,Etapa_Postulaci_n__c,MensajeErrorSIGEDU__c,
                                            Fecha_de_Admisi_n__c,Fecha_Baja_Postulaci_n__c,Motivo_Baja_de_Postulaci_n__c,Pago_del_arancel_de_inscripci_n__c,Exceptuar_pago_matricula__c,
                                        	Oferta_Acad_mica__r.Id_Sigedu__c 
                                        FROM Postulaciones__c WHERE id =:Idpostulacion];

       
        map<String,String> cData = new map<String,String>();
        Postulacion datos = new Postulacion();

        datos.nroDeOrden = postulacion.Nro_de_orden__c;
        datos.fecha = String.valueOf(postulacion.FechaCambioEstadoSIGEDU__c);
        datos.estado = postulacion.Etapa_Postulaci_n__c;
        datos.pago_matricula = postulacion.Exceptuar_pago_matricula__c;
        datos.inicio_cursada = postulacion.Oferta_Acad_mica__r.Id_Sigedu__c;
        
        getExamenes(postulacion.Contacto__c, datos);

        List<String> parameters = new List<String>();
        parameters.add(postulacion.Nro_de_orden__c);

        System.debug('datos ' + JSON.Serialize(datos));

        HTTPResponse res = HTTPUtil.DoRequest('ActualizarEstadoPostulacion',null,JSON.Serialize(datos),parameters,'');
        System.debug('response' + res);
        System.debug(res.getBody());
        if(res.getStatusCode() >= 200 && res.getStatusCode() < 300){
            postulacion.EstadoSIGEDU__c = 'ENVIADO';
            postulacion.MensajeErrorSIGEDU__c = '';
        }else {
            postulacion.EstadoSIGEDU__c = 'ERROR';
            postulacion.MensajeErrorSIGEDU__c = res.getBody();          
        }

        PostulacionTriggerMethods.send = false;
        update postulacion;
    }

    private static void getExamenes(Id alumnoId, Postulacion datos ){
        

        List<Ex_men__c> examenes = [SELECT id, Calificaci_n_An_lisis_de_casos__c, Calificaci_n_Razonamiento_matem_tico__c,Calificaci_n_Escritura__c,Calificaci_n_promedio__c,
                                    Fecha_del_examen__c, Resultado__c
                                    FROM Ex_men__c WHERE Contacto__c = :alumnoId order by Fecha_del_examen__c desc];

        
        if(!examenes.isEmpty()){
            
            Ex_men__c examen = examenes[0];

            if(examen.Calificaci_n_An_lisis_de_casos__c != null){
                Examen examenAnalisisCasos = new Examen();

                examenAnalisisCasos.examen = 'analisis de casos';    
                examenAnalisisCasos.nota = Integer.valueOf(examen.Calificaci_n_An_lisis_de_casos__c) ;    

                datos.examenes.add(examenAnalisisCasos);

            }
            if(examen.Calificaci_n_Razonamiento_matem_tico__c  != null ){
                Examen examenRazonamiento = new Examen();

                examenRazonamiento.examen = 'razonamiento matematico';    
                examenRazonamiento.nota = Integer.valueOf(examen.Calificaci_n_Razonamiento_matem_tico__c) ;    

                datos.examenes.add(examenRazonamiento);

            }
            if(examen.Calificaci_n_Escritura__c  != null ){
                Examen examenEscritura = new Examen();

                examenEscritura.examen = 'analisis de casos';    
                examenEscritura.nota = Integer.valueOf(examen.Calificaci_n_Escritura__c) ;    

                datos.examenes.add(examenEscritura);

            }

        }

    }
    public class Postulacion{

        public String nroDeOrden {get;set;}
        public String fecha {get;set;}
        public String estado {get;set;}
        public String pago_matricula {get;set;}
        public String inicio_cursada {get;set;}
        public List<Examen>  examenes {get;set;}

        public Postulacion(){
            examenes = new List<Examen>();
        }
    }

    public class Examen{
        public String examen {get;set;}
        public Integer nota {get;set;}
    }

}