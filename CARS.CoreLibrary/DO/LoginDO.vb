Imports CARS.CoreLibrary
Imports Microsoft.VisualBasic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports Microsoft.Practices.EnterpriseLibrary.Data.Sql
Imports System
Imports System.Configuration
Imports System.Data
Imports System.Data.Common
Imports System.Security.Cryptography
Imports System.IO
Namespace CARS.Login
    Public Class LoginDO
        Dim ConnectionString As String
        Dim objDB As Database
        Public Sub New()
            ConnectionString = System.Configuration.ConfigurationManager.AppSettings("MSGConstr")
            objDB = New SqlDatabase(ConnectionString)
        End Sub
        Public Function ValidateUser(ByVal objLoginBO As LoginBO) As String
            Dim strStatus As String
            Try
                objLoginBO.Password = Encrypt(objLoginBO.Password, "&%#@?,:*")
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("usp_Adm_ValidateUser_NEW")
                    objDB.AddInParameter(objcmd, "@iv_ID_Login", DbType.String, objLoginBO.UserId)
                    objDB.AddInParameter(objcmd, "@iv_Password", DbType.String, objLoginBO.Password)
                    objDB.AddOutParameter(objcmd, "@ov_Error_Code", DbType.String, 50)
                    Try
                        objDB.ExecuteNonQuery(objcmd)
                        strStatus = objDB.GetParameterValue(objcmd, "@ov_Error_Code").ToString
                    Catch ex As Exception
                        Throw
                    End Try
                End Using
                Return strStatus
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        '******************************************************'***************
        '  Name of Method         		: GetPageAcess
        '  Description            		: fetching permission details
        '  Input Params           		: - 
        '  Output Params          		: -
        '  I/O Params             		: -     
        '  Globals Used           		: - 
        '  Routines Called        		: -
        '***********************************************************************
        Public Function GetPageAcess(ByVal objLoginBO As LoginBO) As DataSet
            Dim DsUserDet As New DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("Usp_UserPerDet")
                    objDB.AddInParameter(objcmd, "@iv_ID_Login", DbType.String, objLoginBO.UserId)
                    DsUserDet = objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
            Return DsUserDet
        End Function
        '******************************************************'***************
        '  Name of Method         		: GetUserDetails
        '  Description            		: Fetching user details
        '  Input Params           		: - 
        '  Output Params          		: -
        '  I/O Params             		: -     
        '  Globals Used           		: - 
        '  Routines Called        		: -
        '***********************************************************************
        Public Function GetUserDetails(ByVal objLoginBO As LoginBO) As DataSet
            Dim DsUserDet As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_USER_DEPT_DETAILS")
                    objDB.AddInParameter(objcmd, "@IV_USER", DbType.String, objLoginBO.UserId)
                    DsUserDet = objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
            Return DsUserDet
        End Function
        '******************************************************'***************
        '  Name of Method         		: ModuleName
        '  Description            		: Fetching start up screen
        '  Input Params           		: - 
        '  Output Params          		: -
        '  I/O Params             		: -     
        '  Globals Used           		: - 
        '  Routines Called        		: -
        '***********************************************************************
        Public Function ModuleName(ByVal objLoginBO As LoginBO) As String
            Dim strModuleName As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("usp_Adm_UserStartScr")
                    objDB.AddInParameter(objcmd, "@iv_ID_Login", DbType.String, objLoginBO.UserId)
                    objDB.AddOutParameter(objcmd, "@ov_StartScreen", DbType.String, 500)
                    objDB.ExecuteNonQuery(objcmd)
                    strModuleName = objDB.GetParameterValue(objcmd, "@ov_StartScreen").ToString
                End Using
                Return strModuleName
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        '******************************************************'***************
        '  Name of Method         		: FetchMLMenuDetails
        '  Description            		: Fetching left menu, top menu caption for multilingual
        '  Input Params           		: - 
        '  Output Params          		: -
        '  I/O Params             		: -     
        '  Globals Used           		: - 
        '  Routines Called        		: -
        '***********************************************************************
        Public Function FetchMLMenuDetails(ByVal objLoginBO As LoginBO) As DataSet
            Dim dsLTMenu As DataSet = Nothing
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_ML_leftMenuFetch")
                    objDB.AddInParameter(objcmd, "@MOD_NAME", DbType.String, objLoginBO.pMLModuleName)
                    objDB.AddInParameter(objcmd, "@LANG_NAME", DbType.String, objLoginBO.PMLLangName)
                    objDB.AddInParameter(objcmd, "@MENU_TYPE", DbType.String, objLoginBO.PMLMenuType)
                    objDB.AddOutParameter(objcmd, "@OV_ERROR", DbType.String, 150)
                    dsLTMenu = objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
            Return dsLTMenu
        End Function
        Private Shared Function Encrypt(ByVal strText As String, ByVal strEncrKey As String) As String
            Dim IV() As Byte = {&H12, &H34, &H56, &H78, &H90, &HAB, &HCD, &HEF}
            Try
                Dim bykey() As Byte = System.Text.Encoding.UTF8.GetBytes(Left(strEncrKey, 8))
                Dim InputByteArray() As Byte = System.Text.Encoding.UTF8.GetBytes(strText)
                Dim des As New DESCryptoServiceProvider
                Dim ms As New MemoryStream
                Dim cs As New CryptoStream(ms, des.CreateEncryptor(bykey, IV), CryptoStreamMode.Write)
                cs.Write(InputByteArray, 0, InputByteArray.Length)
                cs.FlushFinalBlock()
                Return Convert.ToBase64String(ms.ToArray())
            Catch exth As System.Threading.ThreadAbortException
                Throw exth
            Catch ex As Exception
                Return ex.Message
            End Try
        End Function

    End Class
End Namespace
