public class SyncSymposiumEvents {
    
    public static void SyncEvents(){
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        StaticResource sr = [SELECT Id, Body FROM StaticResource WHERE Name = 'SymposiumEventsClientID' LIMIT 1];
        String client_id = sr.Body.toString();
        System.debug('Client id: ' + client_id);
        request.setEndpoint('callout:Symposium_Events/events?client_id='+client_id+'&enable_private_events=1&limit=8000&ongoing=1');
        request.setTimeout(120000);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        // If the request is successful, parse the JSON response.
        if (response.getStatusCode() == 200) {           
            ResultSet results = (ResultSet) JSON.deserialize(response.getBody(), ResultSet.class);
            List <Stage_Event__c> stageEvents = new List <Stage_Event__c> ();
            for (Events event: results.Events) {
                Stage_Event__c stageEvent = new Stage_Event__c();
                
                stageEvent.SymposiumId__c = event.id;
                stageEvent.city_name__c = event.city_name;
                stageEvent.country_name__c = event.country_name;
                stageEvent.description__c = event.description;
                stageEvent.is_private__c = event.is_private;
                stageEvent.opening_date__c = DateTime.newInstance(event.opening_date);
                stageEvent.closing_date__c = DateTime.newInstance(event.closing_date);
                stageEvent.place__c = event.place;
                stageEvent.title__c = event.title;
                String categoriesfield = '';
                for(categories ct : event.categories){
                     categoriesfield +=  ct.name + ',';
                                                     }
                stageEvent.categoriesname__c = categoriesfield;
                stageEvent.type_name__c = event.type_name;
                stageEvent.type_id__c = event.type_id;
                stageEvent.type_route__c = event.type_route;
                stageEvent.url__c = event.url;
                stageEvent.timezone__c = event.timezone;
                stageEvent.registration_url__c = event.registration_url;
                stageEvent.owner__c = event.owner;
                stageEvent.summary__c = event.summary;
                stageEvent.image__c = event.image;
                stageEvent.lng__c = event.lng;
                stageEvent.lat__c = event.lat;
                stageEvent.date_ini__c = Datetime.valueOf(event.date_ini);
                stageEvent.date_end__c = Datetime.valueOf(event.date_end);
                stageEvent.created_at__c = Datetime.valueOf(event.created_at);
                stageEvent.campus_name__c= event.campus_name;

                stageEvents.add(stageEvent);
            }   
            System.debug('stage Events:' + stageEvents);
            //upsert into Stage_Event__c matching on SymposiumId__c
            try {
                upsert stageEvents SymposiumId__c;  
            } catch (DmlException e) {
                System.debug(e.getMessage());
            }
            
        }
    }  
    public class Events {
        public String url;
        public String type_route;
        public String type_name;
        public Integer type_id;
        public String title;
        public String timezone;
        public List<Tags> tags;
        public String summary;
        public String registration_url;
        public String place;
        public Integer owner;
        public Integer opening_date;
        public String lng;
        public String lat;
        public Boolean is_private;
        public Integer id;
        public String description;
        public String date_ini;
        public String date_end;
        public String country_name;
        public Integer closing_date;
        public String city_name;
        public List<Categories> categories;
        public String image;
        public String created_at;
        public String campus_name;
        public Integer created_at_timestamp;
    }
    
    public class Tags {
        public Integer code;
        public String name;
        public Integer partner; 
    }           
    public class Categories {
        public Integer partner;
        public String name;
        public Integer code;
    }   
    
    public class Event_types_found {
        public String name;
        public Integer id;
    }
    
    public class Event_categories_found {
        public Integer partner_id;
        public String name;
        public String id;
    }
    public class ResultSet{ 
        public Integer total;
        public Integer status;
        public List<Events> events;
        public List<Event_types_found> event_types_found;
        public List<Event_categories_found> event_categories_found;
    }
}