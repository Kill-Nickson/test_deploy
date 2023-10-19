FROM python:3.10-alpine

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# postgres
RUN apk add --no-cache postgresql-libs && \
  apk add --no-cache --virtual .build-deps gcc musl-dev postgresql-dev g++ libxslt-dev cargo

# pillow
# RUN apk add --no-cache jpeg-dev zlib-dev

# translations
# RUN apk add gettext-dev

# xhtml2doc (see SEC-1485 and PR#156)
# RUN apk add --no-cache libffi-dev

# reportlab
# RUN apk add --no-cache freetype-dev

# VsCode support
# RUN apk add libstdc++ git openssh-client

RUN pip install --upgrade pip

WORKDIR /app

# install dependencies
# ENV DJANGO_SETTINGS_MODULE=core.settings_docker
COPY requirements.txt requirements.txt
# COPY dist dist
RUN pip install -r requirements.txt

# COPY requirements_dev.txt requirements_dev.txt
# RUN pip install -r requirements_dev.txt

RUN pip install psycopg2-binary

# RUN mkdir -p /root/.jupyter
# RUN echo '{"NotebookApp": { \
#   "allow_origin": "https://nb.secjur.test:4433",\
#   "port": 8888,\
#   "open_browser": false,\
#   "allow_remote_access": true,\
#   "allow_password_change": true,\
#   "trust_xheaders": true,\
#   "custom_display_url": "nb.secjur.test",\
#   "quit_button": false\
#   }\
#   }\
#   ' > /root/.jupyter/jupyter_notebook_config.json

# Install Azure CLI
# RUN pip install --no-cache-dir --prefer-binary azure-cli

# For jupyter notebook
# EXPOSE 8888

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
