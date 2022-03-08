/*
Using Transact-SQL : Exercises
------------------------------------------------------------


Exercises for section 8 : INSERT

In all exercises, write the answer statement and then execute it.
-- These initial steps are to setup the database to ensure the necessary data is present


e8.1	Write an insert statement to create 2 new papers: IN338 and IN238 both called 'Extraspecial Topic' 


e8.2	Create a new user (yourself)
		Write the insert statements that will add three enrolments for you
		in papers you have completed (Add extra papers if required).
		
		 

e8.3	Imagine that every paper on the database will run in 2021.
		Write the statements that will create all the necessary paper instances. You will need to add the Semester
		This can be done using a subselect or a left outer join.

e8.4	Imagine a strange path-of-study requirement: in semester 2020S1
		Find all people who were enrolled in IN605 and not enrolled in IN612 in 2019S2 and enrol them in IN238.
		Write a statement to create the correct paper instance for IN238.
		Write a statement that will find all people enrolled in IN605 (semester 2019S2)
		but	not enrolled in IN612 (semester 2019S2) and 
		will create IN238 (semester 2020S1) enrolments for them. Build it up one step at a time.
		
		1. create paper, semester and paper instance data
		2. Find IN605/2019S2 enrolments that are not in IN612
		3. insert new enrolments
*/

--	8.1
INSERT INTO Paper (PaperID, PaperName)
VALUES ('IN338', 'Extraspecial Topic')

INSERT INTO Paper (PaperID, PaperName)
VALUES ('IN238', 'Extraspecial Topic')

--	8.2
--		Create a new user
INSERT INTO Person (PersonID, GivenName, FamilyName, FullName)
VALUES ('112', 'Harold', 'Mandal', 'Harold Mandal')

--		Enrolment inserts
INSERT INTO Enrolment (PaperID, SemesterID, PersonID)
VALUES ('IN511', '2019S2', '112')

INSERT INTO Enrolment (PaperID, SemesterID, PersonID)
VALUES ('IN512', '2020S1', '112')

INSERT INTO Enrolment (PaperID, SemesterID, PersonID)
VALUES ('IN605', '2020S1', '112')

--	8.3
--		Add papers that aren't in 2021S2 already
--			so now every paper will be running in that semester
INSERT INTO PaperInstance (PaperID, SemesterID)
SELECT p.PaperID, '2021S2' AS [SemesterID] FROM Paper p
WHERE p.PaperID NOT IN (SELECT DISTINCT ppi.PaperID FROM PaperInstance ppi
LEFT JOIN Semester s ON ppi.SemesterID = s.SemesterID)

--	8.4
/*
e8.4	Imagine a strange path-of-study requirement: in semester 2020S1
		Find all people who were enrolled in IN605 and not enrolled in IN612 in 2019S2 and enrol them in IN238.
		Write a statement to create the correct paper instance for IN238.
		Write a statement that will find all people enrolled in IN605 (semester 2019S2)
		but	not enrolled in IN612 (semester 2019S2) and 
		will create IN238 (semester 2020S1) enrolments for them. Build it up one step at a time.
		
		1. create paper, semester and paper instance data
		2. Find IN605/2019S2 enrolments that are not in IN612
		3. insert new enrolments
*/

--		Create the paper instance
INSERT INTO PaperInstance (PaperID, SemesterID)
VALUES ('IN238', '2020S1')

--		Find people enrolled in IN605, not in IN602 that are in 2019S2
--			and enrol them
INSERT INTO Enrolment (PaperID, SemesterID, PersonID)
SELECT 'IN238' AS [PaperID], '2020S1' AS [SemesterID], p.PersonID FROM Person p
JOIN Enrolment e ON p.PersonID = e.PersonID
WHERE e.PaperID = 'IN605' AND e.SemesterID = '2019S2' AND e.PaperID != 'IN602' 