Imports System.Data
Imports Encryption
Imports MSGCOMMON
Imports System.Web.Services
Imports CARS.CoreLibrary.CARS
Imports CARS.CoreLibrary
Imports System.Web.UI
Imports CARS.CoreLibrary.CARS.Services
Imports System.Reflection
Imports Newtonsoft.Json
Public Class Config_UnitofMeasurementContent
    Inherits System.Web.UI.Page
    Shared objUOMService As New CARS.CoreLibrary.CARS.Services.ConfigUOM.ConfigUnitOfMeasurement
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared commonUtil As New Utilities.CommonUtility
    Shared loginName As String
    Shared dtCaption As DataTable
    Shared objUOMBO As New ConfigUnitOfMeasurementBO
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
            objErrHandle.WriteErrorLog(1, "Config_UnitofMeasurementContent", "Page_Load", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub
    <WebMethod()> _
    Public Shared Function LoadUOMConfig() As ConfigUnitOfMeasurementBO()
        Dim uomDetails As New List(Of ConfigUnitOfMeasurementBO)()
        Try
            uomDetails = objUOMService.LoadUOM()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Config_UnitofMeasurementContent", "LoadUOM", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
        End Try
        Return uomDetails.ToList.ToArray
    End Function
    <WebMethod()> _
    Public Shared Function SaveUOMConfig(ByVal uom As String, ByVal desc As String, ByVal mode As String) As String()
        Dim strRes As String()
        Try
            objUOMBO.Unit_Desc = uom
            objUOMBO.Description = desc
            objUOMBO.CreatedBy = loginName

            If (mode = "Edit") Then
                strRes = objUOMService.UpdUOMDetails(objUOMBO)
            ElseIf mode = "Add" Then
                strRes = objUOMService.AddUOMDetails(objUOMBO)
            End If

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Config_UnitofMeasurementContent", "SaveUOMDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strRes
    End Function
    <WebMethod()> _
    Public Shared Function DeleteUOMDetails(ByVal idUOM As String) As String()
        Dim strRes As String()
        Try
            strRes = objUOMService.DeleteUOMDetails(idUOM)

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Config_UnitofMeasurementContent", "DeleteUOMDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strRes
    End Function
End Class