FROM python:3.12.7-slim

ENV TZ=Etc/UTC
WORKDIR /src

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libpq-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Drop root privileges: a compromised bot must not gain root in the container.
RUN useradd --uid 10001 --create-home --no-log-init appuser \
    && mkdir -p /src/logs \
    && chown -R appuser:appuser /src
USER appuser

CMD ["python", "-m", "src"]