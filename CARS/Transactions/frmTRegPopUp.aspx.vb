Imports System.Web.Services
Imports CARS.CoreLibrary
Imports CARS.CoreLibrary.CARS
Imports System.Web.Security
Imports System.Web.UI
Imports Encryption
Imports System.Math
Imports Newtonsoft.Json
Imports System.Reflection
Public Class frmTRegPopUp
    Inherits System.Web.UI.Page
    Shared commonUtil As New Utilities.CommonUtility
    Shared loginName As String
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared dtCaption As DataTable
    Shared objTimeRegDO As New CARS.CoreLibrary.CARS.TimeRegDetail.TimeRegDetailDO
    Shared objTimeRegServ As New CARS.CoreLibrary.CARS.Services.TimeRegDetail.TimeRegDet
    Shared objTimeRegBO As New TimeRegDetBO
    Shared details As New List(Of TimeRegDetBO)()
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim strscreenName As String
        If Session("UserID") Is Nothing Or Session("UserPageperDT") Is Nothing Then
            Response.Redirect("~/frmLogin.aspx")
        Else
            loginName = CType(Session("UserID"), String)
        End If
        strscreenName = IO.Path.GetFileName(Me.Request.PhysicalPath)
        dtCaption = DirectCast(Cache("Caption"), System.Data.DataTable)
        hdnSelect.Value = dtCaption.Select("TAG='select'")(0)(1)
    End Sub
    <WebMethod()> _
    Public Shared Function FetchInvoiceTime(ByVal ordNo As String, ByVal idWoLabSeq As String) As TimeRegDetBO()
        Try
            details = objTimeRegServ.FetchInvoiceTime(ordNo, idWoLabSeq)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transaction_TRegPopUp", "FetchInvoiceTime", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function FetchClktime(ByVal clockIn As String, ByVal clockOut As String) As TimeRegDetBO()
        Try
            details = objTimeRegServ.FetchClockTime(clockIn, clockOut)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transaction_TRegPopUp", "FetchClktime", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function Add_ManualTRDet(ByVal mechId As String, ByVal ordNo As String, ByVal jobNo As String, ByVal dtClockin As String, ByVal timeClockin As String, ByVal dtClockout As String, ByVal timeClockout As String, ByVal idWoLabSeq As String, ByVal unsoldTime As String) As String
        Dim strResult As String = String.Empty
        Dim unsoldTimeText As String = String.Empty
        Dim UTime As Array
        Try
            If unsoldTime = "0" And ordNo = "" Then
                unsoldTimeText = objTimeRegServ.FetchDefUnsoldTime()
                UTime = unsoldTimeText.ToString.Split(";")
                unsoldTime = UTime(1)
            End If
            'dtClockin = commonUtil.GetDefaultDate_MMDDYYYY(dtClockin)
            'dtClockout = commonUtil.GetDefaultDate_MMDDYYYY(dtClockout)
            strResult = objTimeRegServ.Add_ManualTimeRegDet(mechId, ordNo, jobNo, dtClockin, timeClockin, dtClockout, timeClockout, idWoLabSeq, unsoldTime)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transaction_TRegPopUp", "Add_ManualTRDet", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function

End Class