global class EmailToCandidates implements Database.Batchable<sObject> {
    
    global database.querylocator start(Database.BatchableContext BC) {
        System.debug('Inside Start method');
        return Database.getQueryLocator([Select Candidate__r.Id,Candidate__r.First_Name__c,Candidate__r.Email__c from Job_Application__c where DayBeforeJoin__c < 3]);
    }
   
    global void execute(Database.BatchableContext BC,List<Job_Application__c> jobObjList) {
        List<Messaging.SingleEmailMessage> lstEmails = new List<Messaging.SingleEmailMessage>();
        for(Job_Application__c jobobj :(List<Job_Application__c>) jobObjList) {
            Messaging.SingleEmailMessage objEmail = Messaging.renderStoredEmailTemplate('00X5g000000tXpj',null,null);
            
            //Prepare SendToEmail List          
            List<String> lstSendToEmails = new List<String>();
            if(jobobj.Candidate__r.Email__c != null) {
                lstSendToEmails.add(jobobj.Candidate__r.Email__c);
            }
            objEmail.setToAddresses(lstSendToEmails);
            
            //Prepare CCEmailList
            List<String> lstCCToEmails = new List<String>();
            if(jobobj.Candidate__r.Email__c != null) {
                lstCCToEmails.add(jobobj.Candidate__r.Email__c);
            }
            objEmail.setCcAddresses(lstCCToEmails);
            
            // Set From Email Address
            OrgWideEmailAddress owea = new OrgWideEmailAddress();
                owea = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName='noreply@qualcomm.com'];
            if(owea != null){
                objEmail.setOrgWideEmailAddressId(owea.id);
            }
            	
            System.debug('Inside for Loop');
            lstEmails.add(objEmail);
        }
        if(!Test.isRunningTest()) {
            Messaging.SendEmailResult[] results = Messaging.sendEmail(lstEmails);
            // To Check whether Email is sent or not,We update processed field of each Job_Application.
            if(results[0].success) {
                List<Job_Application__c> lstJobToUpdate = new List<Job_Application__c>();
                for(Job_Application__c jobobj :(List<Job_Application__c>) jobObjList) {
                    //Candobj.Processed__c = true;
                    lstJobToUpdate.add(jobobj);
                }
                update lstJobToUpdate ;
                System.debug('Successfully Sent the message');
            }
        }
    }
    global void finish(Database.BatchableContext BC) {
   
    }
}