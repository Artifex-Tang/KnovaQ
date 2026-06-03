FROM python:3.11-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget curl unzip fonts-wqy-zenhei fonts-noto-cjk \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tests
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt \
    && playwright install chromium \
    && playwright install-deps chromium

COPY . .

RUN mkdir -p /tests/reports/allure-results

ENTRYPOINT ["pytest", "--alluredir=/tests/reports/allure-results"]
