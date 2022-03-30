FROM ubuntu:20.04 as python-base

ENV PYTHONFAULTHANDLER=1 \
  PYTHONUNBUFFERED=1 \
  PYTHONHASHSEED=random \
  PIP_NO_CACHE_DIR=off \
  PIP_DISABLE_PIP_VERSION_CHECK=on \
  PIP_DEFAULT_TIMEOUT=100 \
  POETRY_VERSION=1.1.11 \
  SETUPTOOLS_USE_DISTUTILS=stdlib

ARG PYTHON_VERSION_SHORT=3.8
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.9 python3.9-dev python3-pip libssl-dev libmysqlclient-dev && \
    ln -s -f /usr/bin/python${PYTHON_VERSION_SHORT} /usr/bin/python3 && \
    ln -s -f /usr/bin/python${PYTHON_VERSION_SHORT} /usr/bin/python && \
    ln -s -f /usr/bin/pip3 /usr/bin/pip

# COPY  ml_metadata-1.8.0.dev0-cp39-cp39-manylinux2010_x86_64.whl /code/dist/

RUN python -m pip install "poetry==$POETRY_VERSION" && \
    python -m pip install ml-metadata

WORKDIR /code
COPY poetry.lock pyproject.toml /code/
RUN poetry install --no-interaction

COPY ml_metadata_playground/ /code/ml_metadata_playground
COPY tests/ /code/tests

CMD ["python", "ml_metadata_playground/metadata.py"]
