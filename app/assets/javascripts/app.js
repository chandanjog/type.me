'use strict';

/* App Module */

var speedRacer = angular.module('speed-racer', ['controllers']);

speedRacer.
    config(['$routeProvider', function ($routeProvider) {
    $routeProvider.
        when('/race', { templateUrl:'partials/race.html', controller:'RaceCtrl'}).
        when('/menu', { templateUrl:'partials/menu.html', controller:'MenuCtrl'}).
        when('/about', { templateUrl:'partials/about.html'}).
        otherwise({redirectTo:'/menu'});
}]);

