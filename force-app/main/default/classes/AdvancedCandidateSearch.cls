public with sharing class AdvancedCandidateSearch
{
    public List<Candidate__c> candidates {  
        get;
        set;
    }  
    public List<Boolean> checkbox{get;set;}
    public String field { get; set; }
    public Integer indexCities {get;set;}
    public String[] cities;
    public Integer minAge {get
    {
        return minAge;
    }
    set;}
    public Integer maxAge {get{
        return maxAge;
    }set;}

    public AdvancedCandidateSearch()
    {
        candidates = new List<Candidate__c>();
        cities = new String[]{'Bangalore','Hyderabad','Chennai','Noida'};
    }

    public String[] getCities() {
        return cities;
    }
    public String[] getSkills() {
        return new String[]{'Java','C++','Python','Salesforce','FullStack Development','Machine Learning'};
    }

    public PageReference searchCandidatesByName()
    {
        String qu = 'select Id,Name,City__c,First_Name__c,Last_Name__c from Candidate__c where First_Name__c =: field and Years_of_Experience__c >= :minAge and Years_of_Experience__c <= :maxAge';
        
        qu += 'and City__c = :cities[:indexCities]';
        System.debug(qu);
        //candidates = Database.query(qu);
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