echo "Adding printers back..."

$printers = (cat C:\temp\printDriversLog.txt)

ForEach ($printer in $printers) {
	rundll32 printui.dll,PrintUIEntry /in /n$($printer) | Out-Null
}