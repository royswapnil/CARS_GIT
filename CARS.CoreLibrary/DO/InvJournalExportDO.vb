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
Namespace CARS.InvoiceJournalExport
    Public Class InvJournalExportDO
        Dim ConnectionString As String
        Dim objDB As Database
        Dim strStatus As String
        Dim commonUtil As Utilities.CommonUtility
        Public Sub New()
            ConnectionString = System.Configuration.ConfigurationManager.AppSettings("MSGConstr")
            objDB = New SqlDatabase(ConnectionString)
        End Sub
        Public Function FetchFieldConfiguration(ByVal objInvExpBO As InvJournalExportBO) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_MAS_FETCH_FIELD_CONFIGURATION")
                    objDB.AddInParameter(objcmd, "@File_Type", DbType.String, objInvExpBO.FileType)
                    objDB.AddInParameter(objcmd, "@File_Name", DbType.String, objInvExpBO.FileName)
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
        Public Function FetchConfiguration(ByVal objInvExpBO As InvJournalExportBO) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_MAS_FETCH_TEMPLATE_CONFIGURATION")
                    objDB.AddInParameter(objcmd, "@File_Type", DbType.String, objInvExpBO.FileType)
                    objDB.AddInParameter(objcmd, "@File_Name", DbType.String, objInvExpBO.FileName)
                    objDB.AddInParameter(objcmd, "@TEMPLATE_ID", DbType.String, objInvExpBO.TemplateId)
                    objDB.AddInParameter(objcmd, "@Language", DbType.String, System.Configuration.ConfigurationManager.AppSettings("Language").ToString())
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
        Public Function FetchTemplateConfigurations(ByVal objInvExpBO As InvJournalExportBO) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_MAS_FETCH_FIELD_NAMES")
                    objDB.AddInParameter(objcmd, "@File_Type", DbType.String, objInvExpBO.FileType)
                    objDB.AddInParameter(objcmd, "@File_Name", DbType.String, objInvExpBO.FileName)
                    objDB.AddInParameter(objcmd, "@Language", DbType.String, System.Configuration.ConfigurationManager.AppSettings("Language").ToString())
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
        Public Function SaveConfiguration(ByVal objCustExpBO As InvJournalExportBO) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_MAS_SAVE_TEMPLATE_CONFIGURATION")
                    objDB.AddInParameter(objcmd, "@File_Type", DbType.String, objCustExpBO.FileType)
                    objDB.AddInParameter(objcmd, "@File_Name", DbType.String, objCustExpBO.FileName)
                    objDB.AddInParameter(objcmd, "@TEMPLATE_ID", DbType.String, objCustExpBO.TemplateId)
                    objDB.AddInParameter(objcmd, "@Configuration", DbType.String, objCustExpBO.Configuration)
                    objDB.AddInParameter(objcmd, "@Condition", DbType.String, Nothing)
                    objDB.AddInParameter(objcmd, "@CHARACTER_SET", DbType.String, objCustExpBO.CharacterSet)
                    objDB.AddInParameter(objcmd, "@DECIMAL_DELIMITER", DbType.String, objCustExpBO.DecimalDelimiter)
                    objDB.AddInParameter(objcmd, "@THOUSANDS_DELIMITER", DbType.String, objCustExpBO.ThousandsDelimiter)
                    objDB.AddInParameter(objcmd, "@DATE_FORMAT", DbType.String, objCustExpBO.DateFormat)
                    objDB.AddInParameter(objcmd, "@TIME_FORMAT", DbType.String, objCustExpBO.TimeFormat)
                    objDB.AddInParameter(objcmd, "@FILE_MODE", DbType.String, objCustExpBO.FileMode)
                    objDB.AddInParameter(objcmd, "@DELIMITER", DbType.String, objCustExpBO.SpecialDelimiter)
                    objDB.AddInParameter(objcmd, "@DELIMITER_OTHER", DbType.String, objCustExpBO.DelimiterOther)
                    objDB.AddInParameter(objcmd, "@DESCRIPTION", DbType.String, objCustExpBO.Description)
                    objDB.AddInParameter(objcmd, "@UserID", DbType.String, objCustExpBO.UserId)
                    objDB.AddInParameter(objcmd, "@TEMPLATE_NAME", DbType.String, objCustExpBO.TemplateName)
                    objDB.AddInParameter(objcmd, "@FLF_BL_SPAC", DbType.Boolean, 0)
                    objDB.AddInParameter(objcmd, "@BLANK_SPACES", DbType.Int32, 0)
                    objDB.AddOutParameter(objcmd, "@0V_RETVALUE", DbType.String, 20)
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@0V_RETVALUE").ToString()
                End Using
                Return strStatus
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function DeleteConfiguration(ByVal objCustExpBO As InvJournalExportBO) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_MAS_DELETE_TEMPLATE_CONFIGURATION")
                    objDB.AddInParameter(objcmd, "@File_Type", DbType.String, objCustExpBO.FileType)
                    objDB.AddInParameter(objcmd, "@File_Name", DbType.String, objCustExpBO.FileName)
                    objDB.AddInParameter(objcmd, "@TEMPLATE_ID", DbType.String, objCustExpBO.TemplateId)
                    objDB.AddOutParameter(objcmd, "@0V_RETVALUE", DbType.String, 20)
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@0V_RETVALUE").ToString()
                End Using
                Return strStatus
            Catch ex As Exception
                Throw ex
            End Try
        End Function
    End Class
End Namespace
