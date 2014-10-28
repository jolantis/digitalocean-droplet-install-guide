# ------------------------------------------------------------------------------
# vanwunnik.com
# ------------------------------------------------------------------------------

# Remove the "www." at the beginning of URLs

server {
  listen [::]:80;
  listen 80;

  # listen on the www host
  server_name www.vanwunnik.com;

  # and redirect to the non-www host (declared below)
  return 301 $scheme://vanwunnik.com$request_uri;
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

server {
  listen [::]:80;
  listen 80;

  # Listen on the non-www host
  server_name vanwunnik.com;

  # Include Nginx's SPDY module (currently experimental)
  include h5bp/directive-only/spdy.conf;

  # Path for static files
  root /usr/share/nginx/www/vanwunnik.com/public;

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

  # Basic config set
  include h5bp/basic.conf;

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Kirby CMS URIs
  include kirby/kirby.conf;

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Redirect old forgotten and rusty URIs
  include kirby/vanwunnik.detour.conf;
}


# ------------------------------------------------------------------------------
# stage.vanwunnik.com
# ------------------------------------------------------------------------------

# Remove the "www." at the beginning of URLs

server {
  listen [::]:80;
  listen 80;

  # listen on the www host
  server_name www.stage.vanwunnik.com;

  # and redirect to the non-www host (declared below)
  return 301 $scheme://stage.vanwunnik.com$request_uri;
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

server {
  listen [::]:80;
  listen 80;

  # Listen on the non-www host
  server_name stage.vanwunnik.com;

  # Include Nginx's SPDY module (currently experimental)
  include h5bp/directive-only/spdy.conf;

  # Path for static files
  root /usr/share/nginx/www/stage.vanwunnik.com/public;

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

  # Basic config set
  include h5bp/basic.conf;

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Kirby CMS URIs
  include kirby/kirby.conf;

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Redirect old forgotten and rusty URIs
  include kirby/vanwunnik.detour.conf;
}
