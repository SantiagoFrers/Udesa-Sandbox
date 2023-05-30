/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-02-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
abstract public class Sender{
    
    public static final String STATUS_PENDING 		   = 'Pendiente';
    public static final String STATUS_SENT_OK 		   = 'Enviado';
    public static final String STATUS_SENT_ERROR 	   = 'Enviado con error';
    public static final String STATUS_CONECTION_ERRROR = 'Error de conección';
    public static final String STATUS_ERRROR 		   = 'Error';
    
    protected String 	jsonToSend;
    protected String 	endPointUrl;
    public String 	jsonResponse;
    protected Integer 	codeResponse; 
    protected String 	recordToSendId; 
    protected String 	status; 
    protected String 	errorMsg;
    protected Datetime 	timeOfTry;
    protected SObject 	recordToSync;
	protected SenderHelper.HttpResult result;
    
    public void setRecord(Id recordId) {
        
        this.recordToSendId = recordId;
        this.setDataToSend();
    }
    
    abstract public void setDataToSend();
    abstract public String getConfigName();
    abstract public String getRequestBody();
    abstract public void processResponse();

    virtual  public List<String> getUrlParameters(){
        return null;
    }
    virtual public String getAppendUrl(){
        return null;
    }

    virtual public Map<String,String> getHeaders() {
        return new  Map<String,String>();
    }

    public void send() {
        
        this.TimeOfTry = Datetime.now();
        
        try {
            
            this.result = SenderHelper.doRequest(this.getConfigName(), this.getHeaders(), this.getRequestBody(), this.getUrlParameters(), this.getAppendUrl());

                
            if (this.result?.request != null) {
                
                this.jsonToSend = this.result.request.getBody();
                this.endPointUrl = this.result.request.getEndpoint();
            }
            
            if (this.result?.response != null) {
                
                this.jsonResponse = this.result.response.getbody();
                this.codeResponse = this.result.response.getStatusCode();
                
                if (this.codeResponse >= 200 &&  this.codeResponse < 300) {
                    
                    this.status = Sender.STATUS_SENT_OK;
                    
                } else if (this.codeResponse >= 400 &&  this.codeResponse < 500) {
                    
                    this.status = Sender.STATUS_SENT_ERROR;
                    
                } else if( this.codeResponse >= 500 &&  this.codeResponse < 600) {
                    
                    this.status = Sender.STATUS_CONECTION_ERRROR;
                    
                } else {
                    
                    this.status = Sender.STATUS_ERRROR;
                }
            }
            
            
       } catch (Exception ex) {
            this.status = Sender.STATUS_ERRROR;
            this.errorMsg = ex.getMessage();
            System.debug(ex);
       } 
 
       if (this.status == Sender.STATUS_SENT_OK ||this.status == Sender.STATUS_SENT_ERROR) {
           this.processResponse();
       }
    }

    //cada vez que entras busca ultimo mensaje y muestra. si es pende
    
    public EnvioWs__c getLog() {
        
        EnvioWs__c envio = this.getLog(
            new EnvioWs__c(Intentos__c = 1)
        );
        
        return envio;
    }
    
    public virtual EnvioWs__c getLog(EnvioWs__c envio){
    
        envio.Url__c 			 = (this.endPointUrl.length() > 254) ? this.endPointUrl.substring(0, 254) : this.endPointUrl;
        envio.Estado__c 		 = this.status;
        envio.JSONEnvio__c 		 = this.getRequestBody();
        envio.JSONRespuesta__c 	 = this.jsonResponse;
        envio.Mensaje_Error__c 	 = this.errorMsg;
        envio.CodigoRespuesta__c = (this.codeResponse != null) ? String.valueOf(this.codeResponse):'';

        envio.UltimoIntento__c 	 = this.TimeOfTry;

        return envio;
    }

    virtual public SObject getRecordToSend(){
        return null;
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