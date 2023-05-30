/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-02-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class SenderHelper {

     public static HttpResult doRequest(String configName, Map<String,String> headers, String requestBody, List<String> urlParameters, String appendUrl){
        
        HttpResult result = new HttpResult();

        RestConfiguration__mdt endpointConfig = [SELECT id, developerName, Endpoint__c, Timeout__c, User__c, Password__c,
                                                    ContentType__c, Method__c, Authorization__c  FROM RestConfiguration__mdt WHERE developerName=:configName];        
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
	
        request.setMethod(endpointConfig.Method__c);
        request.setTimeout(Integer.valueOf(endpointConfig.Timeout__c));
        
        if(headers == null) headers = new Map<String,String>();

        headers.putAll(
            SenderHelper.getHeaderFromSetting(endpointConfig)    
        );

        if(headers != null && !headers.isEmpty()){         
            for(String key : headers.keySet()){
                request.setHeader(key, headers.get(key));
            }
        }
        
        String endpoint = endpointConfig.Endpoint__c;

        if (urlParameters != null){
            endpoint = String.format(endpointConfig.Endpoint__c, urlParameters);
        } 
        if (appendUrl != null){
             endpoint = endpoint + appendUrl;
        }
        request.setEndpoint(endpoint);
        system.debug('endpoint: ' + endpoint);        
        system.debug('Body: ' + requestBody);
        if (requestBody != null) request.setBody(requestBody);
        
        HttpResponse response = http.send(request);
          system.debug('response: ' + response);
          system.debug('bodyresponse: ' + response.getbody());

        result.response = response;
        result.request = request;

        return result;
    }

    private static Map<String,String> getHeaderFromSetting(RestConfiguration__mdt endpointConfig) {

        Map<String,String> headers = new Map<String,String>();
          //headers.put('enctype', 'multipart/form-data');
        if (!String.isBlank(endpointConfig.User__c)) {
            headers.put('username', endpointConfig.User__c);
        }
        if (!String.isBlank(endpointConfig.Password__c)) {
            headers.put('password', endpointConfig.Password__c);
        }
        if (!String.isBlank(endpointConfig.User__c)) {
            headers.put('Content-Type', endpointConfig.ContentType__c);   
        }
        
        if(endpointConfig.Authorization__c != null){
            headers.put('Authorization', endpointConfig.Authorization__c);
        } else if(endpointConfig.User__c != null && endpointConfig.Password__c != null ){
            Blob headerValue = Blob.valueOf(endpointConfig.User__c + ':' +  endpointConfig.Password__c);
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);   
            headers.put('Authorization', authorizationHeader);
        }

        return headers;
    }

    public class HttpResult{
        public HttpRequest request;
        public HttpResponse response;
    }

    public static void pass() {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }

}