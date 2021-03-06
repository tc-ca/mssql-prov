FROM mcr.microsoft.com/mssql/server:2017-latest

ARG DB_USERNAME=SA
ENV DB_USERNAME=${DB_USERNAME}

ARG DB_PASSWORD
ENV DB_PASSWORD=${DB_PASSWORD}

ARG PATCH_HISTORY_DB=master
ENV PATCH_HISTORY_DB=${PATCH_HISTORY_DB}
ARG PATCH_HISTORY_SCHEMA=dbo
ENV PATCH_HISTORY_SCHEMA=${PATCH_HISTORY_SCHEMA}
ARG PATCH_HISTORY_TABLE=PATCH_HISTORY
ENV PATCH_HISTORY_TABLE=${PATCH_HISTORY_TABLE}

ARG DB_NAME
ENV DB_NAME=${DB_NAME}
ENV ACCEPT_EULA=Y

RUN mkdir /app
RUN mkdir /app/provision/
RUN mkdir /app/patch/
COPY ./app/ /app/
RUN chmod +x -R /app/*.sh

#RUN /bin/bash -c "/opt/mssql/bin/sqlservr & /app/provision.sh"

EXPOSE 1433

CMD /bin/bash -c "/app/entrypoint.sh & /opt/mssql/bin/sqlservr"