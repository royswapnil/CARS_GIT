/****** Object:  StoredProcedure [dbo].[USP_MAS_MODELGROUP]    Script Date: 03/16/2016 11:26:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_MAS_MODELGROUP]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_MAS_MODELGROUP]
GO
/****** Object:  StoredProcedure [dbo].[USP_MAS_MODELGROUP]    Script Date: 03/16/2016 11:26:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_MAS_MODELGROUP]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*************************************** Application: MSG *************************************************************    
* Module : Master    
* File name : USP_MAS_MODELGROUP.PRC    
* Purpose : To fetch ModelGroup  
* Author : Smita Mohapatra    
* Date  : 10.09.2015   
*********************************************************************************************************************/    

CREATE PROCEDURE [dbo].[USP_MAS_MODELGROUP]  
  
AS  
BEGIN  
	SELECT 	ID_MODELGRP ,MGM.ID_MG_SEQ ,MGM.MG_ID_MAKE, 
      		ID_MODELGRP_NAME  
	FROM TBL_MAS_MODELGROUP MG
	INNER JOIN TBL_MAS_MODELGROUP_MAKE_MAP MGM
	ON MGM.MG_ID_MODEL_GRP = MG.ID_MODELGRP 
  
END  
  
 
  
  
  
  
' 
END
GO
