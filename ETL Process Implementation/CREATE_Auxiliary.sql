USE auxiliary;
GO

CREATE TABLE Holidays (
    HolidayID INT IDENTITY(1,1) PRIMARY KEY,
    HolidayDate DATE UNIQUE,
    HolidayName VARCHAR(50)
);
GO
