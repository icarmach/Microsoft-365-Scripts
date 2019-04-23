Install-Module MSOnline
Import-Module MSOnline

Connect-MsolService

$GroupName = "<Group Name>"
$GroupInfo = Get-MsolGroup | Where-Object {$_.DisplayName -eq $GroupName}

$FilePath = "C:\O365UnlicensedUsers.csv"

Get-MsolUser -All -UnlicensedUsersOnly | Select UserPrincipalName | Export-CSV $FilePath -NoTypeInformation

Import-CSV -Path $FilePath | ForEach { 
	$UPN = $_.UserPrincipalName
	$Users = Get-MsolUser -UserPrincipalName $UPN

	$Users | ForEach {Add-MsolGroupMember -GroupObjectId $GroupInfo.ObjectID -GroupMemberObjectId $Users.ObjectID -GroupMemberType User}
}

rm C:\O365UnlicensedUsers.csv
