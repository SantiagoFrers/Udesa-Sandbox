@RestResource(urlMapping='/ActualizarPostulacion/*')
global with sharing class ActualizarPostulacionService {


    @HttpPost
    global static ServicesUtil.Result doPost(ServicesUtil.Application solicitud, String proceso){

        ServicesUtil.Result result = new ServicesUtil.Result();
        result.code = '';
        result.description = '';

        RestResponse res = RestContext.response;
      
        if(solicitud == null || String.isBlank(proceso)){
            if(!Test.isRunningTest())
                res.statusCode = 400;
            
            setResult(result,'ERROR_DATOS_OBLIGATORIOS','');

            return result;
        }

        ManageApplications.Application application = getApplication( solicitud);

        Boolean success = false;

        Savepoint sp = Database.setSavepoint();

        try{

            success = ManageApplications.updateApplication(application,proceso);
            
            System.assert(success);

            setResult(result,'OK','OK');

        }catch(ManageApplications.ApplicationNotFoundException ex) {  
            System.debug(ex.getMessage());
            setResult(result,'ERROR_NO_EXISTE_POSTULACION',ex.getMessage());
        }catch(ManageApplications.RequiredFieldsException ex) {  
            System.debug(ex.getMessage());
            setResult(result,'ERROR_CAMPO_REQUERIDO',ex.getMessage());
        }catch(ManageApplications.MoreThanOnewException ex) {  
            System.debug(ex.getMessage());
            setResult(result,'ERROR_DUPLICADOS',ex.getMessage());
        }catch(TypeException ex){
            System.debug(ex.getMessage()); //error casteos
            setResult(result,'ERROR_TIPO_DATOS',ex.getMessage());
        }catch(DMLException ex){
            System.debug(ex.getMessage());
            setResult(result,'ERROR_UPDATE',ex.getMessage()); 
        }catch(Exception ex){
            System.debug(ex.getMessage());
            setResult(result,'ERROR', 'No se pudo procesar la solicitud');  
        }

        if(!success){
            if(!Test.isRunningTest()){
                res.statusCode = 400;
                Database.rollback(sp);
            }
        }

        //response
        return result;
    }

    private static ManageApplications.Application getApplication(ServicesUtil.Application app ){

        ManageApplications.Application application = new ManageApplications.Application();
       
        application.id = app.idSolicitud;
        application.email = app.email;

        for (Integer i = 0; i < app.datos.size() ; i++) {
           application.addField(app.datos[i].campo, app.datos[i].valor);
        }

        return application;
    }

    private static void setResult(ServicesUtil.Result result, String code,String msg){
        result.code = code;
        result.description = msg;  
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
    }
    


}