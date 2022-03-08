/*
Using Transact-SQL : Exercises
------------------------------------------------------------

Exercises for section 12 : STORED PROCEDURE

*In all exercises, write the answer statement and then execute it.



e12.1		Create a SP that returns the people with a family name that 
			starts with a vowel [A,E,I,O,U]. List the PersonID and the FullName.
*/
CREATE OR ALTER PROCEDURE getVowels
AS
SELECT PersonID, FullName FROM Person
WHERE FullName LIKE '%a%'
OR FullName LIKE '%e%'
OR FullName LIKE '%i%'
OR FullName LIKE '%o%'
OR FullName LIKE '%u%'
GO

EXEC getVowels
GO
			
--e12.2		Create a SP that accepts a semesterID parameter and returns the papers that
--			have enrolments in that semester. List the PaperID and PaperName.
CREATE PROCEDURE paperEnrolments (@sID nvarchar(10))
AS
SELECT p.PaperID, p.PaperName FROM Paper p
JOIN PaperInstance ppi ON p.PaperID = ppi.PaperID
JOIN Enrolment e ON ppi.PaperID = e.PaperID
WHERE e.SemesterID = @sID
GO

EXEC paperEnrolments '2019S1'
GO
			
--e12.3		Modify the SP of 12.2 so that the parameter is optional.
--			If the user	does not supply a parameter value default to the current semester.
--			If there is no current semester default to the most recent semester.
CREATE PROCEDURE paperEnrolmentsv2 (@sID nvarchar(10))
AS
IF(@sID IS NULL OR @sID = '')
SELECT p.PaperID, p.PaperName FROM Paper p
JOIN PaperInstance ppi ON p.PaperID = ppi.PaperID
JOIN Enrolment e ON ppi.PaperID = e.PaperID
WHERE e.SemesterID = @sID
GO

EXEC paperEnrolmentsv2 ''
GO
			
--e12.4		Create a SP that creates a new semester record. the user must supply all
--			appropriate input parameters.
CREATE PROC newSemester (@sID nvarchar(10), @startDate datetime, @endDate datetime)
AS
INSERT Semester(SemesterID, StartDate, EndDate)
VALUES (@sID, @startDate, @endDate)
GO

EXEC newSemester '', '', ''
GO
		
