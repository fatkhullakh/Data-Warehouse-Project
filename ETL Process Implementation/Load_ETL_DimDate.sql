DECLARE @StartDate DATE; 
DECLARE @EndDate DATE;

-- Step b: Fill the variable with values for the range of years needed
SELECT @StartDate = '2018-01-01', @EndDate = '2024-12-31';

-- Step c: Use a while loop to add dates to the table
DECLARE @DateInProcess DATE = @StartDate;

WHILE @DateInProcess <= @EndDate
BEGIN
    -- Add a row into the date dimension table for this date
    INSERT INTO [dbo].[Date] 
    ( 
        [Date],
        [Year],
        [Month],
        [MonthNo],
        [DayOfWeek],
        [DayOfWeekNo],
        [IsHoliday]
    )
    VALUES ( 
        @DateInProcess, -- [Date]
        YEAR(@DateInProcess), -- [Year]
        DATENAME(MONTH, @DateInProcess), -- [Month]
        MONTH(@DateInProcess), -- [MonthNo]
        DATENAME(WEEKDAY, @DateInProcess), -- [DayOfWeek]
        DATEPART(WEEKDAY, @DateInProcess), -- [DayOfWeekNo]
        0 -- Default to non-holiday, can be updated later
    );  

    -- Add a day and loop again
    SET @DateInProcess = DATEADD(DAY, 1, @DateInProcess);
END
GO



-----------------------------------------------------------------------------

-- Update IsHoliday column in DimDate table using Holidays table from the auxiliary database
UPDATE d
SET d.IsHoliday = 1
FROM Date d
JOIN auxiliary.dbo.Holidays h ON d.Date = h.HolidayDate;
GO


