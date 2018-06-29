Imports System.Web.Services
Imports CARS.CoreLibrary.CARS
Imports CARS.CoreLibrary
Imports System.Web.UI
Imports Newtonsoft.Json
Public Class frmLabourOnOrders
    Inherits System.Web.UI.Page
    Shared loginName As String
    Shared objCommonUtil As New Utilities.CommonUtility
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared dtCaption As DataTable
    Dim objConfigDeptDO As New Department.ConfigDepartmentDO
    Shared objConfigDeptBO As New ConfigDepartmentBO
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
                FillDepartments()

            End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Reports_frmLabourOnorders", "Page_load", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, Session("UserID"))
        End Try
    End Sub
    Private Sub FillDepartments()
        Try
            Dim dsSales As New DataSet
            dsSales = Nothing
            objConfigDeptBO.LoginId = loginName
            dsSales = objConfigDeptDO.Fetch_Dept_sales(objConfigDeptBO)
            HttpContext.Current.Session("Dept") = dsSales
            ' To fill 'From Department' 
            If dsSales.Tables(0).Rows.Count > 0 Then
                ddlDeptFrom.Items.Clear()
                ddlDeptFrom.DataSource = dsSales.Tables(0)
                ddlDeptFrom.DataTextField = "DPT_Name"
                ddlDeptFrom.DataValueField = "ID_Dept"
                ddlDeptFrom.DataBind()
                ddlDeptFrom.Items.Insert(0, hdnSelect.Value)
                If dsSales.Tables(0).Rows.Count = 1 Then
                    ddlDeptFrom.SelectedIndex = 1
                Else
                    ddlDeptFrom.SelectedIndex = 0
                End If
            End If

            ' To fill 'TO Department' 
            If dsSales.Tables(0).Rows.Count > 0 Then
                ddlDeptTo.Items.Clear()
                ddlDeptTo.DataSource = dsSales.Tables(0)
                ddlDeptTo.DataTextField = "DPT_Name"
                ddlDeptTo.DataValueField = "ID_Dept"
                ddlDeptTo.DataBind()
                ddlDeptTo.Items.Insert(0, hdnSelect.Value)
                If dsSales.Tables(0).Rows.Count = 1 Then
                    ddlDeptTo.SelectedIndex = 1
                Else
                    ddlDeptTo.SelectedIndex = 0
                End If
            End If
        Catch exth As System.Threading.ThreadAbortException
            Throw exth
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "frmHoursPerMechanic", "FillDepartments()", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, Session("UserID"))
            'Throw ex
        End Try
    End Sub
    <WebMethod()> _
    Public Shared Function LoadReport(ByVal deptFrom As String, ByVal deptTo As String, ByVal fromDate As String, ByVal toDate As String, ByVal flgclkTime As String) As String

        Dim reportRequest As String = ""
        Dim rnd As New Random()
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

            Dim strLabOnOrdersXML As String = String.Empty
            strLabOnOrdersXML += "<ROOT> <Parameters " _
                             + " DeptFrom=""" + deptFrom + """ " _
                             + " DeptTo=""" + deptTo + """ " _
                             + " DateFrom=""" + fromDate + """ " _
                             + " DateTo=""" + toDate + """ " _
                             + " CalcTime=""" + flgclkTime + """/></ROOT>"
            HttpContext.Current.Session("xmlLabourOnOrders") = strLabOnOrdersXML
            reportRequest = "../Reports/frmShowReports.aspx?ReportHeader=" + objCommonUtil.fnEncryptQString("LabourOnOrders") + "&Rpt=" + objCommonUtil.fnEncryptQString("LabourOnOrders") + "&scrid=" + rnd.Next().ToString()

            'End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "frmHoursPerMechanic", "LoadReport", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return reportRequest
    End Function
End Class