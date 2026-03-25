Option Explicit

Dim WSHShell, scriptDir, startScript, regPath
Set WSHShell = CreateObject("WScript.Shell")

' Get script directory
scriptDir = CreateObject("Scripting.FileSystemObject").GetParentFolderName(WScript.ScriptFullName)
startScript = scriptDir & "\start-ollama-clean.bat"

' Registry path for startup
regPath = "HKCU\Software\Microsoft\Windows\CurrentVersion\Run\OllamaClean"

' Show info
WScript.Echo "========================================="
WScript.Echo "Ollama Auto-Start Setup"
WScript.Echo "========================================="
WScript.Echo ""
WScript.Echo "Script: " & startScript
WScript.Echo ""

' Add to registry
On Error Resume Next
WSHShell.RegWrite regPath, startScript, "REG_SZ"

If Err.Number = 0 Then
    WScript.Echo "SUCCESS!"
    WScript.Echo ""
    WScript.Echo "Ollama will now auto-start when you login"
    WScript.Echo "- 10 second delay after login"
    WScript.Echo "- Old processes killed automatically"
    WScript.Echo "- Runs minimized in background"
    WScript.Echo ""
    WScript.Echo "To test: Restart your PC"
    WScript.Echo ""
    WScript.Echo "To remove: Run remove-ollama-startup.vbs"
Else
    WScript.Echo "ERROR: Failed to setup auto-start"
    WScript.Echo "Error: " & Err.Description
End If

On Error GoTo 0
Set WSHShell = Nothing
