Imports System.Web.Services
Imports CARS.CoreLibrary.CARS
Imports CARS.CoreLibrary
Imports System.Web.UI
Imports Newtonsoft.Json
Public Class frmFixedPriceAnaly
    Inherits System.Web.UI.Page
    Shared loginName As String
    Shared objCommonUtil As New Utilities.CommonUtility
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared dtCaption As DataTable
    Dim objConfigDeptDO As New Department.ConfigDepartmentDO
    Shared objConfigDeptBO As New ConfigDepartmentBO
    Shared objConfigCustDO As New ConfigCustomer.ConfigCustomerDO
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Dim strscreenName As String
            If Session("UserID") Is Nothing Or Session("UserPageperDT") Is Nothing Then
                Response.Redirect("~/frmLogin.aspx")
            Else
                loginName = CType(Session("UserID"), String)
            End If
            strscreenName = IO.Path.GetFileName(Me.Request.PhysicalPath)
            dtCaption = DirectCast(Cache("Caption"), System.Data.DataTable)
            hdnPageSize.Value = System.Configuration.ConfigurationManager.AppSettings("PageSize")
            hdnSelect.Value = dtCaption.Select("TAG='select'")(0)(1)
            If Not (Page.IsPostBack) Then
                ddlCustIdFrom.Items.Clear()
                ddlCustIdFrom.Items.Add(dtCaption.Select("TAG='select'")(0)(1))
                ddlCustIdFrom.AppendDataBoundItems = True
                objCommonUtil.ddlGetValue(strscreenName, ddlCustIdFrom)

                ddlCustIdTo.Items.Clear()
                ddlCustIdTo.Items.Add(dtCaption.Select("TAG='select'")(0)(1))
                ddlCustIdTo.AppendDataBoundItems = True
                objCommonUtil.ddlGetValue(strscreenName, ddlCustIdTo)

                ddlDeptFrom.Items.Clear()
                ddlDeptFrom.Items.Add(dtCaption.Select("TAG='select'")(0)(1))
                ddlDeptFrom.AppendDataBoundItems = True
                objCommonUtil.ddlGetValue(strscreenName, ddlDeptFrom)

                ddlDeptTo.Items.Clear()
                ddlDeptTo.Items.Add(dtCaption.Select("TAG='select'")(0)(1))
                ddlDeptTo.AppendDataBoundItems = True
                objCommonUtil.ddlGetValue(strscreenName, ddlDeptTo)

                Fetch_DepartmentList()
                Load_Customer_ID()

            End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Reports_frmFixedPriceAnaly", "Page_Load", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub
    Private Sub Fetch_DepartmentList()
        Try
            Dim dsDepartment As New DataSet
            objConfigDeptBO.LoginId = loginName
            dsDepartment = objConfigDeptDO.FetchAllDepartments(objConfigDeptBO)

            ddlDeptFrom.DataSource = dsDepartment
            ddlDeptFrom.DataTextField = "DepartmentName"
            ddlDeptFrom.DataValueField = "DepartmentID"
            ddlDeptFrom.DataBind()

            ddlDeptTo.DataSource = dsDepartment
            ddlDeptTo.DataTextField = "DepartmentName"
            ddlDeptTo.DataValueField = "DepartmentID"
            ddlDeptTo.DataBind()

            If dsDepartment.Tables(0).Rows.Count = 1 Then
                ddlDeptFrom.SelectedIndex = 1
            Else
                ddlDeptFrom.SelectedIndex = 0
            End If
            If dsDepartment.Tables(0).Rows.Count = 1 Then
                ddlDeptTo.SelectedIndex = 1
            Else
                ddlDeptTo.SelectedIndex = 0
            End If

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Reports_frmFixedPriceAnaly", "Fetch_DepartmentList()", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, Session("UserId"))
        End Try
    End Sub
    Public Sub Load_Customer_ID()
        Dim ds As New DataSet
        Try
            ds = objConfigCustDO.Fetch_CustomerID()

            If (ds.Tables(0).Rows.Count > 0) Then
                ddlCustIdFrom.DataSource = ds.Tables(0)
                ddlCustIdFrom.DataTextField = "ID_CUSTOMER"
                ddlCustIdFrom.DataValueField = "ID_CUSTOMER"
                ddlCustIdFrom.DataBind()

                ddlCustIdTo.DataSource = ds.Tables(0)
                ddlCustIdTo.DataTextField = "ID_CUSTOMER"
                ddlCustIdTo.DataValueField = "ID_CUSTOMER"
                ddlCustIdTo.DataBind()
            End If

        Catch exth As System.Threading.ThreadAbortException
            Throw exth
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Reports_frmFixedPriceAnaly", "Load_Customer_ID", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, Session("UserId"))
            Throw ex
        End Try
    End Sub
    <WebMethod()> _
    Public Shared Function LoadReport(ByVal deptFrom As String, ByVal deptTo As String, ByVal fromDate As String, ByVal toDate As String, ByVal custIdFrom As String, ByVal custIdTo As String, ByVal flgDI As String, ByVal flgDP As String) As String

        Dim reportRequest As String = ""
        Dim dsReturnVal As DataSet
        Dim rnd As New Random()
        Dim strFixedPriceAnalysisXML As String = String.Empty
        Try
            If toDate <> "" Then
                toDate = objCommonUtil.GetDefaultDate_MMDDYYYY(toDate)
            Else
                toDate = ""
            End If
            If fromDate <> "" Then
                fromDate = objCommonUtil.GetDefaultDate_MMDDYYYY(fromDate)
            Else
                fromDate = ""
            End If



            strFixedPriceAnalysisXML += "<ROOT><FIXEDPRICE " _
                          + " iv_DeptFrom=""" + deptFrom + """ " _
                          + " iv_DeptTo=""" + deptTo + """ " _
                          + " iv_InvDateFrom=""" + fromDate + """ " _
                          + " iv_InvDateTo=""" + toDate + """ " _
                          + " iv_CustIdFrom=""" + custIdFrom + """ " _
                          + " iv_CustIdTo=""" + custIdTo + """ " _
                          + " IV_LANGUAGE=""" + ConfigurationManager.AppSettings("Language").ToString + """ " _
                          + "/> </ROOT>"
            HttpContext.Current.Session("strFixedPriceAnalysisXML") = strFixedPriceAnalysisXML
            'If (dsReturnVal.Tables(0).Rows.Count > 0) Then
            If flgDI = True And flgDP = False Then
                reportRequest = "../Reports/frmShowReports.aspx?ReportHeader=" + objCommonUtil.fnEncryptQString("FixedPriceAnalysis1") + "&Rpt=" + objCommonUtil.fnEncryptQString("FixedPriceAnalysis1") + "&scrid=" + rnd.Next().ToString()

            ElseIf flgDP = True And flgDI = False Then
                reportRequest = "../Reports/frmShowReports.aspx?ReportHeader=" + objCommonUtil.fnEncryptQString("FixedPriceAnalysis2") + "&Rpt=" + objCommonUtil.fnEncryptQString("FixedPriceAnalysis2") + "&scrid=" + rnd.Next().ToString()
            End If

            'End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWOJobDetails", "LoadReport", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return reportRequest
    End Function
End Class