#Transfering vSphere roles from vCenter1 to vCenter2

$VC1=read-host "vCenter1"
$VC2=read-host "vCenter2"
 
# Set the PowerCLI Configuration to connect to multiple vCenters
Set-PowerCLIConfiguration -DefaultVIServerMode multiple -Confirm:$false
 
# Connect to both the source and destination vCenters
connect-viserver -server $VC1, $VC2
 
# Get roles to transfer
$roles = get-virole -server $VC1
 
# Get role Privileges
foreach ($role in $roles) {
[string[]]$privsforRoleAfromVC1=Get-VIPrivilege -Role (Get-VIRole -Name $role -server $VC1) |%{$_.id}
 
# Create new role in VC2
New-VIRole -name $role -Server $VC2
 
# Add Privileges to new role.
Set-VIRole -role (get-virole -Name $role -Server $VC2) -AddPrivilege (get-viprivilege -id $privsforRoleAfromVC1 -server $VC2)
}
 
disconnect-viserver –server $VC1, $VC2
