CREATE VIEW vETLDimCompany
AS
SELECT DISTINCT 
    c.CompanyID AS CompanyID,
    c.CompanyName AS CompanyName,
    c.Type AS TypeOfCompany,
    cr.RatingDescription AS RatingsOfCompanyCategory
FROM
    Appointify.dbo.Company c
LEFT JOIN
    Appointify.dbo.CompanyReviews cr ON c.CompanyID = cr.CompanyID;

GO

MERGE INTO Company as TT
	USING vETLDimCompany as ST
		ON TT.CompanyName = ST.CompanyName
			WHEN Not Matched
				THEN
					INSERT VALUES (ST.CompanyName, ST.TypeOfCompany, ST.RatingsOfCompanyCategory)
					WHEN Not Matched BY Source
				THEN 
					DELETE;

DROP VIEW vETLDimCompany