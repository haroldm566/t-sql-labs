/*
Using Transact-SQL : Exercises
------------------------------------------------------------
Note: I will be marking off the first lab from the second week on Friday, make sure you have committed your work to GitHub.
		


Exercises for section 9 : UPDATE

*In all exercises, write the answer statement and then execute it.


e9.1	Change the name of IN628 to 'Object-Oriented Software Development (discontinued after 2020)'  
*/

SELECT * FROM Paper

UPDATE Paper SET PaperName = 'Object-Oriented Software Development (discontinued after 2020)'
WHERE PaperID = 'IN628'

--e9.2	For all the semesters that start after 01-June-2018, alter the end date
--		to be 14 days later than currently recorded.

UPDATE Semester SET EndDate = DATEADD(DAY, 14, EndDate)
WHERE StartDate > '2018-06-01'

--e9.3	Imagine a strange enrolment requirement regarding the students
--		enrolled in IN238 for 2020S1 [Ensure your database has all the records
--		created by exercise e8.4]: all students with short names [length of FullName
--		is less than 12 characters] must have their enrolment moved 
--		from 2020S1 to 2019S2. Write a statement that will perform this enrolment change.
		
		--Ensure you create the related paperInstance

		-- answer
		UPDATE Enrolment SET SemesterID = '2019S2'
		select distinct e.PersonID, p.FullName from Enrolment e
		join Person p on e.PersonID = p.PersonID
		WHERE LEN(p.FullName) < 12 AND e.PaperID = 'IN238' AND e.SemesterID = '2020S1'

--Exercises for section 10 : DELETE

--*In all exercises, write the answer statement and then execute it.

--e10.1	Write a statement to delete all enrolments for IN238 Extraspecial Topic in semester 2020S11.

DELETE FROM Enrolment
WHERE PaperID = 'IN238'

--e10.2	Delete all PaperInstances that have no enrolments.
DELETE FROM PaperInstance
WHERE PaperID NOT IN (SELECT e.PaperID FROM Enrolment e)