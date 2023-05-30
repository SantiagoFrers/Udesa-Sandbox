public with sharing class FormularioBecasController {

    
    public Contact cnt {get;set;}
    public String optUno {get;set;}
    public String optDos {get;set;}
    public String optTres {get;set;} 
    public List<SelectOption> carrerasDeInteres {get;set;}
    public boolean success{get;set;}
    public String formType {get;set;}
    //public Task consulta {get;set;}
    public Becas__c beca    {get; set;}
    public Case consulta {get;set;}
    
    public FormularioBecasController(){
        cnt = new Contact();
        //consulta  = new Task(Subject= 'Consulta Web');
        consulta = new Case(Origin= 'Web', Type = 'Contactos', Reason='Solicitud Beca', Subject='Solicitud Beca Web');
        
        carrerasDeInteres = CommonMethods.getCarrerasDeInteres();  
        success = false;
        
        beca = new Becas__c();
        beca.Cargado_por__c = 'WEB';
    }
    
    public PageReference save(){
        
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
            cnt.Materias_por_Carrera__c = getCarreras();    
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
        
        try{
            beca.Contacto__c = cntId;
            insert beca;
          //  consulta.WhatId = beca.id;  
            consulta.Beca__c = beca.id;      
        }catch(DMLException ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getDMLMessage(0)));
            return null;  
        }    
        
        consulta.ContactId = cntId;       
        if(consulta.description != null && consulta.description != '' ){
            insert consulta;
        }

        success = true;
        return null;
    }
    
    
    private Contact updateContactFields(Contact oldContact){
        
        if(cnt.FirstName != null)  oldContact.FirstName = cnt.FirstName;
        if(cnt.LastName != null)  oldContact.LastName = cnt.LastName ;
        if(cnt.TipoDocumento__c != null)  oldContact.TipoDocumento__c = cnt.TipoDocumento__c;
        if(cnt.Documento__c != null)  oldContact.Documento__c= cnt.Documento__c;
        if(cnt.Localidad__c != null)  oldContact.Localidad__c= cnt.Localidad__c;
        if(cnt.Nombre_de_cuenta_WEB__c != null)  oldContact.Nombre_de_cuenta_WEB__c = cnt.Nombre_de_cuenta_WEB__c;
        if(cnt.A_o_interesado_en_ingresar__c != null)  oldContact.A_o_interesado_en_ingresar__c = cnt.A_o_interesado_en_ingresar__c;
        if(getCarreras() != '') oldContact.Materias_por_Carrera__c =  getCarreras();
         
        return oldContact;
    }
    
    
    private String getCarreras(){
        String aux = '';
        
        aux += (optUno != null)? optUno + ';':'';
        aux += (optDos != null)? optDos + ';':'';
        aux += (optTres != null)? optTres + ';':'';
        
        return aux;
    }
    
    public List<SelectOption> getPcias() {
 
        List<SelectOption> options = new List<SelectOption>();
        
        List<Localidad__c>  listLoc = [SELECT id, name,Provincia__c,Pa_s__c,Zona_local__c FROM Localidad__c order By name  ];
        
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