public class SyncSymposiumAttendees {

    public static List<Stage_Event_Attendees__c> SyncAttendees(Campaign c, Integer Pagenumber){
//        Campaign[] relevantCampaigns = [select Id,Symposium_ID__c  from Campaign where IsActive= true and Sync_with_Symposium__c= true];
//        System.Debug('Relevant Campaigns:' + relevantCampaigns);
        boolean fullpage = false;
        List <Stage_Event_Attendees__c> stageAttendees = new List <Stage_Event_Attendees__c> ();
        System.debug('Page: ' +  Pagenumber);

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        StaticResource sr = [SELECT Id, Body FROM StaticResource WHERE Name = 'SymposiumEventAttendeesClientID' LIMIT 1];
        String client_id = sr.Body.toString();
//add page
        request.setEndpoint('callout:Symposium_Attendees/event/'+ c.Symposium_ID__c + '/attendees?client_id=' +client_id+ '&limit=100&page=' + Pagenumber);
        request.setTimeout(120000);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            ResultSet results = new ResultSet();
            results = (ResultSet) JSON.deserialize(response.getBody(), ResultSet.class);
            System.debug('Response size'+ results.Attendees.size());

            for (Attendees attendee: results.Attendees) {
                Stage_Event_Attendees__c stageAttendee = new Stage_Event_Attendees__c();

                stageAttendee.attending_id__c = attendee.event_id + '_' + attendee.attending_id;
                stageAttendee.email__c = attendee.email;
                stageAttendee.Manager__c = attendee.manager;
                stageAttendee.nombre__c = attendee.first_name;
                stageAttendee.apellidos__c = attendee.last_name;
                stageAttendee.event_id__c = attendee.event_id;
                stageAttendee.name__c = attendee.name;
                stageAttendee.status__c = attendee.status;
                stageAttendee.registration_form_submitted__c = attendee.registration_form_submitted;
                stageAttendee.created__c = Datetime.valueOf(attendee.created);
                stageAttendee.username__c = attendee.username;
                stageAttendee.visibility__c = attendee.visibility;
                stageAttendee.invoice_id__c = attendee.invoice_id;
                if (attendee.ticket != null){
                    stageAttendee.invoice_id__c = attendee.ticket.id;
                    stageAttendee.invoice_name__c = attendee.ticket.name;
                    stageAttendee.invoice_price__c = attendee.ticket.price;
                }

                if (attendee.checkin != null){
                    stageAttendee.checkin_checked__c = attendee.checkin.checked;
                    stageAttendee.checkin_date_in__c = Datetime.valueOf(attendee.checkin.date_in);
                }
                stageAttendees.add(stageAttendee);

            }

        }


//        try {
//            upsert stageAttendees attending_id__c;
//        } catch (DmlException e) {
//            System.debug(e.getMessage());
//        }

        return stageAttendees;

    }


    public class Ticket {
        public Integer id;
        public String name;
        public Decimal price;
    }

    public class Checkin{
        public Boolean checked;
        public String date_in;
        public Integer date_in_timestamp;
        public String date_out;
        public Integer date_out_timestamp;

    }
    public class Attendees {
        public Integer attending_id;
        public Integer user_id;
        public Integer manager;
        public String username;
        public String email;
        public String name;
        public String first_name;
        public String last_name;
        public String visibility;
        public String status;
        public Integer event_id;
        public Boolean registration_form_submitted;
        public String created;
        public Integer invoice_id;
        public Integer created_timestamp;
        public Ticket ticket;
        public Checkin checkin;
    }
    public class ResultSet{
        public Integer total;
        public List<Attendees> attendees;
    }

    @AuraEnabled
    public static Id executeBatchJob(Id IdCampaign){
        SyncSymposiumAttendeesBatch batchEnviar = new SyncSymposiumAttendeesBatch();
        Campaign cmp = [SELECT Id, Symposium_ID__c FROM Campaign WHERE ID = :IdCampaign];
        batchEnviar.cmp = cmp;
        Id batchJobId = Database.executeBatch(batchEnviar, 200);
        System.debug('test' + batchJobId);
        cmp.batchId__c = batchJobId;
        update cmp;
        return batchJobId;
    }


    @AuraEnabled
    public static AsyncApexJob getBatchJobStatus(Id jobID){
        List<AsyncApexJob> jobInfo = [SELECT Status, NumberOfErrors,JobItemsProcessed,TotalJobItems FROM AsyncApexJob WHERE Id = :jobID];
        System.debug(jobId);
        if(jobInfo.size()>0){
            return jobInfo[0];
        }else{
            return null;
        }

    }
}