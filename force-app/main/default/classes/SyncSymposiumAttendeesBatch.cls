/**
 * Created by joaquin on 13/07/2020.
 *
 * Because Symposium doesn't allow to retrieve more than 100 atendees per call. We are iterating through a fake "Pages"
 * list to get all.
 */

public class SyncSymposiumAttendeesBatch implements Database.Batchable<Integer>, Database.Stateful, Database.AllowsCallouts
{
    public Campaign cmp{get;set;}
    private Boolean stopExecution{get;set;}
    public List<Integer> start(Database.BatchableContext BC)
    {
        List<Integer> pages = new list<Integer>{1};
        if(!Test.isRunningTest()) {
            pages = new list<Integer>{
                    1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143,144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243,144, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 281, 282, 283, 284, 285, 286, 287, 288, 289, 290, 291, 292, 293, 294, 295, 296, 297, 298, 299
            };
        }
        stopExecution = false;
        return pages;

    }

    public void execute(Database.BatchableContext BC, List<Integer> scope)
    {
        if(!stopExecution) {
            List<Stage_Event_Attendees__c> atendees = new List<Stage_Event_Attendees__c>();
            for (Integer i : scope) {
                List<Stage_Event_Attendees__c> atendeesinner =
                        SyncSymposiumAttendees.SyncAttendees(cmp,i);
                //if Atendees is less than a 100 that means we have no more pages so we can stop the execution
                atendees.addAll(atendeesinner);
                if (atendeesinner.size() < 100) {
                    stopExecution = true;
                    break;
                }
            }

            try {
                upsert atendees attending_id__c;
                System.debug(atendees.size());
            } catch (DmlException e) {
                System.debug(e.getMessage());
            }
        }

    }

    public void finish(Database.BatchableContext BC){}



}