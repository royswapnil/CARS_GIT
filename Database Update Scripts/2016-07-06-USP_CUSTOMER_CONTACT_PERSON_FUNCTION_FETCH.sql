GO
/****** Object:  StoredProcedure [dbo].[USP_CUSTOMER_CONTACT_PERSON_FUNCTION_FETCH]    Script Date: 06/07/2016 11:19:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


IF NOT EXISTS (
	SELECT * 
	FROM sys.objects 
	WHERE type = 'P' AND name = 'USP_CUSTOMER_CONTACT_PERSON_FUNCTION_FETCH'
	)
	BEGIN
		EXEC('CREATE PROCEDURE [dbo].[USP_CUSTOMER_CONTACT_PERSON_FUNCTION_FETCH] 
			  AS 
			  BEGIN 
				  SET NOCOUNT ON; 
			  END'
		)
	END

-- =============================================
-- Author:		Thomas Won Nyheim (TWN)
-- Create date: 2016/06/16
-- Description:	Fetches all available functions for customer contact person
-- =============================================
GO
ALTER PROCEDURE [dbo].USP_CUSTOMER_CONTACT_PERSON_FUNCTION_FETCH

AS
BEGIN
	SELECT [ID_CP_FUNCTION]
      ,[FUNCTION_CODE]
      ,[FUNCTION_DESCRIPTION]
      ,[CREATED_BY]
      ,[DT_CREATED]
      ,[MODIFIED_BY]
      ,[DT_MODIFIED]
  FROM [dbo].[TBL_MAS_CUSTOMER_CONTACT_PERSON_FUNCTION]
END
GO