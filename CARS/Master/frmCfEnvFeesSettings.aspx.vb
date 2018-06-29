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
Public Class frmCfEnvFeesSettings
    Inherits System.Web.UI.Page
    Shared objItemsService As New CARS.CoreLibrary.CARS.Services.Items.ItemsDetail
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared commonUtil As New Utilities.CommonUtility
    Shared loginName As String
    Shared dtCaption As DataTable
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            If Session("UserID") Is Nothing Or Session("UserPageperDT") Is Nothing Then
                Response.Redirect("~/frmLogin.aspx")
            Else
                LoginName = CType(Session("UserID"), String)
            End If
            dtCaption = DirectCast(Cache("Caption"), System.Data.DataTable)
            hdnSelect.Value = dtCaption.Select("TAG='select'")(0)(1)
            hdnPageSize.Value = System.Configuration.ConfigurationManager.AppSettings("PageSize")

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transaction_frmCfEnvFeesSettings", "Page_Load", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub
    <WebMethod()> _
    Public Shared Function SparePart_Search(ByVal q As String) As ItemsBO()
        Dim spareDetails As New List(Of ItemsBO)()
        Try
            spareDetails = objItemsService.SparePartSearch(q)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transaction_frmCfEnvFeesSettings", "SparePart_Search", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
        End Try
        Return spareDetails.ToList.ToArray
    End Function
    <WebMethod()> _
    Public Shared Function LoadEnvFeeSettings(ByVal sparePartId As String, ByVal name As String, ByVal warehouse As String) As ItemsBO()
        Dim spareDetails As New List(Of ItemsBO)()
        Try
            spareDetails = objItemsService.Fetch_EnvSparePartDetails(sparePartId, name, warehouse)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transaction_frmCfEnvFeesSettings", "LoadEnvFeeSettings", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
        End Try
        Return spareDetails.ToList.ToArray
    End Function
    <WebMethod()> _
    Public Shared Function GetEnvFeeSettings(ByVal spareId As String, ByVal make As String, ByVal warehouse As String) As Collection
        Dim details As New Collection
        Try
            details = objItemsService.GetEnvSparePartDetails(spareId, make, warehouse)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transaction_frmCfEnvFeesSettings", "GetEnvFeeSettings", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details
    End Function
    <WebMethod()> _
    Public Shared Function LoadVATCode() As ItemsBO()
        Dim vatcodeDetails As New List(Of ItemsBO)()
        Try
            vatcodeDetails = commonUtil.LoadVatCode()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transaction_frmCfEnvFeesSettings", "LoadVATCode", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return vatcodeDetails.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function LoadWarehouse() As WOJobDetailBO()
        Dim whDetails As New List(Of WOJobDetailBO)()
        Try
            whDetails = commonUtil.LoadWarehouse()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transaction_frmCfEnvFeesSettings", "LoadWarehouse", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return whDetails.ToList.ToArray()
    End Function

    <WebMethod()> _
    Public Shared Function SaveEnvFeeSettings(ByVal idItem As String, ByVal flgEnvfee As String, ByVal minAmt As String, ByVal maxAmt As String, ByVal addedFeePerc As String, ByVal name As String, ByVal vatCode As String, ByVal idMake As String, ByVal idWh As String) As String()
        Dim strRes As String()
        Try
            Dim objItemsBO As New ItemsBO
            objItemsBO.ID_ITEM = idItem
            objItemsBO.FLG_EFD = flgEnvfee
            objItemsBO.MIN_AMT = commonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(minAmt = "", 0D, minAmt))
            objItemsBO.MAX_AMT = commonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(maxAmt = "", 0D, maxAmt))
            objItemsBO.ADDED_FEE_PERC = commonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(addedFeePerc = "", 0D, addedFeePerc))
            objItemsBO.ENV_NAME = name
            objItemsBO.ENV_VATCODE = vatCode
            objItemsBO.CREATED_BY = loginName
            objItemsBO.ENV_ID_MAKE = idMake
            objItemsBO.ENV_ID_WAREHOUSE = idWh

            strRes = objItemsService.Save_EnvFeeSettings(objItemsBO)

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transaction_frmCfEnvFeesSettings", "SaveEnvFeeSettings", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strRes
    End Function

    <WebMethod()> _
    Public Shared Function DeleteEnvFeeSettings(ByVal sparePartId As String, ByVal sparePartMake As String, ByVal sparePartWh As String) As String()
        Dim strVal As String()
        Try
            strVal = objItemsService.Delete_EnvFeeSettings(sparePartId, sparePartMake, sparePartWh)

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transaction_frmCfEnvFeesSettings", "DeleteEnvFeeSettings", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strVal
    End Function
End Class