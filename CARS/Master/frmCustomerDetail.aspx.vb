Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports System.Configuration
Imports System.IO
Imports System.Drawing
Imports System.Web.Script.Serialization.JavaScriptSerializer
Imports System.Object
Imports System.MarshalByRefObject
Imports System.Net.WebRequest
Imports System.Net.HttpWebRequest
Imports System.Net.HttpWebResponse
Imports System.Net
Imports System.Web
Imports System.Web.UI.HtmlControls
Imports System.Web.UI.WebControls.WebParts
Imports CARS.CoreLibrary
Imports CARS.CoreLibrary.CARS.Services
Imports Encryption
Imports MSGCOMMON
Imports System.Web.Services
Imports System.Threading
Imports System.Globalization
Imports CARS.CoreLibrary.CARS
Imports Newtonsoft.Json
Imports System.Reflection


Public Class frmCustomerDetail
    Inherits System.Web.UI.Page
    Shared ddLangName As String = "ctl00$cntMainPanel$Language" 'Localization
    Public Const PostBackEventTarget As String = "__EVENTTARGET" 'Localization
    Shared objCustomerService As New CARS.CoreLibrary.CARS.Services.Customer.CustomerDetails
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared commonUtil As New Utilities.CommonUtility
    Shared OErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared loginName As String
    Shared objCustBo As New CustomerBO

    'Localization start ##############################################
    'Protected Overrides Sub InitializeCulture()
    '    Dim selectedValue As String
    '    Dim lang As String = Request.Form("Language")
    '    If Request(PostBackEventTarget) <> "" Then
    '        Dim controlID As String = Request(PostBackEventTarget)
    '        If controlID.Equals(ddLangName) Then
    '            selectedValue = Request.Form(Request(PostBackEventTarget))
    '            Select Case selectedValue
    '                Case "0"
    '                    SetCulture("nb-NO", "nb-NO")
    '                Case "1"
    '                    SetCulture("en-GB", "nb-NO")
    '                Case "2"
    '                    SetCulture("de-DE", "nb-NO")
    '                Case Else
    '            End Select
    '            If Session("MyUICulture").ToString <> "" And Session("MyCulture").ToString <> "" Then
    '                Thread.CurrentThread.CurrentUICulture = CType(Session.Item("MyUICulture"), CultureInfo)
    '                Thread.CurrentThread.CurrentCulture = CType(Session.Item("MyCulture"), CultureInfo)
    '            End If
    '        End If
    '    End If
    '    MyBase.InitializeCulture()
    'End Sub
    'Protected Sub SetCulture(name As String, locale As String)
    '    Thread.CurrentThread.CurrentUICulture = New CultureInfo(name)
    '    Thread.CurrentThread.CurrentCulture = New CultureInfo(locale)
    '    Session("MyUICulture") = Thread.CurrentThread.CurrentUICulture
    '    Session("MyCulture") = Thread.CurrentThread.CurrentCulture
    'End Sub

    Protected Overrides Sub InitializeCulture()
        MyBase.InitializeCulture()
        If (Session("culture") IsNot Nothing) Then
            Dim ci As New CultureInfo(Session("culture").ToString())
            Thread.CurrentThread.CurrentCulture = ci
            Thread.CurrentThread.CurrentUICulture = ci
        End If
    End Sub



    'Localization end #################################################

    'Protected Sub cbCheckedChange(sender As Object, e As EventArgs)
    '    If cbPrivOrSub.Checked = True Then
    '        txtCompany.Visible = False
    '    Else
    '        txtCompany.Visible = True
    '    End If
    'End Sub


    Private Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then

        End If
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
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "master_Customer_Details", "Page_Load", ex.Message, loginName)
        End Try
    End Sub


    'Protected Sub btnprivCustSMS_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnprivCustSMS.Click
    '    Session("MobileNo") = txtprivCustMobile.Text
    '    Session("Name") = txtFirstname.Text + " " + txtMiddlename.Text + " " + txtLastname.Text
    '    Session("Email") = txtprivCustEmail.Text
    '    ClientScript.RegisterStartupScript(Me.GetType(), "script", "window.open('frmSendSMS.aspx'), 'SendSMS'", True)

    'End Sub

    <WebMethod()>
    Public Shared Function GetZipCodes(ByVal zipCode As String) As List(Of String)
        Dim retZipCodes As New List(Of String)()
        Try
            retZipCodes = commonUtil.getZipCodes(zipCode, loginName)

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCustomerDetail", "GetZipCodes", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return retZipCodes
    End Function


    <WebMethod()>
    Public Shared Function FetchCustomerDetails(ByVal custId As String) As CustomerBO()
        Dim custDetails As New List(Of CustomerBO)()
        Try
            custDetails = objCustomerService.FetchCustomerDetails(custId)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCustomerDetail", "FetchCustomerDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
        End Try
        Return custDetails.ToList.ToArray
    End Function

    <WebMethod()>
    Public Shared Function GetCustomerContact(ByVal custId As String) As CustomerBO()
        Dim custContact As New List(Of CustomerBO)()
        Try
            custContact = objCustomerService.getCustomerContact(custId)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCustomerDetail", "GetCustomerContact", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
        End Try
        Return custContact.ToList.ToArray
    End Function

    <WebMethod()>
    Public Shared Function InsertCustomerDetails(ByVal Customer As String) As String()
        Dim strResult As String()
        Dim dsReturnValStr As String = ""
        Dim cust As CustomerBO = JsonConvert.DeserializeObject(Of CustomerBO)(Customer)
        Try
            cust.CUST_NAME = cust.CUST_FIRST_NAME + " " + cust.CUST_MIDDLE_NAME + " " + cust.CUST_LAST_NAME
            Console.WriteLine(cust.CUST_FIRST_NAME)
            strResult = objCustomerService.Insert_Customer(cust)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCustomerDetail", "InsertCustomer", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function

    <WebMethod()>
    Public Shared Function InsertCCPFunction(ByVal code As String, ByVal description As String)
        Dim strResult As String()
        Try
            strResult = objCustomerService.CCP_Function_Insert(code, description)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCustomerDetail", "InsertCCPFunction", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function

    <WebMethod()>
    Public Shared Function InsertCCPTitle(ByVal code As String, ByVal description As String)
        Dim strResult As String()
        Try
            strResult = objCustomerService.CCP_Title_Insert(code, description)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCustomerDetail", "InsertCCPTitle", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function

    <WebMethod()>
    Public Shared Function FetchEniro(ByVal search As String) As CustomerBO()
        Dim details As New List(Of CustomerBO)()
        Try
            details = objCustomerService.GetEniroData(search)
            Dim dt As New DataTable()
            dt.TableName = "localCustDetails"
            For Each [property] As PropertyInfo In details(0).[GetType]().GetProperties()
                dt.Columns.Add(New DataColumn([property].Name, [property].PropertyType))
            Next

            For Each vehicle As CustomerBO In details
                Dim newRow As DataRow = dt.NewRow()
                For Each [property] As PropertyInfo In vehicle.[GetType]().GetProperties()
                    newRow([property].Name) = vehicle.[GetType]().GetProperty([property].Name).GetValue(vehicle, Nothing)
                Next
                dt.Rows.Add(newRow)
            Next
            HttpContext.Current.Session("CustomerDet") = dt

            Return details.ToList.ToArray
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCustomerDetail", "LoadSubsidiary", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Function

    <WebMethod()>
    Public Shared Function LoadEniroDet(ByVal EniroId As String) As CustomerBO()
        Try
            Dim details As New List(Of CustomerBO)()
            details = objCustomerService.LoadEniroDetails(EniroId)
            Return details.ToList.ToArray
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_CustomerDetail", "LoadEniroDet", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Function

    <WebMethod()>
    Public Shared Function BindContact(ByVal Id As String) As List(Of String)
        Try
            Dim retDet As New List(Of String)()
            retDet = objCustomerService.BindContact(Id)
            Return retDet
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_CustomerDetail", "LoadEniroDet", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Function

    <WebMethod()>
    Public Shared Function getBrregData(ByVal Search As String) As CustomerBO.Brregdata()
        Try
            Dim details As New List(Of CustomerBO.Brregdata)()
            details = objCustomerService.getBrregData(Search)
            Return details.ToList.ToArray
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_CustomerDetail", "getBrregData", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Function

    <WebMethod()>
    <System.Web.Script.Services.ScriptMethod(ResponseFormat:=System.Web.Script.Services.ResponseFormat.Json)>
    Public Shared Function Company_List(ByVal q As String) As CustomerBO()
        Dim vehDetails As New List(Of CustomerBO)()
        Try
            vehDetails = objCustomerService.Company_List(q)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transaction_frmWOSearch", "Vehicle_Search", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
        End Try
        Return vehDetails.ToList.ToArray
    End Function

    <WebMethod()>
    Public Shared Function LoadSalesman() As CustomerBO()
        Dim Salesman As New List(Of CustomerBO)()
        Try
            Salesman = objCustomerService.FetchSalesman()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_VehicleDetail", "LoadCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return Salesman.ToList.ToArray()
    End Function

    <WebMethod()>
    Public Shared Function GetSalesman(ByVal loginId As String) As CustomerBO()
        Dim Salesman As New List(Of CustomerBO)()
        Try
            Salesman = objCustomerService.GetSalesman(loginId)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_VehicleDetail", "LoadCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return Salesman.ToList.ToArray()
    End Function

    <WebMethod()>
    Public Shared Function LoadBranch() As CustomerBO()
        Dim Branch As New List(Of CustomerBO)()
        Try
            Branch = objCustomerService.FetchBranch()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_VehicleDetail", "LoadCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return Branch.ToList.ToArray()
    End Function

    <WebMethod()>
    Public Shared Function GetBranch(ByVal branchId As String) As CustomerBO()
        Dim Branch As New List(Of CustomerBO)()
        Try
            Branch = objCustomerService.GetBranch(branchId)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_VehicleDetail", "LoadCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return Branch.ToList.ToArray()
    End Function

    <WebMethod()>
    Public Shared Function LoadCategory() As CustomerBO()
        Dim Category As New List(Of CustomerBO)()
        Try
            Category = objCustomerService.FetchCategory()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_VehicleDetail", "LoadCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return Category.ToList.ToArray()
    End Function

    <WebMethod()>
    Public Shared Function GetCategory(ByVal categoryId As String) As CustomerBO()
        Dim Category As New List(Of CustomerBO)()
        Try
            Category = objCustomerService.GetCategory(categoryId)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_VehicleDetail", "LoadCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return Category.ToList.ToArray()
    End Function
    <WebMethod()>
    Public Shared Function LoadSalesGroup() As CustomerBO()
        Dim SalesGroup As New List(Of CustomerBO)()
        Try
            SalesGroup = objCustomerService.FetchSalesGroup()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_VehicleDetail", "LoadCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return SalesGroup.ToList.ToArray()
    End Function

    <WebMethod()>
    Public Shared Function GetSalesGroup(ByVal salesgroupId As String) As CustomerBO()
        Dim SalesGroup As New List(Of CustomerBO)()
        Try
            SalesGroup = objCustomerService.GetSalesGroup(salesgroupId)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_VehicleDetail", "LoadCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return SalesGroup.ToList.ToArray()
    End Function

    <WebMethod()>
    Public Shared Function LoadPaymentTerms() As CustomerBO()
        Dim PaymentTerms As New List(Of CustomerBO)()
        Try
            PaymentTerms = objCustomerService.FetchPaymentTerms()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_VehicleDetail", "LoadCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return PaymentTerms.ToList.ToArray()
    End Function

    <WebMethod()>
    Public Shared Function GetPaymentTerms(ByVal paymentTermsId As String) As CustomerBO()
        Dim PaymentTerms As New List(Of CustomerBO)()
        Try
            PaymentTerms = objCustomerService.GetPaymentTerms(paymentTermsId)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_VehicleDetail", "LoadCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return PaymentTerms.ToList.ToArray()
    End Function

    <WebMethod()>
    Public Shared Function LoadCardType() As CustomerBO()
        Dim CardType As New List(Of CustomerBO)()
        Try
            CardType = objCustomerService.FetchCardType()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_VehicleDetail", "LoadCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return CardType.ToList.ToArray()
    End Function

    <WebMethod()>
    Public Shared Function GetCardType(ByVal cardTypeId As String) As CustomerBO()
        Dim CardType As New List(Of CustomerBO)()
        Try
            CardType = objCustomerService.GetCardType(cardTypeId)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_VehicleDetail", "LoadCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return CardType.ToList.ToArray()
    End Function

    <WebMethod()>
    Public Shared Function LoadCurrencyType() As CustomerBO()
        Dim CurrencyType As New List(Of CustomerBO)()
        Try
            CurrencyType = objCustomerService.FetchCurrencyType()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_VehicleDetail", "LoadCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return CurrencyType.ToList.ToArray()
    End Function

    <WebMethod()>
    Public Shared Function GetCurrencyType(ByVal currencyId As String) As CustomerBO()
        Dim CurrencyType As New List(Of CustomerBO)()
        Try
            CurrencyType = objCustomerService.GetCurrencyType(currencyId)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_VehicleDetail", "LoadCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return CurrencyType.ToList.ToArray()
    End Function

    <WebMethod()>
    Public Shared Function AddBranch(ByVal branchCode As String, ByVal branchText As String, ByVal branchNote As String, ByVal branchAnnot As String) As String
        Dim strResult As String = ""
        Dim dsReturnValStr As String = ""
        Try
            objCustBo.BRANCH_CODE = branchCode
            objCustBo.BRANCH_TEXT = branchText
            objCustBo.BRANCH_NOTE = branchNote
            objCustBo.BRANCH_ANNOT = branchAnnot

            strResult = objCustomerService.Add_Branch(objCustBo)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmVehicleDetail", "AddVehicle", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function

    <WebMethod()>
    Public Shared Function DeleteBranch(ByVal branchId As String) As CustomerBO()
        Dim Branch As New List(Of CustomerBO)()
        Try
            Branch = objCustomerService.DeleteBranch(branchId)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_VehicleDetail", "LoadCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return Branch.ToList.ToArray()
    End Function

    <WebMethod()>
    Public Shared Function AddCategory(ByVal categoryCode As String, ByVal categoryText As String, ByVal categoryAnnot As String) As String
        Dim strResult As String = ""
        Dim dsReturnValStr As String = ""
        Try
            objCustBo.CATEGORY_CODE = categoryCode
            objCustBo.CATEGORY_TEXT = categoryText
            objCustBo.CATEGORY_ANNOT = categoryAnnot

            strResult = objCustomerService.Add_Category(objCustBo)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmVehicleDetail", "AddVehicle", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function



    <WebMethod()>
    Public Shared Function DeleteCategory(ByVal categoryId As String) As CustomerBO()
        Dim Category As New List(Of CustomerBO)()
        Try
            Category = objCustomerService.DeleteCategory(categoryId)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_VehicleDetail", "LoadCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return Category.ToList.ToArray()
    End Function

    <WebMethod()>
    Public Shared Function AddSalesGroup(ByVal salesgroupCode As String, ByVal salesgroupText As String, ByVal salesgroupInv As String, ByVal salesgroupVat As String) As String
        Dim strResult As String = ""
        Dim dsReturnValStr As String = ""
        Try
            objCustBo.SALESGROUP_CODE = salesgroupCode
            objCustBo.SALESGROUP_TEXT = salesgroupText
            objCustBo.SALESGROUP_INVESTMENT = salesgroupInv
            objCustBo.SALESGROUP_VAT = salesgroupVat

            strResult = objCustomerService.Add_SalesGroup(objCustBo)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmVehicleDetail", "AddVehicle", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function

    <WebMethod()>
    Public Shared Function DeleteSalesGroup(ByVal salesgroupId As String) As CustomerBO()
        Dim SalesGroup As New List(Of CustomerBO)()
        Try
            SalesGroup = objCustomerService.DeleteSalesGroup(salesgroupId)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_VehicleDetail", "LoadCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return SalesGroup.ToList.ToArray()
    End Function

    <WebMethod()>
    Public Shared Function AddPaymentTerms(ByVal paytermsCode As String, ByVal paytermsText As String, ByVal paytermsDays As String) As String
        Dim strResult As String = ""
        Dim dsReturnValStr As String = ""
        Try
            objCustBo.PAYMENT_TERMS_CODE = paytermsCode
            objCustBo.PAYMENT_TERMS_TEXT = paytermsText
            objCustBo.PAYMENT_TERMS_DAYS = paytermsDays

            strResult = objCustomerService.Add_PaymentTerms(objCustBo)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmVehicleDetail", "AddVehicle", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function

    <WebMethod()>
    Public Shared Function DeletePaymentTerms(ByVal paymenttermsId As String) As CustomerBO()
        Dim PaymentTerms As New List(Of CustomerBO)()
        Try
            PaymentTerms = objCustomerService.DeletePaymentTerms(paymenttermsId)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_VehicleDetail", "LoadCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return PaymentTerms.ToList.ToArray()
    End Function

    <WebMethod()>
    Public Shared Function AddCardType(ByVal cardtypeCode As String, ByVal cardtypeText As String, ByVal cardtypeCustno As String) As String
        Dim strResult As String = ""
        Dim dsReturnValStr As String = ""
        Try
            objCustBo.CARD_TYPE_CODE = cardtypeCode
            objCustBo.CARD_TYPE_TEXT = cardtypeText
            objCustBo.CARD_TYPE_CUSTNO = cardtypeCustno

            strResult = objCustomerService.Add_CardType(objCustBo)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmVehicleDetail", "AddVehicle", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function

    <WebMethod()>
    Public Shared Function DeleteCardType(ByVal cardtypeId As String) As CustomerBO()
        Dim CardType As New List(Of CustomerBO)()
        Try
            CardType = objCustomerService.DeleteCardType(cardtypeId)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_VehicleDetail", "LoadCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return CardType.ToList.ToArray()
    End Function

    <WebMethod()>
    Public Shared Function AddCurrencyType(ByVal currencyCode As String, ByVal currencyText As String, ByVal currencyRate As String) As String
        Dim strResult As String = ""
        Dim dsReturnValStr As String = ""
        Try
            objCustBo.CURRENCY_TYPE_CODE = currencyCode
            objCustBo.CURRENCY_TYPE_TEXT = currencyText
            objCustBo.CURRENCY_TYPE_RATE = currencyRate

            strResult = objCustomerService.Add_CurrencyType(objCustBo)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmVehicleDetail", "AddVehicle", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function

    <WebMethod()>
    Public Shared Function DeleteCurrency(ByVal currencyId As String) As CustomerBO()
        Dim Currency As New List(Of CustomerBO)()
        Try
            Currency = objCustomerService.DeleteCurrency(currencyId)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_VehicleDetail", "LoadCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return Currency.ToList.ToArray()
    End Function
    <WebMethod()>
    Public Shared Function LoadCustomerTemplate() As CustomerBO()
        Dim CustomerTemplate As New List(Of CustomerBO)()
        Try
            CustomerTemplate = objCustomerService.LoadCustomerTemplate()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_VehicleDetail", "LoadWarrantyCodes", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return CustomerTemplate.ToList.ToArray()
    End Function

    <WebMethod()>
    Public Shared Function FetchCustomerTemplate(ByVal tempId As String) As CustomerBO()
        Dim custDetails As New List(Of CustomerBO)()
        Try
            custDetails = objCustomerService.FetchCustomerTemplate(tempId)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCustomerDetail", "FetchCustomerDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
        End Try
        Return custDetails.ToList.ToArray
    End Function

    <WebMethod()>
    Public Shared Function InsertCustomerTemplate(ByVal Customer As String) As String()
        Dim strResult As String()
        Dim dsReturnValStr As String = ""
        Dim cust As CustomerBO = JsonConvert.DeserializeObject(Of CustomerBO)(Customer)
        Try
            cust.CUST_NAME = cust.CUST_FIRST_NAME + " " + cust.CUST_MIDDLE_NAME + " " + cust.CUST_LAST_NAME
            Console.WriteLine(cust.CUST_FIRST_NAME)
            strResult = objCustomerService.InsertCustomerTemplate(cust)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCustomerDetail", "InsertCustomer", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function

    <WebMethod()>
    Public Shared Function LoadContactType() As CustomerBO()
        Dim ContactType As New List(Of CustomerBO)()
        Try
            ContactType = objCustomerService.FetchContactType()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_VehicleDetail", "LoadWarrantyCodes", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return ContactType.ToList.ToArray()
    End Function
    <WebMethod()>
    Public Shared Function LoadContact(ByVal custId As String) As CustomerBO.ContactInformation()
        Dim ContactType As New List(Of CustomerBO.ContactInformation)()
        Try
            ContactType = objCustomerService.FetchContact(custId)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_VehicleDetail", "LoadWarrantyCodes", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return ContactType.ToList.ToArray()
    End Function

    <WebMethod()>
    Public Shared Function AddCustomerContact(ByVal seq As String, ByVal contactType As String, ByVal customerId As String, ByVal contactValue As String, ByVal contactStandard As Boolean)
        Dim strResult As String = ""
        Dim dsReturnValStr As String = ""
        If (seq.Length < 1) Then
            seq = ""
        End If
        Try
            objCustBo.CONTACT_TYPE = contactType
            objCustBo.CONTACT_DESCRIPTION = contactValue
            objCustBo.CONTACT_STANDARD = contactStandard
            objCustBo.ID_CUSTOMER = customerId
            objCustBo.USER_LOGIN = loginName

            strResult = objCustomerService.Add_CustomerContact(objCustBo, seq)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCustomerDetail", "AddCustomer", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function

    <WebMethod()>
    Public Shared Function AddCustomerContactPerson(ByVal CustomerCP As String) As String
        Dim strResult As String
        Dim dsReturnValStr As String = ""
        Dim custCP As CustomerBO.ContactPerson = JsonConvert.DeserializeObject(Of CustomerBO.ContactPerson)(CustomerCP)
        Try
            strResult = objCustomerService.Add_CustomerContactPerson(custCP)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCustomerDetail", "InsertCustomerContactPerson", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function

    <WebMethod()>
    Public Shared Function FetchCustomerContactPerson(ByVal ID_CP As String, ByVal CP_CUSTOMER_ID As String)
        Dim custDetails As New List(Of CustomerBO.ContactPerson)()
        Try
            custDetails = objCustomerService.Fetch_CustomerContactPerson(ID_CP, CP_CUSTOMER_ID)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCustomerDetail", "FetchCustomerDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
        End Try
        Return custDetails.ToList.ToArray
    End Function
    <WebMethod()>
    Public Shared Function DeleteCustomerContactPerson(ByVal ID_CP As String)
        Dim strResult As String = ""
        Try
            strResult = objCustomerService.Delete_CustomerContactPerson(ID_CP)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_CustomerDetails", "DeleteContactPerson", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function

    <WebMethod()>
    Public Shared Function Fetch_CCP_Title(ByVal q As String)
        Dim ccpTitle As New List(Of CustomerBO.ContactPersonTitle)()
        Try
            ccpTitle = objCustomerService.Fetch_CCP_Title(q)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCustomerDetail", "FetchCustomerDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
        End Try
        Return ccpTitle.ToList.ToArray
    End Function
    <WebMethod()>
    Public Shared Function Fetch_CCP_Function(ByVal q As String)
        Dim ccpFunction As New List(Of CustomerBO.ContactPersonFunction)()
        Try
            ccpFunction = objCustomerService.Fetch_CCP_Function(q)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCustomerDetail", "FetchCustomerDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
        End Try
        Return ccpFunction.ToList.ToArray
    End Function

    <WebMethod()>
    Public Shared Function DeleteContact(ByVal CustomerSeq As String)
        Dim strResult As String = ""
        Try
            strResult = objCustomerService.Delete_Contact(CustomerSeq)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_CustomerDetails", "DeleteContact", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function

    <WebMethod()>
    Public Shared Function StandardContact(ByVal CustomerSeq As String)
        Dim strResult As String = ""
        Try
            strResult = objCustomerService.Standard_Contact(CustomerSeq)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_CustomerDetails", "StandardContact", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function

End Class





'Partial Class frmCustomerDetail
'    Protected Sub cbCheckedChange(sender As Object, e As EventArgs)
'        If cbPrivOrSub.Checked = True Then
'            txtCompany.Visible = False

'        Else
'            txtCompany.Visible = True

'        End If
'    End Sub
'End Class