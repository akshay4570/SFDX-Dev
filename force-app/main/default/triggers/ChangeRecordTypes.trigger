// A trigger for basically changing the Record type Dynamically and by querying the RecordType for automation of 
// chevron items

trigger ChangeRecordTypes on Job_Application__c (before insert,before update) {    
    if(Trigger.isInsert){
        for (Job_Application__c cc : trigger.new){
            recordtype rectype = [select id, DeveloperName from RecordType where id='0125g000000Q9VKAA0'];
            cc.RecordTypeid = rectype.id;
        }
    }
    
    if(Trigger.isUpdate){
        Map< String,Id> typeMap = New Map< String,Id>();
        for(RecordType rt: [Select DeveloperName, Id From RecordType Where sObjectType = 'Job_Application__c']) {
             typeMap.put(rt.DeveloperName,rt.Id);
        }
        for (Job_Application__c cc : trigger.new)  {
            if(cc.Status__c != Trigger.oldMap.get(cc.Id).Status__c){
                String statusVal = cc.Status__c;
                if(statusVal == 'No show'){
                    statusVal = statusVal.left(2) + '_' + statusVal.right(4);
                }
                if(statusVal == 'Screening in progress'){
                    statusVal = 'New';
                }
                Id recid = typeMap.get(statusVal);
                recordtype rectype = [select id, DeveloperName from RecordType where id=:recid];
                cc.RecordTypeid = rectype.id;
                }   
           }
        }
}