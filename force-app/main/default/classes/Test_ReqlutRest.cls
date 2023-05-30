@IsTest
public class Test_ReqlutRest {

@testSetup static void setup() {

//Se insertan los datos para la prueba
//Contacto
Contact testContact = new Contact();
            testContact.FirstName = 'testContactName';
            testContact.LastName = 'testContactLastName';
            testContact.Documento__c = '31456';
            testContact.Email = 'testContact@test.edu.ar';
            testContact.MobilePhone = '+5491158701256';
    		testContact.sigedu_n_id_persona__c = '929999';
        insert testContact;

//Cuenta
Account testAccts = new Account();
    		testAccts.Type = '';
            testAccts.name = 'testContactName';
            testAccts.Id_Reqlut__c = '1939';
            testAccts.unidad_de_negocios__C = 'Grado';
        insert testAccts;

//Programas asociados
hed__Program_Enrollment__c testProg_enro = new hed__Program_Enrollment__c();
            testProg_enro.hed__Enrollment_Status__c = 'Graduado';
            testProg_enro.hed__Account__c = testAccts.id;
            testProg_enro.hed__Contact__c = testContact.id;
            //testProg_enro.hed__Start_Date__c = system.today() ;
            testProg_enro.hed__End_Date__c = system.today();
    		testProg_enro.hed__Admission_Date__c = system.today();
        insert testProg_enro;
    }
    
    @IsTest
    static void testGetStudentNull() {
Test.startTest();
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;
        request.httpMethod = 'GET';
        request.requestURI = '/Reqlut/38536334'; // Se envia un numero inexistente
        ReqlutRest.StudentInfo result = ReqlutRest.getStudent();        
        ReqlutRest.StudentInfo datos_student = new ReqlutRest.StudentInfo();
        System.assertEquals(null, result);
Test.stopTest();
    }

@IsTest
    static void testGetStudentNotNull() {
        Test.startTest();
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;
        request.httpMethod = 'GET';
        request.requestURI = '/Reqlut/31456'; // Se envia el numero de prueba cargado

        ReqlutRest.StudentInfo result = ReqlutRest.getStudent();
        String jsonString = JSON.serialize(result);
        Map<String, Object> jsonData = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
        String cellphone = (String) jsonData.get('cellphone');
        system.debug(cellphone);
              
 	       
		//ReqlutRest.StudentInfo datos_student = new ReqlutRest.StudentInfo(); 
        
        System.assertEquals('+5491158701256', cellphone);
Test.stopTest();
                
    }
    
}