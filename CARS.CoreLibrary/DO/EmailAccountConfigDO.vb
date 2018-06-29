Imports Microsoft.VisualBasic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports Microsoft.Practices.EnterpriseLibrary.Data.Sql
Imports System
Imports System.Configuration
Imports System.Data
Imports System.Data.Common
Namespace CARS.ConfigEmailAccount
    Public Class ConfigEmailAccountDO
        Dim ConnectionString As String
        Dim objDB As Database
        Dim strStatus As String
        Dim commonUtil As Utilities.CommonUtility
        Public Sub New()
            ConnectionString = System.Configuration.ConfigurationManager.AppSettings("MSGConstr")
            objDB = New SqlDatabase(ConnectionString)
        End Sub
        Public Function Fetch_EmailAccountConfig(ByVal userId As String) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_EMAIL_ACCT_CONFIG")
                    objDB.AddInParameter(objcmd, "@ID_USER", DbType.String, userId)
                    Try
                        Return objDB.ExecuteDataSet(objcmd)
                    Catch ex As Exception
                        Throw
                    End Try
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Save_EmailAccountConfig(ByVal objConfigEmailAcctBO As ConfigEmailAccountBO, ByVal userId As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_SAVE_EMAIL_ACCT_CONFIG")
                    objDB.AddInParameter(objcmd, "@ID_EMAIL_ACCT", DbType.Int32, Convert.ToInt32(objConfigEmailAcctBO.Id_Email_Accnt))
                    objDB.AddInParameter(objcmd, "@ID_SUBSIDIARY", DbType.Int32, Convert.ToInt32(objConfigEmailAcctBO.Id_Subsidiary))
                    objDB.AddInParameter(objcmd, "@SETTING_NAME", DbType.String, objConfigEmailAcctBO.Setting_Name)
                    objDB.AddInParameter(objcmd, "@EMAIL", DbType.String, objConfigEmailAcctBO.Email)
                    objDB.AddInParameter(objcmd, "@SMTP", DbType.String, objConfigEmailAcctBO.Smtp)
                    objDB.AddInParameter(objcmd, "@PORT", DbType.String, objConfigEmailAcctBO.Port)
                    objDB.AddInParameter(objcmd, "@CRYPTATION", DbType.String, objConfigEmailAcctBO.Cryptation)
                    objDB.AddInParameter(objcmd, "@USERNAME", DbType.String, objConfigEmailAcctBO.Username)
                    objDB.AddInParameter(objcmd, "@PASSWORD", DbType.String, objConfigEmailAcctBO.Password)
                    objDB.AddInParameter(objcmd, "@USER_ID", DbType.String, userId)
                    objDB.AddOutParameter(objcmd, "@OV_RETVAL", DbType.String, 10)
                    Try
                        objDB.ExecuteNonQuery(objcmd)
                        strStatus = objDB.GetParameterValue(objcmd, "@OV_RETVAL").ToString + "," + objDB.GetParameterValue(objcmd, "@OV_RETVAL").ToString
                    Catch ex As Exception
                        Throw
                    End Try
                End Using
                Return strStatus
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Delete_EmailAccount(ByVal xmlDoc As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_DELETE_EMAIL_ACCT_CONFIG")
                    objDB.AddInParameter(objcmd, "@IV_XMLDOC", DbType.String, xmlDoc)
                    objDB.AddOutParameter(objcmd, "@OV_RETVALUE", DbType.String, 10)
                    Try
                        objDB.ExecuteNonQuery(objcmd)
                        strStatus = objDB.GetParameterValue(objcmd, "@OV_RETVALUE").ToString + "," + objDB.GetParameterValue(objcmd, "@OV_RETVALUE").ToString
                    Catch ex As Exception
                        Throw
                    End Try
                End Using
                Return strStatus
            Catch ex As Exception
                Throw ex
            End Try
        End Function

    End Class
End Namespace

