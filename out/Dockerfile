FROM python:3.10-alpine

RUN \
 apk add --no-cache postgresql-libs && \
 apk add --no-cache --virtual .build-deps gcc musl-dev postgresql-dev && \
 python3 -m pip install flask psycopg2 configparser --no-cache-dir && \
 apk --purge del .build-deps

COPY . .

WORKDIR srv/app

ENTRYPOINT [ "python3", "-m", "flask", "run" ]
CMD [ "--host=0.0.0.0", "--port=80" ]

EXPOSE 80
