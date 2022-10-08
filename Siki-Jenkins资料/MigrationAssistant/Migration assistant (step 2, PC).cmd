@setlocal enableextensions enabledelayedexpansion
@echo off

set REQUIRED_SPACE=50 Mb
set MY_PATH=%~dp0
set INFILE_SDK=%MY_PATH%SDK.zip
set INFILE_KEYCHAIN=%MY_PATH%Keychain.zip
set LOCKFNAME=migration-assistant.lock
set LOCKFILE=%MY_PATH%%LOCKFNAME%

if exist "!LOCKFILE!" (
	echo.
	echo -------------------------------------------------------------------------------
	echo Looks like the migration assistant is already running. Why not let it finish?
	echo If it's not, please delete the "!LOCKFNAME!" file on your USB key
	echo and run this script again.
	echo -------------------------------------------------------------------------------
	echo.
	pause > nul
	exit 1
)
if not exist "!INFILE_SDK!" (
	echo.
	echo The iOS SDK was not found on your USB key.
	echo.
	echo It looks like the migration assistant ^(step 1^) has not been run on Mac yet.
	echo.
	echo Please move the 2 assistant files on a USB key with at least %REQUIRED_SPACE% free on it,
	echo and run the first script ^(step 1^) on your Mac.
	echo.
	echo Press any key to close this window.
	pause > nul
	exit 1
)
if "_%IOSBUILDENV_PATH%_"=="__" if "_%IOSUNITYBUILDER_PATH%_"=="__" (
	echo.
	echo Neither the IOSBUILDENV_PATH nor the IOSUNITYBUILDER_PATH environment
	echo variables are set.
	echo.
	echo It looks like the iOS builder product package was not completely installed.
	echo.
	echo Please reinstall it thoroughly and run this script again.
	echo.
	echo Press any key to close this window.
	pause > nul
	exit 1
)
if not exist "%IOSBUILDENV_PATH%\Toolchain\plconvert.exe" if not exist "%IOSUNITYBUILDER_PATH%\Toolchain\plconvert.exe" (
	echo.
	echo No iOS toolchain was found.
	echo.
	echo It looks like the iOS builder product package was not completely installed,
	echo or was incorrectly uninstalled.
	echo.
	echo Please reinstall it thoroughly and run this script again.
	echo.
	echo Press any key to close this window.
	pause > nul
	exit 1
)

echo.
echo -------------------------------------------------------------------------------
echo Welcome again^! For this second step, we copy the files from the iOS SDK that we
echo collected on your USB key into place, so that the iOS builder can find them.
echo -------------------------------------------------------------------------------

echo. > "!LOCKFILE!"

echo.
echo Final step. Unpacking the SDK...
echo             This WILL take a while, so please wait...
echo             (a message will be displayed at the end of the process)
if not "_%IOSUNITYBUILDER_PATH%_"=="__" if exist "%IOSUNITYBUILDER_PATH%\Toolchain\plconvert.exe" (
	rmdir /s /q "%IOSUNITYBUILDER_PATH%\SDK" > nul 2>&1
	mkdir "%IOSUNITYBUILDER_PATH%\SDK" > nul 2>&1
	"%IOSUNITYBUILDER_PATH%\Toolchain\unzip" -oqq "!INFILE_SDK!" -d "%IOSUNITYBUILDER_PATH%\SDK"
	"%IOSUNITYBUILDER_PATH%\Toolchain\plconvert" "%IOSUNITYBUILDER_PATH%\SDK\Info.plist" "%IOSUNITYBUILDER_PATH%\SDK\Info.plist" "-AdditionalInfo=string:"
	echo DO NOT PUT ANYTHING ELSE IN THIS DIRECTORY>                               "%IOSUNITYBUILDER_PATH%\SDK\DO NOT PUT ANYTHING ELSE IN THIS DIRECTORY.txt"
	echo ------------------------------------------>>                              "%IOSUNITYBUILDER_PATH%\SDK\DO NOT PUT ANYTHING ELSE IN THIS DIRECTORY.txt"
	echo The iOS SDK directory must reflect the EXACT state of what's available>>  "%IOSUNITYBUILDER_PATH%\SDK\DO NOT PUT ANYTHING ELSE IN THIS DIRECTORY.txt"
	echo on a stock iOS system. Adding or deleting extra frameworks by hand in>>   "%IOSUNITYBUILDER_PATH%\SDK\DO NOT PUT ANYTHING ELSE IN THIS DIRECTORY.txt"
	echo this directory will just corrupt your SDK and make it unusable. Please>>  "%IOSUNITYBUILDER_PATH%\SDK\DO NOT PUT ANYTHING ELSE IN THIS DIRECTORY.txt"
	echo READ the documentation on how to specify extra libraries or frameworks.>> "%IOSUNITYBUILDER_PATH%\SDK\DO NOT PUT ANYTHING ELSE IN THIS DIRECTORY.txt"
	copy /Y "%IOSUNITYBUILDER_PATH%\SDK\DO NOT PUT ANYTHING ELSE IN THIS DIRECTORY.txt" "%IOSUNITYBUILDER_PATH%\SDK\System\Library\Frameworks" > nul
	if exist "!INFILE_KEYCHAIN!" "%IOSUNITYBUILDER_PATH%\Toolchain\unzip" -oqq "!INFILE_KEYCHAIN!" -d "%IOSUNITYBUILDER_PATH%\Keychain"

	rem // new iOS SDK == empty compiler caches
	rmdir /s /q "%IOSUNITYBUILDER_PATH%\Toolchain\.ccache" > nul 2>&1
	rmdir /s /q "%IOSUNITYBUILDER_PATH%\Toolchain\.llvm-modules" > nul 2>&1
)
if not "_%IOSBUILDENV_PATH%_"=="__" if exist "%IOSBUILDENV_PATH%\Toolchain\plconvert.exe" (
	rmdir /s /q "%IOSBUILDENV_PATH%\SDK" > nul 2>&1
	mkdir "%IOSBUILDENV_PATH%\SDK" > nul 2>&1
	"%IOSBUILDENV_PATH%\Toolchain\unzip" -oqq "!INFILE_SDK!" -d "%IOSBUILDENV_PATH%\SDK"
	"%IOSBUILDENV_PATH%\Toolchain\plconvert" "%IOSBUILDENV_PATH%\SDK\Info.plist" "%IOSBUILDENV_PATH%\SDK\Info.plist" "-AdditionalInfo=string:"
	echo DO NOT PUT ANYTHING ELSE IN THIS DIRECTORY>                               "%IOSBUILDENV_PATH%\SDK\DO NOT PUT ANYTHING ELSE IN THIS DIRECTORY.txt"
	echo ------------------------------------------>>                              "%IOSBUILDENV_PATH%\SDK\DO NOT PUT ANYTHING ELSE IN THIS DIRECTORY.txt"
	echo The iOS SDK directory must reflect the EXACT state of what's available>>  "%IOSBUILDENV_PATH%\SDK\DO NOT PUT ANYTHING ELSE IN THIS DIRECTORY.txt"
	echo on a stock iOS system. Adding or deleting extra frameworks by hand in>>   "%IOSBUILDENV_PATH%\SDK\DO NOT PUT ANYTHING ELSE IN THIS DIRECTORY.txt"
	echo this directory will just corrupt your SDK and make it unusable. Please>>  "%IOSBUILDENV_PATH%\SDK\DO NOT PUT ANYTHING ELSE IN THIS DIRECTORY.txt"
	echo READ the documentation on how to specify extra libraries or frameworks.>> "%IOSBUILDENV_PATH%\SDK\DO NOT PUT ANYTHING ELSE IN THIS DIRECTORY.txt"
	copy /Y "%IOSBUILDENV_PATH%\SDK\DO NOT PUT ANYTHING ELSE IN THIS DIRECTORY.txt" "%IOSBUILDENV_PATH%\SDK\System\Library\Frameworks" > nul
	if exist "!INFILE_KEYCHAIN!" "%IOSBUILDENV_PATH%\Toolchain\unzip" -oqq "!INFILE_KEYCHAIN!" -d "%IOSBUILDENV_PATH%\Keychain"

	rem // new iOS SDK == empty compiler caches
	rmdir /s /q "%IOSBUILDENV_PATH%\Toolchain\.ccache" > nul 2>&1
	rmdir /s /q "%IOSBUILDENV_PATH%\Toolchain\.llvm-modules" > nul 2>&1
)
del /f /q "!LOCKFILE!" > nul 2>&1

echo.
echo -------------------------------------------------------------------------------
echo Finished.
echo The iOS SDK is now in place. You can now build iOS projects.
echo Press any key to close this window.
echo -------------------------------------------------------------------------------

pause > nul
exit 0
