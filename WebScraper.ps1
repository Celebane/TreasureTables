Import-Module AngleParse
Clear-Host
function ScrapeWebTable
{
    param (
        [Parameter(mandatory = $true)][uri]$Web,
        [Parameter(mandatory = $true)][string]$FileName
    )
    $Raw = Invoke-WebRequest -Uri $Web | Select-HtmlContent 'tr', @{Item = 'td' }
    $FileName = './Test/' + $FileName + '.csv'
    New-Item $FileName
    [System.Collections.ArrayList]$List = @()
    foreach ($Record in $Raw)
    {
        if (( $null -ne $Record.Item ) -and ($Record.Item.Trim() -ne ''))
        {
            $Index = $Record.Item[0]
            $Item = $Record.Item[1]
            $NewLine = [string]$Index + ',' + '"' + $Item.ToString().Trim().Replace('"', '""') + '"'
            $List.Add($NewLine)
            #Add-Content -Path $FileName -Value $NewLine
        }
    }
    $List -join "`r`n" | Set-Content $FileName -NoNewLine
}

ScrapeWebTable

function ScrapeURLs
{
    $URL = 'https://chartopia.d12dev.com/chart/9764/'
    $Raw = Invoke-WebRequest $URL | Select-HtmlContent 'td > div > p > span', @{Name = 'a'; Link = 'a', ([AngleParse.Attr]::Href) }
    $Sorted = $Raw.GetEnumerator() | Sort-Object -Property Name
    foreach ($Record in $Sorted)
    {
        $Link = 'https://chartopia.d12dev.com' + $Record.Link.Trim()
        $Name = $Record.Name.ToString().Replace(' ', '').Replace(',', '').Replace('"', '').Trim()
        ScrapeWebTable $Link $Name
    }
    
    
    <# for ($i = 0; $i -lt $Sorted.Count; $i++)
    {
        $Link = 'https://chartopia.d12dev.com' + $Sorted[$i].Link.Trim()
        $Name = $Sorted[$i].Name.ToString().Replace(' ','').replace(',','').Trim()
        #$Name + ": " + $Link
        ScrapeWebTable $Link $Name
    } #>
}

#ScrapeURLs