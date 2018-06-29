GO
---------------------------Change Password---------------------------------------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS(SELECT * FROM TBL_TAG_CAPTIONS WHERE CAPTION='Change Password' )
BEGIN
Insert into TBL_TAG_CAPTIONS (TAG,CAPTION,ID_LANG,DT_CREATED,CREATED_BY) values ('lblChngPwd','Change Password',1,GETDATE(),'admin')
Insert into TBL_TAG_CAPTIONS (TAG,CAPTION,ID_LANG,DT_CREATED,CREATED_BY) values ('lblChngPwd','Change Password_G',2,GETDATE(),'admin')
Insert into TBL_TAG_CAPTIONS (TAG,CAPTION,ID_LANG,DT_CREATED,CREATED_BY) values ('lblChngPwd','Change Password_N',3,GETDATE(),'admin')

Insert into TBL_TAG_CAPTIONS (TAG,CAPTION,ID_LANG,DT_CREATED,CREATED_BY) values ('lblOldPassword','Old Password',1,GETDATE(),'admin')
Insert into TBL_TAG_CAPTIONS (TAG,CAPTION,ID_LANG,DT_CREATED,CREATED_BY) values ('lblOldPassword','Old Password_G',2,GETDATE(),'admin')
Insert into TBL_TAG_CAPTIONS (TAG,CAPTION,ID_LANG,DT_CREATED,CREATED_BY) values ('lblOldPassword','Old Password_N',3,GETDATE(),'admin')

Insert into TBL_TAG_CAPTIONS (TAG,CAPTION,ID_LANG,DT_CREATED,CREATED_BY) values ('lblNewPassword','New Password',1,GETDATE(),'admin')
Insert into TBL_TAG_CAPTIONS (TAG,CAPTION,ID_LANG,DT_CREATED,CREATED_BY) values ('lblNewPassword','New Password_G',2,GETDATE(),'admin')
Insert into TBL_TAG_CAPTIONS (TAG,CAPTION,ID_LANG,DT_CREATED,CREATED_BY) values ('lblNewPassword','New Password_N',3,GETDATE(),'admin')

Insert into TBL_TAG_CAPTIONS (TAG,CAPTION,ID_LANG,DT_CREATED,CREATED_BY) values ('lblConfirmPassword','Password Confirm',1,GETDATE(),'admin')
Insert into TBL_TAG_CAPTIONS (TAG,CAPTION,ID_LANG,DT_CREATED,CREATED_BY) values ('lblConfirmPassword','Password Confirm_G',2,GETDATE(),'admin')
Insert into TBL_TAG_CAPTIONS (TAG,CAPTION,ID_LANG,DT_CREATED,CREATED_BY) values ('lblConfirmPassword','Password Confirm_N',3,GETDATE(),'admin')

END
GO
---------------------------Login---------------------------------------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS(SELECT * FROM TBL_TAG_CAPTIONS WHERE CAPTION='Login to the system' )
BEGIN
Insert into TBL_TAG_CAPTIONS (TAG,CAPTION,ID_LANG,DT_CREATED,CREATED_BY) values ('lblLogintosys','Login to the system',1,GETDATE(),'admin')
Insert into TBL_TAG_CAPTIONS (TAG,CAPTION,ID_LANG,DT_CREATED,CREATED_BY) values ('lblLogintosys','Ins System einloggen.',2,GETDATE(),'admin')
Insert into TBL_TAG_CAPTIONS (TAG,CAPTION,ID_LANG,DT_CREATED,CREATED_BY) values ('lblLogintosys','Pålogg',3,GETDATE(),'admin')

Insert into TBL_TAG_CAPTIONS (TAG,CAPTION,ID_LANG,DT_CREATED,CREATED_BY) values ('lblLanguage','English',1,GETDATE(),'admin')
Insert into TBL_TAG_CAPTIONS (TAG,CAPTION,ID_LANG,DT_CREATED,CREATED_BY) values ('lblLanguage','German',2,GETDATE(),'admin')
Insert into TBL_TAG_CAPTIONS (TAG,CAPTION,ID_LANG,DT_CREATED,CREATED_BY) values ('lblLanguage','Norsk',3,GETDATE(),'admin')

Insert into TBL_TAG_CAPTIONS (TAG,CAPTION,ID_LANG,DT_CREATED,CREATED_BY) values ('lblLoginTitle','Garage Planning and Administration System ',1,GETDATE(),'admin')
Insert into TBL_TAG_CAPTIONS (TAG,CAPTION,ID_LANG,DT_CREATED,CREATED_BY) values ('lblLoginTitle','Werkstatt Planungs- und Verwaltungsprogramm',2,GETDATE(),'admin')
Insert into TBL_TAG_CAPTIONS (TAG,CAPTION,ID_LANG,DT_CREATED,CREATED_BY) values ('lblLoginTitle','Verkstedplanlegging og Material Administrasjon',3,GETDATE(),'admin')

Insert into TBL_TAG_CAPTIONS (TAG,CAPTION,ID_LANG,DT_CREATED,CREATED_BY) values ('lbluser','User Name',1,GETDATE(),'admin')
Insert into TBL_TAG_CAPTIONS (TAG,CAPTION,ID_LANG,DT_CREATED,CREATED_BY) values ('lbluser','Benutzername',2,GETDATE(),'admin')
Insert into TBL_TAG_CAPTIONS (TAG,CAPTION,ID_LANG,DT_CREATED,CREATED_BY) values ('lbluser','Brukernavn',3,GETDATE(),'admin')


END

GO