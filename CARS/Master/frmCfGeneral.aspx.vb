Imports System.Web.Services
Imports CARS.CoreLibrary
Imports CARS.CoreLibrary.CARS
Imports System.Web.Security
Imports System.Web.UI
Imports Encryption
Public Class frmCfGeneral
    Inherits System.Web.UI.Page
    Shared commonUtil As New Utilities.CommonUtility
    Shared dtCaption As DataTable
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared objZipCodesBO As New ZipCodesBO
    Shared objConfigGenServ As New Services.ConfigGeneral.ConfigGeneral
    Shared details As New List(Of ZipCodesBO)()
    Shared configdetails As New List(Of ConfigSettingsBO)()
    Shared loginName As String
    Dim objuserper As New UserAccessPermissionsBO
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Dim strscreenName As String = ""
            If Session("UserID") Is Nothing Or Session("UserPageperDT") Is Nothing Then
                Response.Redirect("~/frmLogin.aspx")
            Else
                loginName = CType(Session("UserID"), String)
            End If
            dtCaption = DirectCast(Cache("Caption"), System.Data.DataTable)
            hdnSelect.Value = dtCaption.Select("TAG='select'")(0)(1)
            hdnPageSize.Value = System.Configuration.ConfigurationManager.AppSettings("PageSize")
            strscreenName = IO.Path.GetFileName(Me.Request.PhysicalPath)

            cmbTimeFormat.Items.Clear()
            cmbTimeFormat.Items.Add(dtCaption.Select("TAG='select'")(0)(1))
            cmbTimeFormat.AppendDataBoundItems = True
            commonUtil.ddlGetValue(strscreenName, cmbTimeFormat)

            cmbUnitofTimings.Items.Clear()
            cmbUnitofTimings.Items.Add(dtCaption.Select("TAG='select'")(0)(1))
            cmbUnitofTimings.AppendDataBoundItems = True
            commonUtil.ddlGetValue(strscreenName, cmbUnitofTimings)

            SetPermission()

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfGeneral", "Page_Load", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub

    <WebMethod()> _
    Public Shared Function LoadGenSettings() As Collection
        Dim configDetails As New Collection
        Try
            configDetails = objConfigGenServ.FetchAllZipCode()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfGeneral", "LoadGenSettings", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return configDetails
    End Function
    <WebMethod()> _
    Public Shared Function SaveGenSettings(ByVal timeFormat As String, ByVal unitOfTime As String, ByVal currency As String, ByVal minSplits As String,
                                      ByVal useSubRepCode As String, ByVal useAutoResize As String, ByVal useDynClkTime As String, ByVal useNewJobCard As String,
                                      ByVal useEdtStdTime As String, ByVal useViewGarSum As String, ByVal useMondStDay As String, ByVal useVehRegn As String,
                                      ByVal useInvPdf As String, ByVal useDBS As String, ByVal useApprIR As String, ByVal useMechGrid As String,
                                      ByVal useSortPL As String, ByVal useValStdTime As String, ByVal useEdtChgTime As String, ByVal useValMileage As String,
                                      ByVal useSavUpdDP As String, ByVal useIntNote As String, ByVal useGrpSPBO As String, ByVal useDispWOSpares As String) As String
        Dim strResult As String = ""
        Try
            strResult = objConfigGenServ.SaveGenSettings(timeFormat, unitOfTime, currency, minSplits, useSubRepCode, useAutoResize, useDynClkTime, useNewJobCard, useEdtStdTime, useViewGarSum, useMondStDay, useVehRegn, useInvPdf, useDBS, useApprIR, useMechGrid, useSortPL, useValStdTime, useEdtChgTime, useValMileage, useSavUpdDP, useIntNote, useGrpSPBO, useDispWOSpares)

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfGeneral", "SaveUSTime", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function

    <WebMethod()> _
    Public Shared Function SaveZipCode(ByVal zipcode As String, ByVal country As String, ByVal state As String, ByVal city As String, ByVal mode As String) As String
        Dim strResult As String = ""
        Try
            objZipCodesBO.ZipCode = zipcode
            objZipCodesBO.Country = country
            objZipCodesBO.State = state
            objZipCodesBO.City = city

            strResult = objConfigGenServ.SaveZipCodes(objZipCodesBO, mode)

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfGeneral", "SaveZipCode", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function

    <WebMethod()> _
    Public Shared Function GetZipCodeDetails(ByVal zipCode As String) As ZipCodesBO()
        Try

            details = objConfigGenServ.GetZipCodeDetails(zipCode)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfGeneral", "GetZipCodeDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function

    <WebMethod()> _
    Public Shared Function DeleteZipCode(ByVal delxml As String) As String()
        Dim strResult As String()
        Try
            strResult = objConfigGenServ.DeleteZipCode(delxml)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfGeneral", "DeleteZipCode", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function

    <WebMethod()> _
    Public Shared Function LoadConfig() As Collection
        Dim configDetails As New Collection
        Try
            configDetails = objConfigGenServ.FetchConfigSettings()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfGeneral", "LoadConfig", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return configDetails
    End Function

    <WebMethod()> _
    Public Shared Function SaveConfig(ByVal idconfig As String, ByVal idsettings As String, ByVal desc As String, ByVal mode As String) As ConfigSettingsBO()
        Try
            Dim strXMLDocMas As String = ""
            If (mode = "Add") Then
                strXMLDocMas = ""
                strXMLDocMas = "<insert ID_CONFIG=""" + idconfig + """ DESCRIPTION=""" + desc.Trim.Replace("<", "&lt;").Replace(">", "&gt;") + """/>"
                strXMLDocMas = "<root>" + strXMLDocMas + "</root>"
                configdetails = commonUtil.AddConfigDetails(strXMLDocMas)
            Else
                strXMLDocMas = ""
                strXMLDocMas = "<MODIFY ID_CONFIG=""" + idconfig + """ ID_SETTINGS=""" + idsettings + """ DESCRIPTION=""" + desc.Trim.Replace("<", "&lt;").Replace(">", "&gt;") + """/>"
                strXMLDocMas = "<ROOT>" + strXMLDocMas + "</ROOT>"
                configdetails = commonUtil.UpdateConfigDetails(strXMLDocMas)
            End If


        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfGeneral", "SaveConfig", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return configdetails.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function DeleteConfig(ByVal xmlDoc As String) As String()
        Dim strResult As String()
        Try
            strResult = commonUtil.DeleteConfig(xmlDoc)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfGeneral", "DeleteConfig", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
    <WebMethod()> _
    Public Shared Function SaveVATCode(ByVal idconfig As String, ByVal idsettings As String, ByVal vatcode As String, ByVal vatper As String, ByVal extvatcode As String, ByVal extvataccntcode As String, ByVal mode As String) As ConfigSettingsBO()
        Try
            Dim strXMLDocMas As String = ""
            If (mode = "Add") Then
                strXMLDocMas = ""
                strXMLDocMas = "<insert ID_CONFIG=""" + idconfig + """ DESCRIPTION=""" + vatcode.Trim.Replace("<", "&lt;").Replace(">", "&gt;") + """ VAT_PERCENTAGE=""" + vatper + """ EXT_VAT_CODE=""" + extvatcode + """ EXT_ACC_CODE=""" + extvataccntcode + """/>"
                strXMLDocMas = "<root>" + strXMLDocMas + "</root>"
                configdetails = commonUtil.AddConfigDetails(strXMLDocMas)
            Else
                strXMLDocMas = ""
                strXMLDocMas = "<MODIFY ID_CONFIG=""" + idconfig + """ ID_SETTINGS=""" + idsettings + """ DESCRIPTION=""" + vatcode.Trim.Replace("<", "&lt;").Replace(">", "&gt;") + """ VAT_PERCENTAGE=""" + vatper + """ EXT_VAT_CODE=""" + extvatcode + """ EXT_ACC_CODE=""" + extvataccntcode + """/>"
                strXMLDocMas = "<ROOT>" + strXMLDocMas + "</ROOT>"
                configdetails = commonUtil.UpdateConfigDetails(strXMLDocMas)
            End If


        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfGeneral", "SaveVATCode", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return configdetails.ToList.ToArray()
    End Function

    <WebMethod()> _
    Public Shared Function SaveStationType(ByVal desc As String, ByVal stattypeId As String, ByVal mode As String) As ConfigSettingsBO()
        Try
            Dim strXMLDocMas As String = ""
            If (mode = "Add") Then
                strXMLDocMas = ""
                strXMLDocMas = "<insert TYPE_STATION=""" + desc + """/>"
                strXMLDocMas = "<root>" + strXMLDocMas + "</root>"
                configdetails = objConfigGenServ.AddStationType(strXMLDocMas)
            Else
                strXMLDocMas = ""
                strXMLDocMas = "<MODIFY ID_STYPE=""" + stattypeId + """ TYPE_STATION=""" + desc + """/>"
                strXMLDocMas = "<ROOT>" + strXMLDocMas + "</ROOT>"
                configdetails = objConfigGenServ.UpdateStationType(strXMLDocMas)
            End If


        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfGeneral", "SaveStationType", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return configdetails.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function DeleteStationType(ByVal xmlDoc As String) As String()
        Dim strResult As String()
        Try
            strResult = objConfigGenServ.DeleteStationType(xmlDoc)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfGeneral", "DeleteStationType", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
    <WebMethod()> _
    Public Shared Function SaveSMSSettings(ByVal smsServer As String, ByVal smsPrefix As String, ByVal smsSuffix As String, ByVal smsCtryCode As String,
                                    ByVal smsNoChars As String, ByVal smsStDigit As String, ByVal smsMailUsr As String) As String
        Dim strResult As String = ""
        Try
            strResult = objConfigGenServ.SaveSMSSettings(smsServer, smsPrefix, smsSuffix, smsCtryCode, smsNoChars, smsStDigit, smsMailUsr)

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfGeneral", "SaveSMSSettings", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
    <WebMethod()> _
    Public Shared Function SaveDeptMessages(ByVal messageid As String, ByVal deptid As String, ByVal commtext As String, ByVal detailtext As String, ByVal mode As String) As String
        Dim strXMLDocMess As String = ""
        Try
            If (mode = "Add") Then
                strXMLDocMess = ""
                strXMLDocMess = "<INSERT ID_DEPT=""" + deptid + """ COMMERCIAL_TEXT=""" + commtext + """ DETAIL_TEXT=""" + detailtext + """ CREATED_BY=""" + loginName + """/>"
                strXMLDocMess = "<ROOT>" + strXMLDocMess + "</ROOT>"
                strXMLDocMess = objConfigGenServ.AddDeptMessage(strXMLDocMess, deptid, messageid)
            Else
                strXMLDocMess = ""
                strXMLDocMess = "<MODIFY ID_MESSAGES=""" + messageid + """ ID_DEPT=""" + deptid + """ COMMERCIAL_TEXT=""" + commtext + """ DETAIL_TEXT=""" + detailtext + """ MODIFIED_BY=""" + loginName + """/>"
                strXMLDocMess = "<ROOT>" + strXMLDocMess + "</ROOT>"
                strXMLDocMess = objConfigGenServ.UpdateDeptMessage(strXMLDocMess, deptid, messageid)
            End If


        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfGeneral", "SaveDeptMessages", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strXMLDocMess
    End Function
    <WebMethod()> _
    Public Shared Function DeleteDeptMessage(ByVal xmldata As String) As String
        Dim strResult As String = ""
        Try
            strResult = objConfigGenServ.DeleteDeptMessage(xmldata)

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfGeneral", "DeleteDeptMessages", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
    <WebMethod()> _
    Public Shared Function GetDeptMessDetails(ByVal messId As String) As ConfigSettingsBO()
        Dim configdetails As New List(Of ConfigSettingsBO)()
        Try

            configdetails = objConfigGenServ.GetDeptMessDetails(messId)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfGeneral", "GetDeptMessDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return configdetails.ToList.ToArray()
    End Function

    Private Sub SetPermission()
        Dim dt As New DataTable
        Dim str As String
        Dim objLoginBo As New LoginBO
        dt = Session("UserPageperDT")
        If Not dt Is Nothing Then
            str = "/master/frmCfGeneral.aspx" 'Request.Url.AbsolutePath frmCfRepairPackage
            objuserper = commonUtil.GetUserScrPer(dt, str)
            If Not objuserper Is Nothing Then
                If objuserper.PF_ACC_VIEW = True Then
                    btnAddDeptMessT.Disabled = Convert.ToBoolean(IIf(btnAddDeptMessT.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnAddDeptMessB.Disabled = Convert.ToBoolean(IIf(btnAddDeptMessB.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnAddDiscCodeT.Disabled = Convert.ToBoolean(IIf(btnAddDiscCodeT.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnAddDiscCodeB.Disabled = Convert.ToBoolean(IIf(btnAddDiscCodeB.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnAddReasonT.Disabled = Convert.ToBoolean(IIf(btnAddReasonT.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnAddReasonB.Disabled = Convert.ToBoolean(IIf(btnAddReasonB.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnAddStationTypeT.Disabled = Convert.ToBoolean(IIf(btnAddStationTypeT.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnAddStationTypeB.Disabled = Convert.ToBoolean(IIf(btnAddStationTypeB.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnAddVATCodeT.Disabled = Convert.ToBoolean(IIf(btnAddVATCodeT.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnAddVATCodeB.Disabled = Convert.ToBoolean(IIf(btnAddVATCodeB.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnAddZipCodeT.Disabled = Convert.ToBoolean(IIf(btnAddZipCodeT.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnAddZipCodeB.Disabled = Convert.ToBoolean(IIf(btnAddZipCodeB.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))

                    btnDelDeptMessT.Disabled = Convert.ToBoolean(IIf(btnDelDeptMessT.Disabled = False, IIf(objuserper.PF_ACC_DELETE = True, False, True), True))
                    btnDelDeptMessB.Disabled = Convert.ToBoolean(IIf(btnDelDeptMessB.Disabled = False, IIf(objuserper.PF_ACC_DELETE = True, False, True), True))
                    btnDelDiscCodeT.Disabled = Convert.ToBoolean(IIf(btnDelDiscCodeT.Disabled = False, IIf(objuserper.PF_ACC_DELETE = True, False, True), True))
                    btnDelDiscCodeB.Disabled = Convert.ToBoolean(IIf(btnDelDiscCodeB.Disabled = False, IIf(objuserper.PF_ACC_DELETE = True, False, True), True))
                    btnDelReasonT.Disabled = Convert.ToBoolean(IIf(btnDelReasonT.Disabled = False, IIf(objuserper.PF_ACC_DELETE = True, False, True), True))
                    btnDelReasonB.Disabled = Convert.ToBoolean(IIf(btnDelReasonB.Disabled = False, IIf(objuserper.PF_ACC_DELETE = True, False, True), True))
                    btnDelStationTypeT.Disabled = Convert.ToBoolean(IIf(btnDelStationTypeT.Disabled = False, IIf(objuserper.PF_ACC_DELETE = True, False, True), True))
                    btnDelStationTypeB.Disabled = Convert.ToBoolean(IIf(btnDelStationTypeB.Disabled = False, IIf(objuserper.PF_ACC_DELETE = True, False, True), True))
                    btnDelVATCodeT.Disabled = Convert.ToBoolean(IIf(btnDelVATCodeT.Disabled = False, IIf(objuserper.PF_ACC_DELETE = True, False, True), True))
                    btnDelVATCodeB.Disabled = Convert.ToBoolean(IIf(btnDelVATCodeB.Disabled = False, IIf(objuserper.PF_ACC_DELETE = True, False, True), True))
                    btnDelZipCodeT.Disabled = Convert.ToBoolean(IIf(btnDelZipCodeT.Disabled = False, IIf(objuserper.PF_ACC_DELETE = True, False, True), True))
                    btnDelZipCodeB.Disabled = Convert.ToBoolean(IIf(btnDelZipCodeB.Disabled = False, IIf(objuserper.PF_ACC_DELETE = True, False, True), True))

                    btnSaveDeptMess.Disabled = Convert.ToBoolean(IIf(btnSaveDeptMess.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnSaveDiscCode.Disabled = Convert.ToBoolean(IIf(btnSaveDiscCode.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnSaveGenSett.Disabled = Convert.ToBoolean(IIf(btnSaveGenSett.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnSaveReason.Disabled = Convert.ToBoolean(IIf(btnSaveReason.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnSaveSMS.Disabled = Convert.ToBoolean(IIf(btnSaveSMS.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnSaveStationType.Disabled = Convert.ToBoolean(IIf(btnSaveStationType.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnSaveVATCode.Disabled = Convert.ToBoolean(IIf(btnSaveVATCode.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnSaveZipCode.Disabled = Convert.ToBoolean(IIf(btnSaveZipCode.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                End If
            End If
        End If
    End Sub

End Class