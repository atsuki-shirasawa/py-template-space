##########################################
# build base image
##########################################
FROM python:3.9.10-slim as builder

RUN apt-get -y update && apt-get install -y --no-install-recommends \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# install poetry
RUN curl -sSL https://install.python-poetry.org | python -
ENV PATH /root/.local/bin:$PATH

WORKDIR /root
COPY pyproject.toml poetry.lock ./
RUN poetry export -f requirements.txt --without-hashes --output requirements.txt

##########################################
# build deploy image
##########################################
FROM python:3.9.10-slim

RUN apt-get -y update && apt-get install -y --no-install-recommends \
    tzdata \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV TZ Asia/Tokyo

WORKDIR /root
COPY --from=builder /root/requirements.txt .
RUN pip install --upgrade pip \
    pip install --no-cache-dir -r requirements.txt

COPY src ./src

ENTRYPOINT ["python", "src/main.py"]