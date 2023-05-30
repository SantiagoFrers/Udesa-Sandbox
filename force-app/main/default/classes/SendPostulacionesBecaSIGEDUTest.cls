@isTest
public class SendPostulacionesBecaSIGEDUTest {

    @isTest
    public static void otorgarBeca(){
    	
    	TestUtilData.createPostulacionBecaScene();
        
        List<Becas__c> postulacionesBeca = [SELECT  Alojamiento_Otorgado__c,CreditoOtorgado__c,BecaOtorgada__c,Postulacion__c,
                                   		Estado__c 
                                   FROM Becas__c];
        
        Test.setMock(HttpCalloutMock.class, new WebServicesMockTest());
        Test.startTest();
        
        	postulacionesBeca[0].Estado__c = 'Otorgado';
        
        	update postulacionesBeca[0];
        
        Test.stopTest();
       	
        
        Postulaciones__c postulacion = [SELECT id , Nro_de_orden__c,Etapa_Postulaci_n__c,BecasSincronizadasSIGEDUMensajeError__c,BecasSincronizadasSIGEDU__c,
                                                (SELECT id, Beca__c, Beca__r.ID_BECA_SIGEDU__c,BecaOtorgada__c,Estado__c,Alojamiento_Otorgado__c,Comit_m_s_reciente__c ,Comit_m_s_reciente__r.Name
                                                 FROM Becas__r
                                                 WHERE FueOtorgada__c = true
                                                	OR Comit_m_s_reciente__c != Null)
                                                FROM Postulaciones__c WHERE id =:postulacionesBeca[0].Postulacion__c];
        system.assert(postulacion.BecasSincronizadasSIGEDU__c == 'ENVIADO');
        
    }
    
    @isTest
    public static void assignComite(){
    	Comite__c comite = new Comite__c();
        comite.Fecha_del_comit__c = Date.today();
        comite.Tipo_de_comit__c = 'General';
        insert comite;
        
    	TestUtilData.createPostulacionBecaScene();
        
        List<Becas__c> postulacionesBeca = [SELECT  Alojamiento_Otorgado__c,CreditoOtorgado__c,BecaOtorgada__c,Postulacion__c,
                                   		Estado__c 
                                   FROM Becas__c];
        
        Test.setMock(HttpCalloutMock.class, new WebServicesMockTest());
        Test.startTest();
        
        	postulacionesBeca[0].Comit_m_s_reciente__c = comite.Id;
        
        	update postulacionesBeca[0];
        
        Test.stopTest();
       	
        
        Postulaciones__c postulacion = [SELECT id , Nro_de_orden__c,Etapa_Postulaci_n__c,BecasSincronizadasSIGEDUMensajeError__c,BecasSincronizadasSIGEDU__c,
                                                (SELECT id, Beca__c, Beca__r.ID_BECA_SIGEDU__c,BecaOtorgada__c,Estado__c,Alojamiento_Otorgado__c,Comit_m_s_reciente__c ,Comit_m_s_reciente__r.Name
                                                 FROM Becas__r
                                                 WHERE FueOtorgada__c = true
                                                	OR Comit_m_s_reciente__c != Null)
                                                FROM Postulaciones__c WHERE id =:postulacionesBeca[0].Postulacion__c];
        system.assert(postulacion.BecasSincronizadasSIGEDU__c == 'ENVIADO');
        
    }
        
}