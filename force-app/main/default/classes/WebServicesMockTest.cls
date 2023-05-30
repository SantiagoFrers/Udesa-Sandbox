@isTest
global class WebServicesMockTest implements HttpCalloutMock {

    global Boolean error {get;set;}
   
    global HTTPResponse respond(HTTPRequest req) {

        HttpResponse res = new HttpResponse();
        
        if(error == null || !error){
            res.setStatusCode(200);    
        }else {
            res.setStatusCode(401);
        }
    
        return res;
    }


}