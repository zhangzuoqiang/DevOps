title  网校部署 %date% author:hzchenkj
@echo off
set SERVER_NAME=RMProxyServer
set VERSION=11.0.0
SET MIN=110_20140711


set BASR_DIR=C:\WXBServer
set CURR_DIR=%cd%

rem RMProxyServerSetup110_20140711
set TIME=%date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%%time:~6,2%


echo 创建c:\download%TIME%.bat文件
echo cd c:\  > %CURR_DIR%\download%TIME%.bat
echo rmdir /q /s deploy  >> %CURR_DIR%\download%TIME%.bat
echo mkdir deploy >>%CURR_DIR%\download%TIME%.bat
echo cd deploy>>%CURR_DIR%\download%TIME%.bat
echo wget ftp://down:winupon.zdsoft.123@deploy.winupon.com//products/ap/vizpower/%VERSION%/server/%SERVER_NAME%Setup%MIN%.exe >> %CURR_DIR%\download%TIME%.bat

echo '============================'

echo 创建c:\deploy%TIME%.bat文件
echo net stop %SERVER_NAME% >> %CURR_DIR%\deploy%TIME%.bat
echo C:\deploy\%SERVER_NAME%Setup%MIN%.exe /S /v/qn >> %CURR_DIR%\deploy%TIME%.bat
echo %BASR_DIR%\%SERVER_NAME%\RMRecordServer /UnregServer >> %CURR_DIR%\deploy%TIME%.bat
echo %BASR_DIR%\%SERVER_NAME%\RMRecordServer /Service >> %CURR_DIR%\deploy%TIME%.bat
echo net start %SERVER_NAME% >>%CURR_DIR%\deploy%TIME%.bat

echo '============================'

echo 开始远程执行download.bat 脚本
echo 开始远程执行deploy.bat脚本

for /f "tokens=1,2,3,4,5,6 delims= " %%a in ( server.txt) do (


        echo ===ip:%%a user:%%b password:%%c type:%%d====

	echo %CURR_DIR%\PsExec.exe \\%%a -u %%b -p %%c -c %CURR_DIR%\download%TIME%.bat
%CURR_DIR%\PsExec.exe \\%%a -u %%b -p %%c -c %CURR_DIR%\download%TIME%.bat
rem %CURR_DIR%\PsExec.exe \\%%a -u %%b -p %%c -c %CURR_DIR%\deploy%TIME%.bat

)


del %CURR_DIR%\download%TIME%.bat
del %CURR_DIR%\deploy%TIME%.bat

pause