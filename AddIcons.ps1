Import-Module activedirectory
$CMC = @("Put groups arrays here")
$JMMC = @("Put groups arrays here")
$SMH = @("Put groups arrays here")
$Trin = @("Put groups arrays here")
$SFHAD = @("Put groups arrays here")
$ADMIN = @("Put groups arrays here")
$option = @("JMMC", "CMC", "SMH", "TRIN", "SFHAD","SISTERS","ADMIN")
$ErrorActionPreference = "SilentlyContinue"
While($true)
	{
$ui = (Read-host -Prompt "Enter Groups
Options: JMMC, CMC, SMH, Trin, SFHAD, Sisters, Admin")
$ui = $ui.ToUpper()
if ($ui -eq [string]::Empty)
	{
	break
	}
elseif ($option -notcontains $ui)
	{
	Write-Host "Try again..."
	continue
	}
if ($ui -eq $option[1])
	{
    $groups = $CMC
	$server = "server.name.1"
	}
elseif ($ui -eq $option[0])
	{
    $groups = $JMMC
	$server = "server.name.1"
	}
elseif ($ui -eq $option[3])
	{
	$groups = $Trinity
	$server = "server.name.1"
	}
elseif ($ui -eq $option[4])
	{
	$groups = $SFHAD
	$server = "server.name.3"
	}
elseif($ui -eq $option[2]) 
	{
	$groups = $SMH
	$server = "server.name.1" 
	}
elseif($ui -eq $option[5])
	{
	$groups = $Trinity 
	$server = "server.name"
	}
elseif ($ui -eq $option[6])
	{
	$groups = $ADMIN
	$server = "server.name"
	}
	While ($true)
		{
		$member=$null
		$name=$null
		$user = (Read-Host -Prompt "Enter ADusername or FullName")
		if ($user -eq [string]::Empty)
		{
		break
		}
		$user = $user.ToLower()
		$name = Get-ADUser -Server $server -Filter {DisplayName -like $user} -Properties *
		$member = Get-ADUser -Server $server -Identity $user -Properties *
		if ($member -ne $null)
		{
		$member | select DisplayName, Title, Department, Division
		
		$ru = (Read-Host -Prompt "Would you like to proceed?(Y/N)")
		$ru = $ru.ToLower()
		if ($ru -eq "y"
		{
			ForEach ($group in $groups)
				{
				Write-Host "Adding $group group"
		    	Add-ADGroupMember -Identity $group -Members $member
				}
				Write-Host ("Groups Added Successfully! Hit enter to quit, or enter another username to add to $ui groups.")
		}
		else
		{
			exit
		}
		}
		if ($name -ne $null)
		{
		$name | select DisplayName, Title, Department, Division
		
		$ru = (Read-Host -Prompt "Would you like to proceed?(Y/N)"
		$ru = $ru.ToLower()
		if ($ru -eq "y")
		{
			ForEach ($group in $groups)
				{
				Write-Host "Adding $group group"
		    	Add-ADGroupMember -Identity $group -Members $name
				}
				Write-Host ("Groups Added Successfully! Hit enter to quit, or enter another FullName to add to $ui groups.")
		}
		else
		{
			exit
		}
		}
	if ($name -eq $null -and $member -eq $null)
		{
			Write-Host "The ADusername or Fullname specified was not found...Try again."
			continue
		}
	}
}
