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
Public Class Config_DiscountCodeContent
    Inherits System.Web.UI.Page
    Shared objItemsService As New CARS.CoreLibrary.CARS.Services.Items.ItemsDetail
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared commonUtil As New Utilities.CommonUtility
    Shared loginName As String
    Shared dtCaption As DataTable
    Shared objItemsBO As New ItemsBO
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
            objErrHandle.WriteErrorLog(1, "Config_DiscountCodeContent", "Page_Load", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub
    <WebMethod()> _
    Public Shared Function LoadDiscCodeConfig() As ItemsBO()
        Dim suppDetails As New List(Of ItemsBO)()
        Try
            suppDetails = objItemsService.FetchSprDiscountCodes(Nothing)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Config_DiscountCodeContent", "LoadDiscCodeConfig", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
        End Try
        Return suppDetails.ToList.ToArray
    End Function
    <WebMethod()> _
    Public Shared Function GetDiscCodeDetails(ByVal idDiscCode As String) As Collection
        Dim details As New Collection
        Try
            details = objItemsService.GetDiscCodeDetails(idDiscCode)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Config_DiscountCodeContent", "GetDiscCodeDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details
    End Function
    <WebMethod()> _
    Public Shared Function SaveDiscCodeDetails(ByVal suppCurrentNo As String, ByVal discCode As String, ByVal desc As String, ByVal mode As String) As String()
        Dim strRes As String()
        Try
            objItemsBO.SUPPLIER_NUMBER = IIf(suppCurrentNo = "0", Nothing, suppCurrentNo)
            objItemsBO.ITEM_DISC_CODE_BUYING = discCode
            objItemsBO.DESCRIPTION = desc
            objItemsBO.CREATED_BY = loginName

            If (mode = "Edit") Then
                strRes = objItemsService.UpdDiscCodeDetails(objItemsBO)
            ElseIf mode = "Add" Then
                strRes = objItemsService.AddDiscCodeDetails(objItemsBO)
            End If


        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Config_DiscountCodeContent", "SaveDiscCodeDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strRes
    End Function
    <WebMethod()> _
    Public Shared Function DeleteDiscCodeDetails(ByVal idDiscCode As String) As String()
        Dim strRes As String()
        Try
            strRes = objItemsService.DeleteDiscCodeDetails(idDiscCode)

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Config_DiscountCodeContent", "DeleteDiscCodeDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strRes
    End Function
End Class