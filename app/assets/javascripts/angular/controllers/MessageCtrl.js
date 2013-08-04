var MessageCtrl = ['$scope', '$routeParams', '$http', function($scope, $routeParams, $http) {
  $scope.id = $routeParams.messageId;

  $scope.getMessages = function($scope) {
    console.log("Getting messages");
    $http.get("/message_threads/"+$scope.id)
    .success(function(data, status, headers, config) {
        console.log(data);

    }).error(function(data, status, headers, config) {
        console.error(data);
        console.error(status);
    });
  };

  $scope.getMessages($scope);
}];