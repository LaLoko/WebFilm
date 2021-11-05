({
    handleCancel : function(component){
        let action = $A.get('e.c:ShowDeleteModal');

        action.setParams({
            show:false
        });
        action.fire();
    },
    deleteComment : function(component,event){

                let review = component.get("v.review");
                let action = component.get('c.deleteReview');
                console.log(JSON.stringify(review))
                action.setParams({
                    review: review
                });
                         action.setCallback(this, function(response){
                                        let state = response.getState();
                                       if (state === "SUCCESS"){
                                           console.log(response.getReturnValue())
                                           let event = component.getEvent('WF_GetNewReviews');
                                           event.setParams({
                                               reviews: response.getReturnValue()
                                           })
                                           event.fire();
                                       }
                         });
                $A.enqueueAction(action);
                let action2 = $A.get('e.c:ShowDeleteModal');

                action2.setParams({
                    show:false
                });
                action2.fire();
    }
})