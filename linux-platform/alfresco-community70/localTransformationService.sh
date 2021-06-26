#!/bin/sh


SERVICE_NAME=Local_Tranfromation_Service
LOCAL_TRANSFORM_SERVICE_HOME=/usr/local/alfresco-community70
PID_PATH_NAME=$LOCAL_TRANSFORM_SERVICE_HOME/Local_Tranfromation_Service-pid 

echo "Process id path: $PID_PATH_NAME"

case $1 in 
start)
  echo "Starting $SERVICE_NAME ..."
  if [ ! -f $PID_PATH_NAME ]; then 
       nohup java -XX:MinRAMPercentage=50 -XX:MaxRAMPercentage=80 -DPDFRENDERER_EXE="$LOCAL_TRANSFORM_SERVICE_HOME/alfresco-pdf-renderer/alfresco-pdf-renderer" -DLIBREOFFICE_HOME="$LOCAL_TRANSFORM_SERVICE_HOME/libreoffice" -DIMAGEMAGICK_ROOT="$LOCAL_TRANSFORM_SERVICE_HOME/imagemagick" -DIMAGEMAGICK_DYN="$LOCAL_TRANSFORM_SERVICE_HOME/imagemagick" -DIMAGEMAGICK_EXE="$LOCAL_TRANSFORM_SERVICE_HOME/imagemagick/convert" -DIMAGEMAGICK_CODERS="$LOCAL_TRANSFORM_SERVICE_HOME/imagemagick/modules-Q16HDRI/coders" -DIMAGEMAGICK_CONFIG="$LOCAL_TRANSFORM_SERVICE_HOME/imagemagick/config-Q16HDRI" -DACTIVEMQ_URL="failover:(tcp://localhost:61616)?timeout=3000" -jar $LOCAL_TRANSFORM_SERVICE_HOME/bin/alfresco-transform-core-aio-boot-2.4.0.jar /tmp 2>> /dev/null >>/dev/null & echo $! > $PID_PATH_NAME  
       printf "\n $SERVICE_NAME started ...\n"         
  else 
       printf "\n $SERVICE_NAME is already running ...\n"
  fi
;;

stop)
  if [ -f $PID_PATH_NAME ]; then
         PID=$(cat $PID_PATH_NAME);
         printf "\n $SERVICE_NAME stoping ... \n" 
         /bin/kill $PID;         
         printf "\n $SERVICE_NAME stopped ...\n" 
         rm $PID_PATH_NAME       
  else          
         printf "\n $SERVICE_NAME is not running ...\n"   
  fi    
;;
    
restart)  
  if [ -f $PID_PATH_NAME ]; then 
      PID=$(cat $PID_PATH_NAME);    
      printf "\n $SERVICE_NAME stopping ...\n" 
      kill $PID           
      printf "\n $SERVICE_NAME stopped ...\n"  
      rm $PID_PATH_NAME     
      printf "\n $SERVICE_NAME starting ...\n"  
      nohup java -XX:MinRAMPercentage=50 -XX:MaxRAMPercentage=80 -DPDFRENDERER_EXE="$LOCAL_TRANSFORM_SERVICE_HOME/alfresco-pdf-renderer/alfresco-pdf-renderer" -DLIBREOFFICE_HOME="$LOCAL_TRANSFORM_SERVICE_HOME/libreoffice" -DIMAGEMAGICK_ROOT="$LOCAL_TRANSFORM_SERVICE_HOME/imagemagick" -DIMAGEMAGICK_DYN="$LOCAL_TRANSFORM_SERVICE_HOME/imagemagick" -DIMAGEMAGICK_EXE="$LOCAL_TRANSFORM_SERVICE_HOME/imagemagick/convert" -DIMAGEMAGICK_CODERS="$LOCAL_TRANSFORM_SERVICE_HOME/imagemagick/modules-Q16HDRI/coders" -DIMAGEMAGICK_CONFIG="$LOCAL_TRANSFORM_SERVICE_HOME/imagemagick/config-Q16HDRI" -DACTIVEMQ_URL="failover:(tcp://localhost:61616)?timeout=3000" -jar $LOCAL_TRANSFORM_SERVICE_HOME/bin/alfresco-transform-core-aio-boot-2.4.0.jar /tmp 2>> /dev/null >>/dev/null & echo $! > $PID_PATH_NAME    
      printf "\n $SERVICE_NAME started ...\n"    
  else           
      printf "\n $SERVICE_NAME is not running ...\n"    
     fi     
 esac
