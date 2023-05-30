public with sharing class ActividadesPosibleController {

    public Contact cnt {get;set;}
    public String optUno {get;set;}
    public String optDos {get;set;}
    public String optTres {get;set;} 
    public List<SelectOption> carrerasDeInteres {get;set;}
    public boolean success{get;set;}

    public map<String, List<Localidad__c>> mapLocalidades {get;set;}
    
    public Case consulta {get;set;}
    public String case_type {get;set;}
    public String case_Reason {get;set;}
    public String case_subject {get;set;}
    public String carrera{get;set;}
    public Boolean sobrescribir {get;set;}
    
    public List<Actividad__c> listAct {get;set;}
    public List<ActivityOption> opts {get;set;}
    
    public map<String,List<ActivityOption>> mapOpts {get;set;}
    String categoria;
    
    public ActividadesPosibleController(){
        cnt = new Contact();
      //consulta = new Case(Origin= 'Web', Type = 'Contactos', Reason='Consulta', Subject='Consulta Web');
        consulta = new Case(Origin= 'Web',Priority='Baja');
        
        categoria = ApexPages.currentPage().getParameters().get('cat'); 
        String view = ApexPages.currentPage().getParameters().get('view'); 
        
        id recordTypeId = getActivityRecordTypeId('Posible');
        
        String query = 'SELECT id, Titulo__c , Name__c, Active__c, Career__c, Category__c FROM Actividad__c WHERE recordTypeId =:recordTypeId AND Active__c = true ';
        
        if(categoria != null)
            query += ' AND  Category__c = :categoria ';
            
        try{          
            listAct = database.query(query);
        }catch(Exception ex){
        } 
        
        opts = new List<ActivityOption>();
        mapOpts = new map<String,List<ActivityOption>>();
        
        if(listAct != null){
            
            for(Actividad__c a:listAct){     
                string cat = (view == '1')?a.Career__c:'Actividades';
                List<ActivityOption> optsAux = mapOpts.get(cat);
                if(optsAux == null)
                    optsAux = new List<ActivityOption>();
                
                optsAux.add(new ActivityOption(a));
                
                mapOpts.put(cat, optsAux);
            }
        }
        
        carrerasDeInteres = CommonMethods.getCarrerasDeInteres();  
        mapLocalidades = CommonMethods.getLocalidadesPorPais();
        success = false;
        sobrescribir = true;
    }
    
    public PageReference save(){
      
        if(!validateActivities()){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Seleccione al menos una actividad'));
             return null;  
        }
        
        Contact oldContact = CommonMethods.getOldContact(cnt.Email);
        Id cntId;
        if(oldContact != null){
            oldContact = updateContactFields(oldContact );
            
            try{
                update oldContact ;
                cntId = oldContact.id; 
            }catch(DMLException ex){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getDMLMessage(0)));
                return null;  
            }
        }else{
            
            cnt.Cargado_por__c = 'WEB';
            cnt.Materias_por_Carrera__c =  getCarreras('');    
            String recordTypeName = (categoria == 'Docentes')?'AG - General': 'AG - Posibles';
            cnt.RecordTypeId = CommonMethods.getContactRecordTypeId(recordTypeName );
            Account acc = CommonMethods.getAccount('NO INFORMA');
            if(acc != null)
                cnt.AccountId = acc.id;
            try{
                insert cnt;  
                cntId = cnt.id;
            }catch(DMLException ex){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getDMLMessage(0)));
                return null;  
            }    
        }
        
        
        List<Wish__c> listWish = new List<Wish__c>(); 
        List<Wish__c> listOldWish = [SELECT id, Contact__c , Activity__c FROM Wish__c WHERE Contact__c = :cntId];
        map<id,Wish__c> mapOldWish = new map<id,Wish__c>();
        for(Wish__c w:listOldWish)
            mapOldWish.put(w.Activity__c ,w);    
                    
        for(String k:mapOpts.keySet()){    
            for(ActivityOption act:mapOpts.get(k)){
                if(act.wish && mapOldWish.get(act.act.id) == null ){
                    listWish.add(new Wish__c (Contact__c = cntId , Activity__c = act.act.id));                    
                }
            }
        }
        
        consulta.ContactId = cntId;
        consulta.Type = case_type ;
        consulta.Reason = case_Reason ;
        consulta.Subject= case_subject ;
       
        if(consulta.description != null && consulta.description != '' )
            consulta.description = Label.ActivityPossibleCaseDescription;
        
        Savepoint sp = Database.setSavepoint();
      
        try{
            insert consulta;          
           
            for(Wish__c w:listWish)
                w.Case__c = consulta.id;
      
            insert listWish;   
        }catch(DMLException ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getDMLMessage(0)));
            Database.rollback(sp);
            return null;  
        }

        success = true;
        return null;
    }
    
    
    private Contact updateContactFields(Contact oldContact){
        if(sobrescribir){
            for (Schema.SObjectField fdesc: Schema.getGlobalDescribe().get('Contact').getDescribe().fields.getMap().values()) {
               Schema.DescribeFieldResult  f = fdesc.getDescribe();
               if(f.isUpdateable()){
                   String fielName = f.getName();
                   if(cnt.get(fielName ) != null) oldContact.put(fielName ,cnt.get(fielName));   
               }
            }
        }
        
        oldContact.Materias_por_Carrera__c =  getCarreras(oldContact.Materias_por_Carrera__c);
         
        return oldContact;
    }
    
    
    private String getCarreras(String oldCarrers){

        List<String> carrers = new list<String>();
        
        if(oldCarrers != null){
            
            carrers.addAll(oldCarrers.split(';'));
        }
        
        if(optUno != null && !containsCarrer(carrers, optUno))  carrers.add(optUno);
        if(optDos != null && !containsCarrer(carrers, optDos))  carrers.add(optDos);
        if(optTres != null && !containsCarrer(carrers, optTres)) carrers.add(optTres);
        if(carrera != null && !containsCarrer(carrers, carrera)) carrers.add(carrera);
         
        String aux = '';
        
        for(String c:carrers){      
            aux += c + ';';
        }
        
        return aux;
    }
    
    private Boolean containsCarrer(List<String> listCarrer, String carrer){
        
        for(String c:listCarrer){
            if(c.equals(carrer))
                return true;
        }
        
        return false;
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
       //Metodo para buscar el id del recordType
      public static Id getActivityRecordTypeId(String name){
          
          Id devRecordTypeId;
          
          try{
              devRecordTypeId = Schema.SObjectType.Actividad__c.getRecordTypeInfosByName().get(name).getRecordTypeId();
          }catch(Exception ex){}
          
          return devRecordTypeId;
      }   
   
      public Class ActivityOption{
          
          public Actividad__c act {get;set;}
          public boolean wish {get;set;}
          
          public ActivityOption(Actividad__c act){
              this.act = act;
              this.wish = false;
          }
      
      }        
      
      private Boolean validateActivities(){

         for(String k:mapOpts.keySet()){    
            for(ActivityOption act:mapOpts.get(k)){
                if(act.wish ){ 
                    return true;                 
                }
            }
         }
         return false;   
      }
}