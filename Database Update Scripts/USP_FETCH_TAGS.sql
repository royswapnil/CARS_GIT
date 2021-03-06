/****** Object:  StoredProcedure [dbo].[USP_FETCH_TAGS]    Script Date: 08/03/2015 17:40:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_FETCH_TAGS]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_FETCH_TAGS]
GO
/****** Object:  StoredProcedure [dbo].[USP_FETCH_TAGS]    Script Date: 08/03/2015 17:40:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_FETCH_TAGS]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Praveen
-- Create date: <Create Date,,>
-- Description:	To fetch the tags based on language
-- =============================================
CREATE PROCEDURE [dbo].[USP_FETCH_TAGS]
	-- Add the parameters for the stored procedure here
@IV_LANG VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @IV_LANG_ID INT

	SELECT @IV_LANG_ID = ID_LANG FROM TBL_MAS_LANGUAGE WHERE LANG_NAME=@IV_LANG

	SELECT TAG,CAPTION,ID_LANG FROM TBL_TAG_CAPTIONS WHERE ID_LANG = 3-- @IV_LANG_ID
  

END
' 
END
GO
