Imports System.Data
Imports Encryption
Imports MSGCOMMON
Imports System.Web.Services
Imports CARS.CoreLibrary.CARS
Imports CARS.CoreLibrary
Imports System.Web.UI
Imports System.Xml
Imports System.Data.SqlTypes
Imports CARS.CoreLibrary.ABS10SS3DO
Imports System.IO
Public Class frmOrderNotInvoiced
    Inherits System.Web.UI.Page
    Shared loginName As String
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared dtCaption As DataTable
    Shared objConfigSubDO As New Subsidiary.ConfigSubsidiaryDO
    Shared objConfigDeptDO As New Department.ConfigDepartmentDO
    Shared objConfigDeptBO As New ConfigDepartmentBO
    Shared objMultiLangBO As New MultiLingualBO
    Shared objMultiLangDO As New MultiLingual.MultiLingualDO
    Shared objCommonUtil As New Utilities.CommonUtility
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Dim strscreenName As String
            If Session("UserID") Is Nothing Or Session("UserPageperDT") Is Nothing Then
                Response.Redirect("~/frmLogin.aspx")
            Else
                loginName = CType(Session("UserID"), String)
            End If

            strscreenName = IO.Path.GetFileName(Me.Request.PhysicalPath)

            If Not IsPostBack Then
                dtCaption = DirectCast(Cache("Caption"), System.Data.DataTable)
                hdnSelect.Value = dtCaption.Select("TAG='select'")(0)(1)
                FillDepartment()

                ddlDepartmentF.Attributes.Add("OnChange", "return fnFrmDept();")
                ddlDepartmentT.Attributes.Add("OnChange", "return fnToDept();")
                cmbStatusFrom.Attributes.Add("OnChange", "return fnFromStatus();")
                cmbStatusTo.Attributes.Add("OnChange", "return fnToStatus();")

                Dim tmpstr As String = "return slashtext(txtDateFrom ,txtToDate,'" + hdnDateFormat.Value + "');"
                'txtDateFrom.Attributes.Add("OnChange", tmpstr)

                Dim tmpstr1 As String = "return slashtext(txtToDate ,txtDateFrom,'" + hdnDateFormat.Value + "');"

                'FillStatus()
                cmbStatusFrom.Items.Clear()
                cmbStatusTo.Items.Clear()
                objCommonUtil.ddlGetValue(strscreenName, cmbStatusFrom)
                objCommonUtil.ddlGetValue(strscreenName, cmbStatusTo)
            End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "frmOrderNotInvoiced", "Page_Load", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub
    Public Sub FillDepartment()
        Try
            Dim dsDepartment As New DataSet
            objConfigDeptBO.LoginId = loginName
            dsDepartment = objConfigDeptDO.FetchAllDepartments(objConfigDeptBO)
            ddlDepartmentF.DataSource = dsDepartment
            ddlDepartmentF.DataTextField = "DepartmentName"
            ddlDepartmentF.DataValueField = "DepartmentID"
            ddlDepartmentF.DataBind()
            ddlDepartmentF.Items.Insert(0, New ListItem("--Select--", "0"))

            ddlDepartmentT.DataSource = dsDepartment
            ddlDepartmentT.DataTextField = "DepartmentName"
            ddlDepartmentT.DataValueField = "DepartmentID"
            ddlDepartmentT.DataBind()
            ddlDepartmentT.Items.Insert(0, New ListItem("--Select--", "0"))


            If Not Session("UserDept") Is Nothing Then
                ddlDepartmentF.SelectedIndex = ddlDepartmentF.Items.IndexOf(ddlDepartmentF.Items.FindByValue(Session("UserDept")))
            End If

            If Not Session("UserDept") Is Nothing Then
                ddlDepartmentT.SelectedIndex = ddlDepartmentT.Items.IndexOf(ddlDepartmentT.Items.FindByValue(Session("UserDept")))
            End If

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "frmOrderNotInvoiced", "FillDepartment", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub

    <WebMethod()> _
    Public Shared Function LoadReport(ByVal deptFrom As String, ByVal deptTo As String, ByVal fromDate As String, ByVal toDate As String, ByVal statusFrom As String, ByVal statusTo As String) As String
        Dim reportRequest As String = ""
        Dim rnd As New Random()
        Dim strOrderNotInvoicedRpt As String = ""
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

            strOrderNotInvoicedRpt += "<ROOT> <Parameters " _
                                 + " IV_ID_DEPT_FROM=""" + IIf(deptFrom = "", "", deptFrom) + """ " _
                                 + " IV_ID_DEPT_TO=""" + IIf(deptTo = "", "", deptTo) + """ " _
                                 + " IV_DT_CREATED_FROM=""" + fromDate + """ " _
                                 + " IV_DT_CREATED_TO=""" + toDate + """ " _
                                 + " IV_WO_STATUS_FROM=""" + IIf(statusFrom = "", "", statusFrom) + """ " _
                                 + " IV_WO_STATUS_TO=""" + IIf(statusTo = "", "", statusTo) + """ " _
                                 + " IV_LANGUAGE=""" + ConfigurationManager.AppSettings("Language").ToString + """ " _
                                 + "/> </ROOT>"

            HttpContext.Current.Session("strOrderNotInvoicedRpt") = strOrderNotInvoicedRpt
            reportRequest = "../Reports/frmShowReports.aspx?ReportHeader=" + objCommonUtil.fnEncryptQString("OrderNotInvoiced") + "&Rpt=" + objCommonUtil.fnEncryptQString("OrderNotInvoiced") + "&scrid=" + rnd.Next().ToString()


        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWOJobDetails", "LoadReport", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return reportRequest
    End Function




End Class