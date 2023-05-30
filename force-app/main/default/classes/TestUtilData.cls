@isTest
public with sharing class TestUtilData {


    public static Account createCarrera(String idSigedu, String name){
        
        Id recorcdTypeId = getRecordTypeID('Account', 'Academic_Program');

        Account c = new Account(recordTypeId = recorcdTypeId, name = 'test', idSigedu__c = idSigedu, Unidad_de_negocios__c ='Grado');
        
        insert c; 
        return c;
    }

    public static Oferta_Acad_mica__c creteInicioCursada(String idSigedu,String idCarrera){

        Oferta_Acad_mica__c ic = new Oferta_Acad_mica__c();
        ic.Id_Sigedu__c = idSigedu;
        ic.Carrera__c = idCarrera;

        insert ic;

        return ic;
    }

    public static Lead createLead(String email){

        Lead l = new Lead(Company = 'test', email = email, lastName ='test', AutomaticConversionToContact__c = false);

        insert l;

        return l;
    }

    public static Beca__c createBeca(String name,Double idSigedu){

        Beca__c b = new Beca__c();
        b.Name = name;
        b.ID_BECA_SIGEDU__c = idSigedu;
       

        insert b;

        return b;
    }

    public static Id getRecordTypeID(String objectName, String recordTypeName){  
       

        return [SELECT Id, SobjectType, Name, DeveloperName
                        FROM RecordType
                        WHERE SobjectType= : objectName
                            and DeveloperName = :recordTypeName
                        LIMIT 1].id;
    }

    public static Contact getContact(String email){

        Contact c = new Contact();
        c.firstName = 'test';
        c.lastName = 'test';
        c.email = email;


        insert c;

        return c;

    }

    public static Postulaciones__c createPostulacion(Id idCarrera, Id idContacto, String nroOrden ){
        
        Postulaciones__c postulacion = new Postulaciones__c();

        postulacion.Name = '.';
        postulacion.Contacto__c = idContacto;
        postulacion.Cuenta__c = idCarrera;
        postulacion.Nro_de_orden__c = nroOrden;
        postulacion.Fecha_de_postulaci_n__c = Date.today();
		postulacion.Fiador_solidario__c  = 'No aplica';
        postulacion.Carta_admision__c = 'No aplica';
                postulacion.Copia_de_art_culos_o_publicaciones__c  = 'No aplica';

                postulacion.CV__c  = 'No aplica';

                postulacion.Fap001__c  = 'No aplica';

                postulacion.Fiador_solidario__c  = 'No aplica';

                postulacion.Ficha_de_la_Organizaci_n_de_pertenencia__c  = 'No aplica';

                postulacion.Foto_perfil__c  = 'No aplica';
        postulacion.T_tulo_de_grado__c   = 'No aplica';
         postulacion.Anal_tico_de_grado__c    = 'No aplica';
        postulacion.Reunion_informativa__c ='Inscripto';
        postulacion.Reunion_con_director_Sede__c ='Sede Riobamba';
        postulacion.Reunion_informativa_Sede__c ='Sede Riobamba';
         

        
        
        insert postulacion;
        return postulacion;
    }

    public static Ex_men__c createExamen(Id alumnoId){
        Ex_men__c examen = new Ex_men__c();

        examen.Fecha_del_examen__c = Date.today();
        examen.Calificaci_n_Razonamiento_matem_tico__c = 10.0;
        examen.Calificaci_n_Escritura__c = 10.0;
        examen.Calificaci_n_An_lisis_de_casos__c = 10.0;
        examen.Contacto__c = alumnoId;

        insert examen;

        return examen;

    }
    
    public static Becas__c createPostulacionBeca(Id idBeca, Id alumnoId, Id postulacionId){
    	
        Becas__c postulacionBeca = new Becas__c();
        
        postulacionBeca.Beca__c = idBeca;
        postulacionBeca.Contacto__c = alumnoId;
        postulacionBeca.Postulacion__c = postulacionId;
        postulacionBeca.Estado__c = 'Pendiente de resolución';
        
        insert postulacionBeca;
        
        
        return postulacionBeca;
    }
    
    public static Postulaciones__c createPostulacionScene(){


        Contact alumno = TestUtilData.getContact('Test@test.com');
        Account carrera = TestUtilData.createCarrera('AD','Administracion');
        Oferta_Acad_mica__c inicioCursada = TestUtilData.creteInicioCursada('1',carrera.id);
        Ex_men__c examen = createExamen(alumno.id);
        Postulaciones__c postulacion = TestUtilData.createPostulacion(carrera.id, alumno.id, '1');


        return postulacion;

    }
    
     public static void createPostulacionBecaScene(){


        Contact alumno = TestUtilData.getContact('Test@test.com');
        Account carrera = TestUtilData.createCarrera('AD','Administracion');
        Postulaciones__c postulacion = TestUtilData.createPostulacion(carrera.id, alumno.id, '1');
		
        Beca__c beca = createBeca('BecaTest',12345);
		Beca__c beca2 = createBeca('BecaTest2',123452);
        
        Becas__c postulacionBeca1 = createPostulacionBeca(beca.id, alumno.id,  postulacion.Id);
        Becas__c postulacionBeca2 = createPostulacionBeca(beca2.id, alumno.id,  postulacion.Id);
    }

}