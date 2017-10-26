function Add-Cname {
    [Alias('AddCn')]
    param (
        [Parameter(Mandatory)]
        [String]$Name,
        [Parameter(Mandatory)]
        [string]$Alias,
        [String]$Zone = 'monad.net',
        
        [String]$ComputerName = 'dc',
        [String]$ConfigurationName = 'DnsAdmin'        
    )
    
    try {
        $remotingSession = New-PSSession -ComputerName $ComputerName -ConfigurationName $ConfigurationName -ErrorAction Stop
    } catch {
        throw "Failed to create remoting session - $_"
    }
    
    try {
        Invoke-Command -Session $remotingSession -ScriptBlock {
            $param = @{
                Name = $using:Name 
                HostNameAlias = $using:Alias
                ZoneName = $using:Zone
                # CimSession = 'dc.monad.net'
            }
            Add-DnsServerResourceRecordCname @param
        } -ErrorAction Stop
    } catch {
        throw "Failed to create new CName - $_"
    }
}