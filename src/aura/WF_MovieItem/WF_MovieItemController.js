({
    openMovieDetail : function(component, event, handler){
               let modalEvent = component.getEvent("WF_ShowMovieDetail");
               console.log('movie item')
               console.log(component.get('v.fromFav'))
               console.log(component.get('v.fromBlack'))
               console.log(component.get('v.fromMain'))


               modalEvent.setParams({
                   "showMovieDetail": true,
                   "movie": component.get("v.movie"),
                   "fromMain": component.get('v.fromMain'),
                   "fromFav": component.get('v.fromFav'),
                   "fromBlack": component.get('v.fromBlack')
               });
               modalEvent.fire();
    }
})