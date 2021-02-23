---
author: "EricKwan"
categories: ["laravel", "server", "permission"]
date: 2017-04-06T17:30:00Z
draft: false
slug: "server-documentation-for-laravel"
tags: ["laravel", "server", "permission"]
title: "Server Documentation for Laravel"
showToc: false
---

![logo](/learning-journey/images/2017/08/11130f096dbec743756b69cbb22f9.jpg)

Just to state the obvious for anyone viewing this discussion.... if you give any of your folders 777 permissions, you are allowing ANYONE to read, write and execute any file in that directory.... what this means is you have given ANYONE (any hacker or malicious person in the entire world) permission to upload ANY file, virus or any other file, and THEN execute that file...

[Full Documentation](http://www.mediacollege.com/linux/command/linux-command.html)

### The NORMAL way to set permissions is to have your files owned by the webserver:

    sudo chown -R $(whoami):www-data /path/to/your/root/directory

### Then you set all your directories to 755 and your files to 644... SET file permissions

    sudo find /path/to/your/root/directory -type f -exec chmod 644 {} \;
    sudo find /path/to/your/root/directory -type d -exec chmod 755 {} \;

### Whichever way you set it up, then you need to give read and write permissions to the webserver for storage, cache and any other directories the webserver needs to upload or write too (depending on your situation), so run the commands from bash above

    sudo chgrp -R www-data storage bootstrap/cache
    sudo chmod -R ug+rwx storage bootstrap/cache

If there are any updated version and there are any mistaken, feel free to modifiy it :) Thanks =)
