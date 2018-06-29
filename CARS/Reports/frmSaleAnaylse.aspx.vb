Imports System.Web.Services
Imports CARS.CoreLibrary.CARS
Imports CARS.CoreLibrary
Imports System.Web.UI
Imports Newtonsoft.Json
Public Class frmSaleAnaylse
    Inherits System.Web.UI.Page
    Shared loginName As String
    Shared objCommonUtil As New Utilities.CommonUtility
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared dtCaption As DataTable
    Shared objOrdReportstDO As New OrderReportsDO
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim strscreenName As String
        Try
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

                FetchDefault()

            End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Reports_frmSaleAnaylse", "FetchDefault", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, Session("UserID"))
            Throw ex
        End Try
    End Sub
    Private Sub FetchDefault()
        Dim dsReturnVal As DataSet
        Try
            dsReturnVal = objOrdReportstDO.Fetch_SaleAnalyse_Report(loginName)

            If dsReturnVal.Tables(0).Rows.Count > 0 Then
                ddlDeptFrom.Items.Clear()
                Dim dvDepartment As DataView
                dvDepartment = dsReturnVal.Tables(0).DefaultView
                dvDepartment.Sort = "DEPARTMENT"
                ddlDeptFrom.DataSource = dvDepartment
                ddlDeptFrom.DataTextField = "DEPARTMENT".ToString.Trim
                ddlDeptFrom.DataValueField = "ID_DEPT".ToString.Trim
                ddlDeptFrom.DataBind()
                ddlDeptFrom.Dispose()
                ddlDeptFrom.Items.Insert(0, hdnSelect.Value)
                ddlDeptFrom.SelectedIndex = 0
            Else
                ddlDeptFrom.Items.Insert(0, hdnSelect.Value)
                ddlDeptFrom.DataBind()
            End If

            If dsReturnVal.Tables(0).Rows.Count > 0 Then
                ddlDeptTo.Items.Clear()
                Dim dvDepartment As DataView
                dvDepartment = dsReturnVal.Tables(0).DefaultView
                dvDepartment.Sort = "DEPARTMENT"
                ddlDeptTo.DataSource = dvDepartment

                ddlDeptTo.DataTextField = "DEPARTMENT".ToString.Trim
                ddlDeptTo.DataValueField = "ID_DEPT".ToString.Trim
                ddlDeptTo.DataBind()
                ddlDeptTo.Dispose()
                ddlDeptTo.Items.Insert(0, hdnSelect.Value)
                ddlDeptTo.SelectedIndex = 0
            Else
                ddlDeptTo.Items.Insert(0, hdnSelect.Value)
                ddlDeptTo.DataBind()
            End If


            If dsReturnVal.Tables(1).Rows.Count > 0 Then
                ddlfworkcode.Items.Clear()
                Dim dvWorkCode As DataView
                dvWorkCode = dsReturnVal.Tables(1).DefaultView
                dvWorkCode.Sort = "DESCRIPTION"
                ddlfworkcode.DataSource = dvWorkCode

                ddlfworkcode.DataTextField = "DESCRIPTION".ToString.Trim
                ddlfworkcode.DataValueField = "WORKCODE".ToString.Trim
                ddlfworkcode.DataBind()
                ddlfworkcode.Dispose()
                ddlfworkcode.Items.Insert(0, hdnSelect.Value)
                ddlfworkcode.SelectedIndex = 0
            Else
                ddlfworkcode.Items.Insert(0, hdnSelect.Value)
                ddlfworkcode.DataBind()
            End If

            If dsReturnVal.Tables(1).Rows.Count > 0 Then
                ddlTworkcode.Items.Clear()
                Dim dvWorkCode As DataView
                dvWorkCode = dsReturnVal.Tables(1).DefaultView
                dvWorkCode.Sort = "DESCRIPTION"
                ddlTworkcode.DataSource = dvWorkCode
                ddlTworkcode.DataTextField = "DESCRIPTION".ToString.Trim
                ddlTworkcode.DataValueField = "WORKCODE".ToString.Trim
                ddlTworkcode.DataBind()
                ddlTworkcode.Dispose()
                ddlTworkcode.Items.Insert(0, hdnSelect.Value)
                ddlTworkcode.SelectedIndex = 0
            Else
                ddlTworkcode.Items.Insert(0, hdnSelect.Value)
                ddlTworkcode.DataBind()
            End If


            If dsReturnVal.Tables(2).Rows.Count > 0 Then
                ddlFMech.Items.Clear()
                ddlFMech.DataSource = dsReturnVal.Tables(2)
                ddlFMech.DataTextField = "MECHNAME".ToString.Trim
                ddlFMech.DataValueField = "MECHID".ToString.Trim
                ddlFMech.DataBind()
                ddlFMech.Dispose()
                ddlFMech.Items.Insert(0, hdnSelect.Value)
                ddlFMech.SelectedIndex = 0
            Else
                ddlFMech.Items.Insert(0, hdnSelect.Value)
                ddlFMech.DataBind()
            End If


            If dsReturnVal.Tables(2).Rows.Count > 0 Then
                ddlTMech.Items.Clear()
                ddlTMech.DataSource = dsReturnVal.Tables(2)
                ddlTMech.DataTextField = "MECHNAME".ToString.Trim
                ddlTMech.DataValueField = "MECHID".ToString.Trim
                ddlTMech.DataBind()
                ddlTMech.Dispose()
                ddlTMech.Items.Insert(0, hdnSelect.Value)
                ddlTMech.SelectedIndex = 0
            Else
                ddlTMech.Items.Insert(0, hdnSelect.Value)
                ddlTMech.DataBind()
            End If

            If Not Session("UserDept") Is Nothing Then
                ddlDeptFrom.SelectedIndex = ddlDeptFrom.Items.IndexOf(ddlDeptFrom.Items.FindByValue(Session("UserDept")))
            End If

            If Not Session("UserDept") Is Nothing Then
                ddlDeptTo.SelectedIndex = ddlDeptTo.Items.IndexOf(ddlDeptTo.Items.FindByValue(Session("UserDept")))
            End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Reports_frmSaleAnaylse", "FetchDefault", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, Session("UserID"))
            Throw ex
        End Try
    End Sub
    <WebMethod()> _
    Public Shared Function LoadReport(ByVal deptFrom As String, ByVal deptTo As String, ByVal fromDate As String, ByVal toDate As String, ByVal fromWorkCode As String, ByVal toWorkCode As String, ByVal flgmech As String, ByVal fromMech As String, ByVal toMech As String) As String

        Dim reportRequest As String = ""
        Dim rnd As New Random()
        Dim strSalesAnalysisXML As String = String.Empty
        Try
            toDate = objCommonUtil.GetDefaultDate_MMDDYYYY(toDate)
            fromDate = objCommonUtil.GetDefaultDate_MMDDYYYY(fromDate)

            strSalesAnalysisXML = "<ROOT><SALANYSIS DEP_FROM=""" + deptFrom + """" _
             + " DEP_TO=""" + deptTo + """" _
             + " FROM_DATE=""" + fromDate + """" _
             + " TO_DATE=""" + toDate + """" _
             + " WORK_CODE_FROM=""" + fromWorkCode + """" _
             + " WORK_CODE_TO=""" + toWorkCode + """" _
             + " MECH_CODE_FROM=""" + fromMech + """" _
             + " MECH_CODE_TO=""" + toMech + """" _
             + " IV_LANGUAGE=""" + ConfigurationManager.AppSettings("Language").ToString + """ " _
             + "/></ROOT>"
            HttpContext.Current.Session("strSalesAnalysisXML") = strSalesAnalysisXML
            If flgmech = True Then
                reportRequest = "../Reports/frmShowReports.aspx?ReportHeader=" + objCommonUtil.fnEncryptQString("SalesAnalysisReport") + "&Rpt=" + objCommonUtil.fnEncryptQString("SalesAnalysisReport1") + "&scrid=" + rnd.Next().ToString()

            Else
                reportRequest = "../Reports/frmShowReports.aspx?ReportHeader=" + objCommonUtil.fnEncryptQString("SalesAnalysisReport") + "&Rpt=" + objCommonUtil.fnEncryptQString("SalesAnalysisReport2") + "&scrid=" + rnd.Next().ToString()

            End If


            'End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "frmSalesPerMechanic", "LoadReport", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return reportRequest
    End Function
End Class