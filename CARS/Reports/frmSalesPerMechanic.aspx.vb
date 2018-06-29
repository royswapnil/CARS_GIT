Imports System.Web.Services
Imports CARS.CoreLibrary.CARS
Imports CARS.CoreLibrary
Imports System.Web.UI
Imports Newtonsoft.Json
Public Class frmSalesPerMechanic
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

            FillYear()
            FillMonths()
            FillDepartments()
            FillMechanicCodes()

        End If
    End Sub
    Private Sub FillYear()
        Try
            cmbYear.Items.Clear()
            Dim YearLoop As Integer
            For YearLoop = Year(Now) + 1 To 1990 Step -1
                cmbYear.Items.Add(YearLoop)
            Next
            cmbYear.Items.Insert(0, hdnSelect.Value)
            cmbYear.DataBind()
            cmbYear.SelectedIndex = 0
        Catch exth As System.Threading.ThreadAbortException
            Throw exth
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "frmSalesPerMechanic", "FillYear()", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, Session("UserID"))
            'Throw ex
        End Try
    End Sub
    Private Sub FillMonths()
        Try
            cmbFrmMonth.Items.Clear()
            cmbFrmMonth.Items.Add(hdnSelect.Value)
            cmbFrmMonth.Items.Insert(1, (New ListItem(MonthName(1), 1)))
            cmbFrmMonth.Items.Insert(2, (New ListItem(MonthName(2), 2)))
            cmbFrmMonth.Items.Insert(3, (New ListItem(MonthName(3), 3)))
            cmbFrmMonth.Items.Insert(4, (New ListItem(MonthName(4), 4)))
            cmbFrmMonth.Items.Insert(5, (New ListItem(MonthName(5), 5)))
            cmbFrmMonth.Items.Insert(6, (New ListItem(MonthName(6), 6)))
            cmbFrmMonth.Items.Insert(7, (New ListItem(MonthName(7), 7)))
            cmbFrmMonth.Items.Insert(8, (New ListItem(MonthName(8), 8)))
            cmbFrmMonth.Items.Insert(9, (New ListItem(MonthName(9), 9)))
            cmbFrmMonth.Items.Insert(10, (New ListItem(MonthName(10), 10)))
            cmbFrmMonth.Items.Insert(11, (New ListItem(MonthName(11), 11)))
            cmbFrmMonth.Items.Insert(12, (New ListItem(MonthName(12), 12)))

            cmbToMonth.Items.Clear()
            cmbToMonth.Items.Add(hdnSelect.Value)
            cmbToMonth.Items.Insert(1, (New ListItem(MonthName(1), 1)))
            cmbToMonth.Items.Insert(2, (New ListItem(MonthName(2), 2)))
            cmbToMonth.Items.Insert(3, (New ListItem(MonthName(3), 3)))
            cmbToMonth.Items.Insert(4, (New ListItem(MonthName(4), 4)))
            cmbToMonth.Items.Insert(5, (New ListItem(MonthName(5), 5)))
            cmbToMonth.Items.Insert(6, (New ListItem(MonthName(6), 6)))
            cmbToMonth.Items.Insert(7, (New ListItem(MonthName(7), 7)))
            cmbToMonth.Items.Insert(8, (New ListItem(MonthName(8), 8)))
            cmbToMonth.Items.Insert(9, (New ListItem(MonthName(9), 9)))
            cmbToMonth.Items.Insert(10, (New ListItem(MonthName(10), 10)))
            cmbToMonth.Items.Insert(11, (New ListItem(MonthName(11), 11)))
            cmbToMonth.Items.Insert(12, (New ListItem(MonthName(12), 12)))

        Catch exth As System.Threading.ThreadAbortException
            Throw exth
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "frmSalesPerMechanic", "FillMonths()", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, Session("UserID"))
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
    <WebMethod()> _
    Public Shared Function LoadReport(ByVal deptFrom As String, ByVal deptTo As String, ByVal year As String, ByVal fromMnth As String, ByVal toMnth As String, ByVal fromMecCode As String, ByVal toMecCode As String) As String

        Dim reportRequest As String = ""
        Dim dsReturnVal As DataSet
        Dim rnd As New Random()
        Dim SalesJournalXML As String = String.Empty
        Try
            If fromMecCode = "0" Then
                fromMecCode = ""
            End If
            If toMecCode = "0" Then
                toMecCode = ""
            End If
            Dim SalesPerMechXML As String = ""

            dsReturnVal = objOrdReportstDO.Check_Sales_Per_Mechanic_Report(deptFrom, deptTo, year, fromMnth, toMnth, fromMecCode, toMecCode)

            If (dsReturnVal.Tables(0).Rows.Count > 0) Then
                SalesPerMechXML += "<ROOT> <Parameters " _
                                + " IV_DEP_FROM=""" + deptFrom + """ " _
                                + " IV_DEP_TO=""" + deptTo + """ " _
                                + " IV_YEAR=""" + year + """ " _
                                + " IV_MONTH_FROM=""" + fromMnth + """ " _
                                + " IV_MONTH_TO=""" + toMnth + """ " _
                                + " IV_MECH_CODE_FROM=""" + IIf(fromMecCode = "", Nothing, fromMecCode) + """ " _
                                + " IV_MECH_CODE_TO=""" + IIf(toMecCode = "", Nothing, toMecCode) + """ " _
                                + " IV_LANGUAGE=""" + ConfigurationManager.AppSettings("Language").ToString + """ " _
                                + "/> </ROOT>"

                HttpContext.Current.Session("SalesPerMechXML") = SalesPerMechXML
                reportRequest = "../Reports/frmShowReports.aspx?ReportHeader=" + objCommonUtil.fnEncryptQString("SalesPerMech") + "&Rpt=" + objCommonUtil.fnEncryptQString("SalesPerMech") + "&scrid=" + rnd.Next().ToString()
            End If

            'End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "frmSalesPerMechanic", "LoadReport", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return reportRequest
    End Function
End Class