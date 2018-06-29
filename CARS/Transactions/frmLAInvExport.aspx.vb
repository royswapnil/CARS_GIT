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

Public Class frmLAInvExport
    Inherits System.Web.UI.Page
    Shared objLAService As New CARS.CoreLibrary.CARS.Services.LinkToAccounting.LinkToAccounting
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared commonUtil As New Utilities.CommonUtility
    Shared loginName As String
    Shared dtCaption As DataTable
    Shared objLABO As New CARS.CoreLibrary.LinkToAccountingBO
    Shared objLADO As New CARS.CoreLibrary.CARS.LinkToAccountingDO.LinkToAccountingDO
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
            objErrHandle.WriteErrorLog(1, "Transaction_frmLAInvExport", "Page_Load", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub
    <WebMethod()> _
    Public Shared Function FetchInvExported(ByVal transId As String) As Collection
        Dim details As Collection
        Try
            transId = IIf(transId = "", "0", transId)
            details = objLAService.Fetch_TransactionDetails(transId)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transaction_frmLAInvExport", "FetchInvExported", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details
    End Function
    <WebMethod()> _
    Public Shared Function LoadLATransactions() As LinkToAccountingBO()
        Dim details As New List(Of LinkToAccountingBO)()
        Try
            details = objLAService.Load_LATransactions()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transaction_frmLAInvExport", "Load_LATransactions", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function FetchInvDetails(ByVal invNo As String) As LinkToAccountingBO()
        Dim details As New List(Of LinkToAccountingBO)()
        Try
            details = objLAService.FetchInvDetails(invNo)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transaction_frmLAInvExport", "FetchInvDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function

    <WebMethod()> _
    Public Shared Function LoadInvXML(ByVal invNo As String) As String
        Dim strInvXML As String = ""
        Try
            strInvXML = "<ID_INV_NO ID_INV_NO='" + invNo + "'/>"
            HttpContext.Current.Session("xmlInvNos") = "<ROOT>" + strInvXML.ToString() + "</ROOT>"
            HttpContext.Current.Session("RptType") = "INVOICE"

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transaction_frmLAInvExport", "LoadInvXML", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return True
    End Function

End Class