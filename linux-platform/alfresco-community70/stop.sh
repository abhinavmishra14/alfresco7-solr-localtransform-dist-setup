#!/bin/bash

#Order of operation
## - Stop ACS
## - Stop DB
## - Stop Solr

printf "\n------------------------------ Stopping services ------------------------- \n"


#User can pass ALF_HOME path. Defaults to "/usr/local/alfresco-community70".
export ALF_HOME=${1:-"/usr/local/alfresco-community70"}
#User can pass SOLR_HOME path. Defaults to "/usr/local/alfresco-search-services".
export SOLR_HOME=${2:-"/usr/local/alfresco-search-services"}

#Stop pgAdmin4 ?, Default to 'true'
STOP_PGADMIN=${3:-"true"}

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
echo PATH: $PATH
echo SOLR_HOME: $SOLR_HOME
echo ALF_HOME: $ALF_HOME
echo "---------------------------------------------"


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
	   echo "postgresql-11.service stopped successfully."
	else
	   echo "Failed to stop postgresql-13.service!"
	   exit 1
       fi

       if [[ $STOP_PGADMIN == true ]]; then
            # Stop pgAdmin4 as well
	    sudo systemctl stop httpd
	    if [[ $? = 0 ]]
	    then
		echo "pgAdmin4 httpd service stopped successfully."
	    else
		echo "Failed to stop pgAdmin4 httpd service!"
		exit 1
	    fi
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


###################################

StopACS
StopDB
StopSOLR

###################################
