# Data Science Industrialization Boilerplate
This boilerplate enables data scientists to develop, serve, version models within a CI/CD 
pipeline hosted on openshift. 

## Basic Setup ##

Two pods in openshift

### Environment Variables for training ###

| Environment Variable | Description | Allowed Values |
|------|-------|---|
| DSI_DEBUG_MODE | Enables debug mode | true, 1 our yes for debug mode, otherwise debug is disasbled|
| DSI_EXECUTE_ON | Where the train should be executed | LOCAL, SSH |
| DSI_TRAINING_SERVICE_USERNAME | Username to be set as default username for accessing the services | string, required |
| DSI_TRAINING_SERVICE_PASSWORD | Password to be set as default password for accessing the services | string, required |
| |Following variables are applicable if **DSI_EXECUTE_ON=SSH**| |
| DSI_SSH_HOST | SSH host name where train should be executed (Only applicable if DSI_EXECUTE_ON=SSH) | host names or ip addresses |
| DSI_SSH_PORT | SSH host port where train should be executed (Only applicable if DSI_EXECUTE_ON=SSH) | port numbers (Default: 22) |
| DSI_SSH_USERNAME | SSH username for remote execution  | string\ |
| DSI_SSH_PASSWORD | SSH password for remote execution  | string |
| DSI_SSH_HTTP_PROXY | HTTP proxy url for remote execution. This is needed if the remote machine needs the proxy for download packages and resources  | string |
| DSI_SSH_HTTPS_PROXY | HTTPS proxy url for remote execution. This is needed if the remote machine needs the proxy for download packages and resources  | string |

### Environment Variables for prediction ###

| Environment Variable | Description | Allowed Values |
|------|-------|---|
| DSI_DEBUG_MODE | Enables debug mode | true, 1 our yes for debug mode, otherwise debug is disasbled|
| DSI_TRAINING_BASE_URL | The base url where the prediction service should get the model from | url (e.g. https://training.openshift.svc |
| DSI_TRAINING_SERVICE_USERNAME | Username of the training service | string, required |
| DSI_TRAINING_SERVICE_PASSWORD | Password of the training service | string, required |
| DSI_PREDICTION_SERVICE_USERNAME | Username to be set as default username for accessing the service | string, required |
| DSI_PREDICTION_SERVICE_PASSWORD | Password to be set as default password for accessing the service | string, required |

## How to Code Your Own Models ## 

common folder

#### How to Develop Locally ####

Develop against the docker training image



#### Example Dataset ####
**Iris flower data set**. (n.d.). In Wikipedia. Retrieved January 7, 2019, from https://en.wikipedia.org/wiki/Iris_flower_data_set


## Structure of the quick starter ##

* **Training**
    * Build Config
		* **name**: *&lt;componentId&gt;*-training-service
		* **variables**: None		
	* Deployment Config
		* **name**: *&lt;componentId&gt;*-training-service
		* **variables**:
			* DSI_EXECUTE_ON: LOCAL	
			* DSI_TRAINING_SERVICE_USERNAME: auto generated username
			* DSI_TRAINING_SERVICE_PASSWORD: auto generated password
	* Route: None		 
* **Prediction**
	* Build Config
		* **name**: *&lt;componentId&gt;*-prediction-service
		* **variables**: None			
	* Deployment Config
		* **name**: *&lt;componentId&gt;*-prediction-service
		* **variables**:
			* DSI_TRAINING_BASE_URL: http://*&lt;componentId&gt;*-training-service.*&lt;env&gt;*.svc:8080
			* DSI_TRAINING_SERVICE_USERNAME: username of the training service
			* DSI_TRAINING_SERVICE_PASSWORD: password of the training service
			* DSI_PREDICTION_SERVICE_USERNAME: auto generated username
			* DSI_PREDICTION_SERVICE_PASSWORD: auto generated password
	* Route: None 


