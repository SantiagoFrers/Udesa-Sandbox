public with sharing class InscripcionLeadController {

    public Lead lead {get;set;}
    public String entro {get;set;}
    public String optUno {get;set;}
    public String optDos {get;set;}
    public String optTres {get;set;} 
    public List<SelectOption> carrerasDeInteres {get;set;}
    public Boolean success{get;set;}
    public String successMsg{get;set;}
     
    public map<String, List<Localidad__c>> mapLocalidades {get;set;}
    
    public InscripcionLeadController(){
        
        lead = new Lead(leadSource = 'Web',AutomaticConversionToContact__c = true);

        carrerasDeInteres = CommonMethods.getCarrerasDeInteres();  
        mapLocalidades = CommonMethods.getLocalidadesPorPais();
                success = false;
    }
    
    public PageReference save(){
    
        lead.Carrera_elegida__c = getCarreras();
        try{
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
    
    
    private String getCarreras(){

        List<String> carrers = new list<String>();
        
        if(optUno != null)  carrers.add(optUno);
        if(optDos != null)  carrers.add(optDos);
        if(optTres != null) carrers.add(optTres);
         
        String aux = '';
        
        for(String c:carrers){      
            aux += c + ';';
        }
        
        return aux;
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
     
     
 
}