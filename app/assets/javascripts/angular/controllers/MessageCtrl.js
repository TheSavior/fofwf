var MessageCtrl = ['$scope', '$routeParams', '$http', function($scope, $routeParams, $http) {
  $scope.id = $routeParams.messageId;

  $scope.getMessages = function($scope) {
    console.log("Getting messages");
    $http.get("/message_threads/"+$scope.id)
    .success(function(data, status, headers, config) {
        console.log(data);
        $scope.data = data;

    }).error(function(data, status, headers, config) {
        console.error(data);
        console.error(status);
    });
  };

  $scope.makeGuess = function(guess) {
    $http.post("/attempt_match/" + $scope.id, {
      guess: guess
    })
      .success(function(data, status, headers, config) {
        console.log(data);
        if (data.guess == "correct") {
          $scope.data.number_matched = data.count;
          $scope.guess = "";
        }
      }).error(function(data, status, headers, config) {
        console.error(data);
        console.error(status);
      });
  };

  $scope.sendMessage = function(message) {
    $http.post("/messages", {thread_id: $scope.id, content: message})
    .success(function(data, status, headers, config) {
        console.log(data);
        $scope.messageText = "";
    }).error(function(data, status, headers, config) {
        console.error(data);
        console.error(status);
    });
  };

  function check() {
    $scope.getMessages($scope);
  }

  $scope.$on('$destroy', function cleanup() {
    console.log("====Cleanup====");
    clearTimeout(timer);
  });

  check();

  var timer = setInterval(check, 2000);

  
}];