# ------------------------------------------------------------------------------
# ssl.example.com
# ------------------------------------------------------------------------------

# Choose between www and non-www, listen on the *wrong* one and redirect to
# the right one -- http://wiki.nginx.org/Pitfalls#Server_Name

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
  listen [::]:443 ssl http2;
  listen 443 ssl http2;

  # The host name to respond to
  server_name example.com;

  # SLL domain certificates
  ssl_certificate      /etc/letsencrypt/live/example.com.crt;
  ssl_certificate_key  /etc/letsencrypt/live/example.com.key;

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

  # Redirect old forgotten and rusty URIs
  # include kirby/detour-example.conf;

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Include the Kirby CMS specific URI config set
  include kirby/kirby-example.conf;

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Include the basic h5bp config set
  include h5bp/basic.conf;

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Include the SSL h5bp config set
  include h5bp/secure.conf;
}


# ------------------------------------------------------------------------------
# ssl.stage.example.com
# ------------------------------------------------------------------------------

# Remove the "www." at the beginning of URLs

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
  listen [::]:443 ssl http2;
  listen 443 ssl http2;

  # Listen on the non-www host
  server_name stage.example.com;

  # SLL domain certificates
  ssl_certificate      /etc/letsencrypt/live/example.com.crt;
  ssl_certificate_key  /etc/letsencrypt/live/example.com.key;

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

  # Redirect old forgotten and rusty URIs
  # include kirby/detour-example.conf;

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Include the Kirby CMS specific URI config set
  include kirby/kirby-example.conf;

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Include the basic h5bp config set
  include h5bp/basic.conf;

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Include the SSL h5bp config set
  include h5bp/secure.conf;
}
