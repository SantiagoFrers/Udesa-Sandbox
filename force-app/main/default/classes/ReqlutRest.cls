@RestResource(urlMapping = '/Reqlut/*')
  global with sharing class ReqlutRest {

      global class StudentInfo{
          String identification{get;set;}
          String email{get;set;}
          String name{get;set;}
          String lastname{get;set;}
          String phone{get;set;}
          String cellphone{get;set;}
          Map<String, Map<String, String>> careers {get;set;}         
		}

    @HttpGet
      global static StudentInfo getStudent(){
      RestRequest request=RestContext.Request;
        String studentId= request.requestURI.substring(request.RequestURI.lastIndexOf('/')+1);         
        try {
                  StudentInfo stdInfo = new StudentInfo();
        
            	  list<hed__Program_Enrollment__c> student_careers = [SELECT hed__Account__r.Id_Reqlut__c, hed__Account__r.unidad_de_negocios__C, hed__Enrollment_Status__c,
                                                                             hed__Start_Date__c, hed__Admission_Date__c, hed__End_Date__c, Postulacion__r.Sede__c
                                                                    	FROM hed__Program_Enrollment__c
                                                                        	where hed__Contact__r.Documento__c = :studentId
                                                                    		and hed__Enrollment_Status__c != 'Baja'
                                                                      		and hed__Account__r.unidad_de_negocios__C in ('Grado', 'Posgrados académicos', 'Posgrados de negocios')
                                                                   			];
    		// Si tiene solo carreras de baja no devuelve nada
            	if (student_careers.size() == 0) {
                       return null
                           ;}
           		else {
                    
                  Contact datos_student = [SELECT Documento__c, Email, FirstName, LastName, Phone, MobilePhone
                                             FROM Contact
                                             	where Documento__c  = :studentId
                                           		and sigedu_n_id_persona__c != null
                                        		];
                    
                  stdInfo.identification =  datos_student.Documento__c;
                  stdInfo.email =  datos_student.Email;
                  stdInfo.name =  datos_student.FirstName;
                  stdInfo.lastname =  datos_student.LastName;
                  stdInfo.phone =  datos_student.Phone;
                  stdInfo.cellphone =  datos_student.MobilePhone;

				Map<String, Map<String, String>> add_list_father = new Map<String, Map<String, String>>();
                for (Integer i = 0; i < student_careers.size() ; i ++){
                        Map<String, String> add_list_child = new Map<String, String>{};
                //Defino los campos
                        String type = student_careers[i].hed__Account__r.unidad_de_negocios__C;
                    	String id = student_careers[i].hed__Account__r.Id_Reqlut__c;    
                    	String state = student_careers[i].hed__Enrollment_Status__c;
                    	
                    	Datetime initialYear = Date.Valueof(student_careers[i].hed__Start_Date__c);  
                    	Datetime AdmissionYear = Date.Valueof(student_careers[i].hed__Admission_Date__c);  
                    	String initialYearString;
                    	if (initialYear != null){
                            initialYearString = initialYear.format('yyyy');
                        } else if (initialYear == null && AdmissionYear != null){
                            initialYearString = AdmissionYear.format('yyyy');}
                    
                    	Datetime endYear = Date.Valueof(student_careers[i].hed__End_Date__c);  
                    	String endYearString;
                    	if  (endYear != null){
                        	endYearString = endYear.format('yyyy');}
                    
                        String centreId = student_careers[i].Postulacion__r.Sede__c;
                        String programName = null; // VA NULL VALIDADO CON CECI
                        String facultyId = null; // VA NULL VALIDADO CON CECI
                    	String iterador = String.valueOf(i + 1);
                
            	// Decode de Type --  "type Reqlut" => <1: Pregrado, 10:Posgrado>,
                    If (type == null || type == ''){
                        type = null;
                    } else if (type == 'Grado'){
                        type = '1';
                    } else if (type == 'Posgrados académicos'){
                        type = '10';
                    } else if (type == 'Posgrados de negocios'){
                        type = '10';
                    }  else {type = null ;}
             
            	// Decode de State -- "state Reqlut" => <0:Estudiante, 1:Titulado, 2:Egresado>,
                    If (state == null || state == ''){
                        state = null;
                    } else If (state == 'Alumno'){
                        state = '0';
                    } else if (state == 'Graduado'){
                        state = '2';
                    }  else {state = null ;}
                  
                // Decode de centreId -- "state Reqlut" => <177:CAMPUS, 178:CABA, 179:ONLINE>,
                    If (centreId == null || centreId == ''){ 
                        centreId = null;
                    } else if (centreId.toLowerCase().contains('campus')){
                        centreId = '177';
                    } else if (centreId.toLowerCase().contains('c.a.b.a.')){
                        centreId = '178';
                    } else if (centreId.toLowerCase().contains('line')){
                        centreId = '179';
                    }  else {centreId = null ;}
                
                //Agrego los campos a la lista
                        add_list_child.put('type', type);
                        add_list_child.put('id', id);
                        add_list_child.put('state', state);
                        add_list_child.put('initialYear', initialYearString);
                        add_list_child.put('endYear', endYearString);
                        add_list_child.put('centreId', centreId);
                        add_list_child.put('programName', programName);
                        add_list_child.put('facultyId', facultyId);
  
                //Agrego a la lista padre la lista hijo
                        add_list_father.put(iterador, add_list_child);
                }
            	//Agrego la lista padre a la lista que se envia
            			stdInfo.careers =  add_list_father;
                    
            	
            	return stdInfo;}
                    
                
        }
              catch (exception e) {
                 return null;
              }
  }
}