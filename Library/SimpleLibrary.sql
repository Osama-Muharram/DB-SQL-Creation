-- SimpleLibrary
/*
-- Documentation

- Book Management:

	Store and manage information about books, including title, author(s), ISBN,
	publication date, genre, and additional details.
	
	Track availability status of book copies, indicating whether they are available
	for borrowing or checked out by users.
	
	Manage multiple copies of a book, each with a unique identifier (copy ID).
	
- User Management :

	Maintain records of library users, including their names, contact information,
	and library card numbers.

- Borrowing and Returns:

	Enable users to borrow book copies from the library.
	
	Track borrowing records, including the book copy borrowed, user information,
	borrowing date, and due date.
	
	Handle the return process, updating the availability status of book copies.
	
	Check for any fines or penalties associated with late returns or damaged book copies.

- Holds and Reservations:

	Allow users to place holds or reservations on book copies that are currently checked out.
	
	Manage the order of reservations to ensure fairness.
	
- Fine Management:

	Calculate and manage fines or penalties for late returns book copies.
	
	Keep track of the fine amount owed by each user.
	
	Maintain the payment status to track whether fines have been paid or are still pending.
*/

-- Create a Database "SimpleLibrary" Has Tables About 
--	(Users, Books, Copies, Reservations, Borrowings, Fines)
	
CREATE DATABASE SimpleLibrary;

USE SimpleLibrary;
GO

-- Create Library Schema
CREATE SCHEMA Library;

-- Create Users Table 
CREATE TABLE Library.Users (
	UserID INT IDENTITY (1, 1),
	FirstName VARCHAR (25) NOT NULL,
	LastName VARCHAR (25) NOT NULL,
	PhoneNumber CHAR (20) NOT NULL,
	EmailAddress VARCHAR (70) NOT NULL,
	LibraryCardNumbers VARCHAR (50) NOT NULL,
	
	CONSTRAINT PK_Users PRIMARY KEY (UserID),
	
	CONSTRAINT UQ_Users_PhoneNumber UNIQUE (PhoneNumber),
	CONSTRAINT UQ_Users_EmailAdress UNIQUE (EmailAddress),
	
	CONSTRAINT CK_Users_PhoneNumber CHECK 
	(PhoneNumber LIKE '+201-[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9]'),
	CONSTRAINT CK_Users_EmailAdress CHECK
	(EmailAddress LIKE '%@%.com')
);

-- Create Books Table
CREATE TABLE Library.Books (
	BookID INT IDENTITY (1, 1),
	BookTitle VARCHAR (255) NOT NULL,
	AuthorName VARCHAR (200) NOT NULL,
	ISBN VARCHAR (50) NOT NULL,
	PublicDate DATE NOT NULL,
	Genre VARCHAR (50) NOT NULL,
	AdditionalDetails VARCHAR (MAX),
	
	CONSTRAINT PK_Books PRIMARY KEY (BookID),
	
	CONSTRAINT UQ_Books_BookTitle UNIQUE (BookTitle),
	CONSTRAINT UQ_Books_ISBN UNIQUE (ISBN),
);

-- Create BookCopies Table
CREATE TABLE Library.BookCopies (
	CopyID INT IDENTITY (1, 1),
	BookID INT NOT NULL,
	AvailabilityStatus BIT NOT NULL,
	
	CONSTRAINT PK_Copies PRIMARY KEY (CopyID),
	
	CONSTRAINT FK_BookCopies_Books FOREIGN KEY 
	(BookID) REFERENCES Library.Books (BookID)
);

-- Create Reservations Table
CREATE TABLE Library.Reservations (
	ReservationID INT IDENTITY (1, 1),
	ReservationDate DATE NOT NULL,
	CopyID INT NOT NULL,
	UserID INT NOT NULL,
	
	CONSTRAINT PK_Reservations PRIMARY KEY (ReservationID),
	
	CONSTRAINT FK_Reservations_BookCopies FOREIGN KEY
	(CopyID) REFERENCES Library.BookCopies (CopyID),
	CONSTRAINT FK_Reservations_Users FOREIGN KEY
	(UserID) REFERENCES Library.Users (UserID)
);

-- Create Borrowings Table
CREATE TABLE Library.Borrowings (
	BorrowingID INT IDENTITY (1, 1),
	BorrowingDate DATE NOT NULL,
	DueDate DATE NOT NULL,
	ActualReturnDate DATE,
	CopyID INT NOT NULL,
	UserID INT NOT NULL,
	
	CONSTRAINT PK_Borrowings PRIMARY KEY (BorrowingID),
	
	CONSTRAINT FK_Borrowings_BookCopies FOREIGN KEY
	(CopyID) REFERENCES Library.BookCopies (CopyID),
	CONSTRAINT FK_Borrowings_Users FOREIGN KEY
	(UserID) REFERENCES Library.Users (UserID)
);

-- Create Fines Table
CREATE TABLE Library.Fines (
	FineID INT IDENTITY	(1, 1),
	BorrowingID INT NOT NULL,
	UserID INT NOT NULL,
	FineAmount SMALLMONEY NOT NULL,
	PaymentStatus BIT NOT NULL,
	LateDays TINYINT NOT NULL,
	
	CONSTRAINT PK_Fines PRIMARY KEY (FineID),
	
	CONSTRAINT FK_Fines_Borrowings FOREIGN KEY
	(BorrowingID) REFERENCES Library.Borrowings (BorrowingID),
	CONSTRAINT FK_Fines_Users FOREIGN KEY
	(UserID) REFERENCES Library.Users (UserID)
);