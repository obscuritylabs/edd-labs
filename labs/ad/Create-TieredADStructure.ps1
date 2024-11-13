param (
    [Parameter(Mandatory = $true)]
    [string]$State
)

# Define the domain name for the forest
$domain = "$State.us.local"

# Define the base Admin OU for the state
$OU_Admin = "OU=Admin,DC=$State,DC=us,DC=local"

# Define the base OUs for each tier within the Admin OU of the state's domain
$OU_Tier0 = "OU=Tier 0,$OU_Admin"
$OU_Tier1 = "OU=Tier 1,$OU_Admin"
$OU_Tier2 = "OU=Tier 2,$OU_Admin"

# Helper function to disable deletion protection
function Disable-DeletionProtection($OUPath) {
    $ou = Get-ADOrganizationalUnit -Identity $OUPath
    Set-ADObject -Identity $ou -ProtectedFromAccidentalDeletion $false
}

# Create the top-level Admin OU for the state
New-ADOrganizationalUnit -Name "Admin" -Path "DC=$State,DC=us,DC=local"
Disable-DeletionProtection -OUPath $OU_Admin

# Create base OUs for each tier under the Admin OU
New-ADOrganizationalUnit -Name "Tier 0" -Path $OU_Admin
New-ADOrganizationalUnit -Name "Tier 1" -Path $OU_Admin
New-ADOrganizationalUnit -Name "Tier 2" -Path $OU_Admin

# Disable deletion protection for each tier OU
Disable-DeletionProtection -OUPath $OU_Tier0
Disable-DeletionProtection -OUPath $OU_Tier1
Disable-DeletionProtection -OUPath $OU_Tier2

# Uniform Sub-OUs for Tier 0 under Admin
New-ADOrganizationalUnit -Name "Computers" -Path $OU_Tier0
New-ADOrganizationalUnit -Name "Groups" -Path $OU_Tier0
New-ADOrganizationalUnit -Name "Users" -Path $OU_Tier0

# Disable deletion protection for each Tier 0 sub-OU
Disable-DeletionProtection -OUPath "OU=Computers,$OU_Tier0"
Disable-DeletionProtection -OUPath "OU=Groups,$OU_Tier0"
Disable-DeletionProtection -OUPath "OU=Users,$OU_Tier0"

# Uniform Sub-OUs for Tier 1 under Admin
New-ADOrganizationalUnit -Name "Computers" -Path $OU_Tier1
New-ADOrganizationalUnit -Name "Groups" -Path $OU_Tier1
New-ADOrganizationalUnit -Name "Users" -Path $OU_Tier1

# Disable deletion protection for each Tier 1 sub-OU
Disable-DeletionProtection -OUPath "OU=Computers,$OU_Tier1"
Disable-DeletionProtection -OUPath "OU=Groups,$OU_Tier1"
Disable-DeletionProtection -OUPath "OU=Users,$OU_Tier1"

# Uniform Sub-OUs for Tier 2 under Admin
New-ADOrganizationalUnit -Name "Computers" -Path $OU_Tier2
New-ADOrganizationalUnit -Name "Groups" -Path $OU_Tier2
New-ADOrganizationalUnit -Name "Users" -Path $OU_Tier2

# Disable deletion protection for each Tier 2 sub-OU
Disable-DeletionProtection -OUPath "OU=Computers,$OU_Tier2"
Disable-DeletionProtection -OUPath "OU=Groups,$OU_Tier2"
Disable-DeletionProtection -OUPath "OU=Users,$OU_Tier2"

Write-Output "Tiered OU Structure Created Successfully under the Admin OU for $domain, with deletion protection disabled for all OUs"
