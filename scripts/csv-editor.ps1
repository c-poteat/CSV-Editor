function removequotes {
    Get-Content -Path ./Outfile-tmp.csv -Encoding UTF8 
    | ForEach-Object {$_ -replace '"',''} | Out-File ./Outfile.csv -Encoding UTF8 
}
function csvedit {
# Import CSV
Import-Csv -Path ./Original.csv 
# Loop through contents & The $_ after the if statement returns the modified object to the pipeline, 
# which can then be passed to the Export-Csv cmdlet.
| ForEach-Object { if($_.Emp_ID -eq "3000"){$_.City = "Charlotte"} $_ } 
# Export CSV under modified
| Export-Csv ./Outfile-tmp.csv -NoTypeInformation
# Call remove quotes function
removequotes
Start-Sleep -Seconds 0.5
}
function addwithoutarray {
# Adding values by assigning variables
# Call previous function
csvedit
$update1 = "Timothy,5000,Asheville"
$update2 = "Sarah,6000,Greensboro"
$update3 = "Roger,7000,Wilmington"
$update4 = "Chris,8000,Raleigh"
Add-Content ./Outfile.csv -Value $update1
Add-Content ./Outfile.csv -Value $update2 
Add-Content ./Outfile.csv -Value $update3
Add-Content ./Outfile.csv -Value $update4 
}
function addwitharray {
    # Using an array to populate CSV
    # Call previous function
    addwithoutarray
    $array = @(
    "Susan,9000,Winston-Salem"
    "Bridget,10000,Cary"
    "Gregory,11000,Rocky Mount"
    "Jane,12000,High Point"
    "Daniel,13000,Goldsboro"
    "David,14000,Apex"
    "Leroy,15000,Jacksonville"
)
    Add-Content ./Outfile.csv -Value $array
}
function addcolumnheader {
# Remove first row Import the CSV file into a PowerShell object and skip the first row
Get-Content ./Outfile.csv | Select-Object -Skip 1 | Set-Content ./Outfile-tmp1.csv
$csvHeader = 'NAME,ID,CITY,STATE,COUNTRY'
$csvBody = Get-Content ./Outfile-tmp1.csv
Add-Content -Path ./Outfile-tmp2.csv -Value $csvHeader
Add-Content -Path ./Outfile-tmp2.csv -Value $csvBody
Import-Csv -Path ./Outfile-tmp2.csv | ForEach-Object { if($null -eq $_.STATE )
{$_.STATE = "North Carolina"} $_ } | ForEach-Object { if($null -eq $_.COUNTRY )
{$_.COUNTRY = "United States"} $_ } 
# Export CSV under modified
| Export-Csv ./Outfile-tmp.csv -NoTypeInformation
# Call remove quotes function
removequotes
Start-Sleep -Seconds 0.5
Get-ChildItem -Path "/Users/nell/Documents/DEV/CSV-Editor/" -Filter "*tmp*" | Remove-Item -Force
}
function removezeros {
# Regular expression remove any zeroes after 1st
Import-Csv -Path ./Outfile.csv | ForEach-Object { if($_.ID -gt "1"){$_.ID = ($_.ID) -replace "(?<=\d)0+(?=\d)", ""} 
if($_.ID -eq "1"){$_.ID = "10"} $_ } 
# Export CSV under modified
| Export-Csv ./Outfile-tmp.csv -NoTypeInformation 
removequotes
Remove-Item -Path ./Outfile-tmp.csv -Force
}

function entryadd {
$entries = @()
$entry = Read-Host "Enter first name for entry in CSV " 
while ($entry -ne "done") {
    $entries += $entry
    $entry = Read-Host "Enter another  (or type 'done' to finish)"
}
$data = Import-Csv -Path ./Outfile.csv
# Select last row and extract ID value
$lastID = $data | Select-Object -Last 1 | Select-Object -ExpandProperty ID
# Convert string to integer
$converttointeger = [int]$lastID
# Create loop and increment ID and randomize Cities due to entry
for ($i = 0; $i -lt $entries.Length; $i++) {
    $converttointeger++
    $city_state_country = Get-Content ./Cities-State-Country.csv | Get-Random
    $entries[$i] = $entries[$i] + "," + ($converttointeger) + "," + $city_state_country
}

Add-Content -Path ./Outfile.csv -Value $entries

}

function main {
    # csvedit
    # addwithoutarray
    # addwitharray
    # addcolumnheader
    #removezeros 
    entryadd
}
main