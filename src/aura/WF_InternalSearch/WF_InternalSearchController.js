({
    doInit : function(component, event, helper){
        helper.onInit(component);
    },
    onGetMoviesOrActors : function(component, event, handler){
        let actorList = event.getParam("actorList")
        let movieList = event.getParam("movieList")
        let favourites = event.getParam("favourites")
        let blacklist = event.getParam("blackList")
        let showFav = event.getParam("showFav")
        let showBlack = event.getParam("showBlacklist")
        console.log('weszlo do wczytywania wszystkiego')

        component.set("v.movieList",null)
        component.set("v.actorList",null)
        component.set("v.favorites",null)
        component.set("v.blackList",null)

        component.set('v.searchKey',event.getParam('searchKey'));
        component.set("v.moviePage",1);
        component.set("v.actorPage",1);
        component.set("v.movie",null);
        component.set("v.actor",null);
        component.set("v.showMovieDetail",false);
        component.set("v.showActorDetail",false);
        component.set("v.actorList", actorList);
        component.set("v.movieList", movieList);
        component.set("v.favorites", favourites);
        component.set("v.blackList", blacklist);
        component.set("v.showFav", showFav);
        component.set("v.showBlacklist", showBlack);
    },
    onSomethingChange : function(component,event){
              let somethingChanged = event.getParam("isChanged");
              let favChanged = event.getParam("favChanged");
              let blackChanged = event.getParam("blackChanged");

             console.log('main')
              console.log(somethingChanged)
              console.log(favChanged)
              console.log(blackChanged)

              component.set("v.somethingChanged",somethingChanged);
              component.set("v.favChanged",favChanged);
              component.set("v.blackChanged",blackChanged);
    },
    onShowMovieDetail : function(component, event, handler){
           let showMovieDetail = event.getParam("showMovieDetail")
           let movie = event.getParam("movie")
           let fromFav = event.getParam('fromFav');
           let fromBlack = event.getParam('fromBlack');
           console.log('form fav main')
           console.log(fromFav)
           console.log('form black main')
           console.log(fromBlack)

           if(component.get("v.showActorDetail") == true){
               component.set("v.showActorDetail", false);
               component.set("v.actor",null);
           }

           component.set('v.fromFav',fromFav);
           component.set('v.fromBlack',fromBlack);
           component.set("v.showMovieDetail", showMovieDetail);
           component.set("v.movie", movie);
    },
        onShowActorDetail : function(component, event, handler){
               let showActorDetail = event.getParam("showActorDetail")
               let actor = event.getParam("actor")
               if(component.get("v.showMovieDetail") == true){
                              component.set("v.showMovieDetail", false);
                              component.set("v.movie",null);
               }

               component.set("v.showActorDetail", showActorDetail);
               component.set("v.actor", actor);
        }
})