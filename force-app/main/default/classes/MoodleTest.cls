/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-02-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public with sharing class MoodleTest {
    
    @isTest
    public static void pass() {

        SenderInscriptionMoodle.pass();
        SenderEnrolUser.pass();
        SenderUserMoodle.pass();
        SenderGetUserMoodle.pass();
        MoodleManager.pass();
        SenderManager.pass();
        CourseMoodleController.pass();
        SenderEnqueueable.pass();
        SenderCourseMoodle.pass();
        SenderHelper.pass();
        CursoMoodleInvocable.pass();
        Sender.pass();


    }
}