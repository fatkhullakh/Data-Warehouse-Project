CREATE database Appointify
GO

use Appointify

-- Create Company Table
CREATE TABLE Company (
    CompanyID INT PRIMARY KEY,
    CompanyName VARCHAR(255),
    Address VARCHAR(255),
    PhoneNumber VARCHAR(50),
    Email VARCHAR(100),
    Type VARCHAR(50)
);

-- Create Services Table
CREATE TABLE Service (
    ServiceID INT PRIMARY KEY,
    ServiceName VARCHAR(255),
    Duration INT,
    Cost DECIMAL(10, 2),
    Type VARCHAR(50),
	CompanyID INT,
    FOREIGN KEY (CompanyID) REFERENCES Company(CompanyID)
);

-- Create Worker Table
CREATE TABLE Worker (
    WorkerID INT PRIMARY KEY,
    Name VARCHAR(255),
    Surname VARCHAR(255),
    DateOfBirth DATE,
    PhoneNumber VARCHAR(50),
    Email VARCHAR(100),
    Gender CHAR(1),
    PESEL VARCHAR(11),
    JobTitle VARCHAR(100),
    CompanyID INT,
    FOREIGN KEY (CompanyID) REFERENCES Company(CompanyID)
);

-- Create Customer Table
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(255),
    Surname VARCHAR(255),
    DateOfBirth DATE,
    Gender CHAR(1),
    PhoneNumber VARCHAR(50),
    PESEL VARCHAR(11),
    Email VARCHAR(100),
    RegistrationDate DATE,
    CompanyID INT,
    FOREIGN KEY (CompanyID) REFERENCES Company(CompanyID)
);

-- Create Promo Code Table
CREATE TABLE Promo_Code (
    ID INT PRIMARY KEY,
    Promo_code VARCHAR(50),
    DiscountAmount DECIMAL(10, 2)
);

-- Create Payment Table
CREATE TABLE Payment (
    PaymentID INT PRIMARY KEY,
    Amount DECIMAL(10, 2),
    DatePaid DATE,
    Status VARCHAR(50),
    PaymentMethod VARCHAR(50),
    CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

-- Create Appointment Table
CREATE TABLE Appointment (
    AppointmentID INT PRIMARY KEY,
    Date DATE,
    Time TIME,
    StartTime TIME,
    EndTime TIME,
    Status VARCHAR(50),
    Cost DECIMAL(10, 2),
    ServiceType VARCHAR(50),
    PromoCodeUsed INT,
	ServiceID INT,
	Promo_Code INT,
    CustomerID INT,
    WorkerID INT,
	PaymentID INT,
    FOREIGN KEY (ServiceID) REFERENCES Service(ServiceID),
    FOREIGN KEY (PromoCodeUsed) REFERENCES Promo_Code(ID),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (WorkerID) REFERENCES Worker(WorkerID),
	FOREIGN KEY (PaymentID) REFERENCES Payment(PaymentID)
);


BULK INSERT Promo_Code FROM 'C:\Users\user\PycharmProjects\Appointify\promo_codes.csv'
WITH (FIRSTROW = 2,
	FIELDTERMINATOR = '|')

BULK INSERT Company FROM 'C:\Users\user\PycharmProjects\Appointify\companies.csv'
WITH (FIRSTROW = 2,
	FIELDTERMINATOR = '|')

BULK INSERT Customer FROM 'C:\Users\user\PycharmProjects\Appointify\customers.csv'
WITH (FIRSTROW = 2,
	FIELDTERMINATOR = '|')

BULK INSERT Worker FROM 'C:\Users\user\PycharmProjects\Appointify\workers.csv'
WITH (FIRSTROW = 2,
	FIELDTERMINATOR = '|')

BULK INSERT Service FROM 'C:\Users\user\PycharmProjects\Appointify\services.csv'
WITH (FIRSTROW = 2,
	FIELDTERMINATOR = ',')

BULK INSERT Payment FROM 'D:\Data Engineering\Semester 4\Data Warehouse\Labs\Lab 2\Generator\payments.csv'
WITH (FIRSTROW = 2,
	FIELDTERMINATOR = '|')

BULK INSERT Appointment FROM 'D:\Data Engineering\Semester 4\Data Warehouse\Labs\Lab 2\Generator\appointments.csv'
WITH (FIRSTROW = 2,
	FIELDTERMINATOR = '|')



--UPDATE Payment
--SET Amount = 0
--WHERE Amount > 170;



--DROP TABLE IF EXISTS Appointment;
--DROP TABLE IF EXISTS Payment;
--DROP TABLE IF EXISTS Promo_Code;
--DROP TABLE IF EXISTS Customer;
--DROP TABLE IF EXISTS Worker;
--DROP TABLE IF EXISTS Service;
--DROP TABLE IF EXISTS Company;


select CustomerID, Name, Surname FROM Customer where PESEL = '52426305877';

UPDATE Customer
SET Name = 'HelloWorld'
WHERE PESEL = '52426305877';




