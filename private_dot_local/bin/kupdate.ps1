#!/bin/env -S echo "This is a powershell script lol, try again"

param([switch]$admin)

try {
    where.exe oh-my-posh.exe | Out-Null

    Write-Host "Updating Oh-My-Posh..."
    oh-my-posh upgrade

    if ( $LASTEXITCODE -gt 0 ) {
        Write-Error "Could not update oh-my-posh, will retry as admin"
    }
    Write-Host "Done."
} catch {}

# Non-admin stuff
if ( -not $admin ) {

    Write-Host "Updating Scoop packages..."
    scoop update --all
    Write-Host "Done."

    try {
        where.exe chezmoi.exe | Out-Null

        Write-Host "Updating Chezmoi..."
        chezmoi update
        Write-Host "Done."
    } catch {}

    try {
        $upgrade_spotify = $true
        Write-Host "Updating spotify..."
        where.exe spicetify.exe | Out-Null

        if ( Get-Process -Name Spotify -ErrorAction SilentlyContinue ) {
            Write-Host "Please close Spotify..."
            try {
                Wait-Process -Name Spotify -Timeout 10 -ErrorAction Stop
            } catch {
                if ( Get-Process -Name Spotify -ErrorAction SilentlyContinue ) {
                    Write-Host "Spotify was not closed, skipping."
                    upgrade-spotify = $false
                }
            }
        }

        if ( $upgrade_spotify ) {

            winget upgrade spotify
            Write-Host "Done."

            Write-Host "Updating spicetify..."
            spicetify update
            Write-Host "Done."
        }
    } catch {}

}

# Run Admin Stuff

# Get the ID and security principal of the current user account
$myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($myWindowsID)

# Get the security principal for the Administrator role
$adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator

# Check to see if we are currently running "as Administrator"
if ($myWindowsPrincipal.IsInRole($adminRole)) {
    # We are running "as Administrator" - so change the title and background color to indicate this
    $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + "(Elevated)"
    Clear-Host
} else {
    # We are not running "as Administrator" - so relaunch as administrator

    # Create a new process object that starts PowerShell
    $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";

    # Specify the current script path and name as a parameter
    $newProcess.Arguments = $myInvocation.MyCommand.Definition + " -admin ";

    Write-Host $newProcess.Arguments

    # Indicate that the process should be elevated
    $newProcess.Verb = "runas";

    # Start the new process
    [System.Diagnostics.Process]::Start($newProcess);

    # Exit from the current, unelevated, process
    exit
}

# Run your code that needs to be elevated here


try {
    where.exe choco.exe | Out-Null
    Write-Host "Updating chocolatey packages..."
    choco upgrade all -y
    Write-Host "Done."
} catch {}


try {
    where.exe winget.exe | Out-Null
    Write-Host "Updating winget packages..."
    winget upgrade --all
    Write-Host "Done."
} catch {}

try {
    # Spotify may have been updated, so apply if needed
    spicetify backup apply
} catch {}

return
