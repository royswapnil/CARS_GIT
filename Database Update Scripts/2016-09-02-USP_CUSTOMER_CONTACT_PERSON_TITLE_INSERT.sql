GO
/****** Object:  StoredProcedure [dbo].[USP_CUSTOMER_CONTACT_PERSON_TITLE_INSERT]    Script Date: 02/09/2016 15:12:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


IF NOT EXISTS (
	SELECT * 
	FROM sys.objects 
	WHERE type = 'P' AND name = 'USP_CUSTOMER_CONTACT_PERSON_TITLE_INSERT'
	)
	BEGIN
		EXEC('CREATE PROCEDURE [dbo].[USP_CUSTOMER_CONTACT_PERSON_TITLE_INSERT] 
			  AS 
			  BEGIN 
				  SET NOCOUNT ON; 
			  END'
		)
	END

-- =============================================
-- Author:		Thomas Won Nyheim (TWN)
-- Create date: 2016/09/02
-- Description:	Adds new title for contact person
-- =============================================
GO
ALTER PROCEDURE [dbo].GO
/****** Object:  StoredProcedure [dbo].[USP_CUSTOMER_CONTACT_PERSON_TITLE_INSERT]    Script Date: 02/09/2016 15:12:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


IF NOT EXISTS (
	SELECT * 
	FROM sys.objects 
	WHERE type = 'P' AND name = 'USP_CUSTOMER_CONTACT_PERSON_TITLE_INSERT'
	)
	BEGIN
		EXEC('CREATE PROCEDURE [dbo].[USP_CUSTOMER_CONTACT_PERSON_TITLE_INSERT] 
			  AS 
			  BEGIN 
				  SET NOCOUNT ON; 
			  END'
		)
	END

-- =============================================
-- Author:		Thomas Won Nyheim (TWN)
-- Create date: 2016/09/02
-- Description:	Adds new title for contact person
-- =============================================
GO
ALTER PROCEDURE [dbo].USP_CUSTOMER_CONTACT_PERSON_TITLE_INSERT(
	@code varchar(10),
	@description varchar(25),
	@user varchar(15),
	@id int OUTPUT,
	@retval varchar(15) output
)
AS
BEGIN
	IF NOT EXISTS (SELECT * FROM TBL_MAS_CUSTOMER_CONTACT_PERSON_TITLE WHERE TITLE_CODE = @code)
		BEGIN
			INSERT INTO [dbo].[TBL_MAS_CUSTOMER_CONTACT_PERSON_TITLE]
					   ([TITLE_CODE]
					   ,[TITLE_DESCRIPTION]
					   ,[CREATED_BY]
					   ,[DT_CREATED])
				 VALUES
					   (@code
					   ,@description
					   ,@user
					   ,GETDATE())
			SET @retval = 'INSFLG'
			SET @id = SCOPE_IDENTITY()
		END
	ELSE
		BEGIN
			SET @retval = 'ERRFLG'
		END
END

(
	@code varchar(10),
	@description varchar(25),
	@user varchar(15),
	@id int OUTPUT,
	@retval varchar(15) output
)
AS
BEGIN
	IF NOT EXISTS (SELECT * FROM TBL_MAS_CUSTOMER_CONTACT_PERSON_TITLE WHERE TITLE_CODE = @code)
		BEGIN
			INSERT INTO [dbo].[TBL_MAS_CUSTOMER_CONTACT_PERSON_TITLE]
					   ([TITLE_CODE]
					   ,[TITLE_DESCRIPTION]
					   ,[CREATED_BY]
					   ,[DT_CREATED])
				 VALUES
					   (@code
					   ,@description
					   ,@user
					   ,GETDATE())
			SET @retval = 'INSFLG'
			SET @id = SCOPE_IDENTITY()
		END
	ELSE
		BEGIN
			SET @retval = 'ERRFLG'
		END
END

