param (
	[string]$version = $(throw "-v is required.")
)

$vkeycode=""
Write-Host "Every logs will be deleted as well as the backup registry print environements registry keys. Please verify that everything is working correctly then press [ENTER]"
While ($vkeycode -ne 13) {
	$press = $host.ui.rawui.readkey("NoEcho,IncludeKeyDown")
	$vkeycode = $press.virtualkeycode
}

if(Test-Path C:\Temp\printEnvironments.reg) {
	rm C:\Temp\printEnvironments.reg
}

if(Test-Path C:\Temp\printEnvironments.reg) {
	rm C:\Temp\printDriversLog.txt
}

if($version -eq "10.0") {
	Start-Process powershell.exe -Argument '-Command Set-ExecutionPolicy -ExecutionPolicy Undefined' -Verb 'runas' 
} else {
	$cmd = '/C runas /user:{0}@{1} "powershell -noexit Set-ExecutionPolicy -ExecutionPolicy Undefined -force"' -f $admin, $domain
	Start-Process cmd -ArgumentList "$($cmd)"
}

