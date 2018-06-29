Imports System.Web.Services
Imports CARS.CoreLibrary
Imports CARS.CoreLibrary.CARS
Imports System.Web.Security
Imports System.Web.UI
Imports Encryption
Imports System.Math
Imports Newtonsoft.Json

Public Class frmEmailTemplateConfig
    Inherits System.Web.UI.Page

    Shared objConfigEmailTemplateBO As New ConfigEmailTemplateBO
    Shared objConfigEmailTemplateDO As New ConfigEmailTemplate.ConfigEmailTemplateDO
    Shared objConfigEmailTemplateServ As New Services.ConfigEmailTemplate.ConfigEmailTemplate
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
            hdnSelect.Value = dtCaption.Select("TAG='select'")(0)(1)
            hdnPageSize.Value = System.Configuration.ConfigurationManager.AppSettings("PageSize")

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmEmailTemplateConfig", "Page_Load", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub

    <WebMethod()> _
    Public Shared Function LoadConfigEmailTemplate() As ConfigEmailTemplateBO()
        Try
            details = objConfigEmailTemplateServ.LoadEmailTemplate()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmEmailTemplateConfig", "LoadEmailTemplate", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray
    End Function
    <WebMethod()> _
    Public Shared Function GetEmailTemplateConfig(ByVal idTemplate As String) As Collection
        Dim details As New Collection
        Try
            details = objConfigEmailTemplateServ.GetEmailTemplateConfig(idTemplate)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmEmailTemplateConfig", "GetEmailTemplateConfig", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details
    End Function
    <WebMethod()> _
    Public Shared Function SaveConfigEmailTemplate(ByVal idTemplate As String, ByVal templateCode As String, ByVal subject As String, ByVal message As String, ByVal mode As String) As String()
        Dim strRes As String()
        Try
            Dim objConfigEmailTemplateBO As New ConfigEmailTemplateBO
            objConfigEmailTemplateBO.Id_Template = idTemplate
            objConfigEmailTemplateBO.Template_Code = templateCode
            objConfigEmailTemplateBO.Subject = subject
            objConfigEmailTemplateBO.Message = message
            If (mode = "Add") Then
                strRes = objConfigEmailTemplateServ.AddEmailTemplate(objConfigEmailTemplateBO)
            Else
                strRes = objConfigEmailTemplateServ.UpdateEmailTemplate(objConfigEmailTemplateBO)
            End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmEmailTemplateConfig", "SaveConfigEmailTemplate", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strRes
    End Function
    <WebMethod()> _
    Public Shared Function DeleteEmailTemplate(ByVal emailTempIdxmls As String) As String()
        Dim strRes As String()
        Try
            strRes = objConfigEmailTemplateServ.DeleteEmailTemplate(emailTempIdxmls)

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmEmailTemplateConfig", "DeleteEmailTemplate", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strRes
    End Function




End Class