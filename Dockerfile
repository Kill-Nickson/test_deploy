FROM python:3.10-alpine

# postgres
RUN apk add --no-cache postgresql-libs && \
    apk add --no-cache --virtual .build-deps gcc musl-dev postgresql-dev g++ libxslt-dev

# pillow
# RUN apk add --no-cache jpeg-dev zlib-dev

# translations
# RUN apk add gettext-dev

# xhtml2doc (see SEC-1485 and PR#156)
# RUN apk add --no-cache libffi-dev

# reportlab
# RUN apk add --no-cache freetype-dev

WORKDIR /app

# install dependencies
# ENV DJANGO_SETTINGS_MODULE=core.settings_docker
COPY requirements.txt requirements.txt
# COPY dist dist
RUN pip install -r requirements.txt
RUN pip install psycopg2-binary gunicorn

# copy source
COPY . .

# generate static files & translations
RUN python manage.py collectstatic --noinput
# RUN python manage.py collectstatic --settings "test_deploy.settings"
# RUN python manage.py compilemessages

# server
EXPOSE 8000
CMD ["gunicorn", "--bind", ":8000", "--workers", "3", "test_deploy.wsgi"]
