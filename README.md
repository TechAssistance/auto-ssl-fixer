# auto-ssl-fixer
Removes domains that fail DCV from the auto SSL list on WHM systems. Due to how WHM orders SSLs too third party providers by varifying DCV passes, they require all subdomains submitted to the cpanel store order to pass DCV otherwise the order will fail. Most people do not set up the defaultly enabled domains etc thus leading to issues. This script helps with that as some servers have over +300 cpanel accounts with 2-3 domains each. 

## example of how the script runs: 
![autosslworkin](https://user-images.githubusercontent.com/76240748/183291520-5b0c1b50-469d-4e71-892e-69f854145195.PNG)

## explanation on why its so bad:
This was an learning expiriment for me. As a Java/bash main(lol), it was fun to mess around with the complex data types of python to try and create cool looking, in line colored reports not to mention progress bars etc. 

There is also the origional pearl vertions I made becasue I saw alot of WHM was coded in pearl and I thought "Well that looks fun" and welp ended up coding my first bit of pearl ever, so if you wanna see some TERRIBLE code look there haha! 
