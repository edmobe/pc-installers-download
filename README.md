# PC Installers Download
A Powershell script to download all the installers required for my new PC using a JSON list of apps.

# Prerequisites
1. A PC running Windows (this was only tested on Windows 11).
1. A PC with running scripts capability.
    You can enable it by running `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned`

# How to use
1. Set the directory to this repository.
1. Update the `Installers.json` to add any application you want to download. The script supports three scenarios:
    1. Normal executables. You must provide an `app` name (alphanumeric characters only), a `category`, and a `url` to the executable. 
    1. Different file extensions (such as `.msi`). For this, you must add an `extension`.
    1. Deeplinks. A good example is Microsoft Store applications. Use the `"urlType":"deeplink"` for this use case.
1. Decide which flags you need. 
    1. `-AlwaysReplace`: Always replaces existing files in `InstallerExecutables\` folder.
    1. `-AskToKeep`: Asks wether to keep already existing file in `InstallerExecutables\` or replacing it with a new download.
1. Run the script. Example: `.\Populate.ps1 -AlwaysReplace`