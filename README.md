# spark-livy-test

A docker-compose project useful for testing a local Spark+Livy client with AWS components (using LocalStack).

Hadoop Version: 2.7.3
Spark Version: 2.4.4
Livy: 0.6.0

TODO:
 - [X] [30/09] Create alias for aws-cli to avoid having to enter --endpoint-url=...
 - [ ] [30/09] Allow using SSL Enabled
 - [X] [30/09] Use iptables to redirect aws-cli request
 - [ ] [30/09] Fix Error Permission denied: '/tmp/localstack/server.test.pem' 
