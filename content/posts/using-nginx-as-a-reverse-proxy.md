---
author: "Eric Cheung"
categories: ["nginx", "reverse-proxy"]
date: 2017-08-04T14:09:31Z
description: ""
draft: false
slug: "using-nginx-as-a-reverse-proxy"
tags: ["nginx", "reverse-proxy"]
title: "Using Nginx as a Reverse Proxy"
---

## Why nginx

It's not any better/worse at serving static files than Apache. However, the big difference is that nginx can serve a lot more users without using up additional resources.

## Example Setup

Firstly, you need to create a site configuration at `/etc/nginx/sites-available`

    cd /etc/nginx/sites-available
    sudo [vim/nano(any editor)] yoursite.com.conf

Then you can ready to prototype your coding

Below are the example server coding setup and will be describe deeply later.

    server {
        listen 80;
        listen [::]:80;
        listen 443 ssl [ssl section] http2 (Optional);
        // you can decide whethere to use the HTTP/2 Protocol
        listen [::]:443 ssl [ssl section] http2 (Optional);

        server_name http://example.com;
        // The server name that you registered in domain provider

        set $target_url http://example:xxx;
        // The target location that you want. e.g. http://192.168.1.31:8000;

        include /etc/nginx/laravel_params (Optional);
        include /etc/nginx/default.d/*.conf (Optional);
        include snippets/signed.conf; [ssl section]
        include snippets/ssl-params.conf; [ssl section]
    }

Save your setting and create a symlink at `/etc/nginx/sites-enabled`

    cd /etc/nginx/sites-enabled
    sudo ln -s /etc/nginx/sites-available/yoursite.com.conf

Then test your setting is correctly by typing

    sudo nginx -t

Finally, reload nginx server

    sudo service nginx reload

## Default parameters

You can defind any default action to make your own purpose, there are a variety of methods that you can do :)

You can find one example default .conf located at `/etc/nginx/default.d/phpmyadmin.conf`

Since phpmyadmin contain credential contents, so I will make a default conf to disable worldwild access.

    location /phpmyadmin {
        return 403;
        // return 403 to all user who try to access phpmyadmin.
        // you can also write a whitelist to enable a group of users.

        location ~ ^/phpmyadmin/(.+\.php)$ {
            return 403;
        }
    }

    location /phpMyAdmin {
        rewrite ^/* /phpmyadmin last;
    }

Remember to add your config from server config.

    server {
        [...]

        include /etc/nginx/default.d/*.conf
        // you can specific name.conf instead of all config

        [...]
    }

## PHP parameters

Below are the example php coding setup if you are using PHP.

    rewrite ^/(.*)/$ /$1 permanent;
    // rewrite any "/" at the end of the url.

    location / {
        proxy_pass $target_url;
        // proxy pass the target_url that we had definded before
        include /etc/nginx/proxy_params;
        limit_req zone=one burst=5;
        // rate limitation
    }

    location @proxy {
        proxy_pass $target_url;
        include /etc/nginx/proxy_params;
    }

    location ~* \.php$ {
        proxy_pass $target_url;
        include /etc/nginx/proxy_params;
    }

## Signed certificate

You must include two file to enable secure HTTP

    server {
        listen 443 ssl [http2];
        listen [::]:443 ssl [http2];

        [...]
        include snippets/signed.conf; [ssl section]
        include snippets/ssl-params.conf; [ssl section]
        [...]
    }

## SSL parameters

You can learn more ssl parameters below if you want.
[Click here](http://nginx.org/en/docs/http/ngx_http_ssl_module.html)
