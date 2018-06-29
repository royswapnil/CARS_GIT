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
Imports System.Drawing

Public Class InvoicePrintConfigSettings
    Inherits System.Web.UI.Page
    Dim screenName As String
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared loginName As String
    Shared dtCaption As DataTable
    Shared objCommonUtil As New Utilities.CommonUtility
    Shared objConfigSubBO As New ConfigSubsidiaryBO
    Dim objConfigSubDO As New Subsidiary.ConfigSubsidiaryDO
    Dim objConfigDeptDO As New Department.ConfigDepartmentDO
    Shared objConfigDeptBO As New ConfigDepartmentBO
    Shared objConfigSubServ As New Services.ConfigSubsidiary.Subsidiary
    Dim objuserper As New UserAccessPermissionsBO
    Dim _reportSettings As ReportSettings
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Dim strscreenName As String
            If Session("UserID") Is Nothing Or Session("UserPageperDT") Is Nothing Then
                Response.Redirect("~/frmLogin.aspx")
            Else
                loginName = CType(Session("UserID"), String)
            End If
            hdnPageSize.Value = System.Configuration.ConfigurationManager.AppSettings("PageSize")
            If Not IsPostBack Then
                dtCaption = DirectCast(Cache("Caption"), System.Data.DataTable)
                hdnSelect.Value = dtCaption.Select("TAG='select'")(0)(1)
                strscreenName = IO.Path.GetFileName(Me.Request.PhysicalPath)
                '' Dim ddl1 As DropDownList = New DropDownList
                '' Dim ddl2 As DropDownList = New DropDownList

                ddlLogoAlignment.Items.Clear()
                ddlLogoAlignment.AppendDataBoundItems = True
                objCommonUtil.ddlGetValue(strscreenName, ddlLogoAlignment)

                ddlFooterAlignment.Items.Clear()
                ddlFooterAlignment.AppendDataBoundItems = True
                objCommonUtil.ddlGetValue(strscreenName, ddlFooterAlignment)

                ddlInvoiceType.Items.Clear()
                ddlInvoiceType.Items.Add(dtCaption.Select("TAG='select'")(0)(1))
                ddlInvoiceType.AppendDataBoundItems = True
                objCommonUtil.ddlGetValue(strscreenName, ddlInvoiceType)

                ddlInvoiceName.Items.Clear()
                ddlInvoiceName.Items.Add(dtCaption.Select("TAG='select'")(0)(1))
                ddlInvoiceName.AppendDataBoundItems = True
                objCommonUtil.ddlGetValue(strscreenName, ddlInvoiceName)

                FillSubsidery()

                'objCommonUtil.ddlGetInvValue(IO.Path.GetFileName(Me.Request.PhysicalPath), ddlLogoAlignment, ddlFooterAlignment, ddlInvoiceType, ddlInvoiceName)
            End If
            strscreenName = IO.Path.GetFileName(Me.Request.PhysicalPath)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "SS3_Reports_InvoicePrintConfig", "Page_Load", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, Session("UserId"))
        End Try
    End Sub
    Protected Sub ddlInvoiceType_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlInvoiceType.SelectedIndexChanged
        If (ddlInvoiceType.SelectedValue = "0") Then
            txtInvoiceCaption.Text = ""
        Else
            txtInvoiceCaption.Text = ddlInvoiceType.SelectedItem.Text
        End If
        LoadInvoiceConfigSettings()
    End Sub
    Protected Sub drpSubsidiary_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles drpSubsidiary.SelectedIndexChanged
        FillDepartment()
        LoadInvoiceConfigSettings()
    End Sub
    Protected Sub drpDepartment_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles drpDepartment.SelectedIndexChanged
        Try
            lblError.Text = ""
            LoadInvoiceConfigSettings()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "SS3_Reports_InvoicePrintConfig", "drpDepartment_SelectedIndexChanged", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, Session("UserId"))
        End Try
    End Sub
    Private Sub FillSubsidery()
        Try
            Dim dsSubsidery As New DataSet
            objConfigSubBO.UserID = loginName
            dsSubsidery = objConfigSubDO.FetchAllSubsidiary(objConfigSubBO)
            drpSubsidiary.DataSource = dsSubsidery
            drpSubsidiary.DataTextField = "SubsidiaryName"
            drpSubsidiary.DataValueField = "SubsidiaryID"
            drpSubsidiary.DataBind()
            drpSubsidiary.Items.Insert(0, New ListItem("--Select--", "0"))
            drpDepartment.Items.Insert(0, New ListItem("--Select--", "0"))
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "SS3_Reports_InvoicePrintConfig", "FillSubsidery()", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, Session("UserId"))
        End Try
    End Sub
    Private Sub FillDepartment()
        Try
            Dim dsDepartment As New DataSet
            objConfigDeptBO.LoginId = loginName
            dsDepartment = objConfigDeptDO.FetchAllDepartments(objConfigDeptBO)
            drpDepartment.DataSource = dsDepartment
            drpDepartment.DataTextField = "DepartmentName"
            drpDepartment.DataValueField = "DepartmentID"
            drpDepartment.DataBind()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "SS3_Reports_InvoicePrintConfig", "FillDepartment()", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, Session("UserId"))
        End Try
    End Sub
    Private Sub LoadInvoiceConfigSettings()
        Dim dsDisplay As New DataSet
        Dim subId As String
        Dim deptId As String
        Dim type As String

        Try
            lnkViewLogo.Visible = False
            lnkViewFooter.Visible = False
            subId = drpSubsidiary.SelectedValue
            deptId = drpDepartment.SelectedValue
            type = ddlInvoiceType.SelectedValue

            _reportSettings = New ReportSettings()
            With _reportSettings
                .Subsidiary = IIf(drpSubsidiary.SelectedValue = 0, SqlTypes.SqlInt32.Null, SqlTypes.SqlInt32.Parse(drpSubsidiary.SelectedValue))
                .Department = IIf(drpDepartment.SelectedValue = 0, SqlTypes.SqlInt32.Null, SqlTypes.SqlInt32.Parse(drpDepartment.SelectedValue))
                .ReportID = "INVOICEPRINT"
                .OrderType = ddlInvoiceType.SelectedValue
            End With
            dsDisplay = _reportSettings.LoadDisplaySettings()

            '_reportSettings.Subsidiary = subId
            '_reportSettings.Department = deptId
            '_reportSettings.OrderType = type
            '_reportSettings.ReportID = "INVOICEPRINT"
            'dsDisplay = _reportSettings.LoadDisplaySettings()
            ViewState("displaySettings") = dsDisplay
            If dsDisplay.Tables(0).Rows.Count > 0 Then
                For Each dr As DataRow In dsDisplay.Tables(0).Rows
                    Dim ctrl As Control = Me.Master.FindControl("ContentPlaceHolder1").FindControl(dr("REF").ToString)
                    If Not ctrl Is Nothing Then
                        If ctrl.GetType.Name = "CheckBox" Then
                        ElseIf ctrl.GetType.Name = "DropDownList" Then
                            CType(ctrl, DropDownList).SelectedValue = IIf(dr("ALTERNATETEXT") Is DBNull.Value, 0, dr("ALTERNATETEXT").ToString())
                        ElseIf ctrl.GetType.Name = "TextBox" Then
                            CType(ctrl, TextBox).Text = IIf(dr("ALTERNATETEXT") Is DBNull.Value, "", dr("ALTERNATETEXT").ToString())
                        End If
                    End If
                Next
            End If
            'Load Image Settings
            If dsDisplay.Tables(1).Rows.Count > 0 Then
                For Each dr As DataRow In dsDisplay.Tables(1).Rows
                    Dim ctrl As Control = Me.Master.FindControl("ContentPlaceHolder1").FindControl(dr("REF").ToString)
                    If Not ctrl Is Nothing Then
                        If dr("DISPLAY") Is DBNull.Value Then
                            CType(ctrl, CheckBox).Checked = False
                        Else
                            CType(ctrl, CheckBox).Checked = CType(dr("DISPLAY"), Boolean)
                        End If
                    End If
                Next
                ddlLogoAlignment.SelectedValue = dsDisplay.Tables(1).Rows(0)("Align")
                ddlFooterAlignment.SelectedValue = dsDisplay.Tables(1).Rows(1)("Align")
                HttpContext.Current.Session("Rep_InvConfig_LogoImage") = dsDisplay.Tables(1).Rows(0)("Image")
                HttpContext.Current.Session("Rep_InvConfig_FooterImage") = dsDisplay.Tables(1).Rows(1)("Image")
            Else
                chkLogo.Checked = False
                chkFooter.Checked = False
            End If
            If Not HttpContext.Current.Session("Rep_InvConfig_LogoImage") Is Nothing Then
                If Not HttpContext.Current.Session("Rep_InvConfig_LogoImage") Is DBNull.Value Then
                    lnkViewLogo.Visible = True
                End If
            End If
            If Not HttpContext.Current.Session("Rep_InvConfig_FooterImage") Is Nothing Then
                If Not HttpContext.Current.Session("Rep_InvConfig_FooterImage") Is DBNull.Value Then
                    lnkViewFooter.Visible = True
                End If
            End If
            'Load Report Settings
            If dsDisplay.Tables(2).Rows.Count > 0 Then
                ViewState("ReportSettingID") = dsDisplay.Tables(2).Rows(0)("REPORTSETTINGSID")
            Else
                ViewState("ReportSettingID") = Nothing
            End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "SS3_InvoicePrintConfigSettings", "LoadDisplaySett", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub
    Protected Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click
        Try
            Dim drArr As DataRow()
            Dim _displaySettings As New DataSet
            _displaySettings = CType(ViewState("displaySettings"), DataSet)
            drArr = _displaySettings.Tables(0).Select("REF = '" + objCommonUtil.fnReplaceSQL(ddlInvoiceName.ID) + "'")
            If drArr.Length > 0 Then
                If drArr(0)("ALTERNATETEXT") Is DBNull.Value Then
                    drArr(0)("ALTERNATETEXT") = ddlInvoiceName.SelectedItem.Value
                ElseIf Not drArr(0)("ALTERNATETEXT") = ddlInvoiceName.SelectedItem.Value Then
                    drArr(0)("ALTERNATETEXT") = ddlInvoiceName.SelectedItem.Value
                End If
            End If
            Dim modifiedDisplaySettingsds As New DataSet("DisplaySettings")
            Dim modifiedDisplaySettingsdt As DataTable = _displaySettings.Tables(0).GetChanges(DataRowState.Modified)
            If Not modifiedDisplaySettingsdt Is Nothing Then
                modifiedDisplaySettingsds.Tables.Add(modifiedDisplaySettingsdt)
                modifiedDisplaySettingsds.Tables(0).TableName = "dtDisplaySettings"
            End If
            Dim ModifieddisplaySettingsXML As String = modifiedDisplaySettingsds.GetXml()
            Dim sr As System.IO.StringReader
            Dim xtr As System.Xml.XmlTextReader
            Dim newXml As SqlXml
            'Save Display Settings
            If Not modifiedDisplaySettingsdt Is Nothing Then
                _reportSettings = New ReportSettings()
                With _reportSettings
                    .Subsidiary = IIf(drpSubsidiary.SelectedValue = 0, SqlTypes.SqlInt32.Null, SqlTypes.SqlInt32.Parse(drpSubsidiary.SelectedValue))
                    .Department = IIf(drpDepartment.SelectedValue = 0, SqlTypes.SqlInt32.Null, SqlTypes.SqlInt32.Parse(drpDepartment.SelectedValue))
                    .ReportID = "INVOICEPRINT"
                    .OrderType = ddlInvoiceType.SelectedValue
                    .UserID = Session("UserID").ToString()
                    sr = New System.IO.StringReader(ModifieddisplaySettingsXML)
                    xtr = New System.Xml.XmlTextReader(sr)
                    newXml = New SqlXml(xtr)
                    .DisplaySettingsXML = newXml
                End With
                _reportSettings.SaveDisplaySettings()
            End If
            _reportSettings = New ReportSettings()
            With _reportSettings
                .Subsidiary = IIf(drpSubsidiary.SelectedValue = 0, SqlTypes.SqlInt32.Null, SqlTypes.SqlInt32.Parse(drpSubsidiary.SelectedValue))
                .Department = IIf(drpDepartment.SelectedValue = 0, SqlTypes.SqlInt32.Null, SqlTypes.SqlInt32.Parse(drpDepartment.SelectedValue))
                .ReportID = "INVOICEPRINT"
                .OrderType = ddlInvoiceType.SelectedValue
                .UserID = Session("UserID").ToString()
            End With
            Dim maxWidth As Integer
            Dim maxheight As Integer
            maxWidth = 700
            maxheight = 100
            If fileBrowseLogo.HasFile Then
                Dim myCallback As New System.Drawing.Image.GetThumbnailImageAbort(AddressOf ThumbnailCallback)
                Dim bitmapData As [Byte]() = New [Byte](fileBrowseLogo.FileBytes.Length - 1) {}
                bitmapData = fileBrowseLogo.FileBytes
                Dim msTemp As MemoryStream = New MemoryStream(bitmapData, 0, bitmapData.Length)

                Dim image1 As System.Drawing.Image = Nothing
                Dim bitTemp As System.Drawing.Bitmap = New System.Drawing.Bitmap(msTemp)
                image1 = bitTemp.GetThumbnailImage(bitTemp.Width, bitTemp.Height, myCallback, IntPtr.Zero)

                'Dim image1 As System.Drawing.Image = System.Drawing.Image.FromFile(fileBrowseLogo.PostedFile.FileName, True)
                Dim newPic As System.Drawing.Bitmap

                If chkHeaderResize.Checked = True Then

                    newPic = BiggerToSmallImage(image1, maxheight, maxWidth)
                    Dim ms1 As New MemoryStream
                    newPic.Save(ms1, System.Drawing.Imaging.ImageFormat.Bmp)
                    Dim image As New SqlTypes.SqlBytes(ms1.GetBuffer)

                    newPic.Dispose()

                    _reportSettings.Image = image
                    HttpContext.Current.Session("Rep_InvConfig_LogoImage") = fileBrowseLogo.FileBytes
                Else
                    Dim image As New SqlTypes.SqlBytes(fileBrowseLogo.FileBytes)
                    _reportSettings.Image = image
                End If
            Else
                _reportSettings.Image = SqlTypes.SqlBytes.Null
            End If
            Dim DisplayArea As String
            DisplayArea = "LOGO"
            Dim imageDisplaySettingsXML As String = "<ROOT><IMAGE REF = """ + chkLogo.ID + """ DISPLAYAREA = """ + objCommonUtil.ConvertStr(DisplayArea) + """ ALIGN = """ + objCommonUtil.ConvertStr(ddlLogoAlignment.SelectedValue) + """ DISPLAY = """ + chkLogo.Checked.ToString + """></IMAGE></ROOT>"
            sr = New System.IO.StringReader(imageDisplaySettingsXML)
            xtr = New System.Xml.XmlTextReader(sr)
            newXml = New SqlXml(xtr)
            _reportSettings.ImageDisplaySettings = newXml
            _reportSettings.SaveImagewithDisplaySettings()

            'Footer Image
            _reportSettings = New ReportSettings()
            With _reportSettings
                .Subsidiary = IIf(drpSubsidiary.SelectedValue = 0, SqlTypes.SqlInt32.Null, SqlTypes.SqlInt32.Parse(drpSubsidiary.SelectedValue))
                .Department = IIf(drpDepartment.SelectedValue = 0, SqlTypes.SqlInt32.Null, SqlTypes.SqlInt32.Parse(drpDepartment.SelectedValue))
                .ReportID = "INVOICEPRINT"
                .OrderType = ddlInvoiceType.SelectedValue
                .UserID = Session("UserID").ToString()
            End With
            If fileBrowseFooter.HasFile Then
                Dim myCallback As New System.Drawing.Image.GetThumbnailImageAbort(AddressOf ThumbnailCallback)
                Dim bitmapData As [Byte]() = New [Byte](fileBrowseFooter.FileBytes.Length - 1) {}
                bitmapData = fileBrowseFooter.FileBytes
                Dim msTemp As MemoryStream = New MemoryStream(bitmapData, 0, bitmapData.Length)
                Dim bitTemp As System.Drawing.Bitmap = New System.Drawing.Bitmap(msTemp)
                Dim image1 As System.Drawing.Image = Nothing
                Dim newPic As System.Drawing.Bitmap
                image1 = bitTemp.GetThumbnailImage(bitTemp.Width, bitTemp.Height, myCallback, IntPtr.Zero)
                'Dim image1 As System.Drawing.Image = System.Drawing.Image.FromFile(fileBrowseFooter.PostedFile.FileName, True)

                'Dim gr As System.Drawing.Graphics

                If chkFooterResize.Checked = True Then
                    newPic = BiggerToSmallImage(image1, maxheight, maxWidth)
                    Dim ms1 As New MemoryStream
                    newPic.Save(ms1, System.Drawing.Imaging.ImageFormat.Bmp)
                    Dim image As New SqlTypes.SqlBytes(ms1.GetBuffer)
                    newPic.Dispose()
                    _reportSettings.Image = image
                    HttpContext.Current.Session("Rep_InvConfig_FooterImage") = fileBrowseFooter.FileBytes
                Else
                    Dim image As New SqlTypes.SqlBytes(fileBrowseFooter.FileBytes)
                    _reportSettings.Image = image
                End If

            Else
                _reportSettings.Image = SqlTypes.SqlBytes.Null
            End If
            DisplayArea = "FOOTER"
            imageDisplaySettingsXML = "<ROOT><IMAGE REF = """ + chkFooter.ID + """ DISPLAYAREA = """ + objCommonUtil.ConvertStr(DisplayArea) + """ ALIGN = """ + objCommonUtil.ConvertStr(ddlFooterAlignment.SelectedValue) + """ DISPLAY = """ + chkFooter.Checked.ToString + """></IMAGE></ROOT>"
            sr = New System.IO.StringReader(imageDisplaySettingsXML)
            xtr = New System.Xml.XmlTextReader(sr)
            newXml = New SqlXml(xtr)
            _reportSettings.ImageDisplaySettings = newXml
            _reportSettings.SaveImagewithDisplaySettings()
            If Not HttpContext.Current.Session("Rep_InvConfig_LogoImage") Is Nothing Then
                If Not HttpContext.Current.Session("Rep_InvConfig_LogoImage") Is DBNull.Value Then
                    lnkViewLogo.Visible = True
                End If
            End If
            If Not HttpContext.Current.Session("Rep_InvConfig_FooterImage") Is Nothing Then
                If Not HttpContext.Current.Session("Rep_InvConfig_FooterImage") Is DBNull.Value Then
                    lnkViewFooter.Visible = True
                End If
            End If

            'Save Report Settings
            _reportSettings = New ReportSettings()
            With _reportSettings
                .Subsidiary = IIf(drpSubsidiary.SelectedValue = 0, SqlTypes.SqlInt32.Null, SqlTypes.SqlInt32.Parse(drpSubsidiary.SelectedValue))
                .Department = IIf(drpDepartment.SelectedValue = 0, SqlTypes.SqlInt32.Null, SqlTypes.SqlInt32.Parse(drpDepartment.SelectedValue))
                .ReportID = "INVOICEPRINT"
                .OrderType = ddlInvoiceType.SelectedValue
                .UserID = Session("UserID").ToString()
                .ReportName = ""
                .Name = ""

                If txtInvoiceCaption.Text.Trim() <> "" Then
                    .Caption = txtInvoiceCaption.Text.Trim()
                Else
                    .Caption = ""
                End If
                If ViewState("ReportSettingID") Is Nothing Then
                    .ReportSettingID = ViewState("ReportSettingID")
                Else
                    .ReportSettingID = CType(ViewState("ReportSettingID"), Integer)
                End If
            End With
            _reportSettings.SaveReportSettings()
            lblError.Text = objErrHandle.GetErrorDesc("COSAVED")
            lblError.ForeColor = Drawing.Color.Green
        Catch ex As Exception

        End Try
    End Sub
    Protected Function BiggerToSmallImage(ByVal image As Drawing.Image, ByVal height As Integer, ByVal width As Integer) As Drawing.Image

        Dim original As Bitmap = image

        Dim newImgWidth As Integer = 0
        Dim newImgHeight As Integer = 0

        Dim orgImgWidth As Integer = original.Width
        Dim orgImgHeight As Integer = original.Height
        Dim ratio As Decimal

        If ((orgImgHeight <= height) And (orgImgWidth <= width)) Then
            'If Image Size is less than Required Size 
            newImgHeight = orgImgHeight
            newImgWidth = orgImgWidth
        Else
            If (orgImgWidth <= width And orgImgHeight > height) Then
                ratio = (height / orgImgHeight)
                newImgWidth = orgImgWidth * ratio
                newImgHeight = height
            ElseIf (orgImgWidth > width And orgImgHeight <= height) Then
                ratio = (width / orgImgWidth)
                newImgHeight = orgImgHeight * ratio
                newImgWidth = width
            ElseIf (orgImgWidth > width And orgImgHeight > height) Then
                ratio = (height / orgImgHeight)
                newImgWidth = orgImgWidth * ratio
                If newImgWidth > width Then
                    ratio = (width / orgImgWidth)
                    newImgHeight = orgImgHeight * ratio
                    newImgWidth = width
                Else
                    newImgHeight = height
                End If

            End If
        End If


        Using newimage As New Bitmap(newImgWidth, newImgHeight)
            Using newgraphics As Graphics = Graphics.FromImage(newimage)
                newgraphics.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBicubic
                newgraphics.DrawImage(original, New Rectangle(0, 0, newImgWidth, newImgHeight), New Rectangle(0, 0, orgImgWidth, orgImgHeight), GraphicsUnit.Pixel)
                newgraphics.Flush()
                newgraphics.Dispose()
            End Using
            Return New Bitmap(newimage)
        End Using

    End Function
    Public Function ThumbnailCallback() As Boolean
        Return True
    End Function
    Protected Sub lnkViewLogo_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Try
            If Not HttpContext.Current.Session("Rep_InvConfig_LogoImage") Is Nothing Then
                HttpContext.Current.Session("RepImage") = HttpContext.Current.Session("Rep_InvConfig_LogoImage")
                Dim strScript As String = "<script>var windowImg = window.open('DisplayImage.ashx','DisplayImage','width=800px;height=400px;menubar=no,location=no,status=no,scrollbars=yes,resizable=yes'); windowImg.focus();</script>"
                ScriptManager.RegisterClientScriptBlock(Me.Page, Me.GetType(), "Open", strScript, False)
                'ClientScript.RegisterStartupScript(Me.GetType(), "Open", strScript, False)
            End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "SS3_InvoicePrintConfig", "lnkViewLogo_Click", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, Session("UserId"))
        End Try
    End Sub
    Protected Sub lnkViewFooter_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Try
            If Not Session("Rep_InvConfig_FooterImage") Is Nothing Then
                Session("RepImage") = Session("Rep_InvConfig_FooterImage")
                Dim strScript As String = "<script>var windowImgFooter = window.open('DisplayImage.ashx','DisplayImage','width=800px;height=400px;menubar=no,location=no,status=no,scrollbars=yes,resizable=yes'); windowImgFooter.focus();</script>"
                ScriptManager.RegisterClientScriptBlock(Me.Page, Me.GetType(), "Open", strScript, False)
                'ClientScript.RegisterStartupScript(Me.GetType(), "Open", strScript, False)
            End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "SS3_InvoicePrintConfig", "lnkViewFooter_Click", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, Session("UserId"))
        End Try
    End Sub
End Class