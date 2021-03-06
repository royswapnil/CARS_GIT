/****** Object:  StoredProcedure [dbo].[USP_CONFIG_Inv_NumSeries_FETCH]    Script Date: 06/07/2016 15:50:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_CONFIG_Inv_NumSeries_FETCH]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_CONFIG_Inv_NumSeries_FETCH]
GO
/****** Object:  StoredProcedure [dbo].[USP_CONFIG_Inv_NumSeries_FETCH]    Script Date: 06/07/2016 15:50:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_CONFIG_Inv_NumSeries_FETCH]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'                
CREATE PROCEDURE [dbo].[USP_CONFIG_Inv_NumSeries_FETCH]                
(                
 @IV_ID_SUBSIDERY_INV INT,      
 @IV_ID_DEPT_INV   INT              
)                
AS                
BEGIN                
                
            
SELECT       
 ID_NUMSERIES,      
 ID_INV_CONFIG,      
 MINV.ID_SETTINGS,      
 INV_INVNOSERIES,      
 INV_CRENOSEREIES,
 MAS.DESCRIPTION,
 PAYSER.INV_PREFIX ,
 PAYSERIES.INV_PREFIX AS CRE_PREFIX     
FROM       
 TBL_MAS_INV_NUMBER_CFG MINV INNER JOIN TBL_MAS_SETTINGS MAS ON MAS.ID_SETTINGS = MINV.ID_SETTINGS
 INNER JOIN TBL_MAS_INV_PAYMENT_SERIES PAYSER ON PAYSER.ID_PAYSERIES = MINV.INV_INVNOSERIES
INNER JOIN TBL_MAS_INV_PAYMENT_SERIES PAYSERIES ON PAYSERIES.ID_PAYSERIES = MINV.INV_CRENOSEREIES
WHERE MINV.MODIFIED_BY IS NULL AND MINV.DT_MODIFIED IS NULL      
AND ID_INV_CONFIG =      
(      
SELECT       
  ID_INV_CONFIG      
FROM       
  TBL_MAS_INV_CONFIGURATION       
WHERE       
  ID_SUBSIDERY_INV = @IV_ID_SUBSIDERY_INV AND       
  ID_DEPT_INV = @IV_ID_DEPT_INV 
  AND      
  DT_EFF_TO IS NULL      
)      
            
          
END                  
                  
/*         
      
 exec USP_CONFIG_INV_NUMSERIES_FETCH  10,1               
                
*/ 
' 
END
GO
