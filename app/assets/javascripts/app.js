'use strict';

/* App Module */

var speedRacer = angular.module('speed-racer', []);

speedRacer.
    config(['$routeProvider', function ($routeProvider) {
    $routeProvider.
        when('/race', { templateUrl:'partials/race.html', controller:RaceCtrl}).
        otherwise({redirectTo:'/race'});
}]);

speedRacer.directive('textEntry', function () {
    return {
        replace:true,
        template:'<div><input type="text" class="user-entry"/></div>',
        link:function (scope, element, attrs) {
            console.log("element::" + element);
            console.log("element::" + element.children(".user-entry"));
            var inputBox = element.children(".user-entry");

            inputBox.bind('keypress',function(event){
                console.log("keypress: "+element.value);
                console.log("keypress charcode: "+String.fromCharCode(event.charCode));
                if(String.fromCharCode(event.charCode) === " "){
                    if(element.value !== undefined){
                        event.preventDefault();
//                        element.value = "";//reset the text box
                        return;
                    }
                    else{
                        event.preventDefault();
                    }
                }
            });

            inputBox.bind('keyup', function (event) {
                element = this;
                if(element.value === ""){
                    return;
                }
                console.log("element value::" + element.value);

                if (element.value.indexOf(' ') !== -1) {
                    element.value = "";//reset the text box
                    return;
                }
                for (var i = 0; i < element.value.length; i++) {

                    console.log("highligted word: " + scope.quote.words[scope.quote.higlighted]);
                    console.log("highligted: " + scope.quote.words[scope.quote.higlighted][i]);
                    console.log("input ::" + element.value[i]);
                    console.log("input entered so far::" + element.value);

                    if (scope.quote.words[scope.quote.higlighted][i] !== element.value[i]) {
                        element.className = 'error';
                    } else {
                        element.className = "";
                        if (element.value === scope.quote.words[scope.quote.higlighted]) {
                            scope.quote.higlighted = scope.quote.higlighted + 1;
                            element.value = "";
                        }
                    }
                }
            });
        }
    };
});

