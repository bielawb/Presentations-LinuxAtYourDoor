function Remove-ARecord {
    [Alias('RmA')]
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
                RRType = 'A'
                Name = $using:Name 
                RecordData = $using:IP 
                ZoneName = $using:Zone
                Confirm = $false
            }
            Remove-DnsServerResourceRecord @param
        } -ErrorAction Stop
    } catch {
        throw "Failed to remove A record - $_"
    }   
}