

Import-Module ADDSDeployment

Uninstall-ADDSDomainController `
-DemoteOperationMasterRole:$true `
-ForceRemoval:$true `
-Force:$true
