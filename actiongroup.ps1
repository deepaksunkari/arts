Connect-AzAccount

$subcriptionID= Read-Host -Prompt "Input your subscription name/ID"

$resourceGroupName= Read-Host -Prompt "Input the Resource Group name where you will create action group in few minutes"
$location= Read-Host -Prompt "Input the location for the Resource Group"
$actionGroupName= Read-Host -Prompt "Input a name less than 12 characters using lowercase for action group"
$actionshortName= Read-Host -Prompt "Input a name less than 12 characters using lowercase for action group display name"
$emailalertname= Read-Host -Prompt "Input a display name for email notification alert"
$smsalertname= Read-Host -Prompt "Input a display name for sms notification alert"
$emailID= Read-Host -Prompt "Input your email and managers ID as example: dsunkari@microsoft.com"
$countryCode= Read-Host -Prompt "Input your mobile country code. ex: 91"
$contactnumber= Read-Host -Prompt "Input your contact number"

select-AzSubscription -Subscription "$subcriptionID"

New-AzResourceGroup -Name $resourceGroupName -Location $location

$email = New-AzActionGroupReceiver -Name $emailalertname -EmailReceiver -EmailAddress $emailID

$sms = New-AzActionGroupReceiver -Name $smsalertname -SmsReceiver -CountryCode $countryCode -PhoneNumber $contactnumber

Set-AzActionGroup -ResourceGroupName $resourceGroupName -Name $actionGroupName -ShortName $actionshortName -Receiver $email, $sms -Debug

$ActionGroupId= (Get-AzActionGroup -ResourceGroupName $resourceGroupName -Name $actionGroupName).Id
Write-Host "$ActionGroupId"
#Set-AzureRmActionGroup -Name $actionGroupName -ResourceGroupName $resourceGroupName -ShortName $actionshortName -Receiver $email,$sms