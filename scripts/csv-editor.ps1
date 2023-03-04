function csvedit {
# Import CSV
Import-Csv -Path ./Original.csv 
# Loop through contents & The $_ after the if statement returns the modified object to the pipeline, 
# which can then be passed to the Export-Csv cmdlet.
| ForEach-Object { if($_.Emp_ID -eq "3000"){$_.City = "Charlotte"} $_ } 
# Export CSV under modified
| Export-Csv ./Outfile_Modified.csv -NoTypeInformation
# Remove Quotes from file
Get-Content -Path ./Outfile_Modified.csv -Encoding UTF8 
| ForEach-Object {$_ -replace '"',''} | Out-File ./Outfile.csv -Encoding UTF8
Start-Sleep -Seconds 3
Remove-Item -Path ./Outfile_Modified.csv
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
$csvHeader = 'EMP_Name,EMP_ID,CITY,STATE,COUNTRY'
$csvBody = Get-Content ./Outfile-tmp1.csv
Add-Content -Path ./Outfile-tmp2.csv -Value $csvHeader
Add-Content -Path ./Outfile-tmp2.csv -Value $csvBody
Import-Csv -Path ./Outfile-tmp2.csv | ForEach-Object { if($null -eq $_.STATE )
{$_.STATE = "North Carolina"} $_ } | ForEach-Object { if($null -eq $_.COUNTRY )
{$_.COUNTRY = "United States"} $_ } 
# Export CSV under modified
| Export-Csv ./Outfile-tmp3.csv -NoTypeInformation
Get-Content -Path ./Outfile-tmp3.csv -Encoding UTF8 
| ForEach-Object {$_ -replace '"',''} | Out-File ./Outfile-tmp4.csv -Encoding UTF8
Copy-Item ./Outfile-tmp4.csv ./Outfile.csv
Start-Sleep -Seconds 3
Get-ChildItem -Path "/Users/nell/Documents/DEV/CSV-Editor/" -Filter "*tmp*" | Remove-Item -Force
}

function main {
    csvedit
    addwithoutarray
    addwitharray
    addcolumnheader
}
main