-- Create schema if missing
DECLARE @dapiSchema varchar(30) = 'dapi_specific'
IF (SELECT COUNT(1) FROM INFORMATION_SCHEMA.SCHEMATA WHERE schema_name = @dapiSchema) = 0
	EXECUTE( 'CREATE SCHEMA ' + @dapiSchema)
GO

create or ALTER FUNCTION dapi_specific.[AddressPart](@address varchar(500), @type varchar(20)) RETURNS varchar(500) 
AS BEGIN
	DECLARE @raddress varchar(500) = (SELECT REVERSE(@address))
	DECLARE @street varchar(250) = ''
	DECLARE @housenumber varchar(30) = ''
	DECLARE @streetnumberAddress varchar(250)
	DECLARE @housenumberAppendix VARCHAR(30) = ''

	IF PATINDEX ('%[a-öA-Ö]%', @address) = 0 -- Ekkert nema tölur í inntaki
		RETURN ''

	-- Viðbót við húsnúmer
	DECLARE @hasAppendix int = (SELECT PATINDEX ('%[a-öA-Ö][0-9]%', @raddress))
	IF @hasAppendix > 0 AND (LEN (@address) = @hasAppendix + 1 OR SUBSTRING ( @raddress, @hasAppendix - 1, 1) = ' ') BEGIN -- Eitthvað fannst og það er annað hvort við enda strengs eða bil á eftir
		SET @housenumberAppendix = COALESCE (TRIM (SUBSTRING (@raddress, @hasAppendix, 1)), '')
	END

	IF @type = 'APPENDIX'
		return @housenumberAppendix
	
	-- Húsnúmer
	DECLARE @houseNumberIndex int = (SELECT PATINDEX ('%[0-9]%', @address))
	DECLARE @houseNumberPart varchar(50)
	DECLARE @removedPrefixLength INT = 0

	IF @houseNumberIndex = 1 BEGIN -- Heimilisfang byrjar á tölustaf ...
		DECLARE @actualStartIndex INT = PATINDEX ('%[a-öA-Ö]%', @address)
		SET @removedPrefixLength = @actualStartIndex - 1
		SET @streetnumberAddress = substring (@address, @actualStartIndex, (len(@address) + 1) - @actualStartIndex)
		SET @houseNumberIndex = (SELECT PATINDEX ('%[0-9]%', @streetnumberAddress))
	END
	ELSE
		SET @streetnumberAddress = @address

	IF @houseNumberIndex > 0 BEGIN
		SET @houseNumberPart = SUBSTRING (@streetnumberAddress, @houseNumberIndex, len(@streetnumberAddress) - (@houseNumberIndex - 1))
		DECLARE @houseNumberEndsIndex INT = (SELECT PATINDEX ('%[^0-9\-]%', @houseNumberPart))

		IF @houseNumberEndsIndex = 0
			SET @houseNumberEndsIndex = LEN (@streetnumberAddress) -- Heimilisfangið endar á húsnúmeri
	
		SET @houseNumber = SUBSTRING (@houseNumberPart, 1, @houseNumberEndsIndex - 1)
		WHILE PATINDEX ('[^0-9]', SUBSTRING (REVERSE (@houseNumber), 1, 1)) = 1
			SET @houseNumber = SUBSTRING (@houseNumber, 1, LEN (@houseNumber) - 1)
			
		SET @address = SUBSTRING (@address, 1, (@houseNumberIndex - 1) + @removedPrefixLength) 
	END

	IF @type = 'NUMBER' 
		return @housenumber

	DECLARE @lodIndex INT = PATINDEX ('%[^a-öA-Ö]lóð%', @address)
	IF @lodIndex > 0 
		SET @address = SUBSTRING (@address, 1, @lodIndex - 1) -- Klippum allt sem snýr að lóð af

	DECLARE @landIndex INT = PATINDEX ('%[^a-öA-Ö\-]land%', @address)
	IF @landIndex > 0 
		SET @address = SUBSTRING (@address, 1, @landIndex - 1) -- Klippum allt sem snýr að landi af

	WHILE PATINDEX ('[^a-öA-Ö \.\)]', SUBSTRING (REVERSE (@address), 1, 1)) = 1 
		SET @address = SUBSTRING (@address, 1, LEN(@address) - 1)

	SET @street = COALESCE (TRIM (@address), '')

	return @street
end 