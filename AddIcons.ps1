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
	
elseif ($ui -eq $option[3])
	{
	$groups = $Trin
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
	$groups = $Trin 
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
		if ($user -match ".\w\s.\w") #FirstName LastName
		{
			$member = Get-ADUser -Server $server -Filter {DisplayName -like $user} -Properties *
		}
		elseif ($user -match ".\w,\s.\w") #LastName, FirstName
		{
			$member = Get-ADUser -Server $server -Filter {DisplayName -like $user} -Properties *
		}
		elseif ($user -match ".\w\s[a-zA-Z]{1}\..\w") #First M. Last
		{
			$member = Get-ADUser -Server $server -Filter {DisplayName -like $user} -Properties *
		}
		elseif ($user -match "[a-zA-Z]{1}\d") #Wheaton IDs one letter and 6 numbers
		{
			$member = Get-ADUser -Server $server -Identity $user -Properties *
		}
		elseif ($user -match "[a-zA-z]{4}[0-9]{4}") #4x4
		{
			$member = Get-ADUser -Server $server -Identity $user -Properties *
		}
		elseif  ($user -match "[a-zA-z]{7}") #ShortName
		{
			$member = Get-ADUser -Server $server -Identity $user -Properties *
		}
		if ($member -ne $null)
		{
		$member | select DisplayName, Title, Department, Division
		#ForEach ($group in $groups) # Loop Through each group and find the members
		#		{
		#			$ismember = Get-ADGroup $group -Properties Member | Select-Object -ExpandProperty Member | Get-ADUser | Select SamAccountname
		#			If ($ismember -contains $member)
		#			{
		#				Write-Host "$user is already a member of $group"
		#				
		#			}
		#			else 
		#			{
		#				Write-Host "$user is not a member of $group"
		#			}
		#		}
		#				
		$ru = (Read-Host -Prompt "Would you like to proceed?(Y/N)")
		$ru = $ru.ToLower()
		if ($ru -like 'y*')
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
	if ($member -eq $null)
		{
			Write-Host "The ADusername or Fullname specified was not found...Try again."
			continue
		}
	}
}
