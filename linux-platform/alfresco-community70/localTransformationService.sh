#!/bin/sh

SERVICE_NAME=Local_Tranfromation_Service 
PATH_TO_JAR=$ALF_HOME/bin/alfresco-transform-core-aio-boot-2.4.0.jar
PID_PATH_NAME=/tmp/Local_Tranfromation_Service-pid 
case $1 in 
start)
       echo "Starting $SERVICE_NAME ..."
  if [ ! -f $PID_PATH_NAME ]; then 
       nohup java -XX:MinRAMPercentage=50 -XX:MaxRAMPercentage=80 -DPDFRENDERER_EXE="$ALF_HOME/alfresco-pdf-renderer/alfresco-pdf-renderer" -DLIBREOFFICE_HOME="$ALF_HOME/libreoffice" -DIMAGEMAGICK_ROOT="$ALF_HOME/imagemagick" -DIMAGEMAGICK_DYN="$ALF_HOME/imagemagick" -DIMAGEMAGICK_EXE="$ALF_HOME/imagemagick/convert" -DIMAGEMAGICK_CODERS="$ALF_HOME/imagemagick/modules-Q16HDRI/coders" -DIMAGEMAGICK_CONFIG="$ALF_HOME/imagemagick/config-Q16HDRI" -DACTIVEMQ_URL=failover:(tcp://localhost:61616)?timeout=3000 -jar $PATH_TO_JAR /tmp 2>> /dev/null >>/dev/null & echo $! > $PID_PATH_NAME  
       echo "$SERVICE_NAME started ..."         
  else 
       echo "$SERVICE_NAME is already running ..."
  fi
;;
stop)
  if [ -f $PID_PATH_NAME ]; then
         PID=$(cat $PID_PATH_NAME);
         echo "$SERVICE_NAME stoping ..." 
         /bin/kill $PID;         
         echo "$SERVICE_NAME stopped ..." 
         rm $PID_PATH_NAME       
  else          
         echo "$SERVICE_NAME is not running ..."   
  fi    
;;    
restart)  
  if [ -f $PID_PATH_NAME ]; then 
      PID=$(cat $PID_PATH_NAME);    
      echo "$SERVICE_NAME stopping ..." 
      kill $PID           
      echo "$SERVICE_NAME stopped ..."  
      rm $PID_PATH_NAME     
      echo "$SERVICE_NAME starting ..."  
      nohup java -XX:MinRAMPercentage=50 -XX:MaxRAMPercentage=80 -DPDFRENDERER_EXE="$ALF_HOME/alfresco-pdf-renderer/alfresco-pdf-renderer" -DLIBREOFFICE_HOME="$ALF_HOME/libreoffice" -DIMAGEMAGICK_ROOT="$ALF_HOME/imagemagick" -DIMAGEMAGICK_DYN="$ALF_HOME/imagemagick" -DIMAGEMAGICK_EXE="$ALF_HOME/imagemagick/convert" -DIMAGEMAGICK_CODERS="$ALF_HOME/imagemagick/modules-Q16HDRI/coders" -DIMAGEMAGICK_CONFIG="$ALF_HOME/imagemagick/config-Q16HDRI" -DACTIVEMQ_URL=failover:(tcp://localhost:61616)?timeout=3000 -jar $PATH_TO_JAR /tmp 2>> /dev/null >>/dev/null & echo $! > $PID_PATH_NAME    
      echo "$SERVICE_NAME started ..."    
  else           
      echo "$SERVICE_NAME is not running ..."    
     fi     
 esac