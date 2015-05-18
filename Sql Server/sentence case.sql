IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('dbo.SentenceCase') AND OBJECTPROPERTY(object_id, 'IsScalarFunction') = 1)
	BEGIN
		DROP FUNCTION dbo.SentenceCase
	END
GO
CREATE FUNCTION dbo.SentenceCase
(
	@Input VARCHAR(8000) = 'mr george robinson-white'
)
RETURNS VARCHAR(8000)
AS
BEGIN

	IF @Input IS NULL OR LEN(@Input) = 0
		RETURN @Input

	DECLARE 
			 @ReturnVal VARCHAR(8000)
			,@Index		SMALLINT
	
	SELECT @Index = PATINDEX('%[A-Z]%', @Input), @ReturnVal = ''
	
	WHILE @Index != 0
		BEGIN
			SELECT 
					 @ReturnVal = @ReturnVal + LOWER(SUBSTRING(@Input, 0, @Index)) + UPPER(SUBSTRING(@Input, @Index, 1))
					,@Input = SUBSTRING(@Input, @Index + 1, LEN(@Input))
					,@Index = PATINDEX('%[^A-Z][A-Z]%', @Input)
					,@Index = @Index + CASE WHEN @Index > 0 THEN 1 ELSE 0 END
		END

	RETURN @ReturnVal + LOWER(@Input)

END
GO

SELECT dbo.SentenceCase('peter')
SELECT dbo.SentenceCase('peter stephenson')
SELECT dbo.SentenceCase('miles o''brien')
SELECT dbo.SentenceCase('george robinson-white')
SELECT dbo.SentenceCase('antony stuart clark')
SELECT dbo.SentenceCase(null)
select dbo.SentenceCase('MR. ANTONY CLARK')
SELECT dbo.SentenceCase('-MR Miles. Edward. O''BRIEN-TEST-test test-')
SELECT dbo.SentenceCase('')
SELECT dbo.SentenceCase('    /@?><?>@')
