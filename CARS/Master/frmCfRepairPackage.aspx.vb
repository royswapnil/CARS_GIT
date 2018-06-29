Imports System.Web.Services
Imports CARS.CoreLibrary
Imports CARS.CoreLibrary.CARS
Imports System.Web.Security
Imports System.Web.UI
Imports Encryption
Public Class frmCfRepairPackage
    Inherits System.Web.UI.Page
    Shared objRPCodeBO As New RepPackCodeBO
    Shared objRPCodeDO As New RepPackCode.RepPackCodeDO
    Shared objRPCodeServ As New Services.RepPackCode.RepPackCode
    Shared commonUtil As New Utilities.CommonUtility
    Shared loginName As String
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared details As New List(Of RepPackCodeBO)()
    Dim objuserper As New UserAccessPermissionsBO
    Shared dtCaption As DataTable
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            If Session("UserID") Is Nothing Or Session("UserPageperDT") Is Nothing Then
                Response.Redirect("~/frmLogin.aspx")
            Else
                LoginName = CType(Session("UserID"), String)
            End If
            dtCaption = DirectCast(Cache("Caption"), System.Data.DataTable)
            hdnSelect.Value = dtCaption.Select("TAG='select'")(0)(1)

            hdnPageSize.Value = System.Configuration.ConfigurationManager.AppSettings("PageSize")

            SetPermission()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfRepairPackage", "Page_Load", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub
    <WebMethod()> _
    Public Shared Function LoadRepPkgConfig() As Collection
        Dim configDetails As New Collection
        Try
            configDetails = objRPCodeServ.FetchAllRepPkgConfig()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfRepairPackage", "LoadRepPkgConfig", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return configDetails
    End Function
    <WebMethod()> _
    Public Shared Function SaveRepPkgCatg(ByVal idconfig As String, ByVal idsettings As String, ByVal desc As String, ByVal mode As String) As RepPackCodeBO()
        Try
            Dim strXMLDocMas As String = ""
            Dim strXMLDocRpCode As String = ""
            Dim strXMLDocChkLst As String = ""
            Dim strXMLDocSprCode As String = ""
            If (mode = "Add") Then
                strXMLDocMas = ""
                strXMLDocMas = "<insert ID_CONFIG=""" + idconfig + """ DESCRIPTION=""" + desc.Trim.Replace("<", "&lt;").Replace(">", "&gt;") + """/>"
                strXMLDocMas = "<root>" + strXMLDocMas + "</root>"
                details = objRPCodeServ.AddConfigDetails(strXMLDocMas)
            Else
                strXMLDocMas = ""
                strXMLDocMas = "<MODIFY ID_CONFIG=""" + idconfig + """ ID_SETTINGS=""" + idsettings + """ wcIsdefault= """ + "0" + """ DESCRIPTION=""" + desc.Trim.Replace("<", "&lt;").Replace(">", "&gt;") + """/>"
                strXMLDocMas = "<ROOT>" + strXMLDocMas + "</ROOT>"
                strXMLDocRpCode = "<ROOT></ROOT>"
                strXMLDocChkLst = "<ROOT></ROOT>"
                strXMLDocSprCode = "<ROOT></ROOT>"
                details = objRPCodeServ.UpdateConfigDetails(strXMLDocMas, strXMLDocRpCode, strXMLDocChkLst, strXMLDocSprCode)
            End If


        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfRepairPackage", "UpdateConfigDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function DeleteRepPkgCatg(ByVal repPkgxml As String) As String()
        Dim strResult As String()
        Try
            strResult = objRPCodeServ.DeleteRepPkgCatg(repPkgxml)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfRepairPackage", "DeleteRepPkgCatg", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
    <WebMethod()> _
    Public Shared Function SaveRepCode(ByVal idconfig As String, ByVal idRepCode As String, ByVal desc As String, ByVal mode As String, ByVal isDefault As String) As RepPackCodeBO()
        Try
            Dim strXMLDocMas As String = ""
            Dim strXMLDocRpCode As String = ""
            Dim strXMLDocChkLst As String = ""
            Dim strXMLDocSrpCode As String = ""
            If (mode = "Add") Then
                strXMLDocMas = ""
                strXMLDocMas = "<insert ID_CONFIG=""" + idconfig + """ RP_REPCODE_DES=""" + desc.Trim.Replace("<", "&lt;").Replace(">", "&gt;") + """ isDefault= """ + isDefault + """/>"
                strXMLDocMas = "<root>" + strXMLDocMas + "</root>"
                details = objRPCodeServ.AddRepCode(strXMLDocMas)
            Else
                strXMLDocMas = "<ROOT></ROOT>"
                strXMLDocRpCode = "<MODIFYRPCODE  ID_REP_CODE=""" + idRepCode + """ RP_REPCODE_DES=""" + desc + """ isDefault= """ + isDefault + """/>"
                strXMLDocRpCode = "<ROOT>" + strXMLDocRpCode + "</ROOT>"
                strXMLDocChkLst = "<ROOT></ROOT>"
                strXMLDocSrpCode = "<ROOT></ROOT>"
                details = objRPCodeServ.UpdateConfigDetails(strXMLDocMas, strXMLDocRpCode, strXMLDocChkLst, strXMLDocSrpCode)
            End If


        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfRepairPackage", "UpdateConfigDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function DeleteRepCode(ByVal repCodexml As String) As String()
        Dim strResult As String()
        Try
            strResult = objRPCodeServ.DeleteRepCode(repCodexml)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfRepairPackage", "DeleteRepCode", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function

    <WebMethod()> _
    Public Shared Function SaveSubRepCode(ByVal idSubRepCode As String, ByVal idRepCode As String, ByVal subRepCodeDesc As String, ByVal mode As String) As RepPackCodeBO()
        Try
            Dim strXMLDocMas As String = ""
            Dim strXMLDocRpCode As String = ""
            Dim strXMLDocChkLst As String = ""
            Dim strXMLDocSrpCode As String = ""
            If (mode = "Add") Then
                strXMLDocMas = ""
                strXMLDocMas = "<INSERTSRC RP_SUBREPCODE_DES=""" + subRepCodeDesc + """ ID_REP_CODE=""" + idRepCode.Trim.Replace("<", "&lt;").Replace(">", "&gt;") + """/>"
                strXMLDocMas = "<root>" + strXMLDocMas + "</root>"
                details = objRPCodeServ.AddSubRepCode(strXMLDocMas)
            Else
                strXMLDocMas = "<ROOT></ROOT>"
                strXMLDocRpCode = "<ROOT></ROOT>"
                strXMLDocChkLst = "<ROOT></ROOT>"
                strXMLDocSrpCode = "<MODIFYSRPCODE  ID_SUBREP_CODE=""" + idSubRepCode + """ RP_SUBREPCODE_DES=""" + subRepCodeDesc + """ ID_REP_CODE= """ + idRepCode + """/>"
                strXMLDocSrpCode = "<ROOT>" + strXMLDocSrpCode + "</ROOT>"

                details = objRPCodeServ.UpdateConfigDetails(strXMLDocMas, strXMLDocRpCode, strXMLDocChkLst, strXMLDocSrpCode)
            End If


        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfRepairPackage", "UpdateConfigDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function DeleteSubRepCode(ByVal subRepCodexml As String) As String()
        Dim strResult As String()
        Try
            strResult = objRPCodeServ.DeleteSubRepCode(subRepCodexml)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfRepairPackage", "DeleteSubRepCode", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function

    <WebMethod()> _
    Public Shared Function SaveRepCodePKK(ByVal idRepCode As String) As RepPackCodeBO()
        Try
            details = objRPCodeServ.AddRepCodePkk(idRepCode)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfRepairPackage", "SaveRepCodePKK", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function SaveCheckList(ByVal idConfig As String, ByVal idCLCode As String, ByVal clDesc As String, ByVal mode As String) As RepPackCodeBO()
        Try
            Dim strXMLDocMas As String = ""
            Dim strXMLDocRpCode As String = ""
            Dim strXMLDocChkLst As String = ""
            Dim strXMLDocSrpCode As String = ""
            If (mode = "Add") Then
                strXMLDocMas = ""
                strXMLDocMas = "<insert ID_CONFIG=""" + idConfig + """ ID_CL_CODE=""" + idCLCode + """ RP_CL_DES= """ + clDesc + """/>"
                strXMLDocMas = "<root>" + strXMLDocMas + "</root>"
                details = objRPCodeServ.AddCheckListCode(strXMLDocMas)
            Else
                strXMLDocMas = "<ROOT></ROOT>"
                strXMLDocRpCode = "<ROOT></ROOT>"
                strXMLDocSrpCode = "<ROOT></ROOT>"
                strXMLDocChkLst = "<MODIFYCHKLST  ID_CL_CODE=""" + idCLCode + """ RP_CL_DES=""" + clDesc + """ ID_CL_CODE_OLD= """ + idCLCode + """/>"
                strXMLDocChkLst = "<ROOT>" + strXMLDocChkLst + "</ROOT>"

                details = objRPCodeServ.UpdateConfigDetails(strXMLDocMas, strXMLDocRpCode, strXMLDocChkLst, strXMLDocSrpCode)
            End If


        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfRepairPackage", "SaveCheckList", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function DeleteCheckList(ByVal checkListxml As String) As String()
        Dim strResult As String()
        Try
            strResult = objRPCodeServ.DeleteCheckList(checkListxml)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfRepairPackage", "DeleteCheckList", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
    <WebMethod()> _
    Public Shared Function SaveWorkCode(ByVal idconfig As String, ByVal idWorkCode As String, ByVal workCodeDesc As String, ByVal mode As String, ByVal isDefault As String) As RepPackCodeBO()
        Try
            Dim strXMLDocMas As String = ""
            Dim strXMLDocRpCode As String = ""
            Dim strXMLDocChkLst As String = ""
            Dim strXMLDocSprCode As String = ""
            If (mode = "Add") Then
                strXMLDocMas = ""
                strXMLDocMas = "<insert ID_CONFIG=""" + idconfig + """ DESCRIPTION=""" + workCodeDesc.Trim.Replace("<", "&lt;").Replace(">", "&gt;") + """ wcIsdefault= """ + isDefault + """/>"
                strXMLDocMas = "<root>" + strXMLDocMas + "</root>"
                details = objRPCodeServ.AddConfigDetails(strXMLDocMas)
            Else
                strXMLDocMas = ""
                strXMLDocMas = "<MODIFY ID_CONFIG=""" + idconfig + """ ID_SETTINGS=""" + idWorkCode + """ wcIsdefault= """ + isDefault + """ DESCRIPTION=""" + workCodeDesc.Trim.Replace("<", "&lt;").Replace(">", "&gt;") + """/>"
                strXMLDocMas = "<ROOT>" + strXMLDocMas + "</ROOT>"
                strXMLDocRpCode = "<ROOT></ROOT>"
                strXMLDocChkLst = "<ROOT></ROOT>"
                strXMLDocSprCode = "<ROOT></ROOT>"
                details = objRPCodeServ.UpdateConfigDetails(strXMLDocMas, strXMLDocRpCode, strXMLDocChkLst, strXMLDocSprCode)
            End If


        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfRepairPackage", "SaveWorkCode", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function DeleteWorkCode(ByVal workCodexml As String) As String()
        Dim strResult As String()
        Try
            strResult = objRPCodeServ.DeleteWorkCode(workCodexml)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfRepairPackage", "DeleteWorkCode", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
    Private Sub SetPermission()
        Dim dt As New DataTable
        Dim str As String
        Dim objLoginBo As New LoginBO
        dt = Session("UserPageperDT")
        If Not dt Is Nothing Then
            str = "/master/frmCfRepairPackage.aspx" 'Request.Url.AbsolutePath frmCfRepairPackage
            objuserper = commonUtil.GetUserScrPer(dt, str)
            If Not objuserper Is Nothing Then
                If objuserper.PF_ACC_VIEW = True Then
                    btnAddRPCatgT.Disabled = Convert.ToBoolean(IIf(btnAddRPCatgT.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnAddRPCatgB.Disabled = Convert.ToBoolean(IIf(btnAddRPCatgB.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnDeleteRPCatgT.Disabled = Convert.ToBoolean(IIf(btnDeleteRPCatgT.Disabled = False, IIf(objuserper.PF_ACC_DELETE = True, False, True), True))
                    btnDeleteRPCatgB.Disabled = Convert.ToBoolean(IIf(btnDeleteRPCatgB.Disabled = False, IIf(objuserper.PF_ACC_DELETE = True, False, True), True))
                    btnSaveRPCatg.Disabled = Convert.ToBoolean(IIf(btnSaveRPCatg.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnAddRCT.Disabled = Convert.ToBoolean(IIf(btnAddRCT.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnAddRCB.Disabled = Convert.ToBoolean(IIf(btnAddRCB.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnDelRCT.Disabled = Convert.ToBoolean(IIf(btnDelRCT.Disabled = False, IIf(objuserper.PF_ACC_DELETE = True, False, True), True))
                    btnDelRCB.Disabled = Convert.ToBoolean(IIf(btnDelRCB.Disabled = False, IIf(objuserper.PF_ACC_DELETE = True, False, True), True))
                    btnSaveRC.Disabled = Convert.ToBoolean(IIf(btnSaveRC.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnAddSubRCT.Disabled = Convert.ToBoolean(IIf(btnAddSubRCT.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnAddSubRCB.Disabled = Convert.ToBoolean(IIf(btnAddSubRCB.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnDelSubRCT.Disabled = Convert.ToBoolean(IIf(btnDelSubRCT.Disabled = False, IIf(objuserper.PF_ACC_DELETE = True, False, True), True))
                    btnDelSubRCB.Disabled = Convert.ToBoolean(IIf(btnDelSubRCB.Disabled = False, IIf(objuserper.PF_ACC_DELETE = True, False, True), True))
                    btnSaveSubRepCode.Disabled = Convert.ToBoolean(IIf(btnSaveSubRepCode.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnAddChkListT.Disabled = Convert.ToBoolean(IIf(btnAddChkListT.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnAddChkListB.Disabled = Convert.ToBoolean(IIf(btnAddChkListB.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnDelChkListT.Disabled = Convert.ToBoolean(IIf(btnDelChkListT.Disabled = False, IIf(objuserper.PF_ACC_DELETE = True, False, True), True))
                    btnDelChkListB.Disabled = Convert.ToBoolean(IIf(btnDelChkListB.Disabled = False, IIf(objuserper.PF_ACC_DELETE = True, False, True), True))
                    btnSaveChkList.Disabled = Convert.ToBoolean(IIf(btnSaveChkList.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnAddWorkCodeT.Disabled = Convert.ToBoolean(IIf(btnAddWorkCodeT.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnAddWorkCodeB.Disabled = Convert.ToBoolean(IIf(btnAddWorkCodeB.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnDelWorkCodeT.Disabled = Convert.ToBoolean(IIf(btnDelWorkCodeT.Disabled = False, IIf(objuserper.PF_ACC_DELETE = True, False, True), True))
                    btnDelWorkCodeB.Disabled = Convert.ToBoolean(IIf(btnDelWorkCodeB.Disabled = False, IIf(objuserper.PF_ACC_DELETE = True, False, True), True))
                    btnSaveWorkCode.Disabled = Convert.ToBoolean(IIf(btnSaveWorkCode.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))

                End If

            End If
        End If
    End Sub
End Class