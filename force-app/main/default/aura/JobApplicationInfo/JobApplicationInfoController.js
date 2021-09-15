({
	captureJoiningDate : function(component, event, helper) {
        var appEvent = $A.get("e.c:FireGrowChart");
        var eventFields = event.getParam("fields");
        var joinDate = new Date(eventFields["Joining_Date__c"]);
        var presentDate = new Date();
        
        var differenceInTime = joinDate.getTime() - presentDate.getTime();
        var days = differenceInTime / (1000*3600*24);
        days = Math.ceil(days);
        if(days < 0)
            days = 0;
        appEvent.setParams({
            joining : days,
            doj : days
        });
        appEvent.fire();
	}
})