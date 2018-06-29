
GO
---------------------------Top Banner---------------------------------------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS(SELECT * FROM TBL_TAG_CAPTIONS WHERE CAPTION='Logout' )
BEGIN
	Insert into TBL_TAG_CAPTIONS (TAG,CAPTION,ID_LANG,DT_CREATED,CREATED_BY) values ('lblLogout','Logout',1,GETDATE(),'admin')
	Insert into TBL_TAG_CAPTIONS (TAG,CAPTION,ID_LANG,DT_CREATED,CREATED_BY) values ('lblLogout','Ausloggen',2,GETDATE(),'admin')
	Insert into TBL_TAG_CAPTIONS (TAG,CAPTION,ID_LANG,DT_CREATED,CREATED_BY) values ('lblLogout','Logg ut',3,GETDATE(),'admin')

	Insert into TBL_TAG_CAPTIONS (TAG,CAPTION,ID_LANG,DT_CREATED,CREATED_BY) values ('lblVersion','Version',1,GETDATE(),'admin')
	Insert into TBL_TAG_CAPTIONS (TAG,CAPTION,ID_LANG,DT_CREATED,CREATED_BY) values ('lblVersion','Version',2,GETDATE(),'admin')
	Insert into TBL_TAG_CAPTIONS (TAG,CAPTION,ID_LANG,DT_CREATED,CREATED_BY) values ('lblVersion','Versjon',3,GETDATE(),'admin')

END
GO