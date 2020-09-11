pdf_template
============

A simple tool to publish PDF file based on template PDF file and data

Usage
-----

Install dependencies by using [Bundler](https://bundler.io/).

```
bundle install --path=vendor/bundles
```

Then,

```
bundle exec ruby pdf_template.rb example.yml
```

This will create `example.pdf`. See `publish!` method to place data
on the template.

### Docker

Install dependencies may not easy in some cases, in that case, use Docker.
Install [Docker](https://www.docker.com/products/docker-desktop), then create docker image.

```
docker build -t pdf_template .
```

Copy font file into `/fonts` directory, then use following command to run.

```
docker run --rm -v `pwd`:/workdir -v `pwd`/fonts:/fonts pdf_template example.yml
```
