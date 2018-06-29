Imports System.Web.Services
Imports CARS.CoreLibrary.CARS
Imports CARS.CoreLibrary
Imports System.Web.UI
Imports Newtonsoft.Json
Public Class frmInvPrint
    Inherits System.Web.UI.Page
    Shared objInvDetBO As New InvDetailBO
    Shared objInvDetDO As New InvDetailDO.InvDetailDO
    Shared objInvDetServ As New Services.InvDetail.InvDetail
    Shared loginName As String
    Shared commonUtil As New Utilities.CommonUtility
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared details As New List(Of InvDetailBO)()
    Shared dtCaption As DataTable
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Dim strscreenName As String
            If Session("UserID") Is Nothing Or Session("UserPageperDT") Is Nothing Then
                Response.Redirect("~/frmLogin.aspx")
            Else
                loginName = CType(Session("UserID"), String)
            End If
            strscreenName = IO.Path.GetFileName(Me.Request.PhysicalPath)
            dtCaption = DirectCast(Cache("Caption"), System.Data.DataTable)
            hdnPageSize.Value = System.Configuration.ConfigurationManager.AppSettings("PageSize")
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmInvPrint", "Page_Load", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub
    <WebMethod()> _
    Public Shared Function LoadInvoiceDetails(ByVal invoiceNo As String, ByVal fromDate As String, ByVal toDate As String, ByVal fromAmount As String, ByVal toAmount As String, ByVal debtor As String, _
     ByVal customer As String, ByVal orderNo As String, ByVal vehRegNo As String, ByVal flgBatchInv As String, ByVal invStatus As String, ByVal crOrder As String) As Collection
        Dim dtConfig As New Collection
        Dim searchBasedOnAmount As Boolean = False
        Dim searchBasedInvDate As Boolean = True
        Try

            fromDate = commonUtil.GetDefaultDate_MMDDYYYY(fromDate)
            toDate = commonUtil.GetDefaultDate_MMDDYYYY(toDate)
            dtConfig = objInvDetServ.FetchInvoices(invoiceNo, fromDate, toDate, fromAmount, toAmount, customer, debtor, vehRegNo, orderNo, invStatus, flgBatchInv, crOrder, searchBasedOnAmount, searchBasedInvDate)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmInvPrint", "LoadInvoiceDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return dtConfig
    End Function
    <WebMethod()> _
    Public Shared Function FetchOrderList(ByVal idInvNo As String) As InvDetailBO()
        Try
            details = objInvDetServ.FetchOrderList(idInvNo)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmInvPrint", "LoadWorkCode", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function CreateCreditNote(ByVal orders As String, ByVal regnDate As String) As String()
        Dim strRetVal As String()
        Try
            regnDate = commonUtil.GetDefaultDate_MMDDYYYY(regnDate)
            strRetVal = objInvDetServ.CreateCrNote(orders, regnDate)

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmInvPrint", "CreateCreditNote", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strRetVal
    End Function
    <WebMethod()> _
    Public Shared Function CreateCreditNoteOrders(ByVal woNo As String, ByVal woPr As String) As String
        Dim strRetVal As String
        Try
            strRetVal = objInvDetServ.CreateCrNoteOrders(woNo, woPr)

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmInvPrint", "CreateCreditNoteOrders", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strRetVal
    End Function
    <WebMethod()> _
    Public Shared Function CreateInv_CreditNoteOrders(ByVal id_inv_no As String) As String()
        Dim strRetVal As String()
        Try
            strRetVal = objInvDetServ.CreateInv_CreditNoteOrders(id_inv_no)

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmInvPrint", "CreateCreditNoteOrders", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strRetVal
    End Function

   
End Class