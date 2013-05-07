function RaceCtrl($scope) {
    $scope.quote = function(){

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
            higlighted: 0,
            text: text
        };
    }();
}

