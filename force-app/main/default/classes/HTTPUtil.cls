public with sharing class HTTPUtil {



    public static HttpResponse doRequest(String configName, Map<String,String> headers, String requestBody, List<String> urlParameters, String appendUrl){
       
        RestConfiguration__mdt endpointConfig = [SELECT id, developerName, Endpoint__c, Timeout__c, User__c, Password__c,
                                                    ContentType__c, Method__c, Authorization__c  FROM RestConfiguration__mdt WHERE developerName=:configName];        
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
	
        request.setMethod(endpointConfig.Method__c);
        request.setTimeout(Integer.valueOf(endpointConfig.Timeout__c));
        
        if(headers == null) headers = new Map<String,String>();

        //headers.put('enctype', 'multipart/form-data');
        headers.put('username', endpointConfig.User__c);
        headers.put('password', endpointConfig.Password__c);
        headers.put('Content-Type', endpointConfig.ContentType__c);   

        if(endpointConfig.Authorization__c != null){
            headers.put('Authorization', endpointConfig.Authorization__c);
        }else {
            Blob headerValue = Blob.valueOf(endpointConfig.User__c + ':' +  endpointConfig.Password__c);
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);   
            headers.put('Authorization', authorizationHeader);
        }
            
        if(headers != null && !headers.isEmpty()){         
            for(String key : headers.keySet()){
                system.debug('Header: ' + key + ' : ' + headers.get(key));
                request.setHeader(key, headers.get(key));
            }
        }
        
        String endpoint = endpointConfig.Endpoint__c;

        if (urlParameters != null) endpoint = String.format(endpointConfig.Endpoint__c, urlParameters);
        if (appendUrl != null) endpoint = endpoint + appendUrl;
        system.debug('Endpoint: ' + endpoint);
        request.setEndpoint(endpoint);
                
        system.debug('Body: ' + requestBody);
        //requestBody = requestBody.replace('/', '');
        if (requestBody != null) request.setBody(requestBody);
        
        HttpResponse response = http.send(request);
          system.debug('response: ' + response);
          system.debug('bodyresponse: ' + response.getbody());
        return response;
    }

}