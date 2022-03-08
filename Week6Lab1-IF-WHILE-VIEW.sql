/*
Using Transact-SQL : Exercises
------------------------------------------------------------
-- Careful of any triggers you may have running FROM the previous lab.
-- You can list all triggers by querying the sys.triggers view
SELECT * FROM sys.triggers

Exercises for Section 15


15.1    Develop a view [BigPaperInstance] that finds the 10 paper instances
		with the most enrolments. Show the paperID, paper name,
		semesterID, start date and end date of the paper instance.
*/
		GO
        CREATE VIEW BigPaperInstance
        AS
        SELECT TOP 10 p.PaperName, p.PaperID, s.StartDate, s.EndDate, COUNT(ppi.PaperID) AS [Instance] FROM Paper p
        JOIN PaperInstance ppi on p.PaperID = ppi.PaperID
        JOIN Enrolment e on ppi.PaperID = e.PaperID
        JOIN Semester s on ppi.SemesterID = s.SemesterID
        GROUP BY p.PaperName, p.PaperID, s.StartDate, s.EndDate, ppi.PaperID
        ORDER BY COUNT(ppi.PaperID) Desc
		GO
        SELECT * FROM BigPaperInstance
		GO
/*
15.2    Develop a view [SmallPaper] that finds the 10 paper instances
		with the least (lowest number of) enrolments. Show the paperID, paper name,
		semesterID, start date and end date of the paper instance.
*/
		GO
        CREATE VIEW SmallPaper
        AS
        SELECT TOP 10 p.PaperName, p.PaperID, s.StartDate, s.EndDate, COUNT(i.PaperID) AS [instance] FROM Paper p
        JOIN PaperInstance i on p.PaperID = i.PaperID
        JOIN Enrolment e on i.PaperID = e.PaperID
        JOIN Semester s on i.SemesterID = s.SemesterID
        GROUP BY p.PaperName, p.PaperID, s.StartDate, s.EndDate, i.PaperID
        ORDER BY COUNT(i.PaperID) Asc
		GO
        SELECT * FROM SmallPaper
		GO

/*
15.3	Write a view that lists all the current first year students
-- you will need to have a current semester and some students enrolled
*/

		GO
        CREATE VIEW FirstYears
        AS
        SELECT distinct p.FullName, s.SemesterID FROM Person p
        JOIN Enrolment e on p.PersonID = e.PersonID
        JOIN PaperInstance i on e.PaperID = i.PaperID
        JOIN Semester s on i.SemesterID = s.SemesterID
        WHERE s.SemesterID = '2021S1' or s.SemesterID = '2021S2'
		GO
        SELECT * FROM FirstYears
		GO
/*
***************************************************************************************

		You can reference a Database table even if you are not 
		currently connected to it as long as you use its fully qualified domain name.
		The following two questions are using the countries table in the World Database.
		You can use this to find the FQDN for World using a new query pointed at that Database:

			SELECT
				 @@SERVERNAME [server name],
				 DB_NAME() [database name],
				 SCHEMA_NAME(schema_id) [schema name], 
				 name [table name],
				 object_id,
				 "fully qualified name (FQN)" =
				 concat(QUOTENAME(DB_NAME()), '.', QUOTENAME(SCHEMA_NAME(schema_id)),'.', QUOTENAME(name))
			FROM sys.tables
			WHERE type = 'U' -- USER_TABLE
Using World:

15.4    Develop a view [ConsonantCountry] that lists the countries that have a name
		starting with a consonant (b c d f g h j k l m n p q r s t v w x y z).
		Show the code and name of each country.
		//Suggestion from Krissi
		select Code, Name
		from [World].[dbo].[country]
		where left(name, 1) not in ('a', 'e', 'i', 'o', 'u')
*/
		GO
        CREATE VIEW ConsonantCountry
        AS 
        SELECT Code, Name
        FROM [World].[dbo].[country]
        WHERE Name LIKE '[b,c,d,f,g,h,j,k,l,m,n,p,q,r,s,t,v,w,x,y,z]%'
		GO
        SELECT * FROM ConsonantCountry
		GO

/*
15.5   Develop a view [RecentlyIndependentCountry] that lists countries that 
		gained their independence within the last 100 years. 
		Make sure the view adjusts the resultset to take account of the date when it is run.

*/
	GO
    CREATE VIEW RecentlyIndependentCountry
    AS 
    SELECT *
    FROM [World].[dbo].[country]
    WHERE IndepYear 
    BETWEEN datepart(year, dateadd(year, -100, GETDATE()))
    AND datepart(year, dateadd(year, 0, GETDATE()))
	GO
    SELECT * FROM RecentlyIndependentCountry
	GO
