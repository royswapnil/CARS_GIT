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
Namespace CARS.ScanDataImportSchedulerDO
    Public Class ScanDataImportSchedulerDO
        Dim ConnectionString As String
        Shared objCommonUtil As New CARS.Utilities.CommonUtility
        Dim objDB As Database
        Dim strStatus As String
        Dim strResult As String
        Public Sub New()
            ConnectionString = System.Configuration.ConfigurationManager.AppSettings("MSGConstr")
            objDB = New SqlDatabase(ConnectionString)
        End Sub
        Public Function FetchScanDataImpScheduler() As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_SCAN_CONFIG_SCHEDULE")
                    objDB.AddInParameter(objcmd, "@IV_Lang", DbType.String, System.Configuration.ConfigurationManager.AppSettings("Language").ToString())
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function GetScanDataImpScheduler(ByVal schId As String) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_GET_SCAN_CONFIG_SCHEDULE")
                    objDB.AddInParameter(objcmd, "@Sch_Id", DbType.String, schId)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function SaveScanDataImpScheduler(ByVal objScanDataImpSchBO As ScanDataImportSchedulerBO) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_INSERT_SCAN_CONFIG_SCHEDULE")
                    objDB.AddInParameter(objcmd, "@SCH_BASIS", DbType.String, objScanDataImpSchBO.Sch_Basis)
                    objDB.AddInParameter(objcmd, "@SCH_TIMEFORMAT", DbType.String, objScanDataImpSchBO.Sch_TimeFormat)
                    objDB.AddInParameter(objcmd, "@SCH_DAILY_INTERVAL_MINS", DbType.Int32, Convert.ToInt32(objScanDataImpSchBO.Sch_Daily_Interval_mins))
                    objDB.AddInParameter(objcmd, "@SCH_WEEK_DAY", DbType.Int32, Convert.ToInt32(objScanDataImpSchBO.Sch_Week_Day))
                    objDB.AddInParameter(objcmd, "@SCH_MONTH_DAY", DbType.Int32, Convert.ToInt32(objScanDataImpSchBO.Sch_Month_Day))
                    objDB.AddInParameter(objcmd, "@SCH_DAILY_STIME", DbType.String, objScanDataImpSchBO.Sch_Daily_STime)
                    objDB.AddInParameter(objcmd, "@SCH_DAILY_ETIME", DbType.String, objScanDataImpSchBO.Sch_Daily_ETime)
                    objDB.AddInParameter(objcmd, "@SCH_WEEK_TIME", DbType.String, objScanDataImpSchBO.Sch_Week_Time)
                    objDB.AddInParameter(objcmd, "@SCH_MONTH_TIME", DbType.String, objScanDataImpSchBO.Sch_Month_Time)
                    objDB.AddInParameter(objcmd, "@FileLocation", DbType.String, objScanDataImpSchBO.FileLocation)
                    objDB.AddInParameter(objcmd, "@Description", DbType.String, objScanDataImpSchBO.Import_Description)
                    objDB.AddInParameter(objcmd, "@IMPORTNAME", DbType.String, objScanDataImpSchBO.Import_Name)
                    objDB.AddInParameter(objcmd, "@DTE_From", DbType.DateTime, objScanDataImpSchBO.Dte_From)
                    objDB.AddInParameter(objcmd, "@CREATED_BY", DbType.String, HttpContext.Current.Session("UserID"))
                    objDB.AddOutParameter(objcmd, "@OV_RETVALUE", DbType.Int32, 10)
                    objDB.AddOutParameter(objcmd, "@ConfigID", DbType.Int32, 10)
                    objDB.ExecuteNonQuery(objcmd)
                    strResult = objDB.GetParameterValue(objcmd, "@OV_RETVALUE").ToString
                End Using
            Catch ex As Exception
                Throw ex
            End Try
            Return strResult
        End Function
        Public Function UpdateScanDataImpScheduler(ByVal objScanDataImpSchBO As ScanDataImportSchedulerBO) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_MODIFY_SCAN_CONFIG_Schedule")
                    objDB.AddInParameter(objcmd, "@Sch_Id", DbType.String, objScanDataImpSchBO.Sch_Id)
                    objDB.AddInParameter(objcmd, "@SCH_BASIS", DbType.String, objScanDataImpSchBO.Sch_Basis)
                    objDB.AddInParameter(objcmd, "@SCH_TIMEFORMAT", DbType.String, objScanDataImpSchBO.Sch_TimeFormat)
                    objDB.AddInParameter(objcmd, "@SCH_DAILY_INTERVAL_MINS", DbType.Int32, Convert.ToInt32(objScanDataImpSchBO.Sch_Daily_Interval_mins))
                    objDB.AddInParameter(objcmd, "@SCH_WEEK_DAY", DbType.Int32, Convert.ToInt32(objScanDataImpSchBO.Sch_Week_Day))
                    objDB.AddInParameter(objcmd, "@SCH_MONTH_DAY", DbType.Int32, Convert.ToInt32(objScanDataImpSchBO.Sch_Month_Day))
                    objDB.AddInParameter(objcmd, "@SCH_DAILY_STIME", DbType.String, objScanDataImpSchBO.Sch_Daily_STime)
                    objDB.AddInParameter(objcmd, "@SCH_DAILY_ETIME", DbType.String, objScanDataImpSchBO.Sch_Daily_ETime)
                    objDB.AddInParameter(objcmd, "@SCH_WEEK_TIME", DbType.String, objScanDataImpSchBO.Sch_Week_Time)
                    objDB.AddInParameter(objcmd, "@SCH_MONTH_TIME", DbType.String, objScanDataImpSchBO.Sch_Month_Time)
                    objDB.AddInParameter(objcmd, "@FileLocation", DbType.String, objScanDataImpSchBO.FileLocation)
                    objDB.AddInParameter(objcmd, "@Description", DbType.String, objScanDataImpSchBO.Import_Description)
                    objDB.AddInParameter(objcmd, "@IMPORTNAME", DbType.String, objScanDataImpSchBO.Import_Name)
                    objDB.AddInParameter(objcmd, "@DTE_From", DbType.DateTime, objScanDataImpSchBO.Dte_From)
                    objDB.AddInParameter(objcmd, "@ModifyBy", DbType.String, HttpContext.Current.Session("UserID"))
                    objDB.AddOutParameter(objcmd, "@OV_RETVALUE", DbType.String, 20)
                    objDB.AddOutParameter(objcmd, "@ConfigID", DbType.Int32, 10)
                    objDB.ExecuteNonQuery(objcmd)
                    strResult = objDB.GetParameterValue(objcmd, "@OV_RETVALUE").ToString
                End Using
            Catch ex As Exception
                Throw ex
            End Try
            Return strResult
        End Function

        Public Function DeleteScanDataImpScheduler(ByVal schId As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_DELETE_SCAN_CONFIG_SCHEDULE")
                    objDB.AddInParameter(objcmd, "@Sch_Id", DbType.Int32, Convert.ToInt32(schId.ToString()))
                    objDB.AddOutParameter(objcmd, "@OV_RETVALUE", DbType.String, 20)
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


