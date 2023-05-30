@isTest
global class SyncSymposiumAttendeesHttpCalloutMock implements HttpCalloutMock {	
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"total":1,"attendees":[{"attending_id":11111,"user_id":14176,"manager":null,"username":"test@udesa.es","email":"test@udesa.es","name":"test","visibility":"public","status":"confirm","event_id":1769,"registration_form_submitted":false,"created":"2019-10-14 11:30:06","invoice_id":48696,"created_timestamp":1571045406,"ticket":{"id":1168,"name":"entrada de pago","price":10,"currency":"EUR"}},{"attending_id":30671,"user_id":14177,"manager":null,"username":"anfagsd@agsdsadas.es","email":"anfagsd@agsdsadas.es","name":"Nasdasfsafas Ifghfgnhgh","visibility":"public","status":"confirm","event_id":1769,"registration_form_submitted":false,"created":"2019-10-14 13:21:49","invoice_id":48697,"created_timestamp":1571052109,"ticket":{"id":1168,"name":"entrada de pago","price":10,"currency":"EUR"}}]}}');
        response.setStatusCode(200);
        return response; 
}
}