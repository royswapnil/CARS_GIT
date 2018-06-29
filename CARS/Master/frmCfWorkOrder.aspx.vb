Imports System.Web.Services
Imports CARS.CoreLibrary
Imports CARS.CoreLibrary.CARS
Imports System.Web.Security
Imports System.Web.UI
Imports Encryption

Public Class frmCfWorkOrder
    Inherits System.Web.UI.Page
    Shared commonUtil As New Utilities.CommonUtility
    Shared dtCaption As DataTable
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared objWorkOrderBO As New ConfigWorkOrderBO
    Shared objWOServ As New Services.ConfigWO.ConfigWorkOrder
    Shared objServCustomer As New Services.Customer.CustomerDetails
    Shared details As New List(Of ConfigWorkOrderBO)()
    Shared configdetails As New List(Of ConfigWorkOrderBO)()
    Shared loginName As String
    Dim objuserper As New UserAccessPermissionsBO
    Shared objConfigDeptBO As New ConfigDepartmentBO
    Shared strscreenName As String = ""
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try

            If Session("UserID") Is Nothing Or Session("UserPageperDT") Is Nothing Then
                Response.Redirect("~/frmLogin.aspx")
            Else
                loginName = CType(Session("UserID"), String)
            End If
            dtCaption = DirectCast(Cache("Caption"), System.Data.DataTable)
            hdnSelect.Value = dtCaption.Select("TAG='select'")(0)(1)
            hdnPageSize.Value = System.Configuration.ConfigurationManager.AppSettings("PageSize")
            strscreenName = IO.Path.GetFileName(Me.Request.PhysicalPath)
            commonUtil.ddlGetValue(strscreenName, cmbChargeBasedOn)
            cmbChargeBasedOn.Items.Insert(0, New ListItem(hdnSelect.Value, "--Select--"))
            SetPermission()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfWorkOrder", "Page_Load", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub
    <WebMethod()> _
    Public Shared Function LoadConfigWorkOrder(ByVal subId As String, ByVal deptId As String) As Collection
        Dim details As New Collection
        Try
            details = objWOServ.FetchConfigWorkOder(subId, deptId)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfWorkOrder", "LoadConfigWorkOrder", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details
    End Function
    <WebMethod()> _
    Public Shared Function LoadSubsidiary() As ConfigDepartmentBO()
        Dim details As New List(Of ConfigDepartmentBO)()
        Try
            objConfigDeptBO.LoginId = loginName.ToString
            details = commonUtil.LoadSubsidiaries(objConfigDeptBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfWorkOrder", "LoadSubsidiary", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function LoadDepartment(ByVal subId As String) As ConfigDepartmentBO()
        Dim details As New List(Of ConfigDepartmentBO)()
        Try
            objConfigDeptBO.LoginId = loginName.ToString()
            objConfigDeptBO.SubsideryId = subId.ToString()
            details = commonUtil.GetDepartment(objConfigDeptBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfWorkOrder", "LoadDepartment", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function LoadStatus(ByVal ordType As String) As WOHeaderBO()
        Dim objWOHeaderServ As New Services.WOHeader.WOHeader
        Dim headerdetails As New List(Of WOHeaderBO)
        strscreenName = "frmWOHead.aspx" 'status is loaded
        Try
            headerdetails = objWOHeaderServ.FetchWOStatus(ordType, strscreenName)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfWorkOrder", "LoadStatus", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return headerdetails.ToList.ToArray()
    End Function
    '<WebMethod()> _
    'Public Shared Function SaveProdGrp(ByVal prodGrpId As String, ByVal prodGrp As String, ByVal discCode As String, ByVal vatCode As String, ByVal prodDesc As String, ByVal subId As String, ByVal deptId As String, ByVal mode As String) As String()
    '    Dim strRes As String()
    '    Try
    '        Dim strXMLDoc As String = ""
    '        If (mode = "Add") Then
    '            strXMLDoc = ""
    '            strXMLDoc = "<DIS><ID_SUB>" + (Val(subId)).ToString() + "</ID_SUB><ID_DEPT>" + (Val(deptId)).ToString() + "</ID_DEPT><CATEGORY>"
    '            strXMLDoc += prodGrp.ToString() + "</CATEGORY><DISCODE>" + discCode.ToString() + "</DISCODE><VATCODE>" + vatCode.ToString() + "</VATCODE><DESCRIPTION>" + prodDesc.ToString() + "</DESCRIPTION></DIS>"
    '            strXMLDoc = "<ROOT>" + strXMLDoc + "</ROOT>"
    '            strRes = objWOServ.SaveProductGroup(strXMLDoc)
    '        Else
    '            strXMLDoc = ""
    '            strXMLDoc = "<DISCODE><ID>" + prodGrpId.ToString() + "</ID><MAKE>" + prodGrp.ToString() + "</MAKE><DIS>" + discCode.ToString() + "</DIS><VAT>" + vatCode.ToString() + "</VAT><DESCRIPTION>" + prodDesc.ToString() + "</DESCRIPTION></DISCODE>"
    '            strXMLDoc = "<ROOT>" + strXMLDoc + "</ROOT>"
    '            strRes = objWOServ.UpdateProductGroup(strXMLDoc)
    '        End If


    '    Catch ex As Exception
    '        objErrHandle.WriteErrorLog(1, "Master_frmCfWorkOrder", "SaveProdGrp", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
    '    End Try
    '    Return strRes
    'End Function

    <WebMethod()> _
    Public Shared Function SavePayType(ByVal idConfig As String, ByVal payType As String, ByVal payTypeId As String, ByVal payTypeDesc As String, ByVal mode As String) As String()
        Dim strRes As String()
        Try
            Dim strXMLDoc As String = ""
            If (mode = "Add") Then
                strXMLDoc = ""
                strXMLDoc = "<PAY><ID_CONFIG>" + idConfig.ToString() + "</ID_CONFIG><DESCRIPTION>" + payType.ToString() + "</DESCRIPTION><REMARKS>"
                strXMLDoc += payTypeDesc.ToString() + "</REMARKS></PAY>"
                strXMLDoc = "<ROOT>" + strXMLDoc + "</ROOT>"
                strRes = objWOServ.SavePayType(strXMLDoc)
            Else
                strXMLDoc = ""
                strXMLDoc = "<PAY><ID>" + payTypeId.ToString() + "</ID><DES>" + payType.ToString() + "</DES><REM>" + payTypeDesc.ToString() + "</REM></PAY>"
                strXMLDoc = "<ROOT>" + strXMLDoc + "</ROOT>"
                strRes = objWOServ.UpdatePayType(strXMLDoc)
            End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfWorkOrder", "SavePayType", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strRes
    End Function
    <WebMethod()> _
    Public Shared Function DeletePayType(ByVal delxml As String) As String()
        Dim strResult As String()
        Try
            strResult = objWOServ.DeletePayType(delxml)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfWorkOrder", "DeletePayType", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
    <WebMethod()> _
    Public Shared Function SaveVATCode(ByVal vatCodeId As String, ByVal vatcodeoncust As String, ByVal vatcodeonitem As String, ByVal vatcodeonveh As String, ByVal vatcodeonordline As String, ByVal vatacccode As String, ByVal mode As String) As String()
        Dim strRes As String()
        Try
            Dim strXMLDoc As String = ""
            If (mode = "Add") Then
                strXMLDoc = ""
                strXMLDoc = "<VAT><VAT_ITEM>" + vatcodeonitem.ToString() + "</VAT_ITEM><VAT_CUAST>" + vatcodeoncust.ToString() + "</VAT_CUAST><VAT_VEH>" + vatcodeonveh.ToString() + "</VAT_VEH><VAT_PER>" + vatcodeonordline.ToString() + "</VAT_PER><CREATED_BY>" + loginName.ToString() + "</CREATED_BY><ACCOUNTCODE>" + vatacccode.ToString() + "</ACCOUNTCODE></VAT>"
                strXMLDoc = "<ROOT>" + strXMLDoc + "</ROOT>"
                strRes = objWOServ.SaveVATCode(strXMLDoc)
            Else
                strXMLDoc = ""
                strXMLDoc = "<VAT><ID_VAT_SEQ>" + vatCodeId.ToString() + "</ID_VAT_SEQ><VAT_ITEM>" + vatcodeonitem.ToString() + "</VAT_ITEM><VAT_CUAST>" + vatcodeoncust.ToString() + "</VAT_CUAST><VAT_VEH>" + vatcodeonveh.ToString() + "</VAT_VEH><VAT_PER>" + vatcodeonordline.ToString() + "</VAT_PER><ACCOUNTCODE>" + vatacccode.ToString() + "</ACCOUNTCODE></VAT>"
                strXMLDoc = "<ROOT>" + strXMLDoc + "</ROOT>"
                strRes = objWOServ.UpdateVATCode(strXMLDoc)
            End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfWorkOrder", "SaveVATCode", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strRes
    End Function
    <WebMethod()> _
    Public Shared Function DeleteVATCode(ByVal delxml As String) As String()
        Dim strResult As String()
        Try
            strResult = objWOServ.DeleteVATCode(delxml)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfWorkOrder", "DeleteVATCode", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
    <WebMethod()> _
    Public Shared Function SaveWorkOrderConfig(ByVal idSub As String, ByVal idDept As String, ByVal woPrefix As String, ByVal woSeries As String, ByVal ownRisk As String, ByVal woGMPerc As String, ByVal woChrgBase As String, ByVal useDelvAddr As String, ByVal useManualRwrk As String, ByVal useVeh As String, ByVal usePCJob As String, ByVal woStatus As String, ByVal useDefCust As String, ByVal idCustomer As String, ByVal useConfirmDialogue As String, ByVal useSaveJobGrid As String, ByVal useVAAccCode As String, ByVal vaAccntCode As String, ByVal useSpareSearch As String, ByVal dispRinvPinv As String) As String()
        Dim strResult As String()
        Try
            objWorkOrderBO.Id_Subsidery = idSub
            objWorkOrderBO.Id_Dept = idDept
            objWorkOrderBO.WOPr = woPrefix
            objWorkOrderBO.Ord_Num = woSeries
            objWorkOrderBO.Own_Risk = ownRisk
            objWorkOrderBO.WO_GMPrice_Perc = woGMPerc
            objWorkOrderBO.WO_Charege_Base = woChrgBase
            objWorkOrderBO.Use_Delv_Address = useDelvAddr
            objWorkOrderBO.Use_Manual_Rwrk = useManualRwrk
            objWorkOrderBO.Use_Vehicle_Sp = useVeh
            objWorkOrderBO.Use_Pc_Job = usePCJob
            objWorkOrderBO.WO_Status = woStatus
            objWorkOrderBO.Use_Default_Cust = useDefCust
            objWorkOrderBO.IdCustomer = idCustomer
            objWorkOrderBO.Use_Cnfrm_Dialogue = useConfirmDialogue
            objWorkOrderBO.Use_SaveJob_Grid = useSaveJobGrid
            objWorkOrderBO.Use_VA_ACC_Code = useVAAccCode
            objWorkOrderBO.VA_ACC_Code = vaAccntCode
            objWorkOrderBO.Use_All_Spare_Search = useSpareSearch
            objWorkOrderBO.Disp_Rinv_Pinv = dispRinvPinv
            strResult = objWOServ.SaveWorkOrderConfig(objWorkOrderBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfWorkOrder", "SaveWorkOrderConfig", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
    <WebMethod()> _
    Public Shared Function SaveWOCopy(ByVal subId As String, ByVal deptId As String, ByVal copySubId As String, ByVal copyDeptId As String) As String
        Dim strResult As String
        Try
            strResult = objWOServ.SaveWOCopy(subId, deptId, copySubId, copyDeptId)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfWorkOrder", "SaveWOCopy", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
    Private Sub SetPermission()
        Dim dt As New DataTable
        Dim str As String
        Dim objLoginBo As New LoginBO
        dt = Session("UserPageperDT")
        If Not dt Is Nothing Then
            str = "/Master/frmCfWorkOrder.aspx" 'Request.Url.AbsolutePath frmCfRepairPackage
            objuserper = commonUtil.GetUserScrPer(dt, str)
            If Not objuserper Is Nothing Then
                If objuserper.PF_ACC_VIEW = True Then
                    btnAddPayTypeT.Disabled = Convert.ToBoolean(IIf(btnAddPayTypeT.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnAddPayTypeB.Disabled = Convert.ToBoolean(IIf(btnAddPayTypeB.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnAddVATCodeT.Disabled = Convert.ToBoolean(IIf(btnAddVATCodeT.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnAddVATCodeB.Disabled = Convert.ToBoolean(IIf(btnAddVATCodeB.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnSavePayType.Disabled = Convert.ToBoolean(IIf(btnSavePayType.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnSaveVATCode.Disabled = Convert.ToBoolean(IIf(btnSaveVATCode.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    
                    btnDelPayTypeT.Disabled = Convert.ToBoolean(IIf(btnDelPayTypeT.Disabled = False, IIf(objuserper.PF_ACC_DELETE = True, False, True), True))
                    btnDelPayTypeB.Disabled = Convert.ToBoolean(IIf(btnDelPayTypeB.Disabled = False, IIf(objuserper.PF_ACC_DELETE = True, False, True), True))
                    btnDelVATCodeT.Disabled = Convert.ToBoolean(IIf(btnDelVATCodeT.Disabled = False, IIf(objuserper.PF_ACC_DELETE = True, False, True), True))
                    btnDelVATCodeB.Disabled = Convert.ToBoolean(IIf(btnDelVATCodeB.Disabled = False, IIf(objuserper.PF_ACC_DELETE = True, False, True), True))
                    
                End If
            End If
        End If
    End Sub
    <WebMethod()> _
    Public Shared Function GetCustomer(ByVal custName As String) As List(Of String)

        Dim retCustomer As New List(Of String)()
        Try
            retCustomer = objServCustomer.GetCustomer(custName)

        Catch exth As System.Threading.ThreadAbortException
            Throw exth
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfWorkOrder", "GetCustomer", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return retCustomer
    End Function


End Class