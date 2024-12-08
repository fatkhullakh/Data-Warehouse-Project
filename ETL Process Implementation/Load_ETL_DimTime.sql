DECLARE @Hour INT = 0;
DECLARE @Minutes INT = 0;

WHILE @Hour < 24
BEGIN
    WHILE @Minutes < 60
    BEGIN
        INSERT INTO Time (Hour, Minutes, TimeOfDay)
        VALUES (
            @Hour,
            @Minutes,
            CASE 
				WHEN @Hour < 8 THEN 'before 8'
                WHEN @Hour >= 8 AND @Hour < 11 THEN 'between 8 and 10'
                WHEN @Hour >= 11 AND @Hour < 15 THEN 'between 11 and 14'
                WHEN @Hour >= 15 AND @Hour < 19 THEN 'between 15 and 18'
                WHEN @Hour >= 19 THEN 'after 19'
                ELSE 'other'
            END
        );
        SET @Minutes = @Minutes + 1;
    END
    SET @Minutes = 0;
    SET @Hour = @Hour + 1;
END
GO