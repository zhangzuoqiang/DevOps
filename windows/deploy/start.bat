set SERVER_NAME=RMProxyServer
set VERSION=11.0.0
SET MIN=110_20140711
set IP=192.168.20.196
set USER=administrator 
set PASSWORD=zdsoft

set BASR_DIR=C:\WXBServer
set CURR_DIR=%cd%

rem RMProxyServerSetup110_20140711
set TIME=%date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%%time:~6,2%


echo ����c:\download%TIME%.bat�ļ�
echo cd c:\  > c:\download%TIME%.bat
echo rmdir /q /s deploy  >> c:\download%TIME%.bat
echo mkdir deploy >>c:\download%TIME%.bat
echo cd deploy>>c:\download%TIME%.bat
echo wget ftp://down:winupon.zdsoft.123@deploy.winupon.com//products/ap/vizpower/%VERSION%/server/%RMProxyServer%Setup%MIN%.exe >> c:\download%TIME%.bat

echo '============================'

echo ����c:\deploy%TIME%.bat�ļ�
echo net stop %SERVER_NAME% >> c:\deploy%TIME%.bat
echo c:\deploy\RMProxyServerSetup110_20140711.exe /S /v/qn >> c:\deploy%TIME%.bat
echo %BASR_DIR%\%SERVER_NAME%\RMRecordServer /UnregServer >> c:\deploy%TIME%.bat
echo %BASR_DIR%\%SERVER_NAME%\RMRecordServer /Service >> c:\deploy%TIME%.bat
echo net start %SERVER_NAME% >>c:\deploy%TIME%.bat

echo '============================'

echo ��ʼԶ��ִ��download.bat �ű�
%CURR_DIR%\PsExec.exe \\%IP% -u %USER% -p %PASSWORD% -c c:\download%TIME%.bat

echo ��ʼԶ��ִ��deploy.bat�ű�
%CURR_DIR%\PsExec.exe \\%IP% -u %USER% -p %PASSWORD% -c c:\deploy%TIME%.bat

del c:\download%TIME%.bat
del c:\deploy%TIME%.bat
cd ..
pause