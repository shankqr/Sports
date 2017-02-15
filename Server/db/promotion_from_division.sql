DECLARE @max_division int
SET @max_division = ISNULL((SELECT MAX(division) FROM club), 5);

DECLARE @counter int, @total_match int
SET @counter = 9;
WHILE @counter < @max_division+1
BEGIN
SET @total_match = ISNULL((SELECT count(*) FROM match WHERE division=@counter+1), 0);
IF(@total_match>11250)
BEGIN
EXECUTE usp_PromoteDemoteBulk @counter, 1, 625
END
ELSE
BEGIN
EXECUTE usp_PromoteBulk @counter, 1, 625
SET @max_division = @counter
END
SET @counter=@counter+1;
END