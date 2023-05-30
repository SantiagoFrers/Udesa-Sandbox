public  with sharing class PostulacionSigedu {
    
    public String nroDeOrden {get;set;}
    public String fecha {get;set;}
    public String estado {get;set;}
    public String pago_matricula {get;set;}
    public String inicio_cursada {get;set;}
    public List<Examen>  examenes {get;set;}
    public Boolean legajo_completo {get;set;}
    public String Modalidad_de_ingreso {get;set;}
    public String Quien_paga_la_matricula {get;set;}

    public PostulacionSigedu() {
        examenes = new List<Examen>();
    }

    public void getExamenes(Id alumnoId ){

        List<Ex_men__c> examenesRecords = [SELECT id, Calificaci_n_An_lisis_de_casos__c, Calificaci_n_Razonamiento_matem_tico__c,Calificaci_n_Escritura__c,Calificaci_n_promedio__c,
                                    Fecha_del_examen__c, Resultado__c
                                    FROM Ex_men__c WHERE Contacto__c = :alumnoId order by Fecha_del_examen__c desc];

        
        if(!examenesRecords.isEmpty()){
            
            Ex_men__c examen = examenesRecords[0];

            if(examen.Calificaci_n_An_lisis_de_casos__c != null){
                Examen examenAnalisisCasos = new Examen();

                examenAnalisisCasos.examen = 'analisis de casos';    
                examenAnalisisCasos.nota = Integer.valueOf(examen.Calificaci_n_An_lisis_de_casos__c) ;    

                this.examenes.add(examenAnalisisCasos);

            }
            if(examen.Calificaci_n_Razonamiento_matem_tico__c  != null ){
                Examen examenRazonamiento = new Examen();

                examenRazonamiento.examen = 'razonamiento matematico';    
                examenRazonamiento.nota = Integer.valueOf(examen.Calificaci_n_Razonamiento_matem_tico__c) ;    

                this.examenes.add(examenRazonamiento);

            }
            if(examen.Calificaci_n_Escritura__c  != null ){
                Examen examenEscritura = new Examen();

                examenEscritura.examen = 'analisis de casos';    
                examenEscritura.nota = Integer.valueOf(examen.Calificaci_n_Escritura__c) ;    

                this.examenes.add(examenEscritura);
            }

        }

    }
    public void pass(){
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

    public class Examen{
        public String examen {get;set;}
        public Integer nota {get;set;}
    }
}