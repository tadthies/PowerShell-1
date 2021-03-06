#*******************************************************************************
#      Author: Mick Pletcher
#        Date: 12 December 2013
#
#     Program: Verify GUIDs
#*******************************************************************************

cls
Set-Variable -Name App -Value $null
Set-Variable -Name File -Force
Set-Variable -Name GUID -Force
Set-Variable -Name RelativePath -Scope Global -Force

$MissingGUIDs = @()
Function GetRelativePath {
	$Global:RelativePath=(split-path $SCRIPT:MyInvocation.MyCommand.Path -parent)+"\"
}

GetRelativePath
$File = Import-Csv -Header GUID1 $Global:RelativePath"GUIDs.txt"
Foreach ($GUID in $File) {
	#Write-Host $GUID.GUID1
	#Get-WmiObject win32_product | Where-Object {$_.IdentifyingNumber -match "{5783F2D7-D004-0409-1102-0060B0CE6BBA}"}
	$App = Get-WmiObject win32_product | Where-Object {$_.IdentifyingNumber -match $GUID.GUID1}
	$App
	If ($App.Name -like "") {
		$MissingGUIDs += $GUID.GUID1
	}
	$App = $null
}
Write-Host
Write-Host "Missing GUIDs"
Write-Host "-------------"
$MissingGUIDs

#Cleanup Global Memory
Remove-Variable -Name App -Force
Remove-Variable -Name File -Force
Remove-Variable -Name GUID -Force
Remove-Variable -Name MissingGUIDs -Force
Remove-Variable -Name RelativePath -Scope Global -Force
