public class SyncSymposiumEventsQueueable implements Queueable, Database.AllowsCallouts {
    public void execute(QueueableContext context) {
       SyncSymposiumEvents.SyncEvents();
    }
}