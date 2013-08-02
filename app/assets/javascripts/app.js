angular.module('fofwfApp', []).
  config(['$routeProvider', function($routeProvider) {
  $routeProvider.
      when('/login', {templateUrl: 'templates/login.html',   controller: LoginCtrl}).
      when('/messages', {templateUrl: 'templates/message-list.html',   controller: MessageListCtrl}).
      when('/message/:messageId', {templateUrl: 'templates/message.html', controller: MessageCtrl}).
      otherwise({redirectTo: '/login'});
}]);