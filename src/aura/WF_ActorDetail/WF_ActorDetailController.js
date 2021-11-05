({
        closeActorDetailModal : function(component, event, handler){
                let modalEvent = component.getEvent("WF_ShowActorDetail");
                           modalEvent.setParams({
                          "showActorDetail": false,
                          "actor": null
                         });
                 modalEvent.fire();
                 },
                     doInit: function(component,event,helper){
                         helper.onInit(component);
                         let resetMovie = component.getEvent("WF_ShowMovieDetail");
                                     resetMovie.setParams({
                                         "showMovieDetail": false
                                     });
                                     resetMovie.fire();
                     }
})