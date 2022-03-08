USE [LabUserTest]
GO
CREATE SCHEMA [Users] AUTHORIZATION [dbo]
GO

DROP TABLE Users.userDetails
create table [Users].[userDetails]
(
	[StudentID] int NOT NULL,
	[LastName] nvarchar(100) NOT NULL,
	[FirstName] nvarchar(100) NOT NULL,
	[Username] nvarchar(100) NOT NULL,
	[Password] nvarchar(100) NOT NULL
)

USE LabUserTest;
select * from Users.userDetails;

--2.	Using the imported data, for each user create a database, SQL Server Login and a database user – you should be able to test this by logging in to SSMS as a created user


IF EXISTS (SELECT * FROM Users.userDetails)
BEGIN
	DECLARE @row int, @personID nvarchar(30), @maxRows int
	SELECT @maxRows = max(RowNumber) from @Users.userDe

	WHILE @row <= @maxRows
	BEGIN
		--	Create database
		DECLARE @dbFilePath nvarchar(2000) DECLARE @dbLogPath nvarchar(2000)
		DECLARE @createFolderXP nvarchar(2000) DECLARE @domainLogin nvarchar(30) 
		DECLARE @prefix nvarchar(200)
		DECLARE @dbName nvarchar(1000)
		DECLARE @logicalDataName nvarchar(600) DECLARE @logicalLogName nvarchar(600) DECLARE @dataFileName nvarchar(600) DECLARE @logFileName nvarchar(600)
		DECLARE @dataSize nvarchar(500) 
		DECLARE @dataMaxSize nvarchar(500) DECLARE @dataFileGrowth nvarchar(500) DECLARE @logSize nvarchar(500) 
		DECLARE @logMaxSize nvarchar(500) DECLARE @logFileGrowth nvarchar(500)
		DECLARE @exeTemp nvarchar(500)

		SELECT * FROM sys.syslogins;

		BEGIN
			PRINT('Begin create database')
			SET @LogicalDataName=@DBName + '_dat'
			SET @DataFileName= @dbFilePath + @DBName + '.mdf'
			SET @LogicalLogName=@DBName + '_log'
			SET @LogFileName= @dbLogPath + @DBName + '.ldf'

			SET @exeTemp = 'CREATE DATABASE ' + @DBName + ' ON ('
			+ 'NAME = [' + @LogicalDataName + '], '
			+ 'FILENAME = [' + @DataFileName + '], '
			+ 'SIZE = ' + @DataSize + ', '
			+ 'MAXSIZE = ' + @DataMaxSize + ', '
			+ 'FILEGROWTH = ' + @DataFileGrowth + ') '
			+ 'LOG ON ('
			+ 'NAME = [' + @LogicalLogName + '], '
			+ 'FILENAME = [' + @LogFileName + '], '
			+ 'SIZE = ' + @LogSize + ', '
			+ 'MAXSIZE = ' + @LogMaxSize + ', '
			+ 'FILEGROWTH = ' + @LogFileGrowth + ') ' PRINT('Creating database ' + @DBName)
			PRINT(exeTemp)
		END(@exeTemp)

		-- Create sql server login
		DECLARE @ExecTemp nvarchar(1000)
		DECLARE @_Login nvarchar(100), @_Password nvarchar(100), @_DefaultDatabase nvarchar(100)

		BEGIN
			SET @ExecTemp = 'CREATE LOGIN ' + @_Login + ' WITH PASSWORD = ''' + @_Password + ''', DEFAULT_DATABASE = ' + @_DefaultDatabase 
			PRINT (@ExecTemp)
			EXEC (@ExecTemp)
		END

		--	Create database user
		SET @exeTemp='USE ' + @_DBName + ' CREATE USER [' + @_Login + '] FOR LOGIN [' + @_Login + ']'

		--	Move onto next row and repeat above
		SET @num1 += 1
	END
END