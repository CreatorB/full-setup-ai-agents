Option Explicit

Dim WSHShell, regPath
Set WSHShell = CreateObject("WScript.Shell")

' Registry path for startup
regPath = "HKCU\Software\Microsoft\Windows\CurrentVersion\Run\OllamaClean"

WScript.Echo "========================================="
WScript.Echo "Removing Ollama Auto-Start"
WScript.Echo "========================================="
WScript.Echo ""

' Remove from registry
On Error Resume Next
WSHShell.RegDelete regPath

If Err.Number = 0 Then
    WScript.Echo "Ollama auto-start removed successfully!"
Else
    WScript.Echo "No auto-start entry found (or already removed)"
End If

On Error GoTo 0
Set WSHShell = Nothing
