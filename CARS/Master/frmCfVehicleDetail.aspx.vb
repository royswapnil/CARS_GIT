Imports System.Web.Services
Imports CARS.CoreLibrary
Imports CARS.CoreLibrary.CARS
Imports System.Web.Security
Imports System.Web.UI
Imports Encryption
Imports System.Math
Imports Newtonsoft.Json
Imports System.Reflection
Public Class frmCfVehicleDetail
    Inherits System.Web.UI.Page
    Shared commonUtil As New Utilities.CommonUtility
    Shared loginName As String
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared dtCaption As DataTable
    Shared objCVehSrv As New Services.ConfigVehicle.ConfigVehicle
    Shared details As New List(Of ConfigVehicleBO)()
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
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
        End If
        strscreenName = IO.Path.GetFileName(Me.Request.PhysicalPath)
        'commonUtil.ddlGetValue(strscreenName, cboPrint)
        'fnRolebasedAuth()
    End Sub
    <WebMethod()> _
    Public Shared Function Fetch_Config() As Collection
        Dim dtConfig As New Collection
        Try
            dtConfig = objCVehSrv.Fetch_ConfigDetails()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfVehicleDetail", "Fetch_Config", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return dtConfig
    End Function
    <WebMethod()> _
    Public Shared Function LoadDiscCode() As ConfigVehicleBO()
        Try
            details = objCVehSrv.Load_DisListData()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfVehicleDetail", "LoadDiscCode", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function LoadVatCode() As ConfigVehicleBO()
        Dim IdLogin As String
        Try
            IdLogin = loginName
            details = objCVehSrv.Load_VatCode(IdLogin)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfVehicleDetail", "LoadVatCode", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function MakeConfigDetails(ByVal idMake As String, ByVal idMakeName As String, ByVal makeDiscCode As String, ByVal makeVatCode As String, ByVal idMakePCode As String, ByVal mode As String) As ConfigVehicleBO()
        Try
            Dim strXMLSettingsVehMake As String = ""
            Dim strXMLSettingsModel As String = ""
            Dim IdLogin As String = loginName
            If makeDiscCode = "0" Then
                makeDiscCode = ""
            End If
            If idMakePCode = "0" Then
                idMakePCode = ""
            End If
            If mode = "Edit" Then
                strXMLSettingsVehMake = "<MODIFY ID_MAKE=""" + idMake + """ ID_MAKE_NAME=""" + idMakeName + """ ID_MAKE_PRICECODE= """ + idMakePCode + """ MAKEDISCODE=""" + makeDiscCode + """ MAKE_VATCODE=""" + makeVatCode + """/>"
                strXMLSettingsVehMake = "<ROOT>" + strXMLSettingsVehMake + "</ROOT>"
                strXMLSettingsModel = "<ROOT></ROOT>"
                details = objCVehSrv.UpdateVehMakeModelConfig(strXMLSettingsVehMake, strXMLSettingsModel, IdLogin)
            Else
                strXMLSettingsVehMake = "<insert ID_MAKE=""" + idMake + """ ID_MAKE_NAME=""" + idMakeName + """ ID_MAKE_PRICECODE= """ + idMakePCode + """ MAKEDISCODE=""" + makeDiscCode + """ MAKE_VATCODE=""" + makeVatCode + """/>"
                strXMLSettingsVehMake = "<root>" + strXMLSettingsVehMake + "</root>"
                strXMLSettingsModel = "<ROOT></ROOT>"
                details = objCVehSrv.SaveVehMakeConfig(strXMLSettingsVehMake, IdLogin)
            End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfVehicleDetail", "MakeConfigDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function ModelConfigDetails(ByVal IdModel As String, ByVal ModelDesc As String, ByVal mode As String) As ConfigVehicleBO()
        Try
            Dim strXMLSettingsVehMake As String = ""
            Dim strXMLSettingsModel As String = ""
            Dim IdLogin As String = loginName
            If mode = "Edit" Then
                strXMLSettingsModel = "<MODIFY ID_MODELGRP=""" + IdModel + """ ID_MODELGRP_NAME=""" + ModelDesc + """  />"
                strXMLSettingsModel = "<ROOT>" + strXMLSettingsModel + "</ROOT>"
                strXMLSettingsVehMake = "<ROOT></ROOT>"
                details = objCVehSrv.UpdateVehMakeModelConfig(strXMLSettingsVehMake, strXMLSettingsModel, IdLogin)
            Else
                strXMLSettingsModel = "<insert ID_MODELGRP=""" + IdModel + """ ID_MODELGRP_NAME=""" + ModelDesc + """  />"
                strXMLSettingsModel = "<root>" + strXMLSettingsModel + "</root>"
                strXMLSettingsVehMake = "<ROOT></ROOT>"
                details = objCVehSrv.SaveVehModelConfig(strXMLSettingsModel, IdLogin)
            End If

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfVehicleDetail", "ModelConfigDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function VehGrpConfigDet(ByVal IdSettings As String, ByVal Desc As String, ByVal Remarks As String, ByVal VGPCode As String, ByVal IntervalCode As String, ByVal mode As String) As ConfigVehicleBO()
        Try
            Dim strXMLVEHGRPUpdate As String = ""
            If VGPCode = "0" Then
                VGPCode = ""
            End If
            Dim IdLogin As String = loginName
            If mode = "Edit" Then
                strXMLVEHGRPUpdate = "<MODIFY ID_CONFIG=""VEH-GROUP "" ID_SETTINGS=""" + IdSettings + """ DESCRIPTION= """ + Desc + """ REMARKS=""" + Remarks + """ VH_GROUP_PRICECODE=""" + VGPCode + """ InterValCode=""" + IntervalCode + """/>"
                strXMLVEHGRPUpdate = "<ROOT>" + strXMLVEHGRPUpdate + "</ROOT>"
                details = objCVehSrv.UpdateVehGroup(strXMLVEHGRPUpdate, IdLogin)
            Else
                strXMLVEHGRPUpdate += "<insert ID_CONFIG=""VEH-GROUP"" DESCRIPTION=""" _
                                        + Desc + """ REMARKS=""" + Remarks + """ VH_GROUP_PRICECODE=""" + VGPCode + """ InterValCode=""" + IntervalCode + """ />"

                strXMLVEHGRPUpdate = "<root>" + strXMLVEHGRPUpdate + "</root>"
                details = objCVehSrv.saveVehGroup(strXMLVEHGRPUpdate, IdLogin)
            End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfVehicleDetail", "UpdateConfigDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function LocationConfigDet(ByVal Desc As String, ByVal IdSettings As String, ByVal mode As String) As ConfigVehicleBO()
        Try
            Dim strXMLSettingsUpdate As String = ""
            Dim IdLogin As String = loginName
            If mode = "Edit" Then
                strXMLSettingsUpdate = "<MODIFY ID_CONFIG=""LOC"" ID_SETTINGS=""" + IdSettings + """ DESCRIPTION=""" + Desc + """/>"
                strXMLSettingsUpdate = "<ROOT>" + strXMLSettingsUpdate + "</ROOT>"
                details = objCVehSrv.updLoc(strXMLSettingsUpdate, IdLogin)
            Else
                strXMLSettingsUpdate += "<insert ID_CONFIG=""LOC"" DESCRIPTION=""" + Desc + """  />"
                strXMLSettingsUpdate = "<root>" + strXMLSettingsUpdate + "</root>"
                details = objCVehSrv.saveLoc(strXMLSettingsUpdate, IdLogin)
            End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfVehicleDetail", "LocationConfigDet", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function DeleteMakeConfig(ByVal makeIdxml As String) As String()
        Dim strResult As String()
        Try
            strResult = objCVehSrv.DeleteConfigMake(makeIdxml)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfVehicleDetail", "DeleteMakeConfig", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
    <WebMethod()> _
    Public Shared Function DeleteModelConfig(ByVal modelIdxml As String) As String()
        Dim strResult As String()
        Try
            strResult = objCVehSrv.DeleteConfigModel(modelIdxml)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfVehicleDetail", "DeleteModelConfig", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
    <WebMethod()> _
    Public Shared Function DeleteVehGroup(ByVal vehIdxml As String) As String()
        Dim strResult As String()
        Try
            strResult = objCVehSrv.DeleteVehGroup(vehIdxml)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfVehicleDetail", "DeleteVehGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
    <WebMethod()> _
    Public Shared Function DeleteLoc(ByVal locIdxml As String) As String()
        Dim strResult As String()
        Try
            strResult = objCVehSrv.DelLocation(locIdxml)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfVehicleDetail", "DeleteLoc", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
End Class