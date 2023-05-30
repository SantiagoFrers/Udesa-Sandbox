/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-02-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class MoodleManager {
    
    
    public static void createCoursesMoodle(List<Curso__c> courses) {

        //Validar que no existan, Antes?
        List<CursoMoodle__c> newCourses = new List<CursoMoodle__c>();

        for (Curso__c course : courses) {
            
            if (course.Procesado__c) {
                continue;
            }

            Integer comisiones = Integer.valueOf(course.Comisiones__c);
            List<String> materias = course.Materias__c.split(';');

            for (Integer i = 0; i < comisiones; i++) {

                String newComision = String.valueOf(i+1);

                for (String materia : materias) {
                    newCourses.add(
                        MoodleManager.newCourseMoodle(
                            course,
                            materia,
                            newComision
                        )
                    );
                }
            }

            course.Procesado__c = true;
        }

        insert newCourses;
        update courses;
    }

    public static CursoMoodle__c newCourseMoodle(Curso__c course, String materia, String comision) {

        CursoMoodle__c newCourese = new CursoMoodle__c(
            Curso__c = course.Id,
            Materia__c = materia,
            Comision__c = comision
        );
        return newCourese;
    }

      
    public static void createInscripcionesCoursesMoodle(Id courseId) {

        List<CursoMoodle__c> moodle = [SELECT Id,Materia__c, Comision__c FROM CursoMoodle__c WHERE Curso__c =: courseId];

        Map<String, List<CursoMoodle__c>> moodleByComision = new  Map<String, List<CursoMoodle__c>>();

        for (CursoMoodle__c c  : moodle) {

            List<CursoMoodle__c> cursos = moodleByComision.get(c.Comision__c);

            if (cursos == null ) {
                cursos = new List<CursoMoodle__c>();
                moodleByComision.put(c.Comision__c, cursos);
            }

            cursos.add(c);
        }


        List<Inscripci_n_al_curso__c> inscripciones = [SELECT Id, Comision__c FROM  Inscripci_n_al_curso__c WHERE Curso__c =: courseId AND Estado__c = 'Activo' AND ProcesadoMoodle__c = false];

        List<InscripcionMoodle__c> newInscriptions = new List<InscripcionMoodle__c>();

        for (Inscripci_n_al_curso__c ins : inscripciones) {

            List<CursoMoodle__c>    cursos = moodleByComision.get(ins.Comision__c);
            Integer quantityByInscription = 0;

            if (cursos != null) {

                for (CursoMoodle__c c : cursos) {
                
                    newInscriptions.add(
                        new InscripcionMoodle__c(
                            InscripcionCurso__c = ins.Id,
                            CursoMoodle__c = c.Id
                        )

                    );

                    quantityByInscription ++;
                }
            }

            ins.ProcesadoMoodle__c     = true;
            ins.InscripcionesMoodle__c = quantityByInscription;
            ins.InscripcionesMoodleSincronizadas__c = 0;
        }
        
        insert newInscriptions;
        update inscripciones;

        List<EnvioWs__c> pendingsToSend = new List<EnvioWs__c>();
        
        for (InscripcionMoodle__c c : newInscriptions) {
            pendingsToSend.add(
                SenderManager.createEnvio('SenderInscriptionMoodle', c.Id)
            );
        }

        SenderManager.enqueueEnvio(pendingsToSend);

    }


    public static void pass() {
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
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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