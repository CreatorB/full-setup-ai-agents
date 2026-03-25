Option Explicit

Dim WSHShell, regPath, value
Set WSHShell = CreateObject("WScript.Shell")

' Registry path for startup
regPath = "HKCU\Software\Microsoft\Windows\CurrentVersion\Run\OllamaClean"

WScript.Echo "========================================="
WScript.Echo "Ollama Auto-Start Verification"
WScript.Echo "========================================="
WScript.Echo ""

' Read from registry
On Error Resume Next
value = WSHShell.RegRead(regPath)

If Err.Number = 0 Then
    WScript.Echo "STATUS: Auto-start is ENABLED"
    WScript.Echo ""
    WScript.Echo "Registry Entry:"
    WScript.Echo "  Key: " & regPath
    WScript.Echo "  Value: " & value
    WScript.Echo ""
    WScript.Echo "What will happen when you login:"
    WScript.Echo "  1. Windows starts"
    WScript.Echo "  2. You login"
    WScript.Echo "  3. Wait 10 seconds"
    WScript.Echo "  4. Kill old Ollama processes"
    WScript.Echo "  5. Start fresh Ollama instance (minimized)"
    WScript.Echo ""
    WScript.Echo "To test: Restart your PC now"
Else
    WScript.Echo "STATUS: Auto-start is NOT configured"
    WScript.Echo ""
    WScript.Echo "To enable: Run setup-ollama-startup.vbs"
End If

On Error GoTo 0
Set WSHShell = Nothing
