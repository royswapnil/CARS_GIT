GO
/****** Object:  StoredProcedure [dbo].[USP_CUSTOMER_CONTACT_PERSON_DELETE]    Script Date: 15/06/2016 11:10:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


IF NOT EXISTS (
	SELECT * 
	FROM sys.objects 
	WHERE type = 'P' AND name = 'USP_CUSTOMER_CONTACT_PERSON_DELETE'
	)
	BEGIN
		EXEC('CREATE PROCEDURE [dbo].[USP_CUSTOMER_CONTACT_PERSON_DELETE] 
			  AS 
			  BEGIN 
				  SET NOCOUNT ON; 
			  END'
		)
	END

GO

-- =============================================
-- Author:		Thomas Won Nyheim (TWN)
-- Create date: 2016/06/15
-- Description:	Removes contact person
-- =============================================

ALTER PROCEDURE [dbo].USP_CUSTOMER_CONTACT_PERSON_DELETE (
	@SEQ INT,
	@RETVAL VARCHAR(15) OUTPUT
)

AS

IF (@SEQ IS NOT NULL)
BEGIN
	DELETE FROM TBL_MAS_CUSTOMER_CONTACT_PERSON WHERE ID_CP = @SEQ
	SET @RETVAL = 'DELFLG'
END	
ELSE
BEGIN
	SET @RETVAL = 'ERRFLG'
END

PRINT @RETVAL