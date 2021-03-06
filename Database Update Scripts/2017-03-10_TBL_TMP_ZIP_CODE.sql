
IF NOT EXISTS(
	SELECT *
	FROM   INFORMATION_SCHEMA.TABLES
	WHERE  TABLE_NAME = 'TBL_TMP_ZIPCODE'
			AND TABLE_SCHEMA = 'dbo'
)
BEGIN
	CREATE TABLE TBL_TMP_ZIPCODE (
		zip_code			varchar(15),
		zip_city			varchar(50),
		county_municipality	varchar(15),
		municipality_name	varchar(50),
		category			varchar(15)
	)
END

ALTER TABLE TBL_MAS_ZIPCODE
ADD ZIP_COUNTYCODE int,
	ZIP_MUNICIPALITY VARCHAR(50)


