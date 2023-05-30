public with sharing class FormularioActividadesPadresController {

    public Contact cntPadre {get;set;}
    public Contact cntHijo {get;set;}
    public Actividad__c actividad {get;set;}
    public Asistencia_a_Actividades__c asistenciaActividad {get;set;}
    public boolean success{get;set;}

    public Case consulta {get;set;}
    public String case_type {get;set;}
    public String case_Reason {get;set;}
    public String case_subject {get;set;}
    
    public FormularioActividadesPadresController(){
        cntPadre = new Contact();
        cntHijo = new Contact();
      //consulta = new Case(Origin= 'Web', Type = 'Contactos', Reason='Consulta', Subject='Consulta Web');
        consulta = new Case(Origin= 'Web',Priority='Baja');
               
        String id = ApexPages.currentPage().getParameters().get('id'); 
        try{
            actividad = [SELECT id, name, Nombre_de_la_actividad__c FROM Actividad__c WHERE id = :id];
        }catch(Exception ex){}    
        
        if(actividad != null){
          asistenciaActividad = new Asistencia_a_Actividades__c();
          asistenciaActividad.Actividad__c= actividad.Id;
          asistenciaActividad.Cargado_por__c = 'Web';
          consulta.subject = 'Inscripción a Actividad';
        }
       
        success = false;
    }
    
    public PageReference save(){
        
        if(actividad == null || !validate()){
            return null;
        }
        
        Contact oldContact = CommonMethods.getOldContact(cntPadre.Email);
        Id cntId = getIdPadre();
        
        if(cntId == null )
            return null;
        
        Id asistenciaId =  registerActivity(actividad.id,cntId);
        
        if(asistenciaId == null )
            return null;
        
        if(consulta.description != null && consulta.description != '' ){
            insertCase(cntId,asistenciaId);
        }
        
        
        if(cntHijo.email != null){
           id idHijo = getIdHijo();
           if(idHijo == null || !createAffiliation(cntId,idHijo))
               return null;           
        }
       
        success = true;
        return null;
    }
    
    private Boolean validate(){
        
        if(((cntHijo.firstname != null && cntHijo.firstname != '') || ( cntHijo.lastname != null && cntHijo.lastname != '') || (cntHijo.email != null && cntHijo.email != '')) && ((cntHijo.firstname == null || cntHijo.firstname == '') ||( cntHijo.lastname == null || cntHijo.lastname == '') || (cntHijo.email == null || cntHijo.email == ''))){
            apexpages.addmessage(new Apexpages.Message(ApexPages.Severity.Error,'Faltan datos del hijo')); 
            return false;  
        }
        
        if(cntHijo.Email != null && cntPadre.Email == cntHijo.Email){
            apexpages.addmessage(new Apexpages.Message(ApexPages.Severity.Error,'Los Correos electrónicos no pueden ser iguales')); 
            return false;  
        }
        
        return true;
    }
    
    private Id getIdPadre(){
        
        Contact oldContact = CommonMethods.getOldContact(cntPadre.Email);
        Id cntId;
        
        if(oldContact != null){            
            return oldContact.id; 
        }else{
            
            cntPadre.Cargado_por__c = 'WEB';  
            cntPadre.RecordTypeId = CommonMethods.getContactRecordTypeId('AG - General');

            try{
                insert cntPadre;  
                return cntPadre.id;
            }catch(DMLException ex){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getDMLMessage(0)));  
            }    
        }
        return null;
    }
    
    private void insertCase(Id cntId, Id asistenciaId){
        
        consulta.ContactId = cntId;
        consulta.Type = case_type;
        consulta.Reason = case_Reason ;
        consulta.Subject= case_subject ;
        consulta.AsistenciaActividad__c = asistenciaId;
        
        insert consulta;
    }
    
    private Boolean createAffiliation(Id idPadre,Id idHijo){

            hed__Relationship__c rel = new hed__Relationship__c();
            rel.hed__Contact__c =  idPadre;
            rel.hed__relatedContact__c = idHijo;
            rel.hed__type__c = 'Child';
            
            try{ 
                 insert rel;
            }catch(DMLException ex){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getDMLMessage(0)));  
                return false;
            } 
        
        return true;
    }
    
    private Id registerActivity(Id activityId, Id cntId){
        
        //Validar por trigger y poner label********************************************
        if(CommonMethods.validateActividad(cntId, activityId)){
            apexpages.addmessage(new Apexpages.Message(ApexPages.Severity.Error,'Ya estás inscripto en esta actividad')); 
            return null;  
        }
         try{
            asistenciaActividad.Contacto__c = cntId;
            insert asistenciaActividad;
            return asistenciaActividad.id;    
        }catch(DMLException ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getDMLMessage(0)));          
        }
        
        return null;
    }
    
    private Id getIdHijo(){
        
         Contact oldContactHijo = CommonMethods.getOldContact(cntHijo.Email);
         
         if(oldContactHijo != null){
            return oldContactHijo.id;
         }else{
            cntHijo.Cargado_por__c = 'WEB';  
            cntHijo.RecordTypeId = CommonMethods.getContactRecordTypeId('AG - Posibles');
            try{ 
                 insert cntHijo;
                 return cntHijo.id;
            }catch(DMLException ex){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getDMLMessage(0)));  
            }    
         }
        
        return null;
    }
}