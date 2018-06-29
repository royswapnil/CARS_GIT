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
Imports System.Drawing.Printing

Public Class DeliveryNoteSettings
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
    Dim _displaySettings As DataSet
    Dim _reportID As String = "DELIVERYNOTE"
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
                FillSubsidery()
                FillDepartment()
                strscreenName = IO.Path.GetFileName(Me.Request.PhysicalPath)
                '' Dim ddl1 As DropDownList = New DropDownList
                '' Dim ddl2 As DropDownList = New DropDownList

                ddlAlignment.Items.Clear()
                ddlAlignment.AppendDataBoundItems = True
                objCommonUtil.ddlGetValue(strscreenName, ddlAlignment)

                ddlFooterAlignment.Items.Clear()
                ddlFooterAlignment.AppendDataBoundItems = True
                objCommonUtil.ddlGetValue(strscreenName, ddlFooterAlignment)

                ddlSecondaryOrderType.Items.Clear()
                ddlSecondaryOrderType.Items.Add(dtCaption.Select("TAG='select'")(0)(1))
                ddlSecondaryOrderType.AppendDataBoundItems = True
                objCommonUtil.ddlGetValue(strscreenName, ddlSecondaryOrderType)

                LoadPrinters()
                ApplyDisplaySettings()
            End If
            If Page.IsPostBack Then
                LoadDisplaySettings()
            End If
            strscreenName = IO.Path.GetFileName(Me.Request.PhysicalPath)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "SS3_Reports_PickingList", "Page_Load", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub
    Private Sub FillSubsidery()
        Dim dsSubsidery As New DataSet
        objConfigSubBO.UserID = loginName
        dsSubsidery = objConfigSubDO.FetchAllSubsidiary(objConfigSubBO)
        drpSubsidiary.DataSource = dsSubsidery
        drpSubsidiary.DataTextField = "SubsidiaryName"
        drpSubsidiary.DataValueField = "SubsidiaryID"
        drpSubsidiary.DataBind()
        drpSubsidiary.Items.Insert(0, New ListItem("--Select--", "0"))
        drpDepartment.Items.Insert(0, New ListItem("--Select--", "0"))
    End Sub
    Private Sub FillDepartment()
        Dim dsDepartment As New DataSet
        objConfigDeptBO.LoginId = loginName
        dsDepartment = objConfigDeptDO.FetchAllDepartments(objConfigDeptBO)
        drpDepartment.DataSource = dsDepartment
        drpDepartment.DataTextField = "DepartmentName"
        drpDepartment.DataValueField = "DepartmentID"
        drpDepartment.DataBind()
        drpDepartment.Items.Insert(0, New ListItem("--Select--", "0"))
    End Sub
    Private Sub LoadPrinters()
        ddlDefaultPrinter.Items.Add(New ListItem("--Select--", ""))
        For Each printer As String In PrinterSettings.InstalledPrinters
            Dim i As Integer = printer.LastIndexOf("\")
            If i = -1 Then i = 0 Else i = i + 1
            ddlDefaultPrinter.Items.Add(New ListItem(printer.Substring(i), printer))

        Next
        If ddlDefaultPrinter.Items.Count = 0 Then
            ddlDefaultPrinter.Items.Clear()
            ddlDefaultPrinter.Items.Add(New ListItem(objErrHandle.GetErrorDesc("MSG230"), ""))
        End If

    End Sub
    Private Sub LoadDisplaySettings()
        Try
            _displaySettings = Nothing
            _reportSettings = New ReportSettings()
            _reportSettings.Subsidiary = IIf(drpSubsidiary.SelectedValue = 0, SqlTypes.SqlInt32.Null, SqlTypes.SqlInt32.Parse(drpSubsidiary.SelectedValue))
            _reportSettings.Department = IIf(drpDepartment.SelectedValue = 0, SqlTypes.SqlInt32.Null, SqlTypes.SqlInt32.Parse(drpDepartment.SelectedValue))
            _reportSettings.ReportID = _reportID
            _reportSettings.OrderType = ddlSecondaryOrderType.SelectedValue
            _displaySettings = _reportSettings.LoadDisplaySettings()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Reports_DeliverNoteSettings", "LoadDisplaySettings", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, Session("UserId"))
        End Try
    End Sub
    Private Sub ApplyDisplaySettings()
        Try
            Session("Rep_DeliveryNoteSettings_LogoImage") = Nothing
            Session("Rep_DeliveryNoteSettings_FooterImage") = Nothing
            lnkLogo.Visible = False
            lnkFooter.Visible = False
            LoadDisplaySettings()
            If _displaySettings.Tables(0).Rows.Count > 0 Then
                For Each dr As DataRow In _displaySettings.Tables(0).Rows
                    Dim ctrl As Control = Me.Master.FindControl("ContentPlaceHolder1").FindControl(dr("REF").ToString)
                    If Not ctrl Is Nothing Then
                        If dr("DISPLAY") Is DBNull.Value Then
                            CType(ctrl, CheckBox).Checked = False
                        Else
                            CType(ctrl, CheckBox).Checked = CType(dr("DISPLAY"), Boolean)
                        End If

                        If ctrl.ID = "chkCommercialText" Then
                            txtCommercial.Text = IIf(dr("CommercialText") Is DBNull.Value, "", dr("CommercialText").ToString())
                        End If
                    End If
                Next
            End If
            'Image Display Settings
            If _displaySettings.Tables(1).Rows.Count > 0 Then
                For Each dr As DataRow In _displaySettings.Tables(1).Rows
                    Dim ctrl As Control = Me.Master.FindControl("ContentPlaceHolder1").FindControl(dr("REF").ToString)
                    If Not ctrl Is Nothing Then
                        If dr("DISPLAY") Is DBNull.Value Then
                            CType(ctrl, CheckBox).Checked = False
                        Else
                            CType(ctrl, CheckBox).Checked = CType(dr("DISPLAY"), Boolean)
                        End If
                    End If
                Next

                If _displaySettings.Tables(1).Rows(0)("Align").ToString.Length <> 0 Then
                    ddlAlignment.SelectedIndex = ddlAlignment.Items.IndexOf(ddlAlignment.Items.FindByValue(_displaySettings.Tables(1).Rows(0)("Align")))
                End If
                If _displaySettings.Tables(1).Rows(1)("Align").ToString.Length <> 0 Then
                    ddlFooterAlignment.SelectedIndex = ddlFooterAlignment.Items.IndexOf(ddlFooterAlignment.Items.FindByValue(_displaySettings.Tables(1).Rows(1)("Align")))
                End If

                Session("Rep_DeliveryNoteSettings_LogoImage") = _displaySettings.Tables(1).Rows(0)("Image")
                Session("Rep_DeliveryNoteSettings_FooterImage") = _displaySettings.Tables(1).Rows(1)("Image")
                If Not IsDBNull(_displaySettings.Tables(1).Rows(0)("Image")) Then
                    lnkLogo.Visible = True
                End If
                If Not IsDBNull(_displaySettings.Tables(1).Rows(1)("Image")) Then
                    lnkFooter.Visible = True
                End If
            Else
                chkLogo.Checked = False
                chkFooter.Checked = False
            End If

            'Report Settings
            If _displaySettings.Tables(2).Rows.Count > 0 Then
                ViewState("ReportSettingsID") = _displaySettings.Tables(2).Rows(0)("REPORTSETTINGSID").ToString
            End If

            'Printer Settings
            If _displaySettings.Tables(3).Rows.Count > 0 Then
                If Not String.IsNullOrEmpty(_displaySettings.Tables(3).Rows(0)("DEFAULTPRINTER")) Then
                    ddlDefaultPrinter.SelectedValue = _displaySettings.Tables(3).Rows(0)("DEFAULTPRINTER")
                    txtLocation.Text = _displaySettings.Tables(3).Rows(0)("DEFAULTPRINTER")
                End If
            Else
                ddlDefaultPrinter.SelectedValue = ""
                txtLocation.Text = ""
            End If
            If ddlSecondaryOrderType.SelectedValue = "BARGAIN" Then
                chkReadytoInvoice.Enabled = False
            Else
                chkReadytoInvoice.Enabled = True
            End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Reports_DeliverNoteSettings", "ApplyDisplaySettings", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, Session("UserId"))
        End Try
    End Sub
    Private Sub SaveDisplaySettings()
        Try
            Dim drArr As DataRow()
            drArr = _displaySettings.Tables(0).Select("REF = '" + objCommonUtil.fnReplaceSQL(chkAddressLine1.ID) + "'")
            If drArr.Length > 0 Then
                If drArr(0)("DISPLAY") Is DBNull.Value Then
                    drArr(0)("DISPLAY") = chkAddressLine1.Checked
                ElseIf Not drArr(0)("DISPLAY") = chkAddressLine1.Checked Then
                    drArr(0)("DISPLAY") = chkAddressLine1.Checked
                End If

            End If

            drArr = _displaySettings.Tables(0).Select("REF = '" + objCommonUtil.fnReplaceSQL(chkAddressLine2.ID) + "'")
            If drArr.Length > 0 Then
                If drArr(0)("DISPLAY") Is DBNull.Value Then
                    drArr(0)("DISPLAY") = chkAddressLine2.Checked
                ElseIf Not drArr(0)("DISPLAY") = chkAddressLine2.Checked Then
                    drArr(0)("DISPLAY") = chkAddressLine2.Checked
                End If
            End If

            drArr = _displaySettings.Tables(0).Select("REF = '" + objCommonUtil.fnReplaceSQL(chkAnnotation.ID) + "'")
            If drArr.Length > 0 Then
                If drArr(0)("DISPLAY") Is DBNull.Value Then
                    drArr(0)("DISPLAY") = chkAnnotation.Checked
                ElseIf Not drArr(0)("DISPLAY") = chkAnnotation.Checked Then
                    drArr(0)("DISPLAY") = chkAnnotation.Checked
                End If
            End If

            drArr = _displaySettings.Tables(0).Select("REF = '" + objCommonUtil.fnReplaceSQL(chkCompanyAddress.ID) + "'")
            If drArr.Length > 0 Then
                If drArr(0)("DISPLAY") Is DBNull.Value Then
                    drArr(0)("DISPLAY") = chkCompanyAddress.Checked
                ElseIf Not drArr(0)("DISPLAY") = chkCompanyAddress.Checked Then
                    drArr(0)("DISPLAY") = chkCompanyAddress.Checked
                End If

            End If

            drArr = _displaySettings.Tables(0).Select("REF = '" + objCommonUtil.fnReplaceSQL(chkCompanyEmail.ID) + "'")
            If drArr.Length > 0 Then
                If drArr(0)("DISPLAY") Is DBNull.Value Then
                    drArr(0)("DISPLAY") = chkCompanyEmail.Checked
                ElseIf Not drArr(0)("DISPLAY") = chkCompanyEmail.Checked Then
                    drArr(0)("DISPLAY") = chkCompanyEmail.Checked
                End If

            End If

            drArr = _displaySettings.Tables(0).Select("REF = '" + objCommonUtil.fnReplaceSQL(chkCompanyName.ID) + "'")
            If drArr.Length > 0 Then
                If drArr(0)("DISPLAY") Is DBNull.Value Then
                    drArr(0)("DISPLAY") = chkCompanyName.Checked
                ElseIf Not drArr(0)("DISPLAY") = chkCompanyName.Checked Then
                    drArr(0)("DISPLAY") = chkCompanyName.Checked
                End If

            End If

            drArr = _displaySettings.Tables(0).Select("REF = '" + objCommonUtil.fnReplaceSQL(chkCompanyPhoneNo.ID) + "'")
            If drArr.Length > 0 Then
                If drArr(0)("DISPLAY") Is DBNull.Value Then
                    drArr(0)("DISPLAY") = chkCompanyPhoneNo.Checked
                ElseIf Not drArr(0)("DISPLAY") = chkCompanyPhoneNo.Checked Then
                    drArr(0)("DISPLAY") = chkCompanyPhoneNo.Checked
                End If

            End If

            drArr = _displaySettings.Tables(0).Select("REF = '" + objCommonUtil.fnReplaceSQL(chkCountry.ID) + "'")
            If drArr.Length > 0 Then
                If drArr(0)("DISPLAY") Is DBNull.Value Then
                    drArr(0)("DISPLAY") = chkCountry.Checked
                ElseIf Not drArr(0)("DISPLAY") = chkCountry.Checked Then
                    drArr(0)("DISPLAY") = chkCountry.Checked
                End If

            End If

            drArr = _displaySettings.Tables(0).Select("REF = '" + objCommonUtil.fnReplaceSQL(chkCustomerInfo.ID) + "'")
            If drArr.Length > 0 Then
                If drArr(0)("DISPLAY") Is DBNull.Value Then
                    drArr(0)("DISPLAY") = chkCustomerInfo.Checked
                ElseIf Not drArr(0)("DISPLAY") = chkCustomerInfo.Checked Then
                    drArr(0)("DISPLAY") = chkCustomerInfo.Checked
                End If

            End If

            drArr = _displaySettings.Tables(0).Select("REF = '" + objCommonUtil.fnReplaceSQL(chkCustomerID.ID) + "'")
            If drArr.Length > 0 Then
                If drArr(0)("DISPLAY") Is DBNull.Value Then
                    drArr(0)("DISPLAY") = chkCustomerID.Checked
                ElseIf Not drArr(0)("DISPLAY") = chkCustomerID.Checked Then
                    drArr(0)("DISPLAY") = chkCustomerID.Checked
                End If
            End If

            drArr = _displaySettings.Tables(0).Select("REF = '" + objCommonUtil.fnReplaceSQL(chkCustomerName.ID) + "'")
            If drArr.Length > 0 Then
                If drArr(0)("DISPLAY") Is DBNull.Value Then
                    drArr(0)("DISPLAY") = chkCustomerName.Checked
                ElseIf Not drArr(0)("DISPLAY") = chkCustomerName.Checked Then
                    drArr(0)("DISPLAY") = chkCustomerName.Checked
                End If

            End If
            drArr = _displaySettings.Tables(0).Select("REF = '" + objCommonUtil.fnReplaceSQL(chkShowDeliveryAddress.ID) + "'")
            If drArr.Length > 0 Then
                If drArr(0)("DISPLAY") Is DBNull.Value Then
                    drArr(0)("DISPLAY") = chkShowDeliveryAddress.Checked
                ElseIf Not drArr(0)("DISPLAY") = chkShowDeliveryAddress.Checked Then
                    drArr(0)("DISPLAY") = chkShowDeliveryAddress.Checked
                End If

            End If


            drArr = _displaySettings.Tables(0).Select("REF = '" + objCommonUtil.fnReplaceSQL(chkMobile.ID) + "'")
            If drArr.Length > 0 Then
                If drArr(0)("DISPLAY") Is DBNull.Value Then
                    drArr(0)("DISPLAY") = chkMobile.Checked
                ElseIf Not drArr(0)("DISPLAY") = chkMobile.Checked Then
                    drArr(0)("DISPLAY") = chkMobile.Checked
                End If

            End If



            drArr = _displaySettings.Tables(0).Select("REF = '" + objCommonUtil.fnReplaceSQL(chkOther.ID) + "'")
            If drArr.Length > 0 Then
                If drArr(0)("DISPLAY") Is DBNull.Value Then
                    drArr(0)("DISPLAY") = chkOther.Checked
                ElseIf Not drArr(0)("DISPLAY") = chkOther.Checked Then
                    drArr(0)("DISPLAY") = chkOther.Checked
                End If

            End If

            drArr = _displaySettings.Tables(0).Select("REF = '" + objCommonUtil.fnReplaceSQL(chkPhoneNoOff.ID) + "'")
            If drArr.Length > 0 Then
                If drArr(0)("DISPLAY") Is DBNull.Value Then
                    drArr(0)("DISPLAY") = chkPhoneNoOff.Checked
                ElseIf Not drArr(0)("DISPLAY") = chkPhoneNoOff.Checked Then
                    drArr(0)("DISPLAY") = chkPhoneNoOff.Checked
                End If

            End If

            drArr = _displaySettings.Tables(0).Select("REF = '" + objCommonUtil.fnReplaceSQL(chkPhoneNoRes.ID) + "'")
            If drArr.Length > 0 Then
                If drArr(0)("DISPLAY") Is DBNull.Value Then
                    drArr(0)("DISPLAY") = chkPhoneNoRes.Checked
                ElseIf Not drArr(0)("DISPLAY") = chkPhoneNoRes.Checked Then
                    drArr(0)("DISPLAY") = chkPhoneNoRes.Checked
                End If

            End If



            drArr = _displaySettings.Tables(0).Select("REF = '" + objCommonUtil.fnReplaceSQL(chkStateCity.ID) + "'")
            If drArr.Length > 0 Then
                If drArr(0)("DISPLAY") Is DBNull.Value Then
                    drArr(0)("DISPLAY") = chkStateCity.Checked
                ElseIf Not drArr(0)("DISPLAY") = chkStateCity.Checked Then
                    drArr(0)("DISPLAY") = chkStateCity.Checked
                End If

            End If


            drArr = _displaySettings.Tables(0).Select("REF = '" + objCommonUtil.fnReplaceSQL(chkZipCode.ID) + "'")
            If drArr.Length > 0 Then
                If drArr(0)("DISPLAY") Is DBNull.Value Then
                    drArr(0)("DISPLAY") = chkZipCode.Checked
                ElseIf Not drArr(0)("DISPLAY") = chkZipCode.Checked Then
                    drArr(0)("DISPLAY") = chkZipCode.Checked
                End If
            End If

            drArr = _displaySettings.Tables(0).Select("REF = '" + objCommonUtil.fnReplaceSQL(chkReadytoInvoice.ID) + "'")
            If drArr.Length > 0 Then
                If drArr(0)("DISPLAY") Is DBNull.Value Then
                    drArr(0)("DISPLAY") = chkReadytoInvoice.Checked
                ElseIf Not drArr(0)("DISPLAY") = chkReadytoInvoice.Checked Then
                    drArr(0)("DISPLAY") = chkReadytoInvoice.Checked
                End If
            End If

            drArr = _displaySettings.Tables(0).Select("REF = '" + objCommonUtil.fnReplaceSQL(chkDiscount.ID) + "'")
            If drArr.Length > 0 Then
                If drArr(0)("DISPLAY") Is DBNull.Value Then
                    drArr(0)("DISPLAY") = chkDiscount.Checked
                ElseIf Not drArr(0)("DISPLAY") = chkDiscount.Checked Then
                    drArr(0)("DISPLAY") = chkDiscount.Checked
                End If
            End If

            drArr = _displaySettings.Tables(0).Select("REF = '" + objCommonUtil.fnReplaceSQL(chkDeliveredLines.ID) + "'")
            If drArr.Length > 0 Then
                If drArr(0)("DISPLAY") Is DBNull.Value Then
                    drArr(0)("DISPLAY") = chkDeliveredLines.Checked
                ElseIf Not drArr(0)("DISPLAY") = chkDeliveredLines.Checked Then
                    drArr(0)("DISPLAY") = chkDeliveredLines.Checked
                End If
            End If
            drArr = _displaySettings.Tables(0).Select("REF = '" + objCommonUtil.fnReplaceSQL(chkDislaySubsidiaryInfo.ID) + "'")
            If drArr.Length > 0 Then
                If drArr(0)("DISPLAY") Is DBNull.Value Then
                    drArr(0)("DISPLAY") = chkDislaySubsidiaryInfo.Checked
                ElseIf Not drArr(0)("DISPLAY") = chkDislaySubsidiaryInfo.Checked Then
                    drArr(0)("DISPLAY") = chkDislaySubsidiaryInfo.Checked
                End If
            End If

            drArr = _displaySettings.Tables(0).Select("REF = '" + objCommonUtil.fnReplaceSQL(chkCommercialText.ID) + "'")
            If drArr.Length > 0 Then
                If drArr(0)("DISPLAY") Is DBNull.Value Then
                    drArr(0)("DISPLAY") = chkCommercialText.Checked
                ElseIf Not drArr(0)("DISPLAY") = chkCommercialText.Checked Then
                    drArr(0)("DISPLAY") = chkCommercialText.Checked
                End If
                drArr(0)("COMMERCIALTEXT") = IIf(txtCommercial.Text = "", DBNull.Value, txtCommercial.Text)
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
            With _reportSettings
                .Subsidiary = IIf(drpSubsidiary.SelectedValue = 0, SqlTypes.SqlInt32.Null, SqlTypes.SqlInt32.Parse(drpSubsidiary.SelectedValue))
                .Department = IIf(drpDepartment.SelectedValue = 0, SqlTypes.SqlInt32.Null, SqlTypes.SqlInt32.Parse(drpDepartment.SelectedValue))
                .ReportID = _reportID
                .OrderType = ddlSecondaryOrderType.SelectedValue
                .UserID = loginName
            End With
            If Not modifiedDisplaySettingsdt Is Nothing Then
                With _reportSettings
                    sr = New System.IO.StringReader(ModifieddisplaySettingsXML)
                    xtr = New System.Xml.XmlTextReader(sr)
                    newXml = New SqlXml(xtr)
                    .DisplaySettingsXML = newXml
                End With
                _reportSettings.SaveDisplaySettings()
            End If
            'Header Image
            If fileBrowseLogo.PostedFile Is Nothing Or fileBrowseLogo.PostedFile.FileName = String.Empty Then
                _reportSettings.Image = SqlTypes.SqlBytes.Null
            Else
                Dim myCallback As New System.Drawing.Image.GetThumbnailImageAbort(AddressOf ThumbnailCallback)

                Dim bitmapData As [Byte]() = New [Byte](fileBrowseLogo.FileBytes.Length - 1) {}
                bitmapData = fileBrowseLogo.FileBytes
                Dim msTemp As MemoryStream = New MemoryStream(bitmapData, 0, bitmapData.Length)

                Dim myThumbnailTemp As System.Drawing.Image = Nothing
                Dim msMain As New MemoryStream

                Dim bitTemp As System.Drawing.Bitmap = New System.Drawing.Bitmap(msTemp)


                myThumbnailTemp = bitTemp.GetThumbnailImage(bitTemp.Width, bitTemp.Height, myCallback, IntPtr.Zero)
                myThumbnailTemp.Save(msMain, System.Drawing.Imaging.ImageFormat.Bmp)

                Dim bitMain As System.Drawing.Bitmap = New System.Drawing.Bitmap(msMain)

                Dim myThumbnailMain As System.Drawing.Image = Nothing

                If (bitMain.Width < bitMain.Height) Then
                    If bitMain.Height > 100 Then
                        myThumbnailMain = bitMain.GetThumbnailImage(100 * bitMain.Width / bitMain.Height, 100, myCallback, IntPtr.Zero)
                    Else
                        myThumbnailMain = bitMain.GetThumbnailImage(bitMain.Width, bitMain.Height, myCallback, IntPtr.Zero)
                    End If

                Else
                    If bitMain.Width > 100 Then
                        myThumbnailMain = bitMain.GetThumbnailImage(100, bitMain.Height * 100 / bitMain.Width, myCallback, IntPtr.Zero)
                    Else
                        myThumbnailMain = bitMain.GetThumbnailImage(bitMain.Width, bitMain.Height, myCallback, IntPtr.Zero)
                    End If
                End If

                Dim ms1 As New MemoryStream
                myThumbnailMain.Save(ms1, System.Drawing.Imaging.ImageFormat.Bmp)
                Dim image As New SqlTypes.SqlBytes(ms1.GetBuffer)

                ms1.Close()
                msTemp.Close()
                msMain.Close()
                With _reportSettings
                    .Image = image
                End With
            End If
            Dim DisplayArea As String
            DisplayArea = "HEADER"
            Dim imageDisplaySettingsXML As String = "<ROOT><IMAGE REF = """ + chkLogo.ID + """ DISPLAYAREA = """ + objCommonUtil.ConvertStr(DisplayArea) + """ ALIGN = """ + objCommonUtil.ConvertStr(ddlAlignment.SelectedValue) + """ DISPLAY = """ + chkLogo.Checked.ToString + """></IMAGE></ROOT>"
            sr = New System.IO.StringReader(imageDisplaySettingsXML)
            xtr = New System.Xml.XmlTextReader(sr)
            newXml = New SqlXml(xtr)
            _reportSettings.ImageDisplaySettings = newXml
            _reportSettings.SaveImagewithDisplaySettings()

            'Footer Image
            If fileBrowseFooter.PostedFile Is Nothing Or fileBrowseFooter.PostedFile.FileName = String.Empty Then
                _reportSettings.Image = SqlTypes.SqlBytes.Null
            Else
                Dim myCallback As New System.Drawing.Image.GetThumbnailImageAbort(AddressOf ThumbnailCallback)

                Dim bitmapData As [Byte]() = New [Byte](fileBrowseFooter.FileBytes.Length - 1) {}
                bitmapData = fileBrowseFooter.FileBytes
                Dim msTemp As MemoryStream = New MemoryStream(bitmapData, 0, bitmapData.Length)

                Dim myThumbnailTemp As System.Drawing.Image = Nothing
                Dim msMain As New MemoryStream

                Dim bitTemp As System.Drawing.Bitmap = New System.Drawing.Bitmap(msTemp)


                myThumbnailTemp = bitTemp.GetThumbnailImage(bitTemp.Width, bitTemp.Height, myCallback, IntPtr.Zero)
                myThumbnailTemp.Save(msMain, System.Drawing.Imaging.ImageFormat.Bmp)

                Dim bitMain As System.Drawing.Bitmap = New System.Drawing.Bitmap(msMain)

                Dim myThumbnailMain As System.Drawing.Image = Nothing

                If (bitMain.Width < bitMain.Height) Then
                    If bitMain.Height > 100 Then
                        myThumbnailMain = bitMain.GetThumbnailImage(100 * bitMain.Width / bitMain.Height, 100, myCallback, IntPtr.Zero)
                    Else
                        myThumbnailMain = bitMain.GetThumbnailImage(bitMain.Width, bitMain.Height, myCallback, IntPtr.Zero)
                    End If

                Else
                    If bitMain.Width > 100 Then
                        myThumbnailMain = bitMain.GetThumbnailImage(100, bitMain.Height * 100 / bitMain.Width, myCallback, IntPtr.Zero)
                    Else
                        myThumbnailMain = bitMain.GetThumbnailImage(bitMain.Width, bitMain.Height, myCallback, IntPtr.Zero)
                    End If
                End If

                Dim ms1 As New MemoryStream
                myThumbnailMain.Save(ms1, System.Drawing.Imaging.ImageFormat.Bmp)
                Dim image As New SqlTypes.SqlBytes(ms1.GetBuffer)

                ms1.Close()
                msTemp.Close()
                msMain.Close()
                With _reportSettings
                    .Image = image
                End With

            End If
            DisplayArea = "FOOTER"
            imageDisplaySettingsXML = "<ROOT><IMAGE REF = """ + chkFooter.ID + """ DISPLAYAREA = """ + objCommonUtil.ConvertStr(DisplayArea) + """ ALIGN = """ + objCommonUtil.ConvertStr(ddlFooterAlignment.SelectedValue) + """ DISPLAY = """ + chkFooter.Checked.ToString + """></IMAGE></ROOT>"
            sr = New System.IO.StringReader(imageDisplaySettingsXML)
            xtr = New System.Xml.XmlTextReader(sr)
            newXml = New SqlXml(xtr)
            _reportSettings.ImageDisplaySettings = newXml
            _reportSettings.SaveImagewithDisplaySettings()

            Dim printerSettingsXML As String


            printerSettingsXML = "<ROOT><PRINTER DEFAULTPRINTER = """ & objCommonUtil.ConvertStr(txtLocation.Text) _
          & """ NOOFCOPIES = """ & String.Empty & """ DRAWER1 = """ & String.Empty _
          & """ DRAWER2= """" LOCATION = """ & objCommonUtil.ConvertStr(txtLocation.Text) & """ SENDTOPRINTER  = """ & String.Empty & """></PRINTER></ROOT>"


            sr = New System.IO.StringReader(printerSettingsXML)
            xtr = New System.Xml.XmlTextReader(sr)
            newXml = New SqlXml(xtr)
            _reportSettings.DisplaySettingsXML = newXml
            _reportSettings.SavePrinterSettings()

            If String.IsNullOrEmpty(ViewState("ReportSettingsID")) Then
                _reportSettings.ReportSettingID = SqlTypes.SqlInt32.Null
            Else
                _reportSettings.ReportSettingID = Convert.ToInt32(ViewState("ReportSettingsID"))
            End If
            _reportSettings.Name = String.Empty
            _reportSettings.ReportName = String.Empty
            _reportSettings.Caption = String.Empty
            _reportSettings.SaveReportSettings()

            ApplyDisplaySettings()

            'RTlblError.Text = "Saved Successfully"
            RTlblError.Text = objErrHandle.GetErrorDesc("MSG074")
            RTlblError.ForeColor = Drawing.Color.Green
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Reports_DeliveryNoteSettings", "SaveDisplaySettings", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, Session("UserId"))
        End Try
    End Sub

    Public Function ThumbnailCallback() As Boolean
        Return True
    End Function

    Protected Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click
        RTlblError.Text = ""
        If drpSubsidiary.SelectedValue = "0" Then
            RTlblError.Text = objErrHandle.GetErrorDesc("RSELECTSUB")
            RTlblError.ForeColor = Drawing.Color.Blue
            Exit Sub
        Else
            RTlblError.Text = ""
        End If
        If (drpSubsidiary.SelectedValue <> "0" And drpDepartment.SelectedValue = "0") Then
            RTlblError.Text = objErrHandle.GetErrorDesc("MSG064")
            RTlblError.ForeColor = Drawing.Color.Blue
            Exit Sub
        Else
            RTlblError.Text = ""
        End If
        SaveDisplaySettings()
    End Sub
    Protected Sub drpSubsidiary_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles drpSubsidiary.SelectedIndexChanged
        RTlblError.Text = ""
        FillDepartment()
        ApplyDisplaySettings()
    End Sub
    Protected Sub drpDepartment_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles drpDepartment.SelectedIndexChanged
        RTlblError.Text = ""
        If drpSubsidiary.SelectedValue = "0" Then
            objConfigDeptBO.LoginId = loginName
            Dim Departments As DataSet = objConfigDeptDO.FetchAllDepartments(objConfigDeptBO)

            If Not drpDepartment.SelectedValue = "0" Then
                Dim drarr As DataRow() = Departments.Tables(0).Select("DEPARTMENTID = '" + objCommonUtil.fnReplaceSQL(drpDepartment.SelectedValue) + "'")
                objConfigSubBO.UserID = loginName
                Dim Subsidiaries As DataSet = objConfigSubDO.FetchAllSubsidiary(objConfigSubBO)
                Dim drarrs As DataRow() = Subsidiaries.Tables(0).Select("SUBSIDIARYNAME = '" + objCommonUtil.fnReplaceSQL(drarr(0)("SUBSIDIARY").ToString()) + "'")
                drpSubsidiary.SelectedValue = drarrs(0)("SubsidiaryID").ToString()
            End If

        End If
        ApplyDisplaySettings()
    End Sub
    Protected Sub ddlSecondaryOrderType_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlSecondaryOrderType.SelectedIndexChanged
        ApplyDisplaySettings()
    End Sub
    Protected Sub lnkLogo_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Try
            If Not Session("Rep_DeliveryNoteSettings_LogoImage") Is Nothing Then
                Session("RepImage") = Session("Rep_DeliveryNoteSettings_LogoImage")
                Dim strScript As String = "<script>var windowImg = window.open('DisplayImage.ashx','DisplayImage','width=800px;height=400px;menubar=no,location=no,status=no,scrollbars=yes,resizable=yes'); windowImg.focus();</script>"
                ScriptManager.RegisterClientScriptBlock(Me.Page, Me.GetType(), "Open", strScript, False)
            End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Reports_PickingListSettings", "lnkLogo_Click", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, Session("UserId"))
        End Try
    End Sub

    Protected Sub lnkFooter_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Try
            If Not Session("Rep_DeliveryNoteSettings_FooterImage") Is Nothing Then
                Session("RepImage") = Session("Rep_DeliveryNoteSettings_FooterImage")
                Dim strScript As String = "<script>var windowImgFooter = window.open('DisplayImage.ashx','DisplayImage','width=800px;height=400px;menubar=no,location=no,status=no,scrollbars=yes,resizable=yes'); windowImgFooter.focus();</script>"
                ScriptManager.RegisterClientScriptBlock(Me.Page, Me.GetType(), "Open", strScript, False)
            End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Reports_PickingListSettings", "lnkViewFooter_Click", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, Session("UserId"))
        End Try
    End Sub
    Protected Sub ddlDefaultPrinter_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlDefaultPrinter.SelectedIndexChanged
        txtLocation.Text = ddlDefaultPrinter.SelectedValue
    End Sub
End Class