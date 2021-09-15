global class JobRecruiter implements Database.Batchable<sObject> {
    global database.querylocator start(Database.BatchableContext BC) {
        System.debug('Inside Start method');
        return Database.getQueryLocator([Select Email from User where Profile.Name = 'System Administrator' or Profile.Name = 'HR Recruiter']);
    }
   
    global void execute(Database.BatchableContext BC, List<User> UserList) {
        List<Messaging.SingleEmailMessage> lstEmails = new List<Messaging.SingleEmailMessage>();
        for(User userobj :(List<User>) UserList) {
            Messaging.SingleEmailMessage objEmail = Messaging.renderStoredEmailTemplate('00X5g000000tYCG',null,null);
            
            //Prepare SendToEmail List          
            List<String> lstSendToEmails = new List<String>();
            if(userobj.Email != null) {
                lstSendToEmails.add(userobj.Email);
            }
            objEmail.setToAddresses(lstSendToEmails);
            
            //Prepare CCEmailList
            List<String> lstCCToEmails = new List<String>();
            if(userobj.Email != null) {
                lstCCToEmails.add(userobj.Email);
            }
            objEmail.setCcAddresses(lstCCToEmails);
            
            // Set From Email Address
            OrgWideEmailAddress owea = new OrgWideEmailAddress();
            owea = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName='noreply@qualcomm.com'];
            if(owea != null){
                objEmail.setOrgWideEmailAddressId(owea.id);
            }
            	
           //Set Email Template
           	//EmailTemplate template = [SELECT Id,Body,Subject,HtmlValue FROM EmailTemplate WHERE Id = '00X5g000000tYCG'];
            
            //Set Email Subject
            //objEmail.setSubject(template.Subject);
           
            //Set Email Body
            //objEmail.setHtmlBody(template.Body);
            lstEmails.add(objEmail);
        }
        if(!Test.isRunningTest()) {
            Messaging.SendEmailResult[] results = Messaging.sendEmail(lstEmails);
            // To Check whether Email is sent or not,We update processed field of each contact.
            if(results[0].success) {
                List<User> lstUserToUpdate = new List<User>();
                for(User userobj :(List<User>) UserList) {
                    lstUserToUpdate.add(userobj);
                }
                update lstUserToUpdate ;
                system.debug('lstUserToUpdate:'+lstUserToUpdate );
            }
        }
    }
    global void finish(Database.BatchableContext BC) {
   
    }
}