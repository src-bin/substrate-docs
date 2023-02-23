# Debugging Substrate

Substrate is written in Go using the standard AWS SDK for Go. Every release comes with source code so, sometimes, the best debugging strategy is to change the source code and recompile. Often, though, that's an enormous pain and overkill. Two environment variables are available to give folks an easier time debugging Substrate and its use of the AWS SDK:

* `SUBSTRATE_DEBUG_AWS_LOGS`: Set to a non-empty string to get full request and response logs of every request made by the AWS SDK.
* `SUBSTRATE_DEBUG_AWS_RETRIES`: Set to an integer to control the maximum number of times a request will be retried by the AWS SDK.