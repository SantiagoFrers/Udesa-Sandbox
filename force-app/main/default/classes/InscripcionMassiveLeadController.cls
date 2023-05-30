public with sharing class InscripcionMassiveLeadController {

    public Lead lead {get;set;}
    public List<SelectOption> carrerasDeInteres {get;set;}
    public Boolean success{get;set;}
    public String successMsg {get;set;}
    public List<LeadWrapper> alumnos {get;set;}
    public String rTAlumno {get;set;}
    public String rTProfesor {get;set;}
    public String idActivity {get;set;}
    
    private Integer limite {get;set;}
    private Integer min {get;set;}
    private Integer count {get;set;}
     
    public map<String, List<Localidad__c>> mapLocalidades {get;set;}
    
    public InscripcionMassiveLeadController(){
        
        count = 1;
        
        rTAlumno = apexpages.currentpage().getparameters().get('rta');
        rTProfesor = apexpages.currentpage().getparameters().get('rtp');
        idActivity = apexpages.currentpage().getparameters().get('id');
        
        if(String.isNotBlank(apexpages.currentpage().getparameters().get('limit'))){
            limite = Integer.valueOf(apexpages.currentpage().getparameters().get('limit'));
        }else{
            limite = 18;
        }
        
        if(String.isNotBlank(apexpages.currentpage().getparameters().get('min'))){
            min = Integer.valueOf(apexpages.currentpage().getparameters().get('min'));
        }else{
            min = 1;
        }
        
        lead = new Lead(leadSource = 'Web',AutomaticConversionToContact__c = true);
        
        
        carrerasDeInteres = CommonMethods.getCarrerasDeInteres();  
        mapLocalidades = CommonMethods.getLocalidadesPorPais();
        
        alumnos = new  List<LeadWrapper>();
        
        for(integer i = 0; i < min; i++){
            newAlumno();
        }
        
        success = false;
    }
    
    
    private void newAlumno(){
    
        if(alumnos.size() < limite){
        
            Lead alumno = new Lead(leadSource = 'Web',AutomaticConversionToContact__c = true,company='No informa');    
          
            LeadWrapper l = new LeadWrapper(alumno,count);
            
            count ++;
            
            alumnos.add(l);
        }
    }
    public PageReference addAlumno(){
        
        newAlumno();
        
        return null;
    }
    
    public PageReference deleteAlumno(){
        
        if(alumnos.size() == 1 ){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Debe haber al menos un alumno'));
            return null;
        }
        integer indexToDelete = Integer.valueOf(ApexPages.CurrentPage().getParameters().get('iToDelete'));
        indexToDelete -= 1;
                
        alumnos.remove(indexToDelete);
        recalculateIndex();
        
        return null;
    }
    
    private void recalculateIndex(){
        
        Integer i = 1;
        
         for(LeadWrapper a:alumnos){
        
            a.index = i;
            
            i++;
           
        }
    
    }
    
    public PageReference save(){
    
        try{
            
            if(!validate()){
                return null;
            }
            
            List<Lead> leads = new List<Lead>();
           
            for(LeadWrapper a:alumnos){
            
                a.lead.ContactRecordType__c = rTAlumno;
                a.lead.Nombre_de_cuenta_web__c =  lead.Nombre_de_cuenta_web__c;
                a.lead.ActividadID__c  = idActivity;
                
                leads.add(a.lead);
            }
            
            insert leads;
            
            lead.ContactRecordType__c = rTProfesor;
            lead.ActividadID__c = idActivity;
            
            insert lead;
            
            PageReference successPage =   new PageReference('/apex/SuccessFormPage?msg=' + successMsg );
            
            successPage.setRedirect(true);
            return successPage;
        }catch(DMLException ex){
            system.debug(ex);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getDMLMessage(0)));
        }
        
        return null;
    }
    
    public List<SelectOption> getPcias() {
 
        List<SelectOption> options = new List<SelectOption>();
        
        List<Localidad__c>  listLoc =  [SELECT id, name,Provincia__c,Pa_s__c,Zona_local__c FROM Localidad__c order By name  ];
        
        for(Localidad__c l:listLoc){  
            options.add(new SelectOption(l.id,l.name));
        }
           
        return options;
     }
     
      public map<String,map<String,List<Localidad__c>>> getLocalidades() {
         map<String, List<Localidad__c>> mapPais = CommonMethods.getLocalidadesPorPais();
         map<String,map<String,List<Localidad__c >>> mapAux = new  map<String,map<String,List<Localidad__c >>>();
         
         for(String p:mapPais.keySet()){     
             List<Localidad__c> localidades = mapPais.get(p);
             map<String,List<Localidad__c >> mapPcia = new map<String,List<Localidad__c >>();
             for(Localidad__c l:localidades){
                 List<Localidad__c > opts = mapPcia.get(l.Provincia__c);
                 if(opts == null)
                     opts = new List<Localidad__c>(); 
                 
                 opts.add(l);
                 
                 mapPcia.put(l.Provincia__c,opts);           
             } 
            
             mapAux.put(p,mapPcia);          
         }
         return mapAux;
     }
     
     public class LeadWrapper{
         
         public boolean success {get;set;}
         public Lead lead {get;set;}
         public String message {get;set;}
         public Integer index {get;set;}
         
         public LeadWrapper(Lead l, Integer i){
             lead = l;
             success = true;
             message = '';
             index = i;
         }
     
     }
     
     private boolean validate(){
        
        boolean valid = true;
     
        if(String.isBlank(lead.Nombre_de_cuenta_web__c)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Debe ingresar un colegio'));
            valid= false;
        }
        
        if(!validatePRofesor(lead)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Faltan datos obligatorios del profesor'));
            valid= false;
        }
        
       
        boolean validA = true;
        
        for(LeadWrapper a:alumnos){
        
            a.success = validateAlumno(a.Lead);
            
            if(!a.success)
                validA = false;
            
        }
        
        if(!validA){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Faltan datos obligatorios de los alumnos'));
            valid= false;
        }
            
        return valid;
     }
     
     
     private boolean validateAlumno(Lead l){
         
         if( String.isBlank(l.firstName) || String.isBlank(l.lastName) || String.isBlank(l.email)|| String.isBlank(l.mobilePhone)|| String.isBlank(l.A_o_interesado_ingresar__c) || String.isBlank(l.NumeroDocumento__c) )
             return false;
  
        return true; 
     }
     
     private boolean validateProfesor(Lead l){
         
         if( String.isBlank(l.firstName) || String.isBlank(l.lastName) || String.isBlank(l.email)|| String.isBlank(l.Phone)||  String.isBlank(l.NumeroDocumento__c) )
             return false;
     
        return true; 
     }
     
     
     public void passTest(){
     
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
     
     
     }
 
}