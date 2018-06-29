Imports System.Web.Services
Imports CARS.CoreLibrary
Imports CARS.CoreLibrary.CARS
Imports System.Web.Security
Imports System.Web.UI
Imports Encryption
Public Class ScanDataImportScheduler
    Inherits System.Web.UI.Page
    Shared commonUtil As New Utilities.CommonUtility
    Shared dtCaption As DataTable
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared objScanDataImpSchedulerBO As New ScanDataImportSchedulerBO
    Shared objScanDataImpSchedulerServ As New Services.ScanDataImportScheduler.ScanDataImportScheduler
    Shared details As New List(Of ScanDataImportSchedulerBO)()
    Shared configdetails As New List(Of ScanDataImportSchedulerBO)()
    Shared loginName As String
    Dim objuserper As New UserAccessPermissionsBO
    Shared strscreenName As String = ""
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            If Session("UserID") Is Nothing Or Session("UserPageperDT") Is Nothing Then
                Response.Redirect("~/frmLogin.aspx")
            Else
                LoginName = CType(Session("UserID"), String)
            End If
            dtCaption = DirectCast(Cache("Caption"), System.Data.DataTable)
            hdnSelect.Value = dtCaption.Select("TAG='select'")(0)(1)
            hdnPageSize.Value = System.Configuration.ConfigurationManager.AppSettings("PageSize")
            strscreenName = IO.Path.GetFileName(Me.Request.PhysicalPath)
            Dim i As Integer
            ddlWeeklyEvery.Items.Clear()
            For i = 1 To 7
                ddlWeeklyEvery.Items.Add(WeekdayName(i))
            Next
            ddlMonthly.Items.Clear()
            For i = 1 To 31
                ddlMonthly.Items.Add(i)
            Next
            commonUtil.ddlGetValue(IO.Path.GetFileName(Me.Request.PhysicalPath), drpdailyHM)

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_ScanDataImportScheduler", "Page_Load", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub
    <WebMethod()> _
    Public Shared Function LoadScanDataImpSch() As ScanDataImportSchedulerBO()
        Try
            details = objScanDataImpSchedulerServ.FetchAllScanDataScheduler()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_ScanDataImportScheduler", "LoadScanDataImpSch", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function FetchScheduleDetails(ByVal schId As String) As ScanDataImportSchedulerBO()
        Try
            details = objScanDataImpSchedulerServ.GetScanDataScheduler(schId)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_ScanDataImportScheduler", "FetchScheduleDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function

    <WebMethod()> _
    Public Shared Function SaveScanDataImpScheduler(ByVal fileLocation As String, ByVal importName As String, ByVal description As String, ByVal schBasis As String, ByVal schDailyTimeFormat As String, ByVal schDailyIntMins As String, ByVal schDailyStTime As String, ByVal schDailyEndTime As String, ByVal schWeekDay As String, ByVal schWeekTime As String, ByVal schMonthDay As String, ByVal schMonthTime As String, ByVal schId As String, ByVal mode As String) As String()
        Dim strResult(1) As String
        Try
            fileLocation = fileLocation.Replace("/", "\")
            objScanDataImpSchedulerBO.FileLocation = fileLocation
            objScanDataImpSchedulerBO.Import_Name = importName
            objScanDataImpSchedulerBO.Import_Description = description
            objScanDataImpSchedulerBO.Sch_Basis = schBasis
            objScanDataImpSchedulerBO.Sch_TimeFormat = schDailyTimeFormat
            objScanDataImpSchedulerBO.Sch_Daily_Interval_mins = schDailyIntMins
            objScanDataImpSchedulerBO.Sch_Week_Day = schWeekDay
            objScanDataImpSchedulerBO.Sch_Month_Day = schMonthDay
            objScanDataImpSchedulerBO.Sch_Daily_STime = schDailyStTime
            objScanDataImpSchedulerBO.Sch_Daily_ETime = schDailyEndTime
            objScanDataImpSchedulerBO.Sch_Week_Time = schWeekTime
            objScanDataImpSchedulerBO.Sch_Month_Time = schMonthTime
            objScanDataImpSchedulerBO.Sch_Id = schId

            strResult = objScanDataImpSchedulerServ.SaveScanDataImpScheduler(objScanDataImpSchedulerBO, mode)

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_ScanDataImportScheduler", "SaveScanDataImpScheduler", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function

    <WebMethod()> _
    Public Shared Function DeleteScheduler(ByVal delschIds As String) As String()
        Dim strResult As String()
        Try
            strResult = objScanDataImpSchedulerServ.DeleteScanDataImpScheduler(delschIds)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_ScanDataImportScheduler", "DeleteScheduler", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function



End Class