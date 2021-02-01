#This script should be used for each subscription manually
$Subscriptions = Get-AzSubscription
foreach ($sub in $Subscriptions)
{
    Get-AzSubscription -SubscriptionName $sub.Name | Set-AzContext

    $Resources = Get-AzResource

    foreach ($r in $Resources)
    {
       $item = New-Object -TypeName PSObject -Property @{
                    Name = $r.Name
                    ResourceType = $r.ResourceType
                    ResourceGroupName = $r.ResourceGroupName
                    } | Select-Object Name,  ResourceType, ResourceGroupName

        if ($item.ResourceType -eq "Microsoft.Storage/storageAccounts")
          {
              $string = "Processing ARM storage account: " + $item.Name
              Write-Output $string
              $Ctx = Get-AzStorageAccount –StorageAccountName $item.Name -ResourceGroupName $item.ResourceGroupName
     
              # Get all the containers
              $containerList = Get-AzStorageContainer -Context $Ctx.Context -MaxCount 2147483647  

              foreach ($c in $containerList)
              {
                  $containerItem = New-Object -TypeName PSObject -Property @{
                                     Name = $c.Name
                                     PublicAccess = $c.PublicAccess
                                     } | Select-Object Name,  PublicAccess
       
                  # Test each for public
                  if ($containerItem.PublicAccess -ne "Off")
                  {
                     $string = "Subscription Name: " + $s.SubscriptionName + " (" + $s.SubscriptionId + ") Storage Account: " + $item.Name + " in RG: " + $item.ResourceGroupName + " has a public container named: " + $c.Name
                     Write-Output $string 
                  } 
              } # ($c in $containerList)

          }

        

    } # ($r in $Resources)

    Write-Output ""

} #foreach ($s in $subscriptionList)