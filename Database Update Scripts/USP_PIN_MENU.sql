GO
/****** Object:  StoredProcedure [dbo].[USP_PIN_MENU]    Script Date: 02/19/2016 11:14:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Thomas Won Nyheim (TWN)
-- Create date: 2016/02/19
-- Description:	Switches the state of the PIN on menu
-- =============================================

IF NOT EXISTS (
	SELECT * 
	FROM sys.objects 
	WHERE type = 'P' 
	      AND name = 'USP_PIN_MENU'
	)
	EXEC('CREATE PROCEDURE [dbo].[USP_PIN_MENU] 
		  AS 
		  BEGIN 
			  SET NOCOUNT ON; 
		  END'
	)
GO

IF NOT EXISTS(
	SELECT *
    FROM   INFORMATION_SCHEMA.COLUMNS
    WHERE  TABLE_NAME = 'TBL_MAS_USERS'
           AND COLUMN_NAME = 'FLG_PIN_MENU'
	)
	EXEC('ALTER TABLE TBL_MAS_USERS 
		  ADD FLG_PIN_MENU BIT'
	) -- ALTER TABLE TBL_MAS_USERS DROP COLUMN FLG_PIN_MENU
GO

ALTER PROCEDURE [dbo].[USP_PIN_MENU] (
	@flg			BIT				= 0,	-- Sets flag, default 0
	@user			VARCHAR(15),			-- User that changes the flag
	@fetch			BIT,
	@PINSTATE		VARCHAR(15) OUTPUT
)

AS

DECLARE @output VARCHAR(15)

IF (@user IS NOT NULL AND @fetch = 0)
BEGIN
	UPDATE TBL_MAS_USERS SET FLG_PIN_MENU = @flg WHERE ID_Login = @user
	SET  @output = 'UPDFLG'
END



SET @PINSTATE = (SELECT FLG_PIN_MENU FROM TBL_MAS_USERS WHERE ID_Login = @user)

PRINT @PINSTATE
