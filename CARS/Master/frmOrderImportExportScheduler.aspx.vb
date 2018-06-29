Imports System.Web.Services
Imports CARS.CoreLibrary
Imports CARS.CoreLibrary.CARS
Imports System.Web.Security
Imports System.Web.UI
Imports Encryption
Public Class frmOrderImportExportScheduler
    Inherits System.Web.UI.Page
    Shared commonUtil As New Utilities.CommonUtility
    Shared dtCaption As DataTable
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared objOrdImpExpSchedulerBO As New OrderImportExportSchedulerBO
    Shared objOrdImpExpSchedulerServ As New Services.OrderImportExportScheduler.OrderImportExportScheduler
    Shared details As New List(Of OrderImportExportSchedulerBO)()
    Shared configdetails As New List(Of OrderImportExportSchedulerBO)()
    Shared loginName As String
    Dim objuserper As New UserAccessPermissionsBO
    Shared strscreenName As String = ""
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            If Session("UserID") Is Nothing Or Session("UserPageperDT") Is Nothing Then
                Response.Redirect("~/frmLogin.aspx")
            Else
                loginName = CType(Session("UserID"), String)
            End If
            dtCaption = DirectCast(Cache("Caption"), System.Data.DataTable)
            hdnSelect.Value = dtCaption.Select("TAG='select'")(0)(1)
            hdnPageSize.Value = System.Configuration.ConfigurationManager.AppSettings("PageSize")
            strscreenName = IO.Path.GetFileName(Me.Request.PhysicalPath)
            Dim i As Integer
            ddlOrdImpWeeklyEvery.Items.Clear()
            For i = 1 To 7
                ddlOrdImpWeeklyEvery.Items.Add(WeekdayName(i))
            Next
            ddlOrdImpMonthly.Items.Clear()
            For i = 1 To 31
                ddlOrdImpMonthly.Items.Add(i)
            Next

            ddlOrdExpWeeklyEvery.Items.Clear()
            For i = 1 To 7
                ddlOrdExpWeeklyEvery.Items.Add(WeekdayName(i))
            Next
            ddlOrdExpMonthly.Items.Clear()
            For i = 1 To 31
                ddlOrdExpMonthly.Items.Add(i)
            Next

            commonUtil.ddlGetValue(IO.Path.GetFileName(Me.Request.PhysicalPath), drpOrdImp_Everyhour)
            commonUtil.ddlGetValue(IO.Path.GetFileName(Me.Request.PhysicalPath), drpOrdExp_Everyhour)
            'SetPermission()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmOrderImportExportScheduler", "Page_Load", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub

    <WebMethod()> _
    Public Shared Function LoadImpExpScheduler() As Collection
        Dim details As New Collection
        Try
            details = objOrdImpExpSchedulerServ.FetchOrdImpExpConfigSchedule()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmOrderImportExportScheduler", "FetchOrdImpExpConfigSchedule", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details
    End Function
    <WebMethod()> _
    Public Shared Function SaveOrdImportScheduler(ByVal impFileLocation As String, ByVal impFileName As String, ByVal impImportType As String, ByVal schImpBasis As String, ByVal schImpDailyTimeFormat As String, ByVal schImpDailyIntMins As String, ByVal schImpDailyStTime As String, ByVal schImpDailyEndTime As String, ByVal schImpWeekDay As String, ByVal schImpWeekTime As String, ByVal schImpMonthDay As String, ByVal schImpMonthTime As String) As String()
        Dim strResult(1) As String
        Try
            impFileLocation = impFileLocation.Replace("/", "\")
            objOrdImpExpSchedulerBO.Import_FileLocation = impFileLocation
            objOrdImpExpSchedulerBO.Import_FileName = impFileName
            objOrdImpExpSchedulerBO.Import_Sch_Basis = schImpBasis
            objOrdImpExpSchedulerBO.Import_Sch_TimeFormat = schImpDailyTimeFormat
            objOrdImpExpSchedulerBO.Import_Sch_Daily_Interval_mins = schImpDailyIntMins
            objOrdImpExpSchedulerBO.Import_Sch_Week_Day = schImpWeekDay
            objOrdImpExpSchedulerBO.Import_Sch_Month_Day = schImpMonthDay
            objOrdImpExpSchedulerBO.Import_Sch_Daily_STime = schImpDailyStTime
            objOrdImpExpSchedulerBO.Import_Sch_Daily_ETime = schImpDailyEndTime
            objOrdImpExpSchedulerBO.Import_Sch_Week_Time = schImpWeekTime
            objOrdImpExpSchedulerBO.Import_Sch_Month_Time = schImpMonthTime
            objOrdImpExpSchedulerBO.Import_Template = impImportType

            Dim importFileLocation As String = String.Empty
            Dim arrayImpFileLocFolder As Array
            Dim importIndex As Int32 = 0
            importFileLocation = objOrdImpExpSchedulerBO.Import_FileLocation.Trim

            If Not importFileLocation Is String.Empty Then
                If importFileLocation.Substring(importFileLocation.Length - 1, 1) <> "\" Then
                    importFileLocation = importFileLocation + "\"
                End If
                arrayImpFileLocFolder = importFileLocation.Split("\")

                For importIndex = 0 To arrayImpFileLocFolder.Length - 2
                    If importIndex = 0 Then
                        Dim splChar As String = String.Empty
                        If importFileLocation.Length > 2 Then
                            splChar = importFileLocation.Substring(2, 1)
                        End If
                        If Not Regex.IsMatch(arrayImpFileLocFolder(importIndex) + splChar, "^([a-zA-Z]:\\)+") Then
                            strResult(0) = "InValid"
                            strResult(1) = ""
                            Return strResult
                        Else
                            strResult(0) = "Valid"
                            strResult(1) = ""
                        End If
                    Else
                        If Not Regex.IsMatch(arrayImpFileLocFolder(importIndex), "^[^\\\/\?\*\""\'\>\<\:\|]*$") Then
                            strResult(0) = "InValid"
                            strResult(1) = ""
                            Return strResult
                        ElseIf arrayImpFileLocFolder(importIndex) = "" Then
                            strResult(0) = "InValid"
                            strResult(1) = ""
                            Return strResult
                        Else
                            strResult(0) = "Valid"
                            strResult(1) = ""
                        End If
                    End If
                Next
            End If
            
            If (strResult(0) <> "InValid") Then
                strResult = objOrdImpExpSchedulerServ.SaveOrdImportScheduler(objOrdImpExpSchedulerBO)
            End If

            'strResult(0) = "0"
            'strResult(1) = ""


        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmAccountImportSchedular", "SaveOrdImpExpScheduler", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function

    <WebMethod()> _
    Public Shared Function SaveOrdExportScheduler(ByVal expFileLocation As String, ByVal expFileName As String, ByVal schExpBasis As String, ByVal schExpDailyTimeFormat As String, ByVal schExpDailyIntMins As String, ByVal schExpDailyStTime As String, ByVal schExpDailyEndTime As String, ByVal schExpWeekDay As String, ByVal schExpWeekTime As String, ByVal schExpMonthDay As String, ByVal schExpMonthTime As String) As String()
        Dim strResult(1) As String
        Try
            objOrdImpExpSchedulerBO.Export_FileLocation = expFileLocation.Replace("/", "\")
            objOrdImpExpSchedulerBO.Export_FileName = expFileName
            objOrdImpExpSchedulerBO.Export_Sch_Basis = schExpBasis
            objOrdImpExpSchedulerBO.Export_Sch_TimeFormat = schExpDailyTimeFormat
            objOrdImpExpSchedulerBO.Export_Sch_Daily_Interval_mins = schExpDailyIntMins
            objOrdImpExpSchedulerBO.Export_Sch_Week_Day = schExpWeekDay
            objOrdImpExpSchedulerBO.Export_Sch_Month_Day = schExpMonthDay
            objOrdImpExpSchedulerBO.Export_Sch_Daily_STime = schExpDailyStTime
            objOrdImpExpSchedulerBO.Export_Sch_Daily_ETime = schExpDailyEndTime
            objOrdImpExpSchedulerBO.Export_Sch_Week_Time = schExpWeekTime
            objOrdImpExpSchedulerBO.Export_Sch_Month_Time = schExpMonthTime

            Dim exportFilePath As String = String.Empty
            Dim arrayExportFolder As Array
            Dim exportIndex As Int32 = 0
            exportFilePath = objOrdImpExpSchedulerBO.Export_FileLocation.Trim

            If Not exportFilePath Is String.Empty Then
                If exportFilePath.Substring(exportFilePath.Length - 1, 1) <> "\" Then
                    exportFilePath = exportFilePath + "\"
                End If
                arrayExportFolder = exportFilePath.Split("\")

                For exportIndex = 0 To arrayExportFolder.Length - 2
                    If exportIndex = 0 Then
                        Dim splChar As String = String.Empty
                        If exportFilePath.Length > 2 Then
                            splChar = exportFilePath.Substring(2, 1)
                        End If
                        If Not Regex.IsMatch(arrayExportFolder(exportIndex) + splChar, "^([a-zA-Z]:\\)+") Then
                            strResult(0) = "InValid"
                            strResult(1) = ""
                            Return strResult
                        Else
                            strResult(0) = "Valid"
                            strResult(1) = ""
                        End If
                    Else
                        If Not Regex.IsMatch(arrayExportFolder(exportIndex), "^[^\\\/\?\*\""\'\>\<\:\|]*$") Then
                            strResult(0) = "InValid"
                            strResult(1) = ""
                            Return strResult
                        ElseIf arrayExportFolder(exportIndex) = "" Then
                            strResult(0) = "InValid"
                            strResult(1) = ""
                            Return strResult
                        Else
                            strResult(0) = "Valid"
                            strResult(1) = ""
                        End If
                    End If
                Next
            End If

            If (strResult(0) <> "InValid") Then
                strResult = objOrdImpExpSchedulerServ.SaveOrdExportScheduler(objOrdImpExpSchedulerBO)
            End If

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmAccountImportSchedular", "SaveOrdExportScheduler", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function




End Class