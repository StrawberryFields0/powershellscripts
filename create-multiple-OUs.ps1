# Script to create multiple OUs
# Run this script as a user with permissions to modify Active Directory

# Prompt for the domain name
$domainName = Read-Host "Enter the domain name (e.g., contoso.com)"

# Prompt for the number of OUs to create
$numOUs = Read-Host "Enter the number of OUs to create"

# Array to store OU names
$ouNames = @()

# Gather OU names from the user
for ($i = 1; $i -le $numOUs; $i++) {
    $ouName = Read-Host "Enter the name of OU $i"
    $ouNames += $ouName
}

# Create OUs
foreach ($ou in $ouNames) {
    $ouPath = "OU=$ou,DC=$($domainName -replace '\.', ',DC=')"
    try {
        New-ADOrganizationalUnit -Name $ou -Path "DC=$($domainName -replace '\.', ',DC=')" -ProtectedFromAccidentalDeletion $true
        Write-Host "Successfully created OU: $ou"
    } catch {
        Write-Host "Error creating OU ${ou} - ${_}" -ForegroundColor Red
    }
}