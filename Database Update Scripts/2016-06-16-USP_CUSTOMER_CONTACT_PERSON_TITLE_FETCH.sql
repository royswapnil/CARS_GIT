GO
/****** Object:  StoredProcedure [dbo].[USP_CUSTOMER_CONTACT_PERSON_TITLE_FETCH]    Script Date: 16/06/2016 11:14:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


IF NOT EXISTS (
	SELECT * 
	FROM sys.objects 
	WHERE type = 'P' AND name = 'USP_CUSTOMER_CONTACT_PERSON_TITLE_FETCH'
	)
	BEGIN
		EXEC('CREATE PROCEDURE [dbo].[USP_CUSTOMER_CONTACT_PERSON_TITLE_FETCH] 
			  AS 
			  BEGIN 
				  SET NOCOUNT ON; 
			  END'
		)
	END

-- =============================================
-- Author:		Thomas Won Nyheim (TWN)
-- Create date: 2016/06/16
-- Description:	Fetches all available titles for customer contact person
-- =============================================
GO
ALTER PROCEDURE [dbo].USP_CUSTOMER_CONTACT_PERSON_TITLE_FETCH

AS
BEGIN
	SELECT [ID_CP_TITLE]
      ,[TITLE_CODE]
      ,[TITLE_DESCRIPTION]
      ,[CREATED_BY]
      ,[DT_CREATED]
      ,[MODIFIED_BY]
      ,[DT_MODIFIED]
  FROM [dbo].[TBL_MAS_CUSTOMER_CONTACT_PERSON_TITLE]
END
GO