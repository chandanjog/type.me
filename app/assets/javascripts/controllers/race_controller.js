function RaceCtrl($scope) {
    $scope.quote = function(){
//        $resource('/race/new?user_id=foo')


        var text="hello how are you doing ; my old friend?"
        var words = text.split(' ');
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
            text: text
        };
    }();

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

}

