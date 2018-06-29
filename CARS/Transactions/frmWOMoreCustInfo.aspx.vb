Imports System.Data
Imports Encryption
Imports MSGCOMMON
Imports System.Web.Services
Imports CARS.CoreLibrary.CARS
Imports CARS.CoreLibrary
Imports System.Web.UI
Imports System.Xml
Public Class frmWOMoreCustInfo
    Inherits System.Web.UI.Page
    Dim screenName As String
    Shared loginName As String
    Shared objWOHeaderBO As New CARS.CoreLibrary.WOHeaderBO
    Shared objWOHeaderServ As New CARS.CoreLibrary.CARS.Services.WOHeader.WOHeader
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared details As New List(Of WOHeaderBO)()
    Shared objCustomerBO As New CARS.CoreLibrary.CustomerBO
    Shared objCustomerServ As New CARS.CoreLibrary.CARS.Services.Customer.CustomerDetails
    Shared detailsCust As New List(Of CustomerBO)()
    Shared dtCaption As DataTable
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Session.Item("id") = Nothing
        Session("Mode") = Nothing
        If Session("UserID") Is Nothing Or Session("UserPageperDT") Is Nothing Then
            Response.Redirect("~/frmLogin.aspx")
        Else
            loginName = CType(Session("UserID"), String)

        End If
        screenName = IO.Path.GetFileName(Me.Request.PhysicalPath)
        If Not IsPostBack Then
            dtCaption = DirectCast(Cache("Caption"), System.Data.DataTable)
            hdnSelect.Value = dtCaption.Select("TAG='select'")(0)(1)
        End If
    End Sub
    <WebMethod()> _
    Public Shared Function LoadCustDetails(ByVal IdCustomer As String) As WOHeaderBO()
        Try
            objWOHeaderBO.Id_Cust_Wo = IdCustomer
            details = objWOHeaderServ.Fetch_WOH_Cust_Details(objWOHeaderBO.Id_Cust_Wo)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWoHead", "LoadCustDet", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function LoadlPriceCode() As CustomerBO()
        Try
            detailsCust = objCustomerServ.Fetch_Cust_PriceCode_Details()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWoHead", "LoadlPriceCode", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return detailsCust.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function LoadlDiscCode() As CustomerBO()
        Try
            detailsCust = objCustomerServ.Fetch_Cust_DiscCode_Details()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWoHead", "LoadlDiscCode", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return detailsCust.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function UpdateCustInfo(ByVal custID As String, ByVal custContactPer As String, ByVal custCreditLimit As String, ByVal custPhoneHome As String, ByVal custPhoneOff As String, ByVal custFax As String, ByVal custPhoneMobile As String, ByVal custEmail As String, ByVal custPriceCode As String, ByVal custAccountNo As String, ByVal custDiscCode As String) As String()
        Dim strResult As String()
        Try
            objWOHeaderBO.Cust_Account_No = custAccountNo
            objWOHeaderBO.Cust_Contactperson = custContactPer
            objWOHeaderBO.Cust_Credit_Limit = custCreditLimit
            objWOHeaderBO.Cust_Discount_Code = custDiscCode
            objWOHeaderBO.Cust_Email = custEmail
            objWOHeaderBO.Cust_Fax = custFax
            objWOHeaderBO.Cust_ID = custID
            objWOHeaderBO.Cust_Pricecode = custPriceCode
            objWOHeaderBO.WO_Cust_Phone_Home = custPhoneHome
            objWOHeaderBO.WO_Cust_Phone_Off = custPhoneOff
            objWOHeaderBO.WO_Cust_Phone_Mobile = custPhoneMobile
            objWOHeaderBO.Modified_By = loginName
            strResult = objWOHeaderServ.Update_Customerdetails(objWOHeaderBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWoHead", "UpdateCustInfo", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult

    End Function
End Class