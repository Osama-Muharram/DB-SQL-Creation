-- SimpleCarRental
/*
-- Documentation

- Customer Management:

	Customer Management: The system should save customers personal information:
	Name, contact information, and a driver's license number.

- Vehicles Information :

	The system should maintain an up-to-date information of available vehicles, including
	information such as make,model, year, mileage, and rental rates, fuel type (Gaz,Electric,.etc.) ,
	plate number, Vehicle Category (4x4, Sedan, ..etc).

	- Vehicle Fuel Types:
		Gasoline (Petrol).
		Diesel.
		Electric.
		Hybrid.

- Vehicle Booking:

	When a customer rents a vehicle System should keep booking information: 
	customer who rented this vehicle, rental start date, rental end date, pickup location, drop of
	location, Initial rental days, initial total due amount, initial vehicle check notes.

- Rental Transaction:
	
	Customer should pay for the rent and a transaction should be logged in the system to keep
	the following information: Payment Details, initial paid amount.

- Vehicle Return:

	When customer returns a vehicle, the system should calculate and keep the Actual Return Date,
	calculate actual rental days, record the final vehicle check notes, 
	specify if there are additional charges.

	Original Transaction should be updated and record all differences in reservation and 
	calculate the actual final amount due, and calculate the remaining amount,
	if they customer need refund, we pay it back.

	Save the current Milage, and calculate the consumed Mileage by customer during the rent period. 
*/

-- Create a Database "SimpleCarRental" Has Tables About
--	(Vehicles, FuelTypes, Categories, Maintenances, Customers, Bookings, Transactions, Returns)

CREATE DATABASE SimpleCarRental;

USE SimpleCarRental;
GO

-- Create Club Schema
CREATE SCHEMA Rental; 

-- Create Table FuelTypes
CREATE TABLE Rental.FuelTypes (
	FuelTypeID INT IDENTITY (1, 1),
	FuelType VARCHAR (20) NOT NULL,
	
	CONSTRAINT PK_FuelTypes PRIMARY KEY (FuelTypeID),
	
	CONSTRAINT UQ_FuelTypes_FuelType UNIQUE (FuelType)
);

-- Create Table Categories
CREATE TABLE Rental.Categories (
	CategoryID INT IDENTITY (1, 1),
	CategoryName VARCHAR (50) NOT NULL,
	
	CONSTRAINT PK_Categories PRIMARY KEY (CategoryID),
	
	CONSTRAINT UQ_Categories_CategoryName UNIQUE (CategoryName)
);

-- Create Table Vehicles
CREATE TABLE Rental.Vehicles (
	VehicleID INT IDENTITY (1, 1),
	ModelName VARCHAR (50) NOT NULL,
	ModelYear SMALLINT NOT NULL,
	MadeIN VARCHAR (50) NOT NULL,
	Mileage INT NOT NULL,
	PlateNumber VARCHAR (30) NOT NULL, 
	Rating TINYINT NOT NULL,
	RentalPricePerDay SMALLMONEY NOT NULL,
	IsAvailable BIT NOT NULL,
	CategoryID INT NOT NULL,
	FuelTypeID INT NOT NULL,
	
	CONSTRAINT PK_Vehicles PRIMARY KEY (VehicleID),
	
	CONSTRAINT UQ_Vehicles_PlateNumber UNIQUE (PlateNumber),
	
	CONSTRAINT FK_Vehicles_Categories FOREIGN KEY 
	(CategoryID) REFERENCES Rental.Categories (CategoryID),
	CONSTRAINT FK_Vehicles_FuelTypes FOREIGN KEY
	(FuelTypeID) REFERENCES Rental.FuelTypes,
	
	CONSTRAINT CK_Vehicls_Raitng CHECK
	(Rating BETWEEN 1 AND 10)
);

-- Create Table Maintenances
CREATE TABLE Rental.Maintenances (
	MaintenanceID INT IDENTITY (1, 1),
	MaintenanceDate DATE NOT NULL,
	Description VARCHAR (500) NOT NULL,
	CostAmount SMALLMONEY NOT NULL,
	VehicleID INT NOT NULL,
	
	CONSTRAINT PK_Maintenances PRIMARY KEY (MaintenanceID),
	
	CONSTRAINT FK_Maintenances_Vehicles FOREIGN KEY
	(VehicleID) REFERENCES Rental.Vehicles (VehicleID)
);

-- Create Table Customers
CREATE TABLE Rental.Customers (
	CustomerID INT IDENTITY (1, 1),
	Name VARCHAR (100) NOT NULL,
	ContactInfo VARCHAR (100) NOT NULL,
	LicenseNumber VARCHAR (20) NOT NULL,
	
	CONSTRAINT PK_Customers PRIMARY KEY (CustomerID),
	
	CONSTRAINT UQ_Customers_LicenseNmumber UNIQUE (LicenseNumber)
);

-- Create Table Bookings
CREATE TABLE Rental.Bookings (
	BookingID INT IDENTITY (1, 1),
	RentalStartDate Date NOT NULL,
	RentalEndDate Date NOT NULL,
	PickUpLocation VARCHAR (100) NOT NULL,
	DropOfLocation VARCHAR (100) NOT NULL,
	InitialRentalDays TINYINT NOT NULL,
	InitialDueAmount SMALLMONEY NOT NULL,
	RentalPricePerDay SMALLMONEY NOT NULL,
	InitialCheckNotes VARCHAR (500) NOT NULL,
	VehicleID INT NOT NULL,
	CustomerID INT NOT NULL,
	
	CONSTRAINT PK_Bookings PRIMARY KEY (BookingID),
	
	CONSTRAINT Fk_Bookings_Vehicles FOREIGN KEY
	(VehicleID) REFERENCES Rental.Vehicles (VehicleID),
	CONSTRAINT Fk_Bookings_Customers FOREIGN KEY 
	(CustomerID) REFERENCES Rental.Customers (CustomerID)
);

-- Create Table Returns
CREATE Table Rental."Returns" (
	ReturnID INT IDENTITY (1, 1),
	ReturnDate DATE NOT NULL,
	ActualRentalDays TINYINT NOT NULL,
	Mileage INT NOT NULL,
	ConsumedMileage SMALLINT NOT NULL,
	FinalCheckNotes VARCHAR (500) NOT NULL,
	AdditionalCharges SMALLMONEY,
	TotalDueAmount SMALLMONEY NOT NULL,
	
	CONSTRAINT PK_Returns PRIMARY KEY (ReturnID)
);

-- Create Table Transactions
CREATE TABLE Rental.Transactions (
	TransactionID INT IDENTITY(1, 1),
	PaymentDetails VARCHAR (100) NOT NULL,
	InitialPaid SMALLMONEY NOT NULL,
	TotalDueAmount SMALLMONEY NOT NULL,
	RemainingAmount SMALLMONEY,
	RefundAmount SMALLMONEY,
	TransactionDate DATE NOT NULL,
	FinalTransactionDate DATE,
	BookingID INT NOT NULL,
	ReturnID INT ,
	CustomerID INT NOT NULL,
	
	CONSTRAINT PK_Transactions PRIMARY KEY (TransactionID),
	
	CONSTRAINT Fk_Transactions_Bookings FOREIGN KEY 
	(BookingID) REFERENCES Rental.Bookings (BookingID),
	CONSTRAINT Fk_Transactions_Returns FOREIGN KEY
	(ReturnID) REFERENCES Rental."Returns" (ReturnID),
	CONSTRAINT Fk_Transactions_Customers FOREIGN KEY
	(CustomerID) REFERENCES Rental.Customers (CustomerID)
);
	