Imports System.Data
Imports Encryption
Imports MSGCOMMON
Imports System.Web.Services
Imports CARS.CoreLibrary.CARS
Imports CARS.CoreLibrary
Imports System.Web.UI
Imports System.Xml
Public Class frmWOVehInfo
    Inherits System.Web.UI.Page
    Dim screenName As String
    Shared loginName As String
    Shared objWOHeaderBO As New CARS.CoreLibrary.WOHeaderBO
    Shared objWOHeaderServ As New CARS.CoreLibrary.CARS.Services.WOHeader.WOHeader
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared details As New List(Of WOHeaderBO)()
    Shared vehDetails As New List(Of VehicleBO)()
    Shared dtCaption As DataTable
    Shared objVehicleService As New CARS.CoreLibrary.CARS.Services.Vehicle.VehicleDetails
    Shared objVehBo As New CARS.CoreLibrary.VehicleBO
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Session.Item("id") = Nothing
        Session("Mode") = Nothing
        If Session("UserID") Is Nothing Or Session("UserPageperDT") Is Nothing Then
            Response.Redirect("~/frmLogin.aspx")
        Else
            loginName = CType(Session("UserID"), String)

        End If
        screenName = IO.Path.GetFileName(Me.Request.PhysicalPath)
        If Not IsPostBack Then
            dtCaption = DirectCast(Cache("Caption"), System.Data.DataTable)
            hdnSelect.Value = dtCaption.Select("TAG='select'")(0)(1)
        End If
    End Sub
    <WebMethod()> _
    Public Shared Function LoadVehDetails(ByVal VehicleId As String) As WOHeaderBO()
        Try
            objWOHeaderBO.Id_Veh_Seq_WO = VehicleId
            details = objWOHeaderServ.Fetch_WOH_Vehicle(objWOHeaderBO.Id_Veh_Seq_WO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWOVehInfo", "LoadVehDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function LoadVehGroup() As VehicleBO()
        Try
            vehDetails = objVehicleService.Fetch_VehConfig()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWOVehInfo", "LoadVehGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return vehDetails.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function LoadVehModel(ByVal IdMake As String) As VehicleBO()
        Try
            objVehBo.Id_Make_Veh = IdMake
            vehDetails = objVehicleService.Fetch_Model(objVehBo)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWOVehInfo", "LoadVehModel", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return vehDetails.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function LoadVehRPModel(ByVal IdMake As String) As VehicleBO()
        Try
            objVehBo.Id_Make_Veh = IdMake
            vehDetails = objVehicleService.Fetch_RPModel()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWOVehInfo", "LoadVehModel", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return vehDetails.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function UpdateVehInfo(ByVal vehId As String, ByVal vehModel As String, ByVal vehRPModel As String, ByVal vehGrp As String, ByVal idCustomer As String, ByVal vehOwner As String, ByVal vehDriver As String, ByVal vehDrvPhone As String, ByVal vehDrvMobile As String, ByVal vehDrvEmail As String, ByVal dtVehRegn As String, ByVal dtLastReg As String, ByVal vehHrs As String _
     , ByVal dtLastHours As String, ByVal vehMil As String, ByVal dtLastMileage As String, ByVal srvType As String, ByVal vehAnnot As String) As String()
        Dim strResult As String()
        Dim dsWOHDetails As DataSet
        Try
            dsWOHDetails = HttpContext.Current.Session("MoreVehInfo")
            objWOHeaderBO.Id_Veh_Seq_WO = vehId
            objWOHeaderBO.WO_Veh_Reg_NO = dsWOHDetails.Tables(0).Rows(0)("VEH_REG_NO").ToString
            objWOHeaderBO.WO_Veh_ERN_NO = dsWOHDetails.Tables(0).Rows(0)("VEH_INTERN_NO").ToString
            objWOHeaderBO.WO_Veh_Vin = dsWOHDetails.Tables(0).Rows(0)("VEH_VIN").ToString
            objWOHeaderBO.Id_Make = dsWOHDetails.Tables(0).Rows(0)("ID_MAKE_VEH").ToString
            objWOHeaderBO.Id_Model = dsWOHDetails.Tables(0).Rows(0)("ID_MODEL_VEH").ToString
            objWOHeaderBO.Veh_Grpdesc = vehGrp
            objWOHeaderBO.Dt_Veh_Last_Regn = dtLastReg
            objWOHeaderBO.Veh_Type = dsWOHDetails.Tables(0).Rows(0)("VEH_TYPE").ToString
            objWOHeaderBO.Dt_Veh_Regn = dtVehRegn
            objWOHeaderBO.WO_Veh_Mileage = vehMil
            objWOHeaderBO.Dt_Veh_Mil_Regn = dtLastMileage
            objWOHeaderBO.WO_Veh_Hrs = vehHrs
            objWOHeaderBO.Dt_Veh_Hrs_Regn = dtLastHours
            objWOHeaderBO.Id_Model_RP = IIf((vehRPModel = "0"), "", vehRPModel)
            objWOHeaderBO.Veh_Mdl_Year = dsWOHDetails.Tables(0).Rows(0)("VEH_MDL_YEAR").ToString
            objWOHeaderBO.Id_Cust_Wo = dsWOHDetails.Tables(0).Rows(0)("ID_CUSTOMER").ToString
            objWOHeaderBO.Veh_Driver = vehDriver
            objWOHeaderBO.Veh_Mobile = vehDrvMobile
            objWOHeaderBO.Veh_Phone1 = vehDrvPhone
            objWOHeaderBO.Veh_Drv_Emailid = vehDrvEmail
            objWOHeaderBO.Veh_Flg_Service_Plan = dsWOHDetails.Tables(0).Rows(0)("VEH_FLG_SERVICE_PLAN").ToString
            objWOHeaderBO.Veh_Flg_AddOn = dsWOHDetails.Tables(0).Rows(0)("VEH_FLG_ADDON").ToString
            objWOHeaderBO.Veh_Srv_Type = srvType
            objWOHeaderBO.Id_AddOn_LocDept = dsWOHDetails.Tables(0).Rows(0)("ID_ADDON_LOCDEPT").ToString
            objWOHeaderBO.Id_Vat_Code = dsWOHDetails.Tables(0).Rows(0)("ID_VAT_CD").ToString
            objWOHeaderBO.Veh_Annot = dsWOHDetails.Tables(0).Rows(0)("VEH_ANNOT").ToString
            objWOHeaderBO.Created_By = dsWOHDetails.Tables(0).Rows(0)("CERATED_BY").ToString
            objWOHeaderBO.Modified_By = loginName
            objWOHeaderBO.Dt_Created = dsWOHDetails.Tables(0).Rows(0)("DT_CREATED").ToString

            strResult = objWOHeaderServ.Update_Vehicledetails(objWOHeaderBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWoHead", "UpdateCustInfo", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
End Class