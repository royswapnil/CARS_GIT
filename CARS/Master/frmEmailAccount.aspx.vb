Imports System.Web.Services
Imports CARS.CoreLibrary
Imports CARS.CoreLibrary.CARS
Imports System.Web.Security
Imports System.Web.UI
Imports Encryption
Imports System.Math
Imports Newtonsoft.Json
Public Class frmEmailAccount
    Inherits System.Web.UI.Page
    Shared objConfigEmailAccountBO As New ConfigEmailAccountBO
    Shared objConfigEmailAccountDO As New ConfigEmailAccount.ConfigEmailAccountDO
    Shared objConfigEmailAccountServ As New Services.ConfigEmailAccount.ConfigEmailAccount
    Shared commonUtil As New Utilities.CommonUtility
    Shared loginName As String
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared details As New List(Of ConfigEmailAccountBO)()
    Dim objuserper As New UserAccessPermissionsBO
    Shared dtCaption As DataTable
    Shared objEncryption As New Encryption64
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
            objErrHandle.WriteErrorLog(1, "Master_frmEmailAccount", "Page_Load", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub
    <WebMethod()> _
    Public Shared Function LoadEmailAccountConfig() As ConfigEmailAccountBO()
        Try
            details = objConfigEmailAccountServ.LoadEmailAccount()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmEmailAccount", "LoadEmailAccountConfig", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray
    End Function

    <WebMethod()> _
    Public Shared Function GetEmailAccountConfig(ByVal idEmailAcct As String) As Collection
        Dim details As New Collection
        Try
            details = objConfigEmailAccountServ.GetEmailAcctConfig(idEmailAcct)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmEmailAccount", "GetEmailAccountConfig", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details
    End Function

    <WebMethod()> _
    Public Shared Function LoadSubsidiary() As ConfigDepartmentBO()
        Dim subdetails As New List(Of ConfigDepartmentBO)()
        Dim subBO As New ConfigDepartmentBO
        subBO.LoginId = HttpContext.Current.Session("UserID")
        Try
            subdetails = commonUtil.LoadSubsidiaries(subBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmEmailAccount", "LoadSubsidiary", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return subdetails.ToList.ToArray
    End Function

    <WebMethod()> _
    Public Shared Function SaveConfigEmailAccount(ByVal idEmailAccnt As String, ByVal idSubsidiary As String, ByVal settingName As String, ByVal email As String, ByVal smtp As String, ByVal port As String, ByVal cryptation As String, ByVal username As String, ByVal password As String) As String()
        Dim strRes As String()
        Try
            objConfigEmailAccountBO.Id_Email_Accnt = idEmailAccnt
            objConfigEmailAccountBO.Id_Subsidiary = idSubsidiary
            objConfigEmailAccountBO.Setting_Name = settingName
            objConfigEmailAccountBO.Email = email
            objConfigEmailAccountBO.Smtp = smtp
            objConfigEmailAccountBO.Port = port
            objConfigEmailAccountBO.Cryptation = cryptation
            objConfigEmailAccountBO.Username = username
            password = objEncryption.Encrypt(password, ConfigurationManager.AppSettings.Get("encKey"))
            objConfigEmailAccountBO.Password = password

            strRes = objConfigEmailAccountServ.SaveEmailAcct(objConfigEmailAccountBO)
            
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "DeleteEmailAccount", "SaveConfigEmailAccount", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strRes
    End Function

    <WebMethod()> _
    Public Shared Function DeleteEmailAccount(ByVal emailAccountIdxmls As String) As String()
        Dim strRes As String()
        Try
            strRes = objConfigEmailAccountServ.DeleteEmailAcct(emailAccountIdxmls)

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "DeleteEmailAccount", "DeleteEmailAccount", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strRes
    End Function
End Class