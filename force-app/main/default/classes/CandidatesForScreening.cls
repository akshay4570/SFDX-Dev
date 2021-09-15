public class CandidatesForScreening{
        public Boolean candidateSelect{get;set;}
        public Candidate__c cand{get;set;}
        
        CandidatesForScreening(Candidate__c candTemp){
            this.candidateSelect = false;
            this.cand = candTemp;
        }
    }