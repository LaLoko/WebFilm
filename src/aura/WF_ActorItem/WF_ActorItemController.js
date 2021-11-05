({
        openActorModal : function(component, event, handler){
                   let modalEvent = component.getEvent("WF_ShowActorDetail");
                   modalEvent.setParams({
                       "showActorDetail": true,
                       "actor": component.get("v.actor")
                   });
                   modalEvent.fire();
        }
})