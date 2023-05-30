@isTest
public class TestLeadCheck {

    static testMethod void testLeadCase() {
        insertSettings();
         
        Account noInforma = TestDataFactory.createNoInformaAccount();

        
        Lead creada = TestDataFactory.createOneLeadForCase();

    }
    
    
    static testMethod void testTwoLeadsWithSameEmail() {
        insertSettings();
         
        Account noInforma = TestDataFactory.createNoInformaAccount();
        String keysCourses = TestDataFactory.createTwoCourses();
        Lead creada = TestDataFactory.twoLeadsSameEmail('email@email.com','carrera','colegio',keysCourses );
        System.assert(creada.Nombre_de_cuenta_web__c=='colegio');
        System.assert(creada.Carrera_elegida__c=='carrera');
    }
    
    
    static testMethod void testOneCommonLead() {
        insertSettings();
        Account noInforma = TestDataFactory.createNoInformaAccount();
        String keysCourses = TestDataFactory.createTwoCourses();
        Lead lead = TestDataFactory.createOneCommonLead(keysCourses );
        List <Lead> leads = [SELECT Id FROM Lead];
        System.debug('leads.size():'+leads.size());
        System.assert(leads.size()==1);
        
    }
/*
    static testMethod void testColegioUniversidad() {
     insertSettings();

        Account noInforma = TestDataFactory.createNoInformaAccount();
        String keysActivities = TestDataFactory.createTwoActivities();

        TestDataFactory.createLeadForCollege( 'email@email.com',keysActivities,'Nacional Buenos Aires','Abogacía');
        List <Contact> contactos = [SELECT Id,AccountId,Materias_por_Carrera__c,Nombre_de_cuenta_WEB__c FROM Contact where Email = 'email@email.com'];
        System.debug('contactos.size():'+contactos.size());
        System.assert(contactos.get(0).Materias_por_Carrera__c=='Abogacía');
        System.assert(contactos.get(0).Nombre_de_cuenta_WEB__c=='Nacional Buenos Aires');
        
        
    }
    
    static testMethod void testCreateTwoLeads() {
         insertSettings();
        Account noInforma = TestDataFactory.createNoInformaAccount();
        String keysActivities = TestDataFactory.createTwoActivities();
        String keysCourses = TestDataFactory.createTwoCourses();
        
        
        TestDataFactory.createTwoLeadForActivity( 'email@email.com',keysActivities);
        //1.Testeo que el contacto esté creado
        List <Contact> contactos = [SELECT Id,AccountId FROM Contact where Email = :'email@email.com'];
        System.debug('contactos.size():'+contactos.size());
        System.assert(contactos.size()==1);
        System.assert(contactos.get(0).AccountId==noInforma.Id);
        
        //2. Testeo que esté asignado a la actividad
         List <Asistencia_a_Actividades__c> asistencias = [SELECT Id FROM Asistencia_a_Actividades__c where Contacto__c = :contactos.get(0).Id];
        System.debug('asistencias.size():'+asistencias.size());
        System.assert(asistencias.size()==2);
        //3.Chequeo que no duplique contacto
        TestDataFactory.createTwoLeadForActivity( 'email@email.com',keysActivities);
        contactos = [SELECT Id FROM Contact where Email = :'email@email.com'];
        System.debug('contactos.size():'+contactos.size());
        System.assert(contactos.size()==1);
        
        //3.Chequeo que no duplique registro a actividad
        asistencias = [SELECT Id FROM Asistencia_a_Actividades__c where Contacto__c = :contactos.get(0).Id];
         System.debug('asistencias.size():'+asistencias.size());
        System.assert(asistencias.size()==2);
        
        
          TestDataFactory.createTwoLeadForCursos( 'email2@email.com',keysCourses);
        //1.Testeo que el contacto esté creado
        List <Contact> contactos2 = [SELECT Id FROM Contact where Email = :'email2@email.com'];
        System.debug('contactos2.size():'+contactos2.size());
        System.assert(contactos2.size()==1);
        //2. Testeo que esté asignado a la actividad
         List <Inscripci_n_al_curso__c> inscripciones = [SELECT Id FROM Inscripci_n_al_curso__c where Contacto__c = :contactos2.get(0).Id];
        System.debug('inscripcion.size():'+inscripciones.size());
        System.assert(inscripciones.size()==2);
        //3.Chequeo que no duplique contacto
        TestDataFactory.createTwoLeadForCursos('email2@email.com',keysCourses);
        contactos2 = [SELECT Id FROM Contact where (Email = :'email2@email.com') or (Email = :'email@email.com')];
        System.debug('contactos2.size():'+contactos2.size());
        System.assert(contactos2.size()==2);
        //3.Chequeo que no duplique registro a actividad
        inscripciones = [SELECT Id FROM Inscripci_n_al_curso__c where Contacto__c = :contactos2.get(1).Id];
         System.debug('inscripciones.size():'+inscripciones.size());
      //  System.assert(inscripciones.size()==2);
        
        
    }
    
     */
    static testMethod void testCreateLeads() {
        insertSettings();
        Account noInforma =TestDataFactory.createNoInformaAccount();
        
        Actividad__c actividad1 = TestDataFactory.createActivity('1','Aprendiendo a Elegir','12/10/2012');
        Curso__c curso1 = TestDataFactory.createCourse('1');
        
        TestDataFactory.createOneLeadForActivity('email@email.com',actividad1.Id);
        //1.Testeo que el contacto esté creado
        List <Contact> contactos = [SELECT Id FROM Contact where Email = :'email@email.com'];
        System.debug('contactos.size():'+contactos.size());
        System.assert(contactos.size()==1);
        
        //2. Testeo que esté asignado a la actividad
        List <Asistencia_a_Actividades__c> asistencias = [SELECT Id FROM Asistencia_a_Actividades__c where Contacto__c = :contactos.get(0).Id];
        System.debug('asistencias.size():'+asistencias.size());
        System.assert(asistencias.size()==1);
        //3.Chequeo que no duplique contacto
        TestDataFactory.createOneLeadForActivity('email2@email.com',actividad1.Id);
        contactos = [SELECT Id FROM Contact where Email = :'email2@email.com'];
        System.debug('contactos.size():'+contactos.size());
        System.assert(contactos.size()==1);
        //3.Chequeo que no duplique registro a actividad
        asistencias = [SELECT Id FROM Asistencia_a_Actividades__c where Contacto__c = :contactos.get(0).Id];
         System.debug('asistencias.size():'+asistencias.size());
        System.assert(asistencias.size()==1);
        
        try{
             TestDataFactory.createOneLeadForActivity('email2@email.com',actividad1.Id);
        }catch(Exception ex){
            system.debug(ex);
        }
        
        
        TestDataFactory.createOneLeadForCursos('email2@email.com',curso1.Id);
        //1.Testeo que el contacto esté creado
        List <Contact> contactos2 = [SELECT Id FROM Contact where Email = :'email2@email.com'];
        System.debug('contactos2.size():'+contactos2.size());
        System.assert(contactos2.size()==1);
        //2. Testeo que esté asignado a la actividad
         List <Inscripci_n_al_curso__c> inscripciones = [SELECT Id FROM Inscripci_n_al_curso__c where Contacto__c = :contactos2.get(0).Id];
        System.debug('inscripcion.size():'+inscripciones.size());
        System.assert(inscripciones.size()==1);
        //3.Chequeo que no duplique contacto
        TestDataFactory.createOneLeadForCursos( 'email3@email.com',curso1.Id);
        contactos2 = [SELECT Id FROM Contact where (Email = :'email3@email.com') or (Email = :'email@email.com')];
        System.debug('contactos2.size():'+contactos2.size());
        System.assert(contactos2.size()==2);
        //3.Chequeo que no duplique registro a actividad
        inscripciones = [SELECT Id FROM Inscripci_n_al_curso__c where Contacto__c = :contactos2.get(1).Id];
         System.debug('inscripciones.size():'+inscripciones.size());
     //   System.assert(inscripciones.size()==1);
   		
        try{
              TestDataFactory.createOneLeadForCursos( 'email3@email.com',curso1.Id);
        }catch(Exception ex){
            system.debug(ex);
        }
        
        
        TestDataFactory.createOneLeadForInfo('email3@email.com');
        //1.Testeo que el contacto esté creado
        List <Contact> contactos3 = [SELECT Id FROM Contact where Email = :'email3@email.com'];
        System.debug('contactos3.size():'+contactos3.size());
        System.assert(contactos3.size()==1);
       
        asistencias = [SELECT Id FROM Asistencia_a_Actividades__c where Contacto__c = :contactos3.get(0).Id];
         System.debug('asistencias.size():'+asistencias.size());
        System.assert(asistencias.size()==0);
        
        inscripciones = [SELECT Id FROM Inscripci_n_al_curso__c where Contacto__c = :contactos3.get(0).Id];
         System.debug('inscripciones.size():'+inscripciones.size());
       // System.assert(inscripciones.size()==0);
        
    }
 
    public static void insertSettings(){
    
        ConfiguracionUdesa__c  c = new ConfiguracionUdesa__c();
        c.name = 'DBAConfig';
        c.ContactRecordTypeWeb__c = 'AG - Posibles';
        c.AccountName__c = 'NO INFORMA';
        insert c;
    }
}