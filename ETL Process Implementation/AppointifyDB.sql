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

CREATE TABLE CompanyReviews (
    ReviewID INT PRIMARY KEY,
    CompanyID INT NOT NULL,
    Rating INT CHECK (Rating BETWEEN 0 AND 5),
    RatingDescription VARCHAR(10) NOT NULL,
    ReviewDate DATE NOT NULL,
    FOREIGN KEY (CompanyID) REFERENCES Company(CompanyID)
);

CREATE TABLE WorkerReviews (
    ReviewID INT PRIMARY KEY,
    WorkerID INT NOT NULL,
    ReviewDate DATE NOT NULL,
    Friendliness INT CHECK (Friendliness BETWEEN 0 AND 5),
    Professionalism INT CHECK (Professionalism BETWEEN 0 AND 5),
    Punctuality INT CHECK (Punctuality BETWEEN 0 AND 5),
    QualityOfWork INT CHECK (QualityOfWork BETWEEN 0 AND 5),
    Rating DECIMAL(3, 2) NOT NULL,
    RatingDescription VARCHAR(10) NOT NULL,
    FOREIGN KEY (WorkerID) REFERENCES Worker(WorkerID)
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




BULK INSERT Promo_Code FROM 'D:\Data Engineering\Semester 4\Data Warehouse\Labs\Lab 5\Data\promo_codes.csv'
WITH (FIRSTROW = 2,
	FIELDTERMINATOR = '|')
BULK INSERT Company FROM 'D:\Data Engineering\Semester 4\Data Warehouse\Labs\Lab 5\Data\companies.csv'
WITH (FIRSTROW = 2,
	FIELDTERMINATOR = '|')
BULK INSERT Customer FROM 'D:\Data Engineering\Semester 4\Data Warehouse\Labs\Lab 5\Data\customers.csv'
WITH (FIRSTROW = 2,
	FIELDTERMINATOR = '|')
BULK INSERT Worker FROM 'D:\Data Engineering\Semester 4\Data Warehouse\Labs\Lab 5\Data\workers.csv'
WITH (FIRSTROW = 2,
	FIELDTERMINATOR = '|')
BULK INSERT Service FROM 'D:\Data Engineering\Semester 4\Data Warehouse\Labs\Lab 5\Data\services.csv'
WITH (FIRSTROW = 2,
	FIELDTERMINATOR = ',')
BULK INSERT Payment FROM 'D:\Data Engineering\Semester 4\Data Warehouse\Labs\Lab 5\Data\payments.csv'
WITH (FIRSTROW = 2,
	FIELDTERMINATOR = '|')
BULK INSERT CompanyReviews FROM 'D:\Data Engineering\Semester 4\Data Warehouse\Labs\Lab 5\Data\company_reviews.csv'
WITH (FIRSTROW = 2,
	FIELDTERMINATOR = '|')
BULK INSERT WorkerReviews FROM 'D:\Data Engineering\Semester 4\Data Warehouse\Labs\Lab 5\Data\worker_reviews.csv'
WITH (FIRSTROW = 2,
	FIELDTERMINATOR = '|')
BULK INSERT Appointment FROM 'D:\Data Engineering\Semester 4\Data Warehouse\Labs\Lab 5\Data\appointments.csv'
WITH (FIRSTROW = 2,
	FIELDTERMINATOR = '|')





BULK INSERT Promo_Code FROM 'D:\Data Engineering\Semester 4\Data Warehouse\Labs\Lab 5\Data\2\promo_codes.csv'
WITH (FIRSTROW = 2,
	FIELDTERMINATOR = '|')

BULK INSERT Company FROM 'D:\Data Engineering\Semester 4\Data Warehouse\Labs\Lab 5\Data\2\companies.csv'
WITH (FIRSTROW = 2,
	FIELDTERMINATOR = '|')

BULK INSERT Customer FROM 'D:\Data Engineering\Semester 4\Data Warehouse\Labs\Lab 5\Data\2\customers.csv'
WITH (FIRSTROW = 2,
	FIELDTERMINATOR = '|')

BULK INSERT Worker FROM 'D:\Data Engineering\Semester 4\Data Warehouse\Labs\Lab 5\Data\2\workers.csv'
WITH (FIRSTROW = 2,
	FIELDTERMINATOR = '|')

BULK INSERT Service FROM 'D:\Data Engineering\Semester 4\Data Warehouse\Labs\Lab 5\Data\2\services.csv'
WITH (FIRSTROW = 2,
	FIELDTERMINATOR = ',')

BULK INSERT Payment FROM 'D:\Data Engineering\Semester 4\Data Warehouse\Labs\Lab 5\Data\2\payments.csv'
WITH (FIRSTROW = 2,
	FIELDTERMINATOR = '|')

BULK INSERT CompanyReviews FROM 'D:\Data Engineering\Semester 4\Data Warehouse\Labs\Lab 5\Data\2\company_reviews.csv'
WITH (FIRSTROW = 2,
	FIELDTERMINATOR = '|')

BULK INSERT WorkerReviews FROM 'D:\Data Engineering\Semester 4\Data Warehouse\Labs\Lab 5\Data\2\worker_reviews.csv'
WITH (FIRSTROW = 2,
	FIELDTERMINATOR = '|')

BULK INSERT Appointment FROM 'D:\Data Engineering\Semester 4\Data Warehouse\Labs\Lab 5\Data\2\appointments.csv'
WITH (FIRSTROW = 2,
	FIELDTERMINATOR = '|')



--UPDATE Payment
--SET Amount = 0
--WHERE Amount > 170;



DROP TABLE IF EXISTS Appointment;
DROP TABLE IF EXISTS Payment;
DROP TABLE IF EXISTS Promo_Code;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Worker;
DROP TABLE IF EXISTS Service;
DROP TABLE IF EXISTS Company;
DROP TABLE IF EXISTS CompanyReviews;
DROP TABLE IF EXISTS WorkerReviews;
DROP TABLE IF EXISTS Appointment;


select CustomerID, Name, Surname FROM Customer where PESEL = '52426305877';

UPDATE Customer
SET Name = 'HelloWorld'
WHERE PESEL = '52426305877';


UPDATE Promo_Code
SET DiscountAmount = 0
WHERE DiscountAmount = 40


UPDATE WorkerReviews
SET RatingDescription = 'HELL'
WHERE WorkerID = 1



SELECT * FROM Worker WHERE PESEL = '86575733806'


UPDATE CompanyReviews
SET RatingDescription = 'Awesome'
WHERE CompanyID = 1


SELECT * FROM Promo_Code WHERE DiscountAmount = 0