FROM mcr.microsoft.com/mssql/server:2017-latest

ARG SA_PASSWORD
ENV SA_PASSWORD=${SA_PASSWORD}

ARG PATCH_HISTORY_DB=${PATCH_HISTORY_DB}
ENV PATCH_HISTORY_DB=${PATCH_HISTORY_DB}
ARG PATCH_HISTORY_TABLE=${PATCH_HISTORY_TABLE}
ENV PATCH_HISTORY_TABLE=${PATCH_HISTORY_TABLE}

ARG DB_NAME
ENV DB_NAME=${DB_NAME}
ENV ACCEPT_EULA=Y

RUN mkdir /app
COPY ./app/ /app/
RUN chmod +x -R /app/*.sh

#RUN /bin/bash -c "/opt/mssql/bin/sqlservr & /app/provision.sh"

EXPOSE 1433

CMD /bin/bash -c "/app/entrypoint.sh & /opt/mssql/bin/sqlservr"