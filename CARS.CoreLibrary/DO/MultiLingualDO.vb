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
Namespace CARS.MultiLingual
    Public Class MultiLingualDO
        Dim ConnectionString As String
        Dim objDB As Database
        Public Sub New()
            ConnectionString = System.Configuration.ConfigurationManager.AppSettings("MSGConstr")
            objDB = New SqlDatabase(ConnectionString)
        End Sub
        Public Function GetScreenData(ByVal objMultiLangBO As MultiLingualBO) As DataSet
            Dim dsMultiLang As DataSet = New DataSet()
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_SPR_FETCH_CTRL_DATA")
                    objDB.AddInParameter(objcmd, "@IV_SCRN_NAME", DbType.String, objMultiLangBO.ScreenName)
                    objDB.AddInParameter(objcmd, "@LANGUAGE", DbType.String, objMultiLangBO.LangName)
                    dsMultiLang = objDB.ExecuteDataSet(objcmd)
                End Using

            Catch ex As Exception
                Throw ex
            End Try
            Return dsMultiLang
        End Function
        Public Function Fetch_multilingual(ByVal objMultiLangBO As MultiLingualBO) As DataSet
            Dim dsMultiLang As DataSet = New DataSet()
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("UPS_RPT_DETAIL")
                    objDB.AddInParameter(objcmd, "@IV_SCREENNAME", DbType.String, objMultiLangBO.ScreenName)
                    objDB.AddInParameter(objcmd, "@IV_LANGUAGENAME", DbType.String, objMultiLangBO.LangName)
                    dsMultiLang = objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
            Return dsMultiLang
        End Function
        Public Function FillGridLan(ByVal objMultiLangBO As MultiLingualBO) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_LAN_FETCHLANG")
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try

        End Function
        Public Function GetErrMessage(ByVal objMultiLangBO As MultiLingualBO) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_MAS_ERR_MESSAGE_FETCH")
                    objDB.AddInParameter(objcmd, "@IV_LANG", DbType.Int32, Convert.ToInt32(objMultiLangBO.IdLang))
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Fetch_UserDeparmentDetails() As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_USERDEPARTMENT")
                    objDB.AddInParameter(objcmd, "@IV_USERID", DbType.String, System.Web.HttpContext.Current.Session("UserID"))
                    objDB.AddInParameter(objcmd, "@LANG_NAME", DbType.String, System.Configuration.ConfigurationManager.AppSettings("Language").ToString())

                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function


    End Class
End Namespace

