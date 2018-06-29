Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports System.Configuration
Imports System.IO
Imports System.Drawing
Imports System.Web.Script.Serialization.JavaScriptSerializer
Imports System.Object
Imports System.MarshalByRefObject
Imports System.Net.WebRequest
Imports System.Net.HttpWebRequest
Imports System.Net.HttpWebResponse
Imports System.Net
Imports System.Web
Imports System.Web.UI.HtmlControls
Imports System.Web.UI.WebControls.WebParts
Imports Newtonsoft.Json
Imports Newtonsoft.Json.Linq
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports Microsoft.Practices.EnterpriseLibrary.Data.Sql

Namespace CARS.Services.Items
    Public Class ItemsDetail
        Shared objItemsBO As New ItemsBO
        Shared objItemsDO As New ItemsDO
        Shared objVehicleDO As New VehicleDO
        Shared objVehicleBO As New VehicleBO
        Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
        Shared objWOJ As New CARS.Services.WOJobDetails.WOJobDetails
        Public Function Fetch_Items_Detail(ItemsDetail As ItemsBO)
            Dim dsItemsDetail As New DataSet
            Dim dtItemsDetail As New DataTable
            Dim dtItemsAdvanced As New DataTable
            Dim itemDetails As New ItemsBO
            Try
                dsItemsDetail = objItemsDO.Fetch_Item_Details(ItemsDetail)
                If dsItemsDetail.Tables.Count > 0 Then
                    dtItemsDetail = dsItemsDetail.Tables(0)
                    dtItemsAdvanced = dsItemsDetail.Tables(1)
                End If
                For Each dtrow As DataRow In dtItemsDetail.Rows
                    itemDetails.ID_ITEM = dtrow("ID_ITEM").ToString()
                    itemDetails.ITEM_DESC = dtrow("ITEM_DESC").ToString()
                    itemDetails.ID_SUPPLIER_ITEM = dtrow("ID_SUPPLIER_ITEM").ToString()
                    itemDetails.ID_MAKE = dtrow("ID_MAKE").ToString()
                    itemDetails.ID_WH_ITEM = dtrow("ID_WH_ITEM").ToString()
                    itemDetails.LOCATION = dtrow("LOCATION").ToString()
                    itemDetails.ALT_LOCATION = dtrow("ALT_LOCATION").ToString()
                    'itemDetails.ITEM_DISC_CODE = IIf(IsDBNull(dtrow("ITEM_DISC_CODE")), " ", dtrow("ITEM_DISC_CODE").ToString())
                    itemDetails.ITEM_DISC_CODE_BUY = IIf(IsDBNull(dtrow("ITEM_DISC_CODE_BUY")), " ", dtrow("ITEM_DISC_CODE_BUY").ToString())
                    itemDetails.SUP_Name = dtrow("SUP_Name").ToString()
                    itemDetails.ANNOTATION = dtrow("ANNOTATION").ToString()
                    itemDetails.BASIC_PRICE = IIf(IsDBNull(dtrow("BASIC_PRICE")), "0,00", dtrow("BASIC_PRICE").ToString())
                    itemDetails.AVG_PRICE = IIf(IsDBNull(dtrow("AVG_PRICE")), "0,00", dtrow("AVG_PRICE").ToString())
                    itemDetails.LAST_COST_PRICE = IIf(IsDBNull(dtrow("LAST_COST_PRICE")), "0,00", dtrow("LAST_COST_PRICE").ToString())
                    itemDetails.ITEM_PRICE = IIf(IsDBNull(dtrow("ITEM_PRICE")), "0,00", dtrow("ITEM_PRICE").ToString())
                    itemDetails.ITEM_AVAIL_QTY = IIf(IsDBNull(dtrow("ITEM_AVAIL_QTY")), "0,00", dtrow("ITEM_AVAIL_QTY").ToString())
                    itemDetails.QTY_BO_SUPPLIER = IIf(IsDBNull(dtrow("QTY_BO_SUPPLIER")), "0,00", dtrow("QTY_BO_SUPPLIER").ToString())
                    itemDetails.PACKAGE_QTY = dtrow("PACKAGE_QTY").ToString()
                    itemDetails.TEXT = dtrow("TEXT").ToString()
                    itemDetails.PREVIOUS_ITEM_ID = dtrow("PREVIOUS_ITEM_ID").ToString()
                    itemDetails.NEW_ITEM_ID = dtrow("NEW_ITEM_ID").ToString()
                    itemDetails.FLG_STOCKITEM = IIf(IsDBNull(dtrow("FLG_STOCKITEM")), False, dtrow("FLG_STOCKITEM").ToString())
                    itemDetails.FLG_OBSOLETE_SPARE = IIf(IsDBNull(dtrow("FLG_OBSOLETE_SPARE")), False, dtrow("FLG_OBSOLETE_SPARE").ToString())
                    itemDetails.FLG_LABELS = IIf(IsDBNull(dtrow("FLG_LABELS")), False, dtrow("FLG_LABELS").ToString())
                    itemDetails.FLG_VAT_INCL = IIf(IsDBNull(dtrow("FLG_VAT_INCL")), False, dtrow("FLG_VAT_INCL").ToString())
                    itemDetails.FLG_BLOCK_AUTO_ORD = IIf(IsDBNull(dtrow("FLG_BLOCK_AUTO_ORD")), False, dtrow("FLG_BLOCK_AUTO_ORD").ToString())
                    itemDetails.FLG_ALLOW_DISCOUNT = IIf(IsDBNull(dtrow("FLG_ALLOW_DISCOUNT")), False, dtrow("FLG_ALLOW_DISCOUNT").ToString())
                    itemDetails.FLG_AUTO_ARRIVAL = IIf(IsDBNull(dtrow("FLG_AUTO_ARRIVAL")), False, dtrow("FLG_AUTO_ARRIVAL").ToString())
                    itemDetails.FLG_OBTAIN_SPARE = IIf(IsDBNull(dtrow("FLG_OBTAIN_SPARE")), False, dtrow("FLG_OBTAIN_SPARE").ToString())
                    itemDetails.FLG_AUTOADJUST_PRICE = IIf(IsDBNull(dtrow("FLG_AUTOADJUST_PRICE")), False, dtrow("FLG_AUTOADJUST_PRICE").ToString())
                    itemDetails.FLG_REPLACEMENT_PURCHASE = IIf(IsDBNull(dtrow("FLG_REPLACEMENT_PURCHASE")), False, dtrow("FLG_REPLACEMENT_PURCHASE").ToString())
                    itemDetails.FLG_SAVE_TO_NONSTOCK = IIf(IsDBNull(dtrow("FLG_SAVE_TO_NONSTOCK")), False, dtrow("FLG_SAVE_TO_NONSTOCK").ToString())
                    itemDetails.FLG_EFD = IIf(IsDBNull(dtrow("FLG_EFD")), False, dtrow("FLG_EFD").ToString())
                    itemDetails.MIN_STOCK = dtrow("MIN_STOCK").ToString()
                    itemDetails.MAX_STOCK = dtrow("MAX_STOCK").ToString()
                    itemDetails.ID_UNIT_ITEM = dtrow("ID_UNIT_ITEM").ToString()
                    itemDetails.LAST_BUY_PRICE = IIf(IsDBNull(dtrow("LAST_BUY_PRICE")), False, dtrow("LAST_BUY_PRICE").ToString())
                    itemDetails.DT_LAST_BUY = dtrow("DT_LAST_BUY").ToString()
                    itemDetails.WEIGHT = dtrow("WEIGHT").ToString()
                    itemDetails.ENV_ID_ITEM = dtrow("ENV_ID_ITEM").ToString()
                    itemDetails.ENV_ID_MAKE = dtrow("ENV_ID_MAKE").ToString()
                    itemDetails.ENV_ID_WAREHOUSE = dtrow("ENV_ID_WAREHOUSE").ToString()
                    itemDetails.COST_PRICE1 = dtrow("COST_PRICE1").ToString()
                    itemDetails.DISCOUNT = dtrow("DISCOUNT").ToString()
                    itemDetails.ID_SPCATEGORY = IIf(IsDBNull(dtrow("ID_SPCATEGORY")), "0", dtrow("ID_SPCATEGORY").ToString())
                    itemDetails.SUPP_CURRENTNO = dtrow("SUPP_CURRENTNO").ToString()
                    itemDetails.SUP_CURRENCY_CODE = dtrow("SUP_CURRENCY_CODE").ToString()
                    itemDetails.ID_ITEM_CATG = dtrow("ID_ITEM_CATG").ToString()
                    'itemDetails.Add(itemDet)
                Next
                For Each dtrow As DataRow In dtItemsAdvanced.Rows
                    itemDetails.PO_NO = dtrow("PO_NO").ToString()
                    itemDetails.PO_QTY = dtrow("PO_QTY").ToString()
                    itemDetails.PO_DT_CREATED = dtrow("PO_DT_CREATED").ToString()
                    itemDetails.PO_DT_EXPDLVDATE = dtrow("PO_DT_EXPDLVDATE").ToString()
                    itemDetails.PO_ANNOTATION = dtrow("PO_ANNOTATION").ToString()
                    itemDetails.IR_NO = dtrow("IR_NO").ToString()
                    itemDetails.IR_QTY = dtrow("IR_QTY").ToString()
                    itemDetails.COUNTING_DATE = dtrow("COUNTING_DATE").ToString()
                    itemDetails.COUNTING_CREATED_BY = dtrow("COUNTING_CREATED_BY").ToString()

                    itemDetails.DT_LAST_SOLD = dtrow("DT_LAST_SOLD").ToString()
                    itemDetails.DT_LAST_BO = dtrow("DT_LAST_BO").ToString()
                    itemDetails.TOTAL_BO_QTY = dtrow("TOTAL_BO_QTY").ToString()
                    itemDetails.TOTAL_ORDER_BO_QTY = dtrow("TOTAL_ORDER_BO_QTY").ToString()
                    itemDetails.TOTAL_BARGAIN_BO_QTY = dtrow("TOTAL_BARGAIN_BO_QTY").ToString()
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOHeader", "Fetch_Customer_Contact_Person", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return itemDetails
        End Function

        Public Function LoadMakeCode() As List(Of VehicleBO)
            Dim dsLoadMakes As New DataSet
            Dim dtMakeCodes As DataTable
            Dim Make As New List(Of VehicleBO)()
            Try
                dsLoadMakes = objItemsDO.LoadMakeCodes()
                dtMakeCodes = dsLoadMakes.Tables(0)
                'HttpContext.Current.Session("dvSubsidiaryList") = dtSubDetails.DefaultView
                For Each dtrow As DataRow In dtMakeCodes.Rows
                    Dim makeDet As New VehicleBO()
                    makeDet.Id_Make_Veh = dtrow("ID_SETTINGS").ToString()
                    makeDet.MakeName = dtrow("ID_PARAM").ToString()
                    Make.Add(makeDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Vehicle.vb", "FetchMakeCode", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return Make.ToList
        End Function
        Public Function LoadCategory(ByVal q As String) As List(Of ItemsBO)
            Dim dsLoadCategories As New DataSet
            Dim dtCategory As DataTable
            Dim Category As New List(Of ItemsBO)()
            Try
                dsLoadCategories = objItemsDO.LoadCategory(q)
                dtCategory = dsLoadCategories.Tables(0)
                'HttpContext.Current.Session("dvSubsidiaryList") = dtSubDetails.DefaultView
                For Each dtrow As DataRow In dtCategory.Rows
                    Dim CategoryDet As New ItemsBO()
                    CategoryDet.ID_ITEM_CATG = dtrow("ID_ITEM_CATG").ToString()
                    CategoryDet.CATEGORY = dtrow("CATG_DESC").ToString()
                    Category.Add(CategoryDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Vehicle.vb", "FetchMakeCode", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return Category.ToList
        End Function
        Public Function LoadUnitItem() As List(Of ItemsBO)
            Dim dsLoadUnit As New DataSet
            Dim dtUnitItem As DataTable
            Dim Unit As New List(Of ItemsBO)()
            Try
                dsLoadUnit = objItemsDO.LoadUnitItem()
                dtUnitItem = dsLoadUnit.Tables(0)
                'HttpContext.Current.Session("dvSubsidiaryList") = dtSubDetails.DefaultView
                For Each dtrow As DataRow In dtUnitItem.Rows
                    Dim unitDet As New ItemsBO()
                    unitDet.ID_UNIT_ITEM = dtrow("ID_UNIT").ToString()
                    unitDet.UNIT_DESC = dtrow("UNIT_DESC").ToString()
                    Unit.Add(unitDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Vehicle.vb", "FetchMakeCode", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return Unit.ToList
        End Function
        'Autocomplete function for spare part search
        Public Function SparePartSearch(ByVal q As String) As List(Of ItemsBO)
            Dim dsSparePart As New DataSet
            Dim dtSparePart As DataTable
            Dim sparePartSearchResult As New List(Of ItemsBO)()
            Try
                dsSparePart = objItemsDO.SparePart_Search(q)

                If dsSparePart.Tables.Count > 0 Then
                    dtSparePart = dsSparePart.Tables(0)
                End If
                If q <> String.Empty Then
                    For Each dtrow As DataRow In dtSparePart.Rows
                        Dim csr As New ItemsBO()
                        csr.ID_MAKE = dtrow("ID_MAKE").ToString
                        csr.ID_ITEM = dtrow("ID_ITEM").ToString
                        csr.ITEM_DESC = dtrow("ITEM_DESC").ToString
                        csr.ITEM_AVAIL_QTY = dtrow("ITEM_AVAIL_QTY").ToString
                        csr.LOCATION = dtrow("LOCATION").ToString
                        csr.ID_WH_ITEM = dtrow("ID_WH_ITEM").ToString
                        csr.LAST_COST_PRICE = dtrow("LAST_COST_PRICE").ToString
                        csr.ITEM_PRICE = dtrow("ITEM_PRICE").ToString
                        csr.ENV_ID_MAKE = dtrow("SUPP_CURRENTNO").ToString
                        sparePartSearchResult.Add(csr)
                    Next
                End If
            Catch ex As Exception
                Throw ex
            End Try
            Return sparePartSearchResult
        End Function
        'Autocomplete function for supplier search
        Public Function SupplierSearch(ByVal q As String) As List(Of ItemsBO)
            Dim dsSupplier As New DataSet
            Dim dtSupplier As DataTable
            Dim supSearchResult As New List(Of ItemsBO)()
            Try
                dsSupplier = objItemsDO.Supplier_Search(q)

                If dsSupplier.Tables.Count > 0 Then
                    dtSupplier = dsSupplier.Tables(0)
                End If
                If q <> String.Empty Then
                    For Each dtrow As DataRow In dtSupplier.Rows
                        Dim csr As New ItemsBO()
                        csr.ID_SUPPLIER_ITEM = dtrow("ID_SUPPLIER").ToString
                        csr.SUP_Name = dtrow("SUP_Name").ToString
                        csr.SUPP_CURRENTNO = dtrow("SUPP_CURRENTNO").ToString

                        supSearchResult.Add(csr)
                    Next
                End If
            Catch ex As Exception
                Throw ex
            End Try
            Return supSearchResult
        End Function
        Public Function FetchSparePartDetails(ByVal spareId As String) As List(Of ItemsBO)
            Dim dsSparePart As New DataSet
            Dim dtSparePart As DataTable
            Dim retSparePart As New List(Of ItemsBO)()
            Try
                dsSparePart = objItemsDO.Fetch_SparePart_Details(spareId)

                If dsSparePart.Tables.Count > 0 Then
                    dtSparePart = dsSparePart.Tables(0)
                End If
                If spareId <> String.Empty Then
                    For Each dtrow As DataRow In dtSparePart.Rows
                        Dim spareDet As New ItemsBO()
                        spareDet.ID_MAKE = dtrow("ID_MAKE").ToString()
                        spareDet.ID_ITEM = dtrow("ID_ITEM").ToString()
                        spareDet.ITEM_DESC = dtrow("ITEM_DESC").ToString()
                        spareDet.LOCATION = dtrow("LOCATION").ToString()
                        spareDet.ID_SUPPLIER_ITEM = dtrow("ID_SUPPLIER_ITEM").ToString()
                        retSparePart.Add(spareDet)
                    Next
                End If
            Catch ex As Exception
                Throw ex
            End Try
            Return retSparePart
        End Function

        Public Function Insert_SparePart(ByVal spareID As ItemsBO) As String()
            Dim strResult As String = ""
            Dim strArray As Array
            Dim login As String = HttpContext.Current.Session("UserID")
            Try
                strResult = objItemsDO.Insert_SparePart(spareID, login)
                strArray = strResult.Split(";")
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.Customer", "Insert_Customer", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strArray
        End Function
        Public Function Fetch_ItemsHistory(ByVal ID_ITEM As String, ID_MAKE As String, ID_WAREHOUSE As Integer)
            Dim ItemsHistory As New List(Of ItemsBO.ItemsHistory)()
            Dim dsItemHistory As New DataSet
            Dim dtItemHistory As New DataTable
            Dim objItemHistory As New ItemsBO.ItemsHistory
            Try
                dsItemHistory = objItemsDO.FetchItemsHistory(ID_ITEM, ID_MAKE, ID_WAREHOUSE)
                If dsItemHistory.Tables.Count > 0 Then
                    dtItemHistory = dsItemHistory.Tables(0)
                    For Each dtrow As DataRow In dtItemHistory.Rows
                        Dim ItemsHD As New ItemsBO.ItemsHistory
                        ItemsHD.M_YEAR = dtrow("M_YEAR").ToString
                        ItemsHD.M_PERIOD = dtrow("M_PERIOD").ToString
                        ItemsHD.M_TOTAL_SOLD_QTY = dtrow("M_TOTAL_SOLD_QTY")
                        ItemsHD.M_TOTAL_COST = dtrow("M_TOTAL_COST")
                        ItemsHD.M_TOTAL_GROSS = dtrow("M_TOTAL_GROSS")
                        ItemsHistory.Add(ItemsHD)
                    Next
                    dtItemHistory = dsItemHistory.Tables(1)
                    For Each dtrow As DataRow In dtItemHistory.Rows
                        Dim ItemsHD As New ItemsBO.ItemsHistory
                        ItemsHD.M_YEAR = dtrow("M_YEAR").ToString
                        ItemsHD.M_PERIOD = dtrow("M_PERIOD").ToString
                        ItemsHD.M_TOTAL_SOLD_QTY = dtrow("M_TOTAL_SOLD_QTY")
                        ItemsHD.M_TOTAL_COST = dtrow("M_TOTAL_COST")
                        ItemsHD.M_TOTAL_GROSS = dtrow("M_TOTAL_GROSS")
                        ItemsHistory.Add(ItemsHD)
                    Next
                End If
            Catch ex As Exception

            End Try
            Return ItemsHistory
        End Function
        Public Function Fetch_EnvSparePartDetails(ByVal sparePartId As String, ByVal name As String, ByVal warehouse As String) As List(Of ItemsBO)
            Dim dsSparePart As New DataSet
            Dim dtSparePart As DataTable
            Dim idWh As String = ""
            Dim sparePartSearchResult As New List(Of ItemsBO)()
            Try
                idWh = warehouse ' objWOJ.GetWarehouse()
                dsSparePart = objItemsDO.Fetch_EnvSparePart_Details(sparePartId, name, HttpContext.Current.Session("UserID").ToString, idWh)
                HttpContext.Current.Session("EnvSparePartDetails") = dsSparePart

                If dsSparePart.Tables.Count > 0 Then
                    dtSparePart = dsSparePart.Tables(0)
                    For Each dtrow As DataRow In dtSparePart.Rows
                        Dim csr As New ItemsBO()
                        csr.SLNO = dtrow("SLNO").ToString
                        csr.ID_ITEM = dtrow("ID_ITEM").ToString
                        csr.ENV_ID_WAREHOUSE = dtrow("ID_WAREHOUSE").ToString
                        csr.MIN_AMT = dtrow("MIN_AMT").ToString
                        csr.MAX_AMT = dtrow("MAX_AMT").ToString
                        csr.ADDED_FEE_PERC = dtrow("ADDED_FEE_PERCENTAGE").ToString
                        csr.ENV_NAME = dtrow("NAME").ToString
                        csr.ENV_VATCODE = dtrow("VAT_CODE").ToString
                        csr.ENV_ID_MAKE = dtrow("SUPP_CURRENTNO").ToString
                        sparePartSearchResult.Add(csr)
                    Next
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.Items", "Fetch_EnvSparePartDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))

            End Try
            Return sparePartSearchResult
        End Function

        Public Function GetEnvSparePartDetails(ByVal sparePartId As String, ByVal make As String, ByVal warehouse As String) As Collection
            Dim detailsColl As New Collection
            Try
                Dim ds As New DataSet
                Dim dt As New DataTable
                Dim dv As New DataView

                ds = HttpContext.Current.Session("EnvSparePartDetails")
                If (ds.Tables.Count > 0) Then
                    If (ds.Tables(0).Rows.Count > 0) Then
                        dt = ds.Tables(0)
                        dv = dt.DefaultView
                        dv.RowFilter = "Id_Item = '" + sparePartId + "' and SUPP_CURRENTNO='" + make + "' and Id_Warehouse = '" + warehouse + "'"
                    End If

                    dt = dv.ToTable

                    If (dt.Rows.Count > 0) Then
                        For Each dtrow As DataRow In dt.Rows
                            Dim csr As New ItemsBO()
                            csr.SLNO = dtrow("SLNO").ToString
                            csr.ID_ITEM = dtrow("ID_ITEM").ToString
                            csr.ENV_ID_WAREHOUSE = dtrow("ID_WAREHOUSE").ToString
                            csr.MIN_AMT = dtrow("MIN_AMT").ToString
                            csr.MAX_AMT = dtrow("MAX_AMT").ToString
                            csr.ADDED_FEE_PERC = dtrow("ADDED_FEE_PERCENTAGE").ToString
                            csr.ENV_NAME = dtrow("NAME").ToString
                            csr.ENV_VATCODE = dtrow("VAT_CODE").ToString
                            csr.ENV_ID_MAKE = dtrow("SUPP_CURRENTNO").ToString
                            detailsColl.Add(csr)
                        Next
                    Else
                        dt = ds.Tables(0)
                        Dim details As New List(Of ItemsBO)()
                        detailsColl.Add(details)
                    End If
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.Items", "GetEnvSparePartDetails", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return detailsColl
        End Function

        Public Function Save_EnvFeeSettings(ByVal objItemsBO As ItemsBO) As String()
            Dim strResult As String = ""
            Dim strResVal As Array
            Try
                strResult = objItemsDO.Save_EnvFeeSettings(objItemsBO)
                strResVal = strResult.Split(",")
                ' Dim strValue = objErrHandle.GetErrorDesc("MTEMPLATE").ToString
                If strResVal(0) = "INS" Then
                    strResVal(0) = "INSERTED"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("INS")
                ElseIf strResVal(0) = "UDP" Then
                    strResVal(0) = "UPDATED"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("UPD")
                ElseIf strResVal(0) = "ERROR" Then
                    strResVal(0) = "ERROR"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("DUPSAVE")
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.Items", "Save_EnvFeeSettings", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strResVal
        End Function

        Public Function Delete_EnvFeeSettings(ByVal sparePartId As String, ByVal spMake As String, ByVal idWh As String) As String()
            Dim strResult As String = ""
            Dim strResVal As Array
            Try
                strResult = objItemsDO.Delete_EnvSparePart_Details(sparePartId, spMake, idWh)
                strResVal = strResult.Split(",")
                ' Dim strValue = objErrHandle.GetErrorDesc("MTEMPLATE").ToString
                If strResVal(0) = "DEL" Then
                    strResVal(0) = "DELETED"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("DEL")
                ElseIf strResVal(0) = "ERROR" Then
                    strResVal(0) = "ERROR"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("IEC")
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.Items", "Delete_EnvFeeSettings", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strResVal
        End Function
        Public Function FetchSupplierDetails(ByVal supplier As String) As List(Of ItemsBO)
            Dim dsSupplier As New DataSet
            Dim dtSupplier As DataTable
            Dim retSupplier As New List(Of ItemsBO)()
            Try
                dsSupplier = objItemsDO.LoadSupplier(supplier, HttpContext.Current.Session("UserID"))

                If dsSupplier.Tables.Count > 0 Then
                    dtSupplier = dsSupplier.Tables(0)
                End If

                For Each dtrow As DataRow In dtSupplier.Rows
                    Dim supplierdet As New ItemsBO()
                    supplierdet.SUP_Name = dtrow("SUPPLIER NAME").ToString()
                    supplierdet.SUPPLIER_NUMBER = dtrow("SUPPLIER NUMBER").ToString()
                    supplierdet.ID_SUPPLIER_ITEM = dtrow("SUPPLIER ID").ToString()
                    retSupplier.Add(supplierdet)
                Next

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.Items", "FetchSupplierDetails", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return retSupplier
        End Function
        Public Function FetchSprDiscountCodes(ByVal supplier As String) As List(Of ItemsBO)
            Dim dsDiscCodes As New DataSet
            Dim dtDiscCodes As DataTable
            Dim retDiscCodes As New List(Of ItemsBO)()
            Try
                dsDiscCodes = objItemsDO.LoadDiscCodes(supplier)
                HttpContext.Current.Session("SprDiscountCodes") = dsDiscCodes
                If dsDiscCodes.Tables.Count > 0 Then
                    dtDiscCodes = dsDiscCodes.Tables(0)
                    For Each dtrow As DataRow In dtDiscCodes.Rows
                        Dim discCodesdet As New ItemsBO()
                        discCodesdet.DISCOUNT = dtrow("ID_DISCOUNTCODE").ToString()
                        discCodesdet.DESCRIPTION = dtrow("DISCOUNTCODE").ToString()
                        discCodesdet.ID_ITEM_DISC_CODE_BUYING = dtrow("ID_DISCOUNTCODE").ToString()
                        discCodesdet.SUP_Name = dtrow("SUP_Name").ToString()
                        discCodesdet.SUPPLIER_NUMBER = dtrow("SUPP_CurrentNo").ToString()
                        discCodesdet.ITEM_DISC_CODE_BUYING = dtrow("DESCRIPTION").ToString()
                        retDiscCodes.Add(discCodesdet)
                    Next
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.Items", "FetchSprDiscountCodes", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return retDiscCodes
        End Function
        Public Function FetchSparePartCategoryDetails() As List(Of ItemsBO)
            Dim dsSpCatgDet As New DataSet
            Dim dtSpCatgDet As DataTable
            Dim retSpCatgDet As New List(Of ItemsBO)()
            Try
                dsSpCatgDet = objItemsDO.LoadSparePartCategory()
                HttpContext.Current.Session("SparePartCategory") = dsSpCatgDet
                If dsSpCatgDet.Tables.Count > 0 Then
                    dtSpCatgDet = dsSpCatgDet.Tables(0)
                End If

                For Each dtrow As DataRow In dtSpCatgDet.Rows
                    Dim spCatgDetdet As New ItemsBO()
                    spCatgDetdet.SUPPLIER_NUMBER = dtrow("SUPP_CURRENTNO").ToString()
                    spCatgDetdet.CATEGORY = dtrow("CATEGORY").ToString()
                    spCatgDetdet.DESCRIPTION = dtrow("DESCRIPTION").ToString()
                    spCatgDetdet.INITIALCLASSCODE = dtrow("INITIALCLASSCODE").ToString()
                    spCatgDetdet.ID_VAT_CODE = IIf(IsDBNull(dtrow("ID_VATCODE")) = True, 0, dtrow("ID_VATCODE"))
                    spCatgDetdet.ACCOUNT_CODE = dtrow("ACCOUNTCODE").ToString()
                    spCatgDetdet.FLG_ALLOW_BCKORD = dtrow("FLG_ALLOWBO_L").ToString()
                    spCatgDetdet.FLG_CNT_STOCK = dtrow("FLG_COUNTSTOCK_L").ToString()
                    spCatgDetdet.FLG_ALLOW_CLASSIFICATION = dtrow("FLG_ALLOWCLASS_L").ToString()
                    spCatgDetdet.ALLOW_BCKORD = dtrow("FLG_ALLOWBO").ToString()
                    spCatgDetdet.CNT_STOCK = dtrow("FLG_COUNTSTOCK").ToString()
                    spCatgDetdet.ALLOW_CLASSIFICATION = dtrow("FLG_ALLOWCLASS").ToString()
                    spCatgDetdet.SUP_Name = dtrow("SUPPLIER").ToString()
                    spCatgDetdet.ID_SPCATEGORY = dtrow("ID_ITEM_CATG").ToString()
                    spCatgDetdet.ID_ITEM_DISC_CODE_BUYING = IIf(IsDBNull(dtrow("ID_DISCOUNTCODEBUY")) = True, "0", dtrow("ID_DISCOUNTCODEBUY"))
                    spCatgDetdet.ITEM_DISC_CODE_BUYING = IIf(IsDBNull(dtrow("DISCOUNTBUY")) = True, "", dtrow("DISCOUNTBUY"))
                    spCatgDetdet.ITEM_DISC_CODE_SELL = IIf(IsDBNull(dtrow("DISCOUNTSELL")) = True, "", dtrow("DISCOUNTSELL"))
                    spCatgDetdet.ID_ITEM_DISC_CODE_SELL = IIf(IsDBNull(dtrow("ID_DISCOUNTCODESELL")) = True, "0", dtrow("ID_DISCOUNTCODESELL"))
                    spCatgDetdet.ID_SUPPLIER_ITEM = IIf(IsDBNull(dtrow("ID_SUPPLIER")) = True, "0", dtrow("ID_SUPPLIER"))
                    retSpCatgDet.Add(spCatgDetdet)
                Next

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.Items", "FetchSparePartCategoryDetails", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return retSpCatgDet
        End Function
        Public Function GetSparePartCategoryDetails(ByVal idItemCatg As String) As Collection
            Dim detailsColl As New Collection
            Try
                Dim ds As New DataSet
                Dim dt As New DataTable
                Dim dv As New DataView

                ds = HttpContext.Current.Session("SparePartCategory")
                If (ds.Tables.Count > 0) Then
                    If (ds.Tables(0).Rows.Count > 0) Then
                        dt = ds.Tables(0)
                        dv = dt.DefaultView
                        dv.RowFilter = "ID_ITEM_CATG = '" + idItemCatg + "'"
                    End If

                    dt = dv.ToTable

                    If (dt.Rows.Count > 0) Then
                        For Each dtrow As DataRow In dt.Rows
                            Dim spCatgDetdet As New ItemsBO()
                            spCatgDetdet.SUPPLIER_NUMBER = dtrow("SUPP_CURRENTNO").ToString()
                            spCatgDetdet.CATEGORY = dtrow("CATEGORY").ToString()
                            spCatgDetdet.DESCRIPTION = dtrow("DESCRIPTION").ToString()
                            spCatgDetdet.INITIALCLASSCODE = dtrow("INITIALCLASSCODE").ToString()
                            spCatgDetdet.ID_VAT_CODE = IIf(IsDBNull(dtrow("ID_VATCODE")) = True, 0, dtrow("ID_VATCODE"))
                            spCatgDetdet.ACCOUNT_CODE = dtrow("ACCOUNTCODE").ToString()
                            spCatgDetdet.FLG_ALLOW_BCKORD = dtrow("FLG_ALLOWBO_L").ToString()
                            spCatgDetdet.FLG_CNT_STOCK = dtrow("FLG_COUNTSTOCK_L").ToString()
                            spCatgDetdet.FLG_ALLOW_CLASSIFICATION = dtrow("FLG_ALLOWCLASS_L").ToString()
                            spCatgDetdet.ALLOW_BCKORD = dtrow("FLG_ALLOWBO").ToString()
                            spCatgDetdet.CNT_STOCK = dtrow("FLG_COUNTSTOCK").ToString()
                            spCatgDetdet.ALLOW_CLASSIFICATION = dtrow("FLG_ALLOWCLASS").ToString()
                            spCatgDetdet.SUP_Name = dtrow("SUPPLIER").ToString()
                            spCatgDetdet.ID_SPCATEGORY = dtrow("ID_ITEM_CATG").ToString()
                            spCatgDetdet.ID_ITEM_DISC_CODE_BUYING = IIf(IsDBNull(dtrow("ID_DISCOUNTCODEBUY")) = True, "0", dtrow("ID_DISCOUNTCODEBUY"))
                            spCatgDetdet.ITEM_DISC_CODE_BUYING = IIf(IsDBNull(dtrow("DISCOUNTBUY")) = True, "", dtrow("DISCOUNTBUY"))
                            spCatgDetdet.ITEM_DISC_CODE_SELL = IIf(IsDBNull(dtrow("DISCOUNTSELL")) = True, "", dtrow("DISCOUNTSELL"))
                            spCatgDetdet.ID_ITEM_DISC_CODE_SELL = IIf(IsDBNull(dtrow("ID_DISCOUNTCODESELL")) = True, "0", dtrow("ID_DISCOUNTCODESELL"))
                            spCatgDetdet.ID_SUPPLIER_ITEM = IIf(IsDBNull(dtrow("ID_SUPPLIER")) = True, "0", dtrow("ID_SUPPLIER"))
                            detailsColl.Add(spCatgDetdet)
                        Next
                    Else
                        dt = ds.Tables(0)
                        Dim details As New List(Of ItemsBO)()
                        detailsColl.Add(details)
                    End If
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.Items", "GetSparePartCategoryDetails", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return detailsColl
        End Function

        Public Function AddSpCatgDetails(ByVal objItemsBO As ItemsBO) As String()
            Dim strResult As String = ""
            Dim strResVal As Array
            Try
                strResult = objItemsDO.AddSpCatgDetails(objItemsBO)
                strResVal = strResult.Split(",")
                Dim strValue = objItemsBO.DESCRIPTION.ToString
                If strResVal(0) = "True" Then
                    strResVal(0) = "INSERTED"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("ADD", "'" + objErrHandle.GetErrorDesc("MSG068") + "'")
                ElseIf strResVal(0) = "0" Then
                    strResVal(0) = "AEXISTS"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("RECNINS", "'" + strValue + "'")
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.Items", "AddSpCatgDetails", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strResVal
        End Function

        Public Function UpdSpCatgDetails(ByVal objItemsBO As ItemsBO) As String()
            Dim strResult As String = ""
            Dim strResVal As Array
            Try
                strResult = objItemsDO.UpdSpCatgDetails(objItemsBO)
                strResVal = strResult.Split(",")
                Dim strValue = objItemsBO.DESCRIPTION.ToString
                If strResVal(0) = "True" Then
                    strResVal(0) = "UPDATED"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("UPD", "'" + objErrHandle.GetErrorDesc("MSG068") + "'")
                ElseIf strResVal(0) = "0" Then
                    strResVal(0) = "AEXISTS"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("RECNUPDS", "'" + strValue + "'")
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.Items", "UpdSpCatgDetails", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strResVal
        End Function

        Public Function DeleteSpCatgDetails(ByVal idItemCatg As String) As String()
            Dim strResult As String = ""
            Dim strResVal As Array
            Try
                strResult = objItemsDO.DeleteSpCatgDet(idItemCatg)
                strResVal = strResult.Split(",")
                Dim strValue = objErrHandle.GetErrorDesc("MTEMPLATE").ToString
                If strResVal(0) = "True" Then
                    strResVal(0) = "DELETED"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("DDEL", "'" + objErrHandle.GetErrorDesc("MSG068") + "'")
                Else
                    strResVal(0) = "ERROR"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("msg099")
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.Items", "DeleteSpCatgDetails", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strResVal
        End Function

        Public Function GetDiscCodeDetails(ByVal idDiscCode As String) As Collection
            Dim detailsColl As New Collection
            Try
                Dim ds As New DataSet
                Dim dt As New DataTable
                Dim dv As New DataView

                ds = HttpContext.Current.Session("SprDiscountCodes")
                If (ds.Tables.Count > 0) Then
                    If (ds.Tables(0).Rows.Count > 0) Then
                        dt = ds.Tables(0)
                        dv = dt.DefaultView
                        dv.RowFilter = "ID_DISCOUNTCODE = '" + idDiscCode + "'"
                    End If

                    dt = dv.ToTable

                    If (dt.Rows.Count > 0) Then
                        For Each dtrow As DataRow In dt.Rows
                            Dim discCodesdet As New ItemsBO()
                            discCodesdet.DISCOUNT = dtrow("ID_DISCOUNTCODE").ToString()
                            discCodesdet.DESCRIPTION = dtrow("DISCOUNTCODE").ToString()
                            discCodesdet.ID_ITEM_DISC_CODE_BUYING = dtrow("ID_DISCOUNTCODE").ToString()
                            discCodesdet.SUP_Name = dtrow("SUP_NAME").ToString()
                            discCodesdet.SUPPLIER_NUMBER = dtrow("SUPP_CURRENTNO").ToString()
                            discCodesdet.ITEM_DISC_CODE_BUYING = dtrow("DESCRIPTION").ToString()
                            detailsColl.Add(discCodesdet)
                        Next
                    Else
                        dt = ds.Tables(0)
                        Dim details As New List(Of ItemsBO)()
                        detailsColl.Add(details)
                    End If
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.Items", "GetDiscCodeDetails", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return detailsColl
        End Function
        Public Function AddDiscCodeDetails(ByVal objItemsBO As ItemsBO) As String()
            Dim strResult As String = ""
            Dim strResVal As Array
            Try
                strResult = objItemsDO.AddDiscCodeDetails(objItemsBO)
                strResVal = strResult.Split(",")
                Dim strValue = objItemsBO.DESCRIPTION.ToString
                If strResVal(0) = "True" Then
                    strResVal(0) = "INSERTED"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("ADD", "'" + objErrHandle.GetErrorDesc("DSCCD") + "'")
                ElseIf strResVal(0) = "0" Then
                    strResVal(0) = "AEXISTS"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("SS3_001")
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.Items", "AddDiscCodeDetails", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strResVal
        End Function

        Public Function UpdDiscCodeDetails(ByVal objItemsBO As ItemsBO) As String()
            Dim strResult As String = ""
            Dim strResVal As Array
            Try
                strResult = objItemsDO.UpdDiscCodeDetails(objItemsBO)
                strResVal = strResult.Split(",")
                Dim strValue = objItemsBO.DESCRIPTION.ToString
                If strResVal(0) = "True" Then
                    strResVal(0) = "UPDATED"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("UPD", "'" + objErrHandle.GetErrorDesc("DSCCD") + "'")
                ElseIf strResVal(0) = "0" Then
                    strResVal(0) = "AEXISTS"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("RECNUPDS", "'" + strValue + "'")
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.Items", "UpdDiscCodeDetails", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strResVal
        End Function
        Public Function DeleteDiscCodeDetails(ByVal idDiscCode As String) As String()
            Dim strResult As String = ""
            Dim strResVal As Array
            Try
                strResult = objItemsDO.DeleteDiscCodeDetails(idDiscCode)
                strResVal = strResult.Split(",")

                If strResVal(0) = "True" Then
                    strResVal(0) = "DELETED"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("DDEL", "'" + objErrHandle.GetErrorDesc("DSCCD") + "'")
                ElseIf (strResVal(0) = "Record already in use. Cannot be deleted") Then
                    strResVal(0) = "AEXISTS"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("MSG098")
                Else
                    strResVal(0) = "ERROR"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("MSG099")
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.Items", "DeleteDiscCodeDetails", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strResVal
        End Function
        'sparepartpopup implementation...
        Public Function SparePartPopup(ByVal q As String, ByVal mustHaveQuantity As String, ByVal isStockItem As String, ByVal isNotStockItem As String, ByVal loc As String, ByVal supp As String, ByVal nonStock As Boolean, ByVal accurateSearch As String) As List(Of ItemsBO)
            Dim dsSparePart As New DataSet
            Dim dtSparePart As DataTable

            Dim sparePartSearchResult As New List(Of ItemsBO)()
            Try
                dsSparePart = objItemsDO.SparePart_Popup(q, mustHaveQuantity, isStockItem, isNotStockItem, loc, supp, nonStock, accurateSearch)
                If dsSparePart.Tables.Count > 0 Then
                    dtSparePart = dsSparePart.Tables(0)
                End If

                If (nonStock) Then
                    If q <> String.Empty Then
                        For Each dtrow As DataRow In dtSparePart.Rows
                            Dim csr As New ItemsBO()
                            csr.ID_MAKE = dtrow("ID_MAKE").ToString
                            csr.ID_ITEM = dtrow("ID_ITEM").ToString
                            csr.ITEM_DESC = dtrow("ITEM_DESC").ToString

                            csr.ITEM_PRICE = dtrow("ITEM_PRICE").ToString
                            csr.SUPP_CURRENTNO = dtrow("SUPP_CURRENTNO").ToString
                            sparePartSearchResult.Add(csr)
                        Next
                    End If

                Else
                    If q <> String.Empty Then
                        For Each dtrow As DataRow In dtSparePart.Rows
                            Dim csr As New ItemsBO()
                            csr.ID_MAKE = dtrow("ID_MAKE").ToString
                            csr.ID_ITEM = dtrow("ID_ITEM").ToString
                            csr.ITEM_DESC = dtrow("ITEM_DESC").ToString
                            csr.ITEM_AVAIL_QTY = dtrow("ITEM_AVAIL_QTY").ToString
                            csr.LOCATION = dtrow("LOCATION").ToString
                            csr.ID_WH_ITEM = dtrow("ID_WH_ITEM").ToString
                            csr.LAST_COST_PRICE = dtrow("LAST_COST_PRICE").ToString
                            csr.ITEM_PRICE = dtrow("ITEM_PRICE").ToString
                            csr.SUPP_CURRENTNO = dtrow("SUPP_CURRENTNO").ToString
                            csr.ITEM_CATG_DESC = dtrow("CATG_DESC").ToString
                            sparePartSearchResult.Add(csr)
                        Next
                    End If
                End If


            Catch ex As Exception
                Throw ex
            End Try
            Return sparePartSearchResult
        End Function


    End Class
End Namespace
