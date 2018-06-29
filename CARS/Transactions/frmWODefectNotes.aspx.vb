Imports System.Data
Imports Encryption
Imports MSGCOMMON
Imports System.Web.Services
Imports CARS.CoreLibrary.CARS
Imports CARS.CoreLibrary
Imports System.Web.UI
Imports System.Xml
Public Class frmWODefectNotes
    Inherits System.Web.UI.Page
    Dim screenName As String
    Dim blWOsearch As Boolean = False
    Shared objWOHeaderBO As New CARS.CoreLibrary.WOHeaderBO
    Shared objWOHeaderServ As New CARS.CoreLibrary.CARS.Services.WOHeader.WOHeader
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared details As New List(Of WOHeaderBO)()
    Shared loginName As String
    Shared objServCustomer As New Services.Customer.CustomerDetails
    Shared objServVehicle As New Services.Vehicle.VehicleDetails
    Shared dtCaption As DataTable
    Shared objCommonUtil As New Utilities.CommonUtility
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Session.Item("id") = Nothing
        Session("Mode") = Nothing
        If Session("UserID") Is Nothing Or Session("UserPageperDT") Is Nothing Then
            Response.Redirect("~/frmLogin.aspx")
        Else
            loginName = CType(Session("UserID"), String)

        End If
        screenName = IO.Path.GetFileName(Me.Request.PhysicalPath)
        dtCaption = DirectCast(Cache("Caption"), System.Data.DataTable)
        ' hdnSelect.Value = dtCaption.Select("TAG='select'")(0)(1)
    End Sub
    <WebMethod()> _
    Public Shared Function Fetch_DefectNotes(ByVal vehicleNo As String) As WOHeaderBO()
        Try
            objWOHeaderBO.Id_Veh_Seq_WO = vehicleNo
            details = objWOHeaderServ.Fetch_DefectNotesGrid(objWOHeaderBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "frmWODefectNotes", "Fetch_DefectNotes", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function SaveDefect(ByVal idVehicle As String, ByVal defectDesc As String, ByVal userId As String) As String
        Dim strRet As String
        Try
            objWOHeaderBO.Id_Veh_Seq_WO = idVehicle
            objWOHeaderBO.DefectDesc = defectDesc
            objWOHeaderBO.LoginId = userId
            strRet = objWOHeaderServ.SaveDefect(objWOHeaderBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "frmWODefectNotes", "SaveDefect", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strRet
    End Function
    <WebMethod()> _
    Public Shared Function CreateWO(ByVal DefectId As String, ByVal DefectNote As String) As String
        Dim strRet As String
        Try

            strRet = DefectId & ";" & DefectNote
            HttpContext.Current.Session("WODefectId") = strRet
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "frmWODefectNotes", "CreateWO", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strRet
    End Function
End Class