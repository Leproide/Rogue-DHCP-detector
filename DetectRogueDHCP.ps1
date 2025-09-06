# https://github.com/Leproide/Rogue-DHCP-detector/
# leproide@paranoici.org - leprechaun@muninn.ovh
# License: GPLv2

# === CONFIG ===
$legitServers = @("192.168.1.1")   # Authorized DHCP servers
$logfile = "C:\dhcp_rogue.log" # LOG file path
$tsharkPath = "C:\Program Files\Wireshark\tshark.exe" # tshark path
$iface = 7   # interface number (you can find it with tshark -D)

# tshark: capture OFFER(2) and ACK(5), show only useful fields
$tsharkArgs = "-l -i $iface -Y ""(dhcp.option.dhcp == 2 || dhcp.option.dhcp == 5)"" -T fields -e ip.src -e dhcp.option.dhcp_server_id -e eth.src"

# Start tshark
$proc = New-Object System.Diagnostics.Process
$proc.StartInfo.FileName = $tsharkPath
$proc.StartInfo.Arguments = $tsharkArgs
$proc.StartInfo.UseShellExecute = $false
$proc.StartInfo.RedirectStandardOutput = $true
$proc.StartInfo.CreateNoWindow = $true
$proc.Start() | Out-Null

$reader = $proc.StandardOutput
while (-not $reader.EndOfStream) {
    $line = $reader.ReadLine()
    if ([string]::IsNullOrWhiteSpace($line)) { continue }

    $parts = $line -split "`t"
    if ($parts.Count -lt 3) { continue }

    $srcIp = $parts[0]
    $serverId = $parts[1]
    $mac = $parts[2]

    if (-not $legitServers.Contains($serverId)) {
        $msg = "[{0}] ROGUE DHCP! Server {1} (src {2}, mac {3})" -f (Get-Date), $serverId, $srcIp, $mac
        Write-Host $msg -ForegroundColor Red
        Add-Content -Path $logfile -Value $msg
    }
    else {
        Write-Host "[OK] Legitimate DHCP from $serverId ($mac)" -ForegroundColor Green
    }
}
