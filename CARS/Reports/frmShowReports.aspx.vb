Imports CrystalDecisions.CrystalReports.Engine
Imports CrystalDecisions.Shared
Imports MSGREPORTS.ReportsCls
Imports Encryption
Imports System.Data
Imports System.Drawing.Font
Imports System.IO
Imports CARS.CoreLibrary
Imports CARS.CoreLibrary.CARS
Imports System.Xml
Imports System.Threading

Public Class frmShowReports
    Inherits System.Web.UI.Page
    Dim MsgRep As MsgReport
    Dim strUserId As String
    Dim oErrHandle As New MSGCOMMON.MsgErrorHndlr
    Dim crReportDocument As New ReportDocument
    Private crTables As Tables
    Private myLogonInfo As CrystalDecisions.Shared.TableLogOnInfo
    Private tabRptConnection As CrystalDecisions.CrystalReports.Engine.Table
    Private ReportFont As System.Drawing.Font
    Dim rptDoc As New ReportDocument
    Dim objrepAcc As New CoreLibrary.CARS.MultiLingual.MultiLingualDO
    Dim strTempPath As String = System.IO.Path.GetTempPath()
    Dim strReportId As String = String.Empty
    Dim objWOJobDetailDO As New CARS.CoreLibrary.CARS.WOJobDetailDO.WOJobDetailDO
    Dim objWOHeaderDO As New CARS.CoreLibrary.CARS.WOHeader.WOHeaderDO
    Dim objLoginBO As New LoginBO
    Dim objLoginDO As New Login.LoginDO
    Shared objCommonUtil As New Utilities.CommonUtility

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
        strUserId = CType(Session("UserID"), String)
        Me.LoadReport()
    End Sub
    Protected Sub Page_Unload(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Unload
        Try
            Dim strReportName As String = String.Empty
            If Not Session("Rpt_Name") Is Nothing Then
                strReportName = Session("Rpt_Name").ToString()
            End If
            If Session("WOJobNo") Is Nothing Then
                Session("WOJobNo") = "0"
            End If
            'change end
            Select Case strReportName
                Case "PICKINGLIST"
                    objWOJobDetailDO.UpdatePickingListPrevPrinted(Session("WONO"), Session("WOPR"), Session("WOJobNo"))
                Case "DELIVERYNOTE"
                    objWOJobDetailDO.UpdateDeliveryNotePrevPrinted(Session("WONO"), Session("WOPR"), Session("WOJobNo"))
                Case "WOHEADPICKINGLIST"
                    objWOHeaderDO.UpdateWOHeadPickingListPrevPrinted(Session("WONO"), Session("WOPR"))
                Case "ORDERHEADPICKINGLIST"
                    objWOHeaderDO.UpdateWOHeadPickingListPrevPrinted(Session("WONO"), Session("WOPR"))
                Case "INVOICEPRINT"  ' Added for KRE order types to update back stock
                    If (Session("Rpt_InvoiceType").ToString() = "INVOICE") Then
                        objWOJobDetailDO.UPDATECREDITNOTESTOCK(Session("WONO"), Session("WOPR"))
                    End If
            End Select
            rptDoc.Close()
            rptDoc.Dispose()
            'GC.WaitForPendingFinalizers()
            GC.Collect()
        Catch ex As Exception
            oErrHandle.WriteErrorLog("1", "Reports_frmShowReports", "Page_Unload", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, "UserID")
        End Try
    End Sub
    Private Sub LoadReport()

        Dim strReportName As String
        If (Request.QueryString("Rpt").Trim = "INVOICEPRINT") Then
            strReportName = "INVOICEPRINT"
        ElseIf (Request.QueryString("Rpt").Trim = "TransactionReport") Then
            strReportName = "TransactionReport"
        ElseIf (Request.QueryString("Rpt").Trim = "ErrorInvoices") Then
            strReportName = "ErrorInvoices"
        ElseIf (Request.QueryString("Rpt").Trim = "WOHEADPICKINGLIST") Then
            strReportName = "WOHEADPICKINGLIST"
        Else
            strReportName = fnDecryptQString("Rpt")
        End If

        Session("Rpt_Name") = strReportName

        Dim strDateFormat As String = System.Configuration.ConfigurationManager.AppSettings("DateFormatValidate").TrimStart("(").TrimEnd(")")
        Dim connString As String = ConfigurationManager.AppSettings("MSGConstr")
        Dim strServerMapPath As String
        Dim strLanguage As String
        Dim blRetval As Boolean
        Dim dsCurrrs As New DataSet
        Dim strRpt As String = String.Empty
        Dim checkInvoiceCaption As Boolean = True
        dsCurrrs = objrepAcc.Fetch_UserDeparmentDetails()

        Try
            strServerMapPath = Server.MapPath("")
            Dim strXMLInvNo As String = ""
            If strReportName = "INVBASIS" Then
                MsgRep = New MsgReport("rptInvoiceBasisNew.rpt", Trim(strServerMapPath), "INVBASIS", strXMLInvNo) 'Request.QueryString("InvNo"))
            ElseIf strReportName = "SubsidiaryList" Then
                Dim objreportutil As CoreLibrary.CARS.Utilities.ReportUtil = CoreLibrary.CARS.Utilities.ReportUtil.CreateReportUtilObject(strServerMapPath)
                crReportDocument = objreportutil.CreateReport("rptSubsidiaryList.rpt", HttpContext.Current.Session("dvSubsidiaryList"))
                blRetval = ParameterFill(strReportName, crReportDocument)
                If (blRetval = False) Then
                    Exit Sub
                End If
                crReportDocument.SetParameterValue("DateFormat", strDateFormat)
                'Parameter Values to format  Numbers for Localization
                If Not crReportDocument.ParameterFields("RPT_ML_DEC_SEP") Is Nothing Then
                    crReportDocument.SetParameterValue("RPT_ML_DEC_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportDecimalSeperator"))
                End If
                If Not crReportDocument.ParameterFields("RPT_ML_THOU_SEP") Is Nothing Then
                    crReportDocument.SetParameterValue("RPT_ML_THOU_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportThousandSeperator"))
                End If
                If Not crReportDocument.ParameterFields("RPT_NO_OF_DIGITS") Is Nothing Then
                    crReportDocument.SetParameterValue("RPT_NO_OF_DIGITS", System.Configuration.ConfigurationManager.AppSettings("DecimalPlaces"))
                End If
                'End
                CrViewer1.ReportSource = crReportDocument
                'Session("dvSubsidiaryList") = Nothing
                Exit Sub
            ElseIf strReportName = "DepartmentList" Then

                Dim objreportutil As CoreLibrary.CARS.Utilities.ReportUtil = CoreLibrary.CARS.Utilities.ReportUtil.CreateReportUtilObject(strServerMapPath)
                crReportDocument = objreportutil.CreateReport("rptDepartmentList.rpt", HttpContext.Current.Session("dvDept"))
                blRetval = ParameterFill(strReportName, crReportDocument)
                If (blRetval = False) Then
                    Exit Sub
                End If
                crReportDocument.SetParameterValue("DateFormat", strDateFormat)
                If Not crReportDocument.ParameterFields("RPT_ML_DEC_SEP") Is Nothing Then
                    crReportDocument.SetParameterValue("RPT_ML_DEC_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportDecimalSeperator"))
                End If
                If Not crReportDocument.ParameterFields("RPT_ML_THOU_SEP") Is Nothing Then
                    crReportDocument.SetParameterValue("RPT_ML_THOU_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportThousandSeperator"))
                End If
                If Not crReportDocument.ParameterFields("RPT_NO_OF_DIGITS") Is Nothing Then
                    crReportDocument.SetParameterValue("RPT_NO_OF_DIGITS", System.Configuration.ConfigurationManager.AppSettings("DecimalPlaces"))
                End If
                CrViewer1.ReportSource = crReportDocument
                Exit Sub
            ElseIf strReportName = "UserDetails" Then

                Dim objreportutil As CoreLibrary.CARS.Utilities.ReportUtil = CoreLibrary.CARS.Utilities.ReportUtil.CreateReportUtilObject(strServerMapPath)
                crReportDocument = objreportutil.CreateReport("rptUserDetails.rpt", HttpContext.Current.Session("dvUserDetails"))
                blRetval = ParameterFill(strReportName, crReportDocument)
                If (blRetval = False) Then
                    Exit Sub
                End If
                crReportDocument.SetParameterValue("DateFormat", strDateFormat)
                'Parameter Values to format  Numbers for Localization
                If Not crReportDocument.ParameterFields("RPT_ML_DEC_SEP") Is Nothing Then
                    crReportDocument.SetParameterValue("RPT_ML_DEC_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportDecimalSeperator"))
                End If
                If Not crReportDocument.ParameterFields("RPT_ML_THOU_SEP") Is Nothing Then
                    crReportDocument.SetParameterValue("RPT_ML_THOU_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportThousandSeperator"))
                End If
                If Not crReportDocument.ParameterFields("RPT_NO_OF_DIGITS") Is Nothing Then
                    crReportDocument.SetParameterValue("RPT_NO_OF_DIGITS", System.Configuration.ConfigurationManager.AppSettings("DecimalPlaces"))
                End If
                CrViewer1.ReportSource = crReportDocument
                Exit Sub
            ElseIf strReportName = "WOHEADPICKINGLIST" Then
                Dim objreportutil As CoreLibrary.CARS.Utilities.ReportUtil = CoreLibrary.CARS.Utilities.ReportUtil.CreateReportUtilObject(strServerMapPath)
                'crReportDocument = objreportutil.CreateReportForList(connString, "rptWOHeadPickingListSettings.rpt", HttpContext.Current.Session("WOHeadPickingList"), HttpContext.Current.Session("WONO"), HttpContext.Current.Session("WOPR"))
                crReportDocument = objreportutil.CreateReportForList(connString, "WorkOrderPickingList.rpt", HttpContext.Current.Session("WOHeadPickingList"), HttpContext.Current.Session("WONO"), HttpContext.Current.Session("WOPR"))
                'rptDoc = rptUtil.CreateReportForList(connString, "rptWOHeadPickingListSettings.rpt", Session("WOHeadPickingList"), Session("WONO"), Session("WOPR"))
                'change end
                Dim orderType As String = "Order" 'fnDecryptQString("OrderType")
                Dim cfSubsidiary As New CARS.CoreLibrary.CARS.Department.ConfigDepartmentDO
                Dim objConfigDeptBO As New ConfigDepartmentBO
                objConfigDeptBO.LoginId = Session("UserID")
                Dim userInfo As DataSet = cfSubsidiary.Fetch_Role1(objConfigDeptBO)
                Dim subsidiary As String = userInfo.Tables(0).Rows(0)("ID_SUBSIDERY_USER")
                Dim department As String = userInfo.Tables(0).Rows(0)("ID_DEPT_USER")
                crReportDocument.SetParameterValue("@IV_Lang", ConfigurationManager.AppSettings("Language").ToString())

                Dim _reportsettings As New ABS10SS3DO.ReportSettings()
                Dim _settings As DataSet
                With _reportsettings
                    'Used the same report id as of Picking List to avoid repetative records
                    .ReportID = "PICKINGLIST" 'strReportName 
                    .Department = department
                    .Subsidiary = subsidiary
                    .OrderType = orderType
                    _settings = .LoadDisplaySettings
                End With
                crReportDocument.SetParameterValue("@DepartmentID", department)
                'crReportDocument.SetParameterValue("DEPARTMENTID", department)
                If _settings.Tables(0).Rows.Count > 0 Then
                    For Each dr As DataRow In _settings.Tables(0).Rows
                        If Not dr("DISPLAY") Is DBNull.Value Then
                            crReportDocument.SetParameterValue(dr("NAME").ToString, dr("DISPLAY"))
                        Else
                            crReportDocument.SetParameterValue(dr("NAME").ToString, True)
                        End If

                    Next
                Else
                    For Each pf As ParameterField In rptDoc.ParameterFields
                        If pf.Name.Substring(0, 4) = "SHOW" Then
                            crReportDocument.SetParameterValue(pf.Name, True)
                        End If
                    Next
                End If

                'FIELDS WHICH ARE NOT REQUIRED FOR PICKING LIST
                crReportDocument.SetParameterValue("SHOWFIRSTREGDATE", False)
                crReportDocument.SetParameterValue("SHOWHOURS", False)
                '
                If _settings.Tables(1).Rows.Count > 0 Then
                    For Each dr As DataRow In _settings.Tables(1).Rows
                        crReportDocument.SetParameterValue(dr("DISPLAYAREA").ToString + "IMAGEID", dr("IMAGEID").ToString)
                        crReportDocument.SetParameterValue("SHOW" + dr("DISPLAYAREA").ToString + "IMAGE", dr("DISPLAY").ToString)
                        crReportDocument.SetParameterValue(dr("DISPLAYAREA").ToString + "IMAGEALIGN", dr("ALIGN").ToString)
                    Next
                Else
                    crReportDocument.SetParameterValue("HEADERIMAGEID", 0)
                    crReportDocument.SetParameterValue("SHOWHEADERIMAGE", False)
                    crReportDocument.SetParameterValue("HEADERIMAGEALIGN", "L")
                    crReportDocument.SetParameterValue("FOOTERIMAGEID", 0)
                    crReportDocument.SetParameterValue("SHOWFOOTERIMAGE", False)
                    crReportDocument.SetParameterValue("FOOTERIMAGEALIGN", "L")
                End If

                If _settings.Tables(2).Rows.Count > 0 Then
                    crReportDocument.SetParameterValue("REPORTNAME", _settings.Tables(2).Rows(0)("REPORTNAME").ToString())
                Else
                    crReportDocument.SetParameterValue("REPORTNAME", "")
                End If
                blRetval = ParameterFill(strReportName, crReportDocument)
                If (blRetval = False) Then
                    Exit Sub
                End If
                crReportDocument.SetParameterValue("DateFormat", strDateFormat)
                'Parameter Values to format  Numbers for Localization
                If Not crReportDocument.ParameterFields("RPT_ML_DEC_SEP") Is Nothing Then
                    crReportDocument.SetParameterValue("RPT_ML_DEC_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportDecimalSeperator"))
                End If
                If Not crReportDocument.ParameterFields("RPT_ML_THOU_SEP") Is Nothing Then
                    crReportDocument.SetParameterValue("RPT_ML_THOU_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportThousandSeperator"))
                End If
                If Not crReportDocument.ParameterFields("RPT_NO_OF_DIGITS") Is Nothing Then
                    crReportDocument.SetParameterValue("RPT_NO_OF_DIGITS", System.Configuration.ConfigurationManager.AppSettings("DecimalPlaces"))
                End If
                CrViewer1.ReportSource = crReportDocument
                Exit Sub
            ElseIf strReportName = "PICKINGLIST" Then
                Dim objreportutil As CoreLibrary.CARS.Utilities.ReportUtil = CoreLibrary.CARS.Utilities.ReportUtil.CreateReportUtilObject(strServerMapPath)
                crReportDocument = objreportutil.CreateReportForList(connString, "rptPickingListSettings.rpt", HttpContext.Current.Session("PickingList"), HttpContext.Current.Session("WONO"), HttpContext.Current.Session("WOPR"))

                Dim orderType As String = fnDecryptQString("OrderType")
                Dim cfSubsidiary As New CARS.CoreLibrary.CARS.Department.ConfigDepartmentDO
                Dim objConfigDeptBO As New ConfigDepartmentBO
                objConfigDeptBO.LoginId = Session("UserID")
                Dim userInfo As DataSet = cfSubsidiary.Fetch_Role1(objConfigDeptBO)
                Dim subsidiary As String = userInfo.Tables(0).Rows(0)("ID_SUBSIDERY_USER")
                Dim department As String = userInfo.Tables(0).Rows(0)("ID_DEPT_USER")
                crReportDocument.SetParameterValue("@IV_Lang", ConfigurationManager.AppSettings("Language").ToString())

                Dim _reportsettings As New ABS10SS3DO.ReportSettings()
                Dim _settings As DataSet
                With _reportsettings
                    .ReportID = strReportName
                    .Department = department
                    .Subsidiary = subsidiary
                    .OrderType = orderType
                    _settings = .LoadDisplaySettings
                End With
                crReportDocument.SetParameterValue("@DepartmentID", department)
                crReportDocument.SetParameterValue("DEPARTMENTID", department)
                If _settings.Tables(0).Rows.Count > 0 Then
                    For Each dr As DataRow In _settings.Tables(0).Rows
                        If Not dr("DISPLAY") Is DBNull.Value Then
                            crReportDocument.SetParameterValue(dr("NAME").ToString, dr("DISPLAY"))
                        Else
                            crReportDocument.SetParameterValue(dr("NAME").ToString, True)
                        End If

                    Next
                Else
                    For Each pf As ParameterField In rptDoc.ParameterFields
                        If pf.Name.Substring(0, 4) = "SHOW" Then
                            crReportDocument.SetParameterValue(pf.Name, True)
                        End If
                    Next
                End If

                'FIELDS WHICH ARE NOT REQUIRED FOR PICKING LIST
                crReportDocument.SetParameterValue("SHOWFIRSTREGDATE", False)
                crReportDocument.SetParameterValue("SHOWHOURS", False)
                '
                If _settings.Tables(1).Rows.Count > 0 Then
                    For Each dr As DataRow In _settings.Tables(1).Rows
                        crReportDocument.SetParameterValue(dr("DISPLAYAREA").ToString + "IMAGEID", dr("IMAGEID").ToString)
                        crReportDocument.SetParameterValue("SHOW" + dr("DISPLAYAREA").ToString + "IMAGE", dr("DISPLAY").ToString)
                        crReportDocument.SetParameterValue(dr("DISPLAYAREA").ToString + "IMAGEALIGN", dr("ALIGN").ToString)
                    Next
                Else
                    crReportDocument.SetParameterValue("HEADERIMAGEID", 0)
                    crReportDocument.SetParameterValue("SHOWHEADERIMAGE", False)
                    crReportDocument.SetParameterValue("HEADERIMAGEALIGN", "L")
                    crReportDocument.SetParameterValue("FOOTERIMAGEID", 0)
                    crReportDocument.SetParameterValue("SHOWFOOTERIMAGE", False)
                    crReportDocument.SetParameterValue("FOOTERIMAGEALIGN", "L")
                End If

                If _settings.Tables(2).Rows.Count > 0 Then
                    crReportDocument.SetParameterValue("REPORTNAME", _settings.Tables(2).Rows(0)("REPORTNAME").ToString())
                Else
                    crReportDocument.SetParameterValue("REPORTNAME", "")
                End If
                blRetval = ParameterFill(strReportName, crReportDocument)
                If (blRetval = False) Then
                    Exit Sub
                End If
                crReportDocument.SetParameterValue("DateFormat", strDateFormat)
                'Parameter Values to format  Numbers for Localization
                If Not crReportDocument.ParameterFields("RPT_ML_DEC_SEP") Is Nothing Then
                    crReportDocument.SetParameterValue("RPT_ML_DEC_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportDecimalSeperator"))
                End If
                If Not crReportDocument.ParameterFields("RPT_ML_THOU_SEP") Is Nothing Then
                    crReportDocument.SetParameterValue("RPT_ML_THOU_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportThousandSeperator"))
                End If
                If Not crReportDocument.ParameterFields("RPT_NO_OF_DIGITS") Is Nothing Then
                    crReportDocument.SetParameterValue("RPT_NO_OF_DIGITS", System.Configuration.ConfigurationManager.AppSettings("DecimalPlaces"))
                End If
                CrViewer1.ReportSource = crReportDocument
                Exit Sub
            ElseIf strReportName = "DELIVERYNOTE" Then
                Dim rptUtil As CoreLibrary.CARS.Utilities.ReportUtil = CoreLibrary.CARS.Utilities.ReportUtil.CreateReportUtilObject(strServerMapPath)
                'rptDoc = rptUtil.CreateReportForList(connString, "DeliveryNote.rpt", Session("DeliveryNote"), Session("WONO"), Session("WOPR"))
                rptDoc = rptUtil.CreateReportForList(connString, "WorkOrderInvoice_DeliveryNote.rpt", Session("DeliveryNote"), Session("WONO"), Session("WOPR"))

                Dim orderType As String = fnDecryptQString("OrderType")

                Dim cfSubsidiary As New CARS.CoreLibrary.CARS.Department.ConfigDepartmentDO  'Fetch_Role1
                Dim objConfigDeptBO As New ConfigDepartmentBO
                objConfigDeptBO.LoginId = HttpContext.Current.Session("UserID")
                Dim userInfo As DataSet = cfSubsidiary.Fetch_Role1(objConfigDeptBO)
                Dim subsidiary As String = userInfo.Tables(0).Rows(0)("ID_SUBSIDERY_USER")
                Dim department As String = userInfo.Tables(0).Rows(0)("ID_DEPT_USER")
                rptDoc.SetParameterValue("@IV_Lang", ConfigurationManager.AppSettings("Language").ToString())


                Dim _reportsettings As New ABS10SS3DO.ReportSettings()
                Dim _settings As DataSet
                With _reportsettings
                    .ReportID = strReportName
                    .Department = department
                    .Subsidiary = subsidiary
                    .OrderType = orderType
                    _settings = .LoadDisplaySettings
                End With
                rptDoc.SetParameterValue("@DepartmentID", department)
                ' rptDoc.SetParameterValue("DEPARTMENTID", department)
                If _settings.Tables(0).Rows.Count > 0 Then
                    For Each dr As DataRow In _settings.Tables(0).Rows
                        If dr("TYPE").ToString = "F" And dr("Name").ToString() <> "CHANGEREADYTOINVOICE" Then
                            rptDoc.SetParameterValue(dr("NAME").ToString, dr("DISPLAY").ToString)
                        ElseIf IsDBNull(dr("TYPE")) And dr("Name").ToString() <> "CHANGEREADYTOINVOICE" Then
                            rptDoc.SetParameterValue(dr("NAME").ToString, True)
                        End If
                    Next
                Else
                    For Each pf As ParameterField In rptDoc.ParameterFields
                        If pf.Name.Substring(0, 4) = "SHOW" Then
                            rptDoc.SetParameterValue(pf.Name, True)
                        End If
                    Next
                End If
                '
                If _settings.Tables(1).Rows.Count > 0 Then
                    For Each dr As DataRow In _settings.Tables(1).Rows
                        rptDoc.SetParameterValue(dr("DISPLAYAREA").ToString + "IMAGEID", dr("IMAGEID").ToString)
                        rptDoc.SetParameterValue("SHOW" + dr("DISPLAYAREA").ToString + "IMAGE", dr("DISPLAY").ToString)
                        rptDoc.SetParameterValue(dr("DISPLAYAREA").ToString + "IMAGEALIGN", dr("ALIGN").ToString)
                    Next
                Else
                    rptDoc.SetParameterValue("HEADERIMAGEID", 0)
                    rptDoc.SetParameterValue("SHOWHEADERIMAGE", False)
                    rptDoc.SetParameterValue("HEADERIMAGEALIGN", "L")
                    rptDoc.SetParameterValue("FOOTERIMAGEID", 0)
                    rptDoc.SetParameterValue("SHOWFOOTERIMAGE", False)
                    rptDoc.SetParameterValue("FOOTERIMAGEALIGN", "L")
                End If

                If _settings.Tables(2).Rows.Count > 0 Then
                    rptDoc.SetParameterValue("REPORTNAME", _settings.Tables(2).Rows(0)("REPORTNAME").ToString())
                Else
                    rptDoc.SetParameterValue("REPORTNAME", "")
                End If
                blRetval = ParameterFill(strReportName, rptDoc)
                If (blRetval = False) Then
                    Exit Sub
                End If
                If Not rptDoc.ParameterFields("DateFormat") Is Nothing Then
                    rptDoc.SetParameterValue("DateFormat", strDateFormat)
                End If

                'Parameter Values to format  Numbers for Localization
                If Not rptDoc.ParameterFields("RPT_ML_DEC_SEP") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_ML_DEC_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportDecimalSeperator"))
                End If
                If Not rptDoc.ParameterFields("RPT_ML_THOU_SEP") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_ML_THOU_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportThousandSeperator"))
                End If
                If Not rptDoc.ParameterFields("RPT_NO_OF_DIGITS") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_NO_OF_DIGITS", System.Configuration.ConfigurationManager.AppSettings("DecimalPlaces"))
                End If
                CrViewer1.ReportSource = rptDoc
                Exit Sub
            ElseIf strReportName = "WorkOrderSpares" Then
                Dim rptUtil As CoreLibrary.CARS.Utilities.ReportUtil = CoreLibrary.CARS.Utilities.ReportUtil.CreateReportUtilObject(strServerMapPath)
                Dim woxml As String = Nothing
                rptDoc = rptUtil.CreateReport(connString, "WorkOrderSpares.rpt", woxml)
                rptDoc.SetParameterValue("WorkOrderNo", Session("WOPR").ToString() + Session("WONO").ToString())
                rptDoc.SetParameterValue("@ID_WO_NO", Session("WONO"))
                rptDoc.SetParameterValue("@ID_WO_PREFIX", Session("WOPR"))
                If IsDBNull(Session("WOJobNo")) Or Session("WOJobNo") Is Nothing Then
                    rptDoc.SetParameterValue("JobNo", 0)
                Else
                    rptDoc.SetParameterValue("JobNo", Convert.ToInt32(Session("WOJobNo").ToString()))
                End If

                blRetval = ParameterFill(strReportName, rptDoc)
                If (blRetval = False) Then
                    Exit Sub
                End If
                rptDoc.SetParameterValue("DateFormat", strDateFormat)
                'Parameter Values to format  Numbers for Localization
                If Not rptDoc.ParameterFields("RPT_ML_DEC_SEP") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_ML_DEC_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportDecimalSeperator"))
                End If
                If Not rptDoc.ParameterFields("RPT_ML_THOU_SEP") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_ML_THOU_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportThousandSeperator"))
                End If
                If Not rptDoc.ParameterFields("RPT_NO_OF_DIGITS") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_NO_OF_DIGITS", System.Configuration.ConfigurationManager.AppSettings("DecimalPlaces"))
                End If
                CrViewer1.ReportSource = rptDoc
                Exit Sub
            ElseIf strReportName = "OrderNotInvoiced" Then
                Dim objreportutil As CoreLibrary.CARS.Utilities.ReportUtil = CoreLibrary.CARS.Utilities.ReportUtil.CreateReportUtilObject(strServerMapPath)
                Dim strOrderNotInvoicedXML As String = Session("strOrderNotInvoicedRpt")
                crReportDocument = objreportutil.CreateReport(connString, "rptordernotinvoiced.rpt", strOrderNotInvoicedXML)
                blRetval = ParameterFill(strReportName, crReportDocument)
                If (blRetval = False) Then
                    Exit Sub
                End If
                crReportDocument.SetParameterValue("Dept", dsCurrrs.Tables(0).Rows(0)("Department").ToString())
                crReportDocument.SetParameterValue("Date", "")
                crReportDocument.SetParameterValue("Datec", dsCurrrs.Tables(0).Rows(0)("Date").ToString())
                crReportDocument.SetParameterValue("DateFormat", strDateFormat)
                'Parameter Values to format  Numbers for Localization
                If Not crReportDocument.ParameterFields("RPT_ML_DEC_SEP") Is Nothing Then
                    crReportDocument.SetParameterValue("RPT_ML_DEC_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportDecimalSeperator"))
                End If
                If Not crReportDocument.ParameterFields("RPT_ML_THOU_SEP") Is Nothing Then
                    crReportDocument.SetParameterValue("RPT_ML_THOU_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportThousandSeperator"))
                End If
                If Not crReportDocument.ParameterFields("RPT_NO_OF_DIGITS") Is Nothing Then
                    crReportDocument.SetParameterValue("RPT_NO_OF_DIGITS", System.Configuration.ConfigurationManager.AppSettings("DecimalPlaces"))
                End If
                'End
                CrViewer1.ReportSource = crReportDocument
                'Session("dvSubsidiaryList") = Nothing
                Exit Sub

            ElseIf strReportName = "INVOICEPRINT" Then
                strReportId = Guid.NewGuid().ToString
                Dim objreportutil As CoreLibrary.CARS.Utilities.ReportUtil = CoreLibrary.CARS.Utilities.ReportUtil.CreateReportUtilObject(strServerMapPath)
                Dim invoiceType As String
                If (Request.QueryString("InvoiceType").Trim = "INVOICEBASIS") Then
                    invoiceType = "INVOICEBASIS"
                ElseIf (Request.QueryString("InvoiceType").Trim = "INVOICE") Then
                    invoiceType = "INVOICE" 'fnDecryptQString("InvoiceType")
                ElseIf (Request.QueryString("InvoiceType").Trim = "CreditNote") Then
                    invoiceType = "CreditNote" 'fnDecryptQString("InvoiceType")
                ElseIf (Request.QueryString("InvoiceType").Trim = "WOJobCard") Then
                    invoiceType = "WOJobCard" 'fnDecryptQString("InvoiceType")
                Else
                    invoiceType = fnDecryptQString("InvoiceType")
                End If

                HttpContext.Current.Session("Rpt_InvoiceType") = invoiceType

                'invoiceType = fnDecryptQString("InvoiceType")
                Dim ss3invoiceType As String = ""
                ss3invoiceType = fnDecryptQString("SS3InvoiceType")
                If ss3invoiceType Is Nothing Then
                    ss3invoiceType = ""
                End If
                If (HttpContext.Current.Session("RptType").ToString() <> "WOJobCard") Then
                    If (invoiceType.Equals("INVOICEBASIS")) Then
                        If ss3invoiceType.ToUpper.Equals("SS3INVOICEBASIS") Then
                            rptDoc = objreportutil.CreateReportForInvoicePrint(connString, "Invoice_WorkOrder_SS3InvBasis.rpt", HttpContext.Current.Session("xmlInvNos").ToString(), HttpContext.Current.Session("RptType").ToString())
                        Else
                            'rptDoc = objreportutil.CreateReportForInvoicePrint(connString, "TestInvBasis.rpt", HttpContext.Current.Session("xmlInvNos").ToString(), HttpContext.Current.Session("RptType").ToString())
                            rptDoc = objreportutil.CreateReportForInvoicePrint(connString, "WorkOrderInvoiceBasis.rpt", HttpContext.Current.Session("xmlInvNos").ToString(), HttpContext.Current.Session("RptType").ToString())
                        End If
                    ElseIf (invoiceType.Equals("INVOICE")) Then
                        If ss3invoiceType.ToUpper.Equals("SS3INVOICE") Then
                            rptDoc = objreportutil.CreateReportForInvoicePrint(connString, "Invoice_WorkOrder_SS3Invoice.rpt", HttpContext.Current.Session("xmlInvNos").ToString(), HttpContext.Current.Session("RptType").ToString())
                        Else
                            'rptDoc = objreportutil.CreateReportForInvoicePrint(connString, "Invoice_WorkOrder_SS2Invoice.rpt", HttpContext.Current.Session("xmlInvNos").ToString(), HttpContext.Current.Session("RptType").ToString())
                            rptDoc = objreportutil.CreateReportForInvoicePrint(connString, "WorkOrderInvoice.rpt", HttpContext.Current.Session("xmlInvNos").ToString(), HttpContext.Current.Session("RptType").ToString())
                        End If
                    ElseIf (invoiceType.Equals("CashInvoice")) Then
                        If ss3invoiceType.ToUpper.Equals("SS3CASHINVOICE") Then ' Cash Invoice is same as Invoice
                            rptDoc = objreportutil.CreateReportForInvoicePrint(connString, "Invoice_WorkOrder_SS3Invoice.rpt", HttpContext.Current.Session("xmlInvNos").ToString(), HttpContext.Current.Session("RptType").ToString())
                        Else
                            'rptDoc = objreportutil.CreateReportForInvoicePrint(connString, "Invoice_WorkOrder_SS2Invoice.rpt", HttpContext.Current.Session("xmlInvNos").ToString(), HttpContext.Current.Session("RptType").ToString())
                            rptDoc = objreportutil.CreateReportForInvoicePrint(connString, "WorkOrderInvoice.rpt", HttpContext.Current.Session("xmlInvNos").ToString(), HttpContext.Current.Session("RptType").ToString())
                        End If
                    ElseIf (invoiceType.Equals("Proposal")) Then
                        If (ss3invoiceType.ToUpper.Equals("SS3PROPOSAL")) Then
                            rptDoc = objreportutil.CreateReportForInvoicePrint(connString, "Invoice_WorkOrder_SS3Proposal.rpt", HttpContext.Current.Session("xmlInvNos").ToString(), HttpContext.Current.Session("RptType").ToString())
                        Else
                            rptDoc = objreportutil.CreateReportForInvoicePrint(connString, "Invoice_WorkOrder_Proposal.rpt", HttpContext.Current.Session("xmlInvNos").ToString(), HttpContext.Current.Session("RptType").ToString())
                        End If
                    ElseIf (invoiceType.Equals("CreditNote")) Then
                        If ss3invoiceType.ToUpper.Equals("SS3CREDITNOTE") Then
                            rptDoc = objreportutil.CreateReportForInvoicePrint(connString, "Invoice_WorkOrder_SS3CreditNote.rpt", Session("xmlInvNos").ToString(), Session("RptType").ToString())
                        Else
                            'rptDoc = objreportutil.CreateReportForInvoicePrint(connString, "Invoice_WorkOrder_CreditNote.rpt", Session("xmlInvNos").ToString(), Session("RptType").ToString())
                            rptDoc = objreportutil.CreateReportForInvoicePrint(connString, "WorkOrderCreditNote.rpt", Session("xmlInvNos").ToString(), Session("RptType").ToString())
                        End If
                    ElseIf (invoiceType.Equals("OrderConfirmation")) Then
                        If ss3invoiceType.ToUpper.Equals("SS3ORDERCONFIRMATION") Then
                            rptDoc = objreportutil.CreateReportForInvoicePrint(connString, "Invoice_WorkOrder_SS3OrdConfirmation.rpt", HttpContext.Current.Session("xmlInvNos").ToString(), HttpContext.Current.Session("RptType").ToString())
                        Else
                            rptDoc = objreportutil.CreateReportForInvoicePrint(connString, "Invoice_WorkOrder_OrdConfirmation.rpt", HttpContext.Current.Session("xmlInvNos").ToString(), HttpContext.Current.Session("RptType").ToString())
                        End If
                    End If
                Else
                    If Session("USEJOBCARD") <> Nothing Then
                        If CType(Session("USEJOBCARD"), Boolean) = False Then
                            rptDoc = objreportutil.CreateReportForInvoicePrint(connString, "WorkOrderInvoice_JobCard.rpt", HttpContext.Current.Session("xmlInvNos").ToString(), HttpContext.Current.Session("RptType").ToString())

                        Else
                            rptDoc = objreportutil.CreateReportForInvoicePrint(connString, "WorkOrderInvoice_JobCard.rpt", HttpContext.Current.Session("xmlInvNos").ToString(), HttpContext.Current.Session("RptType").ToString())
                        End If
                    Else
                        rptDoc = objreportutil.CreateReportForInvoicePrint(connString, "Invoice_WorkOrder_JCard.rpt", HttpContext.Current.Session("xmlInvNos").ToString(), HttpContext.Current.Session("RptType").ToString())
                    End If
                End If
                If (Request.QueryString("InvoiceType").Trim = "INVOICEBASIS") Then
                    invoiceType = "INVOICEBASIS"
                ElseIf (Request.QueryString("InvoiceType").Trim = "INVOICE") Then
                    invoiceType = "INVOICE" 'fnDecryptQString("InvoiceType")
                ElseIf (Request.QueryString("InvoiceType").Trim = "CreditNote") Then
                    invoiceType = "CreditNote" 'fnDecryptQString("InvoiceType")
                Else
                    invoiceType = fnDecryptQString("InvoiceType")
                End If
                'invoiceType = "INVOICEBASIS" 'fnDecryptQString("InvoiceType")
                Dim cfSubsidiary As New CARS.CoreLibrary.CARS.Department.ConfigDepartmentDO   'Fetch_Role1
                Dim objConfigDeptBO As New ConfigDepartmentBO
                objConfigDeptBO.LoginId = Session("UserID")
                Dim userInfo As DataSet = cfSubsidiary.Fetch_Role1(objConfigDeptBO)
                Dim subsidiary As String = IIf(userInfo.Tables(0).Rows(0)("ID_SUBSIDERY_USER") Is DBNull.Value, Nothing, userInfo.Tables(0).Rows(0)("ID_SUBSIDERY_USER"))
                HttpContext.Current.Session("subsidiary") = subsidiary
                Dim department As String = IIf(userInfo.Tables(0).Rows(0)("ID_DEPT_USER") Is DBNull.Value, Nothing, userInfo.Tables(0).Rows(0)("ID_DEPT_USER"))
                HttpContext.Current.Session("department") = department
                Dim _reportsettings As New ABS10SS3DO.ReportSettings()
                Dim _settings As DataSet
                With _reportsettings
                    .ReportID = strReportName
                    .Department = department
                    .Subsidiary = subsidiary
                    .OrderType = invoiceType
                    _settings = .LoadDisplaySettings
                End With
                If invoiceType.Equals("INVOICEBASIS") Then
                    rptDoc.SetParameterValue("IsInvoiceBasis", True)
                Else
                    rptDoc.SetParameterValue("IsInvoiceBasis", False)
                End If
                If invoiceType.Equals("CreditNote") Then
                    rptDoc.SetParameterValue("IsCreditNote", True)
                Else
                    rptDoc.SetParameterValue("IsCreditNote", False)
                End If
                If Not Request.QueryString("InvPrintCopy") Is Nothing Then
                    rptDoc.SetParameterValue("InvPrintCopy", "Copy")
                Else
                    rptDoc.SetParameterValue("InvPrintCopy", String.Empty)
                End If

                If _settings.Tables(0).Rows.Count > 0 Then
                    For Each dr As DataRow In _settings.Tables(0).Rows
                        If dr("TYPE").ToString = "F" Then
                            rptDoc.SetParameterValue(dr("NAME").ToString, dr("DISPLAY").ToString)
                            If dr("NAME").ToString().Equals("INVOICENAMEFROM") Then
                                rptDoc.SetParameterValue(dr("NAME").ToString, IIf(dr("ALTERNATETEXT") Is DBNull.Value, "", dr("ALTERNATETEXT").ToString()))
                            End If
                        Else
                            If dr("NAME").ToString.Substring(0, 4) = "SHOW" Then
                                rptDoc.SetParameterValue(dr("NAME").ToString, True)
                            ElseIf dr("NAME").ToString() <> "INVOICENAMEFROM" Then
                                rptDoc.SetParameterValue(dr("NAME").ToString, True)
                            End If


                            If dr("NAME").ToString().Equals("INVOICENAMEFROM") Then
                                rptDoc.SetParameterValue("INVOICENAMEFROM", "DEPARTMENT")
                            End If
                        End If
                    Next
                Else
                    For Each pf As ParameterField In rptDoc.ParameterFields
                        If pf.Name.Substring(0, 4) = "SHOW" Then
                            rptDoc.SetParameterValue(pf.Name, True)
                        Else
                            rptDoc.SetParameterValue(pf.Name, True)
                        End If
                    Next
                End If

                If _settings.Tables(1).Rows.Count > 0 Then
                    For Each dr As DataRow In _settings.Tables(1).Rows
                        rptDoc.SetParameterValue("SHOW" + dr("DISPLAYAREA").ToString + "IMAGE", dr("DISPLAY").ToString)
                        rptDoc.SetParameterValue(dr("DISPLAYAREA").ToString + "IMAGEALIGN", dr("ALIGN").ToString)
                    Next
                Else
                    rptDoc.SetParameterValue("SHOWLOGOIMAGE", True)
                    rptDoc.SetParameterValue("LOGOIMAGEALIGN", "L")
                    rptDoc.SetParameterValue("SHOWFOOTERIMAGE", True)
                    rptDoc.SetParameterValue("FOOTERIMAGEALIGN", "L")
                End If

                If _settings.Tables(2).Rows.Count > 0 Then
                    strRpt = _settings.Tables(2).Rows(0)("CAPTION")
                Else
                    strRpt = invoiceType
                    checkInvoiceCaption = False
                End If

                If strReportName.Equals("INVOICEPRINT") Then
                    rptDoc.SetParameterValue("TXT_HEADER", strRpt)
                End If
                strLanguage = ConfigurationManager.AppSettings("Language").ToString
                Dim dsMulrs As New DataSet
                Dim objMultiLangBO As New MultiLingualBO
                objMultiLangBO.LangName = strLanguage
                objMultiLangBO.ScreenName = strReportName
                dsMulrs = objrepAcc.Fetch_multilingual(objMultiLangBO)
                If dsMulrs.Tables(0).Rows.Count > 0 Then
                    Dim rowCount As Integer = Integer.MinValue
                    For rowCount = 0 To dsMulrs.Tables(0).Rows.Count - 1
                        rptDoc.SetParameterValue(dsMulrs.Tables(0).Rows(rowCount)("Rpt_Fieldname").ToString(), dsMulrs.Tables(0).Rows(rowCount)("rpt_description").ToString())
                    Next
                    rptDoc.SetParameterValue("DateFormat", strDateFormat)
                End If
                If strReportName.Equals("INVOICEPRINT") Then
                    rptDoc.SetParameterValue("TXT_HEADER", strRpt)

                End If
                If Not rptDoc.ParameterFields("RPT_ML_DEC_SEP") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_ML_DEC_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportDecimalSeperator"))
                End If
                If Not rptDoc.ParameterFields("RPT_ML_THOU_SEP") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_ML_THOU_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportThousandSeperator"))
                End If
                If Not rptDoc.ParameterFields("RPT_NO_OF_DIGITS") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_NO_OF_DIGITS", System.Configuration.ConfigurationManager.AppSettings("DecimalPlaces"))
                End If
                Dim strFilename As String = strTempPath + strReportId + ".rpt"
                dsMulrs.Tables(0).DefaultView.RowFilter = "rpt_fieldname='TXT_HEADER'"
                If dsMulrs.Tables(0).DefaultView.Count > 0 Then
                    Page.Title = dsMulrs.Tables(0).DefaultView.Item(0).Item("rpt_description").ToString
                End If
                If checkInvoiceCaption = False Then
                    If strReportName.Equals("INVOICEPRINT") Then
                        rptDoc.SetParameterValue("TXT_HEADER", Page.Title)
                    End If
                End If
                rptDoc.ExportToDisk(ExportFormatType.CrystalReport, strFilename)

                Dim DsUser As New DataSet
                objLoginBO.UserId = Session("UserId")
                DsUser = objLoginDO.GetPageAcess(objLoginBO)
                If DsUser.Tables.Count > 6 And DsUser.Tables(6).Rows.Count > 0 Then
                    Session("InvPDF") = DsUser.Tables(6).Rows(0)("DESCRIPTION")
                Else
                    Session("InvPDF") = Nothing
                End If

                Dim strFilePath As String = System.Configuration.ConfigurationManager.AppSettings("InvoiceExportPath")
                If strReportName.Equals("INVOICEPRINT") Then
                    Dim newLogDir As DirectoryInfo
                    newLogDir = New DirectoryInfo(strFilePath)
                    If Not newLogDir.Exists() Then
                        newLogDir.Create()
                    End If
                    Try
                        Dim strXML As String = CStr(Session("xmlInvNos")).ToString()
                        Dim objXML As New XmlDocument
                        objXML.LoadXml(strXML)
                        Dim xmlNode As XmlNodeList = objXML.SelectNodes("//ID_INV_NO")
                        If Session("Tot") < 0 Then
                            Dim str As String = String.Empty

                            If Session("InvPDF") = "True" Then
                                Dim strTempPath As String = strFilePath
                                Dim strFile As String = xmlNode(0).Attributes("ID_INV_NO").Value.ToString.Trim + ".pdf"
                                rptDoc.ExportToDisk(ExportFormatType.PortableDocFormat, strFilePath + xmlNode(0).Attributes("ID_INV_NO").Value.ToString.Trim + ".pdf")
                                If File.Exists(strTempPath + strFile) Then
                                    Dim client As Net.WebClient = New Net.WebClient()
                                    Response.ContentType = "application/pdf"
                                    Response.AppendHeader("Content-Disposition", "inline;filename=" + strFile)
                                    Response.TransmitFile(strTempPath + strFile)
                                    Response.Flush()
                                    Response.Close()
                                    Page.Title = "Report"
                                End If
                            Else
                                rptDoc.ExportToDisk(ExportFormatType.PortableDocFormat, strFilePath + xmlNode(0).Attributes("ID_INV_NO").Value.ToString.Trim + ".pdf")
                            End If
                        End If
                        If (xmlNode.Count > 1 And strReportName = "INVOICEPRINT") Then
                            If Session("InvPDF") = "True" Then
                                Dim strTempPath As String = strFilePath
                                Dim strFile As String = xmlNode(0).Attributes("ID_INV_NO").Value.ToString.Trim + ".pdf"
                                rptDoc.ExportToDisk(ExportFormatType.PortableDocFormat, strFilePath + xmlNode(0).Attributes("ID_INV_NO").Value.ToString.Trim + ".pdf")
                                If File.Exists(strTempPath + strFile) Then
                                    Dim client As Net.WebClient = New Net.WebClient()
                                    Response.ContentType = "application/pdf"
                                    Response.AppendHeader("Content-Disposition", "inline;filename=" + strFile)
                                    Response.TransmitFile(strTempPath + strFile)
                                    Response.Flush()
                                    Response.Close()
                                    Page.Title = "Report"
                                End If
                            Else
                                rptDoc.ExportToDisk(ExportFormatType.PortableDocFormat, strFilePath + xmlNode(0).Attributes("ID_INV_NO").Value.ToString.Trim + ".pdf")
                            End If
                        ElseIf xmlNode.Count > 1 Then
                            ThreadPool.QueueUserWorkItem(New WaitCallback(AddressOf GeneratePDF))
                        Else
                            Dim str As String = String.Empty
                            If Session("RptType").ToString <> "WOJobCard" Then
                                '378
                                If Session("InvPDF") = "True" Then
                                    Dim strTempPath As String = strFilePath
                                    Dim strFile As String = xmlNode(0).Attributes("ID_INV_NO").Value.ToString.Trim + ".pdf"
                                    If File.Exists(strTempPath + strFile) Then
                                        Dim client As Net.WebClient = New Net.WebClient()
                                        Response.ContentType = "application/pdf"
                                        Response.AppendHeader("Content-Disposition", "inline;filename=" + strFile)
                                        Response.TransmitFile(strTempPath + strFile)
                                        Response.Flush()
                                        Response.Close()
                                        Page.Title = "Report"
                                    Else
                                        rptDoc.ExportToDisk(ExportFormatType.PortableDocFormat, strFilePath + xmlNode(0).Attributes("ID_INV_NO").Value.ToString.Trim + ".pdf")
                                        If File.Exists(strTempPath + strFile) Then
                                            Dim client As Net.WebClient = New Net.WebClient()
                                            Response.ContentType = "application/pdf"
                                            Response.AppendHeader("Content-Disposition", "inline;filename=" + strFile)
                                            Response.TransmitFile(strTempPath + strFile)
                                            Response.Flush()
                                            Response.Close()
                                            Page.Title = "Report"
                                        End If
                                    End If
                                Else
                                    rptDoc.ExportToDisk(ExportFormatType.PortableDocFormat, strFilePath + xmlNode(0).Attributes("ID_INV_NO").Value.ToString.Trim + ".pdf")
                                End If
                            Else
                                Dim strTempPath As String = System.Configuration.ConfigurationManager.AppSettings("InvoiceExportPath")
                                Dim strFile As String = Request.QueryString("scrid").ToString.Trim + ".pdf"
                                'Dim strFile As String = fnDecryptQString("scrid")

                                If Request.QueryString("JobCardSett").ToString.Trim = "1" Then
                                    If File.Exists(strTempPath + strFile) Then
                                        'Delete
                                        File.Delete(strTempPath + strFile)
                                        'Insert
                                        rptDoc.ExportToDisk(ExportFormatType.PortableDocFormat, strFilePath + xmlNode(0).Attributes("ID_INV_NO").Value.ToString.Trim + ".pdf")
                                        If File.Exists(strTempPath + strFile) Then
                                            Dim client As Net.WebClient = New Net.WebClient()
                                            Response.ContentType = "application/pdf"
                                            Response.AppendHeader("Content-Disposition", "inline;filename=" + strFile)
                                            Response.TransmitFile(strTempPath + strFile)
                                            Response.Flush()
                                            Response.Close()
                                            Page.Title = "Report"
                                        End If
                                    Else
                                        'Insert
                                        rptDoc.ExportToDisk(ExportFormatType.PortableDocFormat, strFilePath + xmlNode(0).Attributes("ID_INV_NO").Value.ToString.Trim + ".pdf")
                                        If File.Exists(strTempPath + strFile) Then
                                            Dim client As Net.WebClient = New Net.WebClient()
                                            Response.ContentType = "application/pdf"
                                            Response.AppendHeader("Content-Disposition", "inline;filename=" + strFile)
                                            Response.TransmitFile(strTempPath + strFile)
                                            Response.Flush()
                                            Response.Close()
                                            Page.Title = "Report"
                                        End If
                                    End If
                                Else
                                    rptDoc.ExportToDisk(ExportFormatType.PortableDocFormat, strFilePath + xmlNode(0).Attributes("ID_INV_NO").Value.ToString.Trim + ".pdf")
                                End If
                            End If
                        End If
                    Catch ex As Exception
                        Dim oErrHandle As New MSGCOMMON.MsgErrorHndlr
                        oErrHandle.WriteErrorLog("1", "Reports_frmShowReports", "Export PDF", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, "UserID")
                    End Try
                End If


                CrViewer1.ReportSource = rptDoc
                'rptDoc.ExportToDisk(ExportFormatType.CrystalReport, strFilename)
                Exit Sub
            ElseIf strReportName = "TransactionReport" Then
                strReportId = Guid.NewGuid().ToString
                Dim objreportutil As CoreLibrary.CARS.Utilities.ReportUtil = CoreLibrary.CARS.Utilities.ReportUtil.CreateReportUtilObject(strServerMapPath)
                Dim transactionReportXML As String = String.Empty
                transactionReportXML = HttpContext.Current.Session("TransactionXML")
                rptDoc = objreportutil.CreateTransactionReport(connString, "TransactionReportExport.rpt", transactionReportXML)
                Dim dsMulrs As New DataSet
                Dim objMultiLangBO As New MultiLingualBO

                strLanguage = ConfigurationManager.AppSettings("Language").ToString
                objMultiLangBO.LangName = strLanguage
                objMultiLangBO.ScreenName = strReportName
                dsMulrs = objrepAcc.Fetch_multilingual(objMultiLangBO)
                If dsMulrs.Tables(0).Rows.Count > 0 Then
                    Dim intRowloop As Integer = Integer.MinValue
                    For intRowloop = 0 To dsMulrs.Tables(0).Rows.Count - 1
                        rptDoc.SetParameterValue(dsMulrs.Tables(0).Rows(intRowloop)("Rpt_Fieldname").ToString(), dsMulrs.Tables(0).Rows(intRowloop)("rpt_description").ToString())
                    Next
                    rptDoc.SetParameterValue("DateFormat", strDateFormat)
                End If
                If Not rptDoc.ParameterFields("RPT_ML_DEC_SEP") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_ML_DEC_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportDecimalSeperator"))
                End If
                If Not rptDoc.ParameterFields("RPT_ML_THOU_SEP") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_ML_THOU_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportThousandSeperator"))
                End If
                If Not rptDoc.ParameterFields("RPT_NO_OF_DIGITS") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_NO_OF_DIGITS", System.Configuration.ConfigurationManager.AppSettings("DecimalPlaces"))
                End If
                Dim strFilename As String = strTempPath + strReportId + ".rpt"

                dsMulrs.Tables(0).DefaultView.RowFilter = "rpt_fieldname='TXT_HEADER'"
                If dsMulrs.Tables(0).DefaultView.Count > 0 Then
                    Page.Title = dsMulrs.Tables(0).DefaultView.Item(0).Item("rpt_description").ToString
                End If

                If checkInvoiceCaption = False Then
                    If strReportName.Equals("INVOICEPRINT") Then
                        rptDoc.SetParameterValue("TXT_HEADER", Page.Title)
                    End If
                End If
                rptDoc.ExportToDisk(ExportFormatType.CrystalReport, strFilename)
                dsMulrs.Dispose()
                CrViewer1.ReportSource = rptDoc
            ElseIf strReportName = "ErrorInvoices" Then
                strReportId = Guid.NewGuid().ToString
                Dim objreportutil As CoreLibrary.CARS.Utilities.ReportUtil = CoreLibrary.CARS.Utilities.ReportUtil.CreateReportUtilObject(strServerMapPath)
                Dim errorInvoicesXML As String = String.Empty
                errorInvoicesXML = HttpContext.Current.Session("errorInvoicesXML")
                rptDoc = objreportutil.CreateTransactionReport(connString, "rptErrorInvoices.rpt", errorInvoicesXML)
                Dim dsMulrs As New DataSet
                Dim objMultiLangBO As New MultiLingualBO

                strLanguage = ConfigurationManager.AppSettings("Language").ToString
                objMultiLangBO.LangName = strLanguage
                objMultiLangBO.ScreenName = strReportName
                dsMulrs = objrepAcc.Fetch_multilingual(objMultiLangBO)
                If dsMulrs.Tables(0).Rows.Count > 0 Then
                    Dim intRowloop As Integer = Integer.MinValue
                    For intRowloop = 0 To dsMulrs.Tables(0).Rows.Count - 1
                        rptDoc.SetParameterValue(dsMulrs.Tables(0).Rows(intRowloop)("Rpt_Fieldname").ToString(), dsMulrs.Tables(0).Rows(intRowloop)("rpt_description").ToString())
                    Next
                    rptDoc.SetParameterValue("DateFormat", strDateFormat)
                End If
                If Not rptDoc.ParameterFields("RPT_ML_DEC_SEP") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_ML_DEC_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportDecimalSeperator"))
                End If
                If Not rptDoc.ParameterFields("RPT_ML_THOU_SEP") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_ML_THOU_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportThousandSeperator"))
                End If
                If Not rptDoc.ParameterFields("RPT_NO_OF_DIGITS") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_NO_OF_DIGITS", System.Configuration.ConfigurationManager.AppSettings("DecimalPlaces"))
                End If
                Dim strFilename As String = strTempPath + strReportId + ".rpt"
                dsMulrs.Tables(0).DefaultView.RowFilter = "rpt_fieldname='TXT_HEADER'"
                If dsMulrs.Tables(0).DefaultView.Count > 0 Then
                    Page.Title = dsMulrs.Tables(0).DefaultView.Item(0).Item("rpt_description").ToString
                End If
                If checkInvoiceCaption = False Then
                    If strReportName.Equals("INVOICEPRINT") Then
                        rptDoc.SetParameterValue("TXT_HEADER", Page.Title)
                    End If
                End If
                rptDoc.ExportToDisk(ExportFormatType.CrystalReport, strFilename)
                dsMulrs.Dispose()
                CrViewer1.ReportSource = rptDoc
            ElseIf strReportName = "SalesJournal" Then
                Dim objreportutil As CoreLibrary.CARS.Utilities.ReportUtil = CoreLibrary.CARS.Utilities.ReportUtil.CreateReportUtilObject(strServerMapPath)
                Dim SalesJournalXML As String = String.Empty
                SalesJournalXML = Session("SalesJournalPara")
                rptDoc = objreportutil.CreateReport(connString, "rptSalesJournal.rpt", SalesJournalXML)

                Dim dsMulrs As New DataSet
                Dim objMultiLangBO As New MultiLingualBO

                strLanguage = ConfigurationManager.AppSettings("Language").ToString
                objMultiLangBO.LangName = strLanguage
                objMultiLangBO.ScreenName = strReportName
                dsMulrs = objrepAcc.Fetch_multilingual(objMultiLangBO)

                If dsMulrs.Tables(0).Rows.Count > 0 Then
                    Dim intRowloop As Integer = Integer.MinValue
                    For intRowloop = 0 To dsMulrs.Tables(0).Rows.Count - 1
                        rptDoc.SetParameterValue(dsMulrs.Tables(0).Rows(intRowloop)("Rpt_Fieldname").ToString(), dsMulrs.Tables(0).Rows(intRowloop)("rpt_description").ToString())
                    Next
                    rptDoc.SetParameterValue("DateFormat", strDateFormat)

                End If

                rptDoc.SetParameterValue("Dept", dsCurrrs.Tables(0).Rows(0)("Department").ToString())
                rptDoc.SetParameterValue("Date", objCommonUtil.GetCurrentLanguageDate(Now.Date))
                ' rptDoc.SetParameterValue("TXT_HEADER", "SalesJournal")
                If dsCurrrs.Tables(0).Rows.Count > 0 Then
                    rptDoc.SetParameterValue("Datec", dsCurrrs.Tables(0).Rows(0)("Date").ToString())
                    rptDoc.SetParameterValue("Page", dsCurrrs.Tables(0).Rows(0)("PAGE").ToString())
                    rptDoc.SetParameterValue("Of", dsCurrrs.Tables(0).Rows(0)("OF").ToString())
                Else
                    rptDoc.SetParameterValue("DateC", "DATE:")
                    rptDoc.SetParameterValue("Page", "PAGE")
                    rptDoc.SetParameterValue("of", "OF")
                End If

                'Parameter Values to format  Numbers for Localization
                If Not rptDoc.ParameterFields("RPT_ML_DEC_SEP") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_ML_DEC_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportDecimalSeperator"))
                End If
                If Not rptDoc.ParameterFields("RPT_ML_THOU_SEP") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_ML_THOU_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportThousandSeperator"))
                End If
                If Not rptDoc.ParameterFields("RPT_NO_OF_DIGITS") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_NO_OF_DIGITS", System.Configuration.ConfigurationManager.AppSettings("DecimalPlaces"))
                End If
                'End
                CrViewer1.ReportSource = rptDoc
                Exit Sub

            ElseIf strReportName = "SalesJournalDI" Then
                Dim objreportutil As CoreLibrary.CARS.Utilities.ReportUtil = CoreLibrary.CARS.Utilities.ReportUtil.CreateReportUtilObject(strServerMapPath)
                Dim SalesJournalXML As String = String.Empty
                SalesJournalXML = Session("SalesJournalPara")
                rptDoc = objreportutil.CreateReport(connString, "rptSalesJournalDI.rpt", SalesJournalXML)
                Dim dsMulrs As New DataSet
                Dim objMultiLangBO As New MultiLingualBO

                strLanguage = ConfigurationManager.AppSettings("Language").ToString
                objMultiLangBO.LangName = strLanguage
                objMultiLangBO.ScreenName = strReportName
                dsMulrs = objrepAcc.Fetch_multilingual(objMultiLangBO)

                If dsMulrs.Tables(0).Rows.Count > 0 Then
                    Dim intRowloop As Integer = Integer.MinValue
                    For intRowloop = 0 To dsMulrs.Tables(0).Rows.Count - 1
                        rptDoc.SetParameterValue(dsMulrs.Tables(0).Rows(intRowloop)("Rpt_Fieldname").ToString(), dsMulrs.Tables(0).Rows(intRowloop)("rpt_description").ToString())
                    Next
                    rptDoc.SetParameterValue("DateFormat", strDateFormat)

                End If

                rptDoc.SetParameterValue("Dept", dsCurrrs.Tables(0).Rows(0)("Department").ToString())
                rptDoc.SetParameterValue("Date", objCommonUtil.GetCurrentLanguageDate(Now.Date))
                'rptDoc.SetParameterValue("TXT_HEADER", "SalesJournal")
                If dsCurrrs.Tables(0).Rows.Count > 0 Then
                    rptDoc.SetParameterValue("Datec", dsCurrrs.Tables(0).Rows(0)("Date").ToString())
                    rptDoc.SetParameterValue("Page", dsCurrrs.Tables(0).Rows(0)("PAGE").ToString())
                    rptDoc.SetParameterValue("Of", dsCurrrs.Tables(0).Rows(0)("OF").ToString())
                Else
                    rptDoc.SetParameterValue("DateC", "DATE:")
                    rptDoc.SetParameterValue("Page", "PAGE")
                    rptDoc.SetParameterValue("of", "OF")
                End If

                'Parameter Values to format  Numbers for Localization
                If Not rptDoc.ParameterFields("RPT_ML_DEC_SEP") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_ML_DEC_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportDecimalSeperator"))
                End If
                If Not rptDoc.ParameterFields("RPT_ML_THOU_SEP") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_ML_THOU_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportThousandSeperator"))
                End If
                If Not rptDoc.ParameterFields("RPT_NO_OF_DIGITS") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_NO_OF_DIGITS", System.Configuration.ConfigurationManager.AppSettings("DecimalPlaces"))
                End If
                'End
                CrViewer1.ReportSource = rptDoc
                Exit Sub
            ElseIf strReportName = "SalesJournalDP" Then
                Dim objreportutil As CoreLibrary.CARS.Utilities.ReportUtil = CoreLibrary.CARS.Utilities.ReportUtil.CreateReportUtilObject(strServerMapPath)
                Dim SalesJournalXML As String = String.Empty
                SalesJournalXML = Session("SalesJournalPara")
                rptDoc = objreportutil.CreateReport(connString, "rptSalesJournalDP.rpt", SalesJournalXML)
                Dim dsMulrs As New DataSet
                Dim objMultiLangBO As New MultiLingualBO

                strLanguage = ConfigurationManager.AppSettings("Language").ToString
                objMultiLangBO.LangName = strLanguage
                objMultiLangBO.ScreenName = strReportName
                dsMulrs = objrepAcc.Fetch_multilingual(objMultiLangBO)

                If dsMulrs.Tables(0).Rows.Count > 0 Then
                    Dim intRowloop As Integer = Integer.MinValue
                    For intRowloop = 0 To dsMulrs.Tables(0).Rows.Count - 1
                        rptDoc.SetParameterValue(dsMulrs.Tables(0).Rows(intRowloop)("Rpt_Fieldname").ToString(), dsMulrs.Tables(0).Rows(intRowloop)("rpt_description").ToString())
                    Next
                    rptDoc.SetParameterValue("DateFormat", strDateFormat)

                End If

                rptDoc.SetParameterValue("Dept", dsCurrrs.Tables(0).Rows(0)("Department").ToString())
                rptDoc.SetParameterValue("Date", objCommonUtil.GetCurrentLanguageDate(Now.Date))
                'rptDoc.SetParameterValue("TXT_HEADER", "SalesJournal")
                If dsCurrrs.Tables(0).Rows.Count > 0 Then
                    rptDoc.SetParameterValue("Datec", dsCurrrs.Tables(0).Rows(0)("Date").ToString())
                    rptDoc.SetParameterValue("Page", dsCurrrs.Tables(0).Rows(0)("PAGE").ToString())
                    rptDoc.SetParameterValue("Of", dsCurrrs.Tables(0).Rows(0)("OF").ToString())
                Else
                    rptDoc.SetParameterValue("DateC", "DATE:")
                    rptDoc.SetParameterValue("Page", "PAGE")
                    rptDoc.SetParameterValue("of", "OF")
                End If

                'Parameter Values to format  Numbers for Localization
                If Not rptDoc.ParameterFields("RPT_ML_DEC_SEP") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_ML_DEC_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportDecimalSeperator"))
                End If
                If Not rptDoc.ParameterFields("RPT_ML_THOU_SEP") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_ML_THOU_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportThousandSeperator"))
                End If
                If Not rptDoc.ParameterFields("RPT_NO_OF_DIGITS") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_NO_OF_DIGITS", System.Configuration.ConfigurationManager.AppSettings("DecimalPlaces"))
                End If
                'End
                CrViewer1.ReportSource = rptDoc
                Exit Sub

            ElseIf strReportName = "SalesPerMech" Then
                Dim objreportutil As CoreLibrary.CARS.Utilities.ReportUtil = CoreLibrary.CARS.Utilities.ReportUtil.CreateReportUtilObject(strServerMapPath)
                Dim salesPerMechXML As String = String.Empty
                salesPerMechXML = Session("SalesPerMechXML")
                rptDoc = objreportutil.CreateReport(connString, "rptSalesPerMechanic.rpt", salesPerMechXML)

                Dim dsMulrs As New DataSet
                Dim objMultiLangBO As New MultiLingualBO

                strLanguage = ConfigurationManager.AppSettings("Language").ToString
                objMultiLangBO.LangName = strLanguage
                objMultiLangBO.ScreenName = strReportName
                dsMulrs = objrepAcc.Fetch_multilingual(objMultiLangBO)

                If dsMulrs.Tables(0).Rows.Count > 0 Then
                    Dim intRowloop As Integer = Integer.MinValue
                    For intRowloop = 0 To dsMulrs.Tables(0).Rows.Count - 1
                        rptDoc.SetParameterValue(dsMulrs.Tables(0).Rows(intRowloop)("Rpt_Fieldname").ToString(), dsMulrs.Tables(0).Rows(intRowloop)("rpt_description").ToString())
                    Next
                    rptDoc.SetParameterValue("DateFormat", strDateFormat)

                End If

                rptDoc.SetParameterValue("Dept", dsCurrrs.Tables(0).Rows(0)("Department").ToString())
                rptDoc.SetParameterValue("Date", objCommonUtil.GetCurrentLanguageDate(Now.Date))
                If dsCurrrs.Tables(0).Rows.Count > 0 Then
                    rptDoc.SetParameterValue("Datec", dsCurrrs.Tables(0).Rows(0)("Date").ToString())
                    rptDoc.SetParameterValue("Page", dsCurrrs.Tables(0).Rows(0)("PAGE").ToString())
                    rptDoc.SetParameterValue("Of", dsCurrrs.Tables(0).Rows(0)("OF").ToString())
                Else
                    rptDoc.SetParameterValue("DateC", "DATE:")
                    rptDoc.SetParameterValue("Page", "PAGE")
                    rptDoc.SetParameterValue("of", "OF")
                End If

                'Parameter Values to format  Numbers for Localization
                If Not rptDoc.ParameterFields("RPT_ML_DEC_SEP") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_ML_DEC_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportDecimalSeperator"))
                End If
                If Not rptDoc.ParameterFields("RPT_ML_THOU_SEP") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_ML_THOU_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportThousandSeperator"))
                End If
                If Not rptDoc.ParameterFields("RPT_NO_OF_DIGITS") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_NO_OF_DIGITS", System.Configuration.ConfigurationManager.AppSettings("DecimalPlaces"))
                End If
                'End
                CrViewer1.ReportSource = rptDoc
                Exit Sub
            ElseIf strReportName = "SalesAnalysisReport1" Then
                Dim objreportutil As CoreLibrary.CARS.Utilities.ReportUtil = CoreLibrary.CARS.Utilities.ReportUtil.CreateReportUtilObject(strServerMapPath)
                Dim strSalesAnalysisXML As String = String.Empty
                strSalesAnalysisXML = Session("strSalesAnalysisXML")
                rptDoc = objreportutil.CreateReport(connString, "rptSalesAnalysisReport1.rpt", strSalesAnalysisXML)

                Dim dsMulrs As New DataSet
                Dim objMultiLangBO As New MultiLingualBO

                strLanguage = ConfigurationManager.AppSettings("Language").ToString
                objMultiLangBO.LangName = strLanguage
                objMultiLangBO.ScreenName = strReportName
                dsMulrs = objrepAcc.Fetch_multilingual(objMultiLangBO)

                If dsMulrs.Tables(0).Rows.Count > 0 Then
                    Dim intRowloop As Integer = Integer.MinValue
                    For intRowloop = 0 To dsMulrs.Tables(0).Rows.Count - 1
                        rptDoc.SetParameterValue(dsMulrs.Tables(0).Rows(intRowloop)("Rpt_Fieldname").ToString(), dsMulrs.Tables(0).Rows(intRowloop)("rpt_description").ToString())
                    Next
                    rptDoc.SetParameterValue("DateFormat", strDateFormat)

                End If

                rptDoc.SetParameterValue("Dept", dsCurrrs.Tables(0).Rows(0)("Department").ToString())
                rptDoc.SetParameterValue("Date", objCommonUtil.GetCurrentLanguageDate(Now.Date))

                If dsCurrrs.Tables(0).Rows.Count > 0 Then
                    rptDoc.SetParameterValue("Datec", dsCurrrs.Tables(0).Rows(0)("Date").ToString())
                    rptDoc.SetParameterValue("Page", dsCurrrs.Tables(0).Rows(0)("PAGE").ToString())
                    rptDoc.SetParameterValue("Of", dsCurrrs.Tables(0).Rows(0)("OF").ToString())
                Else
                    rptDoc.SetParameterValue("DateC", "DATE:")
                    rptDoc.SetParameterValue("Page", "PAGE")
                    rptDoc.SetParameterValue("of", "OF")
                End If

                'Parameter Values to format  Numbers for Localization
                If Not rptDoc.ParameterFields("RPT_ML_DEC_SEP") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_ML_DEC_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportDecimalSeperator"))
                End If
                If Not rptDoc.ParameterFields("RPT_ML_THOU_SEP") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_ML_THOU_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportThousandSeperator"))
                End If
                If Not rptDoc.ParameterFields("RPT_NO_OF_DIGITS") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_NO_OF_DIGITS", System.Configuration.ConfigurationManager.AppSettings("DecimalPlaces"))
                End If
                'End
                CrViewer1.ReportSource = rptDoc
                Exit Sub
            ElseIf strReportName = "SalesAnalysisReport2" Then
                Dim objreportutil As CoreLibrary.CARS.Utilities.ReportUtil = CoreLibrary.CARS.Utilities.ReportUtil.CreateReportUtilObject(strServerMapPath)
                Dim strSalesAnalysisXML As String = String.Empty
                strSalesAnalysisXML = Session("strSalesAnalysisXML")
                rptDoc = objreportutil.CreateReport(connString, "rptSalesAnalysisReport2.rpt", strSalesAnalysisXML)

                Dim dsMulrs As New DataSet
                Dim objMultiLangBO As New MultiLingualBO

                strLanguage = ConfigurationManager.AppSettings("Language").ToString
                objMultiLangBO.LangName = strLanguage
                objMultiLangBO.ScreenName = strReportName
                dsMulrs = objrepAcc.Fetch_multilingual(objMultiLangBO)

                If dsMulrs.Tables(0).Rows.Count > 0 Then
                    Dim intRowloop As Integer = Integer.MinValue
                    For intRowloop = 0 To dsMulrs.Tables(0).Rows.Count - 1
                        rptDoc.SetParameterValue(dsMulrs.Tables(0).Rows(intRowloop)("Rpt_Fieldname").ToString(), dsMulrs.Tables(0).Rows(intRowloop)("rpt_description").ToString())
                    Next
                    rptDoc.SetParameterValue("DateFormat", strDateFormat)

                End If

                rptDoc.SetParameterValue("Dept", dsCurrrs.Tables(0).Rows(0)("Department").ToString())
                rptDoc.SetParameterValue("Date", objCommonUtil.GetCurrentLanguageDate(Now.Date))

                If dsCurrrs.Tables(0).Rows.Count > 0 Then
                    rptDoc.SetParameterValue("Datec", dsCurrrs.Tables(0).Rows(0)("Date").ToString())
                    rptDoc.SetParameterValue("Page", dsCurrrs.Tables(0).Rows(0)("PAGE").ToString())
                    rptDoc.SetParameterValue("Of", dsCurrrs.Tables(0).Rows(0)("OF").ToString())
                Else
                    rptDoc.SetParameterValue("DateC", "DATE:")
                    rptDoc.SetParameterValue("Page", "PAGE")
                    rptDoc.SetParameterValue("of", "OF")
                End If

                'Parameter Values to format  Numbers for Localization
                If Not rptDoc.ParameterFields("RPT_ML_DEC_SEP") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_ML_DEC_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportDecimalSeperator"))
                End If
                If Not rptDoc.ParameterFields("RPT_ML_THOU_SEP") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_ML_THOU_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportThousandSeperator"))
                End If
                If Not rptDoc.ParameterFields("RPT_NO_OF_DIGITS") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_NO_OF_DIGITS", System.Configuration.ConfigurationManager.AppSettings("DecimalPlaces"))
                End If
                'End
                CrViewer1.ReportSource = rptDoc
                Exit Sub
            ElseIf strReportName = "HoursPerMech" Then
                Dim objreportutil As CoreLibrary.CARS.Utilities.ReportUtil = CoreLibrary.CARS.Utilities.ReportUtil.CreateReportUtilObject(strServerMapPath)
                Dim hoursPerMechXML As String = String.Empty
                hoursPerMechXML = Session("HoursPerMechXML")
                rptDoc = objreportutil.CreateReport(connString, "rptHrsPerMechanic.rpt", hoursPerMechXML)

                Dim dsMulrs As New DataSet
                Dim objMultiLangBO As New MultiLingualBO

                strLanguage = ConfigurationManager.AppSettings("Language").ToString
                objMultiLangBO.LangName = strLanguage
                objMultiLangBO.ScreenName = strReportName
                dsMulrs = objrepAcc.Fetch_multilingual(objMultiLangBO)

                If dsMulrs.Tables(0).Rows.Count > 0 Then
                    Dim intRowloop As Integer = Integer.MinValue
                    For intRowloop = 0 To dsMulrs.Tables(0).Rows.Count - 1
                        rptDoc.SetParameterValue(dsMulrs.Tables(0).Rows(intRowloop)("Rpt_Fieldname").ToString(), dsMulrs.Tables(0).Rows(intRowloop)("rpt_description").ToString())
                    Next
                    rptDoc.SetParameterValue("DateFormat", strDateFormat)

                End If

                rptDoc.SetParameterValue("Dept", dsCurrrs.Tables(0).Rows(0)("Department").ToString())
                rptDoc.SetParameterValue("Date", objCommonUtil.GetCurrentLanguageDate(Now.Date))

                If dsCurrrs.Tables(0).Rows.Count > 0 Then
                    rptDoc.SetParameterValue("Datec", dsCurrrs.Tables(0).Rows(0)("Date").ToString())
                    rptDoc.SetParameterValue("Page", dsCurrrs.Tables(0).Rows(0)("PAGE").ToString())
                    rptDoc.SetParameterValue("Of", dsCurrrs.Tables(0).Rows(0)("OF").ToString())
                Else
                    rptDoc.SetParameterValue("DateC", "DATE:")
                    rptDoc.SetParameterValue("Page", "PAGE")
                    rptDoc.SetParameterValue("of", "OF")
                End If

                'Parameter Values to format  Numbers for Localization
                If Not rptDoc.ParameterFields("RPT_ML_DEC_SEP") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_ML_DEC_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportDecimalSeperator"))
                End If
                If Not rptDoc.ParameterFields("RPT_ML_THOU_SEP") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_ML_THOU_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportThousandSeperator"))
                End If
                If Not rptDoc.ParameterFields("RPT_NO_OF_DIGITS") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_NO_OF_DIGITS", System.Configuration.ConfigurationManager.AppSettings("DecimalPlaces"))
                End If
                'End
                CrViewer1.ReportSource = rptDoc
                Exit Sub
            ElseIf strReportName = "Inspection" Then
                Dim objreportutil As CoreLibrary.CARS.Utilities.ReportUtil = CoreLibrary.CARS.Utilities.ReportUtil.CreateReportUtilObject(strServerMapPath)
                Dim inspectionXML As String = String.Empty
                inspectionXML = Session("InspectionXML")
                rptDoc = objreportutil.CreateReport(connString, "rptInspectionLog.rpt", inspectionXML)

                Dim dsMulrs As New DataSet
                Dim objMultiLangBO As New MultiLingualBO

                strLanguage = ConfigurationManager.AppSettings("Language").ToString
                objMultiLangBO.LangName = strLanguage
                objMultiLangBO.ScreenName = strReportName
                dsMulrs = objrepAcc.Fetch_multilingual(objMultiLangBO)

                If dsMulrs.Tables(0).Rows.Count > 0 Then
                    Dim intRowloop As Integer = Integer.MinValue
                    For intRowloop = 0 To dsMulrs.Tables(0).Rows.Count - 1
                        rptDoc.SetParameterValue(dsMulrs.Tables(0).Rows(intRowloop)("Rpt_Fieldname").ToString(), dsMulrs.Tables(0).Rows(intRowloop)("rpt_description").ToString())
                    Next
                    rptDoc.SetParameterValue("DateFormat", strDateFormat)

                End If

                rptDoc.SetParameterValue("Dept", dsCurrrs.Tables(0).Rows(0)("Department").ToString())
                rptDoc.SetParameterValue("Date", objCommonUtil.GetCurrentLanguageDate(Now.Date))

                If dsCurrrs.Tables(0).Rows.Count > 0 Then
                    rptDoc.SetParameterValue("Datec", dsCurrrs.Tables(0).Rows(0)("Date").ToString())
                    rptDoc.SetParameterValue("Page", dsCurrrs.Tables(0).Rows(0)("PAGE").ToString())
                    rptDoc.SetParameterValue("Of", dsCurrrs.Tables(0).Rows(0)("OF").ToString())
                Else
                    rptDoc.SetParameterValue("DateC", "DATE:")
                    rptDoc.SetParameterValue("Page", "PAGE")
                    rptDoc.SetParameterValue("of", "OF")
                End If

                'Parameter Values to format  Numbers for Localization
                If Not rptDoc.ParameterFields("RPT_ML_DEC_SEP") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_ML_DEC_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportDecimalSeperator"))
                End If
                If Not rptDoc.ParameterFields("RPT_ML_THOU_SEP") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_ML_THOU_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportThousandSeperator"))
                End If
                If Not rptDoc.ParameterFields("RPT_NO_OF_DIGITS") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_NO_OF_DIGITS", System.Configuration.ConfigurationManager.AppSettings("DecimalPlaces"))
                End If
                'End
                CrViewer1.ReportSource = rptDoc
                Exit Sub
            ElseIf strReportName = "FixedPriceAnalysis1" Then
                Dim objreportutil As CoreLibrary.CARS.Utilities.ReportUtil = CoreLibrary.CARS.Utilities.ReportUtil.CreateReportUtilObject(strServerMapPath)
                Dim strFixedPriceAnalysisXML As String = String.Empty
                strFixedPriceAnalysisXML = Session("strFixedPriceAnalysisXML")
                rptDoc = objreportutil.CreateReport(connString, "rptFixedPriceAnalyse1.rpt", strFixedPriceAnalysisXML)

                Dim dsMulrs As New DataSet
                Dim objMultiLangBO As New MultiLingualBO

                strLanguage = ConfigurationManager.AppSettings("Language").ToString
                objMultiLangBO.LangName = strLanguage
                objMultiLangBO.ScreenName = strReportName
                dsMulrs = objrepAcc.Fetch_multilingual(objMultiLangBO)

                If dsMulrs.Tables(0).Rows.Count > 0 Then
                    Dim intRowloop As Integer = Integer.MinValue
                    For intRowloop = 0 To dsMulrs.Tables(0).Rows.Count - 1
                        rptDoc.SetParameterValue(dsMulrs.Tables(0).Rows(intRowloop)("Rpt_Fieldname").ToString(), dsMulrs.Tables(0).Rows(intRowloop)("rpt_description").ToString())
                    Next
                    rptDoc.SetParameterValue("DateFormat", strDateFormat)

                End If

                rptDoc.SetParameterValue("Dept", dsCurrrs.Tables(0).Rows(0)("Department").ToString())
                rptDoc.SetParameterValue("Date", objCommonUtil.GetCurrentLanguageDate(Now.Date))

                If dsCurrrs.Tables(0).Rows.Count > 0 Then
                    rptDoc.SetParameterValue("Datec", dsCurrrs.Tables(0).Rows(0)("Date").ToString())
                    rptDoc.SetParameterValue("Page", dsCurrrs.Tables(0).Rows(0)("PAGE").ToString())
                    rptDoc.SetParameterValue("Of", dsCurrrs.Tables(0).Rows(0)("OF").ToString())
                Else
                    rptDoc.SetParameterValue("DateC", "DATE:")
                    rptDoc.SetParameterValue("Page", "PAGE")
                    rptDoc.SetParameterValue("of", "OF")
                End If

                'Parameter Values to format  Numbers for Localization
                If Not rptDoc.ParameterFields("RPT_ML_DEC_SEP") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_ML_DEC_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportDecimalSeperator"))
                End If
                If Not rptDoc.ParameterFields("RPT_ML_THOU_SEP") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_ML_THOU_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportThousandSeperator"))
                End If
                If Not rptDoc.ParameterFields("RPT_NO_OF_DIGITS") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_NO_OF_DIGITS", System.Configuration.ConfigurationManager.AppSettings("DecimalPlaces"))
                End If
                'End
                CrViewer1.ReportSource = rptDoc
                Exit Sub
            ElseIf strReportName = "FixedPriceAnalysis2" Then
                Dim objreportutil As CoreLibrary.CARS.Utilities.ReportUtil = CoreLibrary.CARS.Utilities.ReportUtil.CreateReportUtilObject(strServerMapPath)
                Dim strFixedPriceAnalysisXML As String = String.Empty
                strFixedPriceAnalysisXML = Session("strFixedPriceAnalysisXML")
                rptDoc = objreportutil.CreateReport(connString, "rptFixedPriceAnalyse2.rpt", strFixedPriceAnalysisXML)

                Dim dsMulrs As New DataSet
                Dim objMultiLangBO As New MultiLingualBO

                strLanguage = ConfigurationManager.AppSettings("Language").ToString
                objMultiLangBO.LangName = strLanguage
                objMultiLangBO.ScreenName = strReportName
                dsMulrs = objrepAcc.Fetch_multilingual(objMultiLangBO)

                If dsMulrs.Tables(0).Rows.Count > 0 Then
                    Dim intRowloop As Integer = Integer.MinValue
                    For intRowloop = 0 To dsMulrs.Tables(0).Rows.Count - 1
                        rptDoc.SetParameterValue(dsMulrs.Tables(0).Rows(intRowloop)("Rpt_Fieldname").ToString(), dsMulrs.Tables(0).Rows(intRowloop)("rpt_description").ToString())
                    Next
                    rptDoc.SetParameterValue("DateFormat", strDateFormat)

                End If

                rptDoc.SetParameterValue("Dept", dsCurrrs.Tables(0).Rows(0)("Department").ToString())
                rptDoc.SetParameterValue("Date", objCommonUtil.GetCurrentLanguageDate(Now.Date))

                If dsCurrrs.Tables(0).Rows.Count > 0 Then
                    rptDoc.SetParameterValue("Datec", dsCurrrs.Tables(0).Rows(0)("Date").ToString())
                    rptDoc.SetParameterValue("Page", dsCurrrs.Tables(0).Rows(0)("PAGE").ToString())
                    rptDoc.SetParameterValue("Of", dsCurrrs.Tables(0).Rows(0)("OF").ToString())
                Else
                    rptDoc.SetParameterValue("DateC", "DATE:")
                    rptDoc.SetParameterValue("Page", "PAGE")
                    rptDoc.SetParameterValue("of", "OF")
                End If

                'Parameter Values to format  Numbers for Localization
                If Not rptDoc.ParameterFields("RPT_ML_DEC_SEP") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_ML_DEC_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportDecimalSeperator"))
                End If
                If Not rptDoc.ParameterFields("RPT_ML_THOU_SEP") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_ML_THOU_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportThousandSeperator"))
                End If
                If Not rptDoc.ParameterFields("RPT_NO_OF_DIGITS") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_NO_OF_DIGITS", System.Configuration.ConfigurationManager.AppSettings("DecimalPlaces"))
                End If
                'End
                CrViewer1.ReportSource = rptDoc
                Exit Sub
            ElseIf strReportName = "LabourOnOrders" Then
                Dim objreportutil As CoreLibrary.CARS.Utilities.ReportUtil = CoreLibrary.CARS.Utilities.ReportUtil.CreateReportUtilObject(strServerMapPath)
                Dim labourOnOrdersXML As String = String.Empty
                labourOnOrdersXML = Session("xmlLabourOnOrders")
                rptDoc = objreportutil.CreateReport(connString, "rptLabourOnOrders.rpt", labourOnOrdersXML)

                Dim dsMulrs As New DataSet
                Dim objMultiLangBO As New MultiLingualBO

                strLanguage = ConfigurationManager.AppSettings("Language").ToString
                objMultiLangBO.LangName = strLanguage
                objMultiLangBO.ScreenName = strReportName
                dsMulrs = objrepAcc.Fetch_multilingual(objMultiLangBO)

                If dsMulrs.Tables(0).Rows.Count > 0 Then
                    Dim intRowloop As Integer = Integer.MinValue
                    For intRowloop = 0 To dsMulrs.Tables(0).Rows.Count - 1
                        rptDoc.SetParameterValue(dsMulrs.Tables(0).Rows(intRowloop)("Rpt_Fieldname").ToString(), dsMulrs.Tables(0).Rows(intRowloop)("rpt_description").ToString())
                    Next
                    rptDoc.SetParameterValue("DateFormat", strDateFormat)

                End If
               
                'End
                CrViewer1.ReportSource = rptDoc
                Exit Sub
            ElseIf strReportName = "CNSalesJournal" Then
                Dim objreportutil As CoreLibrary.CARS.Utilities.ReportUtil = CoreLibrary.CARS.Utilities.ReportUtil.CreateReportUtilObject(strServerMapPath)
                Dim strCNSalesJournalXML As String = String.Empty
                strCNSalesJournalXML = Session("CNSalesJournalXML")
                rptDoc = objreportutil.CreateReport(connString, "rptCNSalesJournal.rpt", strCNSalesJournalXML)

                Dim dsMulrs As New DataSet
                Dim objMultiLangBO As New MultiLingualBO

                strLanguage = ConfigurationManager.AppSettings("Language").ToString
                objMultiLangBO.LangName = strLanguage
                objMultiLangBO.ScreenName = strReportName
                dsMulrs = objrepAcc.Fetch_multilingual(objMultiLangBO)

                If dsMulrs.Tables(0).Rows.Count > 0 Then
                    Dim intRowloop As Integer = Integer.MinValue
                    For intRowloop = 0 To dsMulrs.Tables(0).Rows.Count - 1
                        rptDoc.SetParameterValue(dsMulrs.Tables(0).Rows(intRowloop)("Rpt_Fieldname").ToString(), dsMulrs.Tables(0).Rows(intRowloop)("rpt_description").ToString())
                    Next
                    rptDoc.SetParameterValue("DateFormat", strDateFormat)

                End If

                rptDoc.SetParameterValue("Dept", dsCurrrs.Tables(0).Rows(0)("Department").ToString())
                rptDoc.SetParameterValue("Date", objCommonUtil.GetCurrentLanguageDate(Now.Date))

                If dsCurrrs.Tables(0).Rows.Count > 0 Then
                    rptDoc.SetParameterValue("Datec", dsCurrrs.Tables(0).Rows(0)("Date").ToString())
                    ' rptDoc.SetParameterValue("Page", dsCurrrs.Tables(0).Rows(0)("PAGE").ToString())
                    ' rptDoc.SetParameterValue("Of", dsCurrrs.Tables(0).Rows(0)("OF").ToString())
                Else
                    rptDoc.SetParameterValue("DateC", "DATE:")
                    ' rptDoc.SetParameterValue("Page", "PAGE")
                    'rptDoc.SetParameterValue("of", "OF")
                End If

                'Parameter Values to format  Numbers for Localization
                If Not rptDoc.ParameterFields("RPT_ML_DEC_SEP") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_ML_DEC_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportDecimalSeperator"))
                End If
                If Not rptDoc.ParameterFields("RPT_ML_THOU_SEP") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_ML_THOU_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportThousandSeperator"))
                End If
                If Not rptDoc.ParameterFields("RPT_NO_OF_DIGITS") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_NO_OF_DIGITS", System.Configuration.ConfigurationManager.AppSettings("DecimalPlaces"))
                End If
                'End
                CrViewer1.ReportSource = rptDoc
                Exit Sub

            ElseIf strReportName = "CNSalesJournalDI" Then
                Dim objreportutil As CoreLibrary.CARS.Utilities.ReportUtil = CoreLibrary.CARS.Utilities.ReportUtil.CreateReportUtilObject(strServerMapPath)
                Dim strCNSalesJournalXML As String = String.Empty
                strCNSalesJournalXML = Session("CNSalesJournalXML")
                rptDoc = objreportutil.CreateReport(connString, "rptCNSalesJournalDI.rpt", strCNSalesJournalXML)

                Dim dsMulrs As New DataSet
                Dim objMultiLangBO As New MultiLingualBO

                strLanguage = ConfigurationManager.AppSettings("Language").ToString
                objMultiLangBO.LangName = strLanguage
                objMultiLangBO.ScreenName = strReportName
                dsMulrs = objrepAcc.Fetch_multilingual(objMultiLangBO)

                If dsMulrs.Tables(0).Rows.Count > 0 Then
                    Dim intRowloop As Integer = Integer.MinValue
                    For intRowloop = 0 To dsMulrs.Tables(0).Rows.Count - 1
                        rptDoc.SetParameterValue(dsMulrs.Tables(0).Rows(intRowloop)("Rpt_Fieldname").ToString(), dsMulrs.Tables(0).Rows(intRowloop)("rpt_description").ToString())
                    Next
                    rptDoc.SetParameterValue("DateFormat", strDateFormat)

                End If

                rptDoc.SetParameterValue("Dept", dsCurrrs.Tables(0).Rows(0)("Department").ToString())
                rptDoc.SetParameterValue("Date", objCommonUtil.GetCurrentLanguageDate(Now.Date))

                If dsCurrrs.Tables(0).Rows.Count > 0 Then
                    rptDoc.SetParameterValue("Datec", dsCurrrs.Tables(0).Rows(0)("Date").ToString())
                    rptDoc.SetParameterValue("Page", dsCurrrs.Tables(0).Rows(0)("PAGE").ToString())
                    rptDoc.SetParameterValue("Of", dsCurrrs.Tables(0).Rows(0)("OF").ToString())
                Else
                    rptDoc.SetParameterValue("DateC", "DATE:")
                    rptDoc.SetParameterValue("Page", "PAGE")
                    rptDoc.SetParameterValue("of", "OF")
                End If

                'Parameter Values to format  Numbers for Localization
                If Not rptDoc.ParameterFields("RPT_ML_DEC_SEP") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_ML_DEC_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportDecimalSeperator"))
                End If
                If Not rptDoc.ParameterFields("RPT_ML_THOU_SEP") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_ML_THOU_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportThousandSeperator"))
                End If
                If Not rptDoc.ParameterFields("RPT_NO_OF_DIGITS") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_NO_OF_DIGITS", System.Configuration.ConfigurationManager.AppSettings("DecimalPlaces"))
                End If
                'End
                CrViewer1.ReportSource = rptDoc
                Exit Sub
            ElseIf strReportName = "CNSalesJournalDP" Then
                Dim objreportutil As CoreLibrary.CARS.Utilities.ReportUtil = CoreLibrary.CARS.Utilities.ReportUtil.CreateReportUtilObject(strServerMapPath)
                Dim strCNSalesJournalXML As String = String.Empty
                strCNSalesJournalXML = Session("CNSalesJournalXML")
                rptDoc = objreportutil.CreateReport(connString, "rptCNSalesJournalDP.rpt", strCNSalesJournalXML)

                Dim dsMulrs As New DataSet
                Dim objMultiLangBO As New MultiLingualBO

                strLanguage = ConfigurationManager.AppSettings("Language").ToString
                objMultiLangBO.LangName = strLanguage
                objMultiLangBO.ScreenName = strReportName
                dsMulrs = objrepAcc.Fetch_multilingual(objMultiLangBO)

                If dsMulrs.Tables(0).Rows.Count > 0 Then
                    Dim intRowloop As Integer = Integer.MinValue
                    For intRowloop = 0 To dsMulrs.Tables(0).Rows.Count - 1
                        rptDoc.SetParameterValue(dsMulrs.Tables(0).Rows(intRowloop)("Rpt_Fieldname").ToString(), dsMulrs.Tables(0).Rows(intRowloop)("rpt_description").ToString())
                    Next
                    rptDoc.SetParameterValue("DateFormat", strDateFormat)

                End If

                rptDoc.SetParameterValue("Dept", dsCurrrs.Tables(0).Rows(0)("Department").ToString())
                rptDoc.SetParameterValue("Date", objCommonUtil.GetCurrentLanguageDate(Now.Date))

                If dsCurrrs.Tables(0).Rows.Count > 0 Then
                    rptDoc.SetParameterValue("Datec", dsCurrrs.Tables(0).Rows(0)("Date").ToString())
                    rptDoc.SetParameterValue("Page", dsCurrrs.Tables(0).Rows(0)("PAGE").ToString())
                    rptDoc.SetParameterValue("Of", dsCurrrs.Tables(0).Rows(0)("OF").ToString())
                Else
                    rptDoc.SetParameterValue("DateC", "DATE:")
                    rptDoc.SetParameterValue("Page", "PAGE")
                    rptDoc.SetParameterValue("of", "OF")
                End If

                'Parameter Values to format  Numbers for Localization
                If Not rptDoc.ParameterFields("RPT_ML_DEC_SEP") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_ML_DEC_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportDecimalSeperator"))
                End If
                If Not rptDoc.ParameterFields("RPT_ML_THOU_SEP") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_ML_THOU_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportThousandSeperator"))
                End If
                If Not rptDoc.ParameterFields("RPT_NO_OF_DIGITS") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_NO_OF_DIGITS", System.Configuration.ConfigurationManager.AppSettings("DecimalPlaces"))
                End If
                'End
                CrViewer1.ReportSource = rptDoc
                Exit Sub
            ElseIf strReportName = "InvoiceEmail" Then
                Dim objreportutil As CoreLibrary.CARS.Utilities.ReportUtil = CoreLibrary.CARS.Utilities.ReportUtil.CreateReportUtilObject(strServerMapPath)
                Dim invoiceEmailXML As String = String.Empty
                invoiceEmailXML = Session("InvEmailXML")
                rptDoc = objreportutil.CreateTransactionReport(connString, "rptEmailInvoices.rpt", invoiceEmailXML)

                Dim dsMulrs As New DataSet
                Dim objMultiLangBO As New MultiLingualBO

                strLanguage = ConfigurationManager.AppSettings("Language").ToString
                objMultiLangBO.LangName = strLanguage
                objMultiLangBO.ScreenName = strReportName
                dsMulrs = objrepAcc.Fetch_multilingual(objMultiLangBO)

                If dsMulrs.Tables(0).Rows.Count > 0 Then
                    Dim intRowloop As Integer = Integer.MinValue
                    For intRowloop = 0 To dsMulrs.Tables(0).Rows.Count - 1
                        rptDoc.SetParameterValue(dsMulrs.Tables(0).Rows(intRowloop)("Rpt_Fieldname").ToString(), dsMulrs.Tables(0).Rows(intRowloop)("rpt_description").ToString())
                    Next
                    rptDoc.SetParameterValue("DateFormat", strDateFormat)
                End If

                'Parameter Values to format  Numbers for Localization
                If Not rptDoc.ParameterFields("RPT_ML_DEC_SEP") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_ML_DEC_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportDecimalSeperator"))
                End If
                If Not rptDoc.ParameterFields("RPT_ML_THOU_SEP") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_ML_THOU_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportThousandSeperator"))
                End If
                If Not rptDoc.ParameterFields("RPT_NO_OF_DIGITS") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_NO_OF_DIGITS", System.Configuration.ConfigurationManager.AppSettings("DecimalPlaces"))
                End If
                'End
                CrViewer1.ReportSource = rptDoc
                Exit Sub
            ElseIf strReportName = "TimeRegCTPMech" Then
                Dim objreportutil As CoreLibrary.CARS.Utilities.ReportUtil = CoreLibrary.CARS.Utilities.ReportUtil.CreateReportUtilObject(strServerMapPath)
                Dim strTimeRegCTPMechXML As String = String.Empty
                strTimeRegCTPMechXML = Session("TimeRegCTPMechXML")
                rptDoc = objreportutil.CreateReport(connString, "rptTimeRegCTMech.rpt", strTimeRegCTPMechXML)

                Dim dsMulrs As New DataSet
                Dim objMultiLangBO As New MultiLingualBO

                strLanguage = ConfigurationManager.AppSettings("Language").ToString
                objMultiLangBO.LangName = strLanguage
                objMultiLangBO.ScreenName = strReportName
                dsMulrs = objrepAcc.Fetch_multilingual(objMultiLangBO)

                If dsMulrs.Tables(0).Rows.Count > 0 Then
                    Dim intRowloop As Integer = Integer.MinValue
                    For intRowloop = 0 To dsMulrs.Tables(0).Rows.Count - 1
                        rptDoc.SetParameterValue(dsMulrs.Tables(0).Rows(intRowloop)("Rpt_Fieldname").ToString(), dsMulrs.Tables(0).Rows(intRowloop)("rpt_description").ToString())
                    Next
                    rptDoc.SetParameterValue("DateFormat", strDateFormat)
                End If

                'Parameter Values to format  Numbers for Localization
                If Not rptDoc.ParameterFields("RPT_ML_DEC_SEP") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_ML_DEC_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportDecimalSeperator"))
                End If
                If Not rptDoc.ParameterFields("RPT_ML_THOU_SEP") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_ML_THOU_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportThousandSeperator"))
                End If
                If Not rptDoc.ParameterFields("RPT_NO_OF_DIGITS") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_NO_OF_DIGITS", System.Configuration.ConfigurationManager.AppSettings("DecimalPlaces"))
                End If
                'End
                CrViewer1.ReportSource = rptDoc
                Exit Sub
            ElseIf strReportName = "TimeRegMech" Then
                Dim objreportutil As CoreLibrary.CARS.Utilities.ReportUtil = CoreLibrary.CARS.Utilities.ReportUtil.CreateReportUtilObject(strServerMapPath)
                Dim strTimeRegMechXML As String = String.Empty
                strTimeRegMechXML = Session("TimeRegMechXML")
                rptDoc = objreportutil.CreateReport(connString, "rptTimeRegMech.rpt", strTimeRegMechXML)

                Dim dsMulrs As New DataSet
                Dim objMultiLangBO As New MultiLingualBO

                strLanguage = ConfigurationManager.AppSettings("Language").ToString
                objMultiLangBO.LangName = strLanguage
                objMultiLangBO.ScreenName = "TimeRegCTPMech" 'strReportName
                dsMulrs = objrepAcc.Fetch_multilingual(objMultiLangBO)

                If dsMulrs.Tables(0).Rows.Count > 0 Then
                    Dim intRowloop As Integer = Integer.MinValue
                    For intRowloop = 0 To dsMulrs.Tables(0).Rows.Count - 1
                        rptDoc.SetParameterValue(dsMulrs.Tables(0).Rows(intRowloop)("Rpt_Fieldname").ToString(), dsMulrs.Tables(0).Rows(intRowloop)("rpt_description").ToString())
                    Next
                    rptDoc.SetParameterValue("DateFormat", strDateFormat)
                End If

                'Parameter Values to format  Numbers for Localization
                If Not rptDoc.ParameterFields("RPT_ML_DEC_SEP") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_ML_DEC_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportDecimalSeperator"))
                End If
                If Not rptDoc.ParameterFields("RPT_ML_THOU_SEP") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_ML_THOU_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportThousandSeperator"))
                End If
                If Not rptDoc.ParameterFields("RPT_NO_OF_DIGITS") Is Nothing Then
                    rptDoc.SetParameterValue("RPT_NO_OF_DIGITS", System.Configuration.ConfigurationManager.AppSettings("DecimalPlaces"))
                End If
                'End
                CrViewer1.ReportSource = rptDoc
                Exit Sub
            Else
                MsgRep = New MsgReport("rptInvoice.rpt", Trim(strServerMapPath), "INV", strXMLInvNo) 'Request.QueryString("InvNo"))
            End If
            'rptDoc = MsgRep.DisplayReport()
            'If String.IsNullOrEmpty(strReportName) Then
            '    Dim Copytext As String = fnDecryptQString("copytext")
            '    If Copytext Is Nothing Then
            '        Copytext = String.Empty
            '    End If
            '    rptDoc.SetParameterValue("INVOICECOPY", Copytext)
            'End If
            'strLanguage = ConfigurationManager.AppSettings("Language").ToString
            'blRetval = ParameterFill(strReportName, rptDoc)
            'If (blRetval = False) Then
            '    Exit Sub
            'End If
            'If Not rptDoc.ParameterFields("DateFormat") Is Nothing Then
            '    rptDoc.SetParameterValue("DateFormat", strDateFormat)
            'End If

            ''Parameter Values to format  Numbers for Localization
            'If Not rptDoc.ParameterFields("RPT_ML_DEC_SEP") Is Nothing Then
            '    rptDoc.SetParameterValue("RPT_ML_DEC_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportDecimalSeperator"))
            'End If
            'If Not rptDoc.ParameterFields("RPT_ML_THOU_SEP") Is Nothing Then
            '    rptDoc.SetParameterValue("RPT_ML_THOU_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportThousandSeperator"))
            'End If
            'If Not rptDoc.ParameterFields("RPT_NO_OF_DIGITS") Is Nothing Then
            '    rptDoc.SetParameterValue("RPT_NO_OF_DIGITS", System.Configuration.ConfigurationManager.AppSettings("DecimalPlaces"))
            'End If
            ''End

            'CrViewer1.ReportSource = rptDoc
            'CrViewer1.DataBind()
        Catch ex As Threading.ThreadAbortException
            oErrHandle.WriteErrorLog("1", "Reports_frmShowReports", "LoadReport", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, "UserID")
        Catch ex As Exception
            Dim oErrHandle As New MSGCOMMON.MsgErrorHndlr
            oErrHandle.WriteErrorLog("1", "Reports_frmShowReports", "LoadReport", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, "UserID")
            'oErrHandle = Nothing
        End Try
    End Sub
    Private Function fnDecryptQString(ByVal strEncrypted As String) As String
        'Encryption
        Dim objEncryption As New Encryption64
        If Request.QueryString(strEncrypted) Is Nothing Or Request.QueryString(strEncrypted) = "" Then Return Nothing
        Return objEncryption.Decrypt(Request.QueryString(strEncrypted).ToString.Replace(" ", "+"), ConfigurationManager.AppSettings.Get("encKey"))
    End Function
    Public Function ParameterFill(ByVal strReportName As String, ByVal rptDoc As ReportDocument) As Boolean
        Dim dsMulrs As New DataSet
        Dim strLanguage As String = String.Empty
        Dim objMultiLangBO As New MultiLingualBO
        Try
            strLanguage = ConfigurationManager.AppSettings("Language").ToString
            objMultiLangBO.LangName = strLanguage
            objMultiLangBO.ScreenName = strReportName
            dsMulrs = objrepAcc.Fetch_multilingual(objMultiLangBO)
            If dsMulrs.Tables(0).Rows.Count > 0 Then
                Dim intRowloop As Integer = Integer.MinValue
                For intRowloop = 0 To dsMulrs.Tables(0).Rows.Count - 1
                    rptDoc.SetParameterValue(dsMulrs.Tables(0).Rows(intRowloop)("Rpt_Fieldname").ToString(), dsMulrs.Tables(0).Rows(intRowloop)("rpt_description").ToString())
                Next
            Else
                Return False
                Exit Function
            End If

            dsMulrs.Tables(0).DefaultView.RowFilter = "rpt_fieldname='TXT_HEADER'"
            If dsMulrs.Tables(0).DefaultView.Count > 0 Then
                Page.Title = dsMulrs.Tables(0).DefaultView.Item(0).Item("rpt_description").ToString
            End If
            Return True

        Catch ex As Exception
            Dim oErrHandle As New MSGCOMMON.MsgErrorHndlr
            oErrHandle.WriteErrorLog(1, "frmShowReports", "ParameterFill", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, strUserId)
            Throw ex
        End Try
    End Function

    Public Sub GeneratePDF(ByVal State As Object)
        Dim strXML As String = CStr(Session("xmlInvNos")).ToString()
        Dim invoiceType As String = fnDecryptQString("InvoiceType")
        Dim objXML As New XmlDocument
        Try
            objXML.LoadXml(strXML)
            Dim xmlNode As XmlNodeList = objXML.SelectNodes("//ID_INV_NO")

            For Each xnode As XmlNode In xmlNode
                Dim strInvoice As String = xnode.Attributes("ID_INV_NO").Value
                Dim strInvXML As String
                If invoiceType.Equals("CreditNote") Then
                    strInvXML = "<ROOT><OPTIONS FLG_COPYTEXT=""False"" /><ID_INV_NO  ID_INV_NO=""" + strInvoice.ToString().Trim + """  FLG_INVORCN=""True"" /></ROOT>"
                    LoadReport(strInvXML, strInvoice, "CreditNote", invoiceType, "INVOICEPRINT", "CreditNote")
                Else
                    strInvXML = "<ROOT><ID_INV_NO ID_INV_NO=""" + strInvoice.ToString().Trim + """ /></ROOT>"
                    LoadReport(strInvXML, strInvoice, "invoicePrint", invoiceType, "INVOICEPRINT", "INVOICE")
                End If

            Next
        Catch ex As Exception
            Dim oErrHandle As New MSGCOMMON.MsgErrorHndlr
            oErrHandle.WriteErrorLog("1", "Reports_frmShowReports", "GeneratePDF", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, "UserID")
            'Throw ex
        Finally

        End Try
    End Sub
    Private Sub LoadReport(ByVal xmlINVNo As String, ByVal strInvoice As String, ByVal ReportHeader As String, ByVal InvoiceTyp As String, ByVal Rpt As String, ByVal RptType As String)
        Dim strReportName As String = Rpt
        Dim rptDoc1 As New ReportDocument
        Dim strRpt As String = String.Empty
        Dim strServerMapPath As String
        Dim strLanguage As String
        Dim dsMulrs As DataSet
        Dim rptUtil As CoreLibrary.CARS.Utilities.ReportUtil
        Dim strDateFormat As String = System.Configuration.ConfigurationManager.AppSettings("DateFormatValidate").TrimStart("(").TrimEnd(")")
        Try
            strServerMapPath = Server.MapPath("")
            'lblReportHeader.Text = fnDecryptQString("ReportHeader")

            Dim strXMLInvNo As String
            strXMLInvNo = xmlINVNo

            Dim connString As String = ConfigurationManager.AppSettings("MSGConstr")
            rptUtil = CoreLibrary.CARS.Utilities.ReportUtil.CreateReportUtilObject(strServerMapPath)

            Dim checkInvoiceCaption As Boolean = True

            Select Case strReportName
                Case "INVOICEPRINT"
                    'rptDoc1 = rptUtil.CreateReportForInvoicePrint(connString, "Invoice_WorkOrder_SS2Invoice.rpt", strXMLInvNo.ToString(), RptType)
                    rptDoc1 = rptUtil.CreateReportForInvoicePrint(connString, "WorkOrderInvoice.rpt", strXMLInvNo.ToString(), RptType)

                    Dim invoiceType As String = InvoiceTyp

                    Dim cfSubsidiary As New CARS.CoreLibrary.CARS.Department.ConfigDepartmentDO  'Fetch_Role1
                    Dim userInfo As DataSet = cfSubsidiary.Fetch_Role1(Session("USERID"))


                    Dim subsidiary As String = IIf(userInfo.Tables(0).Rows(0)("ID_SUBSIDERY_USER") Is DBNull.Value, Nothing, userInfo.Tables(0).Rows(0)("ID_SUBSIDERY_USER"))
                    Dim department As String = IIf(userInfo.Tables(0).Rows(0)("ID_DEPT_USER") Is DBNull.Value, Nothing, userInfo.Tables(0).Rows(0)("ID_DEPT_USER"))

                    Dim _reportsettings As New ABS10SS3DO.ReportSettings()
                    Dim _settings As DataSet
                    With _reportsettings
                        .ReportID = strReportName
                        .Department = department
                        .Subsidiary = subsidiary
                        .OrderType = invoiceType
                        _settings = .LoadDisplaySettings
                    End With
                    If invoiceType.Equals("INVOICEBASIS") Then
                        rptDoc1.SetParameterValue("IsInvoiceBasis", True)
                    Else
                        rptDoc1.SetParameterValue("IsInvoiceBasis", False)
                    End If
                    If invoiceType.Equals("CreditNote") Then
                        rptDoc1.SetParameterValue("IsCreditNote", True)
                    Else
                        rptDoc1.SetParameterValue("IsCreditNote", False)
                    End If
                    If invoiceType.Equals("InvPrintCopy") Then
                        rptDoc1.SetParameterValue("InvPrintCopy", "Copy")
                    Else
                        rptDoc1.SetParameterValue("InvPrintCopy", String.Empty)
                    End If

                    If _settings.Tables(0).Rows.Count > 0 Then
                        For Each dr As DataRow In _settings.Tables(0).Rows
                            If dr("TYPE").ToString = "F" Then
                                rptDoc1.SetParameterValue(dr("NAME").ToString, dr("DISPLAY").ToString)
                                If dr("NAME").ToString().Equals("INVOICENAMEFROM") Then
                                    rptDoc1.SetParameterValue(dr("NAME").ToString, IIf(dr("ALTERNATETEXT") Is DBNull.Value, "", dr("ALTERNATETEXT").ToString()))
                                End If
                            Else
                                If dr("NAME").ToString.Substring(0, 4) = "SHOW" Then
                                    rptDoc1.SetParameterValue(dr("NAME").ToString, True)
                                ElseIf dr("NAME").ToString() <> "INVOICENAMEFROM" Then
                                    rptDoc1.SetParameterValue(dr("NAME").ToString, True)
                                End If
                                If dr("NAME").ToString().Equals("INVOICENAMEFROM") Then
                                    rptDoc1.SetParameterValue("INVOICENAMEFROM", "DEPARTMENT")
                                End If
                            End If

                        Next
                    Else
                        For Each pf As ParameterField In rptDoc1.ParameterFields
                            If pf.Name.Substring(0, 4) = "SHOW" Then
                                rptDoc1.SetParameterValue(pf.Name, True)
                            Else
                                rptDoc1.SetParameterValue(pf.Name, True)
                            End If
                        Next
                    End If

                    If _settings.Tables(1).Rows.Count > 0 Then
                        For Each dr As DataRow In _settings.Tables(1).Rows
                            'rptDoc1.SetParameterValue(dr("DISPLAYAREA").ToString + "IMAGEID", dr("IMAGEID").ToString)
                            rptDoc1.SetParameterValue("SHOW" + dr("DISPLAYAREA").ToString + "IMAGE", dr("DISPLAY").ToString)
                            rptDoc1.SetParameterValue(dr("DISPLAYAREA").ToString + "IMAGEALIGN", dr("ALIGN").ToString)
                        Next
                    Else
                        rptDoc1.SetParameterValue("SHOWLOGOIMAGE", True)
                        rptDoc1.SetParameterValue("LOGOIMAGEALIGN", "L")
                        rptDoc1.SetParameterValue("SHOWFOOTERIMAGE", True)
                        rptDoc1.SetParameterValue("FOOTERIMAGEALIGN", "L")
                    End If

                    'If _settings.Tables(3).Rows.Count > 0 Then
                    '    If Not _settings.Tables(3).Rows(0)("SENDTOPRINTER") Is DBNull.Value Then
                    '        _sendToPrinter = _settings.Tables(3).Rows(0)("SENDTOPRINTER")
                    '    End If
                    '    If Not _settings.Tables(3).Rows(0)("NOOFCOPIES") Is DBNull.Value Then
                    '        _noofCopies = _settings.Tables(3).Rows(0)("NOOFCOPIES")
                    '    End If
                    '    If Not _settings.Tables(3).Rows(0)("DRAWER1") Is DBNull.Value Then
                    '        _paperSource = _settings.Tables(3).Rows(0)("DRAWER1")
                    '    End If
                    '    If Not _settings.Tables(3).Rows(0)("DEFAULTPRINTER") Is DBNull.Value Then
                    '        _printerName = _settings.Tables(3).Rows(0)("DEFAULTPRINTER")
                    '    End If
                    'End If

                    If _settings.Tables(2).Rows.Count > 0 Then
                        strRpt = _settings.Tables(2).Rows(0)("CAPTION")
                    Else
                        strRpt = invoiceType
                        checkInvoiceCaption = False
                    End If
                    'Dim Header As String = InvoiceTyp
                    If strReportName.Equals("INVOICEPRINT") Then
                        rptDoc1.SetParameterValue("TXT_HEADER", strRpt)
                    End If
            End Select

            strLanguage = ConfigurationManager.AppSettings("Language").ToString
            Dim objMultiLangBO As New MultiLingualBO
            objMultiLangBO.LangName = strLanguage
            objMultiLangBO.ScreenName = strReportName

            dsMulrs = objrepAcc.Fetch_multilingual(objMultiLangBO)

            Select Case strReportName
                Case "PICKINGLIST", "DELIVERYNOTE", "INVOICEPRINT", "WOHEADPICKINGLIST", "ORDERHEADPICKINGLIST"
                    If dsMulrs.Tables(0).Rows.Count > 0 Then
                        Dim rowCount As Integer = Integer.MinValue
                        For rowCount = 0 To dsMulrs.Tables(0).Rows.Count - 1
                            rptDoc1.SetParameterValue(dsMulrs.Tables(0).Rows(rowCount)("Rpt_Fieldname").ToString(), dsMulrs.Tables(0).Rows(rowCount)("rpt_description").ToString())
                        Next
                        rptDoc1.SetParameterValue("DateFormat", strDateFormat)
                    End If
                    If strReportName.Equals("INVOICEPRINT") Then
                        rptDoc1.SetParameterValue("TXT_HEADER", strRpt)
                    End If

            End Select

            'Parameter Values to format  Numbers for Localization
            If Not rptDoc1.ParameterFields("RPT_ML_DEC_SEP") Is Nothing Then
                rptDoc1.SetParameterValue("RPT_ML_DEC_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportDecimalSeperator"))
            End If
            If Not rptDoc1.ParameterFields("RPT_ML_THOU_SEP") Is Nothing Then
                rptDoc1.SetParameterValue("RPT_ML_THOU_SEP", System.Configuration.ConfigurationManager.AppSettings("ReportThousandSeperator"))
            End If
            If Not rptDoc1.ParameterFields("RPT_NO_OF_DIGITS") Is Nothing Then
                rptDoc1.SetParameterValue("RPT_NO_OF_DIGITS", System.Configuration.ConfigurationManager.AppSettings("DecimalPlaces"))
            End If

            'EXPORT THE REPORT TO TEMPORARY PATH AND USE THE EXPORTED REPORT FOR NAVIGATIONS IN THE VIEWER
            Dim strFilename As String = System.Configuration.ConfigurationManager.AppSettings("InvoiceExportPath")
            strFilename = strFilename + strInvoice.Trim.ToString() + ".pdf"

            dsMulrs.Tables(0).DefaultView.RowFilter = "rpt_fieldname='TXT_HEADER'"
            If dsMulrs.Tables(0).DefaultView.Count > 0 Then
                Page.Title = dsMulrs.Tables(0).DefaultView.Item(0).Item("rpt_description").ToString

            End If

            If checkInvoiceCaption = False Then
                If strReportName.Equals("INVOICEPRINT") Then
                    rptDoc1.SetParameterValue("TXT_HEADER", Page.Title)
                End If
            End If
            If Session("Tot") < 0 Then
                LoadReport()
            End If

            strReportId = Guid.NewGuid().ToString
            ' Dim strFilename1 As String = System.IO.Path.GetTempPath() + strReportId + ".rpt"
            'rptDoc1.ExportToDisk(ExportFormatType.CrystalReport, strFilename1)

            rptDoc1.ExportToDisk(ExportFormatType.PortableDocFormat, strFilename)
            'File.Delete(strFilename1)
            dsMulrs.Dispose()
            rptDoc1.Close()
            rptDoc1.Dispose()

        Catch ex As Exception
            Dim oErrHandle As New MSGCOMMON.MsgErrorHndlr
            oErrHandle.WriteErrorLog("1", "Reports_frmShowReports", "LoadReport", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, "UserID")
            'Throw ex
        Finally

        End Try
    End Sub
End Class