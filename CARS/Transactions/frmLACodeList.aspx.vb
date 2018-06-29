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
Public Class frmLACodeList
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
            objErrHandle.WriteErrorLog(1, "Transaction_frmLACodeList", "Page_Load", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub
    <WebMethod()> _
    Public Shared Function FetchLACodeList(ByVal laDeptCode As String, ByVal laCustGrpCode As String) As LinkToAccountingBO()
        Dim details As New List(Of LinkToAccountingBO)()
        Try
            laCustGrpCode = IIf(laCustGrpCode = "", Nothing, laCustGrpCode)
            details = objLAService.FetchLACodeList(laDeptCode, laCustGrpCode)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transaction_frmLACodeList", "FetchLACodeList", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function FetchLAAccTypes(ByVal la_slno As String) As LinkToAccountingBO()
        Dim details As New List(Of LinkToAccountingBO)()
        Try
            details = objLAService.FetchLAAccTypes(la_slno)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transaction_frmLACodeList", "FetchLAAccTypes", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function DeleteLACodeList(ByVal strXML As String) As String()
        Dim strRetVal As String()
        Try
            strRetVal = objLAService.DeleteLACodeList(strXML)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transaction_frmLACodeList", "DeleteLACodeList", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strRetVal
    End Function

End Class