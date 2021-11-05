({
        onInit : function(component){
                const spinner = component.find("spinner");

                        spinner.showSpinner();
                                    let action = component.get("c.getMovieWithDetails");
                                    action.setParams({
                                        movie: component.get("v.movie")
                                    });
                                    action.setCallback(this, function(response){
                                        let state = response.getState();
                                        if (state === "SUCCESS"){
                                            component.set("v.movie",response.getReturnValue())
                                            component.set("v.isFav",response.getReturnValue().movie.isFav__c);
                                            component.set("v.isBlack",response.getReturnValue().movie.isBlack__c);
                                            component.set("v.preScore",response.getReturnValue().movie.Rate__c);
                                        }
                                    });
                            $A.enqueueAction(action);
                                        let action2 = component.get("c.getMovieReviews");
                                                                action2.setParams({
                                                                    movie: component.get("v.movie")
                                                                });
                                                                action2.setCallback(this, function(response){
                                                                    let state = response.getState();
                                                                    if (state === "SUCCESS"){
                                                                        component.set("v.movieReviews",response.getReturnValue())
                                                                 spinner.hideSpinner();
                                                                    }
                                                                });
                                                                                            $A.enqueueAction(action2);



        },
        getActorsAndMovies : function(component, event, handler){
            console.log('helper wszystkie')
                    const spinner = component.find("spinner");

                    spinner.showSpinner();
                    let action = component.get("c.search");
                    action.setParams({
                        key: component.get("v.searchKey"),
                        userFilms : component.get("v.userFilms")
                    });
                                                            console.log('ustawia parametry')

                    action.setCallback(this, function(response){
                        let state = response.getState();
                        console.log(state)
                            ('pre sukces')
                            if((response.getReturnValue().actors.length == 0 || response.getReturnValue().actors == null) &&
                            (response.getReturnValue().moviesWithoutBlacklist.length == 0 || response.getReturnValue().moviesWithoutBlacklist == null)){
                                                var toastEvent = $A.get("e.force:showToast");
                                                                                                            toastEvent.setParams({
                                                                                                                    "title": "No records found",
                                                                                                                    "message": "We cannot found any movies or actors, check if search keyword is correct and try again."
                                                                                                                });
                                                                                                                toastEvent.fire();
                            }else{
                                        console.log('sukces wszystkie helper')


                            let event = component.getEvent("WF_GetMoviesAndActors");
                            event.setParams({
                                   actorList: response.getReturnValue().actors,
                                   movieList: response.getReturnValue().moviesWithoutBlacklist,
                                   favourites: response.getReturnValue().favourites,
                                   blackList: response.getReturnValue().blackList,
                                   showFav: false,
                                   showBlacklist: false
                            });
                            event.fire();
                            }

                            spinner.hideSpinner();

                    });
                     $A.enqueueAction(action);

                },
                    showFavourites : function(component,event){
                                    console.log('helper fav')

                                const spinner = component.find("spinner");

                                spinner.showSpinner();
                                let action = component.get("c.search");
                                action.setParams({
                                    key: component.get("v.searchKey"),
                                    userFilms : component.get("v.userFilms")
                                });
                                        console.log('ustawia parametry')

                                action.setCallback(this, function(response){
                                    let state = response.getState();
                                                            console.log(state)

                                        console/log('pre sukces')
                                                               if(response.getReturnValue().favourites === undefined || response.getReturnValue().favourites.length == 0){
                                                                                            var toastEvent = $A.get("e.force:showToast");
                                                                                            toastEvent.setParams({
                                                                                                    "title": "There is no favourites",
                                                                                                    "message": "We cannot found any favourites films in your collection, try to add one."
                                                                                                });
                                                                                                toastEvent.fire();
                                                                                        }else{
                                                                                                                                    console.log('sukces fav')

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
                                });
                                 $A.enqueueAction(action);
                    },
                    showBlacklist : function(component,event){
                                    console.log('helper black')

                                        const spinner = component.find("spinner");

                                        spinner.showSpinner();
                                        let action = component.get("c.search");
                                        action.setParams({
                                            key: component.get("v.searchKey"),
                                            userFilms : component.get("v.userFilms")
                                        });
                                        console.log('ustawia parametry')
                                        action.setCallback(this, function(response){
                                            let state = response.getState();
                                                                    console.log(state)

                                                ('pre sukces')
                                                if(response.getReturnValue().blackList === undefined || response.getReturnValue().blackList.length == 0){
                                                   var toastEvent = $A.get("e.force:showToast");
                                                       toastEvent.setParams({
                                                        "title": "There is no film in blacklist",
                                                         "message": "We cannot found any films in your blacklist, try to add one."
                                                         });
                                                         toastEvent.fire();
                                                 }else{
                                                                                             console.log('sukces black')


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

                                        });
                                         $A.enqueueAction(action);
                            },
                            refreshReviews : function(component){
                                                               let action2 = component.get("c.getMovieReviews");
                                                                                                action2.setParams({
                                                                                                    movie: component.get("v.movie")
                                                                                                });
                                                                                                action2.setCallback(this, function(response){
                                                                                                    let state = response.getState();
                                                                                                    if (state === "SUCCESS"){
                                                                                                        component.set("v.movieReviews",response.getReturnValue())
                                                                                                 spinner.hideSpinner();
                                                                                                    }
                                                                                                });
                                                                                                                            $A.enqueueAction(action2);
                            }
})