IF NOT EXISTS(SELECT * FROM syscolumns WHERE id=object_id('TBL_MAS_ENVFEESETTINGS') AND name='SUPP_CURRENTNO')
BEGIN 
ALTER TABLE TBL_MAS_ENVFEESETTINGS
ADD  SUPP_CURRENTNO VARCHAR(50)
END