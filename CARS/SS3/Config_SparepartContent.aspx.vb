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
Public Class Config_SparepartContent
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
            objErrHandle.WriteErrorLog(1, "Config_SparepartContent", "Page_Load", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub
    <WebMethod()> _
    Public Shared Function LoadSupplier(ByVal supplier As String) As ItemsBO()
        Dim suppDetails As New List(Of ItemsBO)()
        Try
            suppDetails = objItemsService.FetchSupplierDetails(supplier)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Config_SparepartContent", "LoadSupplier", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
        End Try
        Return suppDetails.ToList.ToArray
    End Function

    <WebMethod()> _
    Public Shared Function LoadDiscCodes(ByVal supplier As String) As ItemsBO()
        Dim discCodes As New List(Of ItemsBO)()
        Try
            discCodes = objItemsService.FetchSprDiscountCodes(supplier)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Config_SparepartContent", "LoadDiscCodes", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
        End Try
        Return discCodes.ToList.ToArray
    End Function
    <WebMethod()> _
    Public Shared Function LoadSpCatgConfig() As ItemsBO()
        Dim spareCatgDetails As New List(Of ItemsBO)()
        Try
            spareCatgDetails = objItemsService.FetchSparePartCategoryDetails()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Config_SparepartContent", "LoadSpCatgConfig", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
        End Try
        Return spareCatgDetails.ToList.ToArray
    End Function
    <WebMethod()> _
    Public Shared Function GetSpCatgDetails(ByVal idItemCatg As String) As Collection
        Dim details As New Collection
        Try
            details = objItemsService.GetSparePartCategoryDetails(idItemCatg)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Config_SparepartContent", "GetSpCatgDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details
    End Function

    <WebMethod()> _
    Public Shared Function SaveSpCatgDetails(ByVal discCodeBuy As String, ByVal discCodeSell As String, ByVal idSupplier As String, ByVal idMake As String, ByVal catg As String, ByVal desc As String, ByVal initialClCode As String, ByVal vatCode As String, ByVal accntCode As String, ByVal flgAllowBO As String, ByVal flgCntStock As String, ByVal flgAllowClass As String, ByVal mode As String) As String()
        Dim strRes As String()
        Try
            objItemsBO.ID_ITEM_DISC_CODE_BUYING = IIf(discCodeBuy = "0", Nothing, discCodeBuy)
            objItemsBO.ID_ITEM_DISC_CODE_SELL = IIf(discCodeSell = "0", Nothing, discCodeSell)
            objItemsBO.ID_SUPPLIER_ITEM = IIf(idSupplier = "0", Nothing, idSupplier)
            objItemsBO.ID_MAKE = idMake
            objItemsBO.CATEGORY = catg
            objItemsBO.DESCRIPTION = desc
            objItemsBO.INITIALCLASSCODE = initialClCode
            objItemsBO.ID_VAT_CODE = vatCode
            objItemsBO.ACCOUNT_CODE = accntCode
            objItemsBO.FLG_ALLOW_BCKORD = flgAllowBO
            objItemsBO.FLG_CNT_STOCK = flgCntStock
            objItemsBO.FLG_ALLOW_CLASSIFICATION = flgAllowClass
            objItemsBO.CREATED_BY = loginName

            If (mode = "Edit") Then
                strRes = objItemsService.UpdSpCatgDetails(objItemsBO)
            ElseIf mode = "Add" Then
                strRes = objItemsService.AddSpCatgDetails(objItemsBO)
            End If


        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Config_SparepartContent", "SaveSpCatgDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strRes
    End Function

    <WebMethod()> _
    Public Shared Function DeleteSpCatgDetails(ByVal idItemCatg As String) As String()
        Dim strRes As String()
        Try
            strRes = objItemsService.DeleteSpCatgDetails(idItemCatg)

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Config_SparepartContent", "DeleteSpCatgDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strRes
    End Function

End Class