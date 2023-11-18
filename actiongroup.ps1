Connect-AzAccount

# Ask the user for input
$subscriptionId = Read-Host -Prompt "Input your subscription name/ID"
$resourceGroupName = "ARTS-SubBudget"
$location = "Central India"
$locationActionGroup = "Global"
$countryCode= "91"
$contactNumber = Read-Host -Prompt "Input your contact number (Example: 987654321)"
$actionGroupName = "SubAlert"
$actionGroupShortName = "SubAlert"
$emailId = "dsunkari@microsoft.com"
$emailalertname= "SubBudgetAlert"
$smsalertname= "SubBudgetSMS"

# Connect to your Azure account
Connect-AzAccount -Subscription $subscriptionId

# Check if the resource group exists, and create it if not
if (-not (Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue)) {
    New-AzResourceGroup -Name $resourceGroupName -Location $location
    $createdResourceGroup = Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue

    if ($createdResourceGroup) {
        Write-Output "Resource group '$resourceGroupName' created in location '$location'."
    } else {
        Write-Output "Failed to create resource group '$resourceGroupName'."
    }
} else {
    Write-Output "Resource group '$resourceGroupName' already exists."
}

$email = New-AzActionGroupEmailReceiverObject -Name $emailalertname -EmailAddress $emailID

$sms = New-AzActionGroupSmsReceiverObject -Name $smsalertname -CountryCode $countryCode -PhoneNumber $contactNumber

# Define the action group properties
$actionGroupEmailProperties = @{
    "GroupShortName" = $actionGroupShortName
    "EmailReceiver" = $email
}

$actionGroupSmsProperties = @{
    "GroupShortName" = $actionGroupShortName
    "ContactReceiver" = $sms
}

# Create the Azure Action Group
$actionGroup = New-AzActionGroup -Location $locationActionGroup -ResourceGroupName $resourceGroupName -Name $actionGroupName -ShortName $actionGroupShortName -EmailReceiver $email -SmsReceiver $sms -Debug

if ($actionGroup) {
    Write-Output "Azure Action Group '$actionGroupName' created in resource group '$resourceGroupName'."
    Write-Output "Action Group Resource ID: $($actionGroup.Id)"
} else {
    Write-Output "Failed to create Azure Action Group '$actionGroupName' in resource group '$resourceGroupName'."
}
