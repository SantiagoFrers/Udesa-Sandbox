public without sharing  class InscriptionTriggerClass {

    
    public static void updateRecords(List<Inscripcion__c> inscriptions) {
        
        List<Facturacion__c> invoices = new List<Facturacion__c>();
        set<id> ctcIds = new set<id>();
        set<id> oppIds = new set<id>();
        Set<String> emailsToSearh = new Set<String>();
        Map<String,Contact> contactByEmail = new Map<String,Contact>();

 
        for(Inscripcion__c i:inscriptions){
            ctcIds.add(i.Contact__c);
            oppIds.add(i.Postulacion__c); 

            if (i.ContactoFactura__c != 'Persona' && i.ContactoFacturacionEmail__c != null) {
                emailsToSearh.add(i.ContactoFacturacionEmail__c);
            }   
            if (i.ContactoFactura__c != 'Persona' &&  i.ContactoPagoEmail__c != null) {
                emailsToSearh.add(i.ContactoPagoEmail__c);
            }   
        }

        map<id,Contact> contacts = new map<id,Contact>([SELECT id, firstName, LastName,Documento__c,Birthdate, Nacionalidad__c,HomePhone, MobilePhone,Correo_electronico_2__c, 
                    Estudios_de_grado__c,Instituci_n_de_grado__c, Estudios_de_posgrado__c,Instituci_n_de_posgrado__c, Otros_estudios__c, Hijos_prospectos_carreras_de_Grado__c,
                    Instituciones__c,   hed__Primary_Organization__c, hed__Primary_Organization__r.Name ,Title,     rea_clasificaci_n_CEE__c,Organizaci_n_comercial_principal_Texto__c , Phone, email, LinkedIn__c,OtherStreet,OtherPostalCode, OtherCity, OtherState,
                    MailingStreet,MailingPostalCode, MailingCity, MailingState
                     FROM Contact where id in : ctcIds OR email in :emailsToSearh OR Correo_electronico_2__c in :emailsToSearh ]);
                    

        for (Contact ctc : contacts.values()) {
            contactByEmail.put(ctc.Email, ctc);
            contactByEmail.put(ctc.Correo_electronico_2__c, ctc);
        }
        
        List<Contact> newContacts = new List<Contact>();

        for(Inscripcion__c i:inscriptions){

            if (i.ContactoFactura__c != 'Persona' && i.ContactoFacturacionEmail__c != null) {
              
                if (!contactByEmail.containsKey(i.ContactoFacturacionEmail__c)) {
                   
                    Contact newContact = InscriptionTriggerClass.createContact(i.ContactoFacturacionEmail__c, i.ContactoFacturacionNombre__c,i.ContactoFacturacionApellido__c,i.ContactoFacturacionTelefono__c);
                    newContacts.add(newContact);
                    contactByEmail.put(i.ContactoFacturacionEmail__c, newContact );
                    
                }
            }   
            if (i.ContactoPago__c != 'Persona' &&  i.ContactoPagoEmail__c != null) {
                if (!contactByEmail.containsKey(i.ContactoPagoEmail__c)) {
                
                    Contact newContact = InscriptionTriggerClass.createContact(i.ContactoPagoEmail__c, i.ContactoPagoNombre__c,i.ContactoPagoApellido__c,i.ContactoPagoTelefono__c);
                    newContacts.add(newContact);
                    contactByEmail.put(i.ContactoPagoEmail__c, newContact  );
                }
            }   
        }
		
        try{
        	insert newContacts;
        }catch(Exception ex){
        	system.debug(ex);
        }

        map<id,Postulaciones__c> opps = new map<id,Postulaciones__c>([SELECT id, Contacto__c, Contacto_de_RRHH__c  , Etapa_Postulaci_n__c   , Complet_formulario_de_inscripci_n__c, Formulario_de_inscripci_n_Fecha__c,
                    Otra_condici_n__c, Forma_de_pago__c, Acept_condiciones_de_inscripci_n__c, Tipo_de_cliente__c
                    FROM Postulaciones__c WHERE id in : oppIds]);
                    

        for(Inscripcion__c i:inscriptions){
            
            if ( opps.get(i.Postulacion__c).Tipo_de_cliente__c == 'Persona' ) {           
            	contacts.put(i.Contact__c, getUpdatedContact(contacts.get(i.Contact__c), i));
            }
            
            Postulaciones__c updatedPostulacion = getUpdatedPostulaciones(opps.get(i.Postulacion__c), i);
          
            opps.put(i.Postulacion__c,updatedPostulacion);      
            
            if (!String.isBlank(i.OpportunityDatosFacturacion__c )) {
                
                invoices.add(getInvoice(i,updatedPostulacion ,contactByEmail));
            }
            
        }
        

        
        update contacts.values();
        update opps.values();
        insert invoices;
    }
    
    private static Postulaciones__c getUpdatedPostulaciones(Postulaciones__c opp,Inscripcion__c ins){
        
        opp.Otra_condici_n__c = ins.OpportunityOtraCondicionDePago__c;
        opp.Acept_condiciones_de_inscripci_n__c = ins.OpportunityAceptaCondiciones__c;    
        opp.Complet_formulario_de_inscripci_n__c = true;
        opp.Formulario_de_inscripci_n_Fecha__c = ins.CreatedDate;

        return opp;
    }
    
    private static Facturacion__c getInvoice(Inscripcion__c ins, Postulaciones__c postulacion, Map<String,Contact> contactsByEmail) {

        Facturacion__c invoice = new Facturacion__c();

        invoice.Postulacion__c = postulacion.Id;
        invoice.DatosFacturacion__c = ins.OpportunityDatosFacturacion__c;
        
        switch on ins.OpportunityDatosFacturacion__c {
            when 'Persona' {
                
                invoice.Razn_social__c          = ins.ContactFirstName__c + ' ' + ins.ContactLastName__c;
                invoice.NombreApellidoFacturacion__c    = ins.ContactFirstName__c + ' ' + ins.ContactLastName__c;
                invoice.Tipo_de_documento__c    =  'DNI';
                invoice.DNI_si_y_solo_si_NO_CUITCUIL__c = ins.ContactNumeroDocumento__c  ;
            }
            when 'OtraPersona' {
                invoice.Razn_social__c          = ins.FacturacionOtraPersonaNombre__c + ' ' + ins.FacturacionOtraPersonaApellido__c; 
                invoice.NombreApellidoFacturacion__c  = ins.FacturacionOtraPersonaNombre__c + ' ' + ins.FacturacionOtraPersonaApellido__c; 
                invoice.Tipo_de_documento__c    = 'DNI';
                invoice.DNI_si_y_solo_si_NO_CUITCUIL__c = ins.FacturacionOtraPersonaDNI__c;
                invoice.DireccionPostal__c  = ins.FacturacionOtraPersonaDireccion__c + ', ' + ins.FacturacionOtraPersonaLocalidad__c + ', ' + ins.FacturacionOtraPersonaCodigoPostal__c;
            }
            when 'Empresa' {
                invoice.Razn_social__c        = ins.FacturacionRazonSocial__c;
                invoice.Tipo_de_documento__c  = 'CUIT';
                invoice.CUITCUIL__c           = ins.FacturacionCUIT__c;
                invoice.SolicitaOC__c         = ins.FacturacionSolicitaOC__c;
            }
        }
	
        invoice.Condicin_de_pago__c  = 'Otras';
        invoice.Forma_de_pago__c = ins.OpportunityFormaPago__c;
        
        invoice.PagoEntidadTarjeta__c = ins.FacturacionEntidadTarjeta__c;
        invoice.PagoNTarjeta__c = ins.FacturacionNTarjeta__c;
        invoice.PagoVencimientoTarjeta__c = ins.FacturacionVencimientoTarjeta__c;
        invoice.PagoCVVTarjeta__c = ins.FacturacionCVVTarjeta__c;
        invoice.PagoTitularTarjeta__c = ins.FacturacionTitularTarjeta__c;
        invoice.PagoDNITarjeta__c = ins.FacturacionDNITarjeta__c;
        invoice.PagoCBUTitular__c = ins.FacturacionCBUTitular__c;
        invoice.PagoCBU__c = ins.FacturacionCBU__c;
        invoice.PagoCBUDNI__c = ins.FacturacionCBUDNI__c;     
        invoice.TarjetaCuotas__c = ins.Cuotas__c;
        invoice.DatosContactosFacturaPagoText__c = '';
        
        if (ins.ContactoFactura__c == 'Persona') {

            invoice.Contacto_de_facturaci_n__c  = ins.Contact__c;

        } else {
            
            invoice.DatosContactosFacturaPagoText__c += 'Contacto Factura: ';
            invoice.DatosContactosFacturaPagoText__c += '' + getContactDataText(ins.ContactoFacturacionEmail__c, ins.ContactoFacturacionNombre__c,ins.ContactoFacturacionApellido__c,ins.ContactoFacturacionTelefono__c);
            
            if (ins.ContactoFacturacionEmail__c != null) {

                Contact  invoiceCtc = contactsByEmail.get(ins.ContactoFacturacionEmail__c);

                if (invoiceCtc != null) {
                    invoice.Contacto_de_facturaci_n__c  = invoiceCtc.Id;
                }

            }
        }

         
        if (ins.ContactoPago__c == 'Persona') {

            invoice.Contacto_de_pago__c = ins.Contact__c;
        } else {
            
            invoice.DatosContactosFacturaPagoText__c += 'Contacto Pago: ';
            invoice.DatosContactosFacturaPagoText__c += getContactDataText(ins.ContactoPagoEmail__c, ins.ContactoPagoNombre__c,ins.ContactoPagoApellido__c,ins.ContactoPagoTelefono__c);
           

            if (ins.ContactoPagoEmail__c != null) {
                
                Contact  paymentCtc = contactsByEmail.get(ins.ContactoPagoEmail__c);

                if (paymentCtc != null) {
                    invoice.Contacto_de_pago__c  = paymentCtc.Id;
                }
            }
        }
        

        return invoice;
    }

    private static Contact getUpdatedContact(Contact ctc,Inscripcion__c ins){
    
        ctc.FirstName = ins.ContactFirstName__c  ;
        ctc.LastName = ins.ContactLastName__c  ;
        ctc.Documento__c = ins.ContactNumeroDocumento__c  ;
        ctc.Birthdate = ins.ContactBirthdate__c  ;
        ctc.Nacionalidad__c = ins.ContactNacionalidad__c  ;
        ctc.OtherStreet = ins.ContactOtherStreet__c  ;
        ctc.OtherPostalCode = ins.ContactOtherPostalCode__c  ;
        ctc.OtherCity = ins.ContactOtherCity__c  ;
        ctc.HomePhone = ins.ContactHomePhome__c  ;
        ctc.mobilephone = ins.ContactMobilePhone__c  ;
        ctc.Correo_electronico_2__c  = ins.ContactEmail2__c  ;
        ctc.Hijos_prospectos_carreras_de_Grado__c = ins.ContactHijosProspectosGrado__c  ;
        ctc.Estudios_de_grado__c = ins.ContactEstudiosGrado__c  ;
        ctc.Instituci_n_de_grado__c = ins.ContactInstitucionGrado__c  ;
        ctc.Estudios_de_posgrado__c  = ins.ContactEstudiosPosgrado__c  ;
        ctc.Instituci_n_de_posgrado__c = ins.ContactInstitucionPosgrado__c  ;
        ctc.Otros_estudios__c = ins.ContactOtrosEstudios__c  ;
        ctc.Instituciones__c  = ins.ContactInstituciones__c  ;
        ctc.Organizaci_n_comercial_principal_Texto__c  = ins.ContactAccountName__c  ;
        ctc.Title  = ins.ContactTitle__c  ;
        ctc.rea_clasificaci_n_CEE__c = ins.ContactArea__c  ;
        ctc.Phone = ins.ContactPhone__c  ;
        ctc.email = ins.ContactEmail__c  ;
        ctc.LinkedIn__c  = ins.ContactLinkedIn__c  ;
        ctc.MailingStreet  = ins.ContactMailingStreet__c  ;
        ctc.MailingPostalCode = ins.ContactMailingPostalCode__c  ;
        ctc.MailingCity = ins.ContactMailingCity__c  ;
        
        
        return ctc;
    }
    
    public static void deleteInscriptions(List<Inscripcion__c> inscriptions){
        
        set<id> ids = new set<id>();
        
        for(Inscripcion__c i:inscriptions){
          ids.add(i.id);
        }
        
        delete [Select id From Inscripcion__c where id in : ids];
    }
    
      
    private static Contact createContact(String email, String firstName, String lastName, String phone) {

        Contact ctc = new Contact();

        ctc.FirstName = firstName;
        ctc.LastName  = lastName;
        ctc.Email     = email;
        ctc.Phone     = phone;

        return ctc;
    }
    
    private static String getContactDataText(String email, String firstName, String lastName, String phone) {
        
        String ctcData = '{';
        ctcData += ' Email : ' + email  + ', ';
        ctcData += ' Nombre : ' + firstName  + ', ';
        ctcData += ' Apellido : ' + lastName  + ', ';
        ctcData += ' Tel : ' + phone  + ' } ';
	
        return ctcData;
    }
}