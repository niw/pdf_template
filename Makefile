.PHONY: all
all: run

.docker_build:
	docker build -t pdf_template .
	touch .docker_build

.PHONY: lint
lint:
	bundle exec rubocop --auto-correct

.PHONY: run
run: .docker_build
	docker run --rm -v `pwd`:/workdir -v `pwd`/fonts:/fonts -i -t --entrypoint=/bin/sh pdf_template

.PHONY: clean
clean:
	git clean -dfx
