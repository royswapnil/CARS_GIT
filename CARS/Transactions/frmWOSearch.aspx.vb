Imports System.Data
Imports Encryption
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports System.Net.WebRequest
Imports System.Net.HttpWebRequest
Imports System.Net.HttpWebResponse
Imports System.Net
Imports System.Web.Services
Imports CARS.CoreLibrary
Imports MSGCOMMON
Imports CARS.CoreLibrary.CARS

Public Class frmWOSearch
    Inherits System.Web.UI.Page
    Shared dtSubDetails As New DataTable()
    Shared dsSubDetails As New DataSet
    Shared objZipCodeBO As New ZipCodesBO
    Shared objZipCodeDO As New ZipCodes.ZipCodesDO
    Shared objVehicleDO As New VehicleDO
    Shared loginName As String
    Shared commonUtil As New Utilities.CommonUtility
    Shared OErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared objVehicleBO As New VehicleBO
    Shared objVehicleService As New CARS.CoreLibrary.CARS.Services.Vehicle.VehicleDetails
    Shared objCustBO As New CustomerBO
    Shared objItemBO As New ItemsBO
    Shared objServItems As New Services.Items.ItemsDetail
    Shared objServCustomer As New Services.Customer.CustomerDetails
    Shared objServOrder As New Services.Order.OrderDetails

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Session("UserID") Is Nothing Or Session("UserPageperDT") Is Nothing Then
            Response.Redirect("~/frmLogin.aspx")
        Else
            loginName = CType(Session("UserID"), String)
        End If

        Try
            Dim strscreenName As String
            Dim dtCaption As DataTable
            loginName = CType(Session("UserID"), String)
            If Not IsPostBack Then
                dtCaption = DirectCast(Cache("Caption"), System.Data.DataTable)
                strscreenName = IO.Path.GetFileName(Me.Request.PhysicalPath)
            End If
            hdnPageSize.Value = System.Configuration.ConfigurationManager.AppSettings("PageSize")
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "transactions_frmWOSearch", "Page_Load", ex.Message, loginName)
        End Try

    End Sub
    <WebMethod()>
    Public Shared Function GetOrder(ByVal orderNo As String) As List(Of String)
        Dim retOrder As New List(Of String)()
        Dim dsOrder As New DataSet
        Dim dtOrder As New DataTable
        Try
            retOrder = objServOrder.GetOrder(orderNo)

        Catch exth As System.Threading.ThreadAbortException
            Throw exth
        Catch ex As Exception
            OErrHandle.WriteErrorLog(1, "OrderDO", "getOrder", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, "pv45")
        End Try
        Return retOrder

    End Function
    <WebMethod()>
    <System.Web.Script.Services.ScriptMethod(ResponseFormat:=System.Web.Script.Services.ResponseFormat.Json)>
    Public Shared Function Customer_Search(ByVal q As String, ByVal isPrivate As String, ByVal isCompany As String) As CustomerBO()
        Dim custDetails As New List(Of CustomerBO)()
        Try
            custDetails = objServCustomer.CustomerSearch(q, isPrivate, isCompany)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transaction_frmWOSearch", "Customer_Search", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
        End Try
        Return custDetails.ToList.ToArray
    End Function
    <WebMethod()>
    <System.Web.Script.Services.ScriptMethod(ResponseFormat:=System.Web.Script.Services.ResponseFormat.Json)>
    Public Shared Function Vehicle_Search(ByVal q As String) As VehicleBO()
        Dim vehDetails As New List(Of VehicleBO)()
        Try
            vehDetails = objVehicleService.VehicleSearch(q)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transaction_frmWOSearch", "Vehicle_Search", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
        End Try
        Return vehDetails.ToList.ToArray
    End Function

    <WebMethod()>
    Public Shared Function SparePart_Search(ByVal q As String) As ItemsBO()
        Dim itemDetails As New List(Of ItemsBO)()
        Try
            itemDetails = objServItems.SparePartSearch(q)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transaction_frmWOSearch", "SparePart_Search", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
        End Try
        Return itemDetails.ToList.ToArray
    End Function

    <WebMethod()>
    <System.Web.Script.Services.ScriptMethod(ResponseFormat:=System.Web.Script.Services.ResponseFormat.Json)>
    Public Shared Function Order_Search(ByVal q As String, ByVal isBargain As String, ByVal isOrder As String, ByVal isCreditnote As String, ByVal isOpenorder As String, ByVal isReadyforinvoice As String) As OrderBO()
        Dim ordDetails As New List(Of OrderBO)()
        Try
            ordDetails = objServOrder.Order_Search(q, isBargain, isOrder, isCreditnote, isOpenorder, isReadyforinvoice)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transaction_frmWOSearch", "Order_Search", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
        End Try
        Return ordDetails.ToList.ToArray
    End Function
    <WebMethod()>
    Public Shared Function GetZipCodes(ByVal zipCode As String) As List(Of String)
        Dim retZipCodes As New List(Of String)()
        Try
            retZipCodes = commonUtil.getZipCodes(zipCode, loginName)

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmWOSearch", "GetZipCodes", ex.Message, loginName)
        End Try
        Return retZipCodes
    End Function
    <WebMethod()> _
    Public Shared Function InvoiceOrder(ByVal orderNo As String, ByVal orderPr As String, ByVal custId As String, ByVal invNo As String, ByVal flgBkOrd As String, ByVal payType As String, ByVal orderType As String) As String
        Dim strScript As String = ""
        Try
            strScript = objServOrder.CreateInvoice(orderNo, orderPr, custId, flgBkOrd, payType, orderType)

            'strScript = objServOrder.OpenInvoicePdf(orderNo, orderPr, custId, invNo)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmWOSearch", "InvoiceOrder", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strScript
    End Function

    <WebMethod()> _
    Public Shared Function DeleteOrd(ByVal q As String) As String()
        Dim strResult As String()
        Try
            strResult = objServOrder.DeleteOrder(q)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfCustomer", "DeleteOrd", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
    <WebMethod()> _
    Public Shared Function OpenPdf(ByVal orderNo As String, ByVal orderPr As String, ByVal custId As String, ByVal invNo As String) As String
        Dim strScript As String = ""
        Try
            strScript = objServOrder.OpenInvoicePdf(orderNo, orderPr, custId, invNo)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmWOSearch", "OpenPdf", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strScript
    End Function
   


End Class