// Search for a particular position and pass it on to the next VF page to select the Candidate best fit for that
// position
public class PositionController {

     public ApexPages.StandardController stdCntrlr {get; set;}
     public PositionController(ApexPages.StandardController controller) {
         stdCntrlr = controller;
         jobObj = new Job_Application__c();
         System.debug('Inside Constructor Function');
     }
    public Job_Application__c jobObj{
        get{
            System.debug('Inside Getter Function');
            return jobObj;
        }
        set;
    }

    
    public PageReference searchForCandidate(){
        PageReference pageRef = Page.candidatePruning;
        pageRef.getParameters().put('posId',jobObj.Position__c);
        return PageRef;
    }
}