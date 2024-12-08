USE AppointifyWarehouse;
CREATE VIEW vETLAppointment
AS
SELECT
    ST1.Cost,
    DATEDIFF(MINUTE, ST1.StartTime, ST1.EndTime) AS Duration,
    ISNULL(PC.DiscountAmount, 0) AS DiscountAmount,
    CS.CustomerID,
    WR.WorkerID,
    CM.CompanyID,
    SV.ServiceID,
    SD.DateID AS Appointment_Date,
    TD.TimeID AS Appointment_Time,
    JK.JunkID,
    ST1.AppointmentID AS AppointmentNo
FROM
    Appointify.dbo.Appointment AS ST1
LEFT JOIN Appointify.dbo.Promo_Code AS PC ON PC.ID = ST1.Promo_Code
LEFT JOIN Appointify.dbo.Worker AS WORKER ON WORKER.WorkerID = ST1.WorkerID
LEFT JOIN Customer AS CS ON CS.CustomerID = ST1.CustomerID
LEFT JOIN Worker AS WR ON WR.WorkerID = ST1.WorkerID
LEFT JOIN Company AS CM ON CM.CompanyID = WORKER.CompanyID
LEFT JOIN ServiceType AS SV ON SV.ServiceID = ST1.ServiceID
LEFT JOIN dbo.Date AS SD ON SD.Date = CAST(ST1.Date AS DATE)
LEFT JOIN dbo.Time AS TD ON TD.Hour = DATEPART(HOUR, ST1.Time) AND TD.Minutes = DATEPART(MINUTE, ST1.Time)
LEFT JOIN dbo.Junk AS JK ON
    JK.StatusOfAppointment = ST1.Status
    AND JK.IsPromoCodeUsed = CASE 
                                WHEN ST1.PromoCodeUsed = 1 THEN 'YES' 
                                ELSE 'NO' 
                              END
    AND JK.IsFree = CASE
                        WHEN ST1.Cost = 0 THEN 'YES'
                        ELSE 'NO'
                    END;
GO

WITH CTE AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY AppointmentNo ORDER BY AppointmentNo) AS rn
    FROM vETLAppointment
)
MERGE INTO dbo.Appointment AS TGT
USING (
    SELECT * FROM CTE WHERE rn = 1
) AS SRC
ON TGT.AppointmentNo = SRC.AppointmentNo
WHEN MATCHED THEN
    UPDATE SET
        TGT.Cost = SRC.Cost,
        TGT.Duration = SRC.Duration,
        TGT.DiscountAmount = SRC.DiscountAmount,
        TGT.CustomerID = SRC.CustomerID,
        TGT.WorkerID = SRC.WorkerID,
        TGT.CompanyID = SRC.CompanyID,
        TGT.ServiceID = SRC.ServiceID,
        TGT.Appointment_Date = SRC.Appointment_Date,
        TGT.Appointment_Time = SRC.Appointment_Time,
        TGT.JunkID = SRC.JunkID
WHEN NOT MATCHED BY TARGET THEN
    INSERT (Cost, Duration, DiscountAmount, CustomerID, WorkerID, CompanyID, ServiceID, Appointment_Date, Appointment_Time, JunkID, AppointmentNo)
    VALUES (SRC.Cost, SRC.Duration, SRC.DiscountAmount, SRC.CustomerID, SRC.WorkerID, SRC.CompanyID, SRC.ServiceID, SRC.Appointment_Date, SRC.Appointment_Time, SRC.JunkID, SRC.AppointmentNo)
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;
GO





DROP VIEW vETLAppointment;


--INSERT INTO Appointment (Cost, Duration, DiscountAmount, CustomerID, WorkerID, CompanyID, ServiceID, Appointment_Date, Appointment_Time, JunkID, AppointmentNo)
--SELECT 
--    Cost,
--    Duration, 
--	DiscountAmount,
--    CustomerID,
--    WorkerID,
--    CompanyID,
--    ServiceID,
--    Appointment_Date,
--    Appointment_Time,
--    JunkID,
--    AppointmentNo
--FROM vETLAppointment;


--MERGE INTO dbo.Appointment AS TGT
--USING vETLAppointment AS SRC
--ON TGT.AppointmentNo = SRC.AppointmentNo 
--WHEN MATCHED THEN
--    UPDATE SET
--        TGT.Cost = SRC.Cost,
--        TGT.Duration = SRC.Duration,
--        TGT.DiscountAmount = SRC.DiscountAmount,
--        TGT.CustomerID = SRC.CustomerID,
--        TGT.WorkerID = SRC.WorkerID,
--        TGT.CompanyID = SRC.CompanyID,
--        TGT.ServiceID = SRC.ServiceID,
--        TGT.Appointment_Date = SRC.Appointment_Date,
--        TGT.Appointment_Time = SRC.Appointment_Time,
--        TGT.JunkID = SRC.JunkID
--WHEN NOT MATCHED BY TARGET THEN
--    INSERT (Cost, Duration, DiscountAmount, CustomerID, WorkerID, CompanyID, ServiceID, Appointment_Date, Appointment_Time, JunkID, AppointmentNo)
--    VALUES (SRC.Cost, SRC.Duration, SRC.DiscountAmount, SRC.CustomerID, SRC.WorkerID, SRC.CompanyID, SRC.ServiceID, SRC.Appointment_Date, SRC.Appointment_Time, SRC.JunkID, SRC.AppointmentNo)
--WHEN NOT MATCHED BY SOURCE THEN
--    DELETE;
--GO

--DROP VIEW vETLAppointment

--CREATE VIEW vETLAppointment
--AS
--SELECT
--    ST1.Cost,
--    DATEDIFF(MINUTE, ST1.StartTime, ST1.EndTime) AS Duration,
--    ISNULL(PC.DiscountAmount, 0) AS DiscountAmount,
--    CS.CustomerID,
--    WR.WorkerID,
--    CM.CompanyID,
--    SV.ServiceID,
--    SD.DateID AS Appointment_Date,
--    TD.TimeID AS Appointment_Time,
--    JK.JunkID,
--    ST1.AppointmentID AS AppointmentNo
--FROM
--    Appointify.dbo.Appointment AS ST1
--LEFT JOIN Appointify.dbo.Promo_Code AS PC ON PC.ID = ST1.Promo_Code
--LEFT JOIN Appointify.dbo.Worker AS WORKER ON WORKER.WorkerID = ST1.WorkerID
--LEFT JOIN Customer AS CS ON CS.CustomerID = ST1.CustomerID
--LEFT JOIN Worker AS WR ON WR.WorkerID = ST1.WorkerID
--LEFT JOIN Company AS CM ON CM.CompanyID = WORKER.CompanyID
--LEFT JOIN ServiceType AS SV ON SV.ServiceID = ST1.ServiceID
--LEFT JOIN dbo.Date AS SD ON SD.Date = CAST(ST1.Date AS DATE)
--LEFT JOIN dbo.Time AS TD ON TD.Hour = DATEPART(HOUR, ST1.Time) AND TD.Minutes = DATEPART(MINUTE, ST1.Time)
--LEFT JOIN dbo.Junk AS JK ON
--    JK.StatusOfAppointment = ST1.Status
--    AND JK.IsPromoCodeUsed = CASE 
--                                WHEN ST1.PromoCodeUsed = 1 THEN 'YES' 
--                                ELSE 'NO' 
--                              END
--    AND JK.IsFree = CASE
--                        WHEN ST1.Cost = 0 THEN 'YES'
--                        ELSE 'NO'
--                    END;
--GO











