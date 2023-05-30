@isTest
global class SyncSymposiumEventsHttpCalloutMock implements HttpCalloutMock {	
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{ "total" : 1, "status" : 1, "events" : [ { "url" : "", "type_route" : "jornadas", "type_name" : "Jornadas", "type_id" : 5, "title" : "TEST", "timezone" : "", "tags" : [ ], "summary" : "test...", "registration_url" : "", "place" : "Murcia", "owner" : 14147, "opening_date" : 1570518000, "lng" : "-1.1306544542313", "lat" : "37.992240905762", "is_private" : false, "id" : 1769, "description" : " Descripción", "date_ini" : "2019-10-08 09:00:00", "date_end" : "2019-12-31 14:00:00", "country_name" : "España", "closing_date" : 1577797200, "created_at" : "2019-12-31 14:00:0", "city_name" : "Murcia", "categories" : [ { "partner" : 1001, "name" : "Comunicación y audiovisual", "code" : 4 }, { "partner" : 1001, "name" : "Producción audiovisual", "code" : 68 } ] }] }');
        response.setStatusCode(200);
        return response; 
}
}