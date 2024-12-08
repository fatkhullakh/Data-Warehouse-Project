CREATE VIEW vETLDimServiceType
AS
SELECT DISTINCT 
    [ServiceID],
    [ServiceName],
    [Type] AS [ServiceCategory]
FROM Appointify.dbo.Service;
GO

MERGE INTO ServiceType AS TT
USING vETLDimServiceType AS ST
ON TT.ServiceName = ST.ServiceName AND TT.ServiceCategory = ST.ServiceCategory -- Match on both name and category
WHEN MATCHED THEN
    UPDATE SET
        TT.ServiceName = ST.ServiceName,
        TT.ServiceCategory = ST.ServiceCategory
WHEN NOT MATCHED BY TARGET THEN
    INSERT (ServiceName, ServiceCategory)
    VALUES (ST.ServiceName, ST.ServiceCategory);
GO

DROP VIEW vETLDimServiceType