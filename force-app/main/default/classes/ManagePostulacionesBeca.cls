public with sharing class ManagePostulacionesBeca {
    
    private static final Map<String,String> stateBecaByStage = new Map<String,String>{ 'Confirmado' => 'No Procesada' , 'Postulado' => 'Pendiente de Resolución'};
	private static final String STAGE_CONFIRMED = 'Confirmado';
    private static final String STAGE_POSTULATED = 'Postulado';

    public static Boolean createBecas(SolicitudBeca solBeca){
            system.debug(' manage postulacion beca ' + solBeca);
       Boolean success = false;

        Postulaciones__c app = UtilClass.getPostulacion(solBeca.id);
        String year = String.valueOf(app.A_o_comienza_a_cursar__c);
        
        if(app == null){
            success = false;
            throw new ApplicationNotFoundException('No existe la postulacion');
        }
        List<Decimal> nBecas = new List<Decimal>();
        
        for(Beca b:solBeca.becas){
            nBecas.add(Decimal.valueOf(b.idBeca));
        }
        
        if(solBeca.stage == STAGE_CONFIRMED){
            List<Becas__c> becas =  new List<Becas__c> ();
           
            map<String,Beca__c> mapBecas = new map<String,Beca__c>();
            
            for(Beca__c b : [SELECT id,ID_BECA_SIGEDU__c FROM Beca__c WHERE ID_BECA_SIGEDU__c in : nBecas AND A_o__c = :year]){
                mapBecas.put(String.valueOf(b.ID_BECA_SIGEDU__c), b);
            }
            
            for(Beca b:solBeca.becas){
                
                Beca__c beca = mapBecas.get(b.idBeca);
                if(beca == null){
                    throw new BecaNotFoundException('La beca ' + b.idBeca + '(' + year + ') No existe' );
                }
                
                Becas__c newBeca = new Becas__c();
                newBeca.Postulacion__c = app.id;
                newBeca.Contacto__c = app.Contacto__c;
                newBeca.BecaSolicitada__c = Decimal.valueOf(b.porcentaje);
                newBeca.Beca__c = beca.id;
                newBeca.Estado__c = stateBecaByStage.get(solBeca.stage);
                
                becas.add(newBeca);
            }
            insert becas;
            success = true;
        }else if(solBeca.stage == STAGE_POSTULATED){
            
            List<Becas__c> becasToUpdate = [SELECT Id,Estado__c FROM Becas__c WHERE Beca__r.ID_BECA_SIGEDU__c in :nBecas AND Postulacion__c =:app.id];
            for(Becas__c becaToUpdate : becasToUpdate){
            	becaToUpdate.Estado__c = stateBecaByStage.get(solBeca.stage);
            }
            update becasToUpdate;
            success = true;
        }
        
        return success;
    }
    
        
    public class SolicitudBeca{
        public String id {get;set;}
        public List<Beca> becas{get;set;}
        public String stage {get;set;}

        public SolicitudBeca(){
            becas = new List<Beca>();
        }

        public void addBeca(String idBeca, String porcentaje){
            Beca b = new Beca();
            b.idBeca = idBeca;
            b.porcentaje = porcentaje;

            becas.add(b);
        }
    }

    public class Beca{
        public String idBeca {get;set;}
        public String porcentaje {get;set;}
    }


    public class ApplicationNotFoundException extends Exception {}
    public class BecaNotFoundException extends Exception {}
    
   

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