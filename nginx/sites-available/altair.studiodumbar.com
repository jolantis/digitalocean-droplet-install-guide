# ------------------------------------------------------------------------------
# altair.studiodumbar.com
# ------------------------------------------------------------------------------

# www to non-www redirect -- duplicate content is BAD:
# https://github.com/h5bp/html5-boilerplate/blob/5370479476dceae7cc3ea105946536d6bc0ee468/.htaccess#L362
# Choose between www and non-www, listen on the *wrong* one and redirect to
# the right one -- http://wiki.nginx.org/Pitfalls#Server_Name

server {
  listen [::]:80;
  listen 80;

  # listen on the www host
  server_name www.altair.studiodumbar.com;

  # and redirect to the non-www host (declared below)
  return 301 $scheme://altair.studiodumbar.com$request_uri;
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

server {
  listen [::]:80;
  listen 80;

  # Listen on the non-www host
  server_name altair.studiodumbar.com;

  # Path for static files
  root /usr/share/nginx/www/altair.studiodumbar.com/public;

  # Index
  index index.html index.htm index.php;

  # Specify a charset
  charset utf-8;

  # Custom 404 page
  error_page 403 404 /error;

  # Default 50x page
  error_page 500 502 503 504 /50x.html;
  location = /50x.html {
    root /usr/share/nginx/www;
  }

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Remove trailing slash
  rewrite ^/(.+)/$ /$1 permanent;

  # Add trailing slash
  # rewrite ^(.*[^/])$ $1/ permanent;

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Include the basic h5bp config set
  include h5bp/basic.conf;

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Include the Kirby CMS specific URI config set
  include kirby/kirby.conf;

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Redirect old forgotten and rusty URIs
  # include kirby/example.detour.conf;
}
