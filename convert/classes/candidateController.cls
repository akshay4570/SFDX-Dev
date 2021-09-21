public with sharing class candidateController {
    public candidateController() {
        System.debug('Inside Constructor');
    }

    @AuraEnabled(cacheable=true)
    public static List<Candidate__c> getCandidatesList(String name){
        String key = '%'+name+'%';
        String query = 'Select Id, First_Name__c,Last_Name__c, Email__c from Candidate__c where First_Name__c like :key';
        return Database.query(query);
    }

}