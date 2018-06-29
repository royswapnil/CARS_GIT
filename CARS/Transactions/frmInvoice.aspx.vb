Imports System.Data
Imports Encryption
Imports MSGCOMMON
Imports System.Web.Services
Imports CARS.CoreLibrary.CARS
Imports CARS.CoreLibrary
Imports System.Web.UI
Imports CARS.CoreLibrary.CARS.Services
Imports System.Reflection
Imports Newtonsoft.Json
Public Class frmInvoice
    Inherits System.Web.UI.Page
    Shared objInvDetService As New CARS.CoreLibrary.CARS.Services.InvDetail.InvDetail
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared commonUtil As New Utilities.CommonUtility
    Shared loginName As String
    Shared dtCaption As DataTable
    Shared objInvDetBO As New CARS.CoreLibrary.InvDetailBO
    Shared objInvDetDO As New CARS.CoreLibrary.CARS.InvDetailDO.InvDetailDO
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

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transaction_frmInvoice", "Page_Load", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub
    <WebMethod()> _
    Public Shared Function FetchOrdersToBeInvoiced(ByVal id_customer As String, ByVal id_veh_seq As String, ByVal id_wo_no As String, ByVal emailorders As String) As Collection
        Dim details As Collection
        Try
            id_customer = IIf(id_customer = "", Nothing, id_customer)
            id_veh_seq = IIf(id_veh_seq = "", "0", id_veh_seq)
            id_wo_no = IIf(id_wo_no = "", Nothing, id_wo_no)
            details = objInvDetService.FetchOrdersToBeInvoiced(loginName, id_customer, id_veh_seq, id_wo_no, System.Configuration.ConfigurationManager.AppSettings("Language"), emailorders)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transaction_frmInvoice", "FetchOrdersToBeInvoiced", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details
    End Function
    <WebMethod()> _
    Public Shared Function FetchChildOrdersToBeInvoiced(ByVal id_customer As String, ByVal id_veh_seq As String, ByVal id_wo_no As String, ByVal emailorders As String) As Collection
        Dim details As Collection
        Try
            id_customer = IIf(id_customer = "", Nothing, id_customer)
            id_veh_seq = IIf(id_veh_seq = "", "0", id_veh_seq)
            id_wo_no = IIf(id_wo_no = "", Nothing, id_wo_no)
            details = objInvDetService.FetchChildOrdersToBeInvoiced(loginName, id_customer, id_veh_seq, id_wo_no, System.Configuration.ConfigurationManager.AppSettings("Language"), emailorders)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transaction_frmInvoice", "FetchOrdersToBeInvoiced", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details
    End Function
    <WebMethod()> _
    Public Shared Function InvoiceProcess(ByVal orders As String) As String()
        Dim strRetVal As String()
        Try
            strRetVal = objInvDetService.InvoiceProcess(orders)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transaction_frmInvoice", "InvoiceProcess", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strRetVal
    End Function

End Class