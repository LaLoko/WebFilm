({
            onInit : function(component){
                const spinner = component.find("spinner");

                        spinner.showSpinner();
                                        let action = component.get("c.getActorDetails");
                                        action.setParams({
                                            actorWrapper: component.get("v.actor")
                                        });
                                        action.setCallback(this, function(response){
                                            let state = response.getState();
                                            if (state === "SUCCESS"){
                                                component.set("v.actor",response.getReturnValue())
                                            }
                                                            spinner.hideSpinner();

                                        });
                                $A.enqueueAction(action);

            }
})