Param (
    # Always replaces existing files in InstallerExecutables\
    [switch] $AlwaysReplace,
    
    # Asks wether to keep already existing file in InstallerExecutables\ or replacing it with a new download
    [switch] $AskToKeep
)

$installers = Get-Content -Path ".\Installers.json" -Raw | ConvertFrom-Json
$downloadDirectory = ".\InstallerExecutables\"

if (!(Test-Path $downloadDirectory))
{
    [void](New-Item -Path $downloadDirectory -ItemType Directory)
}

foreach ($installer in $installers) {
    # Initialize naming variables
    $app = $installer.app
    $extension = $installer.extension
    $appCategory = $installer.category
    $url = $installer.url
    $urlType = $installer.urlType
    $keep = $false
    if(!$extension)
    {
        if ($urlType -eq "deeplink")
        {
            $extension = ".bat"
        }
        else
        {
            $extension = ".exe"
        }
    }

    # Set locations
    $fileName = $app.replace(' ', '') + "Installer" + $extension
    $downloadPath = Join-Path -Path $downloadDirectory -ChildPath $fileName

    # Main logic
    if (Test-Path $downloadPath)
    {
        # Validate flags
        if ($AskToKeep)
        {
            $answer = ""
            while (!($answer -eq "R" -or $answer -eq "K")) {
                $answer = Read-Host -Prompt "A file already exists in $downloadPath. Should I replace it (R) or keep it (K)?"
                if ($answer -eq "K")
                {
                    $keep = $true
                }
                else
                {
                    Write-Host "Please enter 'R' to replace the file or 'K' to keep it"
                }
            }
        }
        elseif(!$AlwaysReplace)
        {
            $keep = $true
        }

        # Replace logic
        if ($keep)
        {
            Write-Host "Existing $downloadPath will be kept"
        }
        else
        {
            Write-Host "Existing $downloadPath will be removed"
            Remove-Item $downloadPath -verbose
        }
    }

    # Final logic
    if (!$keep)
    {
        if ($urlType -eq "deeplink")
        {
            "start $url" | Out-File $downloadPath -Encoding ascii
            Write-Host "Successfully created $app installer in $downloadPath"
        }
        else
        {
            Write-Host "Downloading installer for $appCategory app: $app..."
            $ProgressPreference = 'SilentlyContinue'
            Invoke-WebRequest -Uri $url -OutFile $downloadPath
            Write-Host "Successfully downloaded $app installer in $downloadPath"
        }   
    }
}