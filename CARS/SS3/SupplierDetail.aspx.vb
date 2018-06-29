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


Public Class SupplierDetail
    Inherits System.Web.UI.Page
    Shared ddLangName As String = "ctl00$cntMainPanel$Language" 'Localization
    Public Const PostBackEventTarget As String = "__EVENTTARGET" 'Localization
    Shared objSupService As New CARS.CoreLibrary.CARS.Services.Supplier.SupplierDetail
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared commonUtil As New Utilities.CommonUtility
    Shared OErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared loginName As String
    Shared objSupBo As New SupplierBO

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


    <WebMethod()>
    <System.Web.Script.Services.ScriptMethod(ResponseFormat:=System.Web.Script.Services.ResponseFormat.Json)>
    Public Shared Function Supplier_Search(ByVal q As String) As SupplierBO()
        Dim spareDetails As New List(Of SupplierBO)()
        Try
            spareDetails = objSupService.Supplier_Search(q)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transaction_frmWOSearch", "Customer_Search", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
        End Try
        Return spareDetails.ToList.ToArray
    End Function

    <WebMethod()>
    Public Shared Function FetchSupplierDetail(ByVal ID_SUPPLIER As String)
        Dim supplierDetail As New SupplierBO
        Dim supplierRes As New List(Of SupplierBO)
        supplierDetail.ID_SUPPLIER = ID_SUPPLIER

        Try
            supplierRes = objSupService.Fetch_Supplier_Detail(supplierDetail)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCustomerDetail", "FetchCustomerDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
        End Try
        Return supplierRes.toList.toArray
        'Return JsonConvert.SerializeObject(itemsRes)
    End Function

    <WebMethod()>
    Public Shared Function FetchCurrencyDetail(ByVal CURRENCY_CODE As String)
        Dim currDetail As New SupplierBO
        Dim currRes As New SupplierBO
        currDetail.CURRENCY_CODE = CURRENCY_CODE

        Try
            currRes = objSupService.Fetch_Currency_Detail(currDetail)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCustomerDetail", "FetchCustomerDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
        End Try
        Return currRes
        'Return JsonConvert.SerializeObject(itemsRes)
    End Function

    <WebMethod()>
    Public Shared Function InsertSupplier(ByVal Supplier As String) As String()
        Dim strResult As String()
        Dim dsReturnValStr As String = ""
        Dim sup As SupplierBO = JsonConvert.DeserializeObject(Of SupplierBO)(Supplier)
        Try
            Console.WriteLine(sup.ID_SUPPLIER)
            strResult = objSupService.Insert_Supplier(sup)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCustomerDetail", "InsertCustomer", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function

    <WebMethod()>
    <System.Web.Script.Services.ScriptMethod(ResponseFormat:=System.Web.Script.Services.ResponseFormat.Json)>
    Public Shared Function Currency_Search(ByVal q As String) As SupplierBO()
        Dim currencyDetails As New List(Of SupplierBO)()
        Try
            currencyDetails = objSupService.Currency_Search(q)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transaction_frmWOSearch", "Customer_Search", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
        End Try
        Return currencyDetails.ToList.ToArray
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