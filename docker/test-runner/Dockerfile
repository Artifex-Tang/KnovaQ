FROM python:3.11-slim

RUN sed -i 's|deb.debian.org|mirrors.aliyun.com|g' /etc/apt/sources.list.d/debian.sources 2>/dev/null || \
    sed -i 's|deb.debian.org|mirrors.aliyun.com|g' /etc/apt/sources.list 2>/dev/null || true
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget curl unzip fonts-wqy-zenhei \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tests
COPY requirements.txt .
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple \
    && pip config set global.trusted-host pypi.tuna.tsinghua.edu.cn
RUN pip install --no-cache-dir -r requirements.txt

RUN playwright install chromium

# Retry apt-get up to 3 times for flaky large packages (libllvm19 ~60MB)
RUN for i in 1 2 3; do \
        apt-get update && playwright install-deps chromium && break || \
        (echo "Retry $i for playwright install-deps" && rm -rf /var/lib/apt/lists/* && sleep 5); \
    done && rm -rf /var/lib/apt/lists/*

COPY . .

RUN mkdir -p /tests/reports/allure-results

ENTRYPOINT ["pytest", "--alluredir=/tests/reports/allure-results"]
