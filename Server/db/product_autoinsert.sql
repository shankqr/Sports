DECLARE @counter int
SET @counter = 54;
WHILE @counter < 491+1
BEGIN
INSERT INTO dbo.product VALUES (@counter+500, '', 1, 'Consumable', 'Others', 'Club Logo Special', 'Change club logo', 'UPDATE club SET logo_pic='+cast(@counter as varchar(9)), 9999, 1000000, 10, '', 'c'+cast(@counter as varchar(9))+'.png');
SET @counter=@counter+1;
END