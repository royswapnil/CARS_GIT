/****** Object:  StoredProcedure [dbo].[USP_WO_VIEW_LABOUR_DETAILS]    Script Date: 11/9/2016 5:39:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_WO_VIEW_LABOUR_DETAILS]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_WO_VIEW_LABOUR_DETAILS]
GO
/****** Object:  StoredProcedure [dbo].[USP_WO_VIEW_LABOUR_DETAILS]    Script Date: 11/9/2016 5:39:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_WO_VIEW_LABOUR_DETAILS]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_WO_VIEW_LABOUR_DETAILS] AS' 
END
GO
      
-- =============================================      
-- Author:  <Author,,Name>      
-- Create date: <Create Date,,>      
-- Description: <Description,,>      
-- =============================================      
ALTER PROCEDURE [dbo].[USP_WO_VIEW_LABOUR_DETAILS]      
@ID_WODET_SEQ AS INT         
AS      
BEGIN      
 -- SET NOCOUNT ON added to prevent extra result sets from      
 -- interfering with SELECT statements.      
 SET NOCOUNT ON;      
      
    -- Insert statements for procedure here      
 SELECT ID_WOLAB_SEQ,ID_WODET_SEQ,WLD.ID_LOGIN,WO_LABOUR_HOURS,WO_HOURLEY_PRICE,WO_VAT_Code,WO_vat_ACCCODE,wo_labour_accountcode,wo_labourvat_percentage,wo_labour_desc,sl_no,WO_LAB_DISCOUNT,FIRST_NAME + '-' +LAST_NAME + '-' + MU.ID_LOGIN AS 'MECHANICNAME'        
 FROM TBL_WO_LABOUR_DETAIL WLD    
 INNER JOIN TBL_MAS_USERS MU
  ON MU.ID_LOGIN = WLD.ID_LOGIN
 WHERE ID_WODET_SEQ = @ID_WODET_SEQ 
 --AND ISNULL(MU.FLG_DUSER,0) <> 1 AND MU.FLG_MECHANIC  = 1
 
 --SELECT FIRST_NAME + '-' +LAST_NAME + '-' + ID_LOGIN AS 'MECHANICNAME' , ID_LOGIN FROM TBL_MAS_USERS  WHERE ID_LOGIN IN (SELECT ID_LOGIN FROM TBL_WO_LABOUR_DETAIL WHERE ID_WODET_SEQ = @ID_WODET_SEQ  )     
 --AND ISNULL(FLG_DUSER,0) <> 1 AND FLG_MECHANIC  = 1
 
 
 --SELECT FIRST_NAME + '-' +LAST_NAME + '-' + MU.ID_LOGIN AS 'MECHANICNAME' , MU.ID_LOGIN, ID_WOLAB_SEQ,ID_WODET_SEQ
 --FROM TBL_MAS_USERS MU
 --INNER JOIN TBL_WO_LABOUR_DETAIL WLD
 --ON MU.ID_LOGIN = WLD.ID_LOGIN
 --WHERE WLD.ID_WODET_SEQ = @ID_WODET_SEQ
 --AND ISNULL(MU.FLG_DUSER,0) <> 1 AND MU.FLG_MECHANIC  = 1
 
       
END 
GO
