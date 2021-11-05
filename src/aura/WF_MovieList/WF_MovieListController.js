({
    onInit: function(component){

      let numberOfPages = component.get("v.movieList").length / 16;
      if(numberOfPages < 1){
          numberOfPages = 1;
      }
      if ((numberOfPages*10) % 10 != 0){
          numberOfPages +=1;
      }
      component.set("v.numberOfPages",Math.floor(numberOfPages));
      let allMovies = component.get("v.movieList");
      let movies = [];
      let maxItem;
      if(component.get("v.movieList").length >= 16 ){
          maxItem = 16;
      }else{
          maxItem = component.get("v.movieList").length;
      }
      for(let i=0;i<maxItem;i++){
          movies.push(allMovies[i]);
      }

      component.set("v.moviesToShow",movies);
      component.set("v.page",1)
    },
    goToNext: function(component){
        let movies = [];
        let pageNumber = component.get("v.page");
        let numberOfPages = component.get("v.numberOfPages");
        let firstItemNumber = (pageNumber*16);
        let lastItemNumber;
        let allMovies = component.get("v.movieList");
                if(firstItemNumber+16>= allMovies.length){
                    lastItemNumber = allMovies.length;
                    component.set("v.nextActive",false);
                                  component.set("v.lastActive",false);
                                  component.set("v.firstActive",true);
                }else{
                    lastItemNumber = firstItemNumber+16;
                                  component.set("v.lastActive",true);
                                  component.set("v.firstActive",false)
                }

              for(let i=firstItemNumber;i<lastItemNumber;i++){
                  movies.push(allMovies[i]);
              }

              component.set("v.prevActive",true);
              component.set("v.moviesToShow",movies);
              component.set("v.page",pageNumber+1)

    },
        goToPrev: function(component){
              let movies = [];
                      let pageNumber = component.get("v.page");
                      let numberOfPages = component.get("v.numberOfPages");
                      let lastItemNumber = ((pageNumber-1)*16);
                      let firstItemNumber;
                      let allMovies = component.get("v.movieList");
                              if(lastItemNumber - 16 <= 0){
                                  firstItemNumber = 0;
                                  component.set("v.prevActive",false);
              component.set("v.firstActive",false);
              component.set("v.lastActive",true);
                              }else{
                                                component.set("v.firstActive",true);
                                                component.set("v.lastActive",false);
                                  firstItemNumber = lastItemNumber - 16;
                              }

                            for(let i=firstItemNumber;i<lastItemNumber;i++){
                                movies.push(allMovies[i]);
                            }

              component.set("v.nextActive",true);
                            component.set("v.moviesToShow",movies);
                            component.set("v.page",pageNumber-1)
        },
        goToFirst : function(component){
            component.set("v.page",1);
            let allMovies = component.get("v.movieList");
                          let movies = [];
            for(let i=0;i<16;i++){
                movies.push(allMovies[i]);
            }
                            component.set("v.moviesToShow",movies);
                            component.set("v.firstActive",false);
                            component.set("v.prevActive",false);
                            component.set("v.nextActive",true);
                            component.set("v.lastActive",true);
                            component.set("v.page",1);
        },
                goToLast : function(component){
                    component.set("v.page",1);
                    let allMovies = component.get("v.movieList");
                    let maxItemNum = component.get("v.movieList").length;
                    let numberOfPages = component.get("v.numberOfPages")
                    let firstItemNumber = (numberOfPages-1)*16
                                  let movies = [];
                    for(let i=firstItemNumber;i<maxItemNum;i++){
                        movies.push(allMovies[i]);
                    }
                                    component.set("v.moviesToShow",movies);
                                    component.set("v.firstActive",true);
                                    component.set("v.prevActive",true);
                                    component.set("v.nextActive",false);
                                    component.set("v.lastActive",false);
                                    component.set("v.page",numberOfPages);
                }
})