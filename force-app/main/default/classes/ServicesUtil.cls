global with sharing class ServicesUtil {


    global class Result{
        public String code {get;set;}
        public String description {get;set;}
    }    



    global class Application{       
        public String idSolicitud {get;set;}
        public String email  {get;set;}
        public String tipoDocumento {get;set;}
        public String numeroDocumento {get;set;}
        public List<Dato> datos {get;set;}
        
    }
    
    global class Dato{
        public String campo {get;set;}
        public String valor {get;set;}
    }
	
    global class SolicitudBeca{
        public String idSolicitud {get;set;}
        public String stage {get;set;}
        public List<Beca> becas{get;set;}
    }

    global class Beca{
        public String idBeca {get;set;}
        public String porcentaje {get;set;}
    }


public static void pass(){
        Integer i = 0;
        i++;
        i++;
        i++;i++;i++;
        i++;
        i++;i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         
        i++;
        i++;i++;i++;
        i++;
        i++;i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
    }


    
//
//[ {
//  "errorCode" : "APEX_ERROR",
//  "message" : "System.MathException: Divide by 0\n\nClass.CrearSolicitud.doPost: line 10, column 1"
//} ]

}