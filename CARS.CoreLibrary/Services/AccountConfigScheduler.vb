Imports System
Imports System.Data.SqlClient
Imports System.Data
Imports System.IO
Imports System.Resources
Imports System.Reflection
Imports CARS.CoreLibrary.CARS
Imports System.Web
Imports Encryption
Imports System.Configuration
Imports MSGCOMMON
Imports System.Web.Security
Namespace CARS.Services.AccountConfigScheduler
    Public Class AccountConfigScheduler
        Shared objAccntConfigSchedulerBO As New AccountConfigSchedulerBO
        Shared objAccntConfigSchedulerDO As New CARS.AccountConfigSchedulerDO.AccountConfigSchedulerDO
        Shared objCommonUtil As New CARS.Utilities.CommonUtility
        Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr

        Public Function FetchAccountConfigScheduler() As Collection
            Dim dsAccntConfigScheduler As New DataSet
            Dim dtAccntConfigScheduler As New DataTable
            Dim dtAccntConfigSchedulerColl As New Collection
            Try
                dsAccntConfigScheduler = objAccntConfigSchedulerDO.FetchAccntConfigSchedule()
                HttpContext.Current.Session("AccountConfigScheduler") = dsAccntConfigScheduler
                If dsAccntConfigScheduler.Tables.Count > 0 Then
                    If (dsAccntConfigScheduler.Tables(0).Rows.Count > 0) Then
                        dtAccntConfigScheduler = dsAccntConfigScheduler.Tables(0)
                        Dim details As New List(Of AccountConfigSchedulerBO)()
                        For Each dtrow As DataRow In dtAccntConfigScheduler.Rows
                            Dim configSchedulerDet As New AccountConfigSchedulerBO()
                            configSchedulerDet.Balance_FileLocation = dtrow("Balance_FileLocation").ToString()
                            configSchedulerDet.Balance_File_Name = dtrow("Balance_FileName").ToString()
                            configSchedulerDet.Balance_ArchiveDays = dtrow("Balance_ArchiveDays").ToString()
                            configSchedulerDet.Balance_Sch_Basis = dtrow("Balance_Sch_Basis").ToString()
                            configSchedulerDet.Balance_Sch_TimeFormat = dtrow("Balance_TimeFormat").ToString()
                            configSchedulerDet.Balance_Sch_Daily_Interval_mins = dtrow("Balance_Sch_Daily_Interval_mins").ToString()
                            configSchedulerDet.Balance_Sch_Week_Day = dtrow("Balance_Sch_Week_Day").ToString()
                            configSchedulerDet.Balance_Sch_Month_Day = dtrow("Balance_Sch_Month_Day").ToString()
                            configSchedulerDet.Balance_Sch_Daily_STime = dtrow("Balance_Sch_Daily_STime").ToString()
                            configSchedulerDet.Balance_Sch_Daily_ETime = dtrow("Balance_Sch_Daily_ETime").ToString()
                            configSchedulerDet.Balance_Sch_Week_Time = dtrow("Balance_Sch_Week_Time").ToString()
                            configSchedulerDet.Balance_Sch_Month_Time = dtrow("Balance_Sch_Month_Time").ToString()
                            configSchedulerDet.Customer_FileLocation = dtrow("Customer_FileLocation").ToString()
                            configSchedulerDet.Customer_File_Name = dtrow("Customer_FileName").ToString()
                            configSchedulerDet.Customer_Sch_Basis = dtrow("Customer_Sch_Basis").ToString()
                            configSchedulerDet.Customer_Sch_TimeFormat = dtrow("Customer_TimeFormat").ToString()
                            configSchedulerDet.Customer_Sch_Daily_Interval_mins = dtrow("Customer_Sch_Daily_Interval_mins").ToString()
                            configSchedulerDet.Customer_Sch_Week_Day = dtrow("Customer_Sch_Week_Day").ToString()
                            configSchedulerDet.Customer_Sch_Month_Day = dtrow("Customer_Sch_Month_Day").ToString()
                            configSchedulerDet.Customer_Sch_Daily_STime = dtrow("Customer_Sch_Daily_STime").ToString()
                            configSchedulerDet.Customer_Sch_Daily_ETime = dtrow("Customer_Sch_Daily_ETime").ToString()
                            configSchedulerDet.Customer_Sch_Week_Time = IIf(IsDBNull(dtrow("Customer_Sch_Week_Time").ToString()) = True, "", dtrow("Customer_Sch_Week_Time").ToString())
                            configSchedulerDet.Customer_Sch_Month_Time = IIf(IsDBNull(dtrow("Customer_Sch_Month_Time").ToString()) = True, "", dtrow("Customer_Sch_Month_Time").ToString())
                            configSchedulerDet.Balance_Template = dtrow("Balance_Template").ToString()
                            configSchedulerDet.Customer_Template = dtrow("Customer_Template").ToString()
                            details.Add(configSchedulerDet)
                        Next
                        dtAccntConfigSchedulerColl.Add(details)
                    ElseIf (dsAccntConfigScheduler.Tables(0).Rows.Count = 0) Then
                        dtAccntConfigScheduler = dsAccntConfigScheduler.Tables(0)
                        Dim details As New List(Of AccountConfigSchedulerBO)()
                        dtAccntConfigSchedulerColl.Add(details)
                    End If

                    'Balance Import Type
                    If (dsAccntConfigScheduler.Tables(1).Rows.Count > 0) Then
                        dtAccntConfigScheduler = dsAccntConfigScheduler.Tables(1)
                        Dim details As New List(Of AccountConfigSchedulerBO)()
                        For Each dtrow As DataRow In dtAccntConfigScheduler.Rows
                            Dim configSchedulerDet As New AccountConfigSchedulerBO()
                            configSchedulerDet.Template_Id = dtrow("Template_Id").ToString()
                            configSchedulerDet.Template_Name = dtrow("Template_Name").ToString()
                            details.Add(configSchedulerDet)
                        Next
                        dtAccntConfigSchedulerColl.Add(details)
                    ElseIf (dsAccntConfigScheduler.Tables(1).Rows.Count = 0) Then
                        dtAccntConfigScheduler = dsAccntConfigScheduler.Tables(1)
                        Dim details As New List(Of AccountConfigSchedulerBO)()
                        dtAccntConfigSchedulerColl.Add(details)
                    End If

                    'Customer Import Type
                    If (dsAccntConfigScheduler.Tables(2).Rows.Count > 0) Then
                        dtAccntConfigScheduler = dsAccntConfigScheduler.Tables(2)
                        Dim details As New List(Of AccountConfigSchedulerBO)()
                        For Each dtrow As DataRow In dtAccntConfigScheduler.Rows
                            Dim configSchedulerDet As New AccountConfigSchedulerBO()
                            configSchedulerDet.Template_Id = dtrow("Template_Id").ToString()
                            configSchedulerDet.Template_Name = dtrow("Template_Name").ToString()
                            details.Add(configSchedulerDet)
                        Next
                        dtAccntConfigSchedulerColl.Add(details)
                    ElseIf (dsAccntConfigScheduler.Tables(2).Rows.Count = 0) Then
                        dtAccntConfigScheduler = dsAccntConfigScheduler.Tables(2)
                        Dim details As New List(Of AccountConfigSchedulerBO)()
                        dtAccntConfigSchedulerColl.Add(details)
                    End If

                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.AccountConfigScheduler", "FetchAccountConfigScheduler", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return dtAccntConfigSchedulerColl
        End Function

        Public Function SaveAccountConfigScheduler(ByVal objConfigSchedulerBO As AccountConfigSchedulerBO) As String()
            Dim strResult As String
            Dim strValue(1) As String
            Dim dsConfig As DataSet = HttpContext.Current.Session("AccountConfigScheduler")
            Try
                strResult = objAccntConfigSchedulerDO.SaveAccntConfigScheduler(objConfigSchedulerBO)
                If (strResult = "0") Then
                    strValue(0) = "0"
                    strValue(1) = objErrHandle.GetErrorDescParameter("SAVE")
                Else
                    strValue(0) = "1"
                    strValue(1) = objErrHandle.GetErrorDescParameter("ConfigStatus")
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.AccountConfigScheduler", "SaveAccountConfigScheduler", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strValue
        End Function

    End Class
End Namespace

