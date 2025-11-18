FROM python:3.10-slim

WORKDIR /app

# mysqlclient 빌드에 필요한 패키지들 설치
RUN apt-get update && apt-get install -y \
    default-libmysqlclient-dev \
    build-essential \
    pkg-config \
    python3-dev \
    mariadb-client \
    gcc \
    && apt-get clean

COPY requirements.txt .

RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

COPY . .
# collectstatic 실행
RUN python manage.py collectstatic --noinput
EXPOSE 8000

CMD ["gunicorn", "config.wsgi:application", "-b", "0.0.0.0:8000", "-w", "2"]

