CREATE DATABASE IF NOT EXISTS $(PATCH_HISTORY_DB)
GO

USE [$(PATCH_HISTORY_DB)]
GO

CREATE TABLE PATCH_HISTORY
(
	PATCH_FILE_NM NVARCHAR(255),
	APPLIED_DTE DATETIME,
	VERSION_CD NVARCHAR(15),
	COMMENTS_TXT NVARCHAR(255)
)
GO

SELECT "Provision complete!"
GO