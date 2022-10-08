::判断Unity是否运行中
TASKLIST /V /S localhost /U %username%>tmp_process_list.txt
TYPE tmp_process_list.txt |FIND "Unity.exe"
 
IF ERRORLEVEL 0 (GOTO UNITY_IS_RUNNING)
ELSE (GOTO START_UNITY)
 
:UNITY_IS_RUNNING
::杀掉Unity
TASKKILL /F /IM Unity.exe
::停1秒
PING 127.0.0.1 -n 1 >NUL
GOTO START_UNITY

:START_UNITY
:: 此处执行Unity打包
"D:\software\Unity\2021.1.7f1c1\Editor\Unity.exe" ^
-quit ^
-batchmode ^
-projectPath "E:\UnityProject\UnityDemo" ^
-executeMethod BuildTools.BuildApk ^
-logFile "E:\UnityProject\UnityDemo\output.log" ^
--productName:%1 ^
--version:%2