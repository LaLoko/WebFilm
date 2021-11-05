({
    onInit: function(component){
      let numberOfPages = component.get("v.actorList").length / 16;
      if(numberOfPages < 1){
          numberOfPages = 1;
      }
      if ((numberOfPages*10) % 10 != 0){
          numberOfPages +=1;
      }
      component.set("v.numberOfPages",Math.floor(numberOfPages));
      let allActors = component.get("v.actorList");
      let actors = [];
      let maxItem;
      if(component.get("v.actorList").length >= 16 ){
          maxItem = 16;
      }else{
          maxItem = component.get("v.actorList").length;
      }
      for(let i=0;i<maxItem;i++){
          actors.push(allActors[i]);
      }

      component.set("v.actorToShow",actors);
      component.set("v.page",1)
    },
    goToNext: function(component){
        let actors = [];
        let pageNumber = component.get("v.page");
        let numberOfPages = component.get("v.numberOfPages");
        let firstItemNumber = (pageNumber*16);
        let lastItemNumber;
        let allActors = component.get("v.actorList");
                if(firstItemNumber+16>= allActors.length){
                    lastItemNumber = allActors.length;
                    component.set("v.nextActive",false);
                                  component.set("v.lastActive",false);
                                  component.set("v.firstActive",true);
                }else{
                    lastItemNumber = firstItemNumber+16;
                                  component.set("v.lastActive",true);
                                  component.set("v.firstActive",false)
                }

              for(let i=firstItemNumber;i<lastItemNumber;i++){
                  actors.push(allActors[i]);
              }

              component.set("v.prevActive",true);
              component.set("v.actorToShow",actors);
              component.set("v.page",pageNumber+1)

    },
        goToPrev: function(component){
              let actors = [];
                      let pageNumber = component.get("v.page");
                      let numberOfPages = component.get("v.numberOfPages");
                      let lastItemNumber = ((pageNumber-1)*16);
                      let firstItemNumber;
                      let allActors = component.get("v.actorList");
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
                                actors.push(allActors[i]);
                            }

              component.set("v.nextActive",true);
                            component.set("v.actorToShow",actors);
                            component.set("v.page",pageNumber-1)
        },
        goToFirst : function(component){
            component.set("v.page",1);
            let allActors = component.get("v.actorList");
                          let actors = [];
            for(let i=0;i<16;i++){
                actors.push(allActors[i]);
            }
                            component.set("v.actorToShow",actors);
                            component.set("v.firstActive",false);
                            component.set("v.prevActive",false);
                            component.set("v.nextActive",true);
                            component.set("v.lastActive",true);
                            component.set("v.page",1);
        },
                goToLast : function(component){
                    component.set("v.page",1);
                    let allActors = component.get("v.actorList");
                    let maxItemNum = component.get("v.actorList").length;
                    let numberOfPages = component.get("v.numberOfPages")
                    let firstItemNumber = (numberOfPages-1)*16
                                  let actors = [];
                    for(let i=firstItemNumber;i<maxItemNum;i++){
                        actors.push(allActors[i]);
                    }
                                    component.set("v.actorToShow",actors);
                                    component.set("v.firstActive",true);
                                    component.set("v.prevActive",true);
                                    component.set("v.nextActive",false);
                                    component.set("v.lastActive",false);
                                    component.set("v.page",numberOfPages);
                }
})