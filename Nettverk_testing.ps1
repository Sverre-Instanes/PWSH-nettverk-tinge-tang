$failures = 0
$sekunder = Read-Host "Hvor mange sekunder mellom sjekk?"
Write-Host "---------------------------"
while ($true) { #gjenta for alltid 

    $google = Test-Connection "8.8.8.8" -Count 1 -Quiet
    $Cloudfare = Test-Connection "1.1.1.1" -Count 1 -Quiet

    $ping = Test-Connection -ComputerName ($Cloudfare ? "1.1.1.1" : "8.8.8.8") -Count 1

    if ($google -or $Cloudfare) { 
            Write-Host "Internet Online" #hvis cloudfare og google funket skriv koblet på nett
            if (Test-Connection "1.1.1.1" -Count 1 -Quiet) {
Write-Host "Cloudfare Online"
            } else {
Write-Host "Cloudfare Offline"
            }
            if (Test-Connection "8.8.8.8" -Count 1 -Quiet) {
Write-Host "Google Online"
            } else {
Write-Host "Google Offline"
            }
            Write-Host "Ping $($ping.Latency) ms"
            Write-Host "Failures $failures"
            Write-Host "---------------------------"
        }

    else { #hvis det ikke funket skriv ikke koblet på nett og få popup
        Write-Host "Offline"
        $failures++
        Write-Host "Totalt $failures feilmeldinger"
                Add-Type -AssemblyName PresentationFramework
            [System.Windows.MessageBox]::Show("Du er koblet fra internettet", "Internett", "Ok", "Warning") 
            Write-Host "---------------------------"
    } #                                              Melding på popup       navn på window svar   bilde ikon
    if ($failures -eq 10) {
        $janei = Read-Host "Vil du restarte NetAdapter? Ja eller Nei"
        if ($janei -eq "Ja") {
            $aktivtkort = Get-NetAdapter | Where-Object { $_.Status -eq "Up" }
            Restart-NetAdapter -Name $aktivtkort.Name
            Write-Host "Starter $($aktivtkort.Name) på nytt."
        }
    }
    Start-Sleep -Seconds $sekunder #3 sekund pause
}
