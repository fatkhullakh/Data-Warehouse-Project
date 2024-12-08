CREATE VIEW vETLDimCustomer
AS
SELECT DISTINCT
	[CustomerID] as [CustomerID],
	[NameAndSurname] = Cast([Name] + ' ' + [Surname] as nvarchar(255)),
	CASE 
        WHEN Gender = 'M' THEN 'Male' 
        WHEN Gender = 'F' THEN 'Female'
        ELSE Gender 
    END AS Gender,
	[PESEL] as [PESEL]
FROM Appointify.dbo.Customer;
go

MERGE INTO Customer as TT
	USING vETLDimCustomer as ST
		ON TT.NameAndSurname = ST.NameAndSurname AND TT.PESEL = ST.PESEL
			WHEN Not Matched
				THEN 
					INSERT
					VALUES (ST.NameAndSurname, ST.Gender, ST.PESEL)
					WHEN Not Matched By Source
				Then
					DELETE
			;

DROP VIEW vETLDimCustomer

