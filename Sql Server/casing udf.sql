ALTER FUNCTION dbo.FormatCase (@Input VARCHAR(8000))
RETURNS VARCHAR(8000)
AS
BEGIN
	IF @Input IS NULL OR LEN(@Input) = 0
		RETURN @Input

	DECLARE 
			 @returnVal VARCHAR(8000)
			,@Index		INTEGER

	SELECT	 @Input = LTRIM(RTRIM(@Input))
			,@ReturnVal = ''

	--Ignore non-letters at the start of the string
	WHILE PATINDEX('[A-Z]', LEFT(@Input, 1)) = 0
	BEGIN
		IF PATINDEX('%[A-Z]%', @Input) = 0
			RETURN @ReturnVal + @Input

		SELECT	@ReturnVal = @ReturnVal + LEFT(@Input, 1)
				, @Input = RIGHT(@Input, LEN(@Input) - 1)
	END

	IF LEN(@Input) = 0
		RETURN @ReturnVal

	--upper case the first letter
	SELECT 
			 @ReturnVal = @ReturnVal + UPPER(LEFT(@Input, 1))
			,@Input = RIGHT(@Input, LEN(@Input) - 1)

	--this function works by reducing the input var whie appending to the output
	--therefore it is finished when input is empty
	WHILE LEN(@Input) > 0
	BEGIN
		--find the first non letter
		SELECT @Index = PATINDEX('%[^A-Z]%', @Input)

		--if there are only letters, append the lower and bail
		IF @Index = 0
		BEGIN
			SELECT @ReturnVal = @ReturnVal + LOWER(@Input)
			BREAK
		END
	
		IF LEN(@Input) = 0
		BREAK

		--append the rest of the current word (lowered), reduce input as appropriate
		SELECT 
			@ReturnVal = @ReturnVal + LOWER(LEFT(@Input, @Index))
			, @Input = RIGHT(@Input, LEN(@Input) - @Index)

		IF LEN(@Input) = 0
			BREAK

		--Ignore multiple non letters in a row
		WHILE PATINDEX('[A-Z]', LEFT(@Input, 1)) = 0
		BEGIN
			IF PATINDEX('%[A-Z]%', @Input) = 0
				RETURN @ReturnVal + @Input
			SELECT	@ReturnVal = @ReturnVal + LEFT(@Input, 1)
				, @Input = RIGHT(@Input, LEN(@Input) - 1)
		END

		IF LEN(@Input) = 0
			BREAK

		--upper case first letter of next word
		SELECT 
			@ReturnVal = @ReturnVal + UPPER(LEFT(@Input, 1))
			, @Input = RIGHT(@Input, LEN(@Input) - 1)
	END

	WHILE CHARINDEX(SPACE(2), @ReturnVal) <> 0
		SELECT @ReturnVal = REPLACE(@ReturnVal, SPACE(2), SPACE(1))

	RETURN @ReturnVal
END
/*
SELECT dbo.FormatCase('peter')
SELECT dbo.FormatCase('peter stephenson')
SELECT dbo.FormatCase('miles o''brien')
SELECT dbo.FormatCase('george robinson-white')
SELECT dbo.FormatCase('antony stuart clark')

SELECT dbo.FormatCase(null)
select dbo.FormatCase('MR. ANTONY CLARK')
SELECT dbo.FormatCase('-MR Miles. Edward. O''BRIEN-TEST-test test-')
*/