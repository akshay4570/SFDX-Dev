public with sharing class LWCApex {
    public LWCApex() {

    }

    @AuraEnabled(cacheable = true)
    public static List<Candidate__c> getCandidateList(){
        return [Select Id, Email__c from Candidate__c Limit 10];
    }
}