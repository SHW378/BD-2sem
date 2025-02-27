create function helloworld()
returns varchar(20)
as
BEGIN
return 'Hello World'
END
GO

SELECT dbo.helloworld()