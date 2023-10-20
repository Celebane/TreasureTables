function GetRandomItem
{
    #Grab a random item from main csv
    $CSV = Import-Csv ".\Tables\Master.csv" -Header ID, Item | Get-Random
    $Item=$CSV.Item
    $Item
    #Check if there are more items to roll
    while ($Item -like '*^*^*')
    {
        $File = $Item.Substring($Item.IndexOf('^') + 1, $Item.IndexOf('^', $Item.IndexOf('^') + 1) - ($Item.IndexOf('^') + 1))
        $Additional= Import-Csv ".\Tables\$File.csv" -Header ID, Item  | Get-Random
        $Item = $Item.replace('^' + $File + '^', $Additional)
    }

    #Check if there are Dice Rolls required
    while ($Item -like '*##*##*')
    {
        $Modifier = 0
        $Rolls = 0
        $D = $Item.Substring($Item.IndexOf('##') + 2, $Item.IndexOf('##') - ($Item.IndexOf('##') + 2))
        
        #Check for positive modifier
        if ($D -like '*+*')
        {
            $D = $D -split '+'
            $Modifier = $Modifier + $D[1]
            $D = $D -ne $D[1]
        }

        #Check for negative modifier
        if ($D -like '*-*')
        {
            $D = $D -split '-'
            $Modifier = $Modifier - $D[1]
            $D = $D -ne $D[1]
        }

        $Dice = $D -split "d" 
        for ($i = 0; $i -lt $Dice[0]; $i++)
        {
            $Roll = Get-Random -Minimum 1 -Maximum $Dice[1]
            $Rolls = $Rolls + $Roll
        }
        $Item = $Item.replace('##' + $D + '##', ($Rolls + $Modifier))
    }

    $Item
    
}
Clear-Host
GetRandomItem