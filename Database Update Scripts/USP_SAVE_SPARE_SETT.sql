/****** Object:  StoredProcedure [dbo].[USP_SAVE_SPARE_SETT]    Script Date: 11/17/2016 11:26:48 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_SAVE_SPARE_SETT]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_SAVE_SPARE_SETT]
GO
/****** Object:  StoredProcedure [dbo].[USP_SAVE_SPARE_SETT]    Script Date: 11/17/2016 11:26:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_SAVE_SPARE_SETT]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_SAVE_SPARE_SETT] AS' 
END
GO
ALTER  PROC [dbo].[USP_SAVE_SPARE_SETT]                 
(       
 @SP_MAKE XML = '<ROOT><MAKE><ID_MAKE>VO</ID_MAKE></MAKE><MAKE><ID_MAKE>VP</ID_MAKE></MAKE></ROOT>',           
 @SP_SUPPLIER XML = '<ROOT><SUPPLIER><ID_SUPPLIER>697</ID_SUPPLIER></SUPPLIER></ROOT>',        
 @SP_LOCATION XML = '<ROOT><LOCATION><LOC>Lager</LOC></LOCATION><LOCATION><LOC>A</LOC></LOCATION></ROOT>',    
 @StockItem bit,       
 @Flg_stockitem_status bit,      
 @Flg_nonstockitem_status bit,    
 @CreatedBy varchar(20) ,    
 @OV_RETVALUE VARCHAR(10)OUTPUT         
)                
AS                  
BEGIN        
 DECLARE @HDOCMAKE INT            
 EXEC SP_XML_PREPAREDOCUMENT @HDOCMAKE OUTPUT, @SP_MAKE            
            
 DECLARE @TABLE_MAKE_LIST TABLE            
 (            
  ROWNUM INT,         
  ID_MAKE VARCHAR(10)           
 )              
 INSERT INTO @TABLE_MAKE_LIST             
        
 SELECT  ROW_NUMBER() OVER(ORDER BY ID_MAKE) AS 'ROWNUM',ID_MAKE FROM OPENXML (@HDOCMAKE,'/ROOT/MAKE',2)            
 WITH   (ID_MAKE VARCHAR(10))            
 --SELECT * FROM @TABLE_MAKE_LIST        
 DELETE FROM @TABLE_MAKE_LIST WHERE ISNULL(ID_MAKE,'')=''        
        
 DECLARE @HDOCSUPP INT            
 EXEC SP_XML_PREPAREDOCUMENT @HDOCSUPP OUTPUT, @SP_SUPPLIER            
            
 DECLARE @TABLE_SUPP_LIST TABLE            
 (            
  ROWNUM INT,         
  ID_SUPPLIER VARCHAR(10)           
 )              
 INSERT INTO @TABLE_SUPP_LIST             
 SELECT ROW_NUMBER() OVER(ORDER BY ID_SUPPLIER) AS 'ROWNUM',ID_SUPPLIER FROM OPENXML (@HDOCSUPP,'/ROOT/SUPPLIER',2)            
 WITH   (ID_SUPPLIER VARCHAR(10))            
 --SELECT * FROM @TABLE_SUPP_LIST        
 DELETE FROM @TABLE_SUPP_LIST WHERE ISNULL(ID_SUPPLIER,'')=''        
        
 DECLARE @HDOCLOC INT            
 EXEC SP_XML_PREPAREDOCUMENT @HDOCLOC OUTPUT, @SP_LOCATION            
            
 DECLARE @TABLE_LOC_LIST TABLE            
 (            
  ROWNUM INT,         
  LOC VARCHAR(10)           
 )              
 INSERT INTO @TABLE_LOC_LIST             
 SELECT ROW_NUMBER() OVER(ORDER BY LOC) AS 'ROWNUM',LOC FROM OPENXML (@HDOCLOC,'/ROOT/LOCATION',2)            
 WITH   (LOC VARCHAR(10))            
 --SELECT * FROM @TABLE_LOC_LIST        
 DELETE FROM @TABLE_LOC_LIST WHERE ISNULL(LOC,'')=''        
       
       
DECLARE @Make_List VARCHAR(MAX)      
DECLARE @Supp_List VARCHAR(MAX)      
DECLARE @Loc_List VARCHAR(MAX)      
IF ((SELECT COUNT(*) FROM @TABLE_MAKE_LIST) > 0)      
BEGIN      
      
 DECLARE @MC INT      
 DECLARE @MI INT = 1      
 SELECT @MC=COUNT(*) FROM @TABLE_MAKE_LIST      
 SET @Make_List = ''       
 WHILE (@MI<=@MC)      
  BEGIN      
  SET @Make_List = @Make_List + (SELECT ID_MAKE FROM @TABLE_MAKE_LIST WHERE ROWNUM= @MI)       
  SET @MI=@MI+1      
  IF @MC>1 AND @MI<=@MC      
   BEGIN      
    SET @Make_List = @Make_List + ','      
   END      
 END      
END      
      
IF ((SELECT COUNT(*) FROM @TABLE_SUPP_LIST) > 0)      
BEGIN      
      
 DECLARE @SC INT      
 DECLARE @SI INT = 1      
 SELECT @SC=COUNT(*) FROM @TABLE_SUPP_LIST      
 SET @Supp_List = ''       
 WHILE (@SI<=@SC)      
  BEGIN      
  SET @Supp_List = @Supp_List + (SELECT ID_SUPPLIER FROM @TABLE_SUPP_LIST WHERE ROWNUM= @SI)       
  SET @SI=@SI+1      
  IF @SC>1 AND @SI<=@SC      
   BEGIN      
    SET @Supp_List = @Supp_List + ','      
   END      
 END      
END      
      
      
      
IF ((SELECT COUNT(*) FROM @TABLE_LOC_LIST) > 0)      
BEGIN      
      
 DECLARE @LC INT      
 DECLARE @LI INT = 1      
 SELECT @LC=COUNT(*) FROM @TABLE_LOC_LIST      
 SET @Loc_List = ''       
 WHILE (@LI<=@LC)      
  BEGIN      
  SET @Loc_List = @Loc_List + (SELECT LOC FROM @TABLE_LOC_LIST WHERE ROWNUM= @LI)       
  SET @LI=@LI+1      
  IF @LC>1 AND @LI<=@LC      
   BEGIN      
    SET @Loc_List = @Loc_List + ','      
   END      
 END      
END      
SELECT @Make_List Make, @Supp_List Supplier,@Loc_List Location     
    
    
    
DELETE FROM TBL_SPR_SETTINGS    
    
 INSERT INTO TBL_SPR_SETTINGS     SELECT @Make_List Make, @Supp_List Supplier,@Loc_List Location , @StockItem,@Flg_stockitem_status,@Flg_nonstockitem_status,getdate(),getdate(),@CreatedBy    
    
IF @@ERROR = 0              
 BEGIN       
   SET @OV_RETVALUE = 'SUCCESS'      
 END     
ELSE    
 BEGIN    
 --SELECT @@ERROR,  @OV_RETVALUE AS 'Roll'    
   SET @OV_RETVALUE = 'ERROR'      
 END     
      
       
       
END
GO
