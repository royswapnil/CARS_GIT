USE [CARSDEV]
GO
/****** Object:  StoredProcedure [dbo].[USP_SPR_GENERATE_PONUMBER]    Script Date: 31.01.2018 13:57:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************** APPLICATION: MSG *************************************************************        
* MODULE    : CONFIG        
* FILE NAME : USP_SPR_GENERATE_PONUMBER.PRC
* PURPOSE   : To generate purchase order number for Add Purchase Order,BackOrder
* AUTHOR    : NARESH R 
* DATE      : 26.10.2007        
*********************************************************************************************************************/        
/*********************************************************************************************************************          
I/P : -- INPUT PARAMETERS        
O/P : -- OUTPUT PARAMETERS        
@OV_RETVALUE - 'INSFLG' IF ERROR, 'OK' OTHERWISE        
       
ERROR CODE        
DESCRIPTION  
INT.VerNO : NOV21.0       
********************************************************************************************************************/        
--'*********************************************************************************'*********************************        
--'* MODIFIED HISTORY :           
--'* S.NO  RFC NO/BUG ID   DATE				AUTHOR			DESCRIPTION       
--'*  1			2694		02-JUNE			SUDHAKAR	MODIFIED PREFIX CONDITION	  
--* #0001#        
--'*********************************************************************************'*********************************


ALTER PROCEDURE [dbo].[USP_SPR_GENERATE_PONUMBER]
(
	@DeptId INT,
	@WarehouseId INT
)
AS
BEGIN
SET NOCOUNT ON

DECLARE @ENDNUM INT, @CURRNUM VARCHAR(10)
SELECT TOP 1 @CURRNUM = CASE ISNULL(PO_CURRNO,0)
			WHEN 0 THEN
				CAST(CAST(ISNULL(PO_CURRNO,PO_STARTNO) AS INT) AS VARCHAR) 
			ELSE
				CAST((CAST(PO_CURRNO AS INT)+1) AS VARCHAR)
		END ,
		@ENDNUM= PO_ENDNO
FROM TBL_SPR_POCONFIG
WHERE ID_WAREHOUSE = @WarehouseId AND ID_DEPT = @DeptId
ORDER BY ID_POCONFIG DESC
IF @ENDNUM >= @CURRNUM 
	SELECT TOP 1 
			ID_POCONFIG,
			PO_PREFIX,
			
			CASE ISNULL(PO_CURRNO,0)
				WHEN 0 THEN
					PO_PREFIX + CAST(CAST(ISNULL(PO_CURRNO,PO_STARTNO) AS INT) AS VARCHAR)
				ELSE
					PO_PREFIX + CAST((CAST(PO_CURRNO AS INT)+1) AS VARCHAR)
			END
			 AS PONUMBER,
			CASE ISNULL(PO_CURRNO,0)
				WHEN 0 THEN
					CAST(CAST(ISNULL(PO_CURRNO,PO_STARTNO) AS INT) AS VARCHAR) 
				ELSE
					CAST((CAST(PO_CURRNO AS INT)+1) AS VARCHAR)
			END
			AS PO_CURRNO,
			PO_ENDNO
	FROM TBL_SPR_POCONFIG
	WHERE ID_WAREHOUSE = @WarehouseId AND ID_DEPT = @DeptId
	ORDER BY ID_POCONFIG DESC
ELSE
	SELECT TOP 1 
			ID_POCONFIG,
			PO_PREFIX,
			
			CASE ISNULL(PO_CURRNO,0)
				WHEN 0 THEN
					PO_PREFIX + CAST(CAST(ISNULL(PO_CURRNO,PO_STARTNO) AS INT) AS VARCHAR)
				ELSE
					PO_PREFIX + CAST((CAST(PO_CURRNO AS INT)+1) AS VARCHAR)
			END
			 AS PONUMBER,
			CASE ISNULL(PO_CURRNO,0)
				WHEN 0 THEN
					CAST(CAST(ISNULL(PO_CURRNO,PO_STARTNO) AS INT) AS VARCHAR) 
				ELSE
					CAST((CAST(PO_CURRNO AS INT)+1) AS VARCHAR)
			END
			AS PO_CURRNO,
			PO_ENDNO
	FROM TBL_SPR_POCONFIG
	WHERE 1=2
END