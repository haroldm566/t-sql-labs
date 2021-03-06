/****** Script for SelectTopNRows command from SSMS  

SELECT TOP (1000) [PaperID]
      ,[SemesterID]
      ,[PersonID]
  FROM [yourDatabaseName].[dbo].[Enrolment]
  
  Week 3 labs are due on Friday 26 March

 13.1 Develop a stored procedure [EnrolmentCount] that accepts a paperID
		and a semesterID and calculates the number of enrolments in the 
		relevant paper instance. It returns the enrolment count as an
		output parameter.
*/
CREATE OR ALTER PROC getEnrolmentCount(@paperID nvarchar(10), @semesterID char(10))
AS
SET NOCOUNT ON
SELECT COUNT(e.PersonID) AS [Enrolment Count In That Paper And Semester] FROM Enrolment e
WHERE e.PaperID = @paperID AND e.SemesterID = @semesterID
GO

EXEC getEnrolmentCount 'IN512', '2019S2'

GO

/*		
13.2	Re-develop stored procedure [EnrolmentCount] so that semesterID
		is optional and defaults to the current semester. If there is no
		current semester, it chooses the most recent semester. 
*/

CREATE OR ALTER PROCEDURE getEnrolmentCount(@paperID nvarchar(10), @semesterID char(10) = NULL)
AS
BEGIN
	-- Grab current semester if @semesterID is null
	IF @semesterID IS NULL
		SELECT @semesterID=SemesterID FROM Semester WHERE GETDATE() BETWEEN StartDate AND EndDate;
	ELSE
		SELECT TOP 1 @semesterID=SemesterID FROM Semester ORDER BY SemesterID DESC;

	SELECT COUNT(e.PersonID) AS [Enrolment Count In That Paper And Semester] FROM Enrolment e
	WHERE e.PaperID = @paperID AND e.SemesterID = @semesterID
END
GO

EXEC getEnrolmentCount 'IN705'

GO

 /*
13.3  Write the script you will need to test 13.2 hint: you may have to cast your output.
*/
EXEC getEnrolmentCount 'IN705'

GO