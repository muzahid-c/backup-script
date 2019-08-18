## Backup Script
This script can copy file from network/administrative share from multiple locations. 

## Motivation
I have created this begining of 2017 as I was in need of such script but could not find which meet my requirements. So I took help from good people of Netizen and created this complete script. 

## Features
This script can generate a log with timestamp so copied files can be verified. Robocopy can be used but back then I was unware of that. Time to time I have improved the code and added powershell command to calculate sizes of both source and destination as batch command has some limitation when size becomes larger. When used with a scheduler it can be used as simple automatic backup system. Feel free to use and modify it according to your need.  

## Tech/framework used
<b>Built with</b>
- [Batch file](https://en.wikipedia.org/wiki/Batch_file)
- [PowerShell](https://microsoft.com/powershell)

## License
GNU General Public License v2.0