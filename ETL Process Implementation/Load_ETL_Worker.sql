CREATE VIEW vETLDimWorker
AS
SELECT DISTINCT 
    w.WorkerID AS WorkerID,
    [NameAndSurname] = CAST([Name] + ' ' + [Surname] AS NVARCHAR(255)),
    CASE 
        WHEN w.Gender = 'M' THEN 'Male' 
        WHEN w.Gender = 'F' THEN 'Female'
        ELSE w.Gender 
    END AS Gender,
    w.PESEL AS PESEL,
    w.JobTitle AS JobTitle,
    wr.RatingDescription AS RatingsOfWorkerCategory
FROM
    Appointify.dbo.Worker w
LEFT JOIN
    Appointify.dbo.WorkerReviews wr ON w.WorkerID = wr.WorkerID;
GO


-- Ensure the DimWorker table has the necessary columns
IF COL_LENGTH('dbo.Worker', 'isCurrent') IS NULL
BEGIN
    ALTER TABLE dbo.Worker
    ADD isCurrent BIT DEFAULT 1;
END;
GO

-- Declare the entry date for the new records
DECLARE @EntryDate DATETIME = GETDATE();

-- Merge new data into DimWorker table
MERGE INTO dbo.Worker AS TT
USING dbo.vETLDimWorker AS ST
ON TT.PESEL = ST.PESEL
WHEN NOT MATCHED BY TARGET THEN
    INSERT (NameAndSurname, Gender, PESEL, JobTitle, RatingsOfWorkerCategory, isCurrent)
    VALUES (ST.NameAndSurname, ST.Gender, ST.PESEL, ST.JobTitle, ST.RatingsOfWorkerCategory, 1)
WHEN MATCHED AND (
    TT.NameAndSurname <> ST.NameAndSurname OR
    TT.Gender <> ST.Gender OR
    TT.JobTitle <> ST.JobTitle OR
    TT.RatingsOfWorkerCategory <> ST.RatingsOfWorkerCategory
) THEN
    UPDATE SET
        TT.NameAndSurname = ST.NameAndSurname,
        TT.Gender = ST.Gender,
        TT.JobTitle = ST.JobTitle,
        TT.RatingsOfWorkerCategory = ST.RatingsOfWorkerCategory,
        TT.isCurrent = 1;
GO

DROP VIEW vETLDimWorker