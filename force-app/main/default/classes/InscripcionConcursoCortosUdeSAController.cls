public with sharing class InscripcionConcursoCortosUdeSAController {
    
    public Lead representante {get;set;}
    public Lead integrante1 {get;set;}
    public Lead integrante2 {get;set;}
    public Lead integrante3 {get;set;}
    public Lead integrante4 {get;set;}
    public Lead mentor {get;set;}
    public String team {get;set;}
    public String comoSeEntero {get;set;}
    public String idCampaign {get;set;}

    public boolean success{get;set;}
     
    public InscripcionConcursoCortosUdeSAController(){
        representante = new Lead();
        integrante1 = new Lead();
        integrante2 = new Lead();
        integrante3 = new Lead();
        integrante4 = new Lead();
        mentor = new Lead();
        
        success = false;
    }
    
    
    public PageReference save(){
        if(!validateOptionalMembers())
            return null;    
    
        List<String> emails = getEmails();
        List<Lead> leadToInsert = new List<Lead>();
        List<Lead> leads = new List<Lead>();
        
        map<String, Contact> mapEmail =  getOldContactMap(emails);
        
       
        
        if(!validateDuplicateEmails(emails))
            return null;
        
        if(!validateOldMembers(emails))
            return null;
            
        List<CampaignMember> members = new List<CampaignMember>();

        try{
            if(representante.email != ''&& representante.email != null){
                members.add( getMember('Representante',idCampaign,team,representante,mapEmail));
            }
            if(integrante1.email != '' && integrante1.email != null){
                members.add( getMember('Integrante',idCampaign,team,integrante1,mapEmail));
            }
            
            if(integrante2.email != '' && integrante2.email != null){
                members.add( getMember('Integrante',idCampaign,team,integrante2,mapEmail));
            }
            
           
            if(validateMember(integrante3)){
               if(!validateFields(integrante3, 'Integrante 4'))
                    return null;
               members.add( getMember('Integrante',idCampaign,team,integrante3,mapEmail));
            }
            
            if(validateMember(integrante4)){
                if(!validateFields(integrante4, 'Integrante 5'))
                    return null;
                    
                members.add( getMember('Integrante',idCampaign,team,integrante4,mapEmail));
                
            }
            
            if(validateMember(mentor)){
                if(!validateFields(mentor,'Mentor'))
                    return null;
                members.add( getMember('Mentor',idCampaign,team,mentor,mapEmail));
            }
            
        }catch(DmlException ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMEssage()));   
            return null;
        }
        insert members;
        success = true;
        
        return null;
    }
    
    private CampaignMember getMember(String typeMember, String idCampaign,String team,Lead leadAux, map<String, Contact> mapEmail){
       
        CampaignMember member = new CampaignMember();
       
        member.CampaignId = idCampaign;
        member.NombreDelProyecto__c = team;
        member.ComoSeEntero__c = comoSeEntero;
        member.Integrante__c  = typeMember;
        
        Contact caux = mapEmail.get(leadAux.email);
        
        if(caux != null){
            member.ContactId = caux.id;
        }else{
            leadAux.company = leadAux.Nombre_de_cuenta_web__c;
            try{
                insert leadAux;
            }catch(DmlException ex){
                throw ex;
            }
            member.LeadId = leadAux.id;
        }
        
        return member;
    }
    
    private  List<String> getEmails(){
        
        List<String> emails = new List<String>();

        if(representante.email != '' && representante.email != null){
            emails.add(representante.email);        
        }
        if(integrante1.email != '' && integrante1.email != null){
            emails.add(integrante1.email);
        }
        if(integrante2.email != '' && integrante2.email != null){
            emails.add(integrante2.email);
        }
        if(integrante3.email != '' && integrante3.email != null){
            emails.add(integrante3.email);
        }
        if(integrante4.email != '' && integrante4.email != null){
            emails.add(integrante4.email);
        }
        if(mentor.email != '' && mentor.email != null){
            emails.add(mentor.email);
        }
        
        return emails;     
    }
    
    
    private map<String, Contact> getOldContactMap( List<String> emails){
         
        List<Contact> contacts = [SELECT id, email from Contact where email in :emails];
        
        map<String, Contact> mapEmail = new map<String, Contact>();
        
        for(Contact c:contacts)
            mapEmail.put(c.email, c);
               
        return mapEmail;
    }
    
    private List<String> getOldMembersEmail( List<String> emails){
        List<CampaignMember> oldMembers = [SELECT id, email FROM CampaignMember where email in: emails and campaignId =:idCampaign  ];
        
        List<String> oldMembersEmail = new List<String>();
        
        for(CampaignMember cm:oldMembers){
            oldMembersEmail.add(cm.Email);
        }
        
        return oldMembersEmail;
    }
    
    private Boolean validateOldMembers(List<String> emails){
        
        List<String> oldMembersEmail = getOldMembersEmail(emails);
        
        if(oldMembersEmail.size() > 0 ){
            
            String msj = '';
            
            if(oldMembersEmail.size() > 1){
                msj = 'Los contactos ';
                for(String e:oldMembersEmail ){
                    msj += e + ' '; 
                }
                msj += 'ya estan inscriptos en el concurso.';
            }else{
                msj = 'El contacto '+ oldMembersEmail.get(0) + ' ya está inscripto en el concurso';              
            }
                         
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,msj));  
            
            return false;
        }   
        
        return true;
    }
    
    private Boolean validateDuplicateEmails(List<String> emails){
        
        map<String,String> mapEmails = new map<String,String>();
        Boolean valid = true;
        for(String e:emails){
            String aux = mapEmails.get(e);  
            if(aux == null ){
                mapEmails.put(e,e);
            }else{
                valid = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Correo electrónico duplicado'));   
            }
        }
        
        return valid;
    }
    
    private Boolean validateMember(Lead l){
            
        if(!String.isBlank(l.FirstName) || !String.isBlank(l.lastName) ||  !String.isBlank(l.email) || !String.isBlank(l.Nombre_de_cuenta_web__c)){
            return true;
        }
        
        return false;
    }
    
    private Boolean validateFields(Lead l, String name){
        
        if(String.isBlank(l.FirstName) || String.isBlank(l.lastName) ||  String.isBlank(l.email) || String.isBlank(l.Nombre_de_cuenta_web__c)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Faltan completar datos del ' + name)); 
            
            return false;
        }
        
        return true;
    }
    
    private Boolean validateOptionalMembers(){
        
       
        if(validateMember(integrante3)){
           if(!validateFields(integrante3, 'Integrante 4'))
                return false;
        }
        
        if(validateMember(integrante4)){
            if(!validateFields(integrante4, 'Integrante 5'))
                return false;              
        }
        
        if(validateMember(mentor)){
            if(!validateFields(mentor,'Mentor'))
                return false;
        }
     
        return true;  
    }
    
    
}