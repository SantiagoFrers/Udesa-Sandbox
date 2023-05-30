public class CommonMethods{

   public static map<String, List<Localidad__c>> getLocalidadesPorPais(){
   
        List<Localidad__c> localidades;
        map<String, List<Localidad__c>> mapLocalidades;  
        
        try{
            localidades = [SELECT Id, Name, Pa_s__c, Provincia__c, Zona_local__c FROM Localidad__c Order By Pa_s__c desc, Provincia__c asc, Name asc];
        }catch(Exception ex){}
        
        if(localidades != null){
        
             mapLocalidades = new  map<String, List<Localidad__c>> ();
             for(Localidad__c l : localidades){
               
               List<Localidad__c> lista = mapLocalidades.get(l.Pa_s__c);
               
               if(lista == null)
                   lista = new List<Localidad__c>();
                
                lista.add(l);
                mapLocalidades.put(l.Pa_s__c,lista);     
            }
        }
        return mapLocalidades;
   }
   
    //Metodo para convertir el campo multipicklist en opciones de checkbox
    public static List<SelectOption> getCarrerasDeInteres(){
        //Describe SObject field and get the fields map
        Map<String, Schema.SObjectField> mapFields = Schema.getGlobalDescribe().get('Contact').getDescribe().fields.getMap();        
         //Describe field and create a list of select options
        List<SelectOption> listOptions = new List<SelectOption>();
        //Get picklist entries and interate to display these in form of checkboxes
        List<Schema.PicklistEntry> pickListEntries = mapFields.get('Materias_por_Carrera__c').getDescribe().getPicklistValues();     
         //loop throough the picklist entries and populate select list
        for (Schema.PicklistEntry pE : pickListEntries) {      
            //Populate the select list with values
            listOptions.add(new SelectOption(pE.getValue() , pE.getLabel()));  
        }   
        //List of select option
        return listOptions;         
  } 
  
  //Metodo para crar string de la consulta
  public static String crearConsulta(String nombreObjeto, String filtro){

    //Trae todos los campos del objeto
    Map<String, Schema.SObjectField> mapFields = Schema.getGlobalDescribe().get(nombreObjeto).getDescribe().fields.getMap(); 

    String consulta = 'SELECT Id ';

    for (String f:mapFields.keySet()) {
      if(f != 'Id')
        consulta += ' , ' + mapFields.get(f).getDescribe().getName();
    }

    consulta += ' FROM ' + nombreObjeto ;
    
    if(filtro != null)
        consulta +=' ' + filtro;
  
    return consulta;
  }
  
  
   //Metodo para validar si ya esta inscripto en el curso
   public static Boolean validateCurso(Id idContact , id idCurso){
      
      Inscripci_n_al_curso__c inscripcionCursoAux;
      
      try{
          inscripcionCursoAux = [SELECT id FROM Inscripci_n_al_curso__c WHERE Curso__c =: idCurso AND Contacto__c =: idContact];
      }catch(Exception ex){
      }
      
      if(inscripcionCursoAux != null)
          return true;
       
      return false;
   }
   
   //Metodo para validar si ya esta inscripto en la actividad
   public static Boolean validateActividad(Id idContact , id idActivity){
       
       Asistencia_a_Actividades__c asitenciaActividades;
      
      try{
          asitenciaActividades= [SELECT id FROM Asistencia_a_Actividades__c WHERE Actividad__c =: idActivity AND Contacto__c =: idContact];
      }catch(Exception ex){
      }
      
      if(asitenciaActividades!= null)
          return true;
       
      return false;
   } 
   
   //Metodo para validar si exite en contacto
   public Static Contact getOldContact(String email){
      
      Contact contactAux;

      try{
          String query = crearConsulta('Contact', '  WHERE Email =: email ');
          contactAux = database.query(query);
      }catch(Exception ex){}
      
      return contactAux;
  }
  
  //Metodo para buscar el id del recordType
  public static Id getContactRecordTypeId(String name){
      
      Id devRecordTypeId;
      
      try{
          devRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(name).getRecordTypeId();
      }catch(Exception ex){}
      
      return devRecordTypeId;
  }   
   
    public static Account getAccount(String name){
       Account acc;
       
       try{
           acc = [SELECT id FROM Account WHERE Name =: name];
       }catch(Exception ex){
       
       }
        
       return acc;   
   }
   

}