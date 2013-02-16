function RaceCtrl($scope) {
    $scope.quote = function(){
        var text="hello how are you", words = text.split(' ');

        return {
            words: words,
            higlighted: 0,
            text: text
        };
    }();
}
