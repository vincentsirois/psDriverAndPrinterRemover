echo "Removing printers..."

$wmilist = Get-WmiObject -class Win32_printer
$psObject = $wmilist | select $wmilist.PSStandardMembers.DefaultDisplayProperySet.References
$problematicPrinters = $psObject | where { $_.Network -eq "True"} | Select DeviceID

Out-File -filepath C:\temp\printDriversLog.txt

ForEach ($printer in $problematicPrinters) {
	echo $printer.DeviceID >> C:\temp\printDriversLog.txt
	rundll32 printui.dll,PrintUIEntry /dn /n$($printer.DeviceID) | Out-Null
}