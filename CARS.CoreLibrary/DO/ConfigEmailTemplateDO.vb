Imports Microsoft.VisualBasic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports Microsoft.Practices.EnterpriseLibrary.Data.Sql
Imports System
Imports System.Configuration
Imports System.Data
Imports System.Data.Common
Imports System.Security.Cryptography
Imports System.IO
Imports CARS.CoreLibrary
Namespace CARS.ConfigEmailTemplate
    Public Class ConfigEmailTemplateDO
        Dim ConnectionString As String
        Dim objDB As Database
        Dim strStatus As String
        Dim commonUtil As Utilities.CommonUtility
        Public Sub New()
            ConnectionString = System.Configuration.ConfigurationManager.AppSettings("MSGConstr")
            objDB = New SqlDatabase(ConnectionString)
        End Sub
        Public Function Fetch_EmailTemplateConfig() As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_MESSAGETEMPLATE")
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
        Public Function Add_EmailTemplate(ByVal objConfigEmailTemplateBO As ConfigEmailTemplateBO, ByVal userId As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_INSERT_MESSAGETEMPLATE")
                    objDB.AddInParameter(objcmd, "@TEMPLATE_CODE", DbType.String, objConfigEmailTemplateBO.Template_Code)
                    objDB.AddInParameter(objcmd, "@SUBJECT", DbType.String, objConfigEmailTemplateBO.Subject)
                    objDB.AddInParameter(objcmd, "@MESSAGE", DbType.String, objConfigEmailTemplateBO.Message)
                    objDB.AddInParameter(objcmd, "@CREATED_BY", DbType.String, userId)
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
        Public Function Update_EmailTemplate(ByVal objConfigEmailTemplateBO As ConfigEmailTemplateBO, ByVal userId As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_UPDATE_MESSAGETEMPLATE")
                    objDB.AddInParameter(objcmd, "@ID_TEMPLATE", DbType.Int32, Convert.ToInt32(objConfigEmailTemplateBO.Id_Template))
                    objDB.AddInParameter(objcmd, "@TEMPLATE_CODE", DbType.String, objConfigEmailTemplateBO.Template_Code)
                    objDB.AddInParameter(objcmd, "@SUBJECT", DbType.String, objConfigEmailTemplateBO.Subject)
                    objDB.AddInParameter(objcmd, "@MESSAGE", DbType.String, objConfigEmailTemplateBO.Message)
                    objDB.AddInParameter(objcmd, "@MODIFIED_BY", DbType.String, userId)
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
        Public Function Delete_EmailTemplate(ByVal xmlDoc As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_DELETE_MESSAGETEMPLATE")
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
        Public Function Fetch_InvEmailTemplateConfig() As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_INVOICE_MESSAGETEMPLATE")
                    objDB.AddInParameter(objcmd, "@IV_Lang", DbType.String, System.Configuration.ConfigurationManager.AppSettings("Language").ToString)
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
        Public Function Fetch_InvEmailSchedule() As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_INVOICE_EMAILSCHEDULE")
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
        Public Function Add_InvEmailTemplate(ByVal objConfigEmailTemplateBO As ConfigEmailTemplateBO, ByVal userId As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_INSERT_INVOICE_MESSAGETEMPLATE")
                    objDB.AddInParameter(objcmd, "@TEMPLATE_CODE", DbType.String, objConfigEmailTemplateBO.Template_Code)
                    objDB.AddInParameter(objcmd, "@SUBJECT", DbType.String, objConfigEmailTemplateBO.Subject)
                    objDB.AddInParameter(objcmd, "@MESSAGE", DbType.String, objConfigEmailTemplateBO.Message)
                    objDB.AddInParameter(objcmd, "@CREATED_BY", DbType.String, userId)
                    objDB.AddInParameter(objcmd, "@FLG_DEFAULT", DbType.Boolean, objConfigEmailTemplateBO.Flg_Default)
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
        Public Function Update_InvEmailTemplate(ByVal objConfigEmailTemplateBO As ConfigEmailTemplateBO, ByVal userId As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_UPDATE_INVOICE_MESSAGETEMPLATE")
                    objDB.AddInParameter(objcmd, "@ID_TEMPLATE", DbType.Int32, Convert.ToInt32(objConfigEmailTemplateBO.Id_Template))
                    objDB.AddInParameter(objcmd, "@TEMPLATE_CODE", DbType.String, objConfigEmailTemplateBO.Template_Code)
                    objDB.AddInParameter(objcmd, "@SUBJECT", DbType.String, objConfigEmailTemplateBO.Subject)
                    objDB.AddInParameter(objcmd, "@MESSAGE", DbType.String, objConfigEmailTemplateBO.Message)
                    objDB.AddInParameter(objcmd, "@MODIFIED_BY", DbType.String, userId)
                    objDB.AddInParameter(objcmd, "@FLG_DEFAULT", DbType.Boolean, objConfigEmailTemplateBO.Flg_Default)
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
        Public Function Delete_InvEmailTemplate(ByVal xmlDoc As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_DELETE_INVOICE_MESSAGETEMPLATE")
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
        Public Function Save_InvEmailSchedule(ByVal objConfigEmailTemplateBO As ConfigEmailTemplateBO, ByVal userId As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_SAVE_INVOICEEMAIL_SCHEDULER")
                    objDB.AddInParameter(objcmd, "@Start_Time", DbType.String, objConfigEmailTemplateBO.Start_Time)
                    objDB.AddInParameter(objcmd, "@USE_MON", DbType.String, objConfigEmailTemplateBO.Use_Mon)
                    objDB.AddInParameter(objcmd, "@USE_TUE", DbType.String, objConfigEmailTemplateBO.Use_Tue)
                    objDB.AddInParameter(objcmd, "@USE_WED", DbType.String, objConfigEmailTemplateBO.Use_Wed)
                    objDB.AddInParameter(objcmd, "@USE_THUR", DbType.String, objConfigEmailTemplateBO.Use_Thur)
                    objDB.AddInParameter(objcmd, "@USE_FRI", DbType.String, objConfigEmailTemplateBO.Use_Fri)
                    objDB.AddInParameter(objcmd, "@USE_SAT", DbType.String, objConfigEmailTemplateBO.Use_Sat)
                    objDB.AddInParameter(objcmd, "@USE_SUN", DbType.String, objConfigEmailTemplateBO.Use_Sun)
                    objDB.AddInParameter(objcmd, "@IV_ID_CREATED_BY", DbType.String, userId)
                    objDB.AddOutParameter(objcmd, "@ov_RetValue", DbType.String, 10)
                    Try
                        objDB.ExecuteNonQuery(objcmd)
                        strStatus = objDB.GetParameterValue(objcmd, "@ov_RetValue").ToString + "," + objDB.GetParameterValue(objcmd, "@ov_RetValue").ToString
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


