Imports System.Web.Services
Imports CARS.CoreLibrary
Imports CARS.CoreLibrary.CARS
Imports System.Web.Security
Imports System.Web.UI
Imports Encryption
Imports System.Math
Imports Newtonsoft.Json
Imports System.Reflection
Imports System.IO

Public Class frmLAExport
    Inherits System.Web.UI.Page
    Shared commonUtil As New Utilities.CommonUtility
    Shared loginName As String
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared dtCaption As DataTable
    Shared details As New List(Of LinkToAccountingBO)()
    Shared objLAServ As New Services.LinkToAccounting.LinkToAccounting
    Shared objLABO As New CARS.CoreLibrary.LinkToAccountingBO
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Session("Decimal_Seperator") = ConfigurationManager.AppSettings.Get("ReportDecimalSeperator").ToString()
            If Session("UserID") Is Nothing Or Session("UserPageperDT") Is Nothing Then
                Response.Redirect("~/frmLogin.aspx")
            Else
                loginName = CType(Session("UserID"), String)
            End If
            dtCaption = DirectCast(Cache("Caption"), System.Data.DataTable)
            hdnSelect.Value = dtCaption.Select("TAG='select'")(0)(1)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmLAExport", "Page_Load", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub
    <WebMethod()> _
    Public Shared Function FetchTranId() As LinkToAccountingBO()
        Try
            details = objLAServ.FetchTranId()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmLAExport", "FetchTranId", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function LoadSubsidiary() As LinkToAccountingBO()
        Try
            details = objLAServ.FetchSubs(loginName)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmLAExport", "LoadSubsidiary", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function FetchDept(ByVal subId As String) As LinkToAccountingBO()
        Try
            details = objLAServ.FetchDepartment(subId, loginName)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmLAExport", "FetchDept", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function Export(ByVal strSelExport As String, ByVal strExpTranId As String, ByVal strInvJrn As String, ByVal strCustInfo As String, ByVal strIdSub As String, ByVal fromDate As String, ByVal dept As String, ByVal toDate As String, ByVal strTranId As String, ByVal strRecreate As String, ByVal strRegenerate As String) As String
        Dim strReturn As String = ""
        Try
            strReturn = objLAServ.Export(strSelExport, strExpTranId, strInvJrn, strCustInfo, strIdSub, fromDate, toDate, strTranId, strRecreate, strRegenerate, dept)

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmLAExport", "Export", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strReturn
    End Function
    <WebMethod()> _
    Public Shared Function LoadErrInvRpt() As String
        Dim strRpt As String = ""
        Try
            strRpt = objLAServ.LoadErrInvoiceRpt()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmLAExport", "LoadErrInvRpt", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strRpt
    End Function

End Class