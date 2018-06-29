Imports System.Web.Services
Imports CARS.CoreLibrary
Imports CARS.CoreLibrary.CARS
Imports System.Web.Security
Imports System.Web.UI
Imports Encryption
Public Class frmCfHourlyPrice
    Inherits System.Web.UI.Page
    Shared objConfigBO As New ConfigSettingsBO
    Shared objConfigDO As New ConfigSettings.ConfigSettingsDO
    Shared objConfigHPServ As New Services.ConfigHourlyPrice.ConfigHourlyPrice
    Shared commonUtil As New Utilities.CommonUtility
    Shared loginName As String
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared details As New List(Of ConfigSettingsBO)()
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

            'SetPermission()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfHourlyPrice", "Page_Load", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub
    <WebMethod()> _
    Public Shared Function LoadAllHPConfig() As Collection
        Dim configDetails As New Collection
        Try
            configDetails = objConfigHPServ.FetchAllHPConfig()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfRepairPackage", "LoadAllHPConfig", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return configDetails
    End Function
    <WebMethod()> _
    Public Shared Function SaveHPConfig(ByVal idconfig As String, ByVal idsettings As String, ByVal desc As String, ByVal mode As String) As ConfigSettingsBO()
        Try
            Dim strXMLDocMas As String = ""
            If (mode = "Add") Then
                strXMLDocMas = ""
                strXMLDocMas = "<insert ID_CONFIG=""" + idconfig + """ DESCRIPTION=""" + desc.Trim.Replace("<", "&lt;").Replace(">", "&gt;") + """/>"
                strXMLDocMas = "<root>" + strXMLDocMas + "</root>"
                details = commonUtil.AddConfigDetails(strXMLDocMas)
            Else
                strXMLDocMas = ""
                strXMLDocMas = "<MODIFY ID_CONFIG=""" + idconfig + """ ID_SETTINGS=""" + idsettings + """ DESCRIPTION=""" + desc.Trim.Replace("<", "&lt;").Replace(">", "&gt;") + """/>"
                strXMLDocMas = "<ROOT>" + strXMLDocMas + "</ROOT>"
                details = commonUtil.UpdateConfigDetails(strXMLDocMas)
            End If


        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfRepairPackage", "UpdateConfigDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function

    <WebMethod()> _
    Public Shared Function DeleteHPConfig(ByVal delxml As String) As String()
        Dim strResult As String()
        Try
            strResult = objConfigHPServ.DeleteConfig(delxml)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfRepairPackage", "DeletePrCodeCust", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
End Class