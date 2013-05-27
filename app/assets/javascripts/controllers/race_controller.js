function updateProgressAndRenderLatestStats($scope, Race, race){
    $scope.timer_id = setInterval(function(){
        var userId = sprintf("guest_%s", race.guest_counter.toString());
        Race.update({
                        id: race.id,
                        user_id: userId,
                        progress: getProgress($scope)
                    },
        function(response){
            $scope.participants = response.participants;
            if(response.status === "COMPLETE"){
                clearInterval($scope.timer_id);
            }
        });

        if(getProgress($scope) === 100){
            Race.update({id: race.id, user_id: userId, progress: getProgress($scope), status: "COMPLETE"})
        }

    },1000);
}

function getProgress($scope){
    return ($scope.quote.highlighted/$scope.quote.words.length)*100;
}

function timeToWaitInMillisecondsForEnablingTheRace(race){
    var diff = new Date().getTime() - Date.parse(race.created_at);
    return (race.race_available_to_join_for_in_seconds * 1000) - diff;
}

speedRacercontrollers.controller('RaceCtrl',[ '$scope', 'Race', function($scope, Race){

    Race.new(function(response){
        var race = response;

        setTimeout(function(){
            $(".start").remove();
            $("#stats .loader").remove();
            updateProgressAndRenderLatestStats($scope, Race, race);

            $(".user-entry").removeAttr('disabled').focus();
        }, timeToWaitInMillisecondsForEnablingTheRace(race));

        $scope.quote = function(){
            var words = race.text.split(' ');
            var processed_words = [];
            _.each(words, function(element, index){
                if(index === (words.length - 1))
                    processed_words.push(element);
                else
                    processed_words.push(element.concat(" "));
            })
            return {
                words: processed_words,
                highlighted: 0,
                text: race.text
            };
        }();

    });


    $scope.isHighlighted = function(index){
        if(index == $scope.quote.highlighted)
            return "highlighted";
        return "";
    }


    var inputBox = $(".user-entry");
    inputBox.bind('keyup', function (event) {
        var element = this;

        console.log("::::::::::::::");
        console.log(sprintf("highligted word: '%s'",$scope.quote.words[$scope.quote.highlighted]));
        console.log("input entered so far::" + element.value);

        for (var i = 0; i < element.value.length; i++) {
            console.log("-------------");
            console.log("highligted: " + $scope.quote.words[$scope.quote.highlighted][i]);
            console.log("input ::" + element.value[i]);

            if ($scope.quote.words[$scope.quote.highlighted].indexOf(element.value) !== 0 ) {
                $(element).addClass('error');
            } else {
                $(element).removeClass('error');
                if (element.value === $scope.quote.words[$scope.quote.highlighted]) {
                    $(sprintf("#word_%s",$scope.quote.highlighted)).removeClass("highlighted");
                    $scope.quote.highlighted = $scope.quote.highlighted + 1;
                    $(sprintf("#word_%s",$scope.quote.highlighted)).addClass("highlighted");
                    element.value = "";
                }
            }
        }

        if($scope.quote.words.length === $scope.quote.highlighted){
            jQuery(element).hide();
        }

    });

}]);
