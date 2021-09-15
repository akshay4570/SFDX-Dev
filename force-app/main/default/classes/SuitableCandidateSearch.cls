public with sharing class SuitableCandidateSearch
{
    // Set of Variables to Capture the field
    public List<Candidate__c> candidates {get;set;}   
    public Integer cnt{get;set;}    
    public String candidateName { get; set; }
    public Id posField {get; set;}
    public Position__c posApplied {get;set;}
    public String[] cities;
    public Integer minAge {get;set;}
    public Integer maxAge {get;set;}
    public List<SkillWrapper> skillWrapList{get;set;}
    public List<CityWrapper> cityWrapList{get;set;}
    public List<CandidatesForScreening> screeningWrapList{get;set;}
    Map<Id, CandidatesForScreening> mapHoldingSelectedRecords{get;set;}
    public ApexPages.StandardSetController stCon{
     get{
         if(stCon == null){
            stCon = new ApexPages.StandardSetController(candidates);    
            stCon.setPageSize(10);   
         }
        return stCon;
     }
     set;
    }
    
    // Constructor
    public SuitableCandidateSearch()
    {
        System.debug('Inside Constructor');
        cnt = 1;
        minAge = 0;
        maxAge = 30;
        posField = System.currentPagereference().getParameters().get('posId');
        posApplied = [Select Name from Position__c where id =: posField][0];
        candidates = new List<Candidate__c>();
        mapHoldingSelectedRecords = new Map<Id,CandidatesForScreening>();
        init();
        
        cities = new String[]{'Bangalore','Hyderabad','Chennai','Noida'};
        Schema.SObjectType s = Schema.getGlobalDescribe().get('Candidate__c');
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String,Schema.SObjectField> fields = r.fields.getMap();

        Schema.DescribeFieldResult fieldResult = fields.get('Skills__c').getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        skillWrapList = new List<skillWrapper>();
        for( Schema.PicklistEntry pickListVal : ple){
            System.debug(pickListVal.getLabel() +' '+pickListVal.getValue());
            SkillWrapper skllwrapper = new SkillWrapper(pickListVal.getLabel());
            skillWrapList.add(skllwrapper);
        }    
        cityWrapList = new List<CityWrapper>();
        for(String cty : cities){
            CityWrapper ctywrap = new CityWrapper(cty);
            cityWrapList.add(ctywrap);
        }
    }

    public void init() {
     System.debug('Inside Init Method');
     screeningWrapList = new List<CandidatesForScreening>();
     for (Candidate__c candidateRecord : (List<Candidate__c>)stCon.getRecords()) {
         if(mapHoldingSelectedRecords != null && mapHoldingSelectedRecords.containsKey(candidateRecord.id)){
            screeningWrapList.add(mapHoldingSelectedRecords.get(candidateRecord.id));
         }
         else{
           screeningWrapList.add(new CandidatesForScreening(candidateRecord, false));
         }
     }
 }

    // A Function which fires when the Search Button is Clicked
    public PageReference searchCandidatesByName()
    {
        try{
            Boolean keepCheck = false;
            String queryForCandidate = 'select Id,Name,City__c,First_Name__c,Last_Name__c from Candidate__c ';
            if(candidateName != ''){
                System.debug(candidateName);
                queryForCandidate += 'where First_Name__c = :candidateName ';
                keepCheck = true;
            }   
            if(minAge != null && keepCheck)
                queryForCandidate += 'and Years_of_Experience__c >= :minAge ';
            else if(minAge != null){
                queryForCandidate += 'where Years_of_Experience__c >= :minAge ';
                keepCheck = true;
            }
            if(maxAge != null && keepCheck)
                queryForCandidate += 'and Years_of_Experience__c <= :maxAge ';
            else if(maxAge != null){
                queryForCandidate += 'where Years_of_Experience__c <= :maxAge ';
                keepCheck = true;
            }
            Boolean checkOnce = true;
            for(CityWrapper cty : cityWrapList){
                if(cty.citySelect && checkOnce){
                    checkOnce = false;
                    String paramCity = cty.city;
                    if(!keepCheck){
                        keepCheck = true;
                        queryForCandidate += 'where (City__c = ' + '\''+paramCity+'\''+' ';
                    }
                    else
                        queryForCandidate += 'and (City__c = ' + '\''+paramCity+'\''+' ';
                }
                else if(cty.citySelect){
                    String paramCity = cty.city;
                    queryForCandidate += 'or City__c = ' + '\''+paramCity+'\''+' ';
                }
            }
            if(checkOnce == false){
                queryForCandidate += ') ';
            }
            Boolean hasSkill = false;
            String skillquery = '';
            for(SkillWrapper skll :skillWrapList){
                if(skll.selected){
                    hasSkill = true;
                    skillquery += '\''+skll.skill+'\''+',';
                }
            }
            if(hasSkill){
                if(keepCheck)
                    queryForCandidate += 'and Skills__c includes(' + skillquery.removeEnd(',') + ')';
                else{
                    queryForCandidate += 'where Skills__c includes(' + skillquery.removeEnd(',') + ')';
                    keepCheck = true;
                }
            }    
            System.debug('Debugging query of Strings = '+queryForCandidate);
            stCon = null;
            
            //To Avoid Redundancy of the same selected Candidates for a particular position
            List<Job_Application__c> jobObjList = [Select Candidate__c,Position__c from Job_Application__c];
            System.debug(jobObjList);
            candidates = Database.query(queryForCandidate);
            for(Job_Application__c jobIter : jobObjList){
                for(Integer i=0;i<candidates.size();i++){
                    if(jobIter.Candidate__c == candidates[i].Id && jobIter.Position__c == posField){
                        candidates.remove(i);
                        break;
                    }
                }
            }
            System.debug('Printing '+candidates);
            if(candidates.size() > 0)
                cnt = cnt + 1;
            else
                cnt = 0;
            init();
        }catch(Exception e){
            PageReference pg = new PageReference('https://cunning-shark-efdyl2-dev-ed--c.visualforce.com/apex/ErrorLoading?core.apexpages.request.devconsole=1  ');
            return pg; 
        }
        return null;
    }
    
    // A Function which fires whenever a Candidate is selected for Screening
    public PageReference selectForScreening(){
        updateSearchItemsMap();
        List<Job_Application__c> jobApplList = new List<Job_Application__c>();
        for(CandidatesForScreening candScreen: mapHoldingSelectedRecords.values()){
            if(candScreen.isSelected){
                Job_Application__c jobApplObj = new Job_Application__c(Candidate__c = candScreen.candRecord.id,
                                                                  Position__c = [Select Name from Position__c where id =: posField].id);
                jobApplList.add(jobApplObj);
            }
        }
        try{
            insert jobApplList;
        }
        catch(Exception e){
            System.debug('Error in pushing records to the database...');
        }
        return new PageReference('https://cunning-shark-efdyl2-dev-ed.my.salesforce.com/a02/o');
    }
    public Boolean hasNext {
       get {
             return stCon.getHasNext();
         }
      set;
    }

    public Boolean hasPrevious {
        get {
            return stCon.getHasPrevious();
        }
      set;
    }

    public Integer pageNumber {
        get {
            return stCon.getPageNumber();
        }
        set;
     }

    public void first() {
        updateSearchItemsMap();
        stCon.first();
        init();
    }
   
    public void last() {
        updateSearchItemsMap();
        stCon.last();
        init();
    }

    public void previous() {
        updateSearchItemsMap();
        stCon.previous();
        init();
    }
    
    public void next() {
        updateSearchItemsMap();
        stCon.next();
        init();
    }
  
    public void cancel() {
        stCon.cancel();
    }
    
    private void updateSearchItemsMap() {
        System.debug('Inside Update SearchItem Map');
         for(CandidatesForScreening wrp : screeningWrapList){
              if(wrp.isSelected){
                 
                 mapHoldingSelectedRecords.put(wrp.candRecord.id, wrp);
                 System.debug('Map Contents = '+wrp);
                 System.debug('Selected '+mapHoldingSelectedRecords);
              }
              if(wrp.isSelected == false && mapHoldingSelectedRecords.containsKey(wrp.candRecord.id)){
                 
                 mapHoldingSelectedRecords.remove(wrp.candRecord.id);
                 System.debug('Map Contents = '+wrp);
                 System.debug('Not Selected = '+mapHoldingSelectedRecords);
              }
         }
     }
    // Wrapper Class to Capture the Skills
    public class SkillWrapper{
        public Boolean selected{get;set;}
        public String skill{get;set;}
        
        public SkillWrapper(String skillstr){
            this.skill = skillstr;
            this.selected = false;
        }
    }
    
    // Wrapper Class to Capture the City
    public class CityWrapper{
        public Boolean citySelect{get;set;}
        public String city{get;set;}
        
        public CityWrapper(String citystr){
            this.citySelect = false;
            this.city = citystr;
        }
    }
    
    //Wrapper Class to Capture the Selected Candidates for Screening
    public class CandidatesForScreening{
        public Boolean isSelected{get;set;}
        public Candidate__c candRecord{get;set;}
        
        public CandidatesForScreening(Candidate__c candRecord,Boolean isSelected){
            this.isSelected = isSelected;
            this.candRecord = candRecord;
        }
    }
}