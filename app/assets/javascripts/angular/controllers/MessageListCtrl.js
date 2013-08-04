var MessageListCtrl = ['$scope', '$http',
  function($scope, $http) {
    $scope.getMessages = function() {
      $http.get("/message_threads")
        .success(function(data, status, headers, config) {
          $scope.messages = data;
        }).error(function(data, status, headers, config) {
          console.error(data);
          console.error(status);
        });
    };

    $scope.newMessage = function() {
      $http.post("/message_threads")
        .success(function(data, status, headers, config) {
          if (data.found === true) {
            $scope.getMessages();
          }
        }).error(function(data, status, headers, config) {
          console.error(data);
          console.error(status);
        });
    };

    $scope.getMessages();
  }
];