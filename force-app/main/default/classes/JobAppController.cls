// Return the Job_Application__c list of objects for a particular RecordID

public class JobAppController {
	@AuraEnabled
    public static Job_Application__c getCandRecords(Id recordId){
        Job_Application__c jobApplicationObject = [Select Candidate__r.Id,Candidate__r.First_Name__c,Candidate__r.Last_Name__c,Candidate__r.Email__c,Candidate__r.City__c,DayBeforeJoin__c,Joining_Date__c,DateofSelection__c from Job_Application__c where Id =: recordId];
        System.debug('Candidate = '+jobApplicationObject);
        return jobApplicationObject;
    }
}