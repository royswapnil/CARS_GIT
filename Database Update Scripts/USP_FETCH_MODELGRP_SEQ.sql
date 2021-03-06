/****** Object:  StoredProcedure [dbo].[USP_FETCH_MODELGRP_SEQ]    Script Date: 03/16/2016 11:25:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_FETCH_MODELGRP_SEQ]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_FETCH_MODELGRP_SEQ]
GO
/****** Object:  StoredProcedure [dbo].[USP_FETCH_MODELGRP_SEQ]    Script Date: 03/16/2016 11:25:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_FETCH_MODELGRP_SEQ]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*************************************** Application: MSG *************************************************************    
* Module : Master    
* File name : USP_FETCH_MODELGRP_SEQ.PRC    
* Purpose : To fetch ModelGroupSeq based on make and model  
* Author : Smita M    
* Date  : 14.03.2016    
*********************************************************************************************************************/    

CREATE PROCEDURE [dbo].[USP_FETCH_MODELGRP_SEQ]  
 (
	 @MakeCodeID 	varchar(10) ,
	 @Model varchar(10)
	 
 )  
AS  
BEGIN  
	SELECT 	ID_MG_SEQ ,  
      		MG_ID_MODEL_GRP  
	FROM TBL_MAS_MODELGROUP_MAKE_MAP  
	WHERE MG_ID_MAKE  =  @MakeCodeID and MG_ID_MODEL_GRP = @Model 
  
END  ' 
END
GO
