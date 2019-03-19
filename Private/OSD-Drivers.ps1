function OSD-Drivers {
    [CmdletBinding()]
    PARAM ()
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: Task Drivers"	-ForegroundColor Green
    if ($Drivers) {
        foreach ($Driver in $Drivers) {
            Write-Host "$OSDBuilderContent\$Driver" -ForegroundColor DarkGray
            if ($OSMajorVersion -eq 6) {
                dism /Image:"$MountDirectory" /Add-Driver /Driver:"$OSDBuilderContent\$Driver" /Recurse /ForceUnsigned /LogPath:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-DISM-Task-Driver.log"
            } else {
                Add-WindowsDriver -Driver "$OSDBuilderContent\$Driver" -Recurse -Path "$MountDirectory" -ForceUnsigned -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Task-Driver.log" | Out-Null
            }
        }
    } else {
        Write-Host "No Task Drivers were processed" -ForegroundColor DarkGray
    }
    
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: Template Drivers"	-ForegroundColor Green
    if ($DriverTemplates) {
        foreach ($Driver in $DriverTemplates) {
            Write-Host "$($Driver.FullName)" -ForegroundColor DarkGray
            if ($OSMajorVersion -eq 6) {
                dism /Image:"$MountDirectory" /Add-Driver /Driver:"$($Driver.FullName)" /Recurse /ForceUnsigned /LogPath:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-DISM-Template-Driver.log"
            } else {
                Add-WindowsDriver -Driver "$($Driver.FullName)" -Recurse -Path "$MountDirectory" -ForceUnsigned -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Template-Driver.log" | Out-Null
            }
        }
    } else {
        Write-Host "No Template Drivers were processed" -ForegroundColor DarkGray
    }
}

function OSD-WinPE-Drivers {
    [CmdletBinding()]
    PARAM ()
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "WinPE: Task WinPE Drivers" -ForegroundColor Green
    if ($WinPEDrivers) {
        foreach ($WinPEDriver in $WinPEDrivers) {
            Write-Host "$OSDBuilderContent\$WinPEDriver" -ForegroundColor DarkGray
            if ($OSMajorVersion -eq 6) {
                dism /Image:"$MountWinPE" /Add-Driver /Driver:"$OSDBuilderContent\$WinPEDriver" /Recurse /ForceUnsigned /LogPath:"$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-DISM-Add-Driver-WinPE.log"
                dism /Image:"$MountWinRE" /Add-Driver /Driver:"$OSDBuilderContent\$WinPEDriver" /Recurse /ForceUnsigned /LogPath:"$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-DISM-Add-Driver-WinRE.log"
                dism /Image:"$MountWinSE" /Add-Driver /Driver:"$OSDBuilderContent\$WinPEDriver" /Recurse /ForceUnsigned /LogPath:"$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-DISM-Add-Driver-WinSE.log"
            } else {
                Add-WindowsDriver -Path "$MountWinPE" -Driver "$OSDBuilderContent\$WinPEDriver" -Recurse -ForceUnsigned -LogPath "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-WindowsDriver-WinPE.log" | Out-Null
                Add-WindowsDriver -Path "$MountWinRE" -Driver "$OSDBuilderContent\$WinPEDriver" -Recurse -ForceUnsigned -LogPath "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-WindowsDriver-WinRE.log" | Out-Null
                Add-WindowsDriver -Path "$MountWinSE" -Driver "$OSDBuilderContent\$WinPEDriver" -Recurse -ForceUnsigned -LogPath "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-WindowsDriver-WinSE.log" | Out-Null
            }
        }
    } else {
        Write-Host "No Task WinPE Drivers were processed" -ForegroundColor DarkGray
    }

<#     Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "WinPE: Template WinPE Drivers" -ForegroundColor Green

    $AOSBDriversWinPE = @()
    $AOSBDriversWinPE = Get-ChildItem ("$OSDBuilderTemplates\DriversWinPE\AutoApply\Global\*","$OSDBuilderTemplates\DriversWinPE\AutoApply\Global $OSArchitecture\*") | Where-Object {$_.PSIsContainer -eq $true} | Select-Object -Property FullName
    if ($ReleaseId -eq 7601) {
        [array]$AOSBDriversWinPE += Get-ChildItem ("$OSDBuilderTemplates\DriversWinPE\AutoApply\WinPE 3\*","$OSDBuilderTemplates\DriversWinPE\AutoApply\WinPE 3 $OSArchitecture\*") | Where-Object {$_.PSIsContainer -eq $true} | Select-Object -Property FullName
    } else {
        if ($OSInstallationType -eq 'Client') {
            [array]$AOSBDriversWinPE += Get-ChildItem ("$OSDBuilderTemplates\DriversWinPE\AutoApply\WinPE 10\*","$OSDBuilderTemplates\DriversWinPE\AutoApply\WinPE 10 $OSArchitecture\*","$OSDBuilderTemplates\DriversWinPE\AutoApply\WinPE 10 $OSArchitecture $ReleaseId\*") | Where-Object {$_.PSIsContainer -eq $true} | Select-Object -Property FullName
        } else {
            [array]$AOSBDriversWinPE += Get-ChildItem ("$OSDBuilderTemplates\DriversWinPE\AutoApply\WinPE Server\*","$OSDBuilderTemplates\DriversWinPE\AutoApply\WinPE Server $ReleaseId\*") | Where-Object {$_.PSIsContainer -eq $true} | Select-Object -Property FullName
        }
    } #>
}