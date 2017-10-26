function Add-ARecord {
    [Alias('AddA')]
    param (
        [Parameter(Mandatory)]
        [String]$Name,
        [Parameter(Mandatory)]
        [IPAddress]$IP,
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
                CreatePtr = $true 
                IPv4Address = $using:IP 
                ZoneName = $using:Zone
                # CimSession = 'dc.monad.net'
            }
            Add-DnsServerResourceRecordA @param
        } -ErrorAction Stop
    } catch {
        throw "Failed to create new A record - $_"
    }
    
}