# mssql-prov [![MicroBadger Layers (tag)](https://img.shields.io/microbadger/layers/teamdman/mssql-prov/latest)](https://hub.docker.com/repository/docker/teamdman/mssql-prov)

A docker container that allows for easy provisioning and patching of Microsoft SQL Server instances.

## Usage

```
yourapp
├── Dockerfile
├── patch
│   ├── patch name
│   │   ├── patch.sql
│   │   ├── comments
│   │   └── version
│   ├── patch name
│   │   ├── patch.sql
│   │   ├── comments
│   │   └── version
│   └── patch name
│       ├── run.sh
│       ├── comments
│       └── version
└── provision
    ├── a.sql
    ├── b.sh
    └── c.sql
```

The items in the provision directory are executed once when the server starts for the first time.\
Specifically, they are ran when the table that tracks the applied patches is not detected.

The items in the patch directory are executed every time the server starts, if they have not executed before.\
The executed patches are tracked in a table created by the provided provision script.

Dockerfile:

```dockerfile
FROM teamdman/mssql-prov:latest
WORKDIR /app/
ADD ./patch/ /app/patch/
ADD ./provision/ /app/provision/
```

Environment variables:

```ino
SA_PASSWORD=YourPasswordHere
```

[_NOTE: The password should follow the SQL Server default password policy, otherwise the container can not setup SQL server and will stop working. By default, the password must be at least 8 characters long and contain characters from three of the following four sets: Uppercase letters, Lowercase letters, Base 10 digits, and Symbols. You can examine the error log by executing the docker logs command._](https://docs.microsoft.com/en-us/sql/linux/quickstart-install-connect-docker?view=sql-server-2017&pivots=cs1-bash)

## Example

[See the provided example.](/example)
