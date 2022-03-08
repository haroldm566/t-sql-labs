/*
Using Transact-SQL : Exercises
------------------------------------------------------------

Exercises for section 11 : TRIGGER

*In all exercises, write the answer statement and then execute it.

*Before you start, run these statements against your database:

		create table [Password](
			PersonID nvarchar(16) not null primary key,
			pwd char(4) not null default left(newID(), 4)  --automatically create a new password
			constraint [fk_password_person] foreign key (PersonID) references Person (PersonID) 	
			on delete cascade on update cascade 			
			)

		insert Person (PersonID, GivenName, FamilyName, FullName)
		values ('122', 'Krissi', 'Wood', 'Krissi Wood')

		drop table Withdrawn

	 	create table Withdrawn(
			PaperID nvarchar(10) not null,
			SemesterID char(6) not null,
			PersonID nvarchar(16) not null,
			WithdrawnDateTime datetime not null default getdate()
			constraint [pk_withdrawn] primary key (PaperID, SemesterID, PersonID)
			)
*/

--e11.1		Create a trigger that reacts to new records on the Person table. 
--			The trigger creates new related records on the Password table, automatically creating passwords.	

CREATE TRIGGER autoCreatePassword ON Person
AFTER INSERT
AS
BEGIN
	INSERT INTO [Password] (PersonID, pwd)
	SELECT PersonID FROM inserted, [pwd]
END
GO

DROP TRIGGER autoCreatePassword

GO
		
--e11.2		Create a trigger that reacts to new paper instances
--			by automatically making an enrolment for Krissi Wood in those paper instances
			
--			drop trigger trigPaperInstanceInsert
			
CREATE TRIGGER autoCreateEnrolment ON PaperInstance			
AFTER INSERT
AS
BEGIN
	INSERT INTO Enrolment (PaperID, SemesterID, PersonID)
	SELECT i.PaperID, i.SemesterID, p.PersonID FROM inserted i
	JOIN Enrolment e ON i.PaperID = e.PaperID
	JOIN Person p ON e.PersonID = p.PersonID
	WHERE p.PersonID = 122
END
GO

DROP TRIGGER autoCreateEnrolment

GO

--e11.3		Create two triggers that record the people who withdraw or dropout of a paper 
--			when it is running [compare the system date to the semester dates].
--			The details of the withdrawl should be posted to the Withdrawn table.

--create table Withdrawn(
--			PaperID nvarchar(10) not null,
--			SemesterID char(6) not null,
--			PersonID nvarchar(16) not null,
--			WithdrawnDateTime datetime not null default getdate()
--			constraint [pk_withdrawn] primary key (PaperID, SemesterID, PersonID)
--			)

--1.	If a student can withdraw from a paper, then re-enrol, then withdraw again in one single semester.
--	BTW: this is NOT how things run at Otago Polytechnic.

--				--if person already has a withdrawn record for this paper instance
--				--insert will cause a PK violation, so
--				--delete the existing record before inserting new record
GO
CREATE TRIGGER recordWithdrawal ON Enrolment
AFTER DELETE
AS
BEGIN
	--if person already has a withdrawn record for this paper instance
	IF EXISTS (SELECT * FROM Withdrawn w WHERE w.PaperID = (SELECT d.PaperID FROM deleted d))
	--delete the existing record before inserting new record
		DELETE FROM Withdrawn WHERE PaperID = (SELECT d.PaperID FROM deleted d)

	INSERT INTO Withdrawn (PaperID, SemesterID, PersonID, WithdrawnDateTime)
	SELECT d.PaperID, d.SemesterID, d.PersonID FROM deleted d
END
GO

--2.	If a student can withdraw from the paper only one time in a single semester
--	BTW: this is what happens at OP. Drop or disable the previous trigger.


--e11.4		Enhance the mechanism from e11.1 so that it also reacts when 
--			a person's PersonID is modified. 
--			In this case, the system must generate a new password for the modified PersonID.

--	*/
DROP TRIGGER IF EXISTS recordWithdrawal

GO
CREATE TRIGGER recordWithdrawalv2 ON Enrolment
AFTER DELETE
AS
BEGIN
	--if person already has a withdrawn record for this paper instance
	IF EXISTS (SELECT * FROM Withdrawn w WHERE w.PaperID = (SELECT d.PaperID FROM deleted d))
	--delete the existing record before inserting new record
		DELETE FROM Withdrawn WHERE PaperID = (SELECT d.PaperID FROM deleted d)

	-- reacts when a person's PersonID is modified. 
	IF UPDATE (PersonID)
		INSERT INTO [Password] (PersonID, pwd)
		SELECT PersonID FROM inserted, [pwd] 

	INSERT INTO Withdrawn (PaperID, SemesterID, PersonID, WithdrawnDateTime)
	SELECT d.PaperID, d.SemesterID, d.PersonID FROM deleted d
END
GO