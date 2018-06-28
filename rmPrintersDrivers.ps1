Write-Warning "Stopping print spooler..."
sc stop spooler

Write-Warning "Exporting current print environments registry keys..."
Start-Process Regedit.exe -ArgumentList '/E /s C:\temp\printEnvironments.reg "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Print\Environments\Windows x64\Print Processors"' -wait | Out-Null

Write-Warning "Removing print environments registry keys..."
Start-Process REG -ArgumentList 'delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Print\Environments\Windows x64\Print Processors" /f' -wait | Out-Null

timeout 2

Write-Warning "Starting print spooler..."
sc start spooler

Write-Warning "Starting PrintUI to remove drivers. Please select to remove the driver AND package of the printer."
Start-Process printui -ArgumentList '/s /t2' -wait | Out-Null

Write-Warning "Stopping print spooler..."
sc stop spooler

Start-Process Regedit.exe -ArgumentList '/S C:\temp\printEnvironments.reg' -wait | Out-Null

Write-Warning "Starting print spooler..."
sc start spooler

Write-Warning "Process completed."
timeout 2