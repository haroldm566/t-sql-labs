/*
Using Transact-SQL : Exercises
------------------------------------------------------------
Exercises for section 6 Subqueries

e6.1	List the paper with the lowest average enrolment per instance. Ignore all papers with no enrolments.
	Display the paper ID, paper name and average enrolment count.
*/
-- (needs testing to make sure it works as said above)
SELECT p.PaperID, p.PaperName, CAST(AVG([Students Enrolled]) AS DECIMAL(10,1)) AS [Average Enrolment Count] FROM Paper p
JOIN (SELECT e.PaperID, e.SemesterID, COUNT(e.PaperID) AS [Students Enrolled]
	  FROM Enrolment AS e
	  JOIN Paper AS p ON e.PaperID = p.PaperID
	  WHERE p.PaperID = e.PaperID
	  GROUP BY e.PaperID, e.SemesterID) AS e2 ON e2.PaperID = p.PaperID
JOIN Semester s ON e2.SemesterID = s.SemesterID
GROUP BY p.PaperID, p.PaperName 
ORDER BY [Average Enrolment Count] ASC

/*
e6.2	List the paper with the highest average enrolment per instance. 
	Display the paper ID, paper name and average enrolment count.
*/

/*
e6.3	For each paper that has a paper instance: list the paper ID, paper name, 
	starting date of the earliest instance, starting date of the most recent instance, 
	the minimum number of enrolments in the instances,
	maximum number of enrolments in the instances and 
	average number of enrolments across all	the instances.
*/
SELECT p.PaperID, p.PaperName,
MIN(s.StartDate) AS [Earliest StartDate],
MAX(s.StartDate) AS [Most Recent StartDate],
CAST(AVG([Students Enrolled]) AS DECIMAL(10,1)) AS [Average Enrolments]
FROM Paper p
JOIN (SELECT e.PaperID, e.SemesterID, COUNT(e.PersonID) AS [Minimum Enrolments], COUNT(e.PersonID) AS [Maximum Enrolments], COUNT(e.PaperID) AS [Students Enrolled]
FROM Enrolment e
JOIN PaperInstance ppi ON e.PaperID = ppi.PaperID
group by e.PaperID, e.SemesterID) AS e2 ON p.PaperID = e2.PaperID
JOIN Semester s ON e2.SemesterID = s.SemesterID
GROUP BY p.PaperID, p.PaperName, e2.[Minimum Enrolments], e2.[Maximum Enrolments]
ORDER BY [Minimum Enrolments] DESC, [Maximum Enrolments] ASC, [Average Enrolments] DESC

/*
e6.4	Which paper attracts people with long names? Find the background statistics 
	to support a hypothesis test: for each paper with enrolments calculate the mean full name length, 
	sample standard deviation full name length & sample size (that is: number of enrolments).
*/
SELECT DISTINCT e.PaperID, COUNT(e.PersonID) AS [ Sample Size ], [ fnLength ] AS [ Mean fnLength ],[ STDEV fnLength ] FROM Enrolment e
JOIN (SELECT pa.PaperID, SUM(LEN(p.FullName))/COUNT(LEN(p.FullName)) AS [ fnLength ], STDEV(LEN(p.FullName)) AS [ STDEV fnLength ] FROM Person p
		JOIN Enrolment e ON p.PersonID = e.PersonID
		JOIN Paper pa ON e.PaperID = pa.PaperID
		WHERE e.PaperID = pa.PaperID
		GROUP BY pa.PaperID) AS p2 ON e.PaperID = p2.PaperID
GROUP BY e.PaperID, [ fnLength ],[ STDEV fnLength ]

/*
e6.5	Rank the semesters from the most loaded (that is: the highest number of enrolments) to
	the least loaded. Calculate the ordinal position (1 for first, 2 for second...) of the semester
	in this ranking.
*/
SELECT s.SemesterID, COUNT(e.PersonID) AS [ Enrolment Count ], RANK() OVER (ORDER BY COUNT(e.PersonID) DESC) FROM Semester s
LEFT JOIN Enrolment e ON s.SemesterID = e.SemesterID
GROUP BY s.SemesterID
ORDER BY [ Enrolment Count ] DESC
/*
Exercises for section 7

--Use UNION to solve these tasks. 
--Note that these tasks could possibly be solved by another non-UNION statement.
--Can you also write a non-UNION statement that produces the same result?   

e7.1	In one result, list all the people who enrolled in a paper delivered during 2019 and
	all the people who have enrolled in IN605. 
	The result should have three columns: PersonID, Full Name and the reason the person
	is on the list - either 'enrolled in 2019' or 'enrolled in IN605'
*/
SELECT DISTINCT p.PersonID, p.FullName, 'Enrolled in 2019' AS [Reason] FROM Person p
JOIN Enrolment e ON p.PersonID = e.PersonID
JOIN PaperInstance pi ON e.SemesterID = pi.SemesterID
JOIN Semester s ON pi.SemesterID = s.SemesterID
WHERE YEAR(s.StartDate) = 2019
UNION ALL
SELECT DISTINCT p.PersonID, p.FullName, 'Enrolled in IN605' AS [Reason] FROM Person p
JOIN Enrolment e ON p.PersonID = e.PersonID
JOIN PaperInstance pi ON e.SemesterID = pi.SemesterID
JOIN Paper pp ON pi.PaperID = pp.PaperID
WHERE pp.PaperID = 'IN605' 

/*
e7.2	Produce one resultset with two columns. List the all Paper Names and all the Person Full Names in one column.
	In the other column calculate the number of characters in the name.
	Sort the result with the longest name first.
*/
SELECT p.FullName AS [Paper Names & Full Names], LEN(p.FullName) AS [ Name Length ] FROM Person p
UNION
SELECT PaperName, LEN(PaperName) FROM Paper
ORDER BY [ Name Length ] DESC
