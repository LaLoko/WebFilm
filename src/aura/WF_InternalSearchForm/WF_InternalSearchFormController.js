({
    getActorsAndMovies : function(component, event, helper){
        let ac1 = component.getEvent('WF_ShowMovieDetail');
        ac1.setParams({
                      "showMovieDetail": false,
                               "movie": null
        });
        ac1.fire();
        let ac2 = component.getEvent('WF_ShowActorDetail');
        ac2.setParams({
                               "showActorDetail": false,
                                   "actor": null
        });
        ac2.fire();
        helper.getActorsAndMovies(component);
    },
    showFavourites : function(component,event,helper){
                let ac1 = component.getEvent('WF_ShowMovieDetail');
                ac1.setParams({
                              "showMovieDetail": false,
                                       "movie": null
                });
                ac1.fire();
                let ac2 = component.getEvent('WF_ShowActorDetail');
                ac2.setParams({
                                       "showActorDetail": false,
                                           "actor": null
                });
                ac2.fire();
               helper.showFavourites(component);
    },
    showBlacklist : function(component,event,helper){
                let ac1 = component.getEvent('WF_ShowMovieDetail');
                ac1.setParams({
                              "showMovieDetail": false,
                                       "movie": null
                });
                ac1.fire();
                let ac2 = component.getEvent('WF_ShowActorDetail');
                ac2.setParams({
                                       "showActorDetail": false,
                                           "actor": null
                });
                ac2.fire();
        helper.showBlacklist(component);
        },


    clear: function(component, event, handler){
        component.set("v.searchItem",'');

        let evt = component.getEvent("WF_GetMoviesAndActors");
        evt.setParams({
            movieList: [],
            actorList: [],
            favourites: [],
            blackList: [],
            showFav: false,
            showBlacklist: false
        });
        evt.fire();

        let showMovieEvt = component.getEvent("WF_ShowMovieDetail");
                showMovieEvt.setParams({
                    movie: null,
                    showMovieDetail: false,
                });
                showMovieEvt.fire();

                        let showActEvt = component.getEvent("WF_ShowActorDetail");
                                showActEvt.setParams({
                                    "showActorDetail": false,
                                    "actor": null
                                });
                                showActEvt.fire();
    },
    onInit : function(component,event,helper){
        let change = component.get("v.somethingChanged");
        let favChanged = component.get('v.favChanged');
        let blackChanged = component.get('v.blackChanged');
        console.log("mamy wczytywanko")
        console.log(change)
                console.log(favChanged)
        console.log(blackChanged)

        if(change = true){
         if(favChanged){
             helper.showFavourites(component);
         }else if(blackChanged){
             helper.showBlacklist(component);
         }else{
                     helper.getActorsAndMovies(component);

         }
                         let changeEvent = component.getEvent("WF_FavOrBlackChanged");
                                              changeEvent.setParams({
                                                 isChanged: false,
                                                 favChanged: false,
                                                 blackChanged: false
                                              });
                                              changeEvent.fire();
        }
    }
})