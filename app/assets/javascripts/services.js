var speedRacerServices = angular.module('services', ['ngResource'])

speedRacerServices.factory('Race',['$resource', function($resource) {
    return $resource('/race/:id',
                    {id: '@id'},
                    {
                        update: {method: 'PUT'},
                        new: { method: 'GET', params: {id: 'new'}}
                    }
    );
}]);