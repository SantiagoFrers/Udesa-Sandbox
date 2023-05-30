@isTest
public with sharing class SendPostulacionesSIGEDUTest {

    @isTest
    public static void admitirPostulacion(){
        
        Postulaciones__c postulacion = TestUtilData.createPostulacionScene();

        postulacion.Etapa_Postulaci_n__c = 'Postulado';

        update postulacion;
        
        Test.setMock(HttpCalloutMock.class, new WebServicesMockTest());


        test.startTest();

            postulacion.Etapa_Postulaci_n__c = 'Admitido';
            update postulacion;
            
        test.stopTest();
        
        Postulaciones__c postulacionEnviada = [SELECT id,EstadoSIGEDU__c FROM Postulaciones__c WHERE id =: postulacion.id];

        system.assert(postulacionEnviada.EstadoSIGEDU__c =='ENVIADO');
    }

      @isTest
      public static void admitirPostulacionErrorSigedu(){
        
        Postulaciones__c postulacion = TestUtilData.createPostulacionScene();

        postulacion.Etapa_Postulaci_n__c = 'Postulado';

        update postulacion;
        
        WebServicesMockTest webserviceMock = new WebServicesMockTest();
        webserviceMock.error = true; 

        Test.setMock(HttpCalloutMock.class, webserviceMock);

        test.startTest();

            postulacion.Etapa_Postulaci_n__c = 'Admitido';
            update postulacion;
            
        test.stopTest();

        Postulaciones__c postulacionEnviada = [SELECT id,EstadoSIGEDU__c FROM Postulaciones__c WHERE id =: postulacion.id];

        system.assert(postulacionEnviada.EstadoSIGEDU__c =='ERROR');


    }

    @isTest
    public static void bajaPostulacion(){

        Postulaciones__c postulacion = TestUtilData.createPostulacionScene();

        postulacion.Etapa_Postulaci_n__c = 'Postulado';

        update postulacion;
        
        WebServicesMockTest webserviceMock = new WebServicesMockTest();
        webserviceMock.error = false; 

        Test.setMock(HttpCalloutMock.class, webserviceMock);

        test.startTest();
            postulacion.Motivo_Baja_de_Postulaci_n__c = 'test';
            postulacion.Etapa_Postulaci_n__c = 'Baja';
            update postulacion;
            
        test.stopTest();

        Postulaciones__c postulacionEnviada = [SELECT id,EstadoSIGEDU__c FROM Postulaciones__c WHERE id =: postulacion.id];

        system.assert(postulacionEnviada.EstadoSIGEDU__c =='ENVIADO');


        
    }

    @isTest
    public static void pagoMatriculacionPostulacion(){
        Postulaciones__c postulacion = TestUtilData.createPostulacionScene();

        
        WebServicesMockTest webserviceMock = new WebServicesMockTest();
        webserviceMock.error = false; 

        Test.setMock(HttpCalloutMock.class, webserviceMock);

            postulacion.Etapa_Postulaci_n__c = 'Admitido';

            update postulacion;
        test.startTest();

            postulacion.Exceptuar_pago_matricula__c = 'SI';
            update postulacion;
            
        test.stopTest();

        Postulaciones__c postulacionEnviada = [SELECT id,EstadoSIGEDU__c FROM Postulaciones__c WHERE id =: postulacion.id];

        system.assert(postulacionEnviada.EstadoSIGEDU__c =='ENVIADO');


    }


}