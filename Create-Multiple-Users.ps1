# Script to create multiple users in specified OUs
# Run this script as a user with permissions to modify Active Directory

# Prompt for the domain name
$domainName = Read-Host "Enter the domain name (e.g., contoso.com)"

# Prompt for the number of users to create
$numUsers = Read-Host "Enter the number of users to create"

# Gather user details from the user
$userDetails = @()

for ($i = 1; $i -le $numUsers; $i++) {
    $userName = Read-Host "Enter the username for user $i"
    $ouName = Read-Host "Enter the OU where user $i should be created (e.g., Sales)"
    $userDetails += [PSCustomObject]@{
        Username = $userName
        OUName   = $ouName
    }
}

# Create users
foreach ($user in $userDetails) {
    $ouPath = "OU=$($user.OUName),DC=$($domainName -replace '\.', ',DC=')"
    $samAccountName = $user.Username
    $userPath = "$ouPath"
    try {
        New-ADUser -Name $samAccountName -SamAccountName $samAccountName -UserPrincipalName "$samAccountName@$domainName" -Path $userPath -AccountPassword (ConvertTo-SecureString "P@ssw0rd!" -AsPlainText -Force) -Enabled $true
        Write-Host "Successfully created user: $samAccountName in OU: $($user.OUName)"
    } catch {
        Write-Host "Error creating user ${samAccountName} - ${_}" -ForegroundColor Red
    }
}
