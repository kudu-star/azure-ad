# This script assigns a permission to an Enterprise Application
# The script is based on the following article:
# https://dev.to/svarukala/manage-azure-ad-enterprise-applications-permissions-using-microsoft-graph-powershell-222m


# Vendor documentation:
# https://docs.microsoft.com/en-us/graph/api/serviceprincipal-post-approleassignments?view=graph-rest-1.0&tabs=http
# https://learn.microsoft.com/en-us/graph/migrate-azure-ad-graph-configure-permissions?tabs=http%2Cupdatepermissions-azureadgraph-powershell


Connect-MgGraph -Scope AppRoleAssignment.ReadWrite.All

# Replace the ObjectID with the ObjectID of your Enterprise Application
$ObjectId = "0cf33eb9-6722-4a66-8b52-773a92ee3e07" 

# Add the correct Graph scope to grant (e.g. User.Read)
$graphScope = "Application.Read.All"
$graph = Get-MgServicePrincipal -Filter "AppId eq '07e55f84-a389-4cb5-bb47-fbe29e37b533'"
# Replace the AppId with the AppId of your Enterprise Application

# Get the graph app role for the scope that you want to grant
$graphAppRole = $graph.AppRoles | ? Value -eq $graphScope

# Prepare the app role assignment
$appRoleAssignment = @{
    "principalId" = $ObjectId
    "resourceId"  = $graph.Id
    "appRoleId"   = $graphAppRole.Id
}
# Grant the app role
New-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $ObjectID -BodyParameter $appRoleAssignment | Format-List
