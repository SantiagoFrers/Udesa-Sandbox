@isTest(SeeAllData=true)
public class InscriptionControllerTest {

    public static testmethod void testInscription(){

        Account acc = new Account();
        acc.Name = 'test';
        acc.RecordTypeId = '01212000000oG2KAAU';
        
        insert acc;
        
        Contact ct = new Contact();
        ct.firstName = 'test';
        ct.LastName = 'test';
        ct.hed__Primary_Organization__c = acc.id;
        ct.Email = 'test@ae.com';
        
        
        insert ct;
        
    Postulaciones__c opp = new Postulaciones__c();
    opp.Contacto__c = ct.id;
        opp.Contacto_de_RRHH__c  = ct.id;
        opp.Etapa_Postulaci_n__c= 'Solicita Inscripción';
        opp.Importe_en_moneda_extranjera__c = 100;
        opp.Importe_valor_a_facturar__c = 10;
        opp.Importe_valor_a_facturar__c = 10;
        opp.Moneda_extranjera__c = 'EURO';
        opp.Reunion_informativa__c = 'No aplica';
        opp.Entrevista__c = 'No aplica';
        opp.Tipo_de_cliente__c = 'Persona';
          opp.FormasDePagoDisponibleFormulario__c = 'Cheque';
		opp.CuotasDisponiblesTarjeta__c = '1';
        
        insert opp;
            
        Apexpages.currentPage().getParameters().put('paymentData', 'Tarjeta');
        Apexpages.currentPage().getParameters().put('invoiceContact', 'OtraPersona');
        Apexpages.currentPage().getParameters().put('creditEntity', 'American Express');
        
        

        
        ApexPages.currentPage().getParameters().put('id', opp.id);
        
        InscripcionController controller = new InscripcionController();
        controller.inscription.OpportunityAceptaCondiciones__c = false;
        controller.inscription.ContactoPagoEmail__c = 'testcontct@test.com';
        controller.inscription.ContactoPagoNombre__c = 'test';
        controller.inscription.ContactoPagoNombre__c = 'test';
        
        controller.inscription.ContactoPagoApellido__c = 'test';
        
        
        controller.inscription.ContactoPagoTelefono__c = '23213123';

        controller.setPaymentData();
        controller.setInvoiceContact();
        controller.setPaymentContact();
        controller.setPaymentType();
        controller.setCreditCardEntity();
        controller.nextPage();
        
        controller.save();
        
        controller.inscription.OpportunityAceptaCondiciones__c = true;
        controller.save();
    }
   
}