@isTest
public with sharing class CrearPostulacionPosgradoServiceTest {
    
    @IsTest
    static void methodName(){
      
      Account c = TestUtilData.createCarrera('1','Administracion');
      Oferta_Acad_mica__c ic = TestUtilData.creteInicioCursada('1',c.id);
      MetadataUtil.getMapping('Postulado');
      test.startTest();

        String json = '{"idSolicitud":1111,"datos":[{"campo":"apellido","valor":"Rodríguez"},{"campo":"nombre","valor":"Juan Pablo"},{"campo":"fecha_nacimiento","valor":"1994-12-17"},{"campo":"sexo","valor":"Male"},{"campo":"tipo_documento","valor":"DNI"},{"campo":"documento","valor":"38709661"},{"campo":"calle","valor":"Carlos Gardel 1689 (1636)"},{"campo":"localidad","valor":"a0K6C000004HyElUAK"},{"campo":"telefono","valor":"47940689"},{"campo":"celular","valor":"1540761800"},{"campo":"email","valor":"rodrigueztrimboli.juanpablo@gmail.com"},{"campo":"solicita_AF","valor":"SI"},{"campo":"ano_finalizacion","valor":2012},{"campo":"cursa_otra_universidad","valor":"SI"},{"campo":"abanderado","valor":"NO"},{"campo":"turno_comite","valor":null},{"campo":"nacionalidad","valor":"Argentina"},{"campo":"carrera_elegida","valor":"1"},{"campo":"colegio","valor":"Colegio La Salle (Florida)"},{"campo":"otra_universidad","valor":null},{"campo":"otra_localidad","valor":null},{"campo":"prom_ano_curso","valor":8},{"campo":"prom_ultimo_ano","valor":8},{"campo":"ingreso_directo","valor":"NO"},{"campo":"tipo_AF","valor":"BSA;Crédito Educativo;Premio al Merito;"},{"campo":"id_inicio_cursada","valor":"1"},{"campo":"doble_titulacion","valor":"1"},{"campo":"solicita_equivalencia","valor":"NO"},{"campo":"tipo_ingreso_directo","valor":null},{"campo":"fecha","valor":"2018-12-06"}],"email":"rodrigueztrimboli.juanpablo@gmail.com"}';
      

        ServicesUtil.Application app = (ServicesUtil.Application) System.JSON.deserialize(json, ServicesUtil.Application.class);

        System.System.debug(app);
        ServicesUtil.result result = CrearPostulacionPosgradoService.doPost(app);

        json = '{"idSolicitud":1111,"datos":[{"campo":"apellido","valor":"Rodríguez"},{"campo":"nombre","valor":"Juan Pablo"},{"campo":"fecha_nacimiento","valor":"1994/12-17"},{"campo":"sexo","valor":"Male"},{"campo":"tipo_documento","valor":"DNI"},{"campo":"documento","valor":"38709661"},{"campo":"calle","valor":"Carlos Gardel 1689 (1636)"},{"campo":"localidad","valor":"a0K6C000004HyElUAK"},{"campo":"telefono","valor":"47940689"},{"campo":"celular","valor":"1540761800"},{"campo":"email","valor":"rodrigueztrimboli.juanpablo@gmail.com"},{"campo":"solicita_AF","valor":"SI"},{"campo":"ano_finalizacion","valor":2012},{"campo":"cursa_otra_universidad","valor":"SI"},{"campo":"abanderado","valor":"NO"},{"campo":"turno_comite","valor":null},{"campo":"nacionalidad","valor":"Argentina"},{"campo":"carrera_elegida","valor":"1"},{"campo":"colegio","valor":"Colegio La Salle (Florida)"},{"campo":"otra_universidad","valor":null},{"campo":"otra_localidad","valor":null},{"campo":"prom_ano_curso","valor":8},{"campo":"prom_ultimo_ano","valor":8},{"campo":"ingreso_directo","valor":"NO"},{"campo":"tipo_AF","valor":"BSA;Crédito Educativo;Premio al Merito;"},{"campo":"id_inicio_cursada","valor":"1"},{"campo":"doble_titulacion","valor":"1"},{"campo":"solicita_equivalencia","valor":"NO"},{"campo":"tipo_ingreso_directo","valor":null},{"campo":"fecha","valor":"2018-12-06"}],"email":"rodrigueztrimboli.juanpablo@gmail.com"}';
      

        app = (ServicesUtil.Application) System.JSON.deserialize(json, ServicesUtil.Application.class);

        result = CrearPostulacionPosgradoService.doPost(app);

        json = '{"idSolicitud":1111,"datos":[{"campo":"apellido","valor":"Rodríguez"},{"campo":"nombre","valor":"Juan Pablo"},{"campo":"fecha_nacimiento","valor":"1994/12-17"},{"campo":"sexo","valor":"Male"},{"campo":"tipo_documento","valor":"DNI"},{"campo":"documento","valor":"38709661"},{"campo":"calle","valor":"Carlos Gardel 1689 (1636)"},{"campo":"localidad","valor":"a0K6C000004HyElUAK"},{"campo":"telefono","valor":"47940689"},{"campo":"celular","valor":"1540761800"},{"campo":"email","valor":"rodrigueztrimboli.juanpablo@gmail.com"},{"campo":"solicita_AF","valor":"SI"},{"campo":"ano_finalizacion","valor":2012},{"campo":"cursa_otra_universidad","valor":"SI"},{"campo":"abanderado","valor":"NO"},{"campo":"turno_comite","valor":null},{"campo":"nacionalidad","valor":"Argentina"},{"campo":"carrera_elegida","valor":"1"},{"campo":"colegio","valor":"Colegio La Salle (Florida)"},{"campo":"otra_universidad","valor":null},{"campo":"otra_localidad","valor":null},{"campo":"prom_ano_curso","valor":8},{"campo":"prom_ultimo_ano","valor":8},{"campo":"ingreso_directo","valor":"NO"},{"campo":"tipo_AF","valor":"BSA;Crédito Educativo;Premio al Merito;"},{"campo":"id_inicio_cursada","valor":"1lll"},{"campo":"doble_titulacion","valor":"1"},{"campo":"solicita_equivalencia","valor":"NO"},{"campo":"tipo_ingreso_directo","valor":null},{"campo":"fecha","valor":"2018-12-06"}],"email":"rodrigueztrimboli.juanpablo@gmail.com"}';
      

        app = (ServicesUtil.Application) System.JSON.deserialize(json, ServicesUtil.Application.class);

        result = CrearPostulacionPosgradoService.doPost(app);

        json = '{"idSolicitud":233423423,"datos":[{"campo":"apellido","valor":"Rodríguez"},{"campo":"nombre","valor":"Juan Pablo"},{"campo":"fecha_nacimiento","valor":"1994-12-17"},{"campo":"sexo","valor":"Male"},{"campo":"tipo_documento","valor":"DNI"},{"campo":"documento","valor":"38709661"},{"campo":"calle","valor":"Carlos Gardel 1689 (1636)"},{"campo":"localidad","valor":"a0K6C000004HyElUAK"},{"campo":"telefono","valor":"47940689"},{"campo":"celular","valor":"1540761800"},{"campo":"email","valor":"rodrigueztrimboli.juanpablo@gmail.com"},{"campo":"solicita_AF","valor":"SI"},{"campo":"ano_finalizacion","valor":2012},{"campo":"cursa_otra_universidad","valor":"SI"},{"campo":"abanderado","valor":"NO"},{"campo":"turno_comite","valor":null},{"campo":"nacionalidad","valor":"Argentina"},{"campo":"carrera_elegida","valor":"1"},{"campo":"colegio","valor":"Colegio La Salle (Florida)"},{"campo":"otra_universidad","valor":null},{"campo":"otra_localidad","valor":null},{"campo":"prom_ano_curso","valor":8},{"campo":"prom_ultimo_ano","valor":8},{"campo":"ingreso_directo","valor":"NO"},{"campo":"tipo_AF","valor":"BSA;Crédito Educativo;Premio al Merito;"},{"campo":"id_inicio_cursada","valor":"1"},{"campo":"doble_titulacion","valor":"1"},{"campo":"solicita_equivalencia","valor":"NO"},{"campo":"tipo_ingreso_directo","valor":null},{"campo":"fecha","valor":"2018-12-06"}],"email":"test@lead.com"}';

        Lead l = TestUtilData.createLead('test@lead.com');
        app = (ServicesUtil.Application) System.JSON.deserialize(json, ServicesUtil.Application.class);

        result = CrearPostulacionPosgradoService.doPost(app);

        System.Assert([SELECT email from Contact WHERE email =:l.email limit 1] != null );

        System.System.debug(result);

        json = '{"idSolicitud":233423423,"datos":[{"campo":"apellido","valor":"Rodríguez"},{"campo":"nombre","valor":"Juan Pablo"},{"campo":"fecha_nacimiento","valor":"1994-12-17"},{"campo":"sexo","valor":"Male"},{"campo":"tipo_documento","valor":"DNI"},{"campo":"documento","valor":"38709661"},{"campo":"calle","valor":"Carlos Gardel 1689 (1636)"},{"campo":"localidad","valor":"a0K6C000004HyElUAK"},{"campo":"telefono","valor":"47940689"},{"campo":"celular","valor":"1540761800"},{"campo":"email","valor":"rodrigueztrimboli.juanpablo@gmail.com"},{"campo":"solicita_AF","valor":"SI"},{"campo":"ano_finalizacion","valor":2012},{"campo":"cursa_otra_universidad","valor":"SI"},{"campo":"abanderado","valor":"NO"},{"campo":"turno_comite","valor":null},{"campo":"nacionalidad","valor":"Argentina"},{"campo":"carrera_elegida","valor":"1"},{"campo":"colegio","valor":"Colegio La Salle (Florida)"},{"campo":"otra_universidad","valor":null},{"campo":"otra_localidad","valor":null},{"campo":"prom_ano_curso","valor":8},{"campo":"prom_ultimo_ano","valor":8},{"campo":"ingreso_directo","valor":"NO"},{"campo":"tipo_AF","valor":"BSA;Crédito Educativo;Premio al Merito;"},{"campo":"id_inicio_cursada","valor":"1"},{"campo":"doble_titulacion","valor":"1"},{"campo":"solicita_equivalencia","valor":"NO"},{"campo":"tipo_ingreso_directo","valor":null},{"campo":"fecha","valor":"2018-12-06"}],"email":"test@lead.com"}}';

        result = ActualizarPostulacionService.doPost(app,'Postulado');


        
      test.stopTest();

      ManageApplications.pass();
      MetadataUtil.pass();
      CrearPostulacionPosgradoService.pass();
      UtilClass.pass();
    }
}