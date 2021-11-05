({
        onInit : function(component,event,helper){
            let action = component.get("c.getUserFilms");

                    action.setCallback(this, function(response){
                        let state = response.getState();
                        if (state === "SUCCESS"){
                            component.set('v.userFilms',response.getReturnValue());
                        }
                    });
                     $A.enqueueAction(action);
        }
})