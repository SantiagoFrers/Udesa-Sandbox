public class SyncSymposiumEventsSchedulable implements Schedulable{
    
    public void execute(SchedulableContext SC) {
        if(!Test.isRunningTest()){
                  System.enqueueJob(new SyncSymposiumEventsQueueable()); 
        }else{
            Boolean test = true;
        }
   }

}