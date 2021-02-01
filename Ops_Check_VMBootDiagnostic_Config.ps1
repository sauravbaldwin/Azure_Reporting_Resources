Connect-AzAccount
$vmobjs = @()
$Subscriptions = Get-AzSubscription
foreach ($sub in $Subscriptions)
{
    Get-AzSubscription -SubscriptionName $sub.Name | Set-AzContext
$vms = Get-AzVM -Status


foreach ($vm in $vms)
    {
            if($vm.DiagnosticsProfile.BootDiagnostics.Enabled)
        {
            $vmbootconfig=$vm.DiagnosticsProfile.BootDiagnostics.Enabled
            $vmbootconfigstorage=$vm.DiagnosticsProfile.BootDiagnostics.StorageUri
            if($vmbootconfigstorage -eq $null)
                {
                $vmbootconfigstorage="Storage Account set to Managed"
                }
        }
            else
            {
            $vmbootconfig="False"
            $vmbootconfigstorage="Not Applicable"

            }

        $vmInfo = [pscustomobject]@{
                'Name'=$vm.Name
                'ResourceGroupName' = $vm.ResourceGroupName
                'Subscription Name'=$sub.Name
                'VMStatus'=$vm.PowerState
                'Location' = $vm.Location
                'Boot Diagnostics Configuration'=$vmbootconfig
                'Boot Diagnostics Storage Name'=$vmbootconfigstorage
                'VmSize'=$vm.HardwareProfile.VmSize
                'VmId' = $vm.VmId 
                 }
            $vmobjs += $vmInfo
    }
}
$vmobjs | Export-Csv -Path C:\Users\saurav.c.shekhar\Documents\Inventory\VMdiagnostic_Check14012021.csv -NoTypeInformation
Write-Host "VM list with diagnostic details written to the csv file"
Invoke-Item C:\Users\saurav.c.shekhar\Documents\Inventory\VMdiagnostic_Check14012021.csv