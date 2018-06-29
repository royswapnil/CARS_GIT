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


Public Class LocalSPDetail
    Inherits System.Web.UI.Page
    Shared objVehicleService As New CARS.CoreLibrary.CARS.Services.Vehicle.VehicleDetails
    Shared objCustService As New CARS.CoreLibrary.CARS.Services.Customer.CustomerDetails
    Shared objItemsService As New CARS.CoreLibrary.CARS.Services.Items.ItemsDetail
    Shared objVehBo As New VehicleBO
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared details As New List(Of VehicleBO)()
    Shared commonUtil As New Utilities.CommonUtility
    Shared OErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared _loginName As String
    Shared loginName As String
    Shared objCustomerService As New Customer.CustomerDetails
    Shared objCVehSrv As New Services.ConfigVehicle.ConfigVehicle
    Shared configDetails As New List(Of ConfigVehicleBO)()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Dim strscreenName As String
            Dim dtCaption As DataTable
            _loginName = CType(Session("UserID"), String)

            If Not IsPostBack Then
                dtCaption = DirectCast(Cache("Caption"), System.Data.DataTable)

                strscreenName = IO.Path.GetFileName(Me.Request.PhysicalPath)
                hdnSelect.Value = dtCaption.Select("TAG='select'")(0)(1)

                lblContactResults.Text = ""
                lblContactResults.Visible = False


            End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmVehicleDetail", "Page_Load", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
        End Try
    End Sub


    <WebMethod()>
    Public Shared Function InsertSparePart(ByVal SparePart As String) As String()
        Dim strResult As String()
        Dim dsReturnValStr As String = ""
        Dim spare As ItemsBO = JsonConvert.DeserializeObject(Of ItemsBO)(SparePart)
        Try
            Console.WriteLine(spare.ID_ITEM)
            strResult = objItemsService.Insert_SparePart(spare)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCustomerDetail", "InsertCustomer", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
    <WebMethod()>
    Public Shared Function FetchMVRDetails(ByVal regNo As String) As VehicleBO()
        Try
            details = objVehicleService.GetMVRData(regNo)
        Catch ex As Exception
            'objErrHandle.WriteErrorLog(1, "Master_frmVehicleDetail", "LoadSubsidiary", ex.Message, _loginName)
        End Try
        Return details.ToList.ToArray
    End Function


    <WebMethod()>
    Public Shared Function GetVehGroup(ByVal VehGrp As String) As List(Of String)
        Dim retVehGroup As New List(Of String)()
        Try
            retVehGroup = objVehicleService.GetVehGroup(VehGrp)

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmVehicleDetail", "GetVehicleGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return retVehGroup
    End Function
    <WebMethod()>
    Public Shared Function GetFuelCode(ByVal FuelCode As String) As List(Of String)
        Dim retFuelCode As New List(Of String)()
        Try
            retFuelCode = objVehicleService.GetFuelCode(FuelCode)

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmVehicleDetail", "GetFuelCode", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return retFuelCode
    End Function

    <WebMethod()>
    Public Shared Function GetWareHouse(ByVal WH As String) As List(Of String)
        Dim retWareHouse As New List(Of String)()
        Try
            retWareHouse = objVehicleService.GetWareHouse(WH)

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmVehicleDetail", "GetWareHouse", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return retWareHouse
    End Function

    <WebMethod()>
    Public Shared Function GetZipCodes(ByVal zipCode As String) As List(Of String)
        Dim retZipCodes As New List(Of String)()
        Try
            retZipCodes = commonUtil.getZipCodes(zipCode, loginName)

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmVehicleDetail", "GetZipCodes", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return retZipCodes
    End Function
    <WebMethod()>
    Public Shared Function FetchVehicleDetails(ByVal refNo As String, ByVal regNo As String, ByVal vehId As String) As VehicleBO()
        Dim vehDetails As New List(Of VehicleBO)()
        Try
            If (refNo <> "" Or vehId <> "" Or regNo <> "") Then
                vehDetails = objVehicleService.FetchVehicleDetails(refNo, regNo, vehId)
            End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmVehicleDetail", "FetchVehicleDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
        End Try
        Return vehDetails.ToList.ToArray
    End Function
    <WebMethod()>
    Public Shared Function LoadNewUsedCode() As VehicleBO()
        Dim newUsedList As New List(Of VehicleBO)()
        Try
            newUsedList = objVehicleService.FetchNewUsedCode()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_VehicleDetail", "LoadWarrantyCodes", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, _loginName)
        End Try
        Return newUsedList.ToList.ToArray()
    End Function

    <WebMethod()>
    Public Shared Function GetNewUsedRefNo(ByVal refNo As String) As VehicleBO()
        Dim newUsedList As New List(Of VehicleBO)()
        Try
            newUsedList = objVehicleService.GetNewUsedRefNo(refNo)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_VehicleDetail", "LoadWarrantyCodes", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, _loginName)
        End Try
        Return newUsedList.ToList.ToArray()
    End Function

    <WebMethod()>
    Public Shared Function SetNewUsedRefNo(ByVal refNoType As String, ByVal refNo As String) As VehicleBO()
        Dim newUsedList As New List(Of VehicleBO)()
        Try
            newUsedList = objVehicleService.SetNewUsedRefNo(refNoType, refNo)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_VehicleDetail", "LoadWarrantyCodes", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, _loginName)
        End Try
        Return newUsedList.ToList.ToArray()
    End Function

    <WebMethod()>
    Public Shared Function LoadStatusCode() As VehicleBO()
        Dim statusList As New List(Of VehicleBO)()
        Try
            statusList = objVehicleService.FetchStatusCode()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_VehicleDetail", "LoadWarrantyCodes", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, _loginName)
        End Try
        Return statusList.ToList.ToArray()
    End Function

    <WebMethod()>
    Public Shared Function LoadMakeCode() As VehicleBO()
        Dim Make As New List(Of VehicleBO)()
        Try
            Make = objItemsService.LoadMakeCode()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_VehicleDetail", "LoadMakeCodes", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, _loginName)
        End Try
        Return Make.ToList.ToArray()
    End Function

    <WebMethod()>
    Public Shared Function LoadCategory(ByVal q As String) As ItemsBO()
        Dim Category As New List(Of ItemsBO)()
        Try
            Category = objItemsService.LoadCategory(q)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_VehicleDetail", "LoadCategory", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, _loginName)
        End Try
        Return Category.ToList.ToArray()
    End Function

    <WebMethod()>
    Public Shared Function LoadUnitItem() As ItemsBO()
        Dim Unit As New List(Of ItemsBO)()
        Try
            Unit = objItemsService.LoadUnitItem()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_VehicleDetail", "LoadMakeCodes", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, _loginName)
        End Try
        Return Unit.ToList.ToArray()
    End Function

    <WebMethod()>
    <System.Web.Script.Services.ScriptMethod(ResponseFormat:=System.Web.Script.Services.ResponseFormat.Json)>
    Public Shared Function SparePart_Search1(ByVal q As String) As ItemsBO()
        Dim spareDetails As New List(Of ItemsBO)()
        Try
            spareDetails = objItemsService.SparePartSearch(q)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transaction_frmWOSearch", "Customer_Search", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
        End Try
        Return spareDetails.ToList.ToArray
    End Function

    <WebMethod()>
    <System.Web.Script.Services.ScriptMethod(ResponseFormat:=System.Web.Script.Services.ResponseFormat.Json)>
    Public Shared Function Supplier_Search(ByVal q As String) As ItemsBO()
        Dim supDetails As New List(Of ItemsBO)()
        Try
            supDetails = objItemsService.SupplierSearch(q)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "ss3_localspdetail", "Supplier_Search", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
        End Try
        Return supDetails.ToList.ToArray
    End Function

    <WebMethod()>
    Public Shared Function FetchSparePartDetails(ByVal spareId As String) As ItemsBO()
        Dim spareDetails As New List(Of ItemsBO)()
        Try
            spareDetails = objItemsService.FetchSparePartDetails(spareId)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCustomerDetail", "FetchCustomerDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
        End Try
        Return spareDetails.ToList.ToArray
    End Function
    <WebMethod()>
    Public Shared Function FetchItemsDetail(ByVal ID_ITEM_ID As String, ByVal ID_ITEM_MAKE As String, ByVal ID_ITEM_WH As String)
        Dim itemsDetail As New ItemsBO
        Dim itemsRes As New ItemsBO
        itemsDetail.ID_ITEM = ID_ITEM_ID
        itemsDetail.ID_WH_ITEM = ID_ITEM_WH
        itemsDetail.ID_MAKE = ID_ITEM_MAKE

        Try
            itemsRes = objItemsService.Fetch_Items_Detail(itemsDetail)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCustomerDetail", "FetchCustomerDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
        End Try
        Return itemsRes
        'Return JsonConvert.SerializeObject(itemsRes)
    End Function

    <WebMethod()>
    Public Shared Function LoadEditMake() As VehicleBO()
        Dim EditMake As New List(Of VehicleBO)()
        Try
            EditMake = objVehicleService.FetchEditMake()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_VehicleDetail", "LoadCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return EditMake.ToList.ToArray()
    End Function

    <WebMethod()>
    Public Shared Function GetEditMake(ByVal makeId As String) As VehicleBO()
        Dim EditMake As New List(Of VehicleBO)()
        Try
            EditMake = objVehicleService.GetEditMake(makeId)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_VehicleDetail", "LoadCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return EditMake.ToList.ToArray()
    End Function
    <WebMethod()>
    Public Shared Function AddEditMake(ByVal editMakeCode As String, ByVal editMakeDesc As String, ByVal editMakePriceCode As String, ByVal editMakeDiscount As String, ByVal editMakeVat As String, ByVal mode As String) As String
        Dim strResult As String = ""
        Dim dsReturnValStr As String = ""
        Dim strXMLSettingsVehMake As String = ""
        Dim strXMLSettingsModel As String = ""
        Try
            If mode = "add" Then
                strXMLSettingsVehMake = "<root><insert ID_MAKE= """ + editMakeCode + """ ID_MAKE_NAME= """ + editMakeDesc + """ ID_MAKE_PRICECODE= """ + editMakePriceCode + """ MAKEDISCODE= """ + editMakeDiscount + """ MAKE_VATCODE= """ + editMakeVat + """ /></root>"
                strXMLSettingsModel = "<ROOT></ROOT>"
                'objVehBo.MakeCode = editMakeCode
                'objVehBo.MakeName = editMakeDesc
                'objVehBo.Cost_Price = editMakePriceCode
                'objVehBo.Description = editMakeDiscount
                'objVehBo.VanNo = editMakeVat
                strResult = objVehicleService.Add_EditMake(strXMLSettingsVehMake)
            Else
                strXMLSettingsVehMake = "<ROOT><MODIFY ID_MAKE= """ + editMakeCode + """ ID_MAKE_NAME= """ + editMakeDesc + """ ID_MAKE_PRICECODE= """ + editMakePriceCode + """ MAKEDISCODE= """ + editMakeDiscount + """ MAKE_VATCODE= """ + editMakeVat + """ /></ROOT>"
                strXMLSettingsModel = "<ROOT></ROOT>"
                configDetails = objCVehSrv.UpdateVehMakeModelConfig(strXMLSettingsVehMake, strXMLSettingsModel, loginName)
            End If

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmVehicleDetail", "AddVehicle", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function

    <WebMethod()>
    Public Shared Function DeleteEditMake(ByVal editMakeId As String) As VehicleBO()
        Dim EditMake As New List(Of VehicleBO)()
        Try
            'EditMake = objVehicleService.DeleteBranch(editMakeId)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_VehicleDetail", "LoadCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return EditMake.ToList.ToArray()
    End Function
    <WebMethod()>
    Public Shared Function FetchModel(ByVal IdMake As String, ByVal Model As String) As String
        Dim IdModel As String = ""
        Try
            IdModel = objVehicleService.GetModel(IdMake, Model)

        Catch exth As System.Threading.ThreadAbortException
            Throw exth
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_VehicleDetail", "FetchModel", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return IdModel.ToString()
    End Function
    <WebMethod()>
    Public Shared Function LoadModel() As VehicleBO()
        Try
            details = objVehicleService.LoadModel()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWoHead", "LoadVehMake", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()>
    Public Shared Function FetchItemsHistory(ByVal ID_ITEM As String, ByVal ID_MAKE As String, ByVal ID_WAREHOUSE As String)
        Dim itemsHistory As New List(Of ItemsBO.ItemsHistory)()
        Try
            itemsHistory = objItemsService.Fetch_ItemsHistory(ID_ITEM, ID_MAKE, ID_WAREHOUSE)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_test", "Fetch_ItemsHistory", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
        End Try
        Return itemsHistory.ToList
    End Function


    <WebMethod()>
    Public Shared Function SparePart_Search(ByVal q As String, ByVal mustHaveQuantity As String, ByVal isStockItem As String, ByVal isNotStockItem As String, ByVal loc As String, ByVal supp As String, ByVal nonStock As Boolean) As ItemsBO()

        Dim itemDetails As New List(Of ItemsBO)()
        Try
            itemDetails = objItemsService.SparePartPopup(q, mustHaveQuantity, isStockItem, isNotStockItem, loc, supp, nonStock, False)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transaction_frmWOSearch", "SparePart_Search", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
        End Try

        Return itemDetails.ToList.ToArray
    End Function

    <WebMethod()>
    Public Shared Function SparePart_Search_Short(ByVal q As String, ByVal supp As String) As ItemsBO()

        If (supp Is Nothing Or supp = "") Then
            supp = "%"
        End If
        If (q Is Nothing Or q = "") Then
            q = "%"
        End If
        Dim must As String = False
        Dim isStock As String = False
        Dim isNon As String = False
        Dim loc As String = "%"
        Dim nonstock As String = False


        Dim itemDetails As ItemsBO()
        Try
            itemDetails = SparePart_Search(q, must, isStock, isNon, loc, supp, nonstock)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transaction_frmWOSearch", "SparePart_Search", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
        End Try

        Return itemDetails.ToList.ToArray
    End Function


End Class


