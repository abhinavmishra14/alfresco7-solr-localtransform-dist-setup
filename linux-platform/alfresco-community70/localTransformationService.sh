#!/bin/sh


SERVICE_NAME=Local_Tranfromation_Service
PID_PATH_NAME=/usr/local/alfresco-community70/Local_Tranfromation_Service-pid 

echo "Process id path: $PID_PATH_NAME"

case $1 in 
start)
  echo "Starting $SERVICE_NAME ..."
  if [ ! -f $PID_PATH_NAME ]; then 
       nohup java -XX:MinRAMPercentage=50 -XX:MaxRAMPercentage=80 -DPDFRENDERER_EXE="/usr/local/alfresco-community70/alfresco-pdf-renderer/alfresco-pdf-renderer" -DLIBREOFFICE_HOME="/usr/local/alfresco-community70/libreoffice" -DIMAGEMAGICK_ROOT="/usr/local/alfresco-community70/imagemagick" -DIMAGEMAGICK_DYN="/usr/local/alfresco-community70/imagemagick" -DIMAGEMAGICK_EXE="/usr/local/alfresco-community70/imagemagick/convert" -DIMAGEMAGICK_CODERS="/usr/local/alfresco-community70/imagemagick/modules-Q16HDRI/coders" -DIMAGEMAGICK_CONFIG="/usr/local/alfresco-community70/imagemagick/config-Q16HDRI" -DACTIVEMQ_URL="failover:(tcp://localhost:61616)?timeout=3000" -jar /usr/local/alfresco-community70/bin/alfresco-transform-core-aio-boot-2.4.0.jar /tmp 2>> /dev/null >>/dev/null & echo $! > $PID_PATH_NAME  
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
      nohup java -XX:MinRAMPercentage=50 -XX:MaxRAMPercentage=80 -DPDFRENDERER_EXE="/usr/local/alfresco-community70/alfresco-pdf-renderer/alfresco-pdf-renderer" -DLIBREOFFICE_HOME="/usr/local/alfresco-community70/libreoffice" -DIMAGEMAGICK_ROOT="/usr/local/alfresco-community70/imagemagick" -DIMAGEMAGICK_DYN="/usr/local/alfresco-community70/imagemagick" -DIMAGEMAGICK_EXE="/usr/local/alfresco-community70/imagemagick/convert" -DIMAGEMAGICK_CODERS="/usr/local/alfresco-community70/imagemagick/modules-Q16HDRI/coders" -DIMAGEMAGICK_CONFIG="/usr/local/alfresco-community70/imagemagick/config-Q16HDRI" -DACTIVEMQ_URL="failover:(tcp://localhost:61616)?timeout=3000" -jar /usr/local/alfresco-community70/bin/alfresco-transform-core-aio-boot-2.4.0.jar /tmp 2>> /dev/null >>/dev/null & echo $! > $PID_PATH_NAME    
      printf "\n $SERVICE_NAME started ...\n"    
  else           
      printf "\n $SERVICE_NAME is not running ...\n"    
     fi     
 esac
