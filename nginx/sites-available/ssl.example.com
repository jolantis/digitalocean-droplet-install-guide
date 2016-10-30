# ------------------------------------------------------------------------------
# ssl.example.com
# ------------------------------------------------------------------------------

# Choose between www and non-www, listen on the *wrong* one and redirect to
# the right one -- http://wiki.nginx.org/Pitfalls#Server_Name

server {
  listen [::]:80;
  listen 80;

  # Listen on both hosts
  server_name example.com www.example.com;

  # and redirect to the https host (declared below)
  # avoiding http://www -> https://www -> https:// chain.
  return 301 https://example.com$request_uri;
}

server {
  listen [::]:443 ssl http2;
  listen 443 ssl http2;

  # Listen on the wrong host
  server_name www.example.com;

  # SLL domain certificates
  ssl_certificate      /etc/letsencrypt/live/example.com.crt;
  ssl_certificate_key  /etc/letsencrypt/live/example.com.key;

  # And redirect to the non-www host (declared below)
  return 301 https://example.com$request_uri;
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

server {
  # listen [::]:443 ssl http2 accept_filter=dataready;  # for FreeBSD
  # listen 443 ssl http2 accept_filter=dataready;  # for FreeBSD
  # listen [::]:443 ssl http2 deferred;  # for Linux
  # listen 443 ssl http2 deferred;  # for Linux
  listen [::]:443 ssl http2;
  listen 443 ssl http2;

  # The host name to respond to
  server_name example.com;

  # Path for static files
  root /usr/share/nginx/wwwroot/example.com/www;

  # Index
  index index.html index.htm index.php;

  # Specify a charset
  charset utf-8;

  # Custom 404 page
  error_page 403 404 /error;

  # Default 50x page
  error_page 500 502 503 504 /50x.html;
  location = /50x.html {
    root /usr/share/nginx/wwwroot;
  }

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Let's Encrypt challenge
  location /.well-known/acme-challenge {
    root /usr/share/nginx/wwwroot/example.com;
  }

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Include the basic h5bp config set
  include h5bp/basic.conf;

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Include SSL and SPDY modules
  include h5bp/directive-only/ssl.conf;
  include h5bp/directive-only/extra-security.conf;
  include h5bp/directive-only/ssl-stapling.conf;

  # Include the Kirby CMS specific URI config set
  include kirby/kirby-example.conf;

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Redirect old forgotten and rusty URIs
  # include kirby/detour-example.conf;
}


# ------------------------------------------------------------------------------
# ssl.stage.example.com
# ------------------------------------------------------------------------------

# Remove the "www." at the beginning of URLs

server {
  listen [::]:80;
  listen 80;

  # Listen on both hosts
  server_name stage.example.com www.stage.example.com;

  # And redirect to the https host (declared below)
  # avoiding http://www -> https://www -> https:// chain.
  return 301 https://stage.example.com$request_uri;
}

server {
  listen [::]:443 ssl http2;
  listen 443 ssl http2;

  # Listen on the wrong host
  server_name www.stage.example.com;

  # SLL domain certificates
  ssl_certificate      /etc/letsencrypt/live/example.com.crt;
  ssl_certificate_key  /etc/letsencrypt/live/example.com.key;

  # And redirect to the non-www host (declared below)
  return 301 https://stage.example.com$request_uri;
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

server {
  # listen [::]:443 ssl http2 accept_filter=dataready;  # for FreeBSD
  # listen 443 ssl http2 accept_filter=dataready;  # for FreeBSD
  # listen [::]:443 ssl http2 deferred;  # for Linux
  # listen 443 ssl http2 deferred;  # for Linux
  listen [::]:443 ssl http2;
  listen 443 ssl http2;

  # Listen on the non-www host
  server_name stage.example.com;

  # Path for static files
  root /usr/share/nginx/wwwroot/example.com/stage;

  # Index
  index index.php index.html index.htm;

  # Specify a charset
  charset utf-8;

  # Custom 404 page
  error_page 403 404 /error;

  # Default 50x page
  error_page 500 502 503 504 /50x.html;
  location = /50x.html {
    root /usr/share/nginx/wwwroot;
  }

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Let's Encrypt challenge
  location /.well-known/acme-challenge {
    root /usr/share/nginx/wwwroot/example.com;
  }

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Include the basic h5bp config set
  include h5bp/basic.conf;

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Include SSL and SPDY modules
  include h5bp/directive-only/ssl.conf;
  include h5bp/directive-only/extra-security.conf;
  include h5bp/directive-only/ssl-stapling.conf;

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Include the Kirby CMS specific URI config set
  include kirby/kirby-example.conf;

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Redirect old forgotten and rusty URIs
  # include kirby/detour-example.conf;
}
