({
    doInit : function(component,event,helper){
    	var action = component.get("c.getCandRecords");
        action.setParams({
            recordId : component.get("v.recordId") 
        });
        action.setCallback(this,function(response){
           	var state = response.getState();
            if(state == "SUCCESS"){
                var returnVal = response.getReturnValue();
				var date1 = new Date(returnVal.Joining_Date__c);
                var date2 = new Date(returnVal.DateOfSelection__c);
                var totalDays = Math.ceil((date1.getTime() - date2.getTime()) /(1000*3600*24));
                component.set("v.candRecord",returnVal);
                if(returnVal.DayBeforeJoin__c != null && returnVal.DayBeforeJoin__c > 0){
					component.set("v.joining",returnVal.DayBeforeJoin__c); 
                    component.set("v.dateOfJoining",totalDays);
                }
                var grow = component.find("grow");
                var joining = component.get("v.joining");
         
                if(joining === undefined){
                    $A.util.addClass(grow,"slds-hide");
                }
            }
        });
        $A.enqueueAction(action);	
        
    },
    
    captureJoiningDateEvent : function(component,event,helper){
        var joinDate = event.getParam("joining");
        var doj = event.getParam("doj");
        component.set("v.joining",joinDate);
        component.set("v.dateOfJoining",doj);
    }
    
})