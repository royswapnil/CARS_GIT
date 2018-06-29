Imports System.Web.Services
Imports CARS.CoreLibrary.CARS
Imports CARS.CoreLibrary
Imports System.Web.UI
Imports Newtonsoft.Json
Public Class frmSalesJournal
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


                ddlPayTypeFrom.Items.Clear()
                ddlPayTypeFrom.Items.Add(dtCaption.Select("TAG='select'")(0)(1))
                ddlPayTypeFrom.AppendDataBoundItems = True
                objCommonUtil.ddlGetValue(strscreenName, ddlPayTypeFrom)

                ddlPayTypeTo.Items.Clear()
                ddlPayTypeTo.Items.Add(dtCaption.Select("TAG='select'")(0)(1))
                ddlPayTypeTo.AppendDataBoundItems = True
                objCommonUtil.ddlGetValue(strscreenName, ddlPayTypeTo)


                Fetch_DepartmentList()
                Load_Customer_ID()
                Load_Payment_Type()
            End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Reports_frmSalesJournal", "Page_Load", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
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

            If Not Session("UserDept") Is Nothing Then
                ddlDeptFrom.SelectedIndex = ddlDeptFrom.Items.IndexOf(ddlDeptFrom.Items.FindByValue(Session("UserDept")))
            End If

            If Not Session("UserDept") Is Nothing Then
                ddlDeptTo.SelectedIndex = ddlDeptTo.Items.IndexOf(ddlDeptTo.Items.FindByValue(Session("UserDept")))
            End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Reports_frmSalesJournal", "Fetch_DepartmentList()", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, Session("UserId"))
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
            objErrHandle.WriteErrorLog(1, "Reports_frmSalesJournal", "Load_Customer_ID", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, Session("UserId"))
            Throw ex
        End Try
    End Sub
    Public Sub Load_Payment_Type()
        Dim ds As New DataSet
        Try
            ds = objConfigCustDO.Fetch_PayType

            If (ds.Tables(0).Rows.Count > 0) Then
                ddlPayTypeFrom.DataSource = ds.Tables(0)
                ddlPayTypeFrom.DataTextField = "DESCRIPTION"
                ddlPayTypeFrom.DataValueField = "DESCRIPTION"
                ddlPayTypeFrom.DataBind()

                ddlPayTypeTo.DataSource = ds.Tables(0)
                ddlPayTypeTo.DataTextField = "DESCRIPTION"
                ddlPayTypeTo.DataValueField = "DESCRIPTION"
                ddlPayTypeTo.DataBind()
            End If

        Catch exth As System.Threading.ThreadAbortException
            Throw exth
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Reports_frmSalesJournal", "Load_Customer_ID", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, Session("UserId"))
            Throw ex
        End Try
    End Sub
    <WebMethod()> _
    Public Shared Function LoadReport(ByVal deptFrom As String, ByVal deptTo As String, ByVal fromDate As String, ByVal toDate As String, ByVal custIdFrom As String, ByVal custIdTo As String, ByVal payTypeFrom As String, ByVal payTypeTo As String, ByVal flgJournal As String, ByVal flgDI As String, ByVal flgDP As String) As String

        Dim reportRequest As String = ""
        Dim dsReturnVal As DataSet
        Dim rnd As New Random()
        Dim SalesJournalXML As String = String.Empty
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

            Dim SalesJournalPara As String = String.Empty
            SalesJournalPara += "<ROOT> <Parameters " _
                            + " IV_DEP_FROM=""" + deptFrom + """ " _
                            + " IV_DEP_TO=""" + deptTo + """ " _
                            + " IV_CUSID_FROM=""" + IIf(custIdFrom = "", Nothing, custIdFrom) + """ " _
                            + " IV_CUSID_TO=""" + IIf(custIdTo = "", Nothing, custIdTo) + """ " _
                            + " IV_INVOICEDATE_FROM=""" + IIf(fromDate = "", Nothing, fromDate) + """ " _
                            + " IV_INVOICEDATE_TO=""" + IIf(toDate = "", Nothing, toDate) + """ " _
                            + " IV_PAYMENT_FROM=""" + IIf(payTypeFrom = "", Nothing, payTypeFrom) + """ " _
                            + " IV_PAYMENT_TO=""" + IIf(payTypeTo = "", Nothing, payTypeTo) + """ " _
                            + " IV_LANGUAGE=""" + ConfigurationManager.AppSettings("Language").ToString + """ " _
                            + "/> </ROOT>"

            HttpContext.Current.Session("SalesJournalPara") = SalesJournalPara
            'If (dsReturnVal.Tables(0).Rows.Count > 0) Then
            If flgJournal = True Then
                reportRequest = "../Reports/frmShowReports.aspx?ReportHeader=" + objCommonUtil.fnEncryptQString("SalesJournal") + "&Rpt=" + objCommonUtil.fnEncryptQString("SalesJournal") + "&scrid=" + rnd.Next().ToString()

            ElseIf flgDI = True Then
                reportRequest = "../Reports/frmShowReports.aspx?ReportHeader=" + objCommonUtil.fnEncryptQString("SalesJournalDI") + "&Rpt=" + objCommonUtil.fnEncryptQString("SalesJournalDI") + "&scrid=" + rnd.Next().ToString()

            ElseIf flgDP = True Then
                reportRequest = "../Reports/frmShowReports.aspx?ReportHeader=" + objCommonUtil.fnEncryptQString("SalesJournalDP") + "&Rpt=" + objCommonUtil.fnEncryptQString("SalesJournalDP") + "&scrid=" + rnd.Next().ToString()
            End If

            'End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWOJobDetails", "LoadReport", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return reportRequest
    End Function
End Class