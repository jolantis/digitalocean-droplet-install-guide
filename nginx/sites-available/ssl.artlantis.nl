# ------------------------------------------------------------------------------
# ssl.artlantis.nl
# ------------------------------------------------------------------------------

# Choose between www and non-www, listen on the *wrong* one and redirect to
# the right one -- http://wiki.nginx.org/Pitfalls#Server_Name

server {
  listen [::]:80;
  listen 80;

  # Listen on both hosts
  server_name artlantis.nl www.artlantis.nl;

  # Include SSL module
  include h5bp/directive-only/ssl.conf;

  # And redirect to the https host (declared below)
  # avoiding http://www -> https://www -> https:// chain.
  return 301 https://artlantis.nl$request_uri;
}

server {
  listen [::]:443 ssl spdy;
  listen 443 ssl spdy;

  # Listen on the wrong host
  server_name www.artlantis.nl;

  # Include SSL and Nginx's SPDY (currently experimental) modules
  include h5bp/directive-only/ssl.conf;
  include h5bp/directive-only/spdy.conf;

  # And redirect to the non-www host (declared below)
  return 301 https://artlantis.nl$request_uri;
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

server {
  listen [::]:443 ssl spdy;
  listen 443 ssl spdy;

  # The host name to respond to
  server_name artlantis.nl;

  # Include SSL and Nginx's SPDY (currently experimental) modules
  include h5bp/directive-only/ssl.conf;
  include h5bp/directive-only/spdy.conf;

  # Path for static files
  root /usr/share/nginx/www/artlantis.nl/public;

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

  # Include the basic h5bp config set
  include h5bp/basic.conf;

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Include the Kirby CMS specific URI config set
  include kirby/kirby.conf;

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Redirect old forgotten and rusty URIs
  include kirby/artlantis.detour.conf;
}


# ------------------------------------------------------------------------------
# ssl.stage.artlantis.nl
# ------------------------------------------------------------------------------

# Remove the "www." at the beginning of URLs

server {
  listen [::]:80;
  listen 80;

  # listen on both hosts
  server_name stage.artlantis.nl www.stage.artlantis.nl;

  # Include SSL module
  include h5bp/directive-only/ssl.conf;

  # and redirect to the https host (declared below)
  # avoiding http://www -> https://www -> https:// chain.
  return 301 https://stage.artlantis.nl$request_uri;
}

server {
  listen [::]:443 ssl spdy;
  listen 443 ssl spdy;

  # Listen on the wrong host
  server_name www.stage.artlantis.nl;

  # Include SSL and Nginx's SPDY (currently experimental) modules
  include h5bp/directive-only/ssl.conf;
  include h5bp/directive-only/spdy.conf;

  # And redirect to the non-www host (declared below)
  return 301 https://stage.artlantis.nl$request_uri;
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

server {
  listen [::]:443 ssl spdy;
  listen 443 ssl spdy;

  # Listen on the non-www host
  server_name stage.artlantis.nl;

  # Include SSL and Nginx's SPDY (currently experimental) modules
  include h5bp/directive-only/ssl.conf;
  include h5bp/directive-only/spdy.conf;

  # Path for static files
  root /usr/share/nginx/www/stage.artlantis.nl/public;

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

  # Include the basic h5bp config set
  include h5bp/basic.conf;

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Include the Kirby CMS specific URI config set
  include kirby/kirby.conf;

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Redirect old forgotten and rusty URIs
  include kirby/artlantis.detour.conf;
}
