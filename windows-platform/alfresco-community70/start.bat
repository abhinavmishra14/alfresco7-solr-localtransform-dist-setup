@echo off

ECHO ################ Starting ACS, DB, Local Transformation Service and Solr Services ##############
ECHO.


SET ALF_INSTALL_PATH=%1
SET SOLR_INSTALL_PATH=%2
SET POSTGRES_INSTALL_PATH=%3

:init
	IF "%~1" == "" (
	   SET ALF_INSTALL_PATH=C:\\alfresco-community70
	)
	
	IF "%~2" == "" (
		SET SOLR_INSTALL_PATH=C:\\alfresco-search-services
	)
	
	IF "%~3" == "" (
		SET POSTGRES_INSTALL_PATH=C:\\PostgreSQL\\13
	)
	
	goto startAMQLocal

:startAMQLocal
    echo.
	echo Starting Active MQ service ...
	start "ActiveMQ" /MIN cmd /c %ALF_INSTALL_PATH%\activemq\bin\win64\activemq.bat start
	timeout 10
    if errorlevel 1 (goto end) else (goto startTrServLocal)
	
	
:startTrServLocal
    echo.
	echo Starting Local transformation service..
	start "localTransformationService" java -DPDFRENDERER_EXE="%ALF_INSTALL_PATH%\\alfresco-pdf-renderer\\alfresco-pdf-renderer.exe"^
		-DLIBREOFFICE_HOME="%ALF_INSTALL_PATH%\\libreoffice"^
		-DIMAGEMAGICK_ROOT="%ALF_INSTALL_PATH%\\imagemagick\\ImageMagick-7.1.0-Q16-HDRI"^
		-DIMAGEMAGICK_DYN="%ALF_INSTALL_PATH%\\imagemagick\\ImageMagick-7.1.0-Q16-HDRI"^
		-DIMAGEMAGICK_CODERS="%ALF_INSTALL_PATH%\\imagemagick\\ImageMagick-7.1.0-Q16-HDRI\\modules\\coders"^
		-DIMAGEMAGICK_CONFIG="%ALF_INSTALL_PATH%\\imagemagick\\ImageMagick-7.1.0-Q16-HDRI"^
		-DIMAGEMAGICK_EXE="%ALF_INSTALL_PATH%\\imagemagick\\ImageMagick-7.1.0-Q16-HDRI\\convert.exe"^
		-DACTIVEMQ_URL=failover:(tcp://localhost:61616)?timeout=3000^
		-jar %ALF_INSTALL_PATH%\\bin\\alfresco-transform-core-aio-boot-2.4.0.jar
		
	timeout 10

    if errorlevel 1 (goto end) else (goto startDB)
	
:startDB
	echo Starting DB...
	:: Using the windows service to start the db.
	:: net start postgresql-x64-13
	REM You can also use this command, if there is any issue with permission elevation on windows
	%POSTGRES_INSTALL_PATH%\bin\pg_ctl.exe restart -D "%POSTGRES_INSTALL_PATH%\data"
	if errorlevel 1 (goto end) else (goto startACS)

:startACS
	echo.
	echo Starting ACS...
	SET CATALINA_HOME=%ALF_INSTALL_PATH%\tomcat
	start "Tomcat" /MIN /WAIT cmd /c %ALF_INSTALL_PATH%\tomcat\bin\catalina.bat start 
	if errorlevel 1 (goto end) else (goto startSolr)
	
:startSolr
	echo.
	set "initial=false"

	:: check if cores exists
	echo.
	set "initial=false"
	CD %SOLR_INSTALL_PATH%\solrhome
	:: check if cores exists
	
	set Exts=alfresco archive
	for %%A in (%Exts%) do (
	  echo Checking core: %%A
	  if not exist %%A\NUL (
		echo %%A doesn't exist
	    set "initial=true"
	  ) else (
		echo %%A already exist
		set "initial=false"
	  )
	)

	CD %ALF_INSTALL_PATH%
	if "%initial%" == "true" (
		GOTO startSolrInitial
	) else (
		GOTO startSolrConsecutive
	)

:startSolrInitial
	echo.
	echo Starting SOLR for the first time, alfresco and archive cores will be created...	
	start "SOLR6" /MIN /WAIT cmd /c %SOLR_INSTALL_PATH%\solr\bin\solr.cmd start -a "-Dcreate.alfresco.defaults=alfresco,archive"
	if errorlevel 1 (goto end)
	
:startSolrConsecutive
	echo.
	echo Starting SOLR...
	start "SOLR6" /MIN /WAIT cmd /c %SOLR_INSTALL_PATH%\solr\bin\solr.cmd start
	if errorlevel 1 (goto end)
	

:end
	echo.
    echo Exiting..
	timeout 10