$frontDoorResourceGroup = "frontdoor-bluegreen-rg"
$frontDoorName = "frontdoor-blue-green1"
$appServicePlanSize = "F1"
$frontDoorFQDN = "fd-bluegreen-deployment.azurefd.net"
$frontDoorBackendPoolName = "backendpool"
###blue
$appServicePlanBlue = "frontdoor-web-blue"
$webAppBlue = "frontdoor-web-blue"

###green
$appServicePlanGreen = "frontdoor-web-green"
$webAppGreen = "frontdoor-web-green"


## frontDoorResourceGroup: 'frontdoor-bluegreen-rg'
## frontDoorName: 'frontdoor-blue-green'
## frontDoorUrl: 'frontdoor-blue-green-demo-app.philliproux.com'
## frontDoorBackendPoolName: 'backendpool'
## appServiceNameBlue: 'frontdoor-web-blue'
## appServiceNameGreen: 'frontdoor-web-green'
# webAppBlueUrl: 'frontdoor-web-blue.azurewebsites.net'
# webAppGreenUrl: 'frontdoor-web-green.azurewebsites.net'
# targetAppServiceName: '' # Set in inline script
# targetWebAppUrl: '' # Set in toggle script

#Delete Resource Group
#az group delete --name $frontDoorResourceGroup


#az group list
Write-Host "Create Resource Group"
#az group create -l westeurope -n $frontDoorResourceGroup

Write-Host "Create Blue Web App"
#az appservice plan create -g $frontDoorResourceGroup -n $appServicePlanBlue --sku $appServicePlanSize
#az webapp create -g $frontDoorResourceGroup -p $appServicePlanBlue -n $webAppBlue


Write-Host "Create Green Web App"
#az appservice plan create -g $frontDoorResourceGroup -n $appServicePlanGreen
#az webapp create -g $frontDoorResourceGroup -p $appServicePlanGreen -n $webAppGreen

Write-Host "Create Front Door"
#az network front-door create --backend-address $frontDoorFQDN --name $frontDoorName --resource-group $frontDoorResourceGroup

Write-Host "Create Front Door Load Balancer"
#$frontDoorLoadBalancerSampleSize = 4
#$frontDoorLoadBalanceSuccessfulSamplesRequired = 2
#$frontDoorLoadBalancingName = "AppBackendPool"
#az network front-door load-balancing create --front-door-name $frontDoorName --name $frontDoorLoadBalancingName --resource-group $frontDoorResourceGroup --sample-size $frontDoorLoadBalancerSampleSize --successful-samples-required $frontDoorLoadBalanceSuccessfulSamplesRequired


Write-Host "Create Front BackEnd"
#az network front-door create --backend-address $frontDoorFQDN --name $frontDoorName --resource-group $frontDoorResourceGroup

az network front-door load-balancing list --front-door-name $frontDoorName --resource-group $frontDoorResourceGroup

.\ToggleFrontdoorBackends.ps1 -frontDoorResourceGroup "frontdoor-bluegreen-rg" -frontDoorName "frontdoor-blue-green1" -frontDoorBackendPoolName "DefaultBackendPool" -frontDoorUrl "http://frontdoor-blue-green1.azurefd.net" -webAppBlueUrl "frontdoor-web-blue.azurewebsites.net" -webAppGreenUrl "frontdoor-web-green.azurewebsites.net"