function UniqueArmor {
    #Import the top CSV
    $CSV = Import-Csv ".\Tables\UniqueArmorsMain.csv" -Header ID, Item

    #Create the Dice based on the number of rows in the CSV
    #and roll it to see which iten to grab
    $Die = New-Dice -Sides $CSV.count
    $Lookup = New-DiceRoll -Dice $Die -NoCrits
    $AT = $CSV[$Lookup - 1].Item

    #Check if there are more items to roll
    while ($AT -like '*^*')
    {
        $Start = $AT.IndexOf('^')
        $End = $AT.IndexOf('^', $AT.IndexOf('^') + 1)
        $File = $AT.Substring($Start + 1, $End - ($Start + 1))
        $File
        $CSV = Import-Csv ".\Tables\$File.csv" -Header ID, Item
        $Die = New-Dice -Sides $CSV.count
        $Lookup = New-DiceRoll -Dice $Die -NoCrits
        $Item = $CSV[$Lookup - 1].Item
        $AT = $AT.replace('^'+$File+'^', $Item)
    }


    $AT
    
}
Clear-Host
UniqueArmor