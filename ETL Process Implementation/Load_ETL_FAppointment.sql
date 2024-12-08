 USE DW_Appointify_TEST;
 


CREATE TABLE FAppointment (
	Cost DECIMAL(10, 2),
    Duration INT,
    DiscountAmount DECIMAL(10, 2),
    CustomerID INT FOREIGN KEY REFERENCES DimCustomer,
    WorkerID INT FOREIGN KEY REFERENCES DimWorker,
    CompanyID INT FOREIGN KEY REFERENCES DimCompany,
    ServiceID INT FOREIGN KEY REFERENCES DimServiceType,
    Appointment_Date INT FOREIGN KEY REFERENCES DimDate,
    Appointment_Time INT FOREIGN KEY REFERENCES DimTime,
    JunkID INT FOREIGN KEY REFERENCES Junk,
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
);
GO



CREATE VIEW vETLAppointment
AS
SELECT
    Cost,
    Duration,
    DiscountAmount,
    CustomerID,
    WorkerID,
    CompanyID,
    ServiceID,
    Appointment_Date,
    Appointment_Time,
    JunkID,
    AppointmentNo
FROM
(
    SELECT
        ST1.Cost,
        ST1.Duration,
        ST2.DiscountAmount,
        CS.CustomerID,
        WR.WorkerID,
        CM.CompanyID,
        SV.ServiceID,
        SD.DateID AS Appointment_Date,
        TD.TimeID AS Appointment_Time,
        JK.JunkID,
        ST1.AppointmentID AS AppointmentNo
    FROM Appointify.dbo.Appointment AS ST1
    LEFT JOIN Appointify.dbo.Promo_Code AS ST2 ON ST2.ID = ST1.Promo_Code
	JOIN Appointify.dbo.Worker AS WORKER ON ST1.WorkerID = WORKER.WorkerID
	JOIN Appointify.dbo.Company AS COMPANY ON WORKER.CompanyID = COMPANY.CompanyID
    JOIN dbo.DimCustomer AS CS ON CS.CustomerID = ST1.CustomerID
    JOIN dbo.DimWorker AS WR ON WR.WorkerID = ST1.WorkerID
    JOIN dbo.DimCompany AS CM ON CM.CompanyID = COMPANY.CompanyID
    JOIN dbo.DimServiceType AS SV ON SV.ServiceID = ST1.ServiceID
    JOIN dbo.DimDate AS SD ON SD.Date = ST1.Date
    JOIN dbo.DimTime AS TD ON TD.Hour = DATEPART(HOUR, ST1.Time) AND TD.Minutes = DATEPART(MINUTE, ST1.Time)
    JOIN dbo.Junk AS JK ON JK.JunkID = ST1.Promo_Code 
        AND JK.StatusOfAppointment = ST1.Status
        AND JK.IsPromoCodeUsed = CASE 
                                    WHEN ST1.PromoCodeUsed = 1 THEN 'YES' 
                                    ELSE 'NO' 
                                  END
        AND JK.IsFree = CASE
                            WHEN ST1.Cost = 0 THEN 'YES'
                            ELSE 'NO'
                        END
) AS x;
GO

DROP VIEW vETLAppointment


INSERT INTO Appointment (Cost, Duration, DiscountAmount, CustomerID, WorkerID, CompanyID, ServiceID, Appointment_Date, Appointment_Time, JunkID, AppointmentNo)
SELECT 
    Cost,
    Duration,
    DiscountAmount,
    CustomerID,
    WorkerID,
    CompanyID,
    ServiceID,
    Appointment_Date,
    Appointment_Time,
    JunkID,
    AppointmentNo
FROM vETLAppointment;

DROP TABLE Appointment








CREATE VIEW vETLAppointment
AS
SELECT 
    Cost,
    Duration,
    DiscountAmount,
    CustomerID,
    WorkerID,
    CompanyID,
    ServiceID,
    Appointment_Date,
    Appointment_Time, 
    JunkID,
    AppointmentNo
FROM 
    (SELECT 
          Cost = ST1.Cost,
          Duration = ST1.Duration,
          DiscountAmount = ST2.DiscountAmount,
          CustomerID = ST1.CustomerID,
          WorkerID = ST1.WorkerID,
          CompanyID = CO.CompanyID,
          ServiceID = ST1.ServiceID,
          Appointment_Date = SD.DateID,
          Appointment_Time = TD.TimeID,
          JunkID = Junk.JunkID,
          AppointmentNo = ST1.AppointmentID
    FROM Appointify.dbo.Appointment AS ST1
	JOIN Appointify.dbo.Promo_Code AS ST2 ON ST1.PromoCodeUsed = ST2.ID
    JOIN dbo.DimDate AS SD ON CONVERT(VARCHAR(10), SD.Date, 111) = CONVERT(VARCHAR(10), ST1.Date, 111)
    JOIN dbo.DimTime AS TD ON TD.Hour = DATEPART(HOUR, ST1.Time)
    LEFT JOIN dbo.DimCustomer AS C ON C.CustomerID = ST1.CustomerID
    LEFT JOIN dbo.DimWorker AS W ON W.WorkerID = ST1.WorkerID
    LEFT JOIN dbo.DimCompany AS CO ON CO.CompanyID = dbo.DimCompany.CompanyID
    LEFT JOIN dbo.DimServiceType AS S ON S.ServiceID = ST1.ServiceID
    ) AS x;
GO





