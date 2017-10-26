#region Testing GETs
$noDomainCred = [pscredential]::new('bielawb', $MonadCredentials.Password)
Invoke-RestMethod -Uri http://awx.monad.net/api/v2/ -Credential $noDomainCred
Invoke-RestMethod -Uri http://awx.monad.net/api/v2/job_templates/ -Credential $noDomainCred | ForEach-Object results
$ldapSettings = Invoke-RestMethod -Uri http://awx.monad.net/api/v2/settings/ldap/ -Credential $noDomainCred 
$ldapSettings | Format-Custom
Invoke-RestMethod -Uri http://awx.monad.net/api/v2/jobs/ -Credential $noDomainCred | 
    ForEach-Object results | 
    Where-Object { $_.failed } |
    Format-Table id, name, job_template, description, extra_vars
#endregion

#region POSTs
function Start-AwxJob {
    [CmdletBinding(
            DefaultParameterSetName = 'id'
    )]
    param (
        [Parameter(Mandatory, ParameterSetName = 'name')]
        [String]$TemplateName,
        
        [hashtable]$Parameters = @{},
        
        [pscredential]$Credential = $noDomainCred
    )
    
    $apiUri = 'http://awx.monad.net/api/v2'
    # get job template id....
    $id = (Invoke-RestMethod -Uri "$apiUri/job_templates/" -Credential $noDomainCred).results.Where{ $_.name -eq $TemplateName}.id
    $fullUri = "{0}/job_templates/{1}/launch/" -f $apiUri, $id
    Invoke-RestMethod -Method Post -UseBasicParsing -Uri $fullUri -Credential $noDomainCred -Body (
        @{
            extra_vars = $Parameters 
        } | ConvertTo-Json
    ) -ContentType application/json
}

(Invoke-RestMethod -Uri "http://awx.monad.net/api/v2/job_templates/" -Credential $noDomainCred).results | 
    Format-Table -Property id, name

Start-AwxJob -TemplateName windows.demo -Parameters @{ title = 'This is a title...' }

#endregion

#region delegation
$ansibleUser = Get-Credential ansibleUser
Start-AwxJob -TemplateName 'Add DNS entries' -Parameters @{ 
    IP = '192.168.7.179'
    hostName = 'foofoo'
    cname = 'cnameToFooFoo' 
} -Credential $ansibleUser

Resolve-DnsName -Name cnameToFooFoo.monad.net

Start-AwxJob -TemplateName 'Remove DNS entries' -Parameters @{ 
    IP = '192.168.7.179'
    hostName = 'foofoo'
    cname = 'cnameToFooFoo' 
} -Credential $ansibleUser
