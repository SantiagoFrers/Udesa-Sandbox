public without sharing class PreInscripcionBecasController {
    
    public Contact cnt{get; set;}
    public Becas__c beca    {get; set;}
    public Boolean succes {get; set;}
    public string localiadSelected {get; set;}
    public List<SelectOption> carrerasDeInteres {get; set;}
       
    private String carreraDefault;
    
    public PreInscripcionBecasController(){
        succes = false;
        cnt = new Contact();
        
        beca = new Becas__c();
        
        String tipoBeca = ApexPages.currentPage().getParameters().get('tipo'); 
        carreraDefault = ApexPages.currentPage().getParameters().get('carrera'); 
          
       
        
        if(tipoBeca != null){
            beca.Programa__c = tipoBeca;          
        }
       
       
        carrerasDeInteres = CommonMethods.getCarrerasDeInteres();
     }
   

    public PageReference guardar(){
    
        //verificar si existe 
        if(String.isNotEmpty(localiadSelected) )
            cnt.Localidad_cont__c  = localiadSelected ;
        
        
        Contact oldCtc = CommonMethods.getOldContact(cnt.Email);
              
        //Se llena el campo carrera de interez de acuerdo a las carreras seleccionadas por el contacto
        if(String.isNotBlank(carreraDefault)){
            cnt.Materias_por_Carrera__c = carreraDefault;
        }else{
            if(checkboxSelections != null){
                String carrerasDeInteres = '';
                
                for(integer i = 0; i < checkboxSelections.size(); i++)
                    carrerasDeInteres += checkboxSelections[i] + '; ';
                
                cnt.Materias_por_Carrera__c = carrerasDeInteres;
            }
        }
        
             
        if(oldCtc != null){
            cnt.id = oldCtc.id;
            
            try{
                update cnt;
            }catch(Exception ex){
                system.debug(ex.getMessage());
                apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Error,ex.getDmlMessage(0));
                apexpages.addmessage(msg); 
            }
            
        }else{
            try{
                cnt.RecordTypeId =  CommonMethods.getContactRecordTypeId('AG - Posibles');
                cnt.Cargado_por__c = 'Web';
                
                insert cnt;
                
            }catch(Exception ex){
                system.debug(ex.getMessage());
                apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Error,ex.getDmlMessage(0));
                apexpages.addmessage(msg); 
                
            }
            
        }
        if(cnt.id != null){
         
            beca.Contacto__c = cnt.Id;
            beca.Cargado_por__c = 'WEB';
            
            try{
                insert beca;
                succes = true;
            }catch(Exception ex){
                system.debug(ex.getMessage());
                apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Error,ex.getDmlMessage(0));
                apexpages.addmessage(msg); 
                
            }
        }
        
        return null;
   }
   

    String[] checkboxSelections = new String[]{};
    
    
    public String[] getcheckboxSelections() {
        return checkboxSelections;
    }
   
    public void setcheckboxSelections (String[] countries) {
        this.checkboxSelections = countries;
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