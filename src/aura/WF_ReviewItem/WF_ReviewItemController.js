({
    reviewDelete : function(component){
        let rev = component.get('v.review')
        console.log(JSON.stringify(rev))

        let event = $A.get('e.c:ShowDeleteModal');
        event.setParams({
           show: true,
           review: rev
        });
        event.fire();
    },
})