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
Namespace CARS.Services.OrderImportExportScheduler
    Public Class OrderImportExportScheduler
        Shared objOrdImpExpSchedulerBO As New OrderImportExportSchedulerBO
        Shared objOrdImpExpSchedulerDO As New CARS.OrderImportExportSchedulerDO.OrderImportExportSchedulerDO
        Shared objCommonUtil As New CARS.Utilities.CommonUtility
        Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
        Public Function FetchOrdImpExpConfigSchedule() As Collection
            Dim dsOrdImpExpScheduler As New DataSet
            Dim dtOrdImpExpScheduler As New DataTable
            Dim dtOrdImpExpSchedulerColl As New Collection
            Try
                dsOrdImpExpScheduler = objOrdImpExpSchedulerDO.FetchOrdImpExpConfigSchedule()
                HttpContext.Current.Session("OrderImportExportScheduler") = dsOrdImpExpScheduler
                If dsOrdImpExpScheduler.Tables.Count > 0 Then
                    If (dsOrdImpExpScheduler.Tables(0).Rows.Count > 0) Then
                        dtOrdImpExpScheduler = dsOrdImpExpScheduler.Tables(0)
                        Dim details As New List(Of OrderImportExportSchedulerBO)()
                        For Each dtrow As DataRow In dtOrdImpExpScheduler.Rows
                            Dim ordImportSchDet As New OrderImportExportSchedulerBO()
                            ordImportSchDet.Order_Imp_Sch_Id = dtrow("Ord_Imp_Sch_Id").ToString()
                            ordImportSchDet.Import_FileLocation = dtrow("Ord_Imp_FileLocation").ToString()
                            ordImportSchDet.Import_FileName = dtrow("Ord_Imp_FileName").ToString()
                            ordImportSchDet.Import_Sch_Basis = dtrow("Ord_Imp_Sch_Basis").ToString()
                            ordImportSchDet.Import_Sch_TimeFormat = dtrow("Ord_Imp_TimeFormat").ToString()
                            ordImportSchDet.Import_Sch_Daily_Interval_mins = dtrow("Ord_Imp_Sch_Daily_Interval_mins").ToString()
                            ordImportSchDet.Import_Sch_Week_Day = dtrow("Ord_Imp_Sch_Week_Day").ToString()
                            ordImportSchDet.Import_Sch_Month_Day = dtrow("Ord_Imp_Sch_Month_Day").ToString()
                            ordImportSchDet.Import_Sch_Daily_STime = IIf(IsDBNull(dtrow("Ord_Imp_Sch_Daily_STime")) = True, "", dtrow("Ord_Imp_Sch_Daily_STime").ToString())
                            ordImportSchDet.Import_Sch_Daily_ETime = IIf(IsDBNull(dtrow("Ord_Imp_Sch_Daily_ETime")) = True, "", dtrow("Ord_Imp_Sch_Daily_ETime").ToString())
                            ordImportSchDet.Import_Sch_Week_Time = IIf(IsDBNull(dtrow("Ord_Imp_Sch_Week_Time")) = True, "", dtrow("Ord_Imp_Sch_Week_Time").ToString())
                            ordImportSchDet.Import_Sch_Month_Time = IIf(IsDBNull(dtrow("Ord_Imp_Sch_Month_Time")) = True, "", dtrow("Ord_Imp_Sch_Month_Time").ToString())
                            ordImportSchDet.Import_Template = dtrow("Ord_Imp_Template").ToString()

                            details.Add(ordImportSchDet)
                        Next
                        dtOrdImpExpSchedulerColl.Add(details)
                    ElseIf (dsOrdImpExpScheduler.Tables(0).Rows.Count = 0) Then
                        dtOrdImpExpScheduler = dsOrdImpExpScheduler.Tables(0)
                        Dim details As New List(Of OrderImportExportSchedulerBO)()
                        dtOrdImpExpSchedulerColl.Add(details)
                    End If

                    If (dsOrdImpExpScheduler.Tables(1).Rows.Count > 0) Then
                        dtOrdImpExpScheduler = dsOrdImpExpScheduler.Tables(1)
                        Dim details As New List(Of OrderImportExportSchedulerBO)()
                        For Each dtrow As DataRow In dtOrdImpExpScheduler.Rows
                            Dim ordExportSchDet As New OrderImportExportSchedulerBO()
                            ordExportSchDet.Order_Exp_Sch_Id = dtrow("Ord_Exp_Sch_Id").ToString()
                            ordExportSchDet.Export_FileLocation = dtrow("Ord_Exp_FileLocation").ToString()
                            ordExportSchDet.Export_FileName = dtrow("Ord_Exp_FileName").ToString()
                            ordExportSchDet.Export_Sch_Basis = dtrow("Ord_Exp_Sch_Basis").ToString()
                            ordExportSchDet.Export_Sch_TimeFormat = dtrow("Ord_Exp_TimeFormat").ToString()
                            ordExportSchDet.Export_Sch_Daily_Interval_mins = dtrow("Ord_Exp_Sch_Daily_Interval_mins").ToString()
                            ordExportSchDet.Export_Sch_Week_Day = dtrow("Ord_Exp_Sch_Week_Day").ToString()
                            ordExportSchDet.Export_Sch_Month_Day = dtrow("Ord_Exp_Sch_Month_Day").ToString()
                            ordExportSchDet.Export_Sch_Daily_STime = IIf(IsDBNull(dtrow("Ord_Exp_Sch_Daily_STime")) = True, "", dtrow("Ord_Exp_Sch_Daily_STime").ToString())
                            ordExportSchDet.Export_Sch_Daily_ETime = IIf(IsDBNull(dtrow("Ord_Exp_Sch_Daily_ETime")) = True, "", dtrow("Ord_Exp_Sch_Daily_ETime").ToString())
                            ordExportSchDet.Export_Sch_Week_Time = IIf(IsDBNull(dtrow("Ord_Exp_Sch_Week_Time")) = True, "", dtrow("Ord_Exp_Sch_Week_Time").ToString())
                            ordExportSchDet.Export_Sch_Month_Time = IIf(IsDBNull(dtrow("Ord_Exp_Sch_Month_Time")) = True, "", dtrow("Ord_Exp_Sch_Month_Time").ToString())

                            details.Add(ordExportSchDet)
                        Next
                        dtOrdImpExpSchedulerColl.Add(details)
                    ElseIf (dsOrdImpExpScheduler.Tables(1).Rows.Count = 0) Then
                        dtOrdImpExpScheduler = dsOrdImpExpScheduler.Tables(1)
                        Dim details As New List(Of OrderImportExportSchedulerBO)()
                        dtOrdImpExpSchedulerColl.Add(details)
                    End If

                    'Order Import Type
                    If (dsOrdImpExpScheduler.Tables(2).Rows.Count > 0) Then
                        dtOrdImpExpScheduler = dsOrdImpExpScheduler.Tables(2)
                        Dim details As New List(Of OrderImportExportSchedulerBO)()
                        For Each dtrow As DataRow In dtOrdImpExpScheduler.Rows
                            Dim configSchedulerDet As New OrderImportExportSchedulerBO()
                            configSchedulerDet.Template_Id = dtrow("Template_Id").ToString()
                            configSchedulerDet.Template_Name = dtrow("Template_Name").ToString()
                            details.Add(configSchedulerDet)
                        Next
                        dtOrdImpExpSchedulerColl.Add(details)
                    ElseIf (dsOrdImpExpScheduler.Tables(2).Rows.Count = 0) Then
                        dtOrdImpExpScheduler = dsOrdImpExpScheduler.Tables(2)
                        Dim details As New List(Of OrderImportExportSchedulerBO)()
                        dtOrdImpExpSchedulerColl.Add(details)
                    End If

                    'Order Export Type
                    If (dsOrdImpExpScheduler.Tables(3).Rows.Count > 0) Then
                        dtOrdImpExpScheduler = dsOrdImpExpScheduler.Tables(3)
                        Dim details As New List(Of OrderImportExportSchedulerBO)()
                        For Each dtrow As DataRow In dtOrdImpExpScheduler.Rows
                            Dim configSchedulerDet As New OrderImportExportSchedulerBO()
                            configSchedulerDet.Template_Id = dtrow("Template_Id").ToString()
                            configSchedulerDet.Template_Name = dtrow("Template_Name").ToString()
                            details.Add(configSchedulerDet)
                        Next
                        dtOrdImpExpSchedulerColl.Add(details)
                    ElseIf (dsOrdImpExpScheduler.Tables(3).Rows.Count = 0) Then
                        dtOrdImpExpScheduler = dsOrdImpExpScheduler.Tables(3)
                        Dim details As New List(Of OrderImportExportSchedulerBO)()
                        dtOrdImpExpSchedulerColl.Add(details)
                    End If

                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.OrderImportExportScheduler", "FetchOrdImpExpConfigSchedule", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return dtOrdImpExpSchedulerColl
        End Function
        Public Function SaveOrdImportScheduler(ByVal objOrdImpExpSchBO As OrderImportExportSchedulerBO) As String()
            Dim strResult As String
            Dim strValue(1) As String
            Try
                strResult = objOrdImpExpSchedulerDO.SaveOrdImportConfigSchedule(objOrdImpExpSchBO)
                If (strResult = "0") Then
                    strValue(0) = "0"
                    strValue(1) = objErrHandle.GetErrorDescParameter("SAVE")
                Else
                    strValue(0) = "1"
                    strValue(1) = objErrHandle.GetErrorDescParameter("ConfigStatus")
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.AccountConfigScheduler", "SaveOrdImportScheduler", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strValue
        End Function
        Public Function SaveOrdExportScheduler(ByVal objOrdImpExpSchBO As OrderImportExportSchedulerBO) As String()
            Dim strResult As String
            Dim strValue(1) As String
            Try
                strResult = objOrdImpExpSchedulerDO.SaveOrdExportConfigSchedule(objOrdImpExpSchBO)
                If (strResult = "0") Then
                    strValue(0) = "0"
                    strValue(1) = objErrHandle.GetErrorDescParameter("SAVE")
                Else
                    strValue(0) = "1"
                    strValue(1) = objErrHandle.GetErrorDescParameter("ConfigStatus")
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.AccountConfigScheduler", "SaveOrdExportScheduler", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strValue
        End Function

    End Class
End Namespace

