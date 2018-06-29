Imports System.Web.Services
Imports CARS.CoreLibrary
Imports CARS.CoreLibrary.CARS
Imports System.Web.Security
Imports System.Web.UI
Imports Encryption
Imports System.Math
Imports Newtonsoft.Json
Public Class frmInvEmailConfig
    Inherits System.Web.UI.Page
    Shared objInvEmailTemplateBO As New ConfigEmailTemplateBO
    Shared objInvEmailTemplateDO As New ConfigEmailTemplate.ConfigEmailTemplateDO
    Shared objInvEmailTemplateServ As New Services.ConfigEmailTemplate.ConfigEmailTemplate
    Shared commonUtil As New Utilities.CommonUtility
    Shared loginName As String
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared details As New List(Of ConfigEmailTemplateBO)()
    Dim objuserper As New UserAccessPermissionsBO
    Shared dtCaption As DataTable
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            If Session("UserID") Is Nothing Or Session("UserPageperDT") Is Nothing Then
                Response.Redirect("~/frmLogin.aspx")
            Else
                loginName = CType(Session("UserID"), String)
            End If
            dtCaption = DirectCast(Cache("Caption"), System.Data.DataTable)
            hdnPageSize.Value = System.Configuration.ConfigurationManager.AppSettings("PageSize")

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmInvEmailConfig", "Page_Load", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub
    <WebMethod()> _
    Public Shared Function LoadInvEmailTemplate() As ConfigEmailTemplateBO()
        Try
            details = objInvEmailTemplateServ.LoadInvEmailTemplate()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmInvEmailConfig", "LoadInvEmailTemplate", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray
    End Function
    <WebMethod()> _
    Public Shared Function GetInvEmailTemplateConfig(ByVal idTemplate As String) As Collection
        Dim details As New Collection
        Try
            details = objInvEmailTemplateServ.GetInvEmailTemplateConfig(idTemplate)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmInvEmailConfig", "GetInvEmailTemplateConfig", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details
    End Function
    <WebMethod()> _
    Public Shared Function SaveInvEmailTemplate(ByVal idTemplate As String, ByVal templateCode As String, ByVal subject As String, ByVal message As String, ByVal isDefault As String, ByVal mode As String) As String()
        Dim strRes As String()
        Try
            Dim objInvEmailTemplateBO As New ConfigEmailTemplateBO
            objInvEmailTemplateBO.Id_Template = idTemplate
            objInvEmailTemplateBO.Template_Code = templateCode
            objInvEmailTemplateBO.Subject = subject
            objInvEmailTemplateBO.Message = message
            objInvEmailTemplateBO.Flg_Default = isDefault
            If (mode = "Add") Then
                strRes = objInvEmailTemplateServ.AddInvEmailTemplate(objInvEmailTemplateBO)
            Else
                strRes = objInvEmailTemplateServ.UpdateInvEmailTemplate(objInvEmailTemplateBO)
            End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmInvEmailConfig", "SaveInvEmailTemplate", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strRes
    End Function

    <WebMethod()> _
    Public Shared Function DeleteInvEmailTemplate(ByVal emailTempIdxmls As String) As String()
        Dim strRes As String()
        Try
            strRes = objInvEmailTemplateServ.DeleteInvEmailTemplate(emailTempIdxmls)

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmInvEmailConfig", "DeleteInvEmailTemplate", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strRes
    End Function
    <WebMethod()> _
    Public Shared Function LoadInvEmailSchedule() As ConfigEmailTemplateBO()
        Try
            details = objInvEmailTemplateServ.LoadInvEmailSchedule()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmInvEmailConfig", "LoadInvEmailSchedule", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray
    End Function
    <WebMethod()> _
    Public Shared Function SaveInvEmailSchedule(ByVal startTime As String, ByVal wkMon As String, ByVal wkTue As String, ByVal wkWed As String, ByVal wkThur As String, ByVal wkFri As String, ByVal wkSat As String, ByVal wkSun As String) As String()
        Dim strRes As String()
        Try
            Dim objInvEmailTemplateBO As New ConfigEmailTemplateBO
            objInvEmailTemplateBO.Start_Time = startTime
            objInvEmailTemplateBO.Use_Mon = wkMon
            objInvEmailTemplateBO.Use_Tue = wkTue
            objInvEmailTemplateBO.Use_Wed = wkWed
            objInvEmailTemplateBO.Use_Thur = wkThur
            objInvEmailTemplateBO.Use_Fri = wkFri
            objInvEmailTemplateBO.Use_Sat = wkSat
            objInvEmailTemplateBO.Use_Sun = wkSun

            strRes = objInvEmailTemplateServ.SaveInvEmailSchedule(objInvEmailTemplateBO)

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmInvEmailConfig", "SaveInvEmailSchedule", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strRes
    End Function


End Class