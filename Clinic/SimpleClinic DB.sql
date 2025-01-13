-- SimpleClinic
/*
-- Documentation

- Patients:

	The database should store information about patients.
	
	Each patient should have a unique identifier, a name, a date of birth, 
	gender, contact information (phone number,email), and address.

- Doctors:

	The database should store information about doctors.
	
	Each doctor should have a unique identifier, a name, specialization,
	a date of birth, gender, contact information (phone number, email), and address.
	
- Appointments:
	The database should store information about appointments.
	
	Each appointment should have a unique identifier, a patient,
	a doctor, appointment date and time, and appointment status.
	
	Appoinment Status:
	
		Completed "1": The appointment has taken place as scheduled.
		
		Pending "2": The appointment has been scheduled but has not yet occurred.
		
		Confirmed "3": The appointment has been confirmed by both
			the patient and the healthcare provider.
			
		Canceled "4": The appointment has been canceled either by
			the patient or the healthcare provider.
			
		Rescheduled "5": The appointment has been rescheduled for a different date or time.
		
		No Show "6": The patient did not show up for the appointment without
			canceling or rescheduling.

- Medical Records:

	The database should store medical records for patients.
	
	For each attended appointment there should be a medical record.
	
	Each medical record should have a unique identifier, a patient, a doctor, 
	a description of the visit, diagnosis,prescribed medication, and any additional notes.

-Prescriptions:

	The database should store information about prescribed medications.
	
	For each medical record there should be at most one prescription.
	
	Each prescription should have a unique identifier, a medical record,
	medication name, dosage, frequency, start date, end date, and any special instructions.

-Payments:
	The database should store information about payments.
	
	Payment is per appointment.
	
	Each payment should have a unique identifier, a patient, a payment date, 
	payment method, amount paid, and any additional notes.
*/

-- Create a Database "SimpleClinic" Has Tables About 
--	(Patients, Doctors, Appointments, MedicalRecords, Prescriptions, Payments)

CREATE DATABASE SimpleClinic;

USE SimpleClinic;
GO

-- Create Clinic Schema 
CREATE SCHEMA Clinic;

-- Create Patients Table
CREATE TABLE Clinic.Patients (
	PatientID INT IDENTITY (1, 1),
	FirstName VARCHAR (25) NOT NULL,
	LastName VARCHAR (25) NOT NULL,
	BirthDate DATE NOT NULL,
	Gender CHAR (1) NOT NULL,
	PhoneNumber CHAR (20) NOT NULL,
	EmailAddress VARCHAR (70) NOT NULL,
	City VARCHAR (20) NOT NULL,
	Governorate VARCHAR (20) NOT NULL,
	
	CONSTRAINT PK_Patients PRIMARY KEY (PatientID),
	
	CONSTRAINT UQ_Patients_EmailAdress UNIQUE (EmailAddress),
	CONSTRAINT UQ_Patients_PhoneNumber UNIQUE (PhoneNumber),
	
	CONSTRAINT CK_Patients_Gender CHECK 
	(Gender IN ('M', 'F')),
	CONSTRAINT CK_Patients_PhoneNumber CHECK 
	(PhoneNumber LIKE '+201-[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9]'),
	CONSTRAINT CK_Patients_EmaillAddress CHECK
	(EmailAddress LIKE '%@%.com')
);

-- Create Doctors Table
CREATE TABLE Clinic.Doctors (
	DoctorID INT IDENTITY (1, 1),
	FirstName VARCHAR (25) NOT NULL,
	LastName VARCHAR (25) NOT NULL,
	Spcilaization VARCHAR (50), 
	BirthDate DATE NOT NULL,
	Gender CHAR (1) NOT NULL,
	PhoneNumber CHAR (20) NOT NULL,
	EmailAddress VARCHAR (70) NOT NULL,
	City NVARCHAR (20) NOT NULL,
	Governorate NVARCHAR(20) NOT NULL,
	
	CONSTRAINT PK_Doctors PRIMARY KEY (DoctorID),
	
	CONSTRAINT UQ_Doctors_EmailAdress UNIQUE (EmailAddress),
	CONSTRAINT UQ_Doctors_PhoneNumber UNIQUE (PhoneNumber),
	
	CONSTRAINT CK_Doctors_Gender CHECK 
	(Gender IN ('M', 'F')),
	CONSTRAINT CK_Doctors_PhoneNumber CHECK 
	(PhoneNumber LIKE '+201-[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9]'),
	CONSTRAINT CK_Doctors_EmaillAddress CHECK
	(EmailAddress LIKE '%@%.com')
);

-- Create Appointments Table
CREATE TABLE Clinic.Appointments (
	AppointmentID INT IDENTITY (1, 1),
	PatientID INT NOT NULL,
	DoctorID INT NOT NULL,
	AppointmentDate DATE NOT NULL,
	AppointmentTime TIME NOT NULL,
	AppointmentStatus CHAR (1) NOT NULL,
	
	CONSTRAINT PK_Appointments PRIMARY KEY (AppointmentID),
	
	CONSTRAINT FK_Appointments_Patients FOREIGN KEY 
	(PatientID) REFERENCES Clinic.Patients (PatientID),
	CONSTRAINT FK_Appointments_Doctors FOREIGN KEY 
	(DoctorID) REFERENCES Clinic.Doctors (DoctorID),
			
	CONSTRAINT CK_Appointments_AppointmentStatus CHECK 
	(AppointmentStatus LIKE '[1-6]')
);

-- Create Payments Table
CREATE TABLE Clinic.Payments (
	PaymentID INT IDENTITY (1, 1),
	AppointmentID INT NOT NULL,
	PaymentDate DATE NOT NULL,
	PaymentMethod VARCHAR (50) NOT NULL,
	AmountPaid SMALLMONEY NOT NULL,
	AdditionalNotes VARCHAR (200),
	
	CONSTRAINT PK_Payments PRIMARY KEY (PaymentID),
	
	CONSTRAINT FK_Payments_Appointments FOREIGN KEY 
	(AppointmentID) REFERENCES Clinic.Appointments (AppointmentID),
);

-- Create MedicalRecords Table
CREATE TABLE Clinic.MedicalRecords (
	MedicalRecordID INT IDENTITY (1, 1),
	AppointmentID INT NOT NULL,
	VisitDescription VARCHAR (50) NOT NULL,
	Diagnosis VARCHAR (200) NOT NULL,
	AdditionalNotes VARCHAR (200),
	
	CONSTRAINT PK_MedicalRecords PRIMARY KEY (MedicalRecordID),
	
	CONSTRAINT FK_MedicalRecords_Appointments FOREIGN KEY 
	(AppointmentID) REFERENCES Clinic.Appointments (AppointmentID)
);


-- Create Prescriptions Table
CREATE TABLE Clinic.Prescriptions (
	PrescriptionID INT IDENTITY (1, 1),
	MedicalRecordID INT NOT NULL, 
	MedicationName VARCHAR (100) NOT NULL,
	Doasge VARCHAR (50) NOT NULL,
	Frequency VARCHAR(50) NOT NULL, 
	StartDate DATE NOT NULL,
	EndDate DATE NOT NULL,
	SpecialInstructions VARCHAR (200),
	
	CONSTRAINT PK_Prescriptions PRIMARY KEY (PrescriptionID),
	
	CONSTRAINT FK_Prescriptions_MedicalRecords FOREIGN KEY 
	(MedicalRecordID) REFERENCES Clinic.MedicalRecords (MedicalRecordID)
);