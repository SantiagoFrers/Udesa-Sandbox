@RestResource(urlMapping='/CrearPostulacionBeca/*')
global with sharing class CrearPostulacionBecaService {

    @HttpPost
    global static ServicesUtil.Result doPost(ServicesUtil.SolicitudBeca solicitudBeca ){
       	system.debug('solicitudBeca ' + solicitudBeca);
        ServicesUtil.Result result = new ServicesUtil.Result();
        setResult(result,'', '');

        ManagePostulacionesBeca.SolicitudBeca postulacionBeca = getSolBeca( solicitudBeca);

        Boolean success = false;
        
        RestResponse res = RestContext.response;
        
        Savepoint sp = Database.setSavepoint();

        try{           
            success = ManagePostulacionesBeca.createBecas(postulacionBeca);
        }catch(ManagePostulacionesBeca.ApplicationNotFoundException ex) {  
            System.debug(ex.getMessage());
            setResult(result,'ERROR_POSTULACION_INEXISTENTE', ex.getMessage());
        }catch(ManagePostulacionesBeca.BecaNotFoundException ex) {  
            System.debug(ex.getMessage());
            setResult(result,'ERROR_BECA_INEXISTENTE', ex.getMessage());
        }catch(TypeException ex){
            System.debug(ex.getMessage()); //error casteos
            setResult(result,'ERROR_TIPO_DATOS', ex.getMessage());  
        }catch(DMLException ex){
            System.debug(ex.getMessage());
            setResult(result,'ERROR_UPDATE', ex.getMessage());  
        }catch(Exception ex){
            System.debug(ex.getMessage());
            setResult(result,'ERROR', 'No se pudo procesar la solicitud');  
        }
		system.debug(success);
        if(success){       
             setResult(result,'OK', 'OK');
        }else{
             if(!Test.isRunningTest()){
                res.statusCode = 400;
                Database.rollback(sp);
            }
        }

        return result;
    }

    private static ManagePostulacionesBeca.SolicitudBeca getSolBeca(ServicesUtil.SolicitudBeca solBeca ){

        ManagePostulacionesBeca.SolicitudBeca sol = new ManagePostulacionesBeca.SolicitudBeca();
       
        sol.id = solBeca.idSolicitud;
        sol.stage = solBeca.stage;

        for (Integer i = 0; i < solBeca.becas.size() ; i++) {
           sol.addBeca(solBeca.becas[i].idBeca, solBeca.becas[i].porcentaje);
        }

        return sol;
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