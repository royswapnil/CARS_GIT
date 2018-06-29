GO
/****** Object:  StoredProcedure [dbo].[USP_IMPORT_ZIPCODES]    Script Date: 14/03/2017 09:14:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


IF NOT EXISTS (
	SELECT * 
	FROM sys.objects 
	WHERE type = 'P' AND name = 'USP_IMPORT_ZIPCODES'
	)
	BEGIN
		EXEC('CREATE PROCEDURE [dbo].[USP_IMPORT_ZIPCODES] 
			  AS 
			  BEGIN 
				  SET NOCOUNT ON; 
			  END'
		)
	END

-- =============================================
-- Author:		Thomas Won Nyheim (TWN)
-- Create date: 2017/03/14
-- Description:	Fetches all or specific contact person
-- =============================================
GO

ALTER PROCEDURE [dbo].USP_IMPORT_ZIPCODES (
	@CNT			VARCHAR(10) OUTPUT
	,@UPD			VARCHAR(10) OUTPUT
	,@INS			VARCHAR(10) OUTPUT
)
AS


SET @CNT = (SELECT COUNT(*) FROM TBL_TMP_ZIPCODE)

INSERT INTO TBL_MAS_ZIPCODE ( -- INSERTS NEW
	ZIP_ZIPCODE
	,ZIP_CITY
	,ZIP_COUNTYCODE
	,ZIP_MUNICIPALITY
	,DT_CREATED
	,CREATED_BY
)
SELECT 
	zip_code
	,zip_city
	,SUBSTRING(county_municipality,1, 2)
	,municipality_name
	,GETDATE()
	,'system'
FROM
	TBL_TMP_ZIPCODE
WHERE zip_code NOT IN (SELECT ZIP_ZIPCODE FROM TBL_MAS_ZIPCODE)
SET @INS = @@ROWCOUNT

UPDATE mz -- UPDATES EXISTING
SET
	mz.ZIP_CITY = tz.zip_city,
	mz.ZIP_COUNTYCODE = SUBSTRING(tz.county_municipality,1, 2),
	mz.ZIP_MUNICIPALITY = tz.municipality_name,
	mz.DT_MODIFIED = GETDATE(),
	mz.MODIFIED_BY = 'system'
--	SELECT * 
FROM TBL_TMP_ZIPCODE tz
	RIGHT JOIN TBL_MAS_ZIPCODE mz
	ON 
		tz.zip_code = mz.ZIP_ZIPCODE
	WHERE
		tz.zip_city <> ISNULL(mz.ZIP_CITY,'')
		or SUBSTRING(tz.county_municipality,1, 2) <> ISNULL(mz.ZIP_COUNTYCODE,'')
		or tz.municipality_name <> ISNULL(mz.ZIP_MUNICIPALITY,'')
SET @UPD = @@ROWCOUNT

SELECT @CNT, @UPD, @INS

DELETE FROM TBL_TMP_ZIPCODE