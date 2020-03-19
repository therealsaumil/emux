# Virtualbox Conversion

commands reused from the [PENT project](https://github.com/ProfessionallyEvil/PENT/blob/master/linux/vmx-vbox.sh)

## tldr

1) `cd vbox_conversion`
2) `./build.sh` script in this directory
3) follow prompts

## Explaination

during the `./build.sh` script execution.

1) Asks the user to download the current vmware 7zip files to a .zip file
2) once downloaded it takes either the file name (if in this directory) or full path to the .zip file.
3) then unzips the file to extract the 7zip files
4) then extracts the 7zip files
5) afterwards it creates a virtualbox (vbox) machine with the `vboxmanage` commands
6) then uses another `vboxmanage` command to export the just created vbox machine which can be imported on any machine
7) cleans up all the extracted files and old vbox machine
