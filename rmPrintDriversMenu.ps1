param (
    [string]$admin = $(throw "-a is required."),
	[string]$version = $(throw "-v is required."),
	[string]$path = $(throw "-p is required."),
	[string]$domain = $(throw "-d is required.")
)

$fcolor = $host.UI.RawUI.ForegroundColor
$bcolor = $host.UI.RawUI.BackgroundColor

function DrawMenu {
    param ($menuItems, $menuPosition, $menuTitel)
    $l = $menuItems.length + 1
    cls
    $menuwidth = $menuTitel.length + 4
    Write-Host "" -NoNewLine
    Write-Host "$menuTitel :" -fore $fcolor -back $bcolor
    Write-Host "" -NoNewLine
    Write-Host ""
    Write-debug "L: $l MenuItems: $menuItems MenuPosition: $menuposition"
    for ($i = 0; $i -le $l;$i++) {
        Write-Host "" -NoNewLine
        if ($i -eq $menuPosition) {
            Write-Host "$($menuItems[$i])" -fore $bcolor -back $fcolor
        } else {
            Write-Host "$($menuItems[$i])" -fore $fcolor -back $bcolor
        }
    }
}

function Menu {
    param ([array]$menuItems, $menuTitel = "MENU")
    $vkeycode = 0
    $pos = 0
    DrawMenu $menuItems $pos $menuTitel
    While ($vkeycode -ne 13) {
        $press = $host.ui.rawui.readkey("NoEcho,IncludeKeyDown")
        $vkeycode = $press.virtualkeycode
        Write-host "$($press.character)" -NoNewLine
        If ($vkeycode -eq 38) {$pos--}
        If ($vkeycode -eq 40) {$pos++}
        if ($pos -lt 0) {$pos = 0}
        if ($pos -ge $menuItems.length) {$pos = $menuItems.length -1}
        DrawMenu $menuItems $pos $menuTitel
    }
    Write-Output $($menuItems[$pos])
}

function Main {
	Do {
		$MainMenu = "1) Remove printers","2) Remove driver","3) Add printers back","4) Cleanup and exit"
		$selection = Menu $MainMenu "Select a command."

		if($selection -eq "1) Remove printers") {
			powershell -File "$($path)/rmNetworkPrinters.ps1"
		}

		if($selection -eq "2) Remove driver") {
			if($version -eq "10.0") {
				Start-Process powershell -Argument '-File $($path)/rmPrintersDrivers.ps1' -Verb 'runas'
			} else {
				cmd /C "runas /user:$($admin)@$($domain) "powershell -File \"$($path)/rmPrintersDrivers.ps1"""
			}
		}

		if($selection -eq "3) Add printers back") {
			powershell -File "$($path)/addNetworkPrintersBack.ps1"
		}
		
		if($selection -eq "4) Cleanup and exit") {
			powershell -File "$($path)/rmPrintDriversCleanup.ps1" -d "$($domain)" -a "$($admin)"
		}
	} while ($selection -ne "4) Cleanup and exit")
}

Main