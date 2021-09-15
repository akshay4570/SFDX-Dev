public with sharing class CandidateSearch
{
    public ApexPages.StandardSetController controller{get; set;} 
    public List<Candidate__c> candidates {  
        get;
        set;
    }  
    public String field { get; set; }

    public CandidateSearch()
    {
        candidates = new List<Candidate__c>();
    }


    public PageReference searchCandidatesByName()
    {
        candidates = [select Id,Name,City__c,First_Name__c,Last_Name__c
                 from Candidate__c where First_Name__c =: field];
        if(candidates.size() == 0)
        {
           PageReference pg = new PageReference('https://cunning-shark-efdyl2-dev-ed--c.visualforce.com/apex/NoRecordsFound');
            return pg; 
        }
        return null;
    }
    public PageReference searchCandidatesByExperience()
    {
        try{
            candidates = [select Id,Name,City__c,First_Name__c,Last_Name__c
                     from Candidate__c where Years_of_Experience__c =: Integer.valueOf(field)];
        }catch(Exception e){
            PageReference pg = new PageReference('https://cunning-shark-efdyl2-dev-ed--c.visualforce.com/apex/ErrorReferencing');
            return pg;
        }
        
        return null;
    }
    public PageReference searchCandidatesBySkills()
    {
        candidates = [select Id,Name,City__c,First_Name__c,Last_Name__c
                 from Candidate__c where Skills__c includes (:field)];
        if(candidates.size() == 0)
        {
           PageReference pg = new PageReference('https://cunning-shark-efdyl2-dev-ed--c.visualforce.com/apex/NoRecordsFound');
            return pg; 
        }
        return null;
    }
    
    
    public PageReference sortCandidatesByName()
    {
        for(Integer i=0;i<candidates.size();i++)
            for(Integer j=i+1;j<candidates.size();j++)
                if(candidates[i].First_Name__c > candidates[j].First_Name__c){
                    Candidate__c temp = candidates[i];
                    candidates[i] = candidates[j];
                    candidates[j] = temp;
                }

        return null;
    }
}