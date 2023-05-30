@isTest
public class TestDataFactory {
    
    public static Account createNoInformaAccount(){
        String nameCuentaNoInforma = 'NO INFORMA';
        Account cuentaNoInforma = new Account(name=nameCuentaNoInforma,Cargado_por__c = 'TEST');
        insert cuentaNoInforma; 
        return cuentaNoInforma;
    }
    
    public static Actividad__c createActivity(String cargadoPor, String curso, String fecha){
        Actividad__c actividad1 = new Actividad__c(
        Tipo__c = curso,
        Fecha_de_realizaci_n__c = Date.parse(fecha),
        Cargado_por__c = cargadoPor);
        insert actividad1;
        return actividad1;
    }
    
    
    public static Curso__c createCourse(){
        return createCourse('Test');
    }
    
    public static Curso__c createCourse(String cargadoPor){
        Curso__c curso = new Curso__c(
            Cargado_por__c = cargadoPor,
            Comisi_n__c = 'Test',
            Sede__c = 'Test',
            Tipo__c = 'Test',
            Fecha_de_inicio__c = Date.parse('01/01/2010'), 
            Fecha_de_Fin__c = Date.parse('01/01/2015')
        );
        insert curso;
        return curso;
    }
    
    public static String createTwoCourses(){
        Curso__c curso1 = TestDataFactory.createCourse('1');
        Curso__c curso2 = TestDataFactory.createCourse('1');
        
        String retorno = curso1.Id;
        retorno = retorno + ','+curso2.Id;
        
        return retorno;
    }
    
    public static String createTwoActivities(){
        
        Actividad__c actividad1 = TestDataFactory.createActivity('1','Aprendiendo a Elegir','11/10/2012');
        Actividad__c actividad2 = TestDataFactory.createActivity('1','Aprendiendo a Elegir','12/10/2012');
        
        String retorno = actividad1.Id;
        retorno = retorno + ','+actividad2.Id;
        
        return retorno;
    }
    
    public static Lead createOneLeadForActivity(String email,String activityId){
        String lastName='lastName';
        Lead lead = new Lead(FirstName='Martin',LastName=lastName,Email=email,Company='CompanyDesdeWeb',Description='activityId='+activityId+';campos1=valorCampo1;campo2=valorCampo2',ActividadID__c = activityId, A_o_interesado_ingresar__c= '2014', LeadSource= 'Web',AutomaticConversionToContact__c = true);
        insert lead;
        System.debug('Lead insertada, email: '+lead.Email);
        System.debug('Lead insertada, contacto: '+lead.Contacto__c);
        return lead;
    }
    
     public static Lead createOneLeadForCursos(String email,String courseId){
        String lastName='lastName';
        Lead lead = new Lead(FirstName='Martin',LastName=lastName,Email=email,Company='CompanyDesdeWeb',Description='courseId='+courseId+';campos1=valorCampo1;campo2=valorCampo2', CursoID__c = courseId, LeadSource= 'Web',AutomaticConversionToContact__c= true);
         insert lead;
        return lead;
    }
    
    public static Lead createOneLeadForCase(){
        String lastName='lastName';
        String email = 'test@test.com';
        Lead lead = new Lead(FirstName='Martin',LastName=lastName,Email=email,Company='CompanyDesdeWeb', A_o_interesado_ingresar__c= '2014', LeadSource= 'Web',AutomaticConversionToContact__c = true);
        lead.CaseDescription__c = 'test';
        lead.CaseType__c = 'TEst';
        lead.CaseReason__c = 'TEst';
        lead.CaseSubject__c = 'TEst';
        insert lead;
        System.debug('Lead insertada, email: '+lead.Email);
        return lead;
    }
    
      public static Lead createOneLeadForInfo( String email){
        String lastName='lastName';
        Lead lead = new Lead(FirstName='Martin',LastName=lastName,Email=email,Company='CompanyDesdeWeb',Description='campos1=valorCampo1;campo2=valorCampo2', LeadSource= 'Web',AutomaticConversionToContact__c = true);
        insert lead;
        return lead;
    }
    
    public static Lead createTwoLeadForActivity(String email,String keys){
        String lastName='lastName';
        Lead lead = new Lead(FirstName='Martin',LastName=lastName,Email=email,Company='CompanyDesdeWeb',Description='activityId='+keys+';campos1=valorCampo1;campo2=valorCampo2', LeadSource= 'Web', AutomaticConversionToContact__c = true);
        insert lead;
        return lead;
    }
    
    public static Lead createTwoLeadForCursos(String email,String keys){
        String lastName='lastName';
        Lead lead = new Lead(FirstName='Martin',LastName=lastName,Email=email,Company='CompanyDesdeWeb',Description='courseId='+keys+';campos1=valorCampo1;campo2=valorCampo2', LeadSource= 'Web',AutomaticConversionToContact__c = true);
        insert lead;
        return lead;
    }
    
    public static Lead createLeadForCollege(String email,String keys,String colegio,String carrera){
        String lastName='lastName';
        Lead lead = new Lead(FirstName='Martin',LastName=lastName,Email=email,Company='CompanyDesdeWeb',Description='activityId='+keys+';campos1=valorCampo1;campo2=valorCampo2',Carrera_elegida__c=carrera,Nombre_de_cuenta_web__c=colegio, LeadSource= 'Web',AutomaticConversionToContact__c = true);
        system.debug('********************');
        insert lead;
         system.debug('********************' + lead);
        return lead;
    }
    
    public static Lead createOneCommonLead(String courseId){  
        Lead lead = new Lead(FirstName='asdad',LastName='asdad',Email='asdasd@sadasdasd.com',Phone='32432',Company='Company From WebToLead',description='courseId='+courseId+';campos1=valorCampo1;campo2=valorCampo2',Carrera_elegida__c='asddffgd',Nombre_de_cuenta_web__c='Abogacia', LeadSource= 'Web', AutomaticConversionToContact__c = true);
        insert lead;
        return lead;
    }
    
    public static Lead twoLeadsSameEmail(String email,String carrera, String cuentaWeb,String courseId){  
        Lead lead = new Lead(FirstName='asdad1',LastName='asdad1',Email=email,Phone='32432',Company='Company From WebToLead',description='courseId='+courseId+';campos1=valorCampo1;campo2=valorCampo2', LeadSource= 'Web',AutomaticConversionToContact__c = true);
        insert lead;
        
        Lead lead2 = new Lead(FirstName='asdad2',LastName='asdad2',Email=email,Phone='32432',Company='Company From WebToLead',description='courseId='+courseId+';campos1=valorCampo1;campo2=valorCampo2',Carrera_elegida__c=carrera,Nombre_de_cuenta_web__c=cuentaWeb, LeadSource= 'Web', AutomaticConversionToContact__c = true);
        insert lead2;
        
        return lead2;
    }
 
    
}