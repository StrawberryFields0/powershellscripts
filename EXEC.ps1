# Define the path to the JSON file
$jsonPath = "$env:USERPROFILE\Desktop\users.json"

# Check if the JSON file exists
if (-Not (Test-Path -Path $jsonPath)) {
    Write-Host "JSON file not found at: $jsonPath" -ForegroundColor Red
    exit
}

# Import the JSON file
$users = Get-Content -Path $jsonPath | ConvertFrom-Json

# Iterate through each user in the JSON data
foreach ($user in $users) {
    # Extract username and OU
    $username = $user.Username
    $ouName = $user.OU

    # Construct the OU path
    $ouPath = "OU=$ouName,DC=LTG1,DC=local"  

    try {
        # Create the new user in the specified OU
        New-ADUser -Name $username `
                   -SamAccountName $username `
                   -UserPrincipalName "$username@LTG1.local" `
                   -Path $ouPath `
                   -AccountPassword (ConvertTo-SecureString "P@ssw0rd!" -AsPlainText -Force) `
                   -Enabled $true

        Write-Host "Successfully created user: $username in OU: $ouName" -ForegroundColor Green
    } catch {
        # Handle any errors during user creation
        Write-Host "Error creating user: $username in OU: $ouName - $_" -ForegroundColor Red
    }
}
