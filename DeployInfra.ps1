$frontDoorResourceGroup = "frontdoor-bluegreen-rg"
$frontDoorName = "frontdoor-blue-green1"
$appServicePlanSize = "F1"
$frontDoorFQDN = $frontDoorName + ".azurefd.net"
$frontDoorBackendPoolName = "backendpool"

Write-Host $frontDoorFQDN
###blue
$appServicePlanBlue = "frontdoor-web-blue"
$webAppBlue = "frontdoor-web-blue"
$webAppBlueHostName = "frontdoor-web-green.azurewebsites.net"

###green
$appServicePlanGreen = "frontdoor-web-green"
$webAppGreen = "frontdoor-web-green"
$webAppGreenHostName = "frontdoor-web-green.azurewebsites.net"


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

# Write-Host "List Backend Pools - ....Remove"
# az network front-door backend-pool list --front-door-name $frontDoorName --resource-group $frontDoorResourceGroup -o table
# #az network front-door backend-pool backend list --front-door-name $frontDoorName #--pool-name $frontDoorBackendPoolName --resource-group $frontDoorResourceGroup -o table

# Write-Host "Health Probe Settings .... Remove"
# az network front-door probe list --front-door-name $frontDoorName --resource-group $frontDoorResourceGroup -o table

# Write-Host "List load balancers"
# az network front-door load-balancing list --front-door-name $frontDoorName --resource-group $frontDoorResourceGroup -o table

# Write-Host "Create Front Door Load Balancer"
# $frontDoorLoadBalancerSampleSize = 4
# $frontDoorLoadBalanceSuccessfulSamplesRequired = 2
# $frontDoorLoadBalancingName = "LoadBalancer1" #rename
# az network front-door load-balancing create --front-door-name $frontDoorName --name $frontDoorLoadBalancingName --resource-group $frontDoorResourceGroup --sample-size $frontDoorLoadBalancerSampleSize --successful-samples-required $frontDoorLoadBalanceSuccessfulSamplesRequired

# Write-Host "List load balancers"
# az network front-door load-balancing list --front-door-name $frontDoorName --resource-group $frontDoorResourceGroup -o table

# Write-Host "Create Health Probe"
# $frontDoorHealthProbeIntervalInSeconds = 30
# $frontDoorHealthProbeName = "frontDoorDefaultHealthProbe"
# $frontDoorHealthProbePath = "/"
# $frontDoorHealthProbeProtocol = "Https"
# az network front-door probe create --front-door-name $frontDoorName --interval $frontDoorHealthProbeIntervalInSeconds --name $frontDoorHealthProbeName --path $frontDoorHealthProbePath --resource-group $frontDoorResourceGroup --protocol $frontDoorHealthProbeProtocol  #{Http, Https}

# Write-Host "Create Backend Pool"
$frontDoorBackEndPoolName = "MyBackendPool" # rename
# az network front-door backend-pool create --address $webAppBlueHostName --front-door-name $frontDoorName --load-balancing $frontDoorLoadBalancingName --name $frontDoorBackEndPoolName --probe $frontDoorHealthProbeName --resource-group $frontDoorResourceGroup

Write-Host "List Routing Rules...Remove"
az network front-door routing-rule list --front-door-name $frontDoorName --resource-group $frontDoorResourceGroup

Write-Host "List FrontEnd Endpoints"
az network front-door frontend-endpoint list --front-door-name $frontDoorName --resource-group $frontDoorResourceGroup

# Delete default rule if exist?
#az network front-door routing-rule delete --front-door-name --name --resource-group

#$frontDoorFQDN = "http://frontdoor-blue-green1.azurefd.net" ## Duplicate variable
$frontDoorRouteType = "Forward"
$frontDoorRouteName = "DefaultRoutingRule" # Default Value generated!
$frontDoorEndPointName = "DefaultFrontendEndpoint" # Default value!
az network front-door routing-rule create --front-door-name $frontDoorName --frontend-endpoint $frontDoorEndPointName  --name $frontDoorRouteName --resource-group $frontDoorResourceGroup --route-type $frontDoorRouteType --backend-pool $frontDoorBackEndPoolName #--patterns "/api/*"
#.\ToggleFrontdoorBackends.ps1 -frontDoorResourceGroup "frontdoor-bluegreen-rg" -frontDoorName "frontdoor-blue-green1" -frontDoorBackendPoolName "DefaultBackendPool" -frontDoorUrl "http://frontdoor-blue-green1.azurefd.net" -webAppBlueUrl "frontdoor-web-blue.azurewebsites.net" -webAppGreenUrl "frontdoor-web-green.azurewebsites.net"