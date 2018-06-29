Imports System.Data
Imports Encryption
Imports MSGCOMMON
Imports System.Web.Services
Imports CARS.CoreLibrary.CARS
Imports CARS.CoreLibrary
Imports System.Web.UI
Imports System.Xml
Public Class NonInvoiceOrder
    Inherits System.Web.UI.Page
    Dim screenName As String
    Shared objWOHeaderBO As New CARS.CoreLibrary.WOHeaderBO
    Shared objWOHeaderServ As New CARS.CoreLibrary.CARS.Services.WOHeader.WOHeader
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared details As New List(Of WOHeaderBO)()
    Shared loginName As String
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
        If IsPostBack = False Then
            dtCaption = DirectCast(Cache("Caption"), System.Data.DataTable)
        End If
    End Sub
    <WebMethod()> _
    Public Shared Function LoadNonInvoiceOrderDet(ByVal idCust As String, ByVal idUser As String) As WOHeaderBO()
        Try
            objWOHeaderBO.Id_Cust_Wo = idCust
            objWOHeaderBO.Created_By = idUser
            objWOHeaderBO.PageIndex = 1
            objWOHeaderBO.PageSize = System.Configuration.ConfigurationManager.AppSettings("PageSize").ToString()
            details = objWOHeaderServ.Fetch_NonInvoiced_Orders(objWOHeaderBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_NonInvoiceOrder", "LoadNonInvoiceOrderDet", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
End Class