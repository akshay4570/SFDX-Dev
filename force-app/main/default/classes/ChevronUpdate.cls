// Performing the upsert operation on Chevron so that the click on Chevron automatically gets reflected in the DB and
// vice-versa

public class ChevronUpdate {
	@AuraEnabled	
    public static void updateStatus(String JobAppStatus , String recordId){
        Job_Application__c jobApplicationObj = [Select Id ,Status__c from Job_Application__c where Id=:recordId] ; 
        jobApplicationObj.Status__c = JobAppStatus ; 
        upsert jobApplicationObj ;
        
    }
}