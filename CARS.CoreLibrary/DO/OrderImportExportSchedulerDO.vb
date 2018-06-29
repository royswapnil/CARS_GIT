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
Imports System.Web
Namespace CARS.OrderImportExportSchedulerDO
    Public Class OrderImportExportSchedulerDO
        Dim ConnectionString As String
        Shared objCommonUtil As New CARS.Utilities.CommonUtility
        Dim objDB As Database
        Dim strStatus As String
        Dim strResult As String
        Public Sub New()
            ConnectionString = System.Configuration.ConfigurationManager.AppSettings("MSGConstr")
            objDB = New SqlDatabase(ConnectionString)
        End Sub

        Public Function FetchOrdImpExpConfigSchedule() As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_ORD_IMP_EXP_CONFIG_SCHEDULE")
                    objDB.AddInParameter(objcmd, "@File_Type", DbType.String, "IMPORT")
                    objDB.AddInParameter(objcmd, "@Ord_Imp_File_Name", DbType.String, "SparePartImportTemplate.aspx")
                    objDB.AddInParameter(objcmd, "@Ord_Exp_File_Name", DbType.String, "SparePartImportTemplate.aspx")
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function

        Public Function SaveOrdImportConfigSchedule(ByVal objOrdImpExpSchBO As OrderImportExportSchedulerBO) As String
            Dim strResult As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_ORDER_IMPORT_CONFIG_SCHEDULE")
                    objDB.AddInParameter(objcmd, "@Ord_Imp_FileLocation", DbType.String, objOrdImpExpSchBO.Import_FileLocation)
                    objDB.AddInParameter(objcmd, "@Ord_Imp_FileName", DbType.String, objOrdImpExpSchBO.Import_FileName)
                    objDB.AddInParameter(objcmd, "@Ord_Imp_Sch_Basis", DbType.String, objOrdImpExpSchBO.Import_Sch_Basis)
                    objDB.AddInParameter(objcmd, "@Ord_Imp_TimeFormat", DbType.String, objOrdImpExpSchBO.Import_Sch_TimeFormat)
                    objDB.AddInParameter(objcmd, "@Ord_Imp_Sch_Daily_Interval_mins", DbType.String, objOrdImpExpSchBO.Import_Sch_Daily_Interval_mins)
                    objDB.AddInParameter(objcmd, "@Ord_Imp_Sch_Week_Day", DbType.String, objOrdImpExpSchBO.Import_Sch_Week_Day)
                    objDB.AddInParameter(objcmd, "@Ord_Imp_Sch_Month_Day", DbType.String, objOrdImpExpSchBO.Import_Sch_Month_Day)
                    objDB.AddInParameter(objcmd, "@Ord_Imp_Sch_Daily_STime", DbType.String, objOrdImpExpSchBO.Import_Sch_Daily_STime)
                    objDB.AddInParameter(objcmd, "@Ord_Imp_Sch_Daily_ETime", DbType.String, objOrdImpExpSchBO.Import_Sch_Daily_ETime)
                    objDB.AddInParameter(objcmd, "@Ord_Imp_Sch_Week_Time", DbType.String, objOrdImpExpSchBO.Import_Sch_Week_Time)
                    objDB.AddInParameter(objcmd, "@Ord_Imp_Sch_Month_Time", DbType.String, objOrdImpExpSchBO.Import_Sch_Month_Time)
                    objDB.AddInParameter(objcmd, "@CREATED_BY", DbType.String, HttpContext.Current.Session("UserID"))
                    objDB.AddInParameter(objcmd, "@Ord_Imp_Template", DbType.String, objOrdImpExpSchBO.Import_Template)
                    objDB.AddOutParameter(objcmd, "@OV_RETVALUE", DbType.Int32, 10)

                    objDB.ExecuteNonQuery(objcmd)
                    strResult = objDB.GetParameterValue(objcmd, "@OV_RETVALUE").ToString
                End Using
            Catch ex As Exception
                Throw ex
            End Try
            Return strResult
        End Function
        Public Function SaveOrdExportConfigSchedule(ByVal objOrdImpExpSchBO As OrderImportExportSchedulerBO) As String
            Dim strResult As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_ORDER_EXPORT_CONFIG_SCHEDULE")
                    objDB.AddInParameter(objcmd, "@Ord_Exp_FileLocation", DbType.String, objOrdImpExpSchBO.Export_FileLocation)
                    objDB.AddInParameter(objcmd, "@Ord_Exp_FileName", DbType.String, objOrdImpExpSchBO.Export_FileName)
                    objDB.AddInParameter(objcmd, "@Ord_Exp_Sch_Basis", DbType.String, objOrdImpExpSchBO.Export_Sch_Basis)
                    objDB.AddInParameter(objcmd, "@Ord_Exp_TimeFormat", DbType.String, objOrdImpExpSchBO.Export_Sch_TimeFormat)
                    objDB.AddInParameter(objcmd, "@Ord_Exp_Sch_Daily_Interval_mins", DbType.String, objOrdImpExpSchBO.Export_Sch_Daily_Interval_mins)
                    objDB.AddInParameter(objcmd, "@Ord_Exp_Sch_Week_Day", DbType.String, objOrdImpExpSchBO.Export_Sch_Week_Day)
                    objDB.AddInParameter(objcmd, "@Ord_Exp_Sch_Month_Day", DbType.String, objOrdImpExpSchBO.Export_Sch_Month_Day)
                    objDB.AddInParameter(objcmd, "@Ord_Exp_Sch_Daily_STime", DbType.String, objOrdImpExpSchBO.Export_Sch_Daily_STime)
                    objDB.AddInParameter(objcmd, "@Ord_Exp_Sch_Daily_ETime", DbType.String, objOrdImpExpSchBO.Export_Sch_Daily_ETime)
                    objDB.AddInParameter(objcmd, "@Ord_Exp_Sch_Week_Time", DbType.String, objOrdImpExpSchBO.Export_Sch_Week_Time)
                    objDB.AddInParameter(objcmd, "@Ord_Exp_Sch_Month_Time", DbType.String, objOrdImpExpSchBO.Export_Sch_Month_Time)
                    objDB.AddInParameter(objcmd, "@CREATED_BY", DbType.String, HttpContext.Current.Session("UserID"))
                    objDB.AddInParameter(objcmd, "@Ord_Exp_Template", DbType.String, objOrdImpExpSchBO.Export_Template)
                    objDB.AddOutParameter(objcmd, "@OV_RETVALUE", DbType.Int32, 10)

                    objDB.ExecuteNonQuery(objcmd)
                    strResult = objDB.GetParameterValue(objcmd, "@OV_RETVALUE").ToString
                End Using
            Catch ex As Exception
                Throw ex
            End Try
            Return strResult
        End Function

    End Class

End Namespace
