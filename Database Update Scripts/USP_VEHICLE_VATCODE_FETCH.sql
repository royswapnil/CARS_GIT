USE [CARSDEV]
GO

/****** Object:  StoredProcedure [dbo].[USP_VEHICLE_VATCODE_FETCH]    Script Date: 03.10.2017 11:13:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[USP_VEHICLE_VATCODE_FETCH]      
as      
begin      
select ID_SETTINGS, DESCRIPTION, EXT_VAT_CODE 
from TBL_MAS_SETTINGS where id_config='VAT'
end 
GO

