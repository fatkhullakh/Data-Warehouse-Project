INSERT INTO Junk (StatusOfAppointment, IsFree, IsPromoCodeUsed)
SELECT DISTINCT
    a.Status AS StatusOfAppointment,
    CASE WHEN a.Cost = 0 THEN 'YES' ELSE 'NO' END AS IsFree,
    CASE WHEN a.PromoCodeUsed = 1 THEN 'YES' ELSE 'NO' END AS IsPromoCodeUsed
FROM
    Appointify.dbo.Appointment a;
GO

