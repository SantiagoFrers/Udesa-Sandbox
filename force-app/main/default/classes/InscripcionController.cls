public without sharing class InscripcionController {
    
    public boolean success { get; set; }
    public String  msgErrorLoadForm {get;set;}
    public Contact ctc    { get; set; }
    public Postulaciones__c opp    { get; set;}
    public Boolean formDisponible    { get; set; }
    public String value {get;set;}
    
    public Boolean SolicitarDatosParticipante   { get; set; }
    public Boolean SolicitarFormaPagoFormulario    { get; set; }
    public Boolean SolicitarDatosFacturacionFormulario    { get; set; }
    
    
    
    public Boolean requestInvoiceData {get;set;}
    public Boolean requestPaymentData {get;set;}
    
    public Integer totalPages   {get;set;}
    public Integer currentPage {get;set;}
    
    public String creditCardPattern {get;set;}
    public String creditCardCVVPattern {get;set;}
    
    public List<SelectOption> paymentModeAvailables {get;set;}
    public List<SelectOption> paymentsAvailables {get;set;}
    
    
    public Date nac { 
        set{ 
            nac = value;
            ctc.birthdate = nac;
    	}
    	get{
            return ctc.birthdate;
        }
    }
    
    public Boolean isEmpresa { get; set; }
    public Boolean isOtraPersona { get; set; }
    
    
    
    public String aux {get;set;}
    
    public Inscripcion__c inscription {get;set;}
    
    public Date value1 {get;set;}
    
    public InscripcionController(){
        this.msgErrorLoadForm = 'Inscripción no disponible';
        success = false;
        formDisponible = true;
        
        isEmpresa     = false;
        isOtraPersona = false;
        creditCardPattern = 'XXXX XXXX XXXX XXXX';
        creditCardCVVPattern = 'XXX';
        
        
        Id oppId = ApexPages.currentPage().getParameters().get('id');
        String tokenSecurty = ApexPages.currentPage().getParameters().get('t');
        
        
        id ctcId;
        try{
            opp = this.getPostulacionId(oppId);
            
            ctcId = (opp.Contacto__c != null)? opp.Contacto__c : opp.Contacto_de_RRHH__c ;
            
            ctc = [SELECT id, firstName, LastName,Documento__c,Birthdate, Nacionalidad__c,HomePhone, MobilePhone,Correo_electronico_2__c, 
                   Estudios_de_grado__c,Instituci_n_de_grado__c, Estudios_de_posgrado__c,Instituci_n_de_posgrado__c, Otros_estudios__c, Hijos_prospectos_carreras_de_Grado__c,
                   Instituciones__c,   hed__Primary_Organization__c, hed__Primary_Organization__r.Name ,Title,     rea_clasificaci_n_CEE__c,Organizaci_n_comercial_principal_Texto__c , Phone, email, LinkedIn__c,OtherStreet,OtherPostalCode, OtherCity, OtherState,
                   MailingStreet,MailingPostalCode, MailingCity, MailingState
                   FROM Contact where id = : ctcId];
            
            
            if((( opp.Tipo_de_cliente__c == 'Persona' && ctc == null) || opp.Complet_formulario_de_inscripci_n__c || opp.Etapa_Postulaci_n__c  != 'Solicita Inscripción')||
               opp.Tipo_de_cliente__c != 'Persona' && !opp.SolicitarDatosFacturacionFormulario__c
              ){
                  formDisponible = false;
              }else{
                  inscription = createInscription(ctc, opp); 
                  
                  //inscription = createInscription(ctc, opp); 
                  
                  //opp.CondicionesEspecificasFormulario__c ; 
                  this.SolicitarDatosParticipante = opp.Tipo_de_cliente__c == 'Persona';
                  
                  this.SolicitarFormaPagoFormulario =   opp.SolicitarDatosFacturacionFormulario__c;
                  this.SolicitarDatosFacturacionFormulario = opp.SolicitarDatosFacturacionFormulario__c;
                  
                  this.currentPage = 2; 
                  this.totalPages = 2;
                  
                  String payment = opp.FormasDePagoDisponibleFormulario__c ;
                  String coutes  = opp.CuotasDisponiblesTarjeta__c;
                  
                  this.paymentModeAvailables = this.getSelectOptionFromList(
                      this.transformTextToList(
                          payment
                      ));
                  
                  this.paymentsAvailables = this.getSelectOptionFromList(
                      this.transformTextToList(coutes)
                  );
              }
       /* }catch(InscriptionPostulacionHelper.InvalidTokenException ex){
            formDisponible = false;
            msgErrorLoadForm = ex.getMessage();
            system.debug('ex' +  ex.getMessage());*/
        }catch(Exception ex){
            formDisponible = false;
            system.debug('ex' +  ex.getMessage());
            msgErrorLoadForm = 'Ha ocurrido un error al cargar el formulario.';
        //    msgErrorLoadForm = oppId;//ex.getMessage();
        }
        
        //  Solicita Inscripción
    }
    
    
    public PageReference save(){
        
        if( !inscription.OpportunityAceptaCondiciones__c){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Debe aceptar las condiciones'));
            return null;
        }
        
        if(inscription.OpportunityFormaPago__c  != 'Tarjeta'){
            inscription.OpportunityOtraCondicionDePago__c = '';
            
        }else{
            if(inscription.OpportunityFormaPago__c  == ''){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Debe seleccionar una tarjeta'));
                return null;
            }
        }
        
        try{
            insert inscription;
            success = true;
        }catch(DMLException ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, ex.getdmlMessage(0)));
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, ex.getMessage()));
            
        }
        
        
        return null;
    }
    
    private Inscripcion__c createInscription(Contact ctc, Postulaciones__c opp){
        
        Inscripcion__c aux = new Inscripcion__c();
        
        aux.ContactFirstName__c = ctc.FirstName;
        aux.ContactLastName__c = ctc.LastName;
        aux.ContactNumeroDocumento__c = ctc.Documento__c;
        aux.ContactBirthdate__c = ctc.Birthdate;
        aux.ContactNacionalidad__c  = ctc.Nacionalidad__c;
        aux.ContactOtherStreet__c = ctc.OtherStreet;
        aux.ContactOtherPostalCode__c = ctc.OtherPostalCode; 
        aux.ContactOtherCity__c = ctc.OtherCity;
        aux.ContactHomePhome__c = ctc.HomePhone;
        aux.ContactMobilePhone__c = ctc.mobilephone;
        aux.ContactEmail2__c = ctc.Correo_electronico_2__c ;
        aux.ContactHijosProspectosGrado__c = ctc.Hijos_prospectos_carreras_de_Grado__c;
        aux.ContactEstudiosGrado__c = ctc.Estudios_de_grado__c;
        aux.ContactInstitucionGrado__c = ctc.Instituci_n_de_grado__c;
        aux.ContactEstudiosPosgrado__c    = ctc.Estudios_de_posgrado__c ;
        aux.ContactInstitucionPosgrado__c = ctc.Instituci_n_de_posgrado__c;
        aux.ContactOtrosEstudios__c = ctc.Otros_estudios__c;
        aux.ContactInstituciones__c = ctc.Instituciones__c ;
        aux.ContactAccountName__c = ctc.hed__Primary_Organization__r.Name  ;
        aux.ContactTitle__c = ctc.Title ;
        aux.ContactArea__c = ctc.rea_clasificaci_n_CEE__c;
        aux.ContactPhone__c  = ctc.Phone;
        aux.ContactEmail__c  = ctc.email;
        aux.ContactLinkedIn__c  = ctc.LinkedIn__c ;
        aux.ContactMailingStreet__c = ctc.MailingStreet  ;
        aux.ContactMailingPostalCode__c = ctc.MailingPostalCode;
        aux.ContactMailingCity__c = ctc.MailingCity;
        aux.OpportunityFormaPago__c = opp.Forma_de_pago__c ;
        aux.OpportunityOtraCondicionDePago__c = opp.Otra_condici_n__c;
        aux.OpportunityAceptaCondiciones__c = opp.Acept_condiciones_de_inscripci_n__c ;
        aux.Postulacion__c= opp.id;
        aux.Contact__c = ctc.id;
        aux.Cuotas__c  = '1'; 
        
        return aux;    
    }
    
    public Pagereference setPaymentData(){
        
        String newPaymentData = Apexpages.currentPage().getParameters().get('paymentData');
        
        inscription.OpportunityDatosFacturacion__c = newPaymentData;
        return null;
    }
    
    public Pagereference setInvoiceContact(){
        
        String contactInvoiceOpt = Apexpages.currentPage().getParameters().get('invoiceContact');
        
        inscription.ContactoFactura__c = contactInvoiceOpt;
        return null;
    }
    
    public Pagereference setPaymentContact(){
        
        String contactPaymentOpt = Apexpages.currentPage().getParameters().get('paymentContact');
        
        inscription.ContactoPago__c = contactPaymentOpt;
        return null;
    }
    
    public Pagereference setPaymentType(){
        
        String newPaymentType = Apexpages.currentPage().getParameters().get('paymenType');
        
        inscription.OpportunityFormaPago__c = newPaymentType;
        
        return null;
    }
    public Pagereference setCreditCardEntity(){
        
        String newEntity = Apexpages.currentPage().getParameters().get('creditEntity');
        
        if (newEntity == 'American Express' ){
            creditCardPattern = 'XXXX XXXXXX XXXXX';
            creditCardCVVPattern = 'XXXX';
        } else {
            creditCardPattern = 'XXXX XXXX XXXX XXXX';
            creditCardCVVPattern = 'XXX';
        }
        
        
        return null;
    }
    
    
    public Pagereference nextPage(){
        
        currentPage += 1;
        return null;   
    }
    
    public Pagereference backPage(){
        
        currentPage -= 1;
        return null;   
    }
    
    private List<SelectOption> getSelectOptionFromList(List<String> values){
        
        List<SelectOption>  newSelectOption = new List<SelectOption>();
        
        for (String value : values) {
            
            newSelectOption.add(
                new SelectOption(
                    value,
                    value
                )
            );
        }
        return newSelectOption;
    }
    
    private List<String> transformTextToList(String textToList){
        
        return textToList != null ? 
            textToList.split(';')  :
        new List<String>();
    }
    
    private  Postulaciones__c getPostulacionId(String Id) {
        
        return [SELECT  Id, CodigoVerificacion__c,
                Contacto__c, Contacto_de_RRHH__c  , Etapa_Postulaci_n__c  , Complet_formulario_de_inscripci_n__c, Formulario_de_inscripci_n_Fecha__c,
                Otra_condici_n__c, Forma_de_pago__c, Acept_condiciones_de_inscripci_n__c, SolicitarDatosFacturacionFormulario__c , CuotasDisponiblesTarjeta__c  ,FormasDePagoDisponibleFormulario__c,
                Cuenta__c, Tipo_de_cliente__c
                FROM Postulaciones__c
                WHERE Id =:id]; 
    }
    
    
}