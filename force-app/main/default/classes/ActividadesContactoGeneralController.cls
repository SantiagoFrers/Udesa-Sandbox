public without sharing class ActividadesContactoGeneralController {

    public Lead lead {get; set;}
    public Lead leadHijo {get; set;}
    public Lead leadProf {get; set;}

    public String optPersona {get; set;}
    public String[] actividades {get; set;}

    public Boolean success {get; set;}
    public String successMsg {get; set;}

    public List < SelectOption > actividadesOpt {get; set;}

    public map < String,List < Localidad__c >> mapLocalidades {get; set;}

    public ActividadesContactoGeneralController() {
        optPersona = 'Padre';

        lead = new Lead(leadSource = 'Web', AutomaticConversionToContact__c = true, Company = 'NO INFORMA', Clasificacion__c = 'Padre');
        leadHijo = new Lead(leadSource = 'Web', AutomaticConversionToContact__c = true, Company = 'NO INFORMA');

        leadProf = new Lead(leadSource = 'Web', AutomaticConversionToContact__c = true, Company = 'NO INFORMA', Clasificacion__c = 'Personal de colegio');

        actividadesOpt = getActividades();
        actividades = new String[] {};

        mapLocalidades = CommonMethods.getLocalidadesPorPais();
        success = false;
    }

    public PageReference save() {

        if (actividades.size() == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Seleccione una actividad'));

            return null;
        }

        try {
            List < Lead > leads = new List < Lead > ();

            if (optPersona == 'Padre') {

                if (String.isBlank(lead.firstName) || String.isBlank(lead.lastName) || String.isBlank(lead.email) || String.isBlank(lead.mobilePhone)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Faltan datos obligatorios'));
                    return null;
                }

                if (String.isBlank(leadHijo.firstName) || String.isBlank(leadHijo.lastName) || String.isBlank(leadHijo.email)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Faltan datos obligatorios'));
                    return null;
                }

                lead.ActividadId__c = string.join(actividades, ';');

                leads.add(lead);
                leads.add(leadHijo);

            } else {
                if (String.isBlank(leadProf.firstName) || String.isBlank(leadProf.lastName) || String.isBlank(leadProf.email)|| String.isBlank(leadProf.Localidad__c)|| String.isBlank(leadProf.Nombre_de_cuenta_web__c)|| String.isBlank(leadProf.CargoColegio__c)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Faltan datos obligatorios'));
                    return null;
                }
                leadProf.ActividadId__c = string.join(actividades, ';');

                leads.add(leadProf);

            }

            insert leads;

            PageReference successPage = new PageReference('/apex/SuccessFormPage?msg=' + successMsg);

            successPage.setRedirect(true);
            return successPage;
        } catch(DMLException ex) {
            system.debug(ex);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getDMLMessage(0)));
        }

        return null;
    }

    public List < SelectOption > getPcias() {

        List < SelectOption > options = new List < SelectOption > ();

        List < Localidad__c > listLoc = [SELECT id, name, Provincia__c, Pa_s__c, Zona_local__c FROM Localidad__c order By name];

        for (Localidad__c l: listLoc) {
            options.add(new SelectOption(l.id, l.name));
        }

        return options;
    }

    public map < String,map < String, List < Localidad__c >>> getLocalidades() {
    
        map < String, List < Localidad__c >> mapPais = CommonMethods.getLocalidadesPorPais();
        map < String,map < String,List < Localidad__c >>> mapAux = new map < String,
        map < String, List < Localidad__c >>> ();

        for (String p: mapPais.keySet()) {
            List < Localidad__c > localidades = mapPais.get(p);
            map < String,
            List < Localidad__c >> mapPcia = new map < String,
            List < Localidad__c >> ();
            for (Localidad__c l: localidades) {
                List < Localidad__c > opts = mapPcia.get(l.Provincia__c);
                if (opts == null) opts = new List < Localidad__c > ();

                opts.add(l);

                mapPcia.put(l.Provincia__c, opts);
            }

            mapAux.put(p, mapPcia);
        }
        return mapAux;
    }

    private List < SelectOption > getActividades() {

        String actParam = apexpages.currentpage().getparameters().get('actividades');

        set < id > ids = new set < id > ();
        List < Actividad__c > actividadesAux;
        try {

            for (String a: actParam.split(';')) {
                ids.add(a);
            }

            actividadesAux = [SELECT id, Name, Nombre_de_la_actividad__c, Titulo__c FROM Actividad__c WHERE id in :ids];

            List < SelectOption > opts = new List < SelectOption > ();

            for (Actividad__c a: actividadesAux) {
                opts.add(new SelectOption(a.id, String.format(Label.OpcionActividad, new String[] {
                    a.Titulo__c
                })));

            }

            return opts;

        } catch(Exception ex) {}

        return null;

    }

}