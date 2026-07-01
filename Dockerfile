#FROM python:3.6-slim-stretch
FROM python:3.12-slim-bookworm

COPY . /mediapipe/

WORKDIR /mediapipe/

RUN bash install.sh

CMD ["make", "start"]