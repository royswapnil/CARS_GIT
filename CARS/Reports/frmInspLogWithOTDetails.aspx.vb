Imports System.Web.Services
Imports CARS.CoreLibrary.CARS
Imports CARS.CoreLibrary
Imports System.Web.UI
Imports Newtonsoft.Json
Public Class frmInspLogWithOTDetails
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
                FillMechanicCodes()
            End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "frmHoursPerMechanic", "Page_load", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, Session("UserID"))
        End Try
    End Sub
    Private Sub FillMechanicCodes()
        Try
            Dim dsSales As New DataSet
            dsSales = Nothing
            dsSales = HttpContext.Current.Session("Dept")

            ' To fill 'From Mechanic Code' 
            If dsSales.Tables(1).Rows.Count > 0 Then
                cmbFromMechCode.Items.Clear()
                Dim dvMechanicCode As DataView
                dvMechanicCode = dsSales.Tables(1).DefaultView
                dvMechanicCode.Sort = "ID_Login"
                cmbFromMechCode.DataSource = dvMechanicCode
                cmbFromMechCode.DataTextField = "ID_Login"
                cmbFromMechCode.DataValueField = "ID_Login"
                cmbFromMechCode.DataBind()
                cmbFromMechCode.Items.Insert(0, hdnSelect.Value)
                If dsSales.Tables(1).Rows.Count = 1 Then
                    cmbFromMechCode.SelectedIndex = 1
                Else
                    cmbFromMechCode.SelectedIndex = 0
                End If
            Else
                cmbFromMechCode.Items.Insert(0, Session("Select"))
            End If

            ' To fill 'TO Mechanic Code' 
            If dsSales.Tables(1).Rows.Count > 0 Then
                cmbToMechCode.Items.Clear()
                Dim dvMechanicCode As DataView
                dvMechanicCode = dsSales.Tables(1).DefaultView
                dvMechanicCode.Sort = "ID_Login"
                cmbToMechCode.DataSource = dvMechanicCode

                cmbToMechCode.DataTextField = "ID_Login"
                cmbToMechCode.DataValueField = "ID_Login"
                cmbToMechCode.DataBind()
                cmbToMechCode.Items.Insert(0, hdnSelect.Value)
                If dsSales.Tables(1).Rows.Count = 1 Then
                    cmbToMechCode.SelectedIndex = 1
                Else
                    cmbToMechCode.SelectedIndex = 0
                End If

            Else
                cmbToMechCode.Items.Insert(0, Session("Select"))
            End If
        Catch exth As System.Threading.ThreadAbortException
            Throw exth
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "frmSalesPerMechanic", "FillMechanicCodes()", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, Session("UserID"))
            'Throw ex
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
            objErrHandle.WriteErrorLog(1, "frmSalesPerMechanic", "FillDepartments()", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, Session("UserID"))
            'Throw ex
        End Try
    End Sub
    <WebMethod()> _
    Public Shared Function LoadReport(ByVal deptFrom As String, ByVal deptTo As String, ByVal fromDate As String, ByVal toDate As String, ByVal fromMecCode As String, ByVal toMecCode As String) As String

        Dim reportRequest As String = ""
        Dim rnd As New Random()
        Dim InspectionXML As String = String.Empty
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

            InspectionXML += "<ROOT> <Parameters " _
                                  + " IV_DEP_FROM=""" + deptFrom + """ " _
                                  + " IV_DEP_TO=""" + deptTo + """ " _
                                  + " IV_FROM_DATE=""" + fromDate + """ " _
                                  + " IV_TO_DATE=""" + toDate + """ " _
                                  + " IV_MECH_CODE_FROM=""" + fromMecCode + """ " _
                                  + " IV_MECH_CODE_TO=""" + toMecCode + """ " _
                                  + " IV_WORKHOUR=""" + ConfigurationManager.AppSettings("WorkHoursinMins").ToString + """ " _
                                  + "/> </ROOT>"

            HttpContext.Current.Session("InspectionXML") = InspectionXML
            reportRequest = "../Reports/frmShowReports.aspx?ReportHeader=" + objCommonUtil.fnEncryptQString("Inspection") + "&Rpt=" + objCommonUtil.fnEncryptQString("Inspection") + "&scrid=" + rnd.Next().ToString()

            'End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "frmHoursPerMechanic", "LoadReport", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return reportRequest
    End Function
End Class