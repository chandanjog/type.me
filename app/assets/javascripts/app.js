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
            var inputBox = element.children(".user-entry");

            inputBox.bind('keyup', function (event) {
                element = this;

                console.log("::::::::::::::");
                console.log(sprintf("highligted word: '%s'",scope.quote.words[scope.quote.higlighted]));
                console.log("input entered so far::" + element.value);
                for (var i = 0; i < element.value.length; i++) {
                    console.log("-------------");
                    console.log("highligted: " + scope.quote.words[scope.quote.higlighted][i]);
                    console.log("input ::" + element.value[i]);

                    if (scope.quote.words[scope.quote.higlighted].indexOf(element.value) !== 0 ) {
                        element.className = 'error';
                    } else {
                        element.className = "";
                        if (element.value === scope.quote.words[scope.quote.higlighted]) {
                            scope.quote.higlighted = scope.quote.higlighted + 1;
                            element.value = "";
                        }
                    }
                }

                if(scope.quote.words.length === scope.quote.higlighted){
                    jQuery(element).hide();
                }

            });
        }
    };
});

