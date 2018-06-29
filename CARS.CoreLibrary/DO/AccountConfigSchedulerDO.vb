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
Namespace CARS.AccountConfigSchedulerDO
    Public Class AccountConfigSchedulerDO
        Dim ConnectionString As String
        Shared objCommonUtil As New CARS.Utilities.CommonUtility
        Dim objDB As Database
        Dim strStatus As String
        Shared objConfigLABO As New ConfigLABO
        Dim strResult As String
        Public Sub New()
            ConnectionString = System.Configuration.ConfigurationManager.AppSettings("MSGConstr")
            objDB = New SqlDatabase(ConnectionString)
        End Sub

        Public Function FetchAccntConfigSchedule() As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_ACCOUNT_CONFIG_SCHEDULE")
                    objDB.AddInParameter(objcmd, "@File_Type", DbType.String, "IMPORT")
                    objDB.AddInParameter(objcmd, "@Balance_File_Name", DbType.String, "CustomerBalanceImport.aspx")
                    objDB.AddInParameter(objcmd, "@Customer_File_Name", DbType.String, "CustomerImport.aspx")
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function

        Public Function SaveAccntConfigScheduler(ByVal objAccntConfigScheduler As AccountConfigSchedulerBO) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_INSERT_ACCOUNT_CONFIG_SCHEDULE")
                    objDB.AddInParameter(objcmd, "@Balance_FileLocation", DbType.String, objAccntConfigScheduler.Balance_FileLocation)
                    objDB.AddInParameter(objcmd, "@Balance_FileName", DbType.String, objAccntConfigScheduler.Balance_File_Name)
                    objDB.AddInParameter(objcmd, "@Balance_ArchiveDays", DbType.Int32, Convert.ToInt32(objAccntConfigScheduler.Balance_ArchiveDays))
                    objDB.AddInParameter(objcmd, "@Balance_Sch_Basis", DbType.String, objAccntConfigScheduler.Balance_Sch_Basis)
                    objDB.AddInParameter(objcmd, "@Balance_TimeFormat", DbType.String, objAccntConfigScheduler.Balance_Sch_TimeFormat)
                    objDB.AddInParameter(objcmd, "@Balance_Sch_Daily_Interval_mins", DbType.Int32, Convert.ToInt32(objAccntConfigScheduler.Balance_Sch_Daily_Interval_mins))
                    objDB.AddInParameter(objcmd, "@Balance_Sch_Week_Day", DbType.Int32, Convert.ToInt32(objAccntConfigScheduler.Balance_Sch_Week_Day))
                    objDB.AddInParameter(objcmd, "@Balance_Sch_Month_Day", DbType.Int32, Convert.ToInt32(objAccntConfigScheduler.Balance_Sch_Month_Day))
                    objDB.AddInParameter(objcmd, "@Balance_Sch_Daily_STime", DbType.String, objAccntConfigScheduler.Balance_Sch_Daily_STime)
                    objDB.AddInParameter(objcmd, "@Balance_Sch_Daily_ETime", DbType.String, objAccntConfigScheduler.Balance_Sch_Daily_ETime)
                    objDB.AddInParameter(objcmd, "@Balance_Sch_Week_Time", DbType.String, objAccntConfigScheduler.Balance_Sch_Week_Time)
                    objDB.AddInParameter(objcmd, "@Balance_Sch_Month_Time", DbType.String, objAccntConfigScheduler.Balance_Sch_Month_Time)
                    objDB.AddInParameter(objcmd, "@Customer_FileLocation", DbType.String, objAccntConfigScheduler.Customer_FileLocation)
                    objDB.AddInParameter(objcmd, "@Customer_FileName", DbType.String, objAccntConfigScheduler.Customer_File_Name)
                    objDB.AddInParameter(objcmd, "@Customer_Sch_Basis", DbType.String, objAccntConfigScheduler.Customer_Sch_Basis)
                    objDB.AddInParameter(objcmd, "@Customer_TimeFormat", DbType.String, objAccntConfigScheduler.Customer_Sch_TimeFormat)
                    objDB.AddInParameter(objcmd, "@Customer_Sch_Daily_Interval_mins", DbType.Int32, Convert.ToInt32(objAccntConfigScheduler.Customer_Sch_Daily_Interval_mins))
                    objDB.AddInParameter(objcmd, "@Customer_Sch_Week_Day", DbType.Int32, Convert.ToInt32(objAccntConfigScheduler.Customer_Sch_Week_Day))
                    objDB.AddInParameter(objcmd, "@Customer_Sch_Month_Day", DbType.Int32, Convert.ToInt32(objAccntConfigScheduler.Customer_Sch_Month_Day))
                    objDB.AddInParameter(objcmd, "@Customer_Sch_Daily_STime", DbType.String, objAccntConfigScheduler.Customer_Sch_Daily_STime)
                    objDB.AddInParameter(objcmd, "@Customer_Sch_Daily_ETime", DbType.String, objAccntConfigScheduler.Customer_Sch_Daily_ETime)
                    objDB.AddInParameter(objcmd, "@Customer_Sch_Week_Time", DbType.String, objAccntConfigScheduler.Customer_Sch_Week_Time)
                    objDB.AddInParameter(objcmd, "@Customer_Sch_Month_Time", DbType.String, objAccntConfigScheduler.Customer_Sch_Month_Time)
                    objDB.AddInParameter(objcmd, "@Balance_Template", DbType.String, objAccntConfigScheduler.Balance_Template)
                    objDB.AddInParameter(objcmd, "@Customer_Template", DbType.String, objAccntConfigScheduler.Customer_Template)
                    objDB.AddInParameter(objcmd, "@CREATED_BY", DbType.String, HttpContext.Current.Session("UserID"))
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

