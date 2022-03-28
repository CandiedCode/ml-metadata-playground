SETUPTOOLS_USE_DISTUTILS ?= stdlib

.PHONY: check-config
check-config:  ## Checks the validity of the pyproject.toml file.
	poetry check

.PHONY: new
new:
	poetry new ml-metadata-playground

.PHONY: build
build:  ## Builds a package, as a tarball and a wheel by default.
	poetry build

.PHONY: install
install:  ## Installs the project dependencies.
	poetry install

.PHONY: env-info
env-info: ## Displays information about the current environment.
	poetry env info

.PHONY: env-list
env-list: ## ists all virtualenvs associated with the current project.
	poetry env list

.PHONY: run
run:
	SETUPTOOLS_USE_DISTUTILS=${SETUPTOOLS_USE_DISTUTILS} poetry run python ml_metadata_playground/metadata.py

.PHONY: docker-db
docker-db:
	docker run -it --rm -p 3306:3306 --cap-add=sys_nice --name mysql -e MYSQL_USER=test -e MYSQL_PASSWORD=secret -e MYSQL_DATABASE=metadata -e MYSQL_ROOT_PASSWORD=root mysql
