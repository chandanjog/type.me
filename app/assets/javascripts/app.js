'use strict';

/* App Module */

var speedRacer = angular.module('speed-racer', []);

speedRacer.
    config(['$routeProvider', function ($routeProvider) {
    $routeProvider.
        when('/race', { templateUrl:'partials/race.html', controller:RaceCtrl}).
        otherwise({redirectTo:'/race'});
}]);

