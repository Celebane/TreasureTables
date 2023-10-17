function UniqueArmor
{
    #Import the top CSV
    $CSV = Import-Csv ".\Tables\AllRandomWeapon.csv" -Header ID, Item

    #Create the Dice based on the number of rows in the CSV
    #and roll it to see which iten to grab
    $Die = New-Dice -Sides $CSV.count
    $Lookup = New-DiceRoll -Dice $Die -NoCrits
    $AT = $CSV[$Lookup - 1].Item

    #Check if there are more items to roll
    while ($AT -like '*^*^*')
    {
        $Start = $AT.IndexOf('^')
        $End = $AT.IndexOf('^', $AT.IndexOf('^') + 1)
        $File = $AT.Substring($Start + 1, $End - ($Start + 1))
        $File
        $CSV = Import-Csv ".\Tables\$File.csv" -Header ID, Item
        $Die = New-Dice -Sides $CSV.count
        $Lookup = New-DiceRoll -Dice $Die -NoCrits
        $Item = $CSV[$Lookup - 1].Item
        $AT = $AT.replace('^' + $File + '^', $Item)
    }

    #Check if there are Dice Rolls required
    while ($AT -like '*##*##*')
    {
        $Modifier = 0
        $Rolls = 0
        $Start = $AT.IndexOf('##')
        $End = $AT.IndexOf('##', $AT.IndexOf('##') + 2)
        $D = $AT.Substring($Start + 2, $End - ($Start + 2))
        
        #Check for positive modifier
        if ($D -like '*+*')
        {
            $D = $D -split '+'
            $Modifier = $Modifier + $D[1]
            $D = $D -ne $D[1]
        }

        #Check for positive modifier
        if ($D -like '*-*')
        {
            $D = $D -split '-'
            $Modifier = $Modifier - $D[1]
            $D = $D -ne $D[1]
        }

        $Dice = $D -split "d"
        for ($i = 0; $i -lt $Dice[0]; $i++)
        {
            $Die = New-Dice -Sides $Dice[1]
            $Roll = New-DiceRoll -Dice $Die -NoCrits
            $Rolls = $Rolls + $Roll
        }
        $AT = $AT.replace('##' + $D + '##', ($Rolls + $Modifier))
    }

    $AT
    
}
Clear-Host
UniqueArmor