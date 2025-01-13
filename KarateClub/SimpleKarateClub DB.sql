-- SimpleKarateClub
/*
-- Documentation 

- Membership Management:

	The system should allow the creation and management of member profiles, 
	including personal information, contact details, emergency contact information, and membership status.
	
	Member information (Name, Address, ContactInfo, Emergency Contact).
	
	Each Member can have subscription Periods and each period should have
	(StartDate, EndDate, Fees, IsPaid).
	
	Members should be able to enroll in the karate club, renew their memberships,
	and update their information as needed.
	
	The system should track membership start and end dates, as well as membership status (active/inactive).

- Instructor Management :

	The system should allow the creation and management of instructor profiles,
	including personal information and qualifications.
	
	Instructor information (Name, Address, ContactInfo, Qualifications).

	Members can have many instructors.

	Multiple instructors should be able to train a single member, 
	and each instructor should be able to train multiple members.
	
- Belt Rank and Testing:

	The system should support the management of different belt rank tests in karate.

	Members should be able to participate in belt rank teststo advance their ranks.

	The system should track belt test dates, results, and the instructors who conducted the tests.

	Each member's current belt rank should be recorded and updated as they pass the tests and progress.
	
	Belt Ranks are fixed in the system as follows:
		1. White Belt
		2. Yellow Belt
		3. Orange Belt
		4. Green Belt
		5. Blue Belt
		6. Purple Belt
		7. Brown Belt
		8. Black Belt (1st Dan)
		9. Black Belt (2nd Dan)
		10. Black Belt (3rd Dan)
		11. Black Belt (4th Dan)
		12. Black Belt (5th Dan)
		13. Black Belt (6th Dan)
		14. Black Belt (7th Dan)
		15. Black Belt (8th Dan)
		16. Black Belt (9th Dan)
		17. Black Belt (10th Dan)

	Each Belt Rank has a different test Fees.

- Payment and Fee Management:

	The system should support the management of membership fees and payments
	as well as the test fees payments.

	Members should be able to view their payment history and make payments for membership fees.

	The system should track payment details, such as the amount, date, and payment status.
	
	Member can pay for subscriptions and for test as well.
*/

-- Create a Database "SimpleKarateClub" Has Tables About
--	(Instructors, Members, Memberships, Subscriptions, Payments, BeltRanks, BeltTests)

CREATE DATABASE SimpleKarateClub;

USE SimpleKarateClub;
GO

-- Create Club Schema
CREATE SCHEMA Club;

-- Create Table BeltRanks
CREATE TABLE Club.BeltRanks (
	RankID INT IDENTITY (1, 1),
	RankName VARCHAR (100) NOT NULL,
	TestFees SMALLMONEY NOT NULL,
	
	CONSTRAINT PK_Ranks PRIMARY KEY (RankID),
	
	CONSTRAINT UQ_BeltRanks_RankName UNIQUE (RankName)
);

-- Create Table Instructors
CREATE TABLE Club.Instructors (
	InstructorID INT IDENTITY (1, 1),
	FirstName VARCHAR (30) NOT NULL,
	LastName VARCHAR (30) NOT NULL,
	Qualifications VARCHAR (100) NOT NULL, 
	PhoneNumber CHAR (20) NOT NULL,
	EmailAddress VARCHAR (70) NOT NULL,
	RankID INT NOT NULL,
	
	CONSTRAINT PK_Instructors PRIMARY KEY (InstructorID),
	
	CONSTRAINT UQ_Instructors_PhoneNumber UNIQUE (PhoneNumber),
	CONSTRAINT UQ_Instructors_EmailAddress UNIQUE (EmailAddress),
	
	CONSTRAINT FK_Instructors_BeltRanks FOREIGN KEY
	(RankID) REFERENCES Club.BeltRanks (RankID),
	
	CONSTRAINT CK_Instructors_PhoneNumber CHECK
	(PhoneNumber LIKE '+201-[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9]'),
	CONSTRAINT CK_Instructors_EmailAddress CHECK
	(EmailAddress LIKE '%@%.com')
);

-- Create Table Members
Create TABLE Club.Members (
	MemberID INT IDENTITY (1, 1),
	FirstName VARCHAR (30) NOT NULL,
	LastName VARCHAR (30) NOT NULL,
	PhoneNumber CHAR (20) NOT NULL,
	EmailAddress VARCHAR (70) NOT NULL,
	EmergencyContact VARCHAR (100) NOT NULL,
	IsActive BIT NOT NULL,
	RankID INT NOT NULL,
	
	CONSTRAINT PK_Members PRIMARY KEY (MemberID),
	
	CONSTRAINT UQ_Members_PhoneNumber UNIQUE (PhoneNumber),
	CONSTRAINT UQ_Members_EmailAddress UNIQUE (EmailAddress),
	
	CONSTRAINT FK_Members_BeltRanks FOREIGN KEY
	(RankID) REFERENCES Club.BeltRanks (RankID),
	
	CONSTRAINT CK_Members_PhoneNumber CHECK
	(PhoneNumber LIKE '+201-[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9]'),
	CONSTRAINT CK_Members_EmailAddress CHECK
	(EmailAddress LIKE '%@%.com')
);

-- Create Table Payments
CREATE TABLE Club.Payments (
	PaymentID INT IDENTITY (1, 1),
	PaymentAmount SMALLMONEY NOT NULL,
	PaymentDate	DATE NOT NULL,
	MemberID INT NOT NULl,
	
	CONSTRAINT PK_Payments PRIMARY KEY (PaymentID),
	
	CONSTRAINT FK_Payments_Members FOREIGN KEY 
	(MemberID) REFERENCES Club.Members (MemberID)
);

-- Create Table Memberships
CREATE TABLE Club.Memberships (
	MemberID INT NOT NULL,
	InstructorID INT NOT NULL,
	AssignDate DATE NOT NULL,
	
	CONSTRAINT PK_Memberships PRIMARY KEY (MemberID, InstructorID),
	
	CONSTRAINT FK_Memberships_Members FOREIGN KEY
	(MemberID) REFERENCES Club.Members (MemberID),
	CONSTRAINT FK_Memberships_Instructors FOREIGN KEY
	(InstructorID) REFERENCES Club.Instructors (InstructorID)
);

-- Create Table Subscriptions
CREATE TABLE Club.Subscriptions (
	SubscriptionID INT IDENTITY (1, 1),
	StartDate DATE NOT NULL,
	EndDate DATE NOT NULL,
	SubscriptionFees SMALLMONEY,
	MemberID INT NOT NULL, 
	PaymentID INT NOT NULL,
	
	CONSTRAINT PK_Subscriptions PRIMARY KEY (SubscriptionID),
	
	CONSTRAINT FK_Subscriptions_Members FOREIGN KEY
	(MemberID) REFERENCES Club.Members (MemberID),
	CONSTRAINT FK_Subscriptions_Payments FOREIGN KEY 
	(PaymentID) REFERENCES Club.Payments (PaymentID)
);

-- Create Table BeltTests
CREATE TABLE Club.BeltTests (
	TestID INT IDENTITY (1, 1),
	TestDate DATE NOT NULL,
	TestResult BIT NOT NULL,
	RankID INT NOT NULl,
	PaymentID INT NOT NULl,
	InstructorID INT NOT NULl,
	MemberID INT NOT NULl,
	
	CONSTRAINT PK_Tests PRIMARY KEY (TestID),
	
	CONSTRAINT FK_BeltTests_BeltRanks FOREIGN KEY
	(RankID) REFERENCES Club.BeltRanks (RankID),
	CONSTRAINT FK_BeltTests_Payments FOREIGN KEY
	(PaymentID) REFERENCES Club.Payments (PaymentID),
	CONSTRAINT FK_BeltTests_Instructors FOREIGN KEY 
	(InstructorID) REFERENCES Club.Instructors (InstructorID),
	CONSTRAINT FK_BeltTests_Members FOREIGN KEY
	(MemberID) REFERENCES Club.members (MemberID)
);