CREATE DATABASE AppointifyWarehouse

USE AppointifyWarehouse
GO

CREATE TABLE Worker(
    WorkerID INTEGER IDENTITY(1,1) PRIMARY KEY,
    NameAndSurname VARCHAR(50),
    Gender VARCHAR(10),
    PESEL VARCHAR(11),
    JobTitle VARCHAR(50),
    RatingsOfWorkerCategory VARCHAR(10),
	isCurrent BIT DEFAULT 1
)
GO

CREATE TABLE Customer(
    CustomerID INTEGER IDENTITY(1,1) PRIMARY KEY,
    NameAndSurname VARCHAR(50),
    Gender VARCHAR(10),
    PESEL VARCHAR(11)
)
GO

CREATE TABLE Company(
    CompanyID INTEGER IDENTITY(1,1) PRIMARY KEY,
    CompanyName VARCHAR(50),
    TypeOfCompany VARCHAR(50),
    RatingsOfCompanyCategory VARCHAR(10)
)
GO

CREATE TABLE ServiceType(
    ServiceID INTEGER IDENTITY(1,1) PRIMARY KEY,
    ServiceName VARCHAR(400),
    ServiceCategory VARCHAR(100)
)
GO


CREATE TABLE Date(
    DateID INTEGER IDENTITY(1,1) PRIMARY KEY,
    Date DATE UNIQUE,
    Year INTEGER,
    Month VARCHAR(10),
    MonthNo INTEGER,
    DayOfWeek VARCHAR(10),
    DayOfWeekNo INTEGER,
    isHoliday VARCHAR(50)
)
GO

CREATE TABLE Time(
    TimeID INTEGER IDENTITY(1,1) PRIMARY KEY,
    Hour INTEGER NOT NULL,
    Minutes INTEGER NOT NULL,
    TimeOfDay VARCHAR(20)
)
GO

CREATE TABLE Junk(
  JunkID INTEGER IDENTITY(1,1) PRIMARY KEY,
  StatusOfAppointment VARCHAR(10),
  IsFree VARCHAR(3),
  IsPromoCodeUsed VARCHAR(3)
)
GO


CREATE TABLE Appointment(
    Cost DECIMAL(10,2),
    Duration INT,
    DiscountAmount INT,
    CustomerID INTEGER FOREIGN KEY REFERENCES Customer,
    WorkerID INTEGER FOREIGN KEY REFERENCES Worker,
    CompanyID INTEGER FOREIGN KEY REFERENCES Company,
    ServiceID INTEGER FOREIGN KEY REFERENCES ServiceType,
    Appointment_Date INTEGER FOREIGN KEY REFERENCES Date,
    Appointment_Time INTEGER FOREIGN KEY REFERENCES Time,
    JunkID INTEGER FOREIGN KEY REFERENCES Junk,
    AppointmentNo VARCHAR(15),

  CONSTRAINT composite_pk PRIMARY KEY (
    CustomerID,
    WorkerID,
    CompanyID,
    ServiceID,
    Appointment_Date,
    Appointment_Time,
    JunkID,
    AppointmentNo
    )
)
GO








DROP TABLE IF EXISTS Appointment
GO

DROP TABLE IF EXISTS Worker
GO

DROP TABLE IF EXISTS Customer
GO

DROP TABLE IF EXISTS Company
GO

DROP TABLE IF EXISTS ServiceType
GO

DROP TABLE IF EXISTS Date
GO

DROP TABLE IF EXISTS Time
GO

DROP TABLE IF EXISTS Junk
GO







