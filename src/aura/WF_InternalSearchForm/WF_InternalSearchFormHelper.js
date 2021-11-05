({
    getActorsAndMovies : function(component, event, handler){
            const spinner = component.find("spinner");

            spinner.showSpinner();
            let action = component.get("c.search");
            action.setParams({
                key: component.get("v.searchItem"),
                userFilms : component.get("v.userFilms")
            });
            action.setCallback(this, function(response){
                let state = response.getState();
                if (state === "SUCCESS"){


                    let event = component.getEvent("WF_GetMoviesAndActors");
                    event.setParams({
                           actorList: response.getReturnValue().actors,
                           movieList: response.getReturnValue().moviesWithoutBlacklist,
                           favourites: response.getReturnValue().favourites,
                           blackList: response.getReturnValue().blackList,
                           showFav: false,
                           showBlacklist: false,
                           searchKey: component.get("v.searchItem")
                    });
                    event.fire();

                    spinner.hideSpinner();
                }
            });
             $A.enqueueAction(action);

        },
            showFavourites : function(component,event){
                        const spinner = component.find("spinner");

                        spinner.showSpinner();
                        let action = component.get("c.search");
                        action.setParams({
                            key: component.get("v.searchItem"),
                            userFilms : component.get("v.userFilms")
                        });

                        action.setCallback(this, function(response){
                            let state = response.getState();
                            if (state === "SUCCESS"){
                                                       if(response.getReturnValue().favourites === undefined || response.getReturnValue().favourites.length == 0){
                                                                                    var toastEvent = $A.get("e.force:showToast");
                                                                                    toastEvent.setParams({
                                                                                            "title": "There is no favourites",
                                                                                            "message": "We cannot found any favourites films in your collection, try to add one."
                                                                                        });
                                                                                        toastEvent.fire();
                                                                                }else{
                                let event = component.getEvent("WF_GetMoviesAndActors");
                                event.setParams({
                                       actorList: response.getReturnValue().actors,
                                       movieList: response.getReturnValue().moviesWithoutBlacklist,
                                       favourites: response.getReturnValue().favourites,
                                       blackList: response.getReturnValue().blackList,
                                       showFav: true,
                                       showBlacklist: false
                                });

                                event.fire();
                                }
                                spinner.hideSpinner();
                            }
                        });
                         $A.enqueueAction(action);
            },
            showBlacklist : function(component,event){
                                const spinner = component.find("spinner");

                                spinner.showSpinner();
                                let action = component.get("c.search");
                                action.setParams({
                                    key: component.get("v.searchItem"),
                                    userFilms : component.get("v.userFilms")
                                });
                                action.setCallback(this, function(response){
                                    let state = response.getState();
                                    if (state === "SUCCESS"){
                                        if(response.getReturnValue().blackList === undefined || response.getReturnValue().blackList.length == 0){
                                           var toastEvent = $A.get("e.force:showToast");
                                               toastEvent.setParams({
                                                "title": "There is no film in blacklist",
                                                 "message": "We cannot found any films in your blacklist, try to add one."
                                                 });
                                                 toastEvent.fire();
                                         }else{

                                        let event = component.getEvent("WF_GetMoviesAndActors");
                                        event.setParams({
                                               actorList: response.getReturnValue().actors,
                                               movieList: response.getReturnValue().moviesWithoutBlacklist,
                                               favourites: response.getReturnValue().favourites,
                                               blackList: response.getReturnValue().blackList,
                                               showFav: false,
                                               showBlacklist: true
                                        });
                                        event.fire();
                                        }
                                        spinner.hideSpinner();
                                    }
                                });
                                 $A.enqueueAction(action);
                    }
})