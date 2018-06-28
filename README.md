# psDriverAndPrinterRemover
psDriverAndPrinterRemover are several small powershell scripts to remove network printers and drivers and add it back. I've first made this script to remove multiple Xerox drivers across multiples computers mainly Windows 10 LTSB and Windows 7 Professional. The main issue we had with Xerox drivers were weird formatting issues when the multiple version of the global print driver were install. All the code is free of charge and can be used as-is.

I've made a batch script to execute the powershell script. All computers have a restricted execution policy on our domain. I always start the batch script as the user account and the script will ask for a domain admin credentials if necessary.

The scripts remove all network printers, then remove all print environnements registry keys and you can then remove the drivers you want via printui and you can finally add back all the printers on the computer.

```
@echo off
Setlocal EnableDelayedExpansion
cls

SET dirPath="\\your\script\path"
SET domain="your.domain"

REM Get Windows Version
for /f "tokens=4-7 delims=[.] " %%i in ('ver') do (if %%i==Version (set v=%%j.%%k) else (set v=%%i.%%j))

IF "%v%" == "10.0" (
   powershell Start-Process powershell.exe -Argument '-Command set-executionpolicy bypass -force' -Verb 'runas'
   SET id=" "
) ELSE (
   SET /p id="Enter domain admin user (%domain% only): "
   RUNAS /user:!id!@%domain% "powershell set-executionpolicy bypass -force"
)

powershell -ExecutionPolicy Bypass -File "%DirPath%\rmPrintDriversMenu.ps1" -a %id% -v %v% -p %DirPath% -d %domain%
```
