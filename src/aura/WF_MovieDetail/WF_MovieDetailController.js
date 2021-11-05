({
    closeMovieDetailModal : function(component, event, helper){
            let modalEvent = component.getEvent("WF_ShowMovieDetail");
                       modalEvent.setParams({
                      "showMovieDetail": false,
                      "movie": null
                     });
             modalEvent.fire();
             let favOnClose = component.get("v.isFavOnClose");
             let fav = component.get("v.isFav");
             let black = component.get("v.isBlack");
             let blackOnClose = component.get("v.isBlackOnClose");
             let fromFav = component.get('v.fromFav');
             let fromBlack = component.get('v.fromBlack')
//                            console.log(component.get('v.fromFav'))
//                                           console.log(component.get('v.fromBlack'))
//                            console.log(component.get('v.fromMain'))

             if(favOnClose != undefined || blackOnClose != undefined){
                 console.log('nie jest unchecked')
                 if(favOnClose != fav || blackOnClose != black){
                     let ev = component.getEvent('WF_GetMoviesAndActors');
                     ev.setParams({
                               actorList: [],
                                                            movieList: [],
                                                            favourites: [],
                                                            blackList: [],
                               showFav: false,
                               showBlacklist: false
                     });
                     ev.fire();

//                     let changeEvent = component.getEvent("WF_FavOrBlackChanged");
//                     if(fav && fav != favOnClose){
//                         helper.showFavourites(component);
//                         console.log('wchodzi z fav')
//                                   changeEvent.setParams({
//                                                 isChanged: true,
//                                                 favChanged: true,
//                                                 blackChanged: false
//                                              });
//                     }else if(black && black != blackOnClose){
//                         helper.showBlacklist(component);
//                         console.log('wchodzi z black')
//                                      changeEvent.setParams({
//                                                                          isChanged: true,
//                                                                          favChanged: false,
//                                                                          blackChanged: true
//                                                                       });
//                     }else{
//                         helper.getActorsAndMovies(component);
//                         console.log('wchodzi z glownego')
//                                       changeEvent.setParams({
//                                                                                                   isChanged: true,
//                                                                                                   favChanged: false,
//                                                                                                   blackChanged: false
//                                                                                                });
//                     }

//                     changeEvent.fire();
                 }
             }

    },
    doInit: function(component,event,helper){
        helper.onInit(component);

                let resetActor = component.getEvent("WF_ShowActorDetail");
                resetActor.setParams({
                    "showActorDetail": false
                });
                resetActor.fire();
    },
    refreshReviews : function(component,event,helper){
        let revs = event.getParam('reviews');
        let overall = 0.0;
        revs.forEach(element=> element.Score__c != null ? overall += element.Score__c : '')
        let movie = component.get('v.movie');
        console.log(overall)
        console.log(revs)
        if (revs.length == 0){
            movie.movie.Rate__c = component.get("v.preScore");
//            helper.refreshReviews(component);
//                    movie.movie.Rate__c = overall;
        }else{
                    movie.movie.Rate__c = overall/revs.length;
        }
        component.set('v.movie',movie);
        component.set('v.movieReviews',revs);
    },
    addToFav : function(component, event, handler){

                       const spinner = component.find("spinner");

                                spinner.showSpinner();
                let action = component.get("c.addToFavourites");
                action.setParams({
                    movie: component.get("v.movie"),
                });
                action.setCallback(this, function(response){
                    let state = response.getState();
                    if (state === "SUCCESS"){
                        component.set('v.movie.movie.isFav__c',true)
                        component.set('v.movie.movie.isBlack__c',false)
                        component.set("v.isFavOnClose",true);
                        component.set("v.isBlackOnClose",false);
                    }
                    spinner.hideSpinner();
                });
                 $A.enqueueAction(action);
     },
     deleteFromFav : function(component, event, handler){
                        const spinner = component.find("spinner");

                                 spinner.showSpinner();
                         let action = component.get("c.deleteFormFavourites");
                         action.setParams({
                             movie: component.get("v.movie"),
                         });
                         action.setCallback(this, function(response){
                             let state = response.getState();
                             if (state === "SUCCESS"){
                               component.set('v.movie.movie.isFav__c',false)
              component.set("v.isFavOnClose",false);
                             }
                                                 spinner.hideSpinner();

                         });
                          $A.enqueueAction(action);
     },
         addToBlack : function(component, event, handler){
              const spinner = component.find("spinner");

                                              spinner.showSpinner();
                             let action = component.get("c.addToBlacklist");
                             action.setParams({
                                 movie: component.get("v.movie"),
                             });
                             action.setCallback(this, function(response){
                                 let state = response.getState();
                                 if (state === "SUCCESS"){
                                  component.set('v.movie.movie.isBlack__c',true)
                                  component.set('v.movie.movie.isFav__c',false)
                                                component.set("v.isFavOnClose",false);
                                                          component.set("v.isBlackOnClose",true);

                                 }
                               spinner.hideSpinner();
                             });
                              $A.enqueueAction(action);
          },
          deleteFromBlack : function(component, event, handler){
               const spinner = component.find("spinner");

                                               spinner.showSpinner();
                                       let action = component.get("c.deleteFormBlacklist");
                                       action.setParams({
                                           movie: component.get("v.movie"),
                                       });
                                       action.setCallback(this, function(response){
                                           let state = response.getState();
                                           if (state === "SUCCESS"){
                                             component.set('v.movie.movie.isBlack__c',false)
                                                                     component.set("v.isBlackOnClose",false);
                                           }
                                           spinner.hideSpinner();

                                       });
                                        $A.enqueueAction(action);
          },
         addReview : function(component, event, handler){

         if((component.get("v.reviewText") != undefined && component.get("v.reviewText") != "") || component.get("v.score") != 0){
                      let action = component.get("c.addMovieReview")
                      action.setParams({
                          score: component.get("v.score"),
                          review: component.get("v.reviewText"),
                          movieWrapper: component.get("v.movie")

                      });
                      action.setCallback(this,function(response){
                          let state = response.getState();
                              if (state === "SUCCESS"){
                                    component.set('v.movieReviews',response.getReturnValue())
                                    component.set("v.score", 0);
                                    component.set("v.reviewText","")

                                         let overall = 0.0;
                                            response.getReturnValue().forEach(element=> element.Score__c != null ? overall += element.Score__c : '');
                                            let movie = component.get('v.movie');
                                            movie.movie.Rate__c = overall/response.getReturnValue().length;
                                            component.set('v.movie',movie);
                              }
                      });
                      $A.enqueueAction(action);
         }else{
                    var toastEvent = $A.get("e.force:showToast");
                                                toastEvent.setParams({
                                                 "title": "Invalid review",
                                                  "message": "Please make sure your opinion is correct before submit"
                                                  });
                                                  toastEvent.fire();
         }

         },
         openDeleteModal : function(component,event){
             let show = event.getParam('show');
             let review = event.getParam('review');
             console.log(JSON.stringify(review))

             component.set('v.reviewToDel',review);
             component.set('v.showDeleteModal',show);
         }
})