({  
    captureSelectedChevron : function (component, event, helper) {
        var stepName = event.getParam("detail").value;
        console.log(stepName);
        var action = component.get("c.updateStatus");
        action.setParams({
            JobAppStatus:stepName, 
            recordId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                console.log("Success");
                var toastEvent = $A.get("e.force:showToast");
                if (state === 'SUCCESS'){
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": " Status is Update Succesfully !."
                    });
                }
                toastEvent.fire();
                $A.get('e.force:refreshView').fire();
                
            }
        });
        $A.enqueueAction(action);
    }
})