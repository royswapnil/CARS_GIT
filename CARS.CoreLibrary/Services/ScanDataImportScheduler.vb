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
Namespace CARS.Services.ScanDataImportScheduler
    Public Class ScanDataImportScheduler
        Shared objScanDataImpSchBO As New ScanDataImportSchedulerBO
        Shared objScanDataImpSchDO As New CARS.ScanDataImportSchedulerDO.ScanDataImportSchedulerDO
        Shared objCommonUtil As New CARS.Utilities.CommonUtility
        Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
        Public Function FetchAllScanDataScheduler() As List(Of ScanDataImportSchedulerBO)
            Dim details As New List(Of ScanDataImportSchedulerBO)()
            Dim dsScanDataImpSch As New DataSet
            Dim dtScanDataImpSch As New DataTable
            Try
                dsScanDataImpSch = objScanDataImpSchDO.FetchScanDataImpScheduler()
                If dsScanDataImpSch.Tables.Count > 0 Then
                    dtScanDataImpSch = dsScanDataImpSch.Tables(0)
                    For Each dtrow As DataRow In dtScanDataImpSch.Rows
                        Dim scanDataImpSchDet As New ScanDataImportSchedulerBO()
                        scanDataImpSchDet.Sch_Id = dtrow("Sch_Id").ToString()
                        scanDataImpSchDet.Import_Name = dtrow("Import_Name").ToString()
                        scanDataImpSchDet.FileLocation = dtrow("FileLocation").ToString()
                        scanDataImpSchDet.Sch_Basis = dtrow("Sch_Basis").ToString()
                        scanDataImpSchDet.Import_Description = dtrow("Import_Description").ToString()
                        scanDataImpSchDet.Sch_Base = dtrow("Schedule_Base").ToString()
                        details.Add(scanDataImpSchDet)
                    Next
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ScanDataImportScheduler", "FetchAllScanDataScheduler", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function GetScanDataScheduler(ByVal schId As String) As List(Of ScanDataImportSchedulerBO)
            Dim details As New List(Of ScanDataImportSchedulerBO)()
            Dim dsScanDataImpSch As New DataSet
            Dim dtScanDataImpSch As New DataTable
            Try
                dsScanDataImpSch = objScanDataImpSchDO.GetScanDataImpScheduler(schId)
                If dsScanDataImpSch.Tables.Count > 0 Then
                    dtScanDataImpSch = dsScanDataImpSch.Tables(0)
                    For Each dtrow As DataRow In dtScanDataImpSch.Rows
                        Dim scanDataImpSchDet As New ScanDataImportSchedulerBO()
                        scanDataImpSchDet.Sch_Id = dtrow("Sch_Id").ToString()
                        scanDataImpSchDet.Sch_Basis = dtrow("Sch_Basis").ToString()
                        scanDataImpSchDet.Sch_TimeFormat = IIf(IsDBNull(dtrow("Sch_TimeFormat")) = True, "", dtrow("Sch_TimeFormat"))
                        scanDataImpSchDet.Sch_Daily_Interval_mins = IIf(IsDBNull(dtrow("Sch_Daily_Interval_mins")) = True, "0", dtrow("Sch_Daily_Interval_mins"))
                        scanDataImpSchDet.Sch_Week_Day = IIf(IsDBNull(dtrow("Sch_Week_Day")) = True, "0", dtrow("Sch_Week_Day"))
                        scanDataImpSchDet.Sch_Month_Day = IIf(IsDBNull(dtrow("Sch_Month_Day")) = True, "0", dtrow("Sch_Month_Day"))
                        scanDataImpSchDet.Sch_Daily_STime = IIf(IsDBNull(dtrow("Sch_Daily_STime")) = True, "", dtrow("Sch_Daily_STime"))
                        scanDataImpSchDet.Sch_Daily_ETime = IIf(IsDBNull(dtrow("Sch_Daily_ETime")) = True, "", dtrow("Sch_Daily_ETime"))
                        scanDataImpSchDet.Sch_Week_Time = IIf(IsDBNull(dtrow("Sch_Week_Time")) = True, "", dtrow("Sch_Week_Time"))
                        scanDataImpSchDet.Sch_Month_Time = IIf(IsDBNull(dtrow("Sch_Month_Time")) = True, "", dtrow("Sch_Month_Time"))
                        scanDataImpSchDet.Import_Name = dtrow("Import_Name").ToString()
                        scanDataImpSchDet.FileLocation = dtrow("FileLocation").ToString()
                        scanDataImpSchDet.Import_Description = dtrow("Import_Description").ToString()
                        'scanDataImpSchDet.Sch_Base = dtrow("Schedule_Base").ToString()
                        details.Add(scanDataImpSchDet)
                    Next
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ScanDataImportScheduler", "GetScanDataScheduler", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function SaveScanDataImpScheduler(ByVal objScanDataImpSchedulerBO As ScanDataImportSchedulerBO, ByVal mode As String) As String()
            Dim strResult As String
            Dim strValue(1) As String
            Dim dtDate As Date
            dtDate = [Date].Now()
            Dim dtTime As DateTime
            Dim dthour As Integer
            Dim dtMin As Integer
            Dim dteDate As DateTime = Now()

            Try
                If (objScanDataImpSchedulerBO.Sch_Basis = "D") Then

                    dtTime = CDate(objScanDataImpSchedulerBO.Sch_Daily_STime).ToString("HH:mm")
                    dthour = dtTime.Hour()
                    dtMin = dtTime.Minute()
                    dteDate = dtDate.Date.AddHours(dthour).AddMinutes(dtMin).AddSeconds(0)
                ElseIf (objScanDataImpSchedulerBO.Sch_Basis = "M") Then
                    Dim dtDay As Integer
                    dtDay = dtDate.Day()
                    Dim diff As Integer
                    If dtDay <= Convert.ToInt32(objScanDataImpSchedulerBO.Sch_Month_Day.ToString()) Then
                        diff = Convert.ToInt32(objScanDataImpSchedulerBO.Sch_Month_Day.ToString()) - dtDay
                        dtDate = dtDate.Date.AddDays(diff)
                    Else
                        diff = Convert.ToInt32(objScanDataImpSchedulerBO.Sch_Month_Day.ToString()) - dtDay
                        dtDate = dtDate.Date.AddDays(diff).AddMonths(1)
                    End If
                    dtTime = CDate(objScanDataImpSchedulerBO.Sch_Month_Time.ToString.Trim).ToString("HH:mm")
                    dthour = dtTime.Hour()
                    dtMin = dtTime.Minute()
                    dteDate = dtDate.Date.AddHours(dthour).AddMinutes(dtMin).AddSeconds(0)
                ElseIf (objScanDataImpSchedulerBO.Sch_Basis = "W") Then
                    dtTime = CDate(objScanDataImpSchedulerBO.Sch_Week_Time.ToString.Trim).ToString("HH:mm")
                    Dim dtDay As Integer
                    Dim diff As Integer
                    dtDay = Date.Now.DayOfWeek()
                    If (dtDay <= CInt(objScanDataImpSchedulerBO.Sch_Week_Day.ToString())) Then
                        diff = Convert.ToInt32(objScanDataImpSchedulerBO.Sch_Week_Day.ToString()) - dtDay
                        dtDate = dtDate.Date.AddDays(diff)
                    Else
                        diff = Convert.ToInt32(objScanDataImpSchedulerBO.Sch_Week_Day.ToString()) - dtDay
                        diff = 7 + diff
                        dtDate = dtDate.Date.AddDays(diff)
                    End If
                    dthour = dtTime.Hour()
                    dtMin = dtTime.Minute()
                    'dteDate = dtDate.Date.AddHours(dthour).AddMinutes(dtMin).AddSeconds(0)
                    dteDate = DateTime.Now.ToShortDateString
                End If

                objScanDataImpSchedulerBO.Dte_From = dteDate

                If (mode = "Add") Then
                    strResult = objScanDataImpSchDO.SaveScanDataImpScheduler(objScanDataImpSchedulerBO)
                Else
                    strResult = objScanDataImpSchDO.UpdateScanDataImpScheduler(objScanDataImpSchedulerBO)
                End If

                If (strResult = "0") Then
                    strValue(0) = "0"
                    strValue(1) = objErrHandle.GetErrorDescParameter("SAVED")
                Else
                    strValue(0) = "1"
                    strValue(1) = objErrHandle.GetErrorDescParameter("USEUPDT")
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ScanDataImportScheduler", "SaveScanDataImpScheduler", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strValue
        End Function
        Public Function DeleteScanDataImpScheduler(ByVal delschIds As String) As String()
            Dim strResult As String
            Dim strValue(1) As String
            Dim schIdArr As String()
            Try
                schIdArr = delschIds.Split(",")
                For i As Integer = 0 To schIdArr.Length
                    strResult = objScanDataImpSchDO.DeleteScanDataImpScheduler(schIdArr(i))
                    If (strResult = "0") Then
                        strValue(0) = "0"
                        strValue(1) = objErrHandle.GetErrorDescParameter("DDEL")
                    Else
                        strValue(0) = "1"
                        strValue(1) = objErrHandle.GetErrorDescParameter("DDN")
                    End If
                Next

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.DeleteScanDataImpScheduler", "DeleteScanDataImpScheduler", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strValue
        End Function



    End Class

End Namespace
