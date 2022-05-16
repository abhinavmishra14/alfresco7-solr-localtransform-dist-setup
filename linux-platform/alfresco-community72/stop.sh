#!/bin/bash

#Order of operation
## - Stop LocalTransformService
## - Stop ACS
## - Stop DB
## - Stop Solr
## - Stop AMQ

printf "\n------------------------------ Stopping services ------------------------- \n"


#User can pass ALF_HOME path. Defaults to "/usr/local/alfresco-community72".
export ALF_HOME=${1:-"/usr/local/alfresco-community72"}
#User can pass SOLR_HOME path. Defaults to "/usr/local/alfresco-search-services".
export SOLR_HOME=${2:-"/usr/local/alfresco-search-services"}


export CATALINA_HOME=$ALF_HOME/tomcat
export CATALINA_TMPDIR=$CATALINA_HOME/temp
export JRE_HOME=$JAVA_HOME

# Check if JRE_HOME is set in path variable or not, else set default path. It is mandatory for acs to start
if [ -z "$JRE_HOME" ]
then
  echo "JRE_HOME could not be found, setting the default..." 
  export JRE_HOME="/usr/lib/jvm/java-11"
fi

#Export JRE_HOME to PATH
export PATH=$PATH:$JRE_HOME/bin

# Check if ALF_HOME is set in path variable or not, we may need it for executing shell scripts as needed.
if [[ "$PATH" == *"$ALF_HOME"* ]]; then
  echo "$ALF_HOME already set in PATH variable."
else 
  export PATH=$PATH:$ALF_HOME
fi

# Check if SOLR_HOME is set in path variable or not, we may need it for executing shell scripts as needed.
if [[ "$PATH" == *"$SOLR_HOME"* ]]; then
  echo "$SOLR_HOME already set in PATH variable."
else
  export PATH=$PATH:$SOLR_HOME
fi


echo "---------------------------------------------"
echo CATALINA_HOME: $CATALINA_HOME
echo CATALINA_TMPDIR: $CATALINA_TMPDIR
echo JRE_HOME: $JRE_HOME
echo SOLR_HOME: $SOLR_HOME
echo ALF_HOME: $ALF_HOME
echo PATH: $PATH
echo "---------------------------------------------"

StopLocalTransformService() {
    printf "\nInvoking local transformation service stop script... \n"
	# Check for more info: https://docs.alfresco.com/transform-service/latest/install/#install-with-zip
	sudo -u alfresco $ALF_HOME/localTransformationService.sh stop

	if [[ $? = 0 ]]
	then
           echo "localTransformService script executed successfully."
	else
	   echo "Failed to execute localTransformService script!"
	   exit 1
        fi
}

StopACS() {
        printf "\nShutting down Alfresco Tomcat... \n"
	sudo systemctl stop tomcat
	
	if [[ $? = 0 ]]
	then
	   echo "tomcat service stopped successfully."
	else
	   echo "Failed to stop tomcat service!"
	   exit 1
        fi
}

StopDB() {

	printf "\nShutting down Postgresql... \n"
	sudo systemctl stop postgresql-13.service
	
	if [[ $? = 0 ]]
        then
	   echo "postgresql-13.service stopped successfully."
	else
	   echo "Failed to stop postgresql-13.service!"
	   exit 1
       fi
}

StopSOLR() {

	printf "\nShutting down solr6... \n"
	sudo systemctl stop solr
	
	if [[ $? = 0 ]]
	then
	  echo "solr6 service stopped successfully."
	else
	  echo "Failed to stop solr6 service!"
	  exit 1
        fi
}

StopAMQ() {
	printf "\nStopping ActiveMQ... \n"
	sudo systemctl stop activemq
	
	if [[ $? = 0 ]]
	then
           echo "activemq service stopped successfully."
	else
	   echo "Failed to stop activemq service!"
	   exit 1
        fi
}


###################################

StopLocalTransformService
StopACS
StopDB
StopSOLR
StopAMQ

###################################
