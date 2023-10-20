<# $CSV = Import-Csv ".\Tables\AllRandomWeapon.csv" -Header ID, Item
$HashTable=@{}
foreach($r in $CSV)
{
    $HashTable[$r.ID]=$r.Item
}
$ID = $HashTable.Keys | get-random
$ID
$Item = $HashTable[$ID]
$Item #>

$CSV = Import-Csv ".\Tables\AllRandomWeapon.csv" -Header ID, Item | Get-Random

$CSV.Item