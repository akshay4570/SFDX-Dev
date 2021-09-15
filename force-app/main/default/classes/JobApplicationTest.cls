// Test classes for JobApplication, EmailToCandidates, PositionController, ChangeRecordTypes and has
// a code coverage of more than 75% in each case

@isTest
public class JobApplicationTest {
	
    @isTest 
    static void TestforJobApplication(){
        Candidate__c cand = new Candidate__c(First_Name__c = 'Manohar');
        cand.Skills__c = 'C++;Java';
        
        insert cand;
        
        Position__c pos = new Position__c(Name='Testing');
        insert pos;
        
        System.debug('Candidate ID '+cand.Id);
        System.debug('Position ID '+pos.Id);
        Job_Application__c jobApp = new Job_Application__c(Candidate__c = cand.Id,Position__c = pos.Id,Status__c = 
                                                          'New');
        
        insert jobApp;		
        
    }
    
    @isTest
    static void TestforPositionController(){
        Position__c pos = new Position__c(Name='TestingController');
        insert pos;
        
        ApexPages.StandardController sc = new ApexPages.standardController(pos);
        
        PositionController controller = new PositionController(sc);
        
        controller.searchForCandidate();
    }
    
    @isTest(seeAllData = True)
    static void TestforChangeRecordTypes(){
        Job_Application__c jobObj = [Select Id,Candidate__c,Position__c,Status__c from Job_Application__c where Id = 'a025g000002apqTAAQ'];
        
        System.debug('Job Application '+jobObj);
        String statusVal = 'No show';
        jobObj.Status__c = statusVal;
        
        update jobObj;
        
        Job_Application__c jobObj1 = [Select Id,Candidate__c,Position__c,Status__c from Job_Application__c where Id = 'a025g000002apqTAAQ'];
        System.assertEquals('No show', jobObj1.Status__c, 'Error with Updating Values');
    }
    
    @isTest(seeAllData = True)
    static void TestEmailToCandidates(){
        Candidate__c cand = new Candidate__c(First_Name__c = 'BatchTesting',Email__c = 'akshaysu@qti.qualcomm.com');
        cand.Skills__c = 'C++;Java';
        
        insert cand;
        
        Position__c pos = new Position__c(Name='BatchTesting');
        insert pos;
        

        Job_Application__c jobApp = new Job_Application__c(Candidate__c = cand.Id,Position__c = pos.Id,Status__c = 
                                                          'New',Joining_Date__c = Date.newInstance(2021, 4, 26));
        
        insert jobApp;		
        
        Test.StartTest();
        
        Id batchprocessid = Database.executeBatch(new EmailToCandidates());
        
        Test.StopTest();
        
        List<Job_Application__c> jobTestList = [Select Candidate__r.Id,Candidate__r.First_Name__c,Candidate__r.Email__c from Job_Application__c where DayBeforeJoin__c < 2];
        for(Job_Application__c jobVal : jobTestList){
            System.assertNotEquals(null, jobVal.Candidate__r.Email__c, 'Email should not be Null');
        }
    }
    
}