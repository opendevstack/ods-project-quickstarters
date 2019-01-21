# Data Science Industrialization Boilerplate
This boilerplate enables data scientists to develop, serve, version models within a CI/CD 
pipeline hosted on openshift with the goal in mind that one does not have to take care/change 
much of the needed pipeline and infrastructure.

## Basic Setup ##
The boilerplate provides a two pod setup in openshift, one pod for training service and one pod for 
prediction service.

##### Docker #####  
Each service has their own *Dockerfile*, under *docker-prediction* respectively *docker-training*
that can be changed according to your requirements on operating system dependencies.  
The *docker-training* container provides a Pod that is able to recreate/train the model that is 
developed in the current commit either locally on openshift or execute the training on a remote 
linux system using ssh. The training process is wrapped into a flask server to be able to monitor
 and possible restart the training process. Moreover, the training service offers and endpoint 
 for downloading the created model afterwards.  
The *docker-prediction* container provides a simple flask service for getting new predictions out
 of your model by making json posts to the *prediction* endpoint.
 The prediction service downloads the newly trained model from the training pod after startup.

##### Jenkins #####
The Jenkinsfile organizes the correct succession of spinning up the training, executing it and 
starting the new deployment of the prediction service.  
Additionally, it executes unittest ensuring the the code is functionally before a new training 
process is started, as well as executing integration tests against the prediction endpoint to 
ensure quality checks before redeploying models in openshift.
 
##### External Files #####
External files that are needed either for building your model or docker images are stored under 
*resources*. For demonstration purposes a training and test csv file is stored in resources. 

##### src -  the heart of your service #####
The *src* folder contains the infrastructure coded needed for providing the services in openshift
 in *services*. Custom code for developing your prediction service is organized in the *model* 
 package.  
 In the (common) *requirements.txt* you can specify python dependencies for training, prediction 
 and tests. To keep it simple, there is only one requirements.txt for both pods.
 
 
##### test ##### 
The *test* directory mirrors the structure of the *src*, either for unittests or integration 
tests using the python unittest framework.
 
 
#### How to Code Your Own Models ####
To run your own customized models there is usually no need to change either the Jenkinsfile, 
openshift setup or the training and prediction microservices.  
Custom model code will go under *src/model* and can be organized in custom packages like 
showcased with the *data_cleaning* and *feature_prep*. But in general can be organized as 
preferred.  
There are no further restrictions for developing the in the style you want, for the exception to 
provide the mandatory functions in the ModelWrapper class:
- **prep_and_train**: is called by the train script (which one can customize) and expects a 
pandas dataframe (current implementation). The train script is called by the training service
- **prep_and_predict**: is called by the *predict* endpoint from the prediction service. It 
expects a pandas dataframe with the column names corresponding to the feature names. The predict 
endpoint takes the json request, converts it into a pandas dataframe (for simplicity, even if it 
contains only one row) and executes **prep_and_predict**.

Make sure your specified all dependencies in the requirements.txt

#### How to Develop your Model Locally ####
It is recommended to develop your code against the python interpreter & dependencies specified in
 the docker images.
 This can easily achieved, either by using an IDE that supports that (e.g. PyCharm) or by doing 
 manually in the docker container.
 
The whole setup (prediction and training service) can be tested using the attached docker-compose



#### Example & Example Dataset ####
An example implementation of a custom model is given in *model*, to demonstrate how to organize 
your custom code.  
A Logistic Regression using scikit-learn with some (unnecessary) feature cleaning and engineering
 is trained on the iris data flower set.  
 
**Iris flower data set**. (n.d.). In Wikipedia. Retrieved January 7, 2019, from https://en.wikipedia.org/wiki/Iris_flower_data_set



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


