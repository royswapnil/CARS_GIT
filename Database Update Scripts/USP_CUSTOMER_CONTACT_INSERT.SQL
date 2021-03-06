GO
/****** Object:  StoredProcedure [dbo].[USP_CUSTOMER_CONTACT_INSERT]    Script Date: 03/03/2016 11:14:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


IF NOT EXISTS (
	SELECT * 
	FROM sys.objects 
	WHERE type = 'P' AND name = 'USP_CUSTOMER_CONTACT_INSERT'
	)
	BEGIN
		EXEC('CREATE PROCEDURE [dbo].[USP_CUSTOMER_CONTACT_INSERT] 
			  AS 
			  BEGIN 
				  SET NOCOUNT ON; 
			  END'
		)
	END

IF NOT EXISTS(
	SELECT *
    FROM   INFORMATION_SCHEMA.TABLES
    WHERE  TABLE_NAME = 'TBL_MAS_CUSTOMER_CONTACT'
           AND TABLE_SCHEMA = 'dbo'
	)
BEGIN
	CREATE TABLE [dbo].[TBL_MAS_CUSTOMER_CONTACT](
	[CONTACT_SEQ] [int] IDENTITY(1,1) NOT NULL,
	[CONTACT_CUSTOMER_ID] [int] NOT NULL,
	[CONTACT_TYPE] [int] NOT NULL,
	[CONTACT_VALUE] [varchar](500) NOT NULL,
	[CONTACT_STANDARD] [bit] NOT NULL,
	[DT_CREATED] [date] NOT NULL,
	[CREATED_BY] [varchar](50) NOT NULL,
	[DT_MODIFIED] [date] NULL,
	[MODIFIED_BY] [varchar](50) NULL
	) ON [PRIMARY]
END
GO

-- =============================================
-- Author:		Thomas Won Nyheim (TWN)
-- Create date: 2016/03/04
-- Description:	Adds or updates contact information for customers
-- =============================================

ALTER PROCEDURE [dbo].USP_CUSTOMER_CONTACT_INSERT (
	@SEQ			INT = NULL,
	@CONT_CUSTID	INT,
	@CONT_TYPE		INT,
	@CONT_VALUE		VARCHAR(500),
	@CONT_STANDARD	INT = 0,
	@CONT_USER		VARCHAR(25), -- USER WHO EDITS OR UPDATES THE CONTACT INFORMATION
	@RETVAL			VARCHAR(10) OUTPUT
)

AS

DECLARE @DATE as DATETIME = getdate(); -- SETS DATE
SELECT @SEQ
IF (@SEQ IS NULL)
BEGIN
	-- DO SOMETHING WITH INSERT
	INSERT INTO 
		TBL_MAS_CUSTOMER_CONTACT (
			CONTACT_CUSTOMER_ID,
			CONTACT_TYPE,
			CONTACT_VALUE,
			CONTACT_STANDARD,
			DT_CREATED,
			CREATED_BY
			)
	VALUES
		(
			@CONT_CUSTID,
			@CONT_TYPE,
			@CONT_VALUE,
			@CONT_STANDARD,
			@DATE,
			@CONT_USER
		)
	SET @RETVAL = 'INSFLG'
END
ELSE IF (@SEQ IS NOT NULL) 
BEGIN
	-- DO SOMETHING WITH UPDATE
	IF NOT EXISTS(
		SELECT 
			* 
		FROM 
			TBL_MAS_CUSTOMER_CONTACT
		WHERE
			CONTACT_SEQ = @SEQ
			AND CONTACT_CUSTOMER_ID = @CONT_CUSTID
			AND CONTACT_TYPE = @CONT_TYPE
			AND CONTACT_VALUE = @CONT_VALUE
			AND CONTACT_STANDARD = @CONT_STANDARD
	)
	BEGIN
		UPDATE 
			TBL_MAS_CUSTOMER_CONTACT
		SET
			CONTACT_TYPE = @CONT_TYPE,
			CONTACT_VALUE = @CONT_VALUE,
			CONTACT_STANDARD = @CONT_STANDARD,
			MODIFIED_BY = @CONT_USER,
			DT_MODIFIED = @DATE
		WHERE
			CONTACT_SEQ = @SEQ
			AND CONTACT_CUSTOMER_ID = @CONT_CUSTID
		SET @RETVAL = 'UPDATEFLG'
	END
	ELSE
	BEGIN
		SET @RETVAL = 'NOUPDATE'
	END
END