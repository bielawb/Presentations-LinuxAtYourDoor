function Remove-Cname {
    [Alias('RmCn')]
    param (
        [Parameter(Mandatory)]
        [String]$Name,
        [Parameter(Mandatory)]
        [String]$Alias,
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
                RRType = 'CName'
                Name = $using:Name 
                RecordData = $using:Alias
                ZoneName = $using:Zone
                Confirm = $false
            }
            Remove-DnsServerResourceRecord @param
        } -ErrorAction Stop
    } catch {
        throw "Failed to remove CName - $_"
    }
}