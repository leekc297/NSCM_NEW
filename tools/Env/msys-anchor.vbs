' MSYS2 shared-memory anchor for Git for Windows (2026-10-22)
' Root cause: msys-2.0.dll initialises a per-user shared section under a 15 s spinlock. When two MSYS processes
'   start together (several Claude sessions, git hooks, credential helper) or an initialiser is killed / stalled
'   (antivirus scan), later starts die with: fatal error - add_item ("\??\C:\Program Files\Git", "/", ...) failed, errno 1
'   (git-for-windows/git#6368, msys2/msys2-runtime#333 - not released yet).
' Workaround: keep one long-lived MSYS process alive so the section is initialised once and never torn down.
' This script starts "usr\bin\sleep.exe infinity" hidden if it is not already running. Run at logon (Startup folder).
Option Explicit
Dim sh, wmi, procs, sleepExe
sleepExe = "C:\Program Files\Git\usr\bin\sleep.exe"
Set sh = CreateObject("WScript.Shell")
Set wmi = GetObject("winmgmts:\\.\root\cimv2")
Set procs = wmi.ExecQuery("SELECT ProcessId FROM Win32_Process WHERE Name='sleep.exe' AND CommandLine LIKE '%infinity%'")
If procs.Count = 0 Then
  If CreateObject("Scripting.FileSystemObject").FileExists(sleepExe) Then
    sh.Run """" & sleepExe & """ infinity", 0, False
  End If
End If
