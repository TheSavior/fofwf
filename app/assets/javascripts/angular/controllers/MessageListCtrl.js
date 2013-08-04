var MessageListCtrl = ['$scope', '$http',
    function($scope, $http) {
        $scope.messages = [{
            "time": "3 Days ago",
            "last_message": "What did you think of...",
            "total": 12,
            "current": 3,
            "friends": "Kyle Z, Jay M, Foo B"
        }, {
            "time": "1 Hour ago",
            "last_message": "Nah, I don't know that...",
            "total": 3,
            "current": 2,
            "friends": "Kyle Z, Bar B"
        }, {
            "time": "2 Minutes ago",
            "last_message": "That guy is crazy!",
            "total": 1,
            "current": 0,
            "friends": ""
        }, ];

        $scope.getData = function() {
            console.log("Getting messages");
            $http.get("/message_threads")
            .success(function(data, status, headers, config) {
                console.log(data);

            }).error(function(data, status, headers, config) {
                console.error(data);
                console.error(status);
            });
        };
    }
];