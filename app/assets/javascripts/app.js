angular.module('fofwfApp', ['hmTouchEvents']).
  config(['$routeProvider', function($routeProvider) {
  $routeProvider.
      when('/', {templateUrl: 'templates/message-list.html',   controller: MessageListCtrl}).
      when('/message/:messageId', {templateUrl: 'templates/message.html', controller: MessageCtrl}).
      otherwise({redirectTo: '/'});
}]);