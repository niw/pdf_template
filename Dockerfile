FROM alpine:latest

RUN echo 'gem: --no-rdoc --no-ri' >/etc/gemrc
RUN apk --no-cache add \
  ca-certificates \
  ruby \
  ruby-bundler \
  ruby-io-console \
  gobject-introspection \
  cairo \
  cairo-gobject \
  pango \
  poppler \
  poppler-glib \
  gdk-pixbuf

RUN bundle config --global frozen 1

RUN mkdir -p /app

WORKDIR /app

COPY Gemfile /app
COPY Gemfile.lock /app

RUN apk --no-cache add --virtual .dev \
    make \
    gcc \
    musl-dev \
    ruby-dev \
    gobject-introspection-dev \
    cairo-dev \
    gdk-pixbuf-dev \
    poppler-dev \
    pango-dev && \
  bundle install --without development && \
  mkdir -p /usr/share/poppler && \
  wget -O - https://poppler.freedesktop.org/poppler-data-0.4.7.tar.gz | tar -xz -C /usr/share/poppler && \
  cd /usr/share/poppler/poppler-data-0.4.7 && make install prefix=/usr && rm -rf /usr/share/poppler/poppler-data-0.4.7 && \
  apk del .dev

COPY pdf_template.rb /app

COPY fontdir.conf /etc/fonts/conf.d/00-fontdir.conf

VOLUME /workdir
VOLUME /fonts

WORKDIR /workdir

ENTRYPOINT ["bundle", "exec", "--gemfile=/app/Gemfile", "ruby", "/app/pdf_template.rb"]
