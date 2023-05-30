public class LeadTriggerClass{
    
   public static void registerContact(List<Lead> leadsInsert){
        
         
        set<String> setLeadsEmail = new Set<String>();
        List<Lead> leadsToProcess = new List<Lead>();
       
        for (Lead l:leadsInsert) {
            system.debug('entro Lead ' + l);
            if(l.AutomaticConversionToContact__c){
                system.debug(l.AutomaticConversionToContact__c);
                setLeadsEmail.add(l.Email);
                leadsToProcess.add(l);
            }           
        }
      	
       if(!leadsToProcess.isEmpty()){
            
            //Contact to Update
            List<Contact> contactsToUpdate = new List<Contact>();
            //Contact to Insert
            List<Contact> contactsToInsert = new List<Contact>();
    
            //Record type del contacto por defualt
            ConfiguracionUdesa__c config = ConfiguracionUdesa__c.getInstance('DBAConfig');    
            String defaultRecordType =  CommonMethods.getContactRecordTypeId(config.ContactRecordTypeWeb__c);
           
            
            map<String,Contact> mapEmailContact =  getMapOldContact(new list<String>(setLeadsEmail));
            
            for (Lead l:leadsToProcess) {
               
                //trae si existe el contacto
                Contact oldContact = mapEmailContact.get(l.Email);
                //si existe lo actualiza 
                if (oldContact != null) {        
                    mapEmailContact.put(l.Email, updateContact(oldContact , l));              
                }else{
                    //sino lo inserta 
                    contactsToInsert.add(createContact(l,defaultRecordType));
                }
                
            }
            
           try{
                //Se actualizan o se insertan los contactos
                update mapEmailContact.Values();
                insert contactsToInsert;
               
                //relaciono contacots con lead
                for(Contact c: contactsToInsert){
                    mapEmailContact.put(c.Email, c);
                }
                
                for (Lead l:leadsToProcess) {
                    Contact c = mapEmailContact.get(l.Email);
                    if(c != null) {
                        l.Contacto__c = c.id;
                    }
                }
            }catch(Exception ex){
                 System.debug('Error: ' + ex.getMessage()  );
            } 	
           
       }
       
       
               
        
    }

    // METODO PARA REGISTRAR A LOS CONTACTOS A LAS ACTIVIDADES O CURSOS
    public static void register(List<Lead> leadsTrigger){
    
        List<Lead> leadWithActivities = new List<Lead>();
        List<Lead>  leadWithCourses = new List<Lead>();
        
        for(Lead l : leadsTrigger){
            if(l.CursoID__c != null && l.Contacto__c != null)
                leadWithCourses.add(l);
             
            if(l.ActividadID__c != null  && l.Contacto__c != null)
                leadWithActivities.add(l);
  
        }
        
        if(leadWithActivities.size() > 0)
            registerActivity(leadWithActivities);
        
        if(leadWithCourses.size() > 0)
            registarCourses(leadWithCourses);
    
    }

    public static void registerActivity(List<Lead> leadList){
        
        set<id> contactsId = new set<id>();
        set<String> activitiesId = new set<String>();
        
        for(Lead l : leadList){
            contactsId.add(l.Contacto__c);
            for(String a: l.ActividadID__c.split(';')){
           		 activitiesId.add(a);
            }                
        }
        
        system.debug( activitiesId);
        system.debug( contactsId);
  		
        map<id,Actividad__c> mapAct = new map<id,Actividad__c>([SELECT id, Name, Nombre_de_la_actividad__c  FROM Actividad__c WHERE id in :activitiesId ]) ;
        //validad ya no este registrado a la acividad                 
        map<id, map<String,Boolean>> mapContactOldActivity = getMapContactOldActivity(contactsId, activitiesId);
        system.debug( mapContactOldActivity);
        
        //lista para insertar las actividades
        List<Asistencia_a_Actividades__c> activitiesToInsert = new List<Asistencia_a_Actividades__c>();
        
        for(Lead l : leadList){        
            map<String,Boolean> mapOldActivity = mapContactOldActivity.get(l.Contacto__c);
            for(String a: l.ActividadID__c.split(';')){
                
                if(mapOldActivity != null && mapOldActivity.get(Id.valueOf(a)) != null ){
                    string error =  'El contacto ya esta inscripto en la actividad ' + mapAct.get(a).Nombre_de_la_actividad__c  ;   
                    l.Description  = (l.Description!=null)? l.Description + ' ' + error : error ;       
                    l.addError(error);
                }else{
                    //falta validar que exista la actividad
                        Asistencia_a_Actividades__c asistencia = new Asistencia_a_Actividades__c(
                            Actividad__c = a,
                            Cargado_por__c = l.leadSource,
                            Contacto__c = l.Contacto__c,
                            Inscripci_n__c = 'Si'
                        );
                        activitiesToInsert.add(asistencia); 
                } 
            }
        }
        try{
            insert activitiesToInsert;
        }catch(Exception ex){
            system.debug(ex.getMessage());
        }
    }
    
    private static map<id, map<String,Boolean>> getMapContactOldActivity(set<id> contactsId,set<String> activitiesId){
        
        map<id, map<String,Boolean>> mapContactOldActivity = new map<id, map<String,Boolean>>();
        
        List<Asistencia_a_Actividades__c> oldActivities =  [SELECT Id, Contacto__c,Actividad__c  from Asistencia_a_Actividades__c where  Actividad__c in :activitiesId and Contacto__c in:contactsId];     
        for(Asistencia_a_Actividades__c asistAct: oldActivities){
            
            map<String,Boolean> mapOldActivity = mapContactOldActivity.get(asistAct.Contacto__c);

            if(mapOldActivity == null)
                mapOldActivity = new map<String,Boolean>();
            
            mapOldActivity.put(asistAct.Actividad__c, true);
            
            mapContactOldActivity.put(asistAct.Contacto__c, mapOldActivity);
        }
        return mapContactOldActivity;
    }
    
    public static void registarCourses(List<Lead> leadList){
    
        set<id> contactsId = new set<id>();
        set<id> coursesId = new set<id>();
        
        for(Lead l : leadList){
            contactsId.add(l.Contacto__c);
            coursesId.add(l.CursoID__c);                
        }
        map<id, map<id,Boolean>> mapContactOldCourses = getMapContactOldCourses(contactsId,coursesId);

        List<Inscripci_n_al_curso__c> coursesToInsert = new List<Inscripci_n_al_curso__c>();
        
        for(Lead l : leadList){
            map<id,Boolean> mapOldCourses = mapContactOldCourses.get(l.Contacto__c);
            
            if(mapOldCourses  != null && mapOldCourses.get(l.CursoID__c) != null ){
                string error =  'El contacto ya esta inscripto en el curso ' + l.CursoID__c ;
                l.Description  = (l.Description!=null)? l.Description + ' ' + error : error ;       
                System.debug(error );
                l.addError(error);
            }else{
                Inscripci_n_al_curso__c inscripcion = new Inscripci_n_al_curso__c(
                            Curso__c = l.CursoID__c,
                            Cargado_por__c = l.leadSource,
                            Contacto__c = l.Contacto__c
                 );
                coursesToInsert.add(inscripcion);
            } 
        }
        
        try{
            insert coursesToInsert;
        }catch(Exception ex){
            system.debug(ex.getMessage());
        }
    }
    
    private static  map<id, map<id,Boolean>> getMapContactOldCourses(set<id> contactsId, set<id> coursesId){
        map<id, map<id,Boolean>> mapContactOldCourses = new map<id, map<id,Boolean>>();
        List<Inscripci_n_al_curso__c> oldCursos =  [SELECT Id, Contacto__c,Curso__c from Inscripci_n_al_curso__c where  Curso__c in :coursesId and Contacto__c in:contactsId];   
  
        for(Inscripci_n_al_curso__c ac : oldCursos ){    
            map<id,Boolean> mapOldCourses = mapContactOldCourses.get(ac.Contacto__c);
            
            if(mapOldCourses == null)
                mapOldCourses = new map<id,Boolean>();
            
            mapOldCourses.put(ac.Curso__c , true);
            mapContactOldCourses.put(ac.Contacto__c, mapOldCourses);       
        }
        return mapContactOldCourses;
    }
    public static void registerCases(List<Lead> leadList){
        List<Case> cases = new List<Case>();
        for(Lead l : leadList){
            if(l.CaseDescription__c  != null && l.Contacto__c != null){
            	Case consulta = new Case(Origin= 'Web',Priority='Baja');   
            	consulta.ContactId = (l.Contacto__c != null)? l.Contacto__c : '';
                consulta.Type =  (l.CaseType__c  != null)? l.CaseType__c : '' ;
                consulta.Reason = (l.CaseReason__c  != null)? l.CaseReason__c : '' ;   
                consulta.Subject= (l.CaseSubject__c  != null)? l.CaseSubject__c : '' ; 
                consulta.Description = l.CaseDescription__c;
            	
                cases.add(consulta);
            }              
        }
        
        insert cases;
    }   
   
   private static Contact updateContact(Contact oldContact , Lead l){
        
        oldContact.Nombre_de_cuenta_WEB__c = (l.Nombre_de_cuenta_WEB__c != null)? l.Nombre_de_cuenta_WEB__c: oldContact.Nombre_de_cuenta_WEB__c ;
        oldContact.Materias_por_Carrera__c = (l.Carrera_elegida__c != null)? l.Carrera_elegida__c: oldContact.Materias_por_Carrera__c ;
        oldContact.A_o_interesado_en_ingresar__c = (l.A_o_interesado_ingresar__c != null)?l.A_o_interesado_ingresar__c : oldContact.A_o_interesado_en_ingresar__c;
        oldContact.MobilePhone = (l.MobilePhone != null)?l.MobilePhone : oldContact.MobilePhone;
        oldContact.Localidad__c = (l.Localidad__c != null)? l.Localidad__c : oldContact.Localidad__c ;  
        oldContact.Documento__c = (l.NumeroDocumento__c != null)? l.NumeroDocumento__c  : oldContact.Documento__c ; 
		oldContact.TipoDocumento__c = (l.DocumentType__c != null)? l.DocumentType__c  : oldContact.TipoDocumento__c ;   
       
        return oldContact;
   
   }
   
   private static Contact createContact( Lead l,String defaultRecordType){
   
        Contact newContact = new Contact();

        newContact.FirstName = l.FirstName;
        newContact.LastName = l.LastName;
        newContact.Email = l.Email;
        newContact.MobilePhone = l.MobilePhone;
        newContact.Phone = l.Phone;
        newContact.A_o_interesado_en_ingresar__c = l.A_o_interesado_ingresar__c;
        newContact.Cargado_por__c= l.leadSource; //ver si va leadsource
       	newContact.RecordTypeId = ( l.ContactRecordType__c != null)?  l.ContactRecordType__c : defaultRecordType;
        newContact.Description = l.Description;
        newContact.Nombre_de_cuenta_WEB__c = l.Nombre_de_cuenta_WEB__c;
        newContact.Materias_por_Carrera__c = l.Carrera_elegida__c;
        newContact.Localidad__c = l.Localidad__c;
        newContact.Documento__c = l.NumeroDocumento__c ;   
		newContact.TipoDocumento__c = l.DocumentType__c;
       	newContact.Cargo_en_colegio__c  = l.CargoColegio__c;
       newContact.Clasificaci_n__c  = l.Clasificacion__c ;
        

  
        return newContact;        
   }
   
   private static map<String,Contact>  getMapOldContact(list<String> emails){
   	 	
   	 	map<String,Contact> mapEmailContact; 	 	
        list<Contact> oldContacts;

        try{
            oldContacts =  [SELECT Id, Description, Email, Nombre_de_cuenta_WEB__c, Materias_por_Carrera__c, A_o_interesado_en_ingresar__c, MobilePhone, Localidad__c, Provincia__c, Pa_s__c,Documento__c,TipoDocumento__c
                            from Contact 
                            where Email  in :emails];			
        }catch(Exception ex){}
        
        
        if (oldContacts!= null) {
        	mapEmailContact = new map<String,Contact>();
            for (Contact c:oldContacts) {
                mapEmailContact.put(c.Email,c);
            }
        }
        
        return mapEmailContact;
   }

}