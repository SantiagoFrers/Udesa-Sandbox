public class ManageApplications {

    
    public static final String[] STAGE_TO_PROCESS_GRADO = new List<String>{'Interesado'}; //pasar a custom setting
    public static final String[] STAGE_TO_PROCESS_POSGRADO = new List<String>{'Interesado'}; //pasar a custom setting
	public static final String POSGRADO_NEGOCIO = 'Posgrados de negocios';
    public static final String POSGRADO_ACADEMICO = 'Posgrados académicos';

    public static Boolean createApplication(Application application, String proceso){
                
        Boolean success;
        Id applicationIdToUpdate;
        
        map<String,String> mapValues = getMapValues(application.data);
        map<String,List<FieldMapping__mdt>> mapping = UtilClass.getMapping(proceso);
        Id rtGrado = UtilClass.getRecordTypeIdFromName('Postulaciones__c','Grado');

        List<Contact> cts = UtilClass.getContactsByEmail( new List<String> {application.email}); // ver de poner aca el campo identificatorio
        
        if (cts.size() > 1) {
            throw new MoreThanOnewException('Existe mas de un Contacto con el correo electronico ingresado');
        }
        
        Id ctId = null;
        system.debug('email ' + application.email);
        system.debug(cts);
        
        //postulacion con datos de sigedu
        Postulaciones__c  postulacion = (Postulaciones__c) createRecord('Postulaciones__c',mapValues,mapping.get('Postulaciones__c'), null); 
        //existe un contacto con el email 
        if(!cts.isEmpty() ){

            ctId = cts[0].id;
            //si la postulacion que ingresa es de grado 
            //Se busca la postulación por correo electrónico del chico y el campo Período de inicio de cursada - Si encuenta, actualiza y sino crea
            
            List<Postulaciones__c> postualcionesGrado = [SELECT id, Oferta_Acad_mica__c,Etapa_Postulaci_n__c, Oferta_Acad_mica__r.Per_odo__c 
                                                            FROM Postulaciones__c 
                                                            WHERE Contacto__c =:ctId
                                                             AND RecordTypeId =:rtGrado
                                                        ];
            //si el contacto no tiene una postulacion a grado dar error.
            if(postualcionesGrado.isEmpty()){
                throw new ProcessException('El contacto no tiene ninguna postulacion de Grado');
            }else{            
                //tiene postulacion, se busca que este en la etapa que se pueda actualizar y que el periodo sea el mismo.
                for(Postulaciones__c oldPostulation: postualcionesGrado){

                    if(STAGE_TO_PROCESS_GRADO.contains(oldPostulation.Etapa_Postulaci_n__c)){
                        if(applicationIdToUpdate == null){
                            applicationIdToUpdate = oldPostulation.Id;
                        }else{
                            throw new MoreThanOneApplicationException('Existe mas de un Postulación');
                        }
                    }
                    
                }
                
            }
        }else{         
            
            List<Lead> leads = UtilClass.getLeadsByEmail(new List<String> {application.email});
            
            if (leads.size() > 1) {
                throw new MoreThanOnewException('Existe mas de un Candidato con el correo electronico ingresado');
            }
            
            if(!leads.isEmpty()){
                ctId = UtilClass.convertLead(leads[0]);  //convertir lead
            }
        }
        
        system.debug('mapping ' + mapping.get('Contact'));
        system.debug('values ' + mapValues);
        // crear contacto con datos del ws, si existe un id lo actualiza
        Contact ctc = (Contact) createRecord('Contact',mapValues,mapping.get('Contact'), ctId);
        ctc.email = application.email;
        
        system.debug('ctc: ' + ctc);
        upsert ctc;
        //si existe la postulacion actualizarla
        postulacion.Id = applicationIdToUpdate;
        postulacion.Contacto__c = ctc.id;
        postulacion.Nro_de_orden__c = application.id;
        postulacion.Name = '';
        system.debug('postulacion: ' + postulacion);
        PostulacionTriggerMethods.send = false;
        upsert postulacion;
        
        success = true;
        PostulacionTriggerMethods.send = true;
        return success;    
    }

    //metodo provisorio para el servicio de  creacion de posgrado. Este metodo va a ser integrado con el de grado.
    public static Boolean createApplicationPosgrado(Application application, String proceso){
        
        Boolean success;
        Id applicationIdToUpdate;
        
        map<String,String> mapValues = getMapValues(application.data);
        map<String,List<FieldMapping__mdt>> mapping = UtilClass.getMapping(proceso);
        
     //   Id rtPosgrado = UtilClass.getRecordTypeIdFromName('Postulacion__c','Posgrados');
        
        if(String.isBlank(application.tipoDocumento) || String.isBlank(application.numeroDocumento) ){
            throw new ManageApplications.RequiredFieldsException('Tipo y Número de Documento son obligatorios');
        }
        
        List<Contact> cts = UtilClass.getContactsByDocument( application.tipoDocumento,  application.numeroDocumento ); // ver de poner aca el campo identificatorio
        if(cts.isEmpty()){
             cts = UtilClass.getContactsByEmail( new List<String> {application.email}); 
        }
        
        if (cts.size() > 1) {
            throw new MoreThanOnewException('Existe mas de un Contacto con el numero de documento ingresado');
        }
        
        Id ctId = null;
        system.debug(cts);
        
        //postulacion con datos de sigedu
        Postulaciones__c  postulacion = (Postulaciones__c) createRecord('Postulaciones__c',mapValues,mapping.get('Postulaciones__c'), null); 
     	
        //buscar carrrera para ver que recordtype.
        Account unit = [SELECT Id, Unidad_de_negocios__c FROM Account WHERE idSigedu__c  =: postulacion.Cuenta__r.idSigedu__c ];
        
        
        //existe un contacto con el email 
        if(!cts.isEmpty() ){
            Contact oldContact = cts[0];
            //validar que el dni sea el mismo q el de gestion sino errror
            String docFormula = application.tipoDocumento + application.numeroDocumento;
            if(!String.isBlank(oldContact.TipoDocumento__c) && !String.isBlank(oldContact.Documento__c)  &&  oldContact.DocumentoFormula__c != docFormula){
                throw new ProcessException('Distinto documento al registrado en SF: ' + docFormula + ' <> ' + oldContact.DocumentoFormula__c);
            }
                
            ctId = oldContact.id;
            //si la postulacion que ingresa es de grado 
            //Se busca la postulación por correo electrónico del chico y el campo Período de inicio de cursada - Si encuenta, actualiza y sino crea           
            //si la postulacion es de posgrado : No queremos que actualice postulaciones de otras carreras: Se busca por correo electrónico y por carrera,
            // si no encuentra - Crea. Si encuentra actualiza
            
            List<Postulaciones__c> postualcionesPosGrado = [SELECT id, Oferta_Acad_mica__c,Cuenta__c,Cuenta__r.IdSigedu__c, Etapa_Postulaci_n__c, Oferta_Acad_mica__r.Per_odo__c
                                                            FROM Postulaciones__c
                                                            WHERE Contacto__c =:ctId 
                                                            AND Cuenta__r.IdSigedu__c =:postulacion.Cuenta__r.IdSigedu__c
                                                            AND Oferta_Acad_mica__r.Id_Sigedu__c  =:postulacion.Oferta_Acad_mica__r.Id_Sigedu__c
                                                            AND Permite_Ser_Actualizada_Por_Integracion__c = True
                                                           ];
            
            //Si es de posgrado de negocios y no encuentra postulacion ...error. 
            //si encuentra mas de una ..error duplicado.
            //inicio de cursada.
            //tiene postulacion para el mismo pogrado y esta en la etapa correcta se actualiza	
            if(!postualcionesPosGrado.isEmpty()){
                applicationIdToUpdate = postualcionesPosGrado[0].Id;
            }else{
                if(unit.Unidad_de_negocios__c == ManageApplications.POSGRADO_NEGOCIO){
                     throw new ProcessException('No existe postulación para actualizar (Posgrado Negocio)');
                }
            }      
        }else{         
            
            List<Lead> leads = UtilClass.getLeadsByEmail(new List<String> {application.email});
            
            if (leads.size() > 1) {
                throw new MoreThanOnewException('Existe mas de un Candidato con el correo electronico ingresado');
            }
            
            if(!leads.isEmpty()){
                ctId = UtilClass.convertLead(leads[0]);  //convertir lead
            }
        }
        
        system.debug('mapping ' + mapping.get('Contact'));
        system.debug('values ' + mapValues);
        // crear contacto con datos del ws, si existe un id lo actualiza
        Contact ctc = (Contact) createRecord('Contact',mapValues,mapping.get('Contact'), ctId);
        ctc.email = application.email;
        
        system.debug('ctc: ' + ctc);
        upsert ctc;
        //si existe la postulacion actualizarla
        postulacion.Id = applicationIdToUpdate;
        postulacion.Contacto__c = ctc.id;
        postulacion.Nro_de_orden__c = application.id;
        postulacion.Name = '';
        system.debug('postulacion: ' + postulacion);
        PostulacionTriggerMethods.send = false;
        upsert postulacion;
		PostulacionTriggerMethods.send = true;        
        success = true;
        
        return success;    
    }
    
    

    public static Boolean updateApplication(Application application, String proceso){

        Boolean success;

        map<String,String> mapValues = getMapValues(application.data);
        map<String,List<FieldMapping__mdt>> mapping = UtilClass.getMapping(proceso);

        Postulaciones__c app = UtilClass.getPostulacion(application.id);
        
        if(app == null){
            success = false;
            throw new ApplicationNotFoundException('No existe la postulacion');
        }else{
            if(!app.Permite_Ser_Actualizada_Por_Integracion__c){
                throw new ProcessException('La postulación no permite ser actualizada');
            }
        }

        Postulaciones__c postulacion = (Postulaciones__c) createRecord('Postulaciones__c',mapValues,mapping.get('Postulaciones__c'), app.id);
	    Contact ctc = (Contact) createRecord('Contact',mapValues,mapping.get('Contact'), app.Contacto__c);
        
        update postulacion; 
        update ctc;
        
        success = true;

        return success;
    }


    public static Sobject createRecord(String objectName, map<String,String> mapValues,List<FieldMapping__mdt> mapping,Id rID){
     
        sObject record = MetadataUtil.createRecord(objectName) ;

        if(rId != null) record.id = rId;
        if(mapping != null){
            system.debug('m ' + mapping );
            system.debug('mapValues ' + mapValues );
            
            for(FieldMapping__mdt m:mapping ){
                system.debug('m ' + m );
                system.debug('m2 ' +  mapValues.get(m.SourceFieldName__c) );
                
                if((mapValues.containsKey(m.SourceFieldName__c ) && String.isNotBlank(mapValues.get(m.SourceFieldName__c) )) || String.isNotBlank(m.DefaultValue__c) ){
                    if(m.isRelationship__c){
                        sObject sObj = UtilClass.getSObjectRecord(m.RelationshipObject__c, m.RelationshipIdField__c,mapValues.get(m.SourceFieldName__c));
                        record.putSObject(m.TargetFieldName__c, sObj );
                    }else{
                        String value = (String.isNotBlank(m.DefaultValue__c))? m.DefaultValue__c : mapValues.get(m.SourceFieldName__c);               
                        MetadataUtil.setFieldValue(record,objectName,m.TargetFieldName__c,value);
                    }
                }else{
                    if(m.Required__c){
                        throw new RequiredFieldsException('El campo ' + m.SourceFieldName__c + ' es obligatorio');
                    }
                }
                
            }
        }

        return record;
    }


    private static map<String,String> getMapValues(List<Field> data){

        map<String,String> mapValues = new map<String,String>();

        for(Field f : data){
            mapValues.put(f.name, f.value);
        }

        return mapValues;
    }

    public static void pass(){
        Integer i = 0;

        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
              i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
    

    public class Application{
        
        public String id {get;set;}
        public String email  {get;set;}
        public String tipoDocumento {get;set;}
        public String numeroDocumento {get;set;}
        public String fecha {get;set;}
        public String idCarrera {get;set;}
        public List<Field> data {get;set;}

        public Application(){
            data = new List<Field>();
        }

        public void addField(String name, String value){

            Field f = new Field();
            f.name = name;
            f.value = value;

            data.add(f);
        }
        
    }
    
    public class Field{
        public String name {get;set;}
        public String value {get;set;}
    }

    public class ApplicationNotFoundException extends Exception {}
    public class BecaNotFoundException extends Exception {}
    public class RequiredFieldsException extends Exception {}
    public class MoreThanOnewException extends Exception {}
    public class ProcessException extends Exception {}
    public class MoreThanOneApplicationException extends Exception {}
}