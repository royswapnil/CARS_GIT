Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Imports System.Resources
Imports System.Reflection
Imports CARS.CoreLibrary.CARS
Imports System.Web
Imports Encryption
Imports System.Configuration
Imports System
Imports MSGCOMMON
Imports System.Web.Security
Imports System.Data.Common
Imports System.Math
Imports System.Globalization
Imports CARS.CoreLibrary.CARS.Utilities
Imports System.Windows.Forms
Imports System.Web.UI
Imports System.Xml

Namespace CARS.Services.WOJobDetails
    Public Class WOJobDetails
        Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
        Shared objWOJBO As New WOJobDetailBO
        Shared objWOJDO As New CARS.WOJobDetailDO.WOJobDetailDO
        Shared objCommonUtil As New CARS.Utilities.CommonUtility
        Shared objCustomerDO As New CustomerDO
        Shared objConfigWODO As New CARS.ConfigWorkOrder.ConfigWorkOrderDO
        Shared objWOHBO As New WOHeaderBO
        Shared objWOHDO As New CARS.WOHeader.WOHeaderDO
        Shared objInvDetDO As New CARS.InvDetailDO.InvDetailDO

        Public Function Load_Category(objWOJBO) As List(Of WOJobDetailBO)
            Dim details As New List(Of WOJobDetailBO)()
            Dim dsWOJDetails As New DataSet
            Dim dtWOJDetails As New DataTable
            Try
                dsWOJDetails = objWOJDO.Load_ConfigDetails(objWOJBO)
                HttpContext.Current.Session("WOJConfigDetails") = dsWOJDetails
                If dsWOJDetails.Tables.Count > 0 Then
                    'Category Load
                    If dsWOJDetails.Tables(3).Rows.Count > 0 Then
                        dtWOJDetails = dsWOJDetails.Tables(3)
                        For Each dtrow As DataRow In dtWOJDetails.Rows
                            Dim wojDet As New WOJobDetailBO()
                            wojDet.Category_Id_Settings = dtrow("Id_Settings")
                            wojDet.Category_Description = dtrow("Description")
                            details.Add(wojDet)
                        Next
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "Load_ConfigDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function Load_PriceCode() As List(Of WOJobDetailBO)
            Dim details As New List(Of WOJobDetailBO)()
            Dim dsWOJDetails As New DataSet
            Dim dtWOJDetails As New DataTable
            Try
                dsWOJDetails = HttpContext.Current.Session("WOJConfigDetails")
                'If (dsWOJDetails Is Nothing) Then
                '    dsWOJDetails = objWOJDO.Load_ConfigDetails(objWOJBO)
                'End If

                If dsWOJDetails.Tables.Count > 0 Then
                    'PriceCode Load
                    If dsWOJDetails.Tables(4).Rows.Count > 0 Then
                        dtWOJDetails = dsWOJDetails.Tables(4)
                        For Each dtrow As DataRow In dtWOJDetails.Rows
                            Dim wojDet As New WOJobDetailBO()
                            wojDet.Price_Code_Id_Settings = dtrow("Id_Settings")
                            wojDet.Price_Code_Description = dtrow("Description")
                            details.Add(wojDet)
                        Next
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "Load_PriceCode", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function Load_RepairCode() As List(Of WOJobDetailBO)
            Dim details As New List(Of WOJobDetailBO)()
            Dim dsWOJDetails As New DataSet
            Dim dtWOJDetails As New DataTable
            Try
                dsWOJDetails = HttpContext.Current.Session("WOJConfigDetails")
                If dsWOJDetails.Tables.Count > 0 Then
                    'RepairCode Load
                    If dsWOJDetails.Tables(1).Rows.Count > 0 Then
                        dtWOJDetails = dsWOJDetails.Tables(1)
                        For Each dtrow As DataRow In dtWOJDetails.Rows
                            Dim wojDet As New WOJobDetailBO()
                            wojDet.Id_Rep_Code = dtrow("Id_Rep_Code")
                            wojDet.Rp_RepCode_Des = dtrow("Rp_RepCode_Des")
                            details.Add(wojDet)
                        Next
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "Load_RepairCode", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function Load_WorkCode() As List(Of WOJobDetailBO)
            Dim details As New List(Of WOJobDetailBO)()
            Dim dsWOJDetails As New DataSet
            Dim dtWOJDetails As New DataTable
            Try
                dsWOJDetails = HttpContext.Current.Session("WOJConfigDetails")
                If dsWOJDetails.Tables.Count > 0 Then
                    'WorkCode Load
                    If dsWOJDetails.Tables(7).Rows.Count > 0 Then
                        dtWOJDetails = dsWOJDetails.Tables(7)
                        For Each dtrow As DataRow In dtWOJDetails.Rows
                            Dim wojDet As New WOJobDetailBO()
                            wojDet.Work_Code_Id_Settings = dtrow("Id_Settings")
                            wojDet.Work_Code_Description = dtrow("Description")
                            details.Add(wojDet)
                        Next
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "Load_WorkCode", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function Load_MechanicCompetency() As List(Of WOJobDetailBO)
            Dim details As New List(Of WOJobDetailBO)()
            Dim dsWOJDetails As New DataSet
            Dim dtWOJDetails As New DataTable
            Try
                dsWOJDetails = HttpContext.Current.Session("WOJConfigDetails")
                If dsWOJDetails.Tables.Count > 0 Then
                    'WorkCode Load
                    If dsWOJDetails.Tables(9).Rows.Count > 0 Then
                        dtWOJDetails = dsWOJDetails.Tables(9)
                        For Each dtrow As DataRow In dtWOJDetails.Rows
                            Dim wojDet As New WOJobDetailBO()
                            wojDet.Mech_Id_Compt = dtrow("Id_Compt")
                            wojDet.Mech_Compt_Description = dtrow("Compt_Description")
                            details.Add(wojDet)
                        Next
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "Load_MechanicCompetency", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function Load_StationType() As List(Of WOJobDetailBO)
            Dim details As New List(Of WOJobDetailBO)()
            Dim dsWOJDetails As New DataSet
            Dim dtWOJDetails As New DataTable
            Try
                dsWOJDetails = HttpContext.Current.Session("WOJConfigDetails")
                If dsWOJDetails.Tables.Count > 0 Then
                    'WorkCode Load
                    If dsWOJDetails.Tables(11).Rows.Count > 0 Then
                        dtWOJDetails = dsWOJDetails.Tables(11)
                        For Each dtrow As DataRow In dtWOJDetails.Rows
                            Dim wojDet As New WOJobDetailBO()
                            wojDet.Id_StationType = dtrow("Id_Stype")
                            wojDet.Station_Type_Description = dtrow("Type_Station")
                            details.Add(wojDet)
                        Next
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "Load_StationType", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function getRepairPkgCodes(ByVal repPkgDesc As String, ByVal category As String) As List(Of String)
            Dim retRepPkgCodes As New List(Of String)()
            Dim dsRepPkgCodes As New DataSet
            Dim dtRepPkgCodes As New DataTable
            Dim dvRepPkgCodes As New DataView
            Try
                objWOJBO.Id_Rep_Code = repPkgDesc

                dsRepPkgCodes = HttpContext.Current.Session("WOJConfigDetails")
                dtRepPkgCodes = dsRepPkgCodes.Tables(0)
                dvRepPkgCodes = dtRepPkgCodes.DefaultView
                dvRepPkgCodes.RowFilter = "RP_Desc like '%" + repPkgDesc.Trim + "%'"

                If (category > 0) Then
                    dvRepPkgCodes.RowFilter = "ID_CATG_RP like '%" + category + "%'"
                End If

                dtRepPkgCodes = dvRepPkgCodes.ToTable

                If repPkgDesc <> String.Empty Then
                    For Each dtrow As DataRow In dtRepPkgCodes.Rows
                        retRepPkgCodes.Add(String.Format("{0}-{1}-{2}", dtrow("ID_RPKG_SEQ"), dtrow("RP_DESC"), dtrow("ID_RP_CODE")))

                    Next
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "getRepairPkgCodes", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return retRepPkgCodes
        End Function
        Public Function Fetch_Spares(objWOJBO) As List(Of WOJobDetailBO)
            Dim details As New List(Of WOJobDetailBO)()
            Dim flgStckItem As String = ""
            Dim dsWOJSpares As New DataSet
            Dim dtWOJSpares As New DataTable
            Dim dsFetchStckItem As New DataSet
            Dim dsCust As DataSet = Nothing
            Dim dvWOJSpares As New DataView
            Dim SPMake As String
            Try
                SPMake = HttpContext.Current.Session("SPMake")
                dsWOJSpares = objWOJDO.Fetch_Spares(objWOJBO)
                HttpContext.Current.Session("WOJSparePart") = dsWOJSpares
                If dsWOJSpares.Tables.Count > 0 Then
                    'Spares Load
                    If dsWOJSpares.Tables(0).Rows.Count > 0 Then
                        dtWOJSpares = dsWOJSpares.Tables(0)
                        If Not SPMake Is Nothing Then
                            dvWOJSpares = dtWOJSpares.DefaultView
                            dvWOJSpares.RowFilter = "ID_MAKE = '" + SPMake + "'"
                            dtWOJSpares = dvWOJSpares.ToTable
                            HttpContext.Current.Session("SPMake") = Nothing
                        End If
                        For Each dtrow As DataRow In dtWOJSpares.Rows
                            Dim wojDet As New WOJobDetailBO()
                            wojDet.Id_Item = dtrow("Id_Item")
                            wojDet.Id_Sp_Replace = IIf(IsDBNull(dtrow("Id_Replace")) = True, "", dtrow("Id_Replace"))
                            wojDet.Item_Sp_Desc = IIf(IsDBNull(dtrow("Item_Desc")) = True, "", dtrow("Item_Desc"))
                            wojDet.Id_Item_Catg = IIf(IsDBNull(dtrow("Id_Item_Catg")) = True, "", dtrow("Id_Item_Catg"))
                            wojDet.Id_Make = IIf(IsDBNull(dtrow("SUPP_CURRENTNO")) = True, "", dtrow("SUPP_CURRENTNO"))
                            wojDet.Category_Desc = IIf(IsDBNull(dtrow("Cat_Desc")) = True, "", dtrow("Cat_Desc"))
                            wojDet.Sp_Make = IIf(IsDBNull(dtrow("Make")) = True, "", dtrow("Make"))
                            wojDet.Item_Avail_Qty = IIf(IsDBNull(dtrow("Item_Avail_Qty")) = True, 0, dtrow("Item_Avail_Qty"))   'dtrow("Item_Avail_Qty")
                            wojDet.Flg_Allow_Bckord = IIf(IsDBNull(dtrow("Flg_Allow_Bckord")) = True, 0, dtrow("Flg_Allow_Bckord"))
                            wojDet.Jobi_Dis_Per = IIf(IsDBNull(dtrow("Jobi_Dis_Per")) = True, "0", dtrow("Jobi_Dis_Per"))
                            wojDet.Jobi_Vat_Per = IIf(IsDBNull(dtrow("Jobi_Vat_Per")) = True, "0", dtrow("Jobi_Vat_Per"))
                            wojDet.Jobi_Vat_Seq = IIf(IsDBNull(dtrow("Jobi_Vat_Seq")) = True, 0, dtrow("Jobi_Vat_Seq"))
                            wojDet.Sp_Item_Price = IIf(IsDBNull(dtrow("Item_Price")) = True, "", dtrow("Item_Price"))
                            wojDet.Jobi_Dis_Seq = IIf(IsDBNull(dtrow("Jobi_Dis_Seq")) = True, 0, dtrow("Jobi_Dis_Seq"))
                            wojDet.Jobi_Deliver_Qty = IIf(IsDBNull(dtrow("Jobi_Deliver_Qty")) = True, "0", dtrow("Jobi_Deliver_Qty"))
                            wojDet.Jobi_Bo_Qty = IIf(IsDBNull(dtrow("Jobi_Bo_Qty")) = True, "0", dtrow("Jobi_Bo_Qty"))
                            wojDet.Cost_Price = IIf(IsDBNull(dtrow("Cost_Price")) = True, "0", dtrow("Cost_Price"))
                            wojDet.Sp_Disc_Code_Sell = IIf(IsDBNull(dtrow("Disc_Code_Sell")) = True, "", dtrow("Disc_Code_Sell"))
                            wojDet.Sp_Disc_Code_Buy = IIf(IsDBNull(dtrow("Disc_Code_Buy")) = True, "", dtrow("Disc_Code_Buy"))
                            wojDet.Sp_Location = IIf(IsDBNull(dtrow("Location")) = True, "", dtrow("Location"))
                            wojDet.Sp_Item_Description = IIf(IsDBNull(dtrow("IDesc")) = True, "", dtrow("IDesc"))
                            wojDet.Sp_I_Item = IIf(IsDBNull(dtrow("I_Item")) = True, "", dtrow("I_Item"))
                            wojDet.Id_Wh_Item = IIf(IsDBNull(dtrow("Id_Wh_Item")) = True, 0, dtrow("Id_Wh_Item"))
                            wojDet.Env_Id_Item = IIf(IsDBNull(dtrow("Env_Id_Item")) = True, "", dtrow("Env_Id_Item"))
                            wojDet.Env_Id_Make = IIf(IsDBNull(dtrow("Env_Id_Make")) = True, "", dtrow("Env_Id_Make"))
                            wojDet.Env_Id_Warehouse = dtrow("Env_Id_Warehouse")
                            wojDet.Flg_Efd = dtrow("Flg_Efd")
                            'If wojDet.Item_Avail_Qty <> "0" Then
                            '    wojDet.Jobi_Order_Qty = "1"  'this is used for popup spare
                            'Else
                            '    wojDet.Jobi_Order_Qty = "0"
                            'End If

                            dsCust = objWOJDO.Cust_CostPriceDetails(objWOJBO.Id_Customer)
                            If dsCust.Tables(0).Rows.Count > 0 Then
                                If dsCust.Tables(0).Rows(0)("FLG_CPRICE") = True Then
                                    wojDet.Sp_Item_Price = dtrow("COST_PRICE") + (dtrow("COST_PRICE") * CDbl(dsCust.Tables(0).Rows(0)("CUST_COSTPRICE")) / 100)
                                Else
                                    wojDet.Sp_Item_Price = dtrow("Item_Price")
                                End If
                            End If

                            'To check if the replacement sp does not have qty and original sp has qty
                            If (wojDet.Id_Sp_Replace = "") Then
                                wojDet.Id_Old_Sp_Replace = ReplaceOldSpares(wojDet.Id_Item, wojDet.Id_Make, "OLD")
                            End If
                            wojDet.SpareDiscount = IIf(IsDBNull(dtrow("Discount")) = True, 0, dtrow("Discount"))

                            details.Add(wojDet)
                        Next
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "Fetch_Spares", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function Fetch_SparesList(objWOJBO) As List(Of WOJobDetailBO)
            Dim details As New List(Of WOJobDetailBO)()
            Dim flgStckItem As String = ""
            Dim dsWOJSpares As New DataSet
            Dim dtWOJSpares As New DataTable
            Dim dsFetchStckItem As New DataSet
            Dim dsCust As DataSet = Nothing
            Dim dvWOJSpares As New DataView
            Dim dsGMHP As New DataSet
            Dim spVat As Decimal = 0.0
            Try
                dsWOJSpares = objWOJDO.Fetch_SparesList(objWOJBO)
                If dsWOJSpares.Tables.Count > 0 Then
                    'Spares Load
                    If dsWOJSpares.Tables(0).Rows.Count > 0 Then
                        dtWOJSpares = dsWOJSpares.Tables(0)

                        For Each dtrow As DataRow In dtWOJSpares.Rows
                            Dim wojDet As New WOJobDetailBO()
                            wojDet.Id_Item = dtrow("Id_Item")
                            wojDet.Id_Sp_Replace = IIf(IsDBNull(dtrow("Id_Replace")) = True, "", dtrow("Id_Replace"))
                            wojDet.Item_Sp_Desc = IIf(IsDBNull(dtrow("Item_Desc")) = True, "", dtrow("Item_Desc"))
                            wojDet.Id_Item_Catg = IIf(IsDBNull(dtrow("Id_Item_Catg")) = True, "", dtrow("Id_Item_Catg"))
                            wojDet.Id_Make = IIf(IsDBNull(dtrow("SUPP_CURRENTNO")) = True, "", dtrow("SUPP_CURRENTNO"))
                            wojDet.Category_Desc = IIf(IsDBNull(dtrow("Cat_Desc")) = True, "", dtrow("Cat_Desc"))
                            wojDet.Sp_Make = IIf(IsDBNull(dtrow("Make")) = True, "", dtrow("Make"))
                            wojDet.Sp_StockQty = IIf(IsDBNull(dtrow("Item_Avail_Qty")) = True, "", dtrow("Item_Avail_Qty"))
                            wojDet.Flg_Allow_Bckord = IIf(IsDBNull(dtrow("Flg_Allow_Bckord")) = True, 0, dtrow("Flg_Allow_Bckord"))
                            wojDet.Jobi_Dis_Per = IIf(IsDBNull(dtrow("Jobi_Dis_Per")) = True, "0", dtrow("Jobi_Dis_Per"))
                            wojDet.Jobi_Vat_Per = IIf(IsDBNull(dtrow("Jobi_Vat_Per")) = True, "0", dtrow("Jobi_Vat_Per"))
                            wojDet.Jobi_Vat_Seq = IIf(IsDBNull(dtrow("Jobi_Vat_Seq")) = True, 0, dtrow("Jobi_Vat_Seq"))
                            wojDet.Sp_Item_Price = IIf(IsDBNull(dtrow("Item_Price")) = True, "", dtrow("Item_Price"))
                            wojDet.Jobi_Dis_Seq = IIf(IsDBNull(dtrow("Jobi_Dis_Seq")) = True, 0, dtrow("Jobi_Dis_Seq"))
                            wojDet.Jobi_Deliver_Qty = IIf(IsDBNull(dtrow("Jobi_Deliver_Qty")) = True, "0", dtrow("Jobi_Deliver_Qty"))
                            wojDet.Jobi_Bo_Qty = IIf(IsDBNull(dtrow("Jobi_Bo_Qty")) = True, "0", dtrow("Jobi_Bo_Qty"))
                            wojDet.Cost_Price = IIf(IsDBNull(dtrow("Cost_Price")) = True, "0", dtrow("Cost_Price"))
                            wojDet.Sp_Disc_Code_Sell = IIf(IsDBNull(dtrow("Disc_Code_Sell")) = True, "", dtrow("Disc_Code_Sell"))
                            wojDet.Sp_Disc_Code_Buy = IIf(IsDBNull(dtrow("Disc_Code_Buy")) = True, "", dtrow("Disc_Code_Buy"))
                            wojDet.Sp_Location = IIf(IsDBNull(dtrow("Location")) = True, "", dtrow("Location"))
                            wojDet.Sp_Item_Description = IIf(IsDBNull(dtrow("IDesc")) = True, "", dtrow("IDesc"))
                            wojDet.Sp_I_Item = IIf(IsDBNull(dtrow("I_Item")) = True, "", dtrow("I_Item"))
                            wojDet.Id_Wh_Item = IIf(IsDBNull(dtrow("Id_Wh_Item")) = True, 0, dtrow("Id_Wh_Item"))
                            wojDet.Env_Id_Item = IIf(IsDBNull(dtrow("Env_Id_Item")) = True, "", dtrow("Env_Id_Item"))
                            wojDet.Env_Id_Make = IIf(IsDBNull(dtrow("Env_Id_Make")) = True, "", dtrow("Env_Id_Make"))
                            wojDet.Env_Id_Warehouse = dtrow("Env_Id_Warehouse")
                            wojDet.Flg_Efd = dtrow("Flg_Efd")
                            Dim ordQty As Decimal = 1.0
                            If objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), wojDet.Sp_StockQty) <> 0.0 Then

                                wojDet.Jobi_Order_Qty = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), ordQty)  'this is used for popup spare
                            Else
                                wojDet.Jobi_Order_Qty = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), ordQty)
                            End If

                            dsCust = objWOJDO.Cust_CostPriceDetails(objWOJBO.Id_Customer)
                            If dsCust.Tables(0).Rows.Count > 0 Then
                                If dsCust.Tables(0).Rows(0)("FLG_CPRICE") = True Then
                                    wojDet.Sp_Item_Price = dtrow("COST_PRICE") + (dtrow("COST_PRICE") * CDbl(dsCust.Tables(0).Rows(0)("CUST_COSTPRICE")) / 100)
                                Else
                                    wojDet.Sp_Item_Price = dtrow("Item_Price")
                                End If
                            End If

                            'To check if the replacement sp does not have qty and original sp has qty
                            If (wojDet.Id_Sp_Replace = "") Then
                                wojDet.Id_Old_Sp_Replace = ReplaceOldSpares(wojDet.Id_Item, wojDet.Id_Make, "OLD")
                            End If

                            objWOJBO.Id_Customer = HttpContext.Current.Session("IdCustomer")
                            objWOJBO.WO_Id_Veh = HttpContext.Current.Session("Veh_Seq_No")
                            objWOJBO.Id_Gm_Vat = HttpContext.Current.Session("ID_GMVAT")
                            objWOJBO.Id_Hp_Vat = HttpContext.Current.Session("ID_HPVAT")
                            objWOJBO.Created_By = HttpContext.Current.Session("UserID")
                            objWOJBO.Id_Item = wojDet.Id_Item
                            objWOJBO.Id_Make = wojDet.Id_Make
                            LoadGMHPVat(objWOJBO)
                            dsGMHP = HttpContext.Current.Session("LoadGMHP_VAT")
                            If dsGMHP.Tables(2).Rows.Count > 0 Then
                                spVat = IIf(IsDBNull(dsGMHP.Tables(2).Rows(0)("SP_VAT")) = True, "0", dsGMHP.Tables(2).Rows(0)("SP_VAT").ToString())
                            Else
                                spVat = "0"
                            End If
                            Dim prInclVat As Decimal = (wojDet.Sp_Item_Price * spVat / 100) + wojDet.Sp_Item_Price
                            wojDet.PriceInclVat = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), prInclVat)

                            details.Add(wojDet)
                        Next
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "Fetch_Spares", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function Load_WorkOrderDetails(objWOJBO) As List(Of WOJobDetailBO)
            Dim details As New List(Of WOJobDetailBO)()
            Dim dsWODetails As New DataSet
            Dim dtWODetails As New DataTable
            Dim fixedPriceAmt As Decimal = 0
            Try
                dsWODetails = objWOJDO.Load_WorkOrderDetails(objWOJBO)
                HttpContext.Current.Session("WODetails") = dsWODetails
                HttpContext.Current.Session("WOSpareDetails") = dsWODetails.Tables(1)
                If dsWODetails.Tables.Count > 0 Then
                    'Work Order Load
                    If dsWODetails.Tables(0).Rows.Count > 0 Then
                        dtWODetails = dsWODetails.Tables(0)
                        For Each dtrow As DataRow In dtWODetails.Rows
                            Dim wojDet As New WOJobDetailBO()
                            wojDet.Id_WO_NO = dtrow("Id_WO_NO")
                            wojDet.Id_WO_Prefix = dtrow("Id_WO_Prefix")
                            wojDet.Id_Job = dtrow("Id_Job")
                            wojDet.Id_Wodet_Seq = dtrow("Id_Wodet_Seq")
                            wojDet.Dt_Planned = IIf(IsDBNull(dtrow("Planned Date")) = True, "", dtrow("Planned Date"))
                            wojDet.WO_Std_Time = dtrow("WO_Std_Time")
                            HttpContext.Current.Session("WO_Std_Time") = dtrow("WO_Std_Time")
                            wojDet.WO_Hourley_Price = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("WO_Hourley_Price")) = True, 0D, dtrow("WO_Hourley_Price")))
                            wojDet.Cost_Price = dtrow("Cost_Price")
                            wojDet.Id_Rpg_Catg_WO = dtrow("Id_Rpg_Catg_WO")
                            wojDet.Id_Rpg_Code_WO = dtrow("Id_Rpg_Code_WO")
                            wojDet.Category_Description = dtrow("Category Description")
                            wojDet.Rp_Desc = dtrow("Rp_Desc")
                            wojDet.Id_Rep_Code_WO = dtrow("Id_Rep_Code_WO")
                            wojDet.Id_Work_Code_WO = dtrow("Id_Work_Code_WO")

                            fixedPriceAmt = IIf(IsDBNull(dtrow("WO_Fixed_Price")) = True, 0D, dtrow("WO_Fixed_Price"))
                            wojDet.WO_Incl_Vat = IIf(IsDBNull(dtrow("WO_Incl_Vat")) = True, False, dtrow("WO_Incl_Vat"))
                            If (wojDet.WO_Incl_Vat = True) Then
                                fixedPriceAmt = fixedPriceAmt + IIf(IsDBNull(dtrow("WO_Tot_Vat_Amt")) = True, 0D, dtrow("WO_Tot_Vat_Amt"))
                            End If
                            wojDet.WO_Fixed_Price = fixedPriceAmt
                            wojDet.WO_Fixed_Price = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), wojDet.WO_Fixed_Price)

                            wojDet.Id_Jobpcd_WO = dtrow("Id_Jobpcd_WO")
                            wojDet.WO_Gm_Per = dtrow("WO_Gm_Per")
                            wojDet.WO_Gm_Vatper = dtrow("WO_Gm_Vatper")
                            wojDet.WO_Lbr_Vatper = dtrow("WO_Lbr_Vatper")
                            wojDet.WO_Clk_Time = dtrow("WO_Clk_Time")
                            wojDet.WO_Clk_Time = FetchClockTime(wojDet.Id_WO_NO, wojDet.Id_WO_Prefix, wojDet.Id_Job)

                            'wojDet.WO_Chrg_Time = dtrow("WO_Chrg_Time")
                            wojDet.WO_Chrg_Time = IIf(IsDBNull(dtrow("WO_Chrg_Time")) = True, "", Convert.ToDecimal(dtrow("WO_Chrg_Time").ToString().Replace(".", NumberFormatInfo.CurrentInfo.NumberDecimalSeparator)))
                            wojDet.Flg_Chrg_Std_Time = dtrow("Flg_Chrg_Std_Time")
                            wojDet.Flg_Stat_Req = IIf(IsDBNull(dtrow("Flg_Stat_Req")) = True, False, dtrow("Flg_Stat_Req"))
                            wojDet.WO_Job_Txt = dtrow("WO_Job_Txt")
                            wojDet.Job_Dis = dtrow("WO_DISCOUNT")
                            wojDet.WO_Own_Risk_Amt = IIf(IsDBNull(dtrow("WO_Own_Risk_Amt")) = True, 0D, dtrow("WO_Own_Risk_Amt"))
                            Dim totlabamt As String = IIf(IsDBNull(dtrow("WO_Tot_Lab_Amt").ToString()) = True, 0, dtrow("WO_Tot_Lab_Amt").ToString())
                            wojDet.WO_Tot_Lab_Amt = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), totlabamt)
                            wojDet.WO_Tot_Spare_Amt = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("WO_Tot_Spare_Amt")) = True, 0D, dtrow("WO_Tot_Spare_Amt")))
                            wojDet.WO_Tot_Gm_Amt = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("WO_Tot_Gm_Amt")) = True, 0D, dtrow("WO_Tot_Gm_Amt")))
                            wojDet.WO_Tot_Vat_Amt = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("WO_Tot_Vat_Amt")) = True, 0D, dtrow("WO_Tot_Vat_Amt")))
                            wojDet.WO_Tot_Disc_Amt = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("WO_Tot_Disc_Amt")) = True, 0D, dtrow("WO_Tot_Disc_Amt")))
                            wojDet.Job_Status = dtrow("Job_Status")
                            wojDet.WO_Own_Risk_Custname = IIf(IsDBNull(dtrow("WO_Own_Risk_Custname")) = True, "", dtrow("WO_Own_Risk_Custname"))
                            wojDet.WO_Own_Cr_Custname = IIf(IsDBNull(dtrow("WO_Own_Cr_Custname")) = True, "", dtrow("WO_Own_Cr_Custname"))
                            wojDet.WO_Own_Risk_Cust = IIf(IsDBNull(dtrow("WO_Own_Risk_Cust")) = True, "", dtrow("WO_Own_Risk_Cust"))
                            wojDet.WO_Own_Cr_Cust = IIf(IsDBNull(dtrow("WO_Own_Cr_Cust")) = True, "", dtrow("WO_Own_Cr_Cust"))
                            wojDet.WO_Own_Pay_Vat = IIf(IsDBNull(dtrow("WO_Own_Pay_Vat")) = True, False, dtrow("WO_Own_Pay_Vat"))
                            wojDet.Id_Mech_Comp = IIf(IsDBNull(dtrow("Id_Mech_Comp")) = True, "0", dtrow("Id_Mech_Comp"))
                            wojDet.Id_Stype_WO = IIf(IsDBNull(dtrow("Id_Stype_WO")) = True, "0", dtrow("Id_Stype_WO"))
                            wojDet.WO_Discount = IIf(IsDBNull(dtrow("WO_Discount")) = True, 0D, dtrow("WO_Discount"))
                            wojDet.Id_Subrep_Code_WO = IIf(IsDBNull(dtrow("Id_Subrep_Code_WO")) = True, 0, dtrow("Id_Subrep_Code_WO"))
                            wojDet.Ownriskvatamt = IIf(IsDBNull(dtrow("Ownriskvatamt")) = True, 0D, dtrow("Ownriskvatamt"))
                            wojDet.Salesman = dtrow("Salesman")
                            wojDet.Flg_Vat_Free = IIf(IsDBNull(dtrow("Flg_Vat_Free")) = True, False, dtrow("Flg_Vat_Free"))
                            wojDet.WO_Tot_Disc_Amt_Fp = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("WO_Tot_Disc_Amt_Fp")) = True, 0D, dtrow("WO_Tot_Disc_Amt_Fp")))
                            wojDet.WO_Tot_Gm_Amt_Fp = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("WO_Tot_Gm_Amt_Fp")) = True, 0D, dtrow("WO_Tot_Gm_Amt_Fp")))
                            wojDet.WO_Tot_Lab_Amt_Fp = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("WO_Tot_Lab_Amt_Fp")) = True, 0D, dtrow("WO_Tot_Lab_Amt_Fp")))
                            wojDet.WO_Tot_Spare_Amt_Fp = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("WO_Tot_Spare_Amt_Fp")) = True, 0D, dtrow("WO_Tot_Spare_Amt_Fp")))
                            wojDet.WO_Tot_Vat_Amt_Fp = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("WO_Tot_Vat_Amt_Fp")) = True, 0D, dtrow("WO_Tot_Vat_Amt_Fp")))
                            wojDet.Flg_Val_Stdtime = dtrow("Flg_Val_Stdtime")
                            wojDet.Flg_Val_Mileage = dtrow("Flg_Val_Mileage")
                            wojDet.Flg_Saveupddp = dtrow("Flg_Saveupddp")
                            wojDet.Flg_Edtchgtime = dtrow("Flg_Edtchgtime")
                            wojDet.WO_Int_Note = dtrow("WO_Int_Note")
                            wojDet.Flg_Disp_Int_Note = dtrow("Flg_Disp_Int_Note")

                            If dsWODetails.Tables(2).Rows.Count > 0 Then
                                wojDet.Id_Job_Deb = dsWODetails.Tables(2).Rows(0)("ID_JOB_DEB")
                                wojDet.Job_Deb_Name = dsWODetails.Tables(2).Rows(0)("Job_Deb_Name")
                                HttpContext.Current.Session("WODebDetails") = dsWODetails.Tables(2)
                            End If
                            details.Add(wojDet)
                        Next
                    End If

                    If dsWODetails.Tables(4).Rows.Count > 0 Then
                        HttpContext.Current.Session("WOMechanics") = dsWODetails.Tables(4)
                    End If

                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "Load_WorkOrderDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function Fetch_SpareParts(objWOJBO) As List(Of WOJobDetailBO)
            Dim details As New List(Of WOJobDetailBO)()
            Dim dsWOJSpareParts As New DataSet
            Dim dtWOJSpareParts As New DataTable
            Try
                'dsWOJSpares = objWOJDO.Fetch_Spares(objWOJBO)
                dsWOJSpareParts = HttpContext.Current.Session("WODetails")
                If Not (dsWOJSpareParts Is Nothing) Then
                    If dsWOJSpareParts.Tables.Count > 0 Then
                        'Spare Parts for particular work order
                        If dsWOJSpareParts.Tables(1).Rows.Count > 0 Then
                            dtWOJSpareParts = dsWOJSpareParts.Tables(1)
                            For Each dtrow As DataRow In dtWOJSpareParts.Rows
                                Dim wojDet As New WOJobDetailBO()
                                wojDet.Id_Wodet_Seq = IIf(IsDBNull(dtrow("Id_Wodet_Seq_Job")) = True, 0, dtrow("Id_Wodet_Seq_Job"))
                                wojDet.Id_WOItem_Seq = IIf(IsDBNull(dtrow("Id_WOItem_Seq")) = True, 0, dtrow("Id_WOItem_Seq"))
                                wojDet.Id_Make = IIf(IsDBNull(dtrow("Id_Make_Job_Id")) = True, "", dtrow("Id_Make_Job_Id"))
                                wojDet.Sp_Slno = dtrow("SLNO")
                                wojDet.Sp_Make = IIf(IsDBNull(dtrow("Make")) = True, "", dtrow("Make"))
                                wojDet.Id_Item_Catg = IIf(IsDBNull(dtrow("Id_Item_Catg_Job")) = True, "", dtrow("Id_Item_Catg_Job"))
                                wojDet.Id_Item_Catg_Job_Id = IIf(IsDBNull(dtrow("Id_Item_Catg_Job_Id")) = True, "0", dtrow("Id_Item_Catg_Job_Id"))
                                wojDet.Id_Item = IIf(IsDBNull(dtrow("Id_Item_Job")) = True, "", dtrow("Id_Item_Job"))
                                wojDet.Item_Sp_Desc = IIf(IsDBNull(dtrow("Item_Desc")) = True, "", dtrow("Item_Desc"))
                                wojDet.Jobi_Order_Qty = IIf(IsDBNull(dtrow("Jobi_Order_Qty")) = True, "0", dtrow("Jobi_Order_Qty"))
                                wojDet.Jobi_Deliver_Qty = IIf(IsDBNull(dtrow("Jobi_Deliver_Qty")) = True, "0", dtrow("Jobi_Deliver_Qty"))
                                wojDet.Jobi_Bo_Qty = IIf(IsDBNull(dtrow("Jobi_Bo_Qty")) = True, "0", dtrow("Jobi_Bo_Qty"))
                                wojDet.Jobi_Sell_Price = IIf(IsDBNull(dtrow("Jobi_Sell_Price")) = True, "0", dtrow("Jobi_Sell_Price"))
                                wojDet.Jobi_Dis_Per = IIf(IsDBNull(dtrow("Jobi_Dis_Per")) = True, "0", dtrow("Jobi_Dis_Per"))
                                wojDet.Jobi_Vat_Per = IIf(IsDBNull(dtrow("Jobi_Vat_Per")) = True, "0", dtrow("Jobi_Vat_Per"))
                                wojDet.Sp_Item_Price = IIf(IsDBNull(dtrow("Total_Price")) = True, "0", dtrow("Total_Price"))
                                wojDet.Order_Line_Text = IIf(IsDBNull(dtrow("Order_Line_Text")) = True, "", dtrow("Order_Line_Text"))
                                wojDet.Td_Calc = dtrow("Td_Calc")
                                wojDet.Id_Customer = IIf(IsDBNull(dtrow("Id_Cust_WO")) = True, "", dtrow("Id_Cust_WO"))
                                wojDet.Text = IIf(IsDBNull(dtrow("Text")) = True, "", dtrow("Text"))
                                wojDet.Sp_Location = IIf(IsDBNull(dtrow("Location")) = True, "", dtrow("Location"))
                                wojDet.Id_Deb_Seq = IIf(IsDBNull(dtrow("Id_Dbt_Seq")) = True, "0", dtrow("Id_Dbt_Seq"))
                                wojDet.Pickinglist_Prev_Printed = IIf(IsDBNull(dtrow("PICKINGLIST_PREV_PRINTED")) = True, "0", dtrow("PICKINGLIST_PREV_PRINTED"))
                                wojDet.Deliverynote_Prev_Printed = IIf(IsDBNull(dtrow("DELIVERYNOTE_PREV_PRINTED")) = True, "0", dtrow("DELIVERYNOTE_PREV_PRINTED"))
                                wojDet.Prev_Picked = IIf(IsDBNull(dtrow("PREV_PICKED")) = True, "0", dtrow("PREV_PICKED"))
                                wojDet.Spare_Type = IIf(IsDBNull(dtrow("SPARE_TYPE")) = True, "ORD", dtrow("SPARE_TYPE"))
                                wojDet.Flg_Force_Vat = IIf(IsDBNull(dtrow("FLG_FORCE_VAT")) = True, "0", dtrow("FLG_FORCE_VAT"))
                                wojDet.Flg_Edit_Sp = IIf(IsDBNull(dtrow("FLG_EDIT_SP")) = True, "0", dtrow("FLG_EDIT_SP"))
                                wojDet.Export_Type = IIf(IsDBNull(dtrow("EXPORT_TYPE")) = True, "", dtrow("EXPORT_TYPE"))
                                wojDet.Cost_Price = IIf(IsDBNull(dtrow("JOBI_COST_PRICE")) = True, "0", dtrow("JOBI_COST_PRICE"))
                                wojDet.ToBe_Picked = IIf(IsDBNull(dtrow("TOBE_PICKED")) = True, "0", dtrow("TOBE_PICKED"))
                                details.Add(wojDet)
                            Next
                        End If
                    End If
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "Fetch_SpareParts", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function CalculateJobDet(ByVal objWOJBO As WOJobDetailBO) As List(Of WOJobDetailBO)
            Dim details As New List(Of WOJobDetailBO)()
            Dim dsWOJLoadGmHp As New DataSet
            Dim dtWOJLoadGmHp As New DataTable
            Dim wojDet As New WOJobDetailBO()
            Dim hpVat As Decimal = 0.0
            Dim gmVat As Decimal = 0.0
            Dim spVat As Decimal = 0.0
            Dim totalVat As Decimal = 0.0
            Dim dsWOJSpareParts As New DataSet
            Dim dtWOJSpareParts As New DataTable
            Dim discount As Decimal = 0.0

            'Dim sellingPrice As Decimal = 0.0
            Dim vatAmount As Decimal = 0.0
            Dim dbtPer As Decimal = 0.0
            Dim jobDisc As String
            Dim DiscountedGMAmt As Decimal = 0.0
            Dim DiscountedLBAmt As Decimal = 0.0
            Dim totalGmPrice As Decimal = 0.0
            Dim wo_hourly_price As String
            Dim garageMaterial As String
            Dim chargeTime As String
            Dim totalLabAmt As Decimal = 0.0
            Dim labourDiscount As Decimal = 0.0
            Dim garageDiscount As Decimal = 0.0
            Dim discAmount As Decimal = 0.0
            Dim totalAmt As Decimal = 0.0
            Dim totalSparePrice As Decimal = 0.0
            Dim dtWODebitors As New DataTable
            Dim hpVatPer As Decimal = 0.0
            Dim gmVatPer As Decimal = 0.0
            Dim dsWODebitors As New DataSet
            Try
                wo_hourly_price = IIf(objWOJBO.WO_Hourley_Price = "", "0", objWOJBO.WO_Hourley_Price)
                jobDisc = objWOJBO.Job_Dis
                garageMaterial = objWOJBO.GarageMat
                chargeTime = objWOJBO.ChrgTime

                If garageMaterial = "" Then
                    garageMaterial = 0
                End If
                If chargeTime = "" Then
                    chargeTime = 0
                End If
                hpVatPer = objWOJBO.HP_Vat
                gmVatPer = objWOJBO.GM_Vat

                totalGmPrice = (Math.Round(((Convert.ToDecimal(IIf(Convert.ToDouble(wo_hourly_price) = 0, 0D, Convert.ToDouble(wo_hourly_price))) * Convert.ToDecimal(IIf(chargeTime = "", 0D, Convert.ToDouble(chargeTime)))) * Convert.ToDecimal(IIf(garageMaterial = "", 0D, Convert.ToDouble(garageMaterial)))) / 100, 2))
                totalLabAmt = Math.Round(Convert.ToDecimal(IIf(Convert.ToDouble(wo_hourly_price) = 0, 0D, Convert.ToDouble(wo_hourly_price))) * Convert.ToDecimal(IIf(chargeTime = "", 0D, Convert.ToDouble(chargeTime))), 2)
                labourDiscount = Round((IIf(jobDisc = "", 0D, jobDisc) * totalLabAmt) / 100, 2)
                garageDiscount = Round((IIf(jobDisc = "", 0D, jobDisc) * totalGmPrice) / 100, 2)
                discAmount = labourDiscount + garageDiscount
                DiscountedGMAmt = totalGmPrice - Round((IIf(jobDisc = "", 0D, jobDisc) * totalGmPrice) / 100, 2)
                DiscountedLBAmt = totalLabAmt - Round((IIf(jobDisc = "", 0D, jobDisc) * totalLabAmt) / 100, 2)
                hpVat = Round(DiscountedLBAmt * hpVatPer / 100, 2)
                gmVat = Round(DiscountedGMAmt * gmVatPer / 100, 2)

                If Not (HttpContext.Current.Session("WOSpareDetails")) Is Nothing Then
                    dtWOJSpareParts = HttpContext.Current.Session("WOSpareDetails")
                End If
                If Not (HttpContext.Current.Session("WODetails")) Is Nothing Then
                    dsWODebitors = HttpContext.Current.Session("WODetails")
                End If

                'If its new job then debitor is from add_DebitorDetails else from load of wodetails
                If dsWODebitors.Tables.Count > 0 Then
                    If dsWODebitors.Tables(2).Rows.Count > 0 Then
                        dtWODebitors = dsWODebitors.Tables(2)
                        HttpContext.Current.Session("WODebDetails") = dtWODebitors
                    End If
                Else
                    dtWODebitors = HttpContext.Current.Session("WODebDetails")
                End If

                'dsWODebitors = HttpContext.Current.Session("WODetails")
                'Spare Parts for particular work order
                If Not (dtWOJSpareParts Is Nothing) Then
                    If dtWOJSpareParts.Rows.Count > 0 Then
                        If dtWODebitors.Rows.Count > 0 Then
                            For Each dtrowDeb As DataRow In dtWODebitors.Rows
                                dbtPer = dtrowDeb("DBT_PER") '100D 
                                For Each dtrow As DataRow In dtWOJSpareParts.Rows
                                    Dim dsCust As DataSet = Nothing
                                    Dim sellingPrice As Decimal
                                    dsCust = objWOJDO.Cust_CostPriceDetails(dtrowDeb("ID_JOB_DEB").ToString)
                                    If dsCust.Tables(0).Rows.Count > 0 Then
                                        If dsCust.Tables(0).Rows(0)("FLG_CPRICE") = True And IIf(IsDBNull(dtrow("SPARE_TYPE")) = True, "", dtrow("SPARE_TYPE")) <> "EFD" And IIf(IsDBNull(dtrow("FLG_EDIT_SP")) = True, False, dtrow("FLG_EDIT_SP")) = False Then

                                            sellingPrice = dtrow("COST_PRICE") + (dtrow("COST_PRICE") * CDbl(dsCust.Tables(0).Rows(0)("CUST_COSTPRICE")) / 100)
                                        Else
                                            sellingPrice = IIf(IsDBNull(dtrow("JOBI_SELL_PRICE")) = True, 0, dtrow("JOBI_SELL_PRICE")) 'Corrected for Repair Package
                                        End If
                                    End If

                                    Dim dVatperc As Decimal = 0.0
                                    Dim discPer As Decimal = 0.0
                                    'sellingPrice = IIf(IsDBNull(dtrow("Jobi_Sell_Price")) = True, 0, dtrow("Jobi_Sell_Price"))
                                    dVatperc = IIf(IsDBNull(dtrow("JOBI_VAT_PER")) = True, 0, dtrow("JOBI_VAT_PER"))
                                    discPer = IIf(IsDBNull(dtrow("JOBI_DIS_PER")) = True, 0, dtrow("JOBI_DIS_PER"))
                                    discount = ((sellingPrice * (IIf(IsDBNull(dtrow("JOBI_DELIVER_QTY")) = True, 0, dtrow("JOBI_DELIVER_QTY")))) * 0.01 * discPer * 0.01 * dbtPer)
                                    discAmount += discount
                                    vatAmount += ((sellingPrice * (IIf(IsDBNull(dtrow("JOBI_DELIVER_QTY")) = True, 0, dtrow("JOBI_DELIVER_QTY"))) * 0.01 * dbtPer) - discount) * 0.01 * dVatperc
                                    totalSparePrice = totalSparePrice + ((sellingPrice * (IIf(IsDBNull(dtrow("JOBI_DELIVER_QTY")) = True, 0, dtrow("JOBI_DELIVER_QTY")))) * 0.01 * dbtPer)

                                Next
                            Next
                            spVat = vatAmount
                        End If
                    End If
                End If

                Dim WO_totalAmt, WO_Tot_Lab_Amt, WO_Tot_Gm_Amt, WO_Tot_Spare_Amt, WO_Tot_Vat_Amt, WO_Tot_Disc_Amt As String
                WO_Tot_Lab_Amt = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(CStr(totalLabAmt) = "", "", CStr(totalLabAmt)))
                WO_Tot_Gm_Amt = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(CStr(totalGmPrice) = "", "", CStr(totalGmPrice)))
                WO_Tot_Spare_Amt = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(CStr(totalSparePrice) = "", "", CStr(totalSparePrice)))
                WO_Tot_Disc_Amt = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(CStr(discAmount) = "", "", CStr(discAmount)))

                totalVat = vatAmount + gmVat + hpVat
                totalAmt = totalLabAmt + totalGmPrice + totalSparePrice - discAmount + totalVat
                WO_totalAmt = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(CStr(totalAmt) = "", "", CStr(totalAmt)))
                WO_Tot_Vat_Amt = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(CStr(totalVat) = "", "", CStr(totalVat)))
                spVat = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(CStr(spVat) = "", "", CStr(spVat)))


                wojDet.GM_Vat = gmVat
                wojDet.HP_Vat = hpVat
                wojDet.SP_Vat = spVat
                wojDet.Tot_Amount = WO_totalAmt
                wojDet.Tot_Lab_Amt = WO_Tot_Lab_Amt
                wojDet.Tot_Gm_Amt = WO_Tot_Gm_Amt
                wojDet.Tot_Spare_Amt = WO_Tot_Spare_Amt
                wojDet.Tot_Vat_Amt = WO_Tot_Vat_Amt
                wojDet.Tot_Disc_Amt = WO_Tot_Disc_Amt
                wojDet.Job_Dis = jobDisc
                wojDet.WO_Gm_Vatper = gmVatPer
                wojDet.WO_Lbr_Vatper = hpVatPer

                HttpContext.Current.Session("WO_AmtCalc") = wojDet
                details.Add(wojDet)

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "services.wojobdetails", "CalculateJobDet", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("userid"))
            End Try
            Return details
        End Function
        Public Function LoadGMHPVat(objWOJBO) As List(Of WOJobDetailBO)
            Dim details As New List(Of WOJobDetailBO)()
            Dim dsWOJLoadGmHp As New DataSet
            Dim dtWOJLoadGmHp As New DataTable
            Try
                dsWOJLoadGmHp = objWOJDO.Load_GMHP_VAT(objWOJBO)
                HttpContext.Current.Session("LoadGMHP_VAT") = dsWOJLoadGmHp

                If dsWOJLoadGmHp.Tables.Count > 0 Then
                    Dim wojDet As New WOJobDetailBO()
                    If dsWOJLoadGmHp.Tables(0).Rows.Count > 0 Then
                        wojDet.HP_Vat = IIf(IsDBNull(dsWOJLoadGmHp.Tables(0).Rows(0)("HP_Vat")) = True, "0", dsWOJLoadGmHp.Tables(0).Rows(0)("HP_Vat"))
                    Else
                        wojDet.HP_Vat = "0"
                    End If
                    If dsWOJLoadGmHp.Tables(1).Rows.Count > 0 Then
                        wojDet.GM_Vat = IIf(IsDBNull(dsWOJLoadGmHp.Tables(1).Rows(0)("GM_Vat")) = True, "0", dsWOJLoadGmHp.Tables(1).Rows(0)("GM_Vat"))
                    Else
                        wojDet.GM_Vat = "0"
                    End If
                    If dsWOJLoadGmHp.Tables(2).Rows.Count > 0 Then
                        wojDet.SP_Vat = IIf(IsDBNull(dsWOJLoadGmHp.Tables(2).Rows(0)("SP_Vat")) = True, "0", dsWOJLoadGmHp.Tables(2).Rows(0)("SP_Vat"))
                    Else
                        wojDet.SP_Vat = "0"
                    End If
                    If dsWOJLoadGmHp.Tables(3).Rows.Count > 0 Then
                        wojDet.Dis_Per = dsWOJLoadGmHp.Tables(3).Rows(0)("Dis_Per")
                    End If
                    If dsWOJLoadGmHp.Tables(4).Rows.Count > 0 Then
                        wojDet.Fixed_Vat = dsWOJLoadGmHp.Tables(4).Rows(0)("Fixed_Vat")
                    End If
                    If dsWOJLoadGmHp.Tables(5).Rows.Count > 0 Then
                        wojDet.Vat_Per = dsWOJLoadGmHp.Tables(5).Rows(0)("Vat_Per")
                    End If
                    If dsWOJLoadGmHp.Tables(6).Rows.Count > 0 Then
                        wojDet.Ownriskvat = dsWOJLoadGmHp.Tables(6).Rows(0)("Ownriskvat")
                        HttpContext.Current.Session("OwnRiskVATPer") = dsWOJLoadGmHp.Tables(6).Rows(0)("Ownriskvat")
                    End If
                    details.Add(wojDet)
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "LoadGMHPVat", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        'Used to load all result set of dataset
        Public Function Load_ConfigDetails(objWOJBO) As Collection
            Dim dsWOJDetails As New DataSet
            Dim dtWOJDetails As New DataTable
            Dim dt As New Collection
            Dim dsMakeModel As New DataSet
            Dim dsCustInfo As New DataSet
            Dim dsSpareStatus As New DataSet
            Try
                'For Getting the Vehicle model
                dsMakeModel = HttpContext.Current.Session("MoreVehInfo")
                If Not dsMakeModel Is Nothing Then
                    If dsMakeModel.Tables.Count > 0 Then
                        If dsMakeModel.Tables(0).Rows.Count > 0 Then

                            ' check this client have changed the column name " ID_MAKE_VEH "  to " VEH_MAKE_CODE "
                            If (dsMakeModel.Tables(0).Columns.Contains("ID_MAKE_VEH")) Then
                                objWOJBO.Id_Make_Rp = IIf(IsDBNull(dsMakeModel.Tables(0).Rows(0)("ID_MAKE_VEH")) = True, "", dsMakeModel.Tables(0).Rows(0)("ID_MAKE_VEH").ToString())
                            ElseIf (dsMakeModel.Tables(0).Columns.Contains("VEH_MAKE_CODE")) Then
                                objWOJBO.Id_Make_Rp = IIf(IsDBNull(dsMakeModel.Tables(0).Rows(0)("VEH_MAKE_CODE")) = True, "", dsMakeModel.Tables(0).Rows(0)("VEH_MAKE_CODE").ToString())
                            End If

                            'objWOJBO.Id_Make_Rp = IIf(IsDBNull(dsMakeModel.Tables(0).Rows(0)("ID_MAKE_VEH").ToString()) = True, "", dsMakeModel.Tables(0).Rows(0)("ID_MAKE_VEH").ToString())

                            objWOJBO.Id_Model_Rp = IIf(IsDBNull(dsMakeModel.Tables(0).Rows(0)("ID_MODEL_RP")) = True, "", dsMakeModel.Tables(0).Rows(0)("ID_MODEL_RP").ToString())
                        End If
                    End If
                End If
                dsWOJDetails = objWOJDO.Load_ConfigDetails(objWOJBO)
                HttpContext.Current.Session("WOJConfigDetails") = dsWOJDetails
                If dsWOJDetails.Tables.Count > 0 Then
                    '0-Repair Pkg,
                    '1-Repair Code
                    '2-Spares
                    '3-Category
                    '4-Price Code
                    '5-Order Settings
                    '6-Price Code -Repeated
                    '7-Work Code
                    '8-Cust/Vehicle details
                    '9-Mechanic Competency
                    '10-Payment Type/Debitor
                    '11-Station Type
                    '12-Mechanics
                    '13-GM details
                    '14-Order Settings
                    '15-WO and prefix
                    '16-all vehicle for order head cust
                    '17-VAO Spares
                    '18-ExVehicle Spares
                    '19-24 - Settings

                    'Cust/Vehicle details Load
                    If dsWOJDetails.Tables(8).Rows.Count > 0 Then
                        dtWOJDetails = dsWOJDetails.Tables(8)
                        Dim details As New List(Of WOJobDetailBO)()
                        For Each dtrow As DataRow In dtWOJDetails.Rows
                            Dim wojDet As New WOJobDetailBO()
                            wojDet.Id_Customer = IIf(IsDBNull(dtrow("Id_Cust_WO")) = True, "", dtrow("Id_Cust_WO"))
                            wojDet.WO_Cust_Groupid = IIf(IsDBNull(dtrow("WO_Cust_Groupid")) = True, "", dtrow("WO_Cust_Groupid"))
                            wojDet.WO_Id_Veh = IIf(IsDBNull(dtrow("Id_Veh_Seq_WO")) = True, "", dtrow("Id_Veh_Seq_WO"))
                            wojDet.Veh_Grp = IIf(IsDBNull(dtrow("Id_Grp_Veh")) = True, "", dtrow("Id_Grp_Veh"))
                            wojDet.Id_Make_Veh = IIf(IsDBNull(dtrow("Id_Make_Veh")) = True, "", dtrow("Id_Make_Veh"))
                            wojDet.WO_Veh_Reg_No = IIf(IsDBNull(dtrow("WO_Veh_Reg_No")) = True, "", dtrow("WO_Veh_Reg_No"))
                            wojDet.WO_Veh_Mileage = IIf(IsDBNull(dtrow("WO_Veh_Mileage")) = True, "", dtrow("WO_Veh_Mileage"))
                            HttpContext.Current.Session("Id_Cust") = IIf(IsDBNull(dtrow("Id_Cust_WO")) = True, "", dtrow("Id_Cust_WO"))
                            HttpContext.Current.Session("VehGroup") = IIf(IsDBNull(dtrow("Id_Grp_Veh")) = True, "", dtrow("Id_Grp_Veh"))
                            HttpContext.Current.Session("Veh_Seq_No") = IIf(IsDBNull(dtrow("Id_Veh_Seq_WO")) = True, "", dtrow("Id_Veh_Seq_WO"))
                            HttpContext.Current.Session("ID_MAKE_HP") = IIf(IsDBNull(dtrow("Id_Make_Veh")) = True, "", dtrow("Id_Make_Veh"))
                            dsCustInfo = objCustomerDO.Fetch_Customer(wojDet.Id_Customer)
                            If (dsCustInfo.Tables.Count > 0) Then
                                If (dsCustInfo.Tables(0).Rows.Count > 0) Then
                                    wojDet.Cust_Info = IIf(IsDBNull(dsCustInfo.Tables(0).Rows(0)("CUST_NAME")) = True, "", dsCustInfo.Tables(0).Rows(0)("CUST_NAME"))
                                    HttpContext.Current.Session("CustName") = IIf(IsDBNull(dsCustInfo.Tables(0).Rows(0)("CUST_NAME")) = True, "", dsCustInfo.Tables(0).Rows(0)("CUST_NAME"))
                                End If
                            End If

                            dsSpareStatus = objWOJDO.Fetch_SpareStatus(objWOJBO)
                            If (dsSpareStatus.Tables.Count > 0) Then
                                If (dsSpareStatus.Tables(0).Rows.Count > 0) Then
                                    wojDet.Flg_Sprsts = IIf(IsDBNull(dsSpareStatus.Tables(0).Rows(0)("FLG_SPRSTATUS")) = True, False, dsSpareStatus.Tables(0).Rows(0)("FLG_SPRSTATUS"))
                                End If
                            End If

                            'Display Internal Note
                            If dsWOJDetails.Tables(24).Rows.Count > 0 Then
                                wojDet.Flg_Disp_Int_Note = dsWOJDetails.Tables(24).Rows(0)("Description").ToString()
                            Else
                                wojDet.Flg_Disp_Int_Note = "False"
                            End If

                            details.Add(wojDet)
                        Next
                        dt.Add(details)
                    ElseIf (dsWOJDetails.Tables(8).Rows.Count = 0) Then
                        dtWOJDetails = dsWOJDetails.Tables(8)
                        Dim details As New List(Of WOJobDetailBO)()
                        dt.Add(details)
                    End If

                    'GM Details
                    If dsWOJDetails.Tables(13).Rows.Count > 0 Then
                        dtWOJDetails = dsWOJDetails.Tables(13)
                        Dim details As New List(Of WOJobDetailBO)()
                        For Each dtrow As DataRow In dtWOJDetails.Rows
                            Dim wojDet As New WOJobDetailBO()
                            wojDet.WO_Gm_Per = dtrow("Price")
                            wojDet.Id_Gm_Vat = dtrow("Id_GMVat")
                            wojDet.Flg_Gm = "True"
                            HttpContext.Current.Session("ID_GMVAT") = dtrow("Id_GMVat")
                            HttpContext.Current.Session("GM_PER") = dtrow("Price")
                            details.Add(wojDet)
                        Next
                        dt.Add(details)
                    Else
                        Dim wojDet As New WOJobDetailBO()
                        Dim details As New List(Of WOJobDetailBO)()
                        wojDet.Flg_Gm = "False"
                        details.Add(wojDet)
                        dt.Add(details)
                    End If

                    'Payment Type and debitor
                    If dsWOJDetails.Tables(10).Rows.Count > 0 Then
                        dtWOJDetails = dsWOJDetails.Tables(10)
                        Dim details As New List(Of WOJobDetailBO)()
                        For Each dtrow As DataRow In dtWOJDetails.Rows
                            Dim wojDet As New WOJobDetailBO()
                            wojDet.WO_Cr_Type = IIf(IsDBNull(dtrow("Description")) = True, "", dtrow("Description")) 'Payment Type
                            wojDet.Id_Job_Deb = IIf(IsDBNull(dtrow("Id_Cust_WO")) = True, "", dtrow("Id_Cust_WO")) 'dtrow("Id_Cust_WO")
                            HttpContext.Current.Session("WO_CR_TYPE") = IIf(IsDBNull(dtrow("Description")) = True, "", dtrow("Description")) 'Payment Type
                            HttpContext.Current.Session("DEB_ID") = IIf(IsDBNull(dtrow("Id_Cust_WO")) = True, "", dtrow("Id_Cust_WO")) 'dtrow("Id_Cust_WO")
                            details.Add(wojDet)
                        Next
                        dt.Add(details)
                    ElseIf (dsWOJDetails.Tables(10).Rows.Count = 0) Then
                        dtWOJDetails = dsWOJDetails.Tables(10)
                        Dim details As New List(Of WOJobDetailBO)()
                        dt.Add(details)
                    End If

                    'Standard or clocked time
                    If dsWOJDetails.Tables(14).Rows.Count > 0 Then
                        dtWOJDetails = dsWOJDetails.Tables(14)
                        Dim details As New List(Of WOJobDetailBO)()
                        For Each dtrow As DataRow In dtWOJDetails.Rows
                            Dim wojDet As New WOJobDetailBO()
                            wojDet.WO_Charge_Base = IIf(IsDBNull(dtrow("WO_CHAREGE_BASE")) = True, "", dtrow("WO_CHAREGE_BASE")) 'Payment Type
                            details.Add(wojDet)
                        Next
                        dt.Add(details)
                    ElseIf (dsWOJDetails.Tables(14).Rows.Count = 0) Then
                        dtWOJDetails = dsWOJDetails.Tables(14)
                        Dim details As New List(Of WOJobDetailBO)()
                        dt.Add(details)
                    End If

                    'Mechanics
                    If dsWOJDetails.Tables(12).Rows.Count > 0 Then
                        dtWOJDetails = dsWOJDetails.Tables(12)
                        Dim details As New List(Of WOJobDetailBO)()
                        For Each dtrow As DataRow In dtWOJDetails.Rows
                            Dim wojDet As New WOJobDetailBO()
                            wojDet.First_Name = IIf(IsDBNull(dtrow("First_Name")) = True, "", dtrow("First_Name")) + "-" + IIf(IsDBNull(dtrow("Last_Name")) = True, "", dtrow("Last_Name")) + "-" + IIf(IsDBNull(dtrow("Id_Login")) = True, "", dtrow("Id_Login"))
                            wojDet.Last_Name = IIf(IsDBNull(dtrow("Last_Name")) = True, "", dtrow("Last_Name"))
                            wojDet.Id_Login = IIf(IsDBNull(dtrow("Id_Login")) = True, "", dtrow("Id_Login"))
                            details.Add(wojDet)
                        Next
                        dt.Add(details)
                    ElseIf (dsWOJDetails.Tables(12).Rows.Count = 0) Then
                        dtWOJDetails = dsWOJDetails.Tables(12)
                        Dim details As New List(Of WOJobDetailBO)()
                        dt.Add(details)
                    End If

                    'Valid Std Time settings
                    If dsWOJDetails.Tables(20).Rows.Count > 0 Then
                        HttpContext.Current.Session("ValidStdTime") = dsWOJDetails.Tables(20).Rows(0)("Description").ToString
                    Else
                        HttpContext.Current.Session("ValidStdTime") = "False"
                    End If

                    'Fetch Duser
                    If dsWOJDetails.Tables(25).Rows.Count > 0 Then
                        dtWOJDetails = dsWOJDetails.Tables(25)
                        Dim details As New List(Of WOJobDetailBO)()
                        For Each dtrow As DataRow In dtWOJDetails.Rows
                            Dim wojDet As New WOJobDetailBO()
                            wojDet.Id_Login = IIf(IsDBNull(dtrow("Id_Login")) = True, "", dtrow("Id_Login"))
                            HttpContext.Current.Session("DUser") = IIf(IsDBNull(dtrow("Id_Login")) = True, "", dtrow("Id_Login"))
                            details.Add(wojDet)
                        Next
                        dt.Add(details)
                    End If

                    'Use Confirm Dialogue
                    Get_ConfirmStatus()

                    If (HttpContext.Current.Session("UseConfirm") <> Nothing And HttpContext.Current.Session("UseConfirm") <> Nothing) Then
                        Dim details As New List(Of WOJobDetailBO)()
                        Dim wojDet As New WOJobDetailBO()
                        wojDet.Use_Confirm_Dialogue = HttpContext.Current.Session("UseConfirm")
                        wojDet.Check_Valid_Std_Time = HttpContext.Current.Session("ValidStdTime")
                        details.Add(wojDet)
                        dt.Add(details)
                    End If
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "Load_AllConfigDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return dt
        End Function
        Public Function Fetch_Hourly_Price(objWOJBO, chkChrgStdTime, jobId, hpmode) As List(Of WOJobDetailBO)
            Dim details As New List(Of WOJobDetailBO)()
            Dim dsWOJLoadHp As New DataSet
            Dim dtWOJLoadHp As New DataTable
            Try
                Dim dsMech As DataSet = HttpContext.Current.Session("Mechanics")
                If dsMech Is Nothing Then
                    dsMech = objWOJDO.Load_Mechanics(HttpContext.Current.Session("WONO"), HttpContext.Current.Session("WOPR"), jobId)
                End If
                Dim mechPrice(0) As String
                Dim mechVat(0) As String
                Dim mechLbTime(0) As String
                If Not dsMech Is Nothing Then
                    If dsMech.Tables(0).Rows.Count <> 0 Then
                        If Not (chkChrgStdTime = "true") Then
                            ReDim Preserve mechPrice(dsMech.Tables(0).Rows.Count)
                            ReDim Preserve mechVat(dsMech.Tables(0).Rows.Count)
                            ReDim Preserve mechLbTime(dsMech.Tables(0).Rows.Count)
                            Dim i As Integer = 0
                            For Each dr As DataRow In dsMech.Tables(0).Rows
                                objWOJBO.Mechpcd_HP = IIf(dr("MEC_HPCODID").ToString() = "", Nothing, dr("MEC_HPCODID").ToString())
                                dsWOJLoadHp = objWOJDO.Fetch_Hourly_Price(objWOJBO)
                                mechPrice(i) = dsWOJLoadHp.Tables(0).Rows(0)(0)
                                mechVat(i) = IIf(dsWOJLoadHp.Tables(0).Rows(0)(1) = "", 0, dsWOJLoadHp.Tables(0).Rows(0)(1))
                                mechLbTime(i) = IIf(dr("TOTALCLOCKEDTIMEMINS").ToString() = "", 0, dr("TOTALCLOCKEDTIMEMINS").ToString())
                                i = i + 1
                            Next
                        Else
                            objWOJBO.Mechpcd_HP = ""
                            dsWOJLoadHp = objWOJDO.Fetch_Hourly_Price(objWOJBO)
                            mechPrice(0) = dsWOJLoadHp.Tables(0).Rows(0)(0)
                            mechVat(0) = dsWOJLoadHp.Tables(0).Rows(0)(1)
                        End If
                    Else
                        objWOJBO.Mechpcd_HP = ""
                        dsWOJLoadHp = objWOJDO.Fetch_Hourly_Price(objWOJBO)
                        mechPrice(0) = dsWOJLoadHp.Tables(0).Rows(0)(0)
                        mechVat(0) = dsWOJLoadHp.Tables(0).Rows(0)(1)
                    End If
                Else
                    objWOJBO.Mechpcd_HP = ""
                    dsWOJLoadHp = objWOJDO.Fetch_Hourly_Price(objWOJBO)
                    mechPrice(0) = dsWOJLoadHp.Tables(0).Rows(0)(0).ToString()
                    mechVat(0) = dsWOJLoadHp.Tables(0).Rows(0)(1).ToString()
                End If

                Dim hourlyPrice As String = String.Empty
                Dim hpVat As String = String.Empty
                Dim highest As Integer = 0
                Dim totalLabourAmt As Decimal = 0.0
                If mechPrice.Length > 1 Then
                    For i As Integer = 0 To mechPrice.Length - 1
                        If highest < mechPrice(i) Then
                            highest = mechPrice(i)
                            hpVat = mechVat(i)
                        End If
                        totalLabourAmt = Round(Convert.ToDecimal(totalLabourAmt + (mechPrice(i) * (Round(mechLbTime(i) / 60, 2)))), 2)
                        'ViewState("totalLabourAmt") = totalLabourAmt
                    Next
                    hourlyPrice = highest.ToString()
                Else
                    hourlyPrice = mechPrice(0)
                    hpVat = mechVat(0)
                End If

                If dsWOJLoadHp.Tables.Count > 0 Then
                    Dim wojDet As New WOJobDetailBO()
                    If (hpmode = "NEW") Then
                        If dsWOJLoadHp.Tables(0).Rows.Count > 0 Then
                            wojDet.HP_Price = IIf(IsDBNull(hourlyPrice) = True, "0", hourlyPrice)
                            wojDet.Id_Hp_Vat = IIf(IsDBNull(hpVat) = True, "0", hpVat)
                            HttpContext.Current.Session("ID_HPVAT") = IIf(IsDBNull(hpVat) = True, "0", hpVat) 'IIf(IsDBNull(dsWOJLoadHp.Tables(0).Rows(0)("INV_LABOR_TEXT")) = True, "0", dsWOJLoadHp.Tables(0).Rows(0)("INV_LABOR_TEXT"))
                            wojDet.WO_Cust_HourlyPrice = IIf(IsDBNull(dsWOJLoadHp.Tables(0).Rows(0)("CUST_HOURLYPRICE")) = True, "0", dsWOJLoadHp.Tables(0).Rows(0)("CUST_HOURLYPRICE"))
                            HttpContext.Current.Session("WO_Cust_HourlyPrice") = IIf(IsDBNull(dsWOJLoadHp.Tables(0).Rows(0)("CUST_HOURLYPRICE")) = True, "0", dsWOJLoadHp.Tables(0).Rows(0)("CUST_HOURLYPRICE"))
                        End If
                    Else
                        If dsWOJLoadHp.Tables(0).Rows.Count > 0 Then
                            wojDet.HP_Price = IIf(IsDBNull(dsWOJLoadHp.Tables(0).Rows(0)("HP_Price")) = True, "0", dsWOJLoadHp.Tables(0).Rows(0)("HP_Price"))
                            wojDet.Id_Hp_Vat = IIf(IsDBNull(dsWOJLoadHp.Tables(0).Rows(0)("INV_LABOR_TEXT")) = True, "0", dsWOJLoadHp.Tables(0).Rows(0)("INV_LABOR_TEXT"))
                            HttpContext.Current.Session("ID_HPVAT") = IIf(IsDBNull(dsWOJLoadHp.Tables(0).Rows(0)("INV_LABOR_TEXT")) = True, "0", dsWOJLoadHp.Tables(0).Rows(0)("INV_LABOR_TEXT"))
                            wojDet.WO_Cust_HourlyPrice = IIf(IsDBNull(dsWOJLoadHp.Tables(0).Rows(0)("CUST_HOURLYPRICE")) = True, "0", dsWOJLoadHp.Tables(0).Rows(0)("CUST_HOURLYPRICE"))
                            HttpContext.Current.Session("WO_Cust_HourlyPrice") = IIf(IsDBNull(dsWOJLoadHp.Tables(0).Rows(0)("CUST_HOURLYPRICE")) = True, "0", dsWOJLoadHp.Tables(0).Rows(0)("CUST_HOURLYPRICE"))
                        End If
                    End If

                    details.Add(wojDet)
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "Fetch_Hourly_Price", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function Load_DebitorDetails(objWOJBO) As List(Of WOJobDetailBO)
            Dim details As New List(Of WOJobDetailBO)()
            Dim dsWODetails As New DataSet
            Dim dtWODetails As New DataTable
            Try
                dsWODetails = HttpContext.Current.Session("WODetails")
                If dsWODetails.Tables.Count > 0 Then
                    'Debitor Load
                    If dsWODetails.Tables(2).Rows.Count > 0 Then
                        dtWODetails = dsWODetails.Tables(2)
                        For Each dtrow As DataRow In dtWODetails.Rows
                            Dim wojDet As New WOJobDetailBO()
                            wojDet.Job_Deb_Name = dtrow("JOB_DEB_NAME")
                            wojDet.Dbt_Per = dtrow("DBT_PER")
                            wojDet.Dbt_Amt = dtrow("DBT_AMT")
                            wojDet.Id_Job_Deb = dtrow("ID_JOB_DEB")
                            wojDet.Id_Deb_Seq = dtrow("ID_DBT_SEQ")
                            wojDet.Deb_Sl_No = dtrow("SLNO")
                            wojDet.Spare_Count = dtrow("SPARECOUNT")
                            wojDet.Org_Per = dtrow("ORGPERCENT")

                            details.Add(wojDet)
                        Next
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "Load_DebitorDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function CalculateFixedPrice(ByVal objWOJBO As WOJobDetailBO) As List(Of WOJobDetailBO)
            Dim details As New List(Of WOJobDetailBO)()
            Dim wojDet As New WOJobDetailBO()

            Try
                Dim fixedVat As Decimal = 0.0
                Dim fixedAmt As Decimal = 0.0
                Dim fixedVatper As Decimal = 0.0
                If HttpContext.Current.Session("Incl_vat") = "true" Then
                    fixedAmt = objWOJBO.Fixed_Price
                    fixedVatper = objWOJBO.Fixed_Vat
                    fixedVatper = 100 + fixedVatper
                    fixedVat = Round((fixedAmt * 100) / fixedVatper, 2)
                    fixedVat = fixedAmt - fixedVat
                Else
                    fixedVat = Round(Convert.ToDecimal(IIf(objWOJBO.Fixed_Price = "", 0D, objWOJBO.Fixed_Price)) * Convert.ToDecimal(objWOJBO.Fixed_Vat) * 0.01, 2)
                    fixedAmt = IIf(objWOJBO.Fixed_Price = "", 0D, objWOJBO.Fixed_Price)
                    fixedAmt = fixedVat + fixedAmt
                End If

                wojDet.Fixed_Price = fixedAmt
                wojDet.Fixed_Vat = fixedVat
                details.Add(wojDet)

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "CalculateFixedPrice", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function Fetch_StockItem_Status(ByVal idItem As String, ByVal idMake As String) As String
            Dim dsStockItem As New DataSet
            Dim id_wh As String = 0
            Dim Flg_stockitem_status As String = ""
            Try
                id_wh = GetWarehouse()
                dsStockItem = objWOJDO.Fetch_StockItem_Status(idItem, idMake, Convert.ToInt32(id_wh.ToString()))

                If (dsStockItem.Tables.Count > 0) Then
                    If dsStockItem.Tables(0).Rows.Count > 0 Then
                        Flg_stockitem_status = dsStockItem.Tables(0).Rows(0)("FLG_STOCK_STATUS").ToString
                    End If
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "Fetch_StockItem_Status", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return Flg_stockitem_status
        End Function
        Public Function Fetch_SparePartStockQty_Details(ByVal objWOJBO As WOJobDetailBO) As List(Of WOJobDetailBO)
            Dim details As New List(Of WOJobDetailBO)()
            Dim dsSpStckQty As New DataSet
            Dim dtSpStckQty As New DataTable
            Dim id_wh_item As String
            Try
                id_wh_item = GetWarehouse()
                objWOJBO.Id_Wh_Item = Convert.ToInt32(id_wh_item.ToString())
                dsSpStckQty = objWOJDO.Fetch_SparePartStockQty_Details(objWOJBO)
                If dsSpStckQty.Tables.Count > 1 Then
                    If dsSpStckQty.Tables(0).Rows.Count > 0 Then
                        dtSpStckQty = dsSpStckQty.Tables(0)
                        For Each dtrow As DataRow In dtSpStckQty.Rows
                            Dim wojDet As New WOJobDetailBO()
                            wojDet.Item_Avail_Qty = IIf(IsDBNull(dtrow("Item_Avail_Qty")) = True, 0, dtrow("Item_Avail_Qty"))
                            wojDet.Sp_Disc_Code_Sell = IIf(IsDBNull(dtrow("Item_Disc_Code")) = True, "", dtrow("Item_Disc_Code"))
                            wojDet.Sp_Disc_Code_Buy = IIf(IsDBNull(dtrow("Item_Disc_Code_Buy")) = True, "", dtrow("Item_Disc_Code_Buy"))
                            details.Add(wojDet)
                        Next
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "Fetch_SparePartStockQty_Details", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function FetchJobNo(objWOJBO) As String
            Dim details As New List(Of WOJobDetailBO)()
            Dim strJobNo As String
            Try
                strJobNo = objWOJDO.Fetch_Job_No(objWOJBO)
                HttpContext.Current.Session("WOJobNo") = strJobNo
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "FetchJobNo", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strJobNo
        End Function
        Public Function GetWarehouse() As String
            Dim dsWarehouse As New DataSet
            Dim Id_Wh_Item As String
            Dim wh_name As String = ""
            Dim flg_default As Boolean
            Try
                dsWarehouse = objWOJDO.GetUsersWarehouse(HttpContext.Current.Session("UserID"))
                If dsWarehouse.Tables.Count > 0 Then
                    If dsWarehouse.Tables(0).Rows.Count > 0 Then
                        Id_Wh_Item = dsWarehouse.Tables(0).Rows(0)("ID_WH").ToString()
                        HttpContext.Current.Session("Id_WH") = Id_Wh_Item.ToString()
                        wh_name = dsWarehouse.Tables(0).Rows(0)("WH_NAME").ToString()
                        flg_default = dsWarehouse.Tables(0).Rows(0)("FLG_DEFAULT").ToString()
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "GetWarehouse", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return Id_Wh_Item
        End Function
        Public Function GetRCWCDetails() As Collection
            Dim dsRCWCDetails As New DataSet
            Dim dtRCWCDetails As New DataTable
            Dim dt As New Collection
            Try
                dsRCWCDetails = objWOJDO.GetRCWCDetails()
                If dsRCWCDetails.Tables.Count > 0 Then
                    'RepairCode Details
                    If dsRCWCDetails.Tables(0).Rows.Count > 0 Then
                        dtRCWCDetails = dsRCWCDetails.Tables(0)
                        Dim details As New List(Of WOJobDetailBO)()
                        For Each dtrow As DataRow In dtRCWCDetails.Rows
                            Dim wojDet As New WOJobDetailBO()
                            wojDet.Id_Rep_Code = IIf(IsDBNull(dtrow("Id_Rep_Code")) = True, "", dtrow("Id_Rep_Code"))
                            wojDet.Rp_RepCode_Des = IIf(IsDBNull(dtrow("Rp_RepCode_Des")) = True, "", dtrow("Rp_RepCode_Des"))
                            wojDet.IsDefault = IIf(IsDBNull(dtrow("IsDefault")) = True, "0", dtrow("IsDefault"))
                            details.Add(wojDet)
                        Next
                        dt.Add(details)
                    End If

                    'Work Code Details
                    If dsRCWCDetails.Tables(1).Rows.Count > 0 Then
                        dtRCWCDetails = dsRCWCDetails.Tables(1)
                        Dim details As New List(Of WOJobDetailBO)()
                        For Each dtrow As DataRow In dtRCWCDetails.Rows
                            Dim wojDet As New WOJobDetailBO()
                            wojDet.Work_Code_Id_Settings = IIf(IsDBNull(dtrow("Id_Settings")) = True, "", dtrow("Id_Settings"))
                            wojDet.IdConfig = IIf(IsDBNull(dtrow("Id_Config")) = True, "", dtrow("Id_Config"))
                            wojDet.Work_Code_Description = IIf(IsDBNull(dtrow("Description")) = True, "", dtrow("Description"))
                            wojDet.Remarks = IIf(IsDBNull(dtrow("Remarks")) = True, "", dtrow("Remarks"))
                            wojDet.Flag = IIf(IsDBNull(dtrow("Flag")) = True, "", dtrow("Flag"))
                            details.Add(wojDet)
                        Next
                        dt.Add(details)
                    End If
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "GetRCWCDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return dt
        End Function
        Public Function Add_DebitorDetails(ByVal debtSlNo As String, ByVal debtCustCode As String, ByVal debtPercentage As String, ByVal debtAmt As String, ByVal debtChkAddAmt As String, ByVal chkOwnRisk As String, ByVal ownRiskAmt As String, ByVal creditCustCode As String, ByVal creditCustName As String) As List(Of WOJobDetailBO)
            Dim details As New List(Of WOJobDetailBO)()
            Try
                Dim dtDebitor As New DataTable
                Dim rUser As DataRow
                Dim dsReturnVal As DataSet = Nothing
                Dim percTotal = 0.0, TotAmt As Decimal = 0.0, SP_Amt_Deb = 0.0
                Dim debitPerc As Decimal = 0.0
                Dim editPercentage As Decimal = 0.0
                Dim creditCustomerPerc As Decimal = 0.0
                Dim creditCustomerAmount As Decimal = 0.0
                Dim BalancePercentage As Decimal = 0.0
                Dim strErr As String = ""
                Dim warning As String = ""
                Dim dtDebitorCopy As New DataTable
                If (HttpContext.Current.Session("WODebDetails") Is Nothing) Then
                    dtDebitor.Columns.Add("ID_JOB_DEB")
                    dtDebitor.Columns.Add("JOB_DEB_NAME")
                    dtDebitor.Columns.Add("DBT_PER")
                    dtDebitor.Columns.Add("DBT_AMT")
                    dtDebitor.Columns.Add("DEBITOR_TYPE")
                    dtDebitor.Columns.Add("ID_DBT_SEQ")
                    dtDebitor.Columns.Add("SLNO")
                    dtDebitor.Columns.Add("SPARECOUNT")
                    dtDebitor.Columns.Add("ORGPERCENT")
                    dtDebitor.Columns.Add("WO_VAT_PERCENTAGE") 'Spare part Vat Per
                    dtDebitor.Columns.Add("WO_GM_PER") 'Garage Material  Percentage
                    dtDebitor.Columns.Add("WO_GM_VATPER") 'Garage Material Vat Percentage
                    dtDebitor.Columns.Add("WO_LBR_VATPER") 'Labour Vat Percentage
                    dtDebitor.Columns.Add("WO_SPR_DISCPER") 'Spare Part Discount Percentage
                    dtDebitor.Columns.Add("WO_FIXED_VATPER") 'Fixed Price Vat Percentage
                    dtDebitor.Columns.Add("JOB VAT")
                    dtDebitor.Columns.Add("LABOUR AMOUNT")
                    dtDebitor.Columns.Add("LABOUR DISCOUNT")
                    dtDebitor.Columns.Add("GM AMOUNT")
                    dtDebitor.Columns.Add("GM DISCOUNT")
                    dtDebitor.Columns.Add("OWN RISK AMOUNT")
                    dtDebitor.Columns.Add("SP_VAT")
                    dtDebitor.Columns.Add("SP_AMT_DEB")
                    rUser = dtDebitor.NewRow()
                    rUser("ID_JOB_DEB") = HttpContext.Current.Session("Id_Cust")
                    rUser("JOB_DEB_NAME") = HttpContext.Current.Session("CustName")
                    rUser("DBT_PER") = "100"
                    rUser("DBT_AMT") = "0"
                    rUser("DEBITOR_TYPE") = "C"
                    rUser("ID_DBT_SEQ") = CStr(1)
                    rUser("SPARECOUNT") = 0
                    rUser("ORGPERCENT") = "100"
                    rUser("SLNO") = CStr(1)
                    rUser("WO_VAT_PERCENTAGE") = 0.0 'Spare part Vat Per
                    rUser("WO_GM_PER") = 0.0 'Garage Material  Percentage
                    rUser("WO_GM_VATPER") = 0.0 'Garage Material Vat Percentage
                    rUser("WO_LBR_VATPER") = 0.0 'Labour Vat Percentage
                    rUser("WO_SPR_DISCPER") = 0.0
                    rUser("WO_FIXED_VATPER") = 0.0 'Fixed Price Vat Percentage
                    rUser("JOB VAT") = 0.0
                    rUser("LABOUR AMOUNT") = 0.0
                    rUser("LABOUR DISCOUNT") = 0.0
                    rUser("GM AMOUNT") = 0.0
                    rUser("GM DISCOUNT") = 0.0
                    rUser("OWN RISK AMOUNT") = 0.0
                    rUser("SP_VAT") = 0.0
                    rUser("SP_AMT_DEB") = 0.0
                    dtDebitor.Rows.Add(rUser)
                Else
                    dtDebitor = HttpContext.Current.Session("WODebDetails")
                    dtDebitorCopy = dtDebitor.Copy()
                    If chkOwnRisk = "true" Then
                        For i As Integer = 0 To dtDebitor.Rows.Count - 1
                            TotAmt = Convert.ToDouble(dtDebitor.Rows(i)("DBT_AMT")) + TotAmt
                            SP_Amt_Deb = dtDebitor.Rows(i)("SP_AMT_DEB")
                        Next
                        If ownRiskAmt.Trim() = "" Or ownRiskAmt.Trim() = "0" Then
                            Dim wojDet As New WOJobDetailBO()
                            strErr = objErrHandle.GetErrorDesc("ORValid")
                            wojDet.ErrMsg = strErr
                            details.Add(wojDet)
                            'Return details.ToList()
                            'Exit Function
                        End If
                        'Smita
                        If (TotAmt - SP_Amt_Deb) < Convert.ToDouble(ownRiskAmt.Trim()) Then
                            'Me.ClientScript.RegisterStartupScript(Me.GetType(), "info", String.Format("alert('{0}');", oErrHandle.GetErrorDesc("MSG057")), True)
                            Dim wojDet As New WOJobDetailBO()
                            strErr = "Total Amount exceeds."
                            wojDet.ErrMsg = strErr
                            details.Add(wojDet)
                            'Return details.ToList()
                            'Exit Function
                        End If




                        rUser = dtDebitor.NewRow()
                        rUser("ID_JOB_DEB") = creditCustCode
                        rUser("JOB_DEB_NAME") = creditCustName
                        rUser("DBT_AMT") = ownRiskAmt
                        rUser("DEBITOR_TYPE") = "C"
                        rUser("ID_DBT_SEQ") = CStr(IIf(IsDBNull(dtDebitor.Compute("MAX(ID_DBT_SEQ)", "") + 1) = True, 1, dtDebitor.Compute("MAX(ID_DBT_SEQ)", "") + 1))
                        rUser("SPARECOUNT") = 0
                        rUser("ORGPERCENT") = rUser("DBT_PER")
                        rUser("SLNO") = dtDebitor.Rows.Count + 1
                        rUser("WO_VAT_PERCENTAGE") = 1 'Spare part Vat Per
                        rUser("WO_GM_PER") = 1 'Garage Material  Percentage
                        rUser("WO_GM_VATPER") = 1 'Garage Material Vat Percentage
                        rUser("WO_LBR_VATPER") = 1 'Labour Vat Percentage
                        rUser("WO_SPR_DISCPER") = 1
                        rUser("WO_FIXED_VATPER") = 1 'Fixed Price Vat Percentage
                        If dtDebitor.Rows(0)("DBT_PER") = "100" Then
                            dtDebitor.Rows(0)("DBT_AMT") = Convert.ToDouble(dtDebitor.Rows(0)("DBT_AMT")) - Convert.ToDouble(ownRiskAmt)
                        End If

                        dtDebitor.Rows.Add(rUser)
                        HttpContext.Current.Session("WODebDetails") = dtDebitor
                        If dtDebitor.Rows.Count > 0 Then
                            For Each dtrow As DataRow In dtDebitor.Rows
                                Dim wojDet As New WOJobDetailBO()
                                wojDet.Job_Deb_Name = IIf(IsDBNull(dtrow("JOB_DEB_NAME")) = True, "", dtrow("JOB_DEB_NAME"))
                                wojDet.Dbt_Per = IIf(IsDBNull(dtrow("DBT_PER")) = True, "", dtrow("DBT_PER"))
                                wojDet.Dbt_Amt = IIf(IsDBNull(dtrow("DBT_AMT")) = True, "", dtrow("DBT_AMT"))
                                wojDet.Id_Job_Deb = IIf(IsDBNull(dtrow("ID_JOB_DEB")) = True, "", dtrow("ID_JOB_DEB"))
                                wojDet.Id_Deb_Seq = IIf(IsDBNull(dtrow("ID_DBT_SEQ")) = True, 0, dtrow("ID_DBT_SEQ"))
                                wojDet.Deb_Sl_No = IIf(IsDBNull(dtrow("SLNO")) = True, "", dtrow("SLNO"))
                                wojDet.Spare_Count = IIf(IsDBNull(dtrow("SPARECOUNT")) = True, "", dtrow("SPARECOUNT"))
                                wojDet.Org_Per = IIf(IsDBNull(dtrow("ORGPERCENT")) = True, "", dtrow("ORGPERCENT"))

                                details.Add(wojDet)
                            Next
                        End If
                        HttpContext.Current.Session("OwnRiskAmt") = ownRiskAmt
                        Exit Function
                    End If
                    If debtSlNo <> "" Then

                        rUser = dtDebitor.Rows(Convert.ToInt32(debtSlNo) - 1)
                        rUser("ID_JOB_DEB") = debtCustCode

                        dsReturnVal = objCustomerDO.Fetch_Customer(debtCustCode)

                        If rUser("DBT_PER").ToString.Length <> 0 Then
                            creditCustomerPerc = rUser("DBT_PER")
                        End If

                        creditCustomerAmount = rUser("DBT_AMT")

                        Dim drCustomer As DataRow()
                        If dsReturnVal.Tables.Count <> 0 Then
                            drCustomer = dsReturnVal.Tables(0).Select("ID_CUSTOMER  = '" & rUser("ID_JOB_DEB") & "'")
                            If drCustomer.Length = 1 Then
                                rUser("JOB_DEB_NAME") = drCustomer(0)("CUST_NAME").ToString()
                            End If
                        End If

                        If debtPercentage <> "" Then
                            rUser("DBT_PER") = Round(Convert.ToDecimal(IIf(debtPercentage = "", 0D, debtPercentage)), 2)
                        End If

                        rUser("DBT_AMT") = IIf(debtAmt = "", 0D, debtAmt)
                        rUser("ORGPERCENT") = rUser("DBT_PER")

                        editPercentage = 0.0

                        For i As Integer = 0 To dtDebitor.Rows.Count - 1
                            If dtDebitor.Rows(i)("DBT_PER").ToString.Length <> 0 Then
                                editPercentage = IIf(IsDBNull(dtDebitor.Rows(i)("DBT_PER")) = True, 0, Convert.ToDecimal(dtDebitor.Rows(i)("DBT_PER"))) + editPercentage
                            End If
                        Next

                        Dim subTotal As Decimal = 0.0

                        For count As Integer = 0 To dtDebitor.Rows.Count - 1
                            If count = (CType(debtSlNo, Integer) - 1) Or count = 0 Then
                            Else
                                If dtDebitor.Rows(count)("DBT_PER").ToString.Length <> 0 Then
                                    subTotal = Convert.ToDecimal(dtDebitor.Rows(count)("DBT_PER")) + subTotal
                                End If
                            End If
                        Next

                        If debtChkAddAmt = "false" Then
                            dtDebitor.Rows(0)("DBT_PER") = 100
                            dtDebitor.Rows(0)("ORGPERCENT") = dtDebitor.Rows(0)("DBT_PER")
                        Else
                            rUser("DBT_PER") = "0"
                            For i As Integer = 0 To dtDebitor.Rows.Count - 1
                                BalancePercentage = BalancePercentage + Convert.ToDecimal(dtDebitor.Rows(i)("DBT_PER"))
                            Next
                            If BalancePercentage >= 100 Then
                                'Me.ClientScript.RegisterStartupScript(Me.GetType(), "infoBalance", "alert(GetMultiMessage('MSG151','',''));", True)
                                Dim wojDet As New WOJobDetailBO()
                                strErr = objErrHandle.GetErrorDesc("MSG151")
                                wojDet.ErrMsg = strErr
                                details.Add(wojDet)
                                'Return details.ToList()
                                'Exit Function
                            End If
                            rUser("DBT_PER") = Round(Convert.ToDecimal(100 - BalancePercentage), 2)
                            rUser("ORGPERCENT") = rUser("DBT_PER")
                        End If

                        If debtSlNo = "1" Then
                            dtDebitor.Rows(0)("DBT_PER") = Round(Convert.ToDecimal(IIf(debtPercentage = "", 0D, debtPercentage)), 2) '+ percTotal)
                            dtDebitor.Rows(0)("ORGPERCENT") = dtDebitor.Rows(0)("DBT_PER")

                            If dtDebitor.Rows.Count = 2 Then
                                If dtDebitor.Rows(1)("DBT_PER").ToString.Length <> 0 Then
                                    dtDebitor.Rows(1)("DBT_PER") = 100.0
                                End If
                            Else
                                For i As Integer = 1 To dtDebitor.Rows.Count - 1
                                    dtDebitor.Rows(i)("DBT_PER") = 0
                                Next
                            End If
                        Else
                            If debtChkAddAmt = "false" Then
                                dtDebitor.Rows(0)("DBT_PER") = Round(Convert.ToDecimal(dtDebitor.Rows(0)("DBT_PER") - (Convert.ToDouble(IIf(debtPercentage = "", 0D, debtPercentage)) + subTotal)), 2)
                                dtDebitor.Rows(0)("ORGPERCENT") = dtDebitor.Rows(0)("DBT_PER")
                            End If
                        End If

                        If Convert.ToDouble(dtDebitor.Rows(0)("DBT_PER")) = 0.0 Then
                            dtDebitor.Rows(0)("DBT_AMT") = "0"
                            'CusPer-->Customer on order head percentage is zero
                            'Me.ClientScript.RegisterStartupScript(Me.GetType(), "info", String.Format("alert('{0}');", oErrHandle.GetErrorDesc("CusPer")), True)
                            Dim wojDet As New WOJobDetailBO()
                            strErr = objErrHandle.GetErrorDesc("CusPer")
                            wojDet.ErrMsg = strErr
                            'details.Add(wojDet)
                            'Return details.ToList()
                        ElseIf Convert.ToDouble(dtDebitor.Rows(0)("DBT_PER")) < 0.0 Then
                            'dtDebitor.Rows(0)("DBT_PER") = Round(Convert.ToDecimal(dgdDebitor.Items(0).Cells(2).Text), 2)
                            dtDebitor.Rows(0)("ORGPERCENT") = dtDebitor.Rows(0)("DBT_PER")
                            'rUser("DBT_PER") = Round(Convert.ToDecimal(dgdDebitor.Items((CType(txtslno.Text, Integer) - 1)).Cells(2).Text), 2)
                            rUser("ORGPERCENT") = rUser("DBT_PER")
                            'Me.ClientScript.RegisterStartupScript(Me.GetType(), "info", String.Format("alert('{0}');", oErrHandle.GetErrorDesc("NegPer")), True)
                            Dim wojDet As New WOJobDetailBO()
                            strErr = objErrHandle.GetErrorDesc("NegPer")
                            'wojDet.ErrMsg = strErr
                            'details.Add(wojDet)
                            'Return details.ToList()
                            warning = "Exists"
                            GoTo loadBack
                            'Exit Function
                        End If

                        percTotal = 0.0
                        For i As Integer = 0 To dtDebitor.Rows.Count - 1
                            If dtDebitor.Rows(i)("DBT_PER").ToString <> "" Then
                                percTotal = Convert.ToDouble(dtDebitor.Rows(i)("DBT_PER")) + percTotal
                            End If
                        Next

                        If percTotal > 100 Then
                            'TotPer-->Total Percentage Should not exceed 100%
                            'Me.ClientScript.RegisterStartupScript(Me.GetType(), "info", String.Format("alert('{0}');", oErrHandle.GetErrorDesc("TotPer")), True)
                            Dim wojDet As New WOJobDetailBO()
                            strErr = objErrHandle.GetErrorDesc("TotPer")
                            wojDet.ErrMsg = strErr
                            details.Add(wojDet)
                            'Return details.ToList()
                            'Exit Function
                            rUser("DBT_PER") = Round(Convert.ToDecimal(creditCustomerPerc), 2)
                            rUser("DBT_AMT") = Round(Convert.ToDecimal(creditCustomerAmount), 2)
                            rUser("ORGPERCENT") = rUser("DBT_PER")
                            Exit Function
                        End If
                    Else
                        'Add New Debitor
                        dtDebitor = HttpContext.Current.Session("WODebDetails")
                        For Each dr As DataRow In dtDebitor.Rows
                            If dr("ID_JOB_DEB") = debtCustCode Then
                                'txtCustSrch.Text = ""
                                'Me.ClientScript.RegisterStartupScript(Me.GetType(), "info", String.Format("alert('{0}');", oErrHandle.GetErrorDesc("CusExs")), True)
                                Dim wojDet As New WOJobDetailBO()
                                strErr = objErrHandle.GetErrorDesc("CusExs")
                                wojDet.ErrMsg = strErr
                                details.Add(wojDet)
                                'Return details.ToList()
                                'Exit Function
                            End If
                        Next

                        If dtDebitor.Rows(0)("ID_JOB_DEB") <> debtCustCode Then

                            rUser = dtDebitor.NewRow()
                            rUser("ID_JOB_DEB") = debtCustCode

                            If debtChkAddAmt = "false" Then
                                dtDebitor.Rows(0)("DBT_PER") = 100
                                dtDebitor.Rows(0)("ORGPERCENT") = dtDebitor.Rows(0)("DBT_PER")

                                For i As Integer = 1 To dtDebitor.Rows.Count - 1
                                    If dtDebitor.Rows(i)("DBT_PER").ToString <> "" Then
                                        percTotal = Convert.ToDouble(dtDebitor.Rows(i)("DBT_PER")) + percTotal
                                    End If
                                Next

                                debitPerc = Convert.ToDecimal(dtDebitor.Rows(0)("DBT_PER"))
                                debitPerc = Convert.ToDecimal(dtDebitor.Rows(0)("DBT_PER")) - (Convert.ToDecimal(IIf(debtPercentage = "", 0D, debtPercentage)) + percTotal)
                                If debitPerc < 0.0 Then
                                    dtDebitor.Rows(0)("DBT_PER") = Round(100 - percTotal, 2)
                                    dtDebitor.Rows(0)("ORGPERCENT") = dtDebitor.Rows(0)("DBT_PER")
                                    'Me.ClientScript.RegisterStartupScript(Me.GetType(), "info", String.Format("alert('{0}');", oErrHandle.GetErrorDesc("NegPer")), True)
                                    Dim wojDet As New WOJobDetailBO()
                                    strErr = objErrHandle.GetErrorDesc("NegPer")
                                    wojDet.ErrMsg = strErr
                                    'details.Add(wojDet)
                                    'Return details.ToList()
                                    'Exit Function
                                    warning = "Exists"
                                    GoTo loadBack
                                Else
                                    dtDebitor.Rows(0)("DBT_PER") = Round(Convert.ToDecimal(dtDebitor.Rows(0)("DBT_PER") - (Convert.ToDouble(IIf(debtPercentage = "", 0D, debtPercentage)) + percTotal)), 2)
                                    dtDebitor.Rows(0)("ORGPERCENT") = dtDebitor.Rows(0)("DBT_PER")
                                End If
                                percTotal = 0.0

                                If Convert.ToDouble(dtDebitor.Rows(0)("DBT_PER")) = 0.0 Then
                                    dtDebitor.Rows(0)("DBT_AMT") = "0"
                                    'CusPer-->Customer on order head percentage is zero
                                    'Me.ClientScript.RegisterStartupScript(Me.GetType(), "info", String.Format("alert('{0}');", oErrHandle.GetErrorDesc("CusPer")), True)
                                    Dim wojDet As New WOJobDetailBO()
                                    strErr = objErrHandle.GetErrorDesc("CusPer")
                                    wojDet.ErrMsg = strErr
                                    details.Add(wojDet)
                                    'Return details.ToList()
                                End If

                                For i As Integer = 0 To dtDebitor.Rows.Count - 1
                                    If dtDebitor.Rows(i)("DBT_PER").ToString <> "" Then
                                        percTotal = Convert.ToDouble(dtDebitor.Rows(i)("DBT_PER")) + percTotal
                                    End If
                                Next

                                If percTotal > 100 Then
                                    'TotPer-->Total Percentage Should not exceed 100%
                                    'Me.ClientScript.RegisterStartupScript(Me.GetType(), "info", String.Format("alert('{0}');", oErrHandle.GetErrorDesc("TotPer")), True)
                                    Dim wojDet As New WOJobDetailBO()
                                    strErr = objErrHandle.GetErrorDesc("TotPer")
                                    wojDet.ErrMsg = strErr
                                    details.Add(wojDet)
                                    'Return details.ToList()
                                    'Exit Function
                                End If
                                rUser("DBT_PER") = Round(Convert.ToDecimal(IIf(debtPercentage = "", 0D, debtPercentage)), 2)
                                rUser("ORGPERCENT") = rUser("DBT_PER")
                                rUser("DBT_AMT") = IIf(debtAmt = "", 0D, debtAmt)

                                rUser("WO_VAT_PERCENTAGE") = 0 'Spare part Vat Per
                                rUser("WO_GM_PER") = 0 'Garage Material  Percentage
                                rUser("WO_GM_VATPER") = 0 'Garage Material Vat Percentage
                                rUser("WO_LBR_VATPER") = 0 'Labour Vat Percentage
                                rUser("WO_SPR_DISCPER") = 0
                                rUser("WO_FIXED_VATPER") = 0 'Fixed Price Vat Percentage
                            Else
                                For i As Integer = 0 To dtDebitor.Rows.Count - 1
                                    If dtDebitor.Rows(i)("DBT_PER").ToString.Length <> 0 Then
                                        BalancePercentage = BalancePercentage + Convert.ToDecimal(dtDebitor.Rows(i)("DBT_PER"))
                                    End If
                                Next

                                If BalancePercentage >= 100 Then
                                    'ClientScript.RegisterStartupScript(Me.GetType(), "infoMyBalance", "alert(GetMultiMessage('MSG151','',''));", True)
                                    Dim wojDet As New WOJobDetailBO()
                                    strErr = objErrHandle.GetErrorDesc("MSG151")
                                    wojDet.ErrMsg = strErr
                                    details.Add(wojDet)
                                    'Return details.ToList()
                                    'Exit Function
                                End If

                                rUser("DBT_PER") = Round(Convert.ToDecimal(100 - BalancePercentage), 2)
                                rUser("ORGPERCENT") = rUser("DBT_PER")
                                rUser("DBT_AMT") = dtDebitor.Rows(0)("DBT_AMT") * (rUser("DBT_PER") / 100)
                                rUser("WO_VAT_PERCENTAGE") = 0 'Spare part Vat Per
                                rUser("WO_GM_PER") = 0 'Garage Material  Percentage
                                rUser("WO_GM_VATPER") = 0 'Garage Material Vat Percentage
                                rUser("WO_LBR_VATPER") = 0 'Labour Vat Percentage
                                rUser("WO_SPR_DISCPER") = 0
                                rUser("WO_FIXED_VATPER") = 0 'Fixed Price Vat Percentage
                            End If

                            If debtCustCode = String.Empty And (creditCustCode.Length <> 0) Then
                                If creditCustCode.Length <> 0 Then
                                    rUser("ID_JOB_DEB") = creditCustCode
                                    dsReturnVal = objCustomerDO.Fetch_Customer(creditCustCode)
                                End If
                            Else
                                dsReturnVal = objCustomerDO.Fetch_Customer(debtCustCode)
                            End If

                            Dim drCustomer As DataRow()
                            If dsReturnVal.Tables.Count <> 0 Then
                                drCustomer = dsReturnVal.Tables(0).Select("ID_CUSTOMER  = '" & rUser("ID_JOB_DEB") & "'")
                                If drCustomer.Length = 1 Then
                                    rUser("JOB_DEB_NAME") = drCustomer(0)("CUST_NAME").ToString()
                                End If
                            End If

                            rUser("DEBITOR_TYPE") = "D"
                            rUser("ID_DBT_SEQ") = CStr(IIf(IsDBNull(dtDebitor.Compute("MAX(ID_DBT_SEQ)", "") + 1) = True, 1, dtDebitor.Compute("MAX(ID_DBT_SEQ)", "") + 1))
                            rUser("SPARECOUNT") = 0
                            rUser("SLNO") = dtDebitor.Rows.Count + 1
                            dtDebitor.Rows.Add(rUser)
                        Else
                            'CusExs-->customer already exists
                            'Me.ClientScript.RegisterStartupScript(Me.GetType(), "info", String.Format("alert('{0}');", oErrHandle.GetErrorDesc("CusExs")), True)
                            Dim wojDet As New WOJobDetailBO()
                            strErr = objErrHandle.GetErrorDesc("CusExs")
                            wojDet.ErrMsg = strErr
                            details.Add(wojDet)
                            ''Return details.ToList()
                            'Exit Function
                        End If

                    End If

                End If

                HttpContext.Current.Session("WODebDetails") = dtDebitor
loadBack:       If (warning = "Exists") Then
                    dtDebitor = dtDebitorCopy.Copy()
                    HttpContext.Current.Session("WODebDetails") = dtDebitor
                End If
                If dtDebitor.Rows.Count > 0 Then
                    For Each dtrow As DataRow In dtDebitor.Rows
                        Dim wojDet As New WOJobDetailBO()
                        wojDet.Job_Deb_Name = IIf(IsDBNull(dtrow("JOB_DEB_NAME")) = True, "", dtrow("JOB_DEB_NAME"))
                        wojDet.Dbt_Per = IIf(IsDBNull(dtrow("DBT_PER")) = True, "", dtrow("DBT_PER"))
                        wojDet.Dbt_Amt = IIf(IsDBNull(dtrow("DBT_AMT")) = True, "", dtrow("DBT_AMT"))
                        wojDet.Id_Job_Deb = IIf(IsDBNull(dtrow("ID_JOB_DEB")) = True, "", dtrow("ID_JOB_DEB"))
                        wojDet.Id_Deb_Seq = IIf(IsDBNull(dtrow("ID_DBT_SEQ")) = True, 0, dtrow("ID_DBT_SEQ"))
                        wojDet.Deb_Sl_No = IIf(IsDBNull(dtrow("SLNO")) = True, "", dtrow("SLNO"))
                        wojDet.Spare_Count = IIf(IsDBNull(dtrow("SPARECOUNT")) = True, "", dtrow("SPARECOUNT"))
                        wojDet.Org_Per = IIf(IsDBNull(dtrow("ORGPERCENT")) = True, "", dtrow("ORGPERCENT"))
                        wojDet.ErrMsg = strErr
                        details.Add(wojDet)
                    Next
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "Add_DebitorDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function Calculate_Debitordet(ByVal totLabAmt As String, ByVal totSpareAmt As String, ByVal totGmAmt As String, ByVal totVatAmt As String, ByVal totDiscAmt As String, ByVal spVat As String, ByVal fixedPrice As String, ByVal inclFPVat As String, ByVal flgFixedPrice As String, ByVal creditCustomer As String, ByVal jobDisc As String, ByVal debitCustomer As String, ByVal garageMat As String, ByVal chkCreditCustPayVat As String, ByVal chkOwnRisk As String, ByVal ownRiskAmt As String) As List(Of WOJobDetailBO)
            Dim details As New List(Of WOJobDetailBO)()
            Try
                Dim dtWODebtors As New DataTable
                'Dim wojDet As New WOJobDetailBO()
                Dim labAmt, spAmt, gmAmt, totVat, totDisc, spDebVat, fixedVAT, fixedPriceExVAT, totFxdPriceVat, indSPAmt, GMVatAmt, LabVatAmt, custSPAmt As Decimal
                'Dim totLabAmt, totSpareAmt, totGmAmt, totVatAmt, totDiscAmt, spVat, fixedPrice, inclFPVat, flgFixedPrice, creditCustomer As String
                Dim jobDiscount As String
                Dim GMAmtVatAfterDis As Decimal = 0.0
                Dim LabAmtVatAfterDis As Decimal = 0.0
                Dim finalTotal As Decimal = 0.0
                Dim objWOJDetailsBO As New WOJobDetailBO
                Dim dsGMHP As New DataSet
                Dim detailsVat As New List(Of WOJobDetailBO)()
                Dim spVatAmt, totalSPVatAmt, disAmt, totalDisAmt As Decimal
                Dim gmDisAmt, labDisAmt As Decimal

                labAmt = 0
                gmAmt = 0
                custSPAmt = 0
                spAmt = 0
                totVat = 0
                totDisc = 0
                spDebVat = 0
                fixedVAT = 0
                fixedPriceExVAT = 0
                totFxdPriceVat = 0
                indSPAmt = 0
                GMVatAmt = 0
                LabVatAmt = 0

                If (HttpContext.Current.Session("OwnRiskVATPer")) Then
                    HttpContext.Current.Session("OwnRiskVATPer") = 0
                End If

                dtWODebtors = HttpContext.Current.Session("WODebDetails")
                If chkOwnRisk <> "true" Then
                    ownRiskAmt = 0

                End If
                Dim count As Integer = dtWODebtors.Rows.Count

                If (totLabAmt = "") Then
                    labAmt = 0
                Else
                    labAmt = Convert.ToDecimal(totLabAmt)
                End If
                If (totSpareAmt = "") Then
                    spAmt = 0
                Else
                    spAmt = Convert.ToDecimal(totSpareAmt)
                End If
                If (totGmAmt = "") Then
                    gmAmt = 0
                Else
                    gmAmt = Convert.ToDecimal(totGmAmt)
                End If
                If (totVatAmt = "") Then
                    totVat = 0
                Else
                    totVat = Convert.ToDecimal(totVatAmt)
                End If
                If (totDiscAmt = "") Then
                    totDisc = 0
                Else
                    totDisc = Convert.ToDecimal(totDiscAmt)
                End If
                If (spVat = "") Then
                    spDebVat = 0
                Else
                    spDebVat = Convert.ToDecimal(spVat)
                End If

                'labAmt = IIf(totLabAmt = "", 0D, Convert.ToDecimal(totLabAmt))
                'spAmt = IIf(totSpareAmt = "", 0D, Convert.ToDecimal(totSpareAmt))
                'gmAmt = IIf(totGmAmt = "", 0D, Convert.ToDecimal(totGmAmt))
                'totVat = IIf(totVatAmt = "", 0D, Convert.ToDecimal(totVatAmt))
                'totDisc = IIf(totDiscAmt = "", 0D, Convert.ToDecimal(totDiscAmt))
                'spDebVat = IIf(spVat = "", 0D, Convert.ToDecimal(spVat))
                jobDiscount = jobDisc ' IIf(jobDisc = "", 0D, Convert.ToDouble(jobDisc))
                finalTotal = labAmt + spAmt + gmAmt - totDisc

                gmDisAmt = 0.0
                labDisAmt = 0.0
                totalSPVatAmt = 0.0
                totalDisAmt = 0.0
                'spVatAmt = IIf(spVat = "", 0D, Convert.ToDecimal(spVat))
                'disAmt = IIf(totDiscAmt = "", 0D, Convert.ToDecimal(totDiscAmt))

                If Not (HttpContext.Current.Session("LoadGMHP_VAT") Is Nothing) Then
                    dsGMHP = HttpContext.Current.Session("LoadGMHP_VAT")
                Else
                    objWOJDetailsBO.Id_Customer = HttpContext.Current.Session("IdCustomer")
                    objWOJDetailsBO.WO_Id_Veh = HttpContext.Current.Session("Veh_Seq_No")
                    objWOJDetailsBO.Id_Gm_Vat = HttpContext.Current.Session("ID_GMVAT")
                    objWOJDetailsBO.Id_Hp_Vat = HttpContext.Current.Session("ID_HPVAT")
                    objWOJDetailsBO.Created_By = HttpContext.Current.Session("UserID")
                    detailsVat = LoadGMHPVat(objWOJDetailsBO)
                    dsGMHP = HttpContext.Current.Session("LoadGMHP_VAT")
                End If
                If (dsGMHP.Tables.Count > 0) Then
                    If dsGMHP.Tables(4).Rows.Count > 0 Then
                        fixedVAT = Round(Convert.ToDecimal(IIf(fixedPrice = "", 0D, fixedPrice)) * Convert.ToDecimal(IIf(dsGMHP.Tables(4).Rows(0)("FIXED_VAT").ToString() = "", 0D, dsGMHP.Tables(4).Rows(0)("FIXED_VAT").ToString())) * 0.01, 2)
                        If inclFPVat = "True" Then
                            fixedVAT = Round((Convert.ToDecimal(IIf(fixedPrice = "", 0D, fixedPrice)) * 100) / Convert.ToDecimal(IIf(dsGMHP.Tables(4).Rows(0)("FIXED_VAT").ToString() = "", 0D, (dsGMHP.Tables(4).Rows(0)("FIXED_VAT").ToString()) + 100)), 2)
                            fixedVAT = Convert.ToDecimal(IIf(fixedPrice = "", 0D, fixedPrice)) - fixedVAT
                        End If
                    End If
                End If
                If inclFPVat = "true" Then
                    fixedPriceExVAT = IIf(fixedPrice = "", 0D, fixedPrice) - fixedVAT
                Else
                    fixedPriceExVAT = IIf(fixedPrice = "", 0D, fixedPrice)
                End If

                'Smita
                If (flgFixedPrice = "true") Then
                    'chckCustBasedVAT.Enabled = True
                    For Each dr As DataRow In dtWODebtors.Rows
                        If chkCreditCustPayVat = "true" Then
                            If dr("ID_JOB_DEB") = creditCustomer Then
                                If Not IsDBNull(dr("DBT_PER")) Then
                                    dr("DBT_AMT") = Round((fixedPriceExVAT * (0.01 * dr("DBT_PER"))) + fixedVAT + (ownRiskAmt), 2)
                                Else
                                    dr("DBT_AMT") = Round(fixedVAT + (ownRiskAmt), 2)
                                End If
                                dr("WO_VAT_PERCENTAGE") = 1 'Spare part Vat Per
                                dr("WO_GM_PER") = 1 'Garage Material  Percentage
                                dr("WO_GM_VATPER") = 1 'Garage Material Vat Percentage
                                dr("WO_LBR_VATPER") = 1 'Labour Vat Percentage
                                dr("WO_SPR_DISCPER") = 1
                                dr("WO_FIXED_VATPER") = 1 'Fixed Price Vat Percentage
                                dr("JOB VAT") = fixedVAT
                                dr("LABOUR AMOUNT") = 0
                                dr("LABOUR DISCOUNT") = 0
                                dr("GM AMOUNT") = 0
                                dr("GM DISCOUNT") = 0
                                dr("OWN RISK AMOUNT") = ownRiskAmt
                                dr("SP_VAT") = 0
                                dr("SP_AMT_DEB") = 0


                            Else
                                If Not IsDBNull(dr("DBT_PER")) Then
                                    dr("DBT_AMT") = Round((fixedPriceExVAT * (0.01 * dr("DBT_PER"))) - (ownRiskAmt), 2)
                                End If
                                dr("WO_VAT_PERCENTAGE") = 0 'Spare part Vat Per
                                dr("WO_GM_PER") = 0 'Garage Material  Percentage
                                dr("WO_GM_VATPER") = 0 'Garage Material Vat Percentage
                                dr("WO_LBR_VATPER") = 0 'Labour Vat Percentage
                                dr("WO_SPR_DISCPER") = 0
                                dr("WO_FIXED_VATPER") = 0 'Fixed Price Vat Percentage
                                dr("JOB VAT") = 0
                                dr("LABOUR AMOUNT") = 0
                                dr("LABOUR DISCOUNT") = 0
                                dr("GM AMOUNT") = 0
                                dr("GM DISCOUNT") = 0
                                dr("OWN RISK AMOUNT") = 0
                                dr("SP_VAT") = 0
                                dr("SP_AMT_DEB") = 0
                            End If
                        Else
                            If dtWODebtors.Rows.Count = 1 Then
                                totFxdPriceVat = totFxdPriceVat + fixedVAT
                                dr("DBT_AMT") = Round((fixedPriceExVAT * (0.01 * dr("DBT_PER"))) + fixedVAT, 2)
                                dr("WO_VAT_PERCENTAGE") = 1 'Spare part Vat Per
                                dr("WO_GM_PER") = 1 'Garage Material  Percentage
                                dr("WO_GM_VATPER") = 1 'Garage Material Vat Percentage
                                dr("WO_LBR_VATPER") = 1 'Labour Vat Percentage
                                dr("WO_SPR_DISCPER") = 1
                                dr("WO_FIXED_VATPER") = 1 'Fixed Price Vat Percentage
                                dr("JOB VAT") = fixedVAT
                                dr("LABOUR AMOUNT") = 0
                                dr("LABOUR DISCOUNT") = 0
                                dr("GM AMOUNT") = 0
                                dr("GM DISCOUNT") = 0
                                dr("OWN RISK AMOUNT") = 0
                                dr("SP_VAT") = 0
                                dr("SP_AMT_DEB") = 0

                            Else
                                objWOJDetailsBO.Id_Customer = dr("ID_JOB_DEB")
                                objWOJDetailsBO.WO_Id_Veh = ""
                                objWOJDetailsBO.Id_Gm_Vat = ""
                                objWOJDetailsBO.Id_Hp_Vat = ""
                                objWOJDetailsBO.Created_By = HttpContext.Current.Session("UserID")
                                objWOJDetailsBO.Id_Item_Job = ""
                                objWOJDetailsBO.Id_Make_Job = ""
                                LoadGMHPVat(objWOJDetailsBO)
                                dsGMHP = HttpContext.Current.Session("LoadGMHP_VAT")

                                If dsGMHP.Tables(4).Rows.Count > 0 Then
                                    If Not IsDBNull(dr("DBT_PER")) Then
                                        fixedVAT = Round(((fixedPriceExVAT * (0.01 * dr("DBT_PER"))) * dsGMHP.Tables(4).Rows(0)("FIXED_VAT")) / 100, 2)
                                    Else
                                        fixedVAT = 0.0
                                    End If
                                    dr("WO_FIXED_VATPER") = dsGMHP.Tables(4).Rows(0)("FIXED_VAT")
                                Else
                                    fixedVAT = 0.0
                                    dr("WO_FIXED_VATPER") = 0.0
                                End If
                                If Not IsDBNull(dr("DBT_PER")) Then
                                    If dr("ID_JOB_DEB") = creditCustomer Then
                                        dr("DBT_AMT") = Round((fixedPriceExVAT * (0.01 * dr("DBT_PER"))), 2) + fixedVAT + (ownRiskAmt)
                                    Else

                                        dr("DBT_AMT") = Round((fixedPriceExVAT * (0.01 * dr("DBT_PER"))), 2) + fixedVAT - (ownRiskAmt)
                                    End If
                                Else
                                    dr("DBT_AMT") = Round(fixedVAT + (ownRiskAmt), 2)

                                End If
                                totFxdPriceVat = totFxdPriceVat + fixedVAT
                                dr("JOB VAT") = fixedVAT
                                dr("LABOUR AMOUNT") = 0
                                dr("LABOUR DISCOUNT") = 0
                                dr("GM AMOUNT") = 0
                                dr("GM DISCOUNT") = 0
                                If dr("ID_JOB_DEB") = creditCustomer Then
                                    dr("OWN RISK AMOUNT") = ownRiskAmt
                                Else
                                    dr("OWN RISK AMOUNT") = 0
                                End If
                                dr("SP_VAT") = 0
                                dr("SP_AMT_DEB") = 0

                            End If
                        End If
                    Next

                Else '10440
                    'chckCustBasedVAT.Enabled = True
                    If ownRiskAmt Is Nothing Then
                        ownRiskAmt = ""
                    End If
                    If HttpContext.Current.Session("OwnRiskVATAmt") Is Nothing Then
                        HttpContext.Current.Session("OwnRiskVATAmt") = 0
                    End If

                    Dim strDBTPer As String
                    For Each dr As DataRow In dtWODebtors.Rows
                        totalSPVatAmt = 0.0
                        totalDisAmt = 0.0
                        dr("WO_GM_PER") = IIf(garageMat.Length = 0, 0D, garageMat)
                        strDBTPer = IIf(dr("DBT_PER").Equals(""), "", dr("DBT_PER").ToString)

                        If strDBTPer = "0" Then
                            If chkCreditCustPayVat = "true" Then
                                If dr("ID_JOB_DEB") = creditCustomer Then
                                    dr("DBT_AMT") = Round((ownRiskAmt + totVat), 2)
                                Else
                                    dr("DBT_AMT") = 0
                                End If
                            Else
                                dr("DBT_AMT") = IIf(ownRiskAmt.ToString.Length = 0, 0, ownRiskAmt) + IIf(HttpContext.Current.Session("OwnRiskVATAmt").ToString.Length = 0, 0, HttpContext.Current.Session("OwnRiskVATAmt"))
                                ownRiskAmt = ownRiskAmt
                                'txtOwnRisk.Text = Session("OwnRiskAmt")
                            End If

                            dr("WO_VAT_PERCENTAGE") = 1 'Spare part Vat Per
                            dr("WO_GM_PER") = 1 'Garage Material  Percentage
                            dr("WO_GM_VATPER") = 1 'Garage Material Vat Percentage
                            dr("WO_LBR_VATPER") = 1 'Labour Vat Percentage
                            dr("WO_SPR_DISCPER") = 1
                            dr("WO_FIXED_VATPER") = 1 'Fixed Price Vat Percentage
                            dr("WO_FIXED_VATPER") = 1 'Fixed Price Vat Percentage

                            dr("LABOUR AMOUNT") = 0
                            dr("LABOUR DISCOUNT") = 0
                            dr("GM AMOUNT") = 0
                            dr("GM DISCOUNT") = 0
                            dr("OWN RISK AMOUNT") = ownRiskAmt


                            If chkCreditCustPayVat = "true" Then
                                dr("JOB VAT") = totVat
                                dr("SP_VAT") = spDebVat
                            Else
                                dr("JOB VAT") = 0
                                dr("SP_VAT") = 0
                            End If
                            dr("SP_AMT_DEB") = 0
                            count = count - 1

                        Else
                            If chkCreditCustPayVat = "true" Then
                                If dr("DBT_PER").ToString <> "" And dr("DBT_PER").ToString <> "0.00000" And dr("DBT_PER").ToString <> "0,00000" Then
                                    Dim dtSpare As DataTable
                                    dtSpare = CType(HttpContext.Current.Session("WOSpareDetails"), DataTable)
                                    If Not dtSpare Is Nothing Then
                                        For Each drSP As DataRow In dtSpare.Rows
                                            Dim dsCust As DataSet = Nothing
                                            Dim Selling_Price As Decimal
                                            dsCust = objWOJDO.Cust_CostPriceDetails(dr("ID_JOB_DEB").ToString)
                                            If dsCust.Tables(0).Rows.Count > 0 Then
                                                If dsCust.Tables(0).Rows(0)("FLG_CPRICE") = True And drSP("SPARE_TYPE") <> "EFD" And IIf(IsDBNull(drSP("FLG_EDIT_SP")) = True, False, drSP("FLG_EDIT_SP")) = False Then
                                                    Selling_Price = drSP("COST_PRICE") + (drSP("COST_PRICE") * CDbl(dsCust.Tables(0).Rows(0)("CUST_COSTPRICE")) / 100)
                                                Else
                                                    Selling_Price = drSP("JOBI_SELL_PRICE")
                                                End If
                                            End If
                                            indSPAmt = drSP("JOBI_DELIVER_QTY") * Selling_Price
                                            If IsDBNull(drSP("ID_ITEM")) Then
                                                Continue For
                                            Else
                                                objWOJDetailsBO.Id_Customer = dr("ID_JOB_DEB")
                                                objWOJDetailsBO.WO_Id_Veh = HttpContext.Current.Session("Veh_Seq_No")
                                                objWOJDetailsBO.Id_Gm_Vat = HttpContext.Current.Session("ID_GMVAT")
                                                objWOJDetailsBO.Id_Hp_Vat = HttpContext.Current.Session("ID_HPVAT")
                                                objWOJDetailsBO.Created_By = HttpContext.Current.Session("UserID")
                                                objWOJDetailsBO.Id_Item_Job = drSP("ID_ITEM")
                                                objWOJDetailsBO.Id_Make_Job = drSP("ID_Make")
                                                LoadGMHPVat(objWOJDetailsBO)
                                                dsGMHP = HttpContext.Current.Session("LoadGMHP_VAT")
                                            End If
                                            If dr("ID_JOB_DEB") = debitCustomer Then
                                                Dim disPet As Double = objCommonUtil.ConvertStr(objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), drSP("JOBI_DIS_PER")))
                                                If dr("DBT_PER").ToString.Length <> 0 Then
                                                    disAmt = Round(((indSPAmt * (0.01 * dr("DBT_PER"))) * disPet) / 100, 2)
                                                Else
                                                    disAmt = 0.0
                                                End If

                                                totalDisAmt = totalDisAmt + disAmt

                                                dr("WO_SPR_DISCPER") = disPet
                                            Else
                                                If Not IsDBNull(dr("DBT_PER")) Then
                                                    Dim disPet As Double = objCommonUtil.ConvertStr(objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), drSP("JOBI_DIS_PER")))
                                                    disAmt = Round(((indSPAmt * (0.01 * dr("DBT_PER"))) * disPet) / 100, 2)
                                                    dr("WO_SPR_DISCPER") = disPet
                                                    totalDisAmt = totalDisAmt + disAmt
                                                End If
                                            End If

                                            If dsGMHP.Tables(2).Rows.Count > 0 Then
                                                If dr("DBT_PER").ToString = "" Then
                                                    spVatAmt = 0
                                                Else
                                                    spVatAmt = Round((((indSPAmt * (0.01 * dr("DBT_PER")) - disAmt)) * dsGMHP.Tables(2).Rows(0)("SP_VAT")) / 100, 2)
                                                End If
                                                totalSPVatAmt = totalSPVatAmt + spVatAmt

                                                dr("WO_VAT_PERCENTAGE") = dsGMHP.Tables(2).Rows(0)("SP_VAT")
                                            Else
                                                spVatAmt = 0.0
                                                dr("WO_VAT_PERCENTAGE") = 0.0
                                            End If
                                        Next
                                        If dsGMHP.Tables(1).Rows.Count > 0 Then

                                            If dr("DBT_PER").ToString <> "" Then
                                                gmDisAmt = Round(((gmAmt * (0.01 * dr("DBT_PER"))) * IIf(jobDiscount.ToString.Length = 0, 0, jobDiscount.ToString) / 100), 2)
                                                If gmDisAmt = 0.0 Then
                                                    If dr("WO_SPR_DISCPER") <> 0.0 Then
                                                        GMAmtVatAfterDis = Round((gmAmt * 0.01 * dsGMHP.Tables(1).Rows(0)("GM_VAT")), 2) - gmDisAmt
                                                        GMVatAmt = Round(((GMAmtVatAfterDis) * dr("DBT_PER")) / 100, 2)

                                                    Else

                                                        GMAmtVatAfterDis = Round((gmAmt * 0.01 * dsGMHP.Tables(1).Rows(0)("GM_VAT")), 2) - gmDisAmt
                                                        GMVatAmt = Round(((GMAmtVatAfterDis) * dr("DBT_PER")) / 100, 2)
                                                    End If

                                                Else
                                                    GMAmtVatAfterDis = Round((gmAmt * 0.01 * dr("DBT_PER")), 2) - gmDisAmt
                                                    GMVatAmt = Round(((GMAmtVatAfterDis) * dsGMHP.Tables(1).Rows(0)("GM_VAT")) / 100, 2)
                                                End If
                                            Else
                                                GMVatAmt = 0
                                            End If

                                            dr("WO_GM_VATPER") = dsGMHP.Tables(1).Rows(0)("GM_VAT")
                                        Else
                                            GMVatAmt = 0.0
                                            dr("WO_GM_VATPER") = 0.0
                                        End If

                                        If dsGMHP.Tables(0).Rows.Count > 0 Then
                                            If dr("DBT_PER").ToString <> "" Then
                                                labDisAmt = Round(((labAmt * (0.01 * dr("DBT_PER"))) * IIf(jobDiscount.ToString.Length = 0, 0, jobDiscount.ToString) / 100), 2)
                                                If labDisAmt = 0.0 Then
                                                    If dr("WO_SPR_DISCPER") <> 0.0 Then
                                                        LabAmtVatAfterDis = Round((labAmt * 0.01 * dsGMHP.Tables(0).Rows(0)("HP_VAT")), 2) - labDisAmt
                                                        LabVatAmt = Round(((LabAmtVatAfterDis) * dr("DBT_PER")) / 100, 2)
                                                    Else
                                                        LabAmtVatAfterDis = Round((labAmt * 0.01 * dsGMHP.Tables(0).Rows(0)("HP_VAT")), 2) - labDisAmt
                                                        LabVatAmt = Round(((LabAmtVatAfterDis) * dr("DBT_PER")) / 100, 2)

                                                    End If

                                                Else
                                                    LabAmtVatAfterDis = Round((labAmt * 0.01 * dr("DBT_PER")), 2) - labDisAmt
                                                    LabVatAmt = Round(((LabAmtVatAfterDis) * dsGMHP.Tables(0).Rows(0)("HP_VAT")) / 100, 2)
                                                End If
                                            Else
                                                LabVatAmt = 0
                                            End If
                                            dr("WO_LBR_VATPER") = dsGMHP.Tables(0).Rows(0)("HP_VAT")
                                        Else
                                            LabVatAmt = 0.0
                                            dr("WO_LBR_VATPER") = 0.0
                                        End If
                                        dr("WO_FIXED_VATPER") = 0.0 'Fixed Price Vat Percentage                                        
                                    Else
                                        dr("WO_SPR_DISCPER") = 0.0
                                        dr("WO_VAT_PERCENTAGE") = 0.0
                                        objWOJDetailsBO.Id_Customer = dr("ID_JOB_DEB")
                                        objWOJDetailsBO.WO_Id_Veh = HttpContext.Current.Session("Veh_Seq_No")
                                        objWOJDetailsBO.Id_Gm_Vat = HttpContext.Current.Session("ID_GMVAT")
                                        objWOJDetailsBO.Id_Hp_Vat = HttpContext.Current.Session("ID_HPVAT")
                                        objWOJDetailsBO.Id_Item = ""
                                        objWOJDetailsBO.Id_Make = ""
                                        objWOJDetailsBO.Created_By = HttpContext.Current.Session("UserID")
                                        LoadGMHPVat(objWOJDetailsBO)
                                        dsGMHP = HttpContext.Current.Session("LoadGMHP_VAT")
                                        If dsGMHP.Tables(1).Rows.Count > 0 Then

                                            If dr("DBT_PER").ToString <> "" Then
                                                gmDisAmt = Round(((gmAmt * (0.01 * dr("DBT_PER"))) * IIf(jobDiscount.ToString.Length = 0, 0, jobDiscount.ToString) / 100), 2)
                                                If gmDisAmt = 0.0 Then
                                                    GMAmtVatAfterDis = Round((gmAmt * 0.01 * dsGMHP.Tables(1).Rows(0)("GM_VAT")), 2) - gmDisAmt
                                                    GMVatAmt = Round(((GMAmtVatAfterDis) * dr("DBT_PER")) / 100, 2)
                                                Else
                                                    GMAmtVatAfterDis = Round((gmAmt * 0.01 * dr("DBT_PER")), 2) - gmDisAmt
                                                    GMVatAmt = Round(((GMAmtVatAfterDis) * dsGMHP.Tables(1).Rows(0)("GM_VAT")) / 100, 2)
                                                End If

                                            Else
                                                GMVatAmt = 0
                                            End If
                                            dr("WO_GM_VATPER") = dsGMHP.Tables(1).Rows(0)("GM_VAT")
                                        Else
                                            GMVatAmt = 0.0
                                            dr("WO_GM_VATPER") = 0.0
                                        End If

                                        If dsGMHP.Tables(0).Rows.Count > 0 Then
                                            If dr("DBT_PER").ToString <> "" Then
                                                labDisAmt = Round(((labAmt * (0.01 * dr("DBT_PER"))) * IIf(jobDiscount.ToString.Length = 0, 0, jobDiscount.ToString) / 100), 2)
                                                LabAmtVatAfterDis = Round((labAmt * 0.01 * dr("DBT_PER")), 2) - labDisAmt
                                                LabVatAmt = Round(((LabAmtVatAfterDis) * dsGMHP.Tables(0).Rows(0)("HP_VAT")) / 100, 2)
                                            Else
                                                LabVatAmt = 0
                                            End If
                                            dr("WO_LBR_VATPER") = dsGMHP.Tables(0).Rows(0)("HP_VAT")
                                        Else
                                            LabVatAmt = 0.0
                                            dr("WO_LBR_VATPER") = 0.0
                                        End If
                                        dr("WO_FIXED_VATPER") = 0.0 'Fixed Price Vat Percentage                                       
                                    End If
                                    If (dr("DBT_PER").ToString = "0.00000" Or dr("DBT_PER").ToString = "0,00000") Or dr("DBT_PER").ToString.Length = 0 Then
                                        dr("DBT_AMT") = ownRiskAmt + IIf(HttpContext.Current.Session("OwnRiskVATAmt").ToString.Length = 0, 0, HttpContext.Current.Session("OwnRiskVATAmt"))
                                        ownRiskAmt = ownRiskAmt
                                        'txtOwnRisk.Text = Session("OwnRiskAmt")
                                        HttpContext.Current.Session("OwnRiskVATAmt") = 0
                                    Else
                                        If ownRiskAmt = "" Then
                                            ownRiskAmt = 0
                                        End If
                                        If chkOwnRisk = "true" Then
                                            ownRiskAmt = ownRiskAmt
                                        End If

                                        Dim TotDisAmt As Decimal
                                        TotDisAmt = totalDisAmt + gmDisAmt + labDisAmt
                                        If Not dtSpare Is Nothing Then
                                            For Each drSP As DataRow In dtSpare.Rows
                                                Dim dsCust As DataSet = Nothing
                                                Dim Selling_Price As Decimal
                                                dsCust = objWOJDO.Cust_CostPriceDetails(dr("ID_JOB_DEB").ToString)

                                                If dsCust.Tables(0).Rows.Count > 0 Then
                                                    If dsCust.Tables(0).Rows(0)("FLG_CPRICE") = True And drSP("SPARE_TYPE") <> "EFD" And IIf(IsDBNull(drSP("FLG_EDIT_SP")) = True, False, drSP("FLG_EDIT_SP")) = False Then
                                                        Selling_Price = drSP("COST_PRICE") + (drSP("COST_PRICE") * CDbl(dsCust.Tables(0).Rows(0)("CUST_COSTPRICE")) / 100)
                                                    Else
                                                        Selling_Price = drSP("JOBI_SELL_PRICE")
                                                    End If
                                                End If
                                                custSPAmt += drSP("JOBI_DELIVER_QTY") * Selling_Price

                                            Next
                                        End If

                                        If dr("ID_JOB_DEB") = creditCustomer Then
                                            If dr("DBT_PER").ToString = "" Then
                                                dr("DBT_AMT") = Round((ownRiskAmt + totVat), 2)
                                            Else
                                                If dr("DBT_PER") > 0 Then
                                                    dr("DBT_AMT") = Round(((labAmt + gmAmt + custSPAmt - ownRiskAmt) * (0.01 * dr("DBT_PER"))) - TotDisAmt + totVat + ((ownRiskAmt * IIf(HttpContext.Current.Session("OwnRiskVATPer").ToString.Length = 0, 0, 100) / (HttpContext.Current.Session("OwnRiskVATPer") + 100))), 2)
                                                Else
                                                    dr("DBT_AMT") = Round((HttpContext.Current.Session("OwnRiskAmt") + totVat), 2)
                                                End If
                                            End If
                                        Else
                                            dr("DBT_AMT") = Round(((labAmt + gmAmt + custSPAmt - ownRiskAmt) * (0.01 * IIf(dr("DBT_PER").ToString.Length = 0, 0, dr("DBT_PER").ToString))) - TotDisAmt - IIf(HttpContext.Current.Session("OwnRiskVATAmt").ToString().Length = 0, 0, HttpContext.Current.Session("OwnRiskVATAmt")), 2)

                                        End If
                                    End If
                                Else
                                    If IsDBNull(dr("DBT_PER")) = True Then
                                        dr("DBT_AMT") = Round((ownRiskAmt + totVat), 2)
                                    Else
                                        If dr("DBT_PER") > 0 Then
                                            dr("DBT_AMT") = Round(((finalTotal - ownRiskAmt) * (0.01 * dr("DBT_PER"))) + totVat + ((ownRiskAmt * IIf(HttpContext.Current.Session("OwnRiskVATPer").ToString.Length = 0, 0, 100) / (HttpContext.Current.Session("OwnRiskVATPer") + 100))), 2)
                                        Else
                                            dr("DBT_AMT") = Round((ownRiskAmt + totVat), 2)
                                        End If
                                    End If
                                End If
                                If dr("ID_JOB_DEB") = creditCustomer Then

                                    dr("WO_VAT_PERCENTAGE") = 1 'Spare part Vat Per
                                    dr("WO_GM_PER") = 1 'Garage Material  Percentage
                                    dr("WO_GM_VATPER") = 1 'Garage Material Vat Percentage
                                    dr("WO_LBR_VATPER") = 1 'Labour Vat Percentage
                                    dr("WO_SPR_DISCPER") = 1
                                    dr("WO_FIXED_VATPER") = 1 'Fixed Price Vat Percentage
                                    dr("JOB VAT") = totVat
                                    dr("LABOUR AMOUNT") = labAmt * (0.01 * IIf(dr("DBT_PER").ToString.Length = 0, 0, dr("DBT_PER").ToString))
                                    dr("LABOUR DISCOUNT") = labDisAmt
                                    dr("GM AMOUNT") = gmAmt * (0.01 * IIf(dr("DBT_PER").ToString.Length = 0, 0, dr("DBT_PER").ToString))
                                    dr("GM DISCOUNT") = gmDisAmt
                                    dr("OWN RISK AMOUNT") = ownRiskAmt

                                    dr("SP_VAT") = spDebVat
                                    dr("SP_AMT_DEB") = 0
                                Else
                                    dr("WO_VAT_PERCENTAGE") = 0 'Spare part Vat Per
                                    dr("WO_GM_PER") = 0 'Garage Material  Percentage
                                    dr("WO_GM_VATPER") = 0 'Garage Material Vat Percentage
                                    dr("WO_LBR_VATPER") = 0 'Labour Vat Percentage
                                    dr("WO_SPR_DISCPER") = 0
                                    dr("WO_FIXED_VATPER") = 0 'Fixed Price Vat Percentage
                                    dr("JOB VAT") = 0
                                    dr("LABOUR AMOUNT") = labAmt * (0.01 * IIf(dr("DBT_PER").ToString.Length = 0, 0, dr("DBT_PER").ToString))
                                    dr("LABOUR DISCOUNT") = labDisAmt
                                    dr("GM AMOUNT") = gmAmt * (0.01 * IIf(dr("DBT_PER").ToString.Length = 0, 0, dr("DBT_PER").ToString))
                                    dr("GM DISCOUNT") = gmDisAmt
                                    dr("OWN RISK AMOUNT") = 0
                                    dr("SP_VAT") = 0
                                    dr("SP_AMT_DEB") = custSPAmt * (0.01 * IIf(dr("DBT_PER").ToString.Length = 0, 0, dr("DBT_PER").ToString))
                                    custSPAmt = 0.0
                                End If
                            Else

                                If dtWODebtors.Rows.Count = 1 Then
                                    dr("DBT_AMT") = Round((finalTotal * (0.01 * IIf(dr("DBT_PER").ToString.Length = 0, 0, dr("DBT_PER").ToString))) + totVat, 2)
                                    dr("WO_VAT_PERCENTAGE") = 1 'Spare part Vat Per
                                    dr("WO_GM_PER") = 1 'Garage Material  Percentage
                                    dr("WO_GM_VATPER") = 1 'Garage Material Vat Percentage
                                    dr("WO_LBR_VATPER") = 1 'Labour Vat Percentage
                                    dr("WO_SPR_DISCPER") = 1
                                    dr("WO_FIXED_VATPER") = 1 'Fixed Price Vat Percentage
                                    If dr("DBT_PER").ToString <> "" Then
                                        gmDisAmt = Round(((gmAmt * (0.01 * dr("DBT_PER"))) * IIf(jobDiscount.ToString.Length = 0, 0, jobDiscount.ToString) / 100), 2)
                                        labDisAmt = Round(((labAmt * (0.01 * dr("DBT_PER"))) * IIf(jobDiscount.ToString.Length = 0, 0, jobDiscount.ToString) / 100), 2)
                                    End If
                                    dr("JOB VAT") = totVat * (0.01 * IIf(dr("DBT_PER").ToString.Length = 0, 0, dr("DBT_PER").ToString))
                                    dr("LABOUR AMOUNT") = labAmt * (0.01 * IIf(dr("DBT_PER").ToString.Length = 0, 0, dr("DBT_PER").ToString))
                                    dr("LABOUR DISCOUNT") = labDisAmt
                                    dr("GM AMOUNT") = gmAmt * (0.01 * IIf(dr("DBT_PER").ToString.Length = 0, 0, dr("DBT_PER").ToString))
                                    dr("GM DISCOUNT") = gmDisAmt
                                    dr("OWN RISK AMOUNT") = 0
                                    dr("SP_VAT") = spDebVat
                                    dr("SP_AMT_DEB") = spAmt
                                Else
                                    Dim dsSpare As DataTable
                                    dsSpare = CType(HttpContext.Current.Session("WOSpareDetails"), DataTable)
                                    If Not dsSpare Is Nothing Then
                                        For Each drSP As DataRow In dsSpare.Rows
                                            Dim dsCust As DataSet = Nothing
                                            Dim Selling_Price As Decimal
                                            dsCust = objWOJDO.Cust_CostPriceDetails(dr("ID_JOB_DEB").ToString)
                                            If dsCust.Tables(0).Rows.Count > 0 Then
                                                If dsCust.Tables(0).Rows(0)("FLG_CPRICE") = True And drSP("SPARE_TYPE") <> "EFD" And IIf(IsDBNull(drSP("FLG_EDIT_SP")) = True, False, drSP("FLG_EDIT_SP")) = False Then
                                                    Selling_Price = drSP("COST_PRICE") + (drSP("COST_PRICE") * CDbl(dsCust.Tables(0).Rows(0)("CUST_COSTPRICE")) / 100)
                                                Else
                                                    Selling_Price = drSP("JOBI_SELL_PRICE")
                                                End If
                                            End If
                                            indSPAmt = drSP("JOBI_DELIVER_QTY") * Selling_Price
                                            If IsDBNull(drSP("ID_ITEM")) Then
                                                Continue For
                                            Else
                                                objWOJDetailsBO.Id_Customer = dr("ID_JOB_DEB")
                                                objWOJDetailsBO.WO_Id_Veh = HttpContext.Current.Session("Veh_Seq_No")
                                                objWOJDetailsBO.Id_Gm_Vat = HttpContext.Current.Session("ID_GMVAT")
                                                objWOJDetailsBO.Id_Hp_Vat = HttpContext.Current.Session("ID_HPVAT")
                                                objWOJDetailsBO.Id_Item = drSP("ID_ITEM")
                                                objWOJDetailsBO.Id_Make = drSP("ID_Make")
                                                objWOJDetailsBO.Created_By = HttpContext.Current.Session("UserID")
                                                LoadGMHPVat(objWOJDetailsBO)
                                                dsGMHP = HttpContext.Current.Session("LoadGMHP_VAT")
                                            End If
                                            If dr("ID_JOB_DEB") = debitCustomer Then
                                                Dim disPet As Double = objCommonUtil.ConvertStr(objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), drSP("JOBI_DIS_PER")))
                                                If dr("DBT_PER").ToString.Length <> 0 Then
                                                    disAmt = Round(((indSPAmt * (0.01 * dr("DBT_PER"))) * disPet) / 100, 2)
                                                Else
                                                    disAmt = 0.0
                                                End If

                                                totalDisAmt = totalDisAmt + disAmt

                                                dr("WO_SPR_DISCPER") = disPet
                                            Else
                                                If Not IsDBNull(dr("DBT_PER")) Then
                                                    Dim disPet As Double = objCommonUtil.ConvertStr(objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), drSP("JOBI_DIS_PER")))
                                                    disAmt = Round(((indSPAmt * (0.01 * dr("DBT_PER"))) * disPet) / 100, 2)
                                                    dr("WO_SPR_DISCPER") = disPet
                                                    totalDisAmt = totalDisAmt + disAmt
                                                End If
                                            End If

                                            If dsGMHP.Tables(2).Rows.Count > 0 Then
                                                If dr("DBT_PER").ToString = "" Then
                                                    spVatAmt = 0
                                                Else
                                                    spVatAmt = Round((((indSPAmt * (0.01 * dr("DBT_PER")) - disAmt)) * dsGMHP.Tables(2).Rows(0)("SP_VAT")) / 100, 2)
                                                End If
                                                totalSPVatAmt = totalSPVatAmt + spVatAmt

                                                dr("WO_VAT_PERCENTAGE") = dsGMHP.Tables(2).Rows(0)("SP_VAT")
                                            Else
                                                spVatAmt = 0.0
                                                dr("WO_VAT_PERCENTAGE") = 0.0
                                            End If
                                        Next
                                        If dsGMHP.Tables(1).Rows.Count > 0 Then

                                            If dr("DBT_PER").ToString <> "" Then
                                                gmDisAmt = Round(((gmAmt * (0.01 * dr("DBT_PER"))) * IIf(jobDiscount.ToString.Length = 0, 0, jobDiscount.ToString) / 100), 2)
                                                If gmDisAmt = 0.0 Then
                                                    If dr("WO_SPR_DISCPER") <> 0.0 Then
                                                        GMAmtVatAfterDis = Round((gmAmt * 0.01 * dsGMHP.Tables(1).Rows(0)("GM_VAT")), 2) - gmDisAmt
                                                        GMVatAmt = Round(((GMAmtVatAfterDis) * dr("DBT_PER")) / 100, 2)

                                                    Else

                                                        GMAmtVatAfterDis = Round((gmAmt * 0.01 * dsGMHP.Tables(1).Rows(0)("GM_VAT")), 2) - gmDisAmt
                                                        GMVatAmt = Round(((GMAmtVatAfterDis) * dr("DBT_PER")) / 100, 2)
                                                    End If

                                                Else
                                                    GMAmtVatAfterDis = Round((gmAmt * 0.01 * dr("DBT_PER")), 2) - gmDisAmt
                                                    GMVatAmt = Round(((GMAmtVatAfterDis) * dsGMHP.Tables(1).Rows(0)("GM_VAT")) / 100, 2)
                                                End If
                                            Else
                                                GMVatAmt = 0
                                            End If

                                            dr("WO_GM_VATPER") = dsGMHP.Tables(1).Rows(0)("GM_VAT")
                                        Else
                                            GMVatAmt = 0.0
                                            dr("WO_GM_VATPER") = 0.0
                                        End If

                                        If dsGMHP.Tables(0).Rows.Count > 0 Then
                                            If dr("DBT_PER").ToString <> "" Then
                                                labDisAmt = Round(((labAmt * (0.01 * dr("DBT_PER"))) * IIf(jobDiscount.ToString.Length = 0, 0, jobDiscount.ToString) / 100), 2)
                                                If labDisAmt = 0.0 Then
                                                    If dr("WO_SPR_DISCPER") <> 0.0 Then
                                                        LabAmtVatAfterDis = Round((labAmt * 0.01 * dsGMHP.Tables(0).Rows(0)("HP_VAT")), 2) - labDisAmt
                                                        LabVatAmt = Round(((LabAmtVatAfterDis) * dr("DBT_PER")) / 100, 2)
                                                    Else
                                                        LabAmtVatAfterDis = Round((labAmt * 0.01 * dsGMHP.Tables(0).Rows(0)("HP_VAT")), 2) - labDisAmt
                                                        LabVatAmt = Round(((LabAmtVatAfterDis) * dr("DBT_PER")) / 100, 2)

                                                    End If

                                                Else
                                                    LabAmtVatAfterDis = Round((labAmt * 0.01 * dr("DBT_PER")), 2) - labDisAmt
                                                    LabVatAmt = Round(((LabAmtVatAfterDis) * dsGMHP.Tables(0).Rows(0)("HP_VAT")) / 100, 2)
                                                End If
                                            Else
                                                LabVatAmt = 0
                                            End If
                                            dr("WO_LBR_VATPER") = dsGMHP.Tables(0).Rows(0)("HP_VAT")
                                        Else
                                            LabVatAmt = 0.0
                                            dr("WO_LBR_VATPER") = 0.0
                                        End If
                                        dr("WO_FIXED_VATPER") = 0.0 'Fixed Price Vat Percentage                                        
                                    Else
                                        dr("WO_SPR_DISCPER") = 0.0
                                        dr("WO_VAT_PERCENTAGE") = 0.0
                                        objWOJDetailsBO.Id_Customer = dr("ID_JOB_DEB")
                                        objWOJDetailsBO.WO_Id_Veh = HttpContext.Current.Session("Veh_Seq_No")
                                        objWOJDetailsBO.Id_Gm_Vat = HttpContext.Current.Session("ID_GMVAT")
                                        objWOJDetailsBO.Id_Hp_Vat = HttpContext.Current.Session("ID_HPVAT")
                                        objWOJDetailsBO.Id_Item = ""
                                        objWOJDetailsBO.Id_Make = ""
                                        objWOJDetailsBO.Created_By = HttpContext.Current.Session("UserID")
                                        LoadGMHPVat(objWOJDetailsBO)
                                        dsGMHP = HttpContext.Current.Session("LoadGMHP_VAT")
                                        'Load_GMHP_VAT(dr("IOBD_J_DEB"), "", "")
                                        If dsGMHP.Tables(1).Rows.Count > 0 Then

                                            If dr("DBT_PER").ToString <> "" Then
                                                gmDisAmt = Round(((gmAmt * (0.01 * dr("DBT_PER"))) * IIf(jobDiscount.ToString.Length = 0, 0, jobDiscount.ToString) / 100), 2)
                                                If gmDisAmt = 0.0 Then
                                                    GMAmtVatAfterDis = Round((gmAmt * 0.01 * dsGMHP.Tables(1).Rows(0)("GM_VAT")), 2) - gmDisAmt
                                                    GMVatAmt = Round(((GMAmtVatAfterDis) * dr("DBT_PER")) / 100, 2)
                                                Else
                                                    GMAmtVatAfterDis = Round((gmAmt * 0.01 * dr("DBT_PER")), 2) - gmDisAmt
                                                    GMVatAmt = Round(((GMAmtVatAfterDis) * dsGMHP.Tables(1).Rows(0)("GM_VAT")) / 100, 2)
                                                End If

                                            Else
                                                GMVatAmt = 0
                                            End If
                                            dr("WO_GM_VATPER") = dsGMHP.Tables(1).Rows(0)("GM_VAT")
                                        Else
                                            GMVatAmt = 0.0
                                            dr("WO_GM_VATPER") = 0.0
                                        End If

                                        If dsGMHP.Tables(0).Rows.Count > 0 Then
                                            If dr("DBT_PER").ToString <> "" Then
                                                labDisAmt = Round(((labAmt * (0.01 * dr("DBT_PER"))) * IIf(jobDiscount.ToString.Length = 0, 0, jobDiscount.ToString) / 100), 2)
                                                LabAmtVatAfterDis = Round((labAmt * 0.01 * dr("DBT_PER")), 2) - labDisAmt
                                                LabVatAmt = Round(((LabAmtVatAfterDis) * dsGMHP.Tables(0).Rows(0)("HP_VAT")) / 100, 2)
                                            Else
                                                LabVatAmt = 0
                                            End If
                                            dr("WO_LBR_VATPER") = dsGMHP.Tables(0).Rows(0)("HP_VAT")
                                        Else
                                            LabVatAmt = 0.0
                                            dr("WO_LBR_VATPER") = 0.0
                                        End If
                                        dr("WO_FIXED_VATPER") = 0.0 'Fixed Price Vat Percentage                                       
                                    End If
                                    If (dr("DBT_PER").ToString = "0.00000" Or dr("DBT_PER").ToString = "0,00000") Or dr("DBT_PER").ToString.Length = 0 Then
                                        dr("DBT_AMT") = ownRiskAmt + IIf(HttpContext.Current.Session("OwnRiskVATAmt").ToString.Length = 0, 0, HttpContext.Current.Session("OwnRiskVATAmt"))
                                        ownRiskAmt = ownRiskAmt
                                        'txtOwnRisk.Text = Session("OwnRiskAmt")
                                        HttpContext.Current.Session("OwnRiskVATAmt") = 0
                                        dr("JOB VAT") = 0
                                        dr("LABOUR AMOUNT") = 0
                                        dr("LABOUR DISCOUNT") = 0
                                        dr("GM AMOUNT") = 0
                                        dr("GM DISCOUNT") = 0
                                        dr("OWN RISK AMOUNT") = HttpContext.Current.Session("OwnRiskAmt")
                                        dr("SP_VAT") = 0
                                        dr("SP_AMT_DEB") = 0
                                    Else
                                        If ownRiskAmt.ToString = "" Then ownRiskAmt = 0
                                        Dim TotDisAmt As Decimal
                                        TotDisAmt = totalDisAmt + gmDisAmt + labDisAmt
                                        TotDisAmt = Round(TotDisAmt, 2)
                                        If Not dsSpare Is Nothing Then
                                            For Each drSP As DataRow In dsSpare.Rows
                                                Dim dsCust As DataSet = Nothing
                                                Dim Selling_Price As Decimal
                                                dsCust = objWOJDO.Cust_CostPriceDetails(dr("ID_JOB_DEB").ToString)
                                                If dsCust.Tables(0).Rows.Count > 0 Then
                                                    If dsCust.Tables(0).Rows(0)("FLG_CPRICE") = True And drSP("SPARE_TYPE") <> "EFD" And IIf(IsDBNull(drSP("FLG_EDIT_SP")) = True, False, drSP("FLG_EDIT_SP")) = False Then
                                                        Selling_Price = drSP("COST_PRICE") + (drSP("COST_PRICE") * CDbl(dsCust.Tables(0).Rows(0)("CUST_COSTPRICE")) / 100)
                                                    Else
                                                        Selling_Price = drSP("JOBI_SELL_PRICE")
                                                    End If
                                                End If
                                                custSPAmt += drSP("JOBI_DELIVER_QTY") * Selling_Price

                                            Next
                                        End If

                                        dr("DBT_AMT") = Round(((labAmt + gmAmt + custSPAmt - ownRiskAmt) * (0.01 * IIf(dr("DBT_PER").ToString.Length = 0, 0, dr("DBT_PER").ToString))) + (LabVatAmt + GMVatAmt + totalSPVatAmt) - TotDisAmt - IIf(HttpContext.Current.Session("OwnRiskVATAmt").ToString().Length = 0, 0, HttpContext.Current.Session("OwnRiskVATAmt")), 2)
                                        dr("JOB VAT") = LabVatAmt + GMVatAmt + totalSPVatAmt
                                        dr("LABOUR AMOUNT") = labAmt * (0.01 * IIf(dr("DBT_PER").ToString.Length = 0, 0, dr("DBT_PER").ToString))
                                        dr("LABOUR DISCOUNT") = labDisAmt
                                        dr("GM AMOUNT") = gmAmt * (0.01 * IIf(dr("DBT_PER").ToString.Length = 0, 0, dr("DBT_PER").ToString))
                                        dr("GM DISCOUNT") = gmDisAmt
                                        dr("OWN RISK AMOUNT") = 0
                                        dr("SP_VAT") = totalSPVatAmt
                                        dr("SP_AMT_DEB") = custSPAmt * (0.01 * IIf(dr("DBT_PER").ToString.Length = 0, 0, dr("DBT_PER").ToString))
                                        custSPAmt = 0.0
                                    End If

                                End If
                            End If
                        End If
                    Next
                End If

                'Smita
                HttpContext.Current.Session("WODebDetails") = dtWODebtors

                If dtWODebtors.Rows.Count > 0 Then
                    For Each dtrow As DataRow In dtWODebtors.Rows
                        Dim wojDet As New WOJobDetailBO()
                        wojDet.Job_Deb_Name = IIf(IsDBNull(dtrow("JOB_DEB_NAME")) = True, "", dtrow("JOB_DEB_NAME"))
                        wojDet.Dbt_Per = IIf(IsDBNull(dtrow("DBT_PER")) = True, "0", dtrow("DBT_PER"))
                        wojDet.Dbt_Amt = IIf(IsDBNull(dtrow("DBT_AMT")) = True, "0", dtrow("DBT_AMT"))
                        wojDet.Id_Job_Deb = IIf(IsDBNull(dtrow("ID_JOB_DEB")) = True, "0", dtrow("ID_JOB_DEB"))
                        wojDet.Id_Deb_Seq = IIf(IsDBNull(dtrow("ID_DBT_SEQ")) = True, 0, dtrow("ID_DBT_SEQ"))
                        wojDet.Deb_Sl_No = IIf(IsDBNull(dtrow("SLNO")) = True, "1", dtrow("SLNO"))
                        wojDet.Spare_Count = IIf(IsDBNull(dtrow("SPARECOUNT")) = True, "0", dtrow("SPARECOUNT"))
                        wojDet.Org_Per = IIf(IsDBNull(dtrow("ORGPERCENT")) = True, "0", dtrow("ORGPERCENT"))

                        details.Add(wojDet)
                    Next
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "Calculate_Debitordet", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function Save_WOJobDetails(ByVal dtWODebtors As DataTable, ByVal dtWOSpareParts As DataTable, ByVal dtWOSparePartsDebitor As DataTable, ByVal objWOJBO As WOJobDetailBO, ByVal mode As String, ByVal dtWOMechanics As DataTable) As String()
            Dim strResult As String()
            Try
                Dim strXMLSpareParts As String
                Dim objdtSpare As DataTable = Nothing
                objdtSpare = dtWOSpareParts
                strXMLSpareParts = "<root>" '---changed
                'Calculate_Debitordet(objWOJBO.Tot_Lab_Amt, objWOJBO.Tot_Spare_Amt, objWOJBO.Tot_Gm_Amt, objWOJBO.Tot_Vat_Amt, objWOJBO.WO_Tot_Disc_Amt, 0, objWOJBO.Fixed_Price, objWOJBO.WO_Incl_Vat, objWOJBO.WO_Fixed_Price, objWOJBO.WO_Own_Cr_Cust)
                dtWODebtors = HttpContext.Current.Session("WODebDetails")

                If mode = "Add" Then
                    If Not dtWOSpareParts Is Nothing Then
                        For i As Integer = 0 To dtWOSpareParts.DefaultView.Count - 1
                            strXMLSpareParts += "<insert ID_ITEM_JOB=""" + objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("ID_ITEM").ToString) + """"
                            strXMLSpareParts += " ID_MAKE_JOB=""" + objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("Id_Make").ToString) + """"
                            strXMLSpareParts += " ID_WAREHOUSE=""" + objCommonUtil.ConvertStr(HttpContext.Current.Session("Id_WH").ToString) + """"
                            strXMLSpareParts += " ID_ITEM_CATG_JOB=""" + objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("Id_Item_Catg").ToString) + """"
                            strXMLSpareParts += " JOBI_ORDER_QTY=""" + objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), dtWOSpareParts.DefaultView(i).Item("JOBI_ORDER_QTY").ToString))) + """"
                            strXMLSpareParts += " JOBI_DELIVER_QTY=""" + IIf(objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("Jobi_Deliver_Qty").ToString) = "", 0, objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), dtWOSpareParts.DefaultView(i).Item("Jobi_Deliver_Qty").ToString)))) + """"
                            strXMLSpareParts += " JOBI_BO_QTY=""" + IIf(objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("Jobi_Bo_Qty").ToString) = "", 0, objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), dtWOSpareParts.DefaultView(i).Item("Jobi_Bo_Qty").ToString)))) + """"
                            strXMLSpareParts += " JOBI_DIS_PER=""" + objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), dtWOSpareParts.DefaultView(i).Item("Jobi_Dis_Per").ToString))) + """"
                            strXMLSpareParts += " JOBI_VAT_PER=""" + objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), dtWOSpareParts.DefaultView(i).Item("Jobi_Vat_Per").ToString))) + """"
                            strXMLSpareParts += " ORDER_LINE_TEXT=""" + objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("Order_line_Text").ToString) + """"
                            strXMLSpareParts += " JOBI_SELL_PRICE=""" + objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), dtWOSpareParts.DefaultView(i).Item("Jobi_Sell_Price").ToString))) + """"
                            strXMLSpareParts += " JOBI_COST_PRICE=""" + objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), dtWOSpareParts.DefaultView(i).Item("Cost_Price").ToString))) + """"

                            If dtWOSpareParts.DefaultView(i).Item("ID_ITEM").Equals(System.DBNull.Value) And dtWOSpareParts.DefaultView(i).Item("Text").ToString <> "" Then
                                strXMLSpareParts += " ID_CUST_WO=""" + objCommonUtil.ConvertStr(objWOJBO.Id_Job_Deb) + """"
                            Else
                                strXMLSpareParts += " ID_CUST_WO=""" + objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("Id_Customer").ToString) + """"
                            End If
                            strXMLSpareParts += " TEXT=""" + objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("Text").ToString) + """"
                            strXMLSpareParts += " TD_CALC=""" + objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("TD_CALC").ToString) + """"
                            strXMLSpareParts += " ITEM_DESC=""" + objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("Item_Sp_Desc").ToString) + """"
                            strXMLSpareParts += " PICKINGLIST_PREV_PRINTED=""" + objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("PICKINGLIST_PREV_PRINTED").ToString) + """"
                            strXMLSpareParts += " DELIVERYNOTE_PREV_PRINTED=""" + objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("DELIVERYNOTE_PREV_PRINTED").ToString) + """"
                            strXMLSpareParts += " PREV_PICKED=""" + IIf(objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("PREV_PICKED").Equals(System.DBNull.Value)), 0, objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), dtWOSpareParts.DefaultView(i).Item("PREV_PICKED").ToString)))) + """"
                            strXMLSpareParts += " SPARE_TYPE=""" + objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("SPARE_TYPE").ToString) + """"
                            strXMLSpareParts += " FLG_FORCE_VAT=""" + objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("FLG_FORCE_VAT").ToString) + """"
                            strXMLSpareParts += " FLG_EDIT_SP=""" + objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("FLG_EDIT_SP").ToString) + """"
                            strXMLSpareParts += " EXPORT_TYPE=""" + objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("EXPORT_TYPE").ToString) + """/>"
                        Next
                    End If
                ElseIf mode = "Update" Then

                    If Not dtWOSpareParts Is Nothing Then
                        For i As Integer = 0 To dtWOSpareParts.DefaultView.Count - 1
                            strXMLSpareParts += "<insert ID_ITEM_JOB=""" + objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("ID_ITEM").ToString) + """"
                            strXMLSpareParts += " ID_MAKE_JOB=""" + IIf(objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("ID_MAKE").ToString) = "", objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("ID_MAKE").ToString), objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("ID_MAKE").ToString)) + """"
                            strXMLSpareParts += " ID_WAREHOUSE=""" + objCommonUtil.ConvertStr(HttpContext.Current.Session("Id_WH").ToString) + """"
                            strXMLSpareParts += " ID_WODET_SEQ_JOB=""" + objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("ID_WODET_SEQ").ToString) + """"
                            strXMLSpareParts += " ID_ITEM_CATG_JOB=""" + objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("Id_Item_Catg").ToString) + """"
                            strXMLSpareParts += " JOBI_ORDER_QTY=""" + objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), dtWOSpareParts.DefaultView(i).Item("JOBI_ORDER_QTY").ToString)) + """"
                            strXMLSpareParts += " JOBI_DELIVER_QTY=""" + IIf(objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("JOBI_DELIVER_QTY").ToString) = "", 0, objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), dtWOSpareParts.DefaultView(i).Item("JOBI_DELIVER_QTY").ToString))) + """"
                            strXMLSpareParts += " JOBI_BO_QTY=""" + IIf(objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("JOBI_BO_QTY").ToString) = "", 0, objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), dtWOSpareParts.DefaultView(i).Item("JOBI_BO_QTY").ToString))) + """"
                            If (dtWOSpareParts.DefaultView(i).Item("JOBI_DIS_PER").ToString.Trim.Length > 0 And dtWOSpareParts.DefaultView(i).Item("JOBI_DIS_PER").ToString <> "&nbsp;") Then
                                If dtWOSpareParts.DefaultView(i).Item("JOBI_DIS_PER").ToString.Contains(";") Then
                                    Dim ar As Array = dtWOSpareParts.DefaultView(i).Item("JOBI_DIS_PER").ToString.Split(";")
                                    Dim sm As String = ""
                                    For i1 As Integer = 0 To ar.Length - 2
                                        sm = sm + objCommonUtil.GetDefaultNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), ar(i1)) + ";"
                                    Next
                                    strXMLSpareParts += " JOBI_DIS_PER=""" + sm + objCommonUtil.GetDefaultNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), ar(ar.Length - 1)) + """"
                                Else
                                    strXMLSpareParts += " JOBI_DIS_PER=""" + objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), dtWOSpareParts.DefaultView(i).Item("JOBI_DIS_PER").ToString)) + """"
                                End If
                            End If
                            If (dtWOSpareParts.DefaultView(i).Item("JOBI_VAT_PER").ToString.Trim.Length > 0 And dtWOSpareParts.DefaultView(i).Item("JOBI_VAT_PER").ToString <> "&nbsp;") Then
                                If dtWOSpareParts.DefaultView(i).Item("JOBI_VAT_PER").ToString.Contains(";") Then
                                    Dim ar As Array = dtWOSpareParts.DefaultView(i).Item("JOBI_VAT_PER").ToString.Split(";")
                                    Dim sm As String = ""
                                    For i1 As Integer = 0 To ar.Length - 2
                                        sm = sm + objCommonUtil.GetDefaultNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), ar(i1)) + ";"
                                    Next
                                    strXMLSpareParts += " JOBI_VAT_PER=""" + sm + objCommonUtil.GetDefaultNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), ar(ar.Length - 1)) + """"
                                Else
                                    strXMLSpareParts += " JOBI_VAT_PER=""" + objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), dtWOSpareParts.DefaultView(i).Item("JOBI_VAT_PER").ToString)) + """"
                                End If
                            End If
                            strXMLSpareParts += " ORDER_LINE_TEXT=""" + objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("ORDER_LINE_TEXT").ToString) + """"
                            strXMLSpareParts += " ID_WOITEM_SEQ=""" + IIf(objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("ID_WOITEM_SEQ").ToString) = "", "0", objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("ID_WOITEM_SEQ").ToString)) + """"
                            strXMLSpareParts += " JOBI_SELL_PRICE=""" + objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), dtWOSpareParts.DefaultView(i).Item("JOBI_SELL_PRICE").ToString)) + """"
                            strXMLSpareParts += " JOBI_COST_PRICE=""" + objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), dtWOSpareParts.DefaultView(i).Item("COST_PRICE").ToString))) + """"
                            If dtWOSpareParts.DefaultView(i).Item("id_item").Equals(System.DBNull.Value) And dtWOSpareParts.DefaultView(i).Item("TEXT").ToString <> "" Then
                                strXMLSpareParts += " ID_CUST_WO=""" + objCommonUtil.ConvertStr(objWOJBO.Id_Job_Deb) + """"
                            Else
                                strXMLSpareParts += " ID_CUST_WO=""" + objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("Id_Customer").ToString) + """"
                            End If
                            strXMLSpareParts += " TEXT=""" + objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("TEXT").ToString) + """"
                            strXMLSpareParts += " TD_CALC=""" + objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("TD_CALC").ToString) + """"
                            strXMLSpareParts += " ITEM_DESC=""" + objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("Item_Sp_Desc").ToString) + """"
                            strXMLSpareParts += " PICKINGLIST_PREV_PRINTED=""" + objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("PICKINGLIST_PREV_PRINTED").ToString) + """"
                            strXMLSpareParts += " DELIVERYNOTE_PREV_PRINTED=""" + objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("DELIVERYNOTE_PREV_PRINTED").ToString) + """"
                            strXMLSpareParts += " PREV_PICKED=""" + IIf(objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("PREV_PICKED").Equals(System.DBNull.Value)), 0, objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), dtWOSpareParts.DefaultView(i).Item("PREV_PICKED").ToString)))) + """"
                            strXMLSpareParts += " SPARE_TYPE=""" + objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("SPARE_TYPE").ToString) + """"
                            strXMLSpareParts += " FLG_FORCE_VAT=""" + objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("FLG_FORCE_VAT").ToString) + """"
                            strXMLSpareParts += " FLG_EDIT_SP=""" + objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("FLG_EDIT_SP").ToString) + """"
                            strXMLSpareParts += " EXPORT_TYPE=""" + objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("EXPORT_TYPE").ToString) + """/>"
                        Next
                    End If
                End If

                strXMLSpareParts += "</root>"

                Dim strXMLWODeb As String = "<root>"
                If Not dtWODebtors Is Nothing Then
                    For i As Integer = 0 To dtWODebtors.DefaultView.Count - 1
                        strXMLWODeb += "<insert ID_DETAIL=""" + objCommonUtil.ConvertStr(dtWODebtors.DefaultView(i).Item("ID_JOB_DEB").ToString) + """"
                        strXMLWODeb += " ID_DBT_SEQ=""" + objCommonUtil.ConvertStr(dtWODebtors.DefaultView(i).Item("ID_DBT_SEQ").ToString) + """"
                        strXMLWODeb += " DEBITOR_TYPE=""" + objCommonUtil.ConvertStr(dtWODebtors.DefaultView(i).Item("DEBITOR_TYPE").ToString) + """" 'Need to check debtor Type C or D
                        strXMLWODeb += " DBT_AMT=""" + objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), dtWODebtors.DefaultView(i).Item("DBT_AMT").ToString))) + """"
                        If dtWODebtors.DefaultView(i).Item("DBT_PER").ToString <> "" Then
                            strXMLWODeb += " DBT_PER=""" + objCommonUtil.ConvertStr(objCommonUtil.GetDefaultLangNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), dtWODebtors.DefaultView(i).Item("DBT_PER").ToString))) + """"
                        Else
                            strXMLWODeb += " DBT_PER=""" + objCommonUtil.ConvertStr(objCommonUtil.GetDefaultLangNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), "0"))) + """"
                        End If
                        strXMLWODeb += " PWO_VAT_PERCENTAGE=""" + objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), dtWODebtors.DefaultView(i).Item("WO_VAT_PERCENTAGE").ToString))) + """"
                        strXMLWODeb += " PWO_GM_PER=""" + objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), dtWODebtors.DefaultView(i).Item("WO_GM_PER").ToString))) + """"
                        strXMLWODeb += " PWO_GM_VATPER=""" + objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), dtWODebtors.DefaultView(i).Item("WO_GM_VATPER").ToString))) + """"
                        strXMLWODeb += " PWO_LBR_VATPER=""" + objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), dtWODebtors.DefaultView(i).Item("WO_LBR_VATPER").ToString))) + """"
                        strXMLWODeb += " PWO_SPR_DISCPER=""" + objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), dtWODebtors.DefaultView(i).Item("WO_SPR_DISCPER").ToString))) + """"
                        strXMLWODeb += " PWO_FIXED_VATPER=""" + objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), dtWODebtors.DefaultView(i).Item("WO_FIXED_VATPER").ToString))) + """"

                        If dtWODebtors.DefaultView(i).Item("ORGPERCENT").ToString <> "" Then
                            strXMLWODeb += " ORG_PER=""" + objCommonUtil.ConvertStr(objCommonUtil.GetDefaultLangNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), dtWODebtors.DefaultView(i).Item("ORGPERCENT").ToString))) + """"
                        Else
                            strXMLWODeb += " ORG_PER=""" + objCommonUtil.ConvertStr(objCommonUtil.GetDefaultLangNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), "0"))) + """"
                        End If

                        If dtWODebtors.DefaultView(i).Item("JOB VAT").ToString <> "" Then
                            strXMLWODeb += " JOB_VAT_AMOUNT=""" + objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), dtWODebtors.DefaultView(i).Item("JOB VAT").ToString))) + """"
                        Else
                            strXMLWODeb += " JOB_VAT_AMOUNT=""" + objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), "0"))) + """"
                        End If
                        If dtWODebtors.DefaultView(i).Item("LABOUR AMOUNT").ToString <> "" Then
                            strXMLWODeb += " LABOUR_AMOUNT=""" + objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), dtWODebtors.DefaultView(i).Item("LABOUR AMOUNT").ToString))) + """"
                        Else
                            strXMLWODeb += " LABOUR_AMOUNT=""" + objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), "0"))) + """"
                        End If
                        If dtWODebtors.DefaultView(i).Item("LABOUR DISCOUNT").ToString <> "" Then
                            strXMLWODeb += " LABOUR_DISCOUNT=""" + objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), dtWODebtors.DefaultView(i).Item("LABOUR DISCOUNT").ToString))) + """"
                        Else
                            strXMLWODeb += " LABOUR_DISCOUNT=""" + objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), "0"))) + """"
                        End If
                        If dtWODebtors.DefaultView(i).Item("GM AMOUNT").ToString <> "" Then
                            strXMLWODeb += " GM_AMOUNT=""" + objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), dtWODebtors.DefaultView(i).Item("GM AMOUNT").ToString))) + """"
                        Else
                            strXMLWODeb += " GM_AMOUNT=""" + objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), "0"))) + """"
                        End If
                        If dtWODebtors.DefaultView(i).Item("GM DISCOUNT").ToString <> "" Then
                            strXMLWODeb += " GM_DISCOUNT=""" + objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), dtWODebtors.DefaultView(i).Item("GM DISCOUNT").ToString))) + """"
                        Else
                            strXMLWODeb += " GM_DISCOUNT=""" + objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), "0"))) + """"
                        End If
                        If dtWODebtors.DefaultView(i).Item("OWN RISK AMOUNT").ToString <> "" Then
                            strXMLWODeb += " OWNRISK_AMOUNT=""" + objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), dtWODebtors.DefaultView(i).Item("OWN RISK AMOUNT").ToString))) + """"
                        Else
                            strXMLWODeb += " OWNRISK_AMOUNT=""" + objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), "0"))) + """"
                        End If
                        If dtWODebtors.DefaultView(i).Item("SP_VAT").ToString <> "" Then
                            strXMLWODeb += " SP_VAT=""" + objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), dtWODebtors.DefaultView(i).Item("SP_VAT").ToString))) + """"
                        Else
                            strXMLWODeb += " SP_VAT=""" + objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), "0"))) + """"
                        End If
                        If dtWODebtors.DefaultView(i).Item("SP_AMT_DEB").ToString <> "" Then
                            strXMLWODeb += " SP_AMT_DEB=""" + objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), dtWODebtors.DefaultView(i).Item("SP_AMT_DEB").ToString))) + """/>"
                        Else
                            strXMLWODeb += " SP_AMT_DEB=""" + objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), "0"))) + """/>"
                        End If

                    Next
                End If
                strXMLWODeb += "</root>"

                dtWOSparePartsDebitor = Get_DebitorDiscount(dtWODebtors, dtWOSpareParts)

                Dim aryDebDisc, aryDebDiscSeq As Array
                Dim aryDebVAT, aryDebVATSeq As Array
                Dim strXMLDiscount As String = "<root>"
                If Not dtWOSparePartsDebitor Is Nothing Then
                    If Not dtWODebtors Is Nothing Then
                        For i As Integer = 0 To dtWOSparePartsDebitor.DefaultView.Count - 1
                            aryDebDisc = Split(dtWOSparePartsDebitor.DefaultView(i).Item("JOBI_DIS_PER"), ";")
                            aryDebVAT = Split(dtWOSparePartsDebitor.DefaultView(i).Item("JOBI_VAT_PER"), ";")
                            aryDebDiscSeq = Split(dtWOSparePartsDebitor.DefaultView(i).Item("JOBI_DIS_SEQ"), ";")
                            aryDebVATSeq = Split(dtWOSparePartsDebitor.DefaultView(i).Item("JOBI_VAT_SEQ"), ";")
                            For j As Integer = 0 To dtWODebtors.DefaultView.Count - 1
                                If (IsDBNull(dtWOSparePartsDebitor.DefaultView(i).Item("ID_ITEM")) Or (dtWOSparePartsDebitor.DefaultView(i).Item("ID_ITEM") = "")) Then
                                    Continue For
                                Else
                                    strXMLDiscount += "<insert ID_DEBTOR=""" + objCommonUtil.ConvertStr(dtWODebtors.DefaultView(j).Item("ID_JOB_DEB").ToString) + """"
                                    strXMLDiscount += " ID_ITEM=""" + objCommonUtil.ConvertStr(dtWOSparePartsDebitor.DefaultView(i).Item("ID_ITEM").ToString) + """"
                                    strXMLDiscount += " ID_MAKE=""" + objCommonUtil.ConvertStr(dtWOSparePartsDebitor.DefaultView(i).Item("ID_MAKE").ToString) + """"
                                    strXMLDiscount += " ID_WAREHOUSE=""" + objCommonUtil.ConvertStr(HttpContext.Current.Session("Id_WH").ToString) + """"
                                    strXMLDiscount += " DBT_VAT_AMOUNT=""0"""
                                    strXMLDiscount += " DBT_DIS_AMT=""0"""
                                    strXMLDiscount += " JOB_VAT_PER=""" + aryDebVAT(j) + """"
                                    strXMLDiscount += " JOB_VAT_SEQ=""" + aryDebVATSeq(j) + """"
                                    strXMLDiscount += " JOB_DIS_SEQ=""" + aryDebDiscSeq(j) + """"
                                    strXMLDiscount += " JOB_DIS_PER=""" + objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), objdtSpare.Rows(i)("JOBI_DIS_PER").ToString()))) + """/>"
                                End If
                            Next
                        Next
                    End If
                End If
                strXMLDiscount += "</root>"

                Dim strXMLMech As String
                If Not dtWOMechanics Is Nothing Then
                    strXMLMech = "<root>"
                    For i As Integer = 0 To dtWOMechanics.DefaultView.Count - 1
                        strXMLMech += "<insert ID_MECH=""" + objCommonUtil.ConvertStr(dtWOMechanics.DefaultView(i).Item("ID_Login").ToString) + """/>"
                    Next
                    strXMLMech += "</root>"
                    objWOJBO.Mechanic_Doc = strXMLMech
                Else
                    objWOJBO.Mechanic_Doc = Nothing
                End If

                objWOJBO.Job_Doc = IIf(strXMLSpareParts = "", "<root></root>", Trim(strXMLSpareParts)) '----changed
                objWOJBO.WO_Doc = IIf(strXMLWODeb = "", Nothing, Trim(strXMLWODeb))
                objWOJBO.Dis_Doc = IIf(strXMLDiscount = "", "<root><root/>", Trim(strXMLDiscount))
                Dim dsCLockTime As DataSet = objWOJDO.Fetch_WO_ClkTime(objWOJBO.Id_WO_NO, objWOJBO.Id_WO_Prefix, objWOJBO.Id_Job)
                If dsCLockTime.Tables(0).Rows.Count > 0 Then
                    objWOJBO.WO_Clk_Time = dsCLockTime.Tables(0).Rows(0)("WO_CLK_TIME").ToString
                End If

                If (mode = "Add") Then
                    strResult = objWOJDO.Save_WOJobDetails(objWOJBO)
                ElseIf (mode = "Update") Then
                    objWOJBO.Modified_By = HttpContext.Current.Session("UserID")
                    strResult = objWOJDO.Update_WOJobDetails(objWOJBO)
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "Save_WOJobDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strResult
        End Function

        Public Function Get_DebitorDiscount(ByVal dtWODebtors As DataTable, ByVal dtWOSparePartsDebitor As DataTable) As DataTable
            Try
                Dim arrVatDis As Array
                If Not dtWODebtors Is Nothing Then
                    For i As Integer = 0 To dtWODebtors.DefaultView.Count - 1
                        objWOJBO.Created_By = HttpContext.Current.Session("UserId")
                        objWOJBO.Id_Job_Deb = dtWODebtors.DefaultView(i).Item("ID_JOB_DEB")
                        objWOJBO.WO_Id_Veh = HttpContext.Current.Session("VEH_SEQ_NO")
                        If Not (dtWOSparePartsDebitor.Columns.Contains("JOBI_DIS_SEQ")) Then
                            dtWOSparePartsDebitor.Columns.Add("JOBI_DIS_SEQ")
                        End If
                        If Not (dtWOSparePartsDebitor.Columns.Contains("JOBI_VAT_SEQ")) Then
                            dtWOSparePartsDebitor.Columns.Add("JOBI_VAT_SEQ")
                        End If
                        'dtWOSparePartsDebitor.Columns.Add("JOBI_DIS_SEQ")
                        'dtWOSparePartsDebitor.Columns.Add("JOBI_VAT_SEQ")
                        If Not dtWOSparePartsDebitor Is Nothing Then
                            For j As Integer = 0 To dtWOSparePartsDebitor.DefaultView.Count - 1
                                If dtWOSparePartsDebitor.Select("ID_ITEM='" + dtWOSparePartsDebitor.DefaultView(j).Item("ID_ITEM") + "'").Length > 0 Then
                                    objWOJBO.Id_Item_Job = dtWOSparePartsDebitor.DefaultView(j).Item("ID_ITEM")
                                    objWOJBO.Id_Make = dtWOSparePartsDebitor.DefaultView(j).Item("ID_MAKE")
                                    objWOJBO.Id_Wh_Item = Convert.ToInt32(HttpContext.Current.Session("Id_WH").ToString) 'dtWOSparePartsDebitor.DefaultView(j).Item("ID_WAREHOUSE")
                                    arrVatDis = Split(objWOJDO.Get_vat_Dis(objWOJBO).ToString, ";")
                                    If i = 0 Then
                                        dtWOSparePartsDebitor.DefaultView(j).Item("JOBI_DIS_SEQ") = arrVatDis(1).ToString
                                        dtWOSparePartsDebitor.DefaultView(j).Item("JOBI_VAT_PER") = arrVatDis(2).ToString 'Val(arrVatDis(2).ToString)
                                        dtWOSparePartsDebitor.DefaultView(j).Item("JOBI_VAT_SEQ") = arrVatDis(3).ToString
                                    Else
                                        dtWOSparePartsDebitor.DefaultView(j).Item("JOBI_DIS_SEQ") = dtWOSparePartsDebitor.DefaultView(j).Item("JOBI_DIS_SEQ") + ";" + arrVatDis(1)
                                        dtWOSparePartsDebitor.DefaultView(j).Item("JOBI_VAT_PER") = dtWOSparePartsDebitor.DefaultView(j).Item("JOBI_VAT_PER") + ";" + arrVatDis(2)
                                        dtWOSparePartsDebitor.DefaultView(j).Item("JOBI_VAT_SEQ") = dtWOSparePartsDebitor.DefaultView(j).Item("JOBI_VAT_SEQ") + ";" + arrVatDis(3)
                                    End If
                                ElseIf IsDBNull(dtWOSparePartsDebitor.DefaultView(j).Item("ID_ITEM")) Then
                                    dtWOSparePartsDebitor.DefaultView(j).Item("JOBI_DIS_SEQ") = 0
                                    dtWOSparePartsDebitor.DefaultView(j).Item("JOBI_VAT_SEQ") = 0
                                End If
                            Next
                        End If
                    Next
                    Return dtWOSparePartsDebitor
                End If
            Catch thex As Threading.ThreadAbortException
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "Get_DebitorDiscount", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
        End Function
        Public Function GetSubRepairCode(ByVal repairCode As String) As List(Of WOJobDetailBO)
            Dim details As New List(Of WOJobDetailBO)()
            Dim dsSubRepairCodes As New DataSet
            Dim dtSubRepairCodes As New DataTable
            Try
                dsSubRepairCodes = objWOJDO.GetSubRepairCode(repairCode)
                ' HttpContext.Current.Session("WOJConfigDetails") = dsSubRepairCodes
                If dsSubRepairCodes.Tables.Count > 0 Then
                    'SubRepairCodes Load
                    If dsSubRepairCodes.Tables(0).Rows.Count > 0 Then
                        dtSubRepairCodes = dsSubRepairCodes.Tables(0)
                        For Each dtrow As DataRow In dtSubRepairCodes.Rows
                            Dim wojDet As New WOJobDetailBO()
                            wojDet.Rp_SubRepCode_Desc = dtrow("RP_SUBREPCODE_DES")
                            wojDet.Id_SubRepCode = dtrow("ID_SUBREP_CODE")
                            details.Add(wojDet)
                        Next
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "GetSubRepairCode", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function CalcSpTotal(ByVal qtyDel As String, ByVal sp As String, ByVal discount As String) As String
            Dim spTotal As String = "0"

            Try
                spTotal = Convert.ToString(Convert.ToDecimal(qtyDel) * Convert.ToDecimal(sp) - (Convert.ToDecimal(qtyDel) * Convert.ToDecimal(sp) * 0.01 * Convert.ToDecimal(discount)))
                spTotal = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(CStr(spTotal) = "", "", CStr(spTotal)))

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "CalcSpTotal", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return spTotal
        End Function
        Public Function Reload_DebitorDetails(ByVal debtCustCode As String, ByVal debtCustName As String) As List(Of WOJobDetailBO)
            Dim details As New List(Of WOJobDetailBO)()
            Try
                Dim dtDebitor As New DataTable
                dtDebitor = HttpContext.Current.Session("WODebDetails")
                dtDebitor.Rows(0)("ID_JOB_DEB") = debtCustCode
                dtDebitor.Rows(0)("JOB_DEB_NAME") = debtCustName
                dtDebitor.AcceptChanges()
                If dtDebitor.Rows.Count > 0 Then
                    For Each dtrow As DataRow In dtDebitor.Rows
                        Dim wojDet As New WOJobDetailBO()
                        wojDet.Job_Deb_Name = IIf(IsDBNull(dtrow("JOB_DEB_NAME")) = True, "", dtrow("JOB_DEB_NAME"))
                        wojDet.Dbt_Per = IIf(IsDBNull(dtrow("DBT_PER")) = True, "", dtrow("DBT_PER"))
                        wojDet.Dbt_Amt = IIf(IsDBNull(dtrow("DBT_AMT")) = True, "", dtrow("DBT_AMT"))
                        wojDet.Id_Job_Deb = IIf(IsDBNull(dtrow("ID_JOB_DEB")) = True, "", dtrow("ID_JOB_DEB"))
                        wojDet.Id_Deb_Seq = IIf(IsDBNull(dtrow("ID_DBT_SEQ")) = True, 0, dtrow("ID_DBT_SEQ"))
                        wojDet.Deb_Sl_No = IIf(IsDBNull(dtrow("SLNO")) = True, "", dtrow("SLNO"))
                        wojDet.Spare_Count = IIf(IsDBNull(dtrow("SPARECOUNT")) = True, "", dtrow("SPARECOUNT"))
                        wojDet.Org_Per = IIf(IsDBNull(dtrow("ORGPERCENT")) = True, "", dtrow("ORGPERCENT"))

                        details.Add(wojDet)
                    Next
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "Reload_DebitorDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function RepairPackageDetails(ByVal idRpCode As String) As Collection
            Dim dsDetails As New DataSet
            Dim dtDetails As New DataTable
            Dim dt As New Collection
            Try
                dsDetails = objWOJDO.Fetch_RPSpareDetails(idRpCode, HttpContext.Current.Session("ID_CUST"), HttpContext.Current.Session("VEH_SEQ_NO"), HttpContext.Current.Session("UserID"))
                If dsDetails.Tables.Count > 0 Then
                    'Spares Details
                    If dsDetails.Tables(0).Rows.Count > 0 Then
                        Dim temprow As DataRow = Nothing

                        'Dim dtDeb As DataTable = CType(HttpContext.Current.Session("WODebDetails"), DataTable)
                        dtDetails = dsDetails.Tables(0)

                        For Each temprow In dtDetails.Rows
                            temprow.BeginEdit()
                            temprow.Item("ID_CUST_WO") = HttpContext.Current.Session("Id_Cust")
                            temprow.AcceptChanges()
                            temprow.EndEdit()
                        Next

                        HttpContext.Current.Session("WOSpareDetails") = dtDetails

                        'InsertEditDebitoronLine()

                        Dim details As New List(Of WOJobDetailBO)()
                        For Each dtrow As DataRow In dtDetails.Rows
                            Dim wojDet As New WOJobDetailBO()
                            wojDet.Id_WOItem_Seq = IIf(IsDBNull(dtrow("Id_WOITEM_SEQ")) = True, 0, dtrow("Id_WOITEM_SEQ"))
                            wojDet.Id_Wodet_Seq = IIf(IsDBNull(dtrow("Id_Wodet_Seq_Job")) = True, 0, dtrow("Id_Wodet_Seq_Job"))
                            wojDet.Id_Make = IIf(IsDBNull(dtrow("Id_Make")) = True, "", dtrow("Id_Make"))
                            wojDet.Id_Item_Catg_Job_Id = IIf(IsDBNull(dtrow("Id_Item_Catg_Job_Id")) = True, "", dtrow("Id_Item_Catg_Job_Id"))
                            wojDet.Id_Item_Catg = IIf(IsDBNull(dtrow("Id_Item_Catg_Job")) = True, "", dtrow("Id_Item_Catg_Job"))
                            wojDet.Id_Item = IIf(IsDBNull(dtrow("Id_Item_Job")) = True, "", dtrow("Id_Item_Job"))
                            wojDet.Item_Sp_Desc = IIf(IsDBNull(dtrow("Item_Desc")) = True, "", dtrow("Item_Desc"))
                            wojDet.Jobi_Order_Qty = IIf(IsDBNull(dtrow("Jobi_Order_Qty")) = True, "0", dtrow("Jobi_Order_Qty"))
                            wojDet.Jobi_Deliver_Qty = IIf(IsDBNull(dtrow("Jobi_Deliver_Qty")) = True, "0", dtrow("Jobi_Deliver_Qty"))
                            wojDet.Jobi_Bo_Qty = IIf(IsDBNull(dtrow("Jobi_BO_Qty")) = True, "0", dtrow("Jobi_BO_Qty"))
                            wojDet.Jobi_Sell_Price = IIf(IsDBNull(dtrow("Jobi_Sell_Price")) = True, "0", dtrow("Jobi_Sell_Price"))
                            wojDet.Jobi_Dis_Per = IIf(IsDBNull(dtrow("Jobi_Dis_Per")) = True, "0", dtrow("Jobi_Dis_Per"))
                            wojDet.Jobi_Vat_Per = IIf(IsDBNull(dtrow("Jobi_Vat_Per")) = True, "0", dtrow("Jobi_Vat_Per"))
                            wojDet.Jobi_Vat_Seq = IIf(IsDBNull(dtrow("Jobi_Vat_Seq")) = True, 0, dtrow("Jobi_Vat_Seq"))
                            wojDet.Jobi_Dis_Seq = IIf(IsDBNull(dtrow("Jobi_Dis_Seq")) = True, 0, dtrow("Jobi_Dis_Seq"))
                            wojDet.Sp_Slno = IIf(IsDBNull(dtrow("SLNO")) = True, "1", dtrow("SLNO"))
                            wojDet.Sp_Make = IIf(IsDBNull(dtrow("MAKE")) = True, "", dtrow("MAKE"))
                            wojDet.Id_Wh_Item = IIf(IsDBNull(dtrow("Id_Warehouse")) = True, 0, dtrow("Id_Warehouse"))
                            wojDet.Cost_Price = IIf(IsDBNull(dtrow("Jobi_Cost_Price")) = True, "0", dtrow("Jobi_Cost_Price"))
                            wojDet.Td_Calc = IIf(IsDBNull(dtrow("Td_Calc")) = True, "1", dtrow("Td_Calc"))
                            wojDet.Id_Deb_Seq = IIf(IsDBNull(dtrow("Id_Dbt_Seq")) = True, 0, dtrow("Id_Dbt_Seq"))
                            wojDet.Order_Line_Text = IIf(IsDBNull(dtrow("Order_Line_Text")) = True, "", dtrow("Order_Line_Text"))
                            wojDet.Id_Customer = IIf(IsDBNull(dtrow("Id_Cust_WO")) = True, "", dtrow("Id_Cust_WO"))
                            wojDet.Text = IIf(IsDBNull(dtrow("Text")) = True, "", dtrow("Text"))
                            wojDet.Sp_Location = IIf(IsDBNull(dtrow("Location")) = True, "", dtrow("Location"))
                            wojDet.Pickinglist_Prev_Printed = IIf(IsDBNull(dtrow("PICKINGLIST_PREV_PRINTED")) = True, "0", dtrow("PICKINGLIST_PREV_PRINTED"))
                            wojDet.Deliverynote_Prev_Printed = IIf(IsDBNull(dtrow("DELIVERYNOTE_PREV_PRINTED")) = True, "0", dtrow("DELIVERYNOTE_PREV_PRINTED"))
                            wojDet.Prev_Picked = IIf(IsDBNull(dtrow("PREV_PICKED")) = True, "0", dtrow("PREV_PICKED"))
                            wojDet.Spare_Type = IIf(IsDBNull(dtrow("SPARE_TYPE")) = True, "ORD", dtrow("SPARE_TYPE"))
                            wojDet.Flg_Force_Vat = IIf(IsDBNull(dtrow("FLG_FORCE_VAT")) = True, "0", dtrow("FLG_FORCE_VAT"))
                            wojDet.Flg_Edit_Sp = IIf(IsDBNull(dtrow("FLG_EDIT_SP")) = True, "0", dtrow("FLG_EDIT_SP"))
                            wojDet.Export_Type = IIf(IsDBNull(dtrow("EXPORT_TYPE")) = True, "", dtrow("EXPORT_TYPE"))
                            wojDet.Sp_Item_Price = IIf(IsDBNull(dtrow("Total_Price")) = True, "0", dtrow("Total_Price"))
                            wojDet.ToBe_Picked = IIf(IsDBNull(dtrow("TOBE_PICKED")) = True, "0", dtrow("TOBE_PICKED"))
                            details.Add(wojDet)
                        Next
                        dt.Add(details)
                    Else
                        HttpContext.Current.Session("WOSpareDetails") = Nothing
                    End If

                    'Repair Package Details
                    If dsDetails.Tables(1).Rows.Count > 0 Then
                        dtDetails = dsDetails.Tables(1)
                        Dim details As New List(Of WOJobDetailBO)()
                        For Each dtrow As DataRow In dtDetails.Rows
                            Dim wojDet As New WOJobDetailBO()
                            wojDet.Id_Catg_Rp = IIf(IsDBNull(dtrow("Id_Catg_Rp")) = True, "", dtrow("Id_Catg_Rp"))
                            wojDet.RpCategory = IIf(IsDBNull(dtrow("RpCategory")) = True, "", dtrow("RpCategory"))
                            wojDet.Id_Rep_Code = IIf(IsDBNull(dtrow("Id_Rp_Code")) = True, "", dtrow("Id_Rp_Code"))
                            wojDet.Rp_RepCode_Des = IIf(IsDBNull(dtrow("Rp_Desc")) = True, "", dtrow("Rp_Desc"))
                            wojDet.RepCode = IIf(IsDBNull(dtrow("RepCode")) = True, "", dtrow("RepCode"))
                            wojDet.RepairCode = IIf(IsDBNull(dtrow("RepairCode")) = True, "", dtrow("RepairCode"))
                            wojDet.Id_Work_Cd_Rp = IIf(IsDBNull(dtrow("Id_Work_Cd_Rp")) = True, "", dtrow("Id_Work_Cd_Rp"))
                            wojDet.WorkCodeCategory = IIf(IsDBNull(dtrow("WorkCodeCategory")) = True, "", dtrow("WorkCodeCategory"))
                            wojDet.WO_Job_Txt = IIf(IsDBNull(dtrow("JobText")) = True, "", dtrow("JobText"))
                            wojDet.Flg_Fix_Price = IIf(IsDBNull(dtrow("Flg_Fix_Price")) = True, False, dtrow("Flg_Fix_Price"))
                            wojDet.WO_Fixed_Price = IIf(IsDBNull(dtrow("FixedPrice")) = True, 0, dtrow("FixedPrice"))
                            wojDet.WO_Fixed_Price = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), wojDet.WO_Fixed_Price)

                            wojDet.Flg_Use_Std_Time = IIf(IsDBNull(dtrow("Flg_Use_Std_Time")) = True, False, dtrow("Flg_Use_Std_Time"))
                            wojDet.Flg_Chrg_Std_Time = IIf(IsDBNull(dtrow("StandardCTime")) = True, False, dtrow("StandardCTime"))
                            wojDet.WO_Std_Time = IIf(IsDBNull(dtrow("StandardTime")) = True, "0", dtrow("StandardTime"))
                            wojDet.WO_Std_Time = wojDet.WO_Std_Time.ToString.Replace(".", ":").ToString.Replace(",", ":")

                            wojDet.Id_Rp_Prc_Grp = IIf(IsDBNull(dtrow("Id_Rp_Prc_Grp")) = True, "0", dtrow("Id_Rp_Prc_Grp"))
                            wojDet.PriceCodeforJob = IIf(IsDBNull(dtrow("Flg_Use_Std_Time")) = True, False, dtrow("Flg_Use_Std_Time"))
                            wojDet.WO_Vat_Calcrisk = IIf(IsDBNull(dtrow("WO_Vat_Calcrisk")) = True, "0", dtrow("WO_Vat_Calcrisk"))
                            wojDet.WO_Gm_Per = IIf(IsDBNull(dtrow("WO_GAR_MATPRICE_PER")) = True, "0", dtrow("WO_GAR_MATPRICE_PER"))

                            wojDet.WO_Charge_Base = IIf(IsDBNull(dtrow("WO_Charege_Base")) = True, "", dtrow("WO_Charege_Base"))
                            wojDet.WO_Discount_Base = IIf(IsDBNull(dtrow("WO_Discount_Base")) = True, "", dtrow("WO_Discount_Base"))
                            wojDet.Id_Comp_Rp = IIf(IsDBNull(dtrow("Id_Comp_Rp")) = True, "", dtrow("Id_Comp_Rp"))
                            wojDet.Id_Stype_Rp = IIf(IsDBNull(dtrow("Id_Stype_Rp")) = True, "", dtrow("Id_Stype_Rp"))
                            wojDet.Id_SubRepCode = IIf(IsDBNull(dtrow("Id_Sub_Rep_Code")) = True, "", dtrow("Id_Sub_Rep_Code"))
                            wojDet.Flg_Use_Gm = IIf(IsDBNull(dtrow("Flg_Use_Gm")) = True, True, dtrow("Flg_Use_Gm"))
                            details.Add(wojDet)
                        Next
                        dt.Add(details)
                    End If
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "RepairPackageDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return dt
        End Function
        Public Function GetAllJobCodes(ByVal jobText As String) As List(Of String)
            Dim dsJobCodes As New DataSet
            Dim dtJobCodes As DataTable
            Dim details As New List(Of String)()
            Try
                dsJobCodes = objWOJDO.GetAllJobCodes(jobText)

                If dsJobCodes.Tables.Count > 0 Then
                    If dsJobCodes.Tables(0).Rows.Count > 0 Then
                        dtJobCodes = dsJobCodes.Tables(0)
                    End If
                End If
                If jobText <> String.Empty Then
                    For Each dtrow As DataRow In dtJobCodes.Rows
                        details.Add(String.Format("{0}*{1}*{2}", dtrow("Job_Code"), dtrow("Operation_Num"), dtrow("Job_Text")))
                    Next
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "GetAllJobCodes", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details
        End Function
        Public Function GetJobText(ByVal opertaionCode As String) As List(Of WOJobDetailBO)
            Dim details As New List(Of WOJobDetailBO)()
            Dim dsJobCodes As New DataSet
            Dim dtJobCodes As New DataTable
            Try
                dsJobCodes = objWOJDO.GetJobText(opertaionCode)
                If dsJobCodes.Tables.Count > 0 Then
                    If dsJobCodes.Tables(0).Rows.Count > 0 Then
                        dtJobCodes = dsJobCodes.Tables(0)
                        For Each dtrow As DataRow In dtJobCodes.Rows
                            Dim wojDet As New WOJobDetailBO()
                            wojDet.Id_Operation = dtrow("Id_Operation")
                            wojDet.Job_Code = dtrow("Job_Code")
                            wojDet.Job_Text = dtrow("Job_Text")
                            details.Add(wojDet)
                        Next
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "GetJobText", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function

        Public Function Delete_Debitors(ByVal rowids As String) As List(Of WOJobDetailBO)
            Dim details As New List(Of WOJobDetailBO)()
            Try
                Dim dtDebitor As New DataTable
                dtDebitor = HttpContext.Current.Session("WODebDetails")
                HttpContext.Current.Session("WODebtIds") = Nothing
                Dim dtDebt As New DataTable
                Dim percenatage As Double = 0.0
                Dim strIdDebitor
                strIdDebitor = ""


                dtDebt = CType(HttpContext.Current.Session("WODebDetails"), DataTable)

                Dim dtDebtId As DataTable = New DataTable
                Dim drDebt As DataRow
                dtDebtId.Columns.Add("ID_DBT_SEQ")
                dtDebtId.Columns.Add("SPARECOUNT")
                For Each dtrow As DataRow In dtDebitor.Rows
                    For i As Integer = 0 To rowids.Length - 1
                        If (dtrow("SlNo") = rowids(i)) Then
                            If dtrow("Dbt_Per") <> "&nbsp;" And dtrow("Dbt_Per") <> "" Then
                                percenatage = percenatage + CType(dtrow("Dbt_Per"), Double)
                            Else
                                HttpContext.Current.Session("OwnRiskAmt") = 0
                                HttpContext.Current.Session("OwnRiskVATAmt") = 0
                                'txtCreditCust.Text = ""
                                'HIDCreditCode.Text = ""
                            End If

                            dtDebt.DefaultView.RowFilter = "true"
                            If strIdDebitor = Nothing Then
                                strIdDebitor = fnReplaceSQL(dtrow("Id_Job_Deb"))
                            Else
                                strIdDebitor = strIdDebitor + "," + fnReplaceSQL(dtrow("Id_Job_Deb"))
                            End If

                            If (dtrow("SPARECOUNT") > 0) Then
                                drDebt = dtDebtId.NewRow()
                                drDebt.Item("ID_DBT_SEQ") = dtrow("ID_DBT_SEQ")
                                drDebt.Item("SPARECOUNT") = dtrow("SPARECOUNT")
                                dtDebtId.Rows.Add(drDebt)
                            End If
                        End If
                    Next
                Next

                If strIdDebitor <> String.Empty Then
                    dtDebt.DefaultView.RowFilter = "ID_JOB_DEB not in (" + strIdDebitor + ")"
                End If

                For j As Integer = 0 To dtDebt.DefaultView.Count - 1
                    If dtDebt.DefaultView.Item(j).Item("ID_JOB_DEB") = HttpContext.Current.Session("ID_CUST") Then
                        If dtDebt.DefaultView.Item(0).Item("DBT_PER").ToString.Length <> 0 Then
                            dtDebt.DefaultView.Item(0).Item("DBT_PER") = Round(Convert.ToDecimal(dtDebt.DefaultView.Item(0).Item("DBT_PER") + percenatage), 2)
                            dtDebt.DefaultView.Item(0).Item("ORGPERCENT") = Round(Convert.ToDecimal(dtDebt.DefaultView.Item(0).Item("DBT_PER")), 2)
                        End If
                    End If
                Next

                For k As Integer = 0 To dtDebt.DefaultView.Count - 1
                    dtDebt.DefaultView.Item(k).Item("SLNO") = k + 1
                Next

                dtDebitor = AddDebitorDet(dtDebt.DefaultView)
                HttpContext.Current.Session("WODebDetails") = dtDebitor
                HttpContext.Current.Session("WODebtIds") = dtDebtId
                'UpdateSpares(dtDebtId)
                'reCalculateDebitorTotal()
                'Load_Debitor()

                If dtDebitor.Rows.Count > 0 Then
                    For Each dtrow As DataRow In dtDebitor.Rows
                        Dim wojDet As New WOJobDetailBO()
                        wojDet.Job_Deb_Name = IIf(IsDBNull(dtrow("JOB_DEB_NAME")) = True, "", dtrow("JOB_DEB_NAME"))
                        wojDet.Dbt_Per = IIf(IsDBNull(dtrow("DBT_PER")) = True, "", dtrow("DBT_PER"))
                        wojDet.Dbt_Amt = IIf(IsDBNull(dtrow("DBT_AMT")) = True, "", dtrow("DBT_AMT"))
                        wojDet.Id_Job_Deb = IIf(IsDBNull(dtrow("ID_JOB_DEB")) = True, "", dtrow("ID_JOB_DEB"))
                        wojDet.Id_Deb_Seq = IIf(IsDBNull(dtrow("ID_DBT_SEQ")) = True, 0, dtrow("ID_DBT_SEQ"))
                        wojDet.Deb_Sl_No = IIf(IsDBNull(dtrow("SLNO")) = True, "", dtrow("SLNO"))
                        wojDet.Spare_Count = IIf(IsDBNull(dtrow("SPARECOUNT")) = True, "", dtrow("SPARECOUNT"))
                        wojDet.Org_Per = IIf(IsDBNull(dtrow("ORGPERCENT")) = True, "", dtrow("ORGPERCENT"))

                        details.Add(wojDet)
                    Next
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "Delete_Debitors", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Private Function fnReplaceSQL(ByVal strUnformated As String) As String
            Try
                If strUnformated Is Nothing Then Return Nothing
                Return strUnformated.Replace("'"c, "''")
            Catch exth As System.Threading.ThreadAbortException
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Transactions_frmWOJobDetails", "fnReplaceSQL", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
        End Function
        Public Function AddDebitorDet(ByVal obDataView As DataView) As DataTable
            Dim obNewDt As DataTable
            Try
                obNewDt = obDataView.Table.Clone()
                Dim idx As Integer = -1
                Dim strColNames As String() = New String(obNewDt.Columns.Count - 1) {}
                For Each col As DataColumn In obNewDt.Columns
                    strColNames(System.Math.Max(System.Threading.Interlocked.Increment(idx), idx - 1)) = col.ColumnName
                Next

                Dim viewEnumerator As IEnumerator = obDataView.GetEnumerator()
                While viewEnumerator.MoveNext()
                    Dim drv As DataRowView = DirectCast(viewEnumerator.Current, DataRowView)
                    Dim dr As DataRow = obNewDt.NewRow()
                    Try
                        For Each strName As String In strColNames
                            dr(strName) = drv(strName)
                        Next
                    Catch ex As Exception
                        'Throw ex
                    End Try
                    obNewDt.Rows.Add(dr)
                End While
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Transactions_frmWOJobDetails", "AddDebitorDet", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return obNewDt
        End Function
        Public Function UpdateSpares() As List(Of WOJobDetailBO)
            Dim details As New List(Of WOJobDetailBO)()
            Try
                Dim dtDebt As New DataTable
                Dim dtSpare As New DataTable
                Dim rSpare As DataRow = Nothing
                Dim rDebt As DataRow = Nothing
                Dim count As Int32 = 0
                Dim woHeadDebtId As String = String.Empty
                Dim woHeadCustId As String = String.Empty
                Dim dtDebitor As DataTable = Nothing
                Dim dsCust As DataSet = Nothing
                dtDebt = HttpContext.Current.Session("WODebtIds")
                dtDebitor = HttpContext.Current.Session("WODebDetails")
                If Not dtDebitor Is Nothing Then
                    woHeadDebtId = dtDebitor.Rows(0)("ID_DBT_SEQ").ToString()
                    woHeadCustId = dtDebitor.Rows(0)("ID_JOB_DEB").ToString()
                End If

                dtSpare = HttpContext.Current.Session("WOSpareDetails")

                If Not dtDebt Is Nothing Then
                    For Each rDebt In dtDebt.Rows
                        If Not dtSpare Is Nothing Then
                            For Each rSpare In dtSpare.Rows
                                If rSpare("ID_DEB_SEQ") = rDebt("ID_DBT_SEQ") Then
                                    rSpare.BeginEdit()
                                    rSpare("ID_CUSTOMER") = woHeadCustId
                                    rSpare("ID_DEB_SEQ") = woHeadDebtId
                                    rSpare.AcceptChanges()
                                    rSpare.EndEdit()
                                    count = count + 1
                                    If count = rDebt("SPARECOUNT") Then
                                        count = 0
                                        Exit For
                                    End If
                                End If
                            Next
                        End If
                    Next
                End If

                HttpContext.Current.Session("WOSpareDetails") = dtSpare


                For Each dtrow As DataRow In dtSpare.Rows
                    Dim wojDet As New WOJobDetailBO()
                    wojDet.Id_WOItem_Seq = IIf(IsDBNull(dtrow("Id_WOITEM_SEQ")) = True, 0, dtrow("Id_WOITEM_SEQ"))
                    wojDet.Id_Wodet_Seq = IIf(IsDBNull(dtrow("Id_Wodet_Seq")) = True, 0, dtrow("Id_Wodet_Seq"))
                    wojDet.Id_Make = IIf(IsDBNull(dtrow("Id_Make")) = True, "", dtrow("Id_Make"))
                    wojDet.Id_Item_Catg_Job_Id = IIf(IsDBNull(dtrow("Id_Item_Catg_Job_Id")) = True, "", dtrow("Id_Item_Catg_Job_Id"))
                    wojDet.Id_Item_Catg = IIf(IsDBNull(dtrow("Id_Item_Catg")) = True, "", dtrow("Id_Item_Catg"))
                    wojDet.Id_Item = IIf(IsDBNull(dtrow("Id_Item")) = True, "", dtrow("Id_Item"))
                    wojDet.Item_Sp_Desc = IIf(IsDBNull(dtrow("Item_Sp_Desc")) = True, "", dtrow("Item_Sp_Desc"))
                    wojDet.Jobi_Order_Qty = IIf(IsDBNull(dtrow("Jobi_Order_Qty")) = True, "0", dtrow("Jobi_Order_Qty"))
                    wojDet.Jobi_Deliver_Qty = IIf(IsDBNull(dtrow("Jobi_Deliver_Qty")) = True, "0", dtrow("Jobi_Deliver_Qty"))
                    wojDet.Jobi_Bo_Qty = IIf(IsDBNull(dtrow("Jobi_BO_Qty")) = True, "0", dtrow("Jobi_BO_Qty"))
                    wojDet.Jobi_Sell_Price = IIf(IsDBNull(dtrow("Jobi_Sell_Price")) = True, "0", dtrow("Jobi_Sell_Price"))
                    wojDet.Jobi_Dis_Per = IIf(IsDBNull(dtrow("Jobi_Dis_Per")) = True, "0", dtrow("Jobi_Dis_Per"))
                    wojDet.Jobi_Vat_Per = IIf(IsDBNull(dtrow("Jobi_Vat_Per")) = True, "0", dtrow("Jobi_Vat_Per"))
                    wojDet.Jobi_Vat_Seq = IIf(IsDBNull(dtrow("Jobi_Vat_Seq")) = True, 0, dtrow("Jobi_Vat_Seq"))
                    wojDet.Jobi_Dis_Seq = IIf(IsDBNull(dtrow("Jobi_Dis_Seq")) = True, 0, dtrow("Jobi_Dis_Seq"))
                    wojDet.Sp_Slno = IIf(IsDBNull(dtrow("Sp_Slno")) = True, "1", dtrow("Sp_Slno"))
                    wojDet.Sp_Make = IIf(IsDBNull(dtrow("Sp_Make")) = True, "", dtrow("Sp_Make"))
                    wojDet.Id_Wh_Item = IIf(IsDBNull(dtrow("Id_Warehouse")) = True, 0, dtrow("Id_Warehouse"))
                    wojDet.Cost_Price = IIf(IsDBNull(dtrow("Cost_Price")) = True, "0", dtrow("Cost_Price"))
                    wojDet.Td_Calc = IIf(IsDBNull(dtrow("Td_Calc")) = True, "1", dtrow("Td_Calc"))
                    wojDet.Id_Deb_Seq = IIf(IsDBNull(dtrow("Id_Deb_Seq")) = True, 0, dtrow("Id_Deb_Seq"))
                    wojDet.Order_Line_Text = IIf(IsDBNull(dtrow("Order_Line_Text")) = True, "", dtrow("Order_Line_Text"))
                    wojDet.Id_Customer = IIf(IsDBNull(dtrow("Id_Customer")) = True, "", dtrow("Id_Customer"))
                    wojDet.Text = IIf(IsDBNull(dtrow("Text")) = True, "", dtrow("Text"))
                    wojDet.Sp_Location = IIf(IsDBNull(dtrow("Sp_Location")) = True, "", dtrow("Sp_Location"))
                    wojDet.Pickinglist_Prev_Printed = IIf(IsDBNull(dtrow("PICKINGLIST_PREV_PRINTED")) = True, "0", dtrow("PICKINGLIST_PREV_PRINTED"))
                    wojDet.Deliverynote_Prev_Printed = IIf(IsDBNull(dtrow("DELIVERYNOTE_PREV_PRINTED")) = True, "0", dtrow("DELIVERYNOTE_PREV_PRINTED"))
                    wojDet.Prev_Picked = IIf(IsDBNull(dtrow("PREV_PICKED")) = True, "0", dtrow("PREV_PICKED"))
                    wojDet.Spare_Type = IIf(IsDBNull(dtrow("SPARE_TYPE")) = True, "ORD", dtrow("SPARE_TYPE"))
                    wojDet.Flg_Force_Vat = IIf(IsDBNull(dtrow("FLG_FORCE_VAT")) = True, "0", dtrow("FLG_FORCE_VAT"))
                    wojDet.Flg_Edit_Sp = IIf(IsDBNull(dtrow("FLG_EDIT_SP")) = True, "0", dtrow("FLG_EDIT_SP"))
                    wojDet.Export_Type = IIf(IsDBNull(dtrow("EXPORT_TYPE")) = True, "", dtrow("EXPORT_TYPE"))
                    wojDet.Sp_Item_Price = IIf(IsDBNull(dtrow("Sp_Item_Price")) = True, "0", dtrow("Sp_Item_Price"))
                    wojDet.ToBe_Picked = IIf(IsDBNull(dtrow("TOBE_PICKED")) = True, "0", dtrow("TOBE_PICKED"))
                    details.Add(wojDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Transactions_frmWOJobDetails", "UpdateSpares", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserId"))
            End Try
            Return details.ToList

        End Function
        Public Function ReCalculateDebitorTotal(ByVal jobDiscount As String, ByVal labourAmt As String, ByVal gmPrice As String, ByVal gmVat As String, ByVal labVat As String, ByVal totalAmount As String, ByVal chckCustBasedVAT As String) As List(Of WOJobDetailBO)
            Dim dsSpare As New DataTable
            Dim dsRow As DataRow
            Dim rSpare As DataRow = Nothing
            Dim newAmount As Decimal = 0D
            Dim dtNewDebitor As New DataTable
            Dim debUser As DataRow
            Dim details As New List(Of WOJobDetailBO)()
            Try
                If Not (HttpContext.Current.Session("WOSpareDetails") Is Nothing) Then
                    dsSpare = HttpContext.Current.Session("WOSpareDetails")
                End If

                If Not dsSpare Is Nothing Then
                    Dim dtSpare As New DataTable
                    Dim dtRow As DataRow

                    dtSpare.Columns.Add("ID_DBT_SEQ")
                    dtSpare.Columns.Add("DBT_AMT", System.Type.GetType("System.Decimal"))
                    dtSpare.Columns.Add("DBT_SPR_VAT_PER")

                    For Each dsRow In dsSpare.Rows
                        dtRow = dtSpare.NewRow()
                        dtRow("DBT_AMT") = dsRow("Sp_Item_Price")
                        dtRow("ID_DBT_SEQ") = dsRow("ID_Deb_SEQ")
                        dtRow("DBT_SPR_VAT_PER") = dsRow("JOBI_VAT_PER")
                        dtSpare.Rows.Add(dtRow)
                    Next

                    dtNewDebitor.Columns.Add("ID_DBT_SEQ")
                    dtNewDebitor.Columns.Add("DBT_AMT")
                    dtNewDebitor.Columns.Add("DBT_SPR_VAT_PER")

                    If Not dtSpare Is Nothing Then
                        For Each rSpare In dtSpare.Rows
                            If dtNewDebitor.Select("ID_DBT_SEQ='" + rSpare.Item("ID_DBT_SEQ").ToString() + "'").Length > 0 Then
                                Continue For
                            Else
                                debUser = dtNewDebitor.NewRow()
                                newAmount = Convert.ToDecimal(dtSpare.Compute("Sum(DBT_AMT)", "ID_DBT_SEQ = '" + rSpare.Item("ID_DBT_SEQ").ToString() + "'"))
                                debUser("ID_DBT_SEQ") = rSpare.Item("ID_DBT_SEQ").ToString()
                                debUser("DBT_AMT") = newAmount
                                debUser("DBT_SPR_VAT_PER") = rSpare.Item("DBT_SPR_VAT_PER").ToString()
                                dtNewDebitor.Rows.Add(debUser)
                            End If
                        Next
                    End If

                    'ViewState("SpareDebitor") = dsNewDebitor

                    Dim dsDebitor As New DataTable
                    Dim drUser As DataRow
                    Dim drSpare As DataRow
                    Dim totAmountExSpare As Decimal = 0D
                    Dim totAmount As Decimal = 0D
                    Dim tempAmount As Decimal = 0D
                    Dim isDebExists As Boolean = False
                    Dim discounExLabour As Decimal = 0D
                    discounExLabour = Round((IIf(jobDiscount = "", 0D, jobDiscount) * IIf(labourAmt = "", 0D, labourAmt)) / 100, 2)
                    Dim discounExGarage As Decimal = 0D
                    discounExGarage = Round((IIf(jobDiscount = "", 0D, jobDiscount) * IIf(gmPrice = "", 0D, gmPrice)) / 100, 2)
                    totAmountExSpare = Convert.ToDecimal(IIf(labourAmt = "", 0D, labourAmt)) + Convert.ToDecimal(IIf(gmPrice = "", 0D, gmPrice)) + Convert.ToDecimal(IIf(gmVat = "", 0D, gmVat)) + Convert.ToDecimal(IIf(labVat = "", 0D, labVat)) - Convert.ToDecimal(discounExLabour + discounExGarage)
                    totAmount = Convert.ToDecimal(totalAmount)

                    dsDebitor = HttpContext.Current.Session("WODebDetails")
                    If Not dsDebitor Is Nothing Then
                        For Each drUser In dsDebitor.Rows
                            isDebExists = False
                            For Each drSpare In dtNewDebitor.Rows
                                If drUser.Item("ID_DBT_SEQ") = drSpare.Item("ID_DBT_SEQ") Then
                                    isDebExists = True
                                    If dsDebitor.Rows.Count = 1 Then
                                        drUser.BeginEdit()
                                        drUser.Item("DBT_AMT") = totAmountExSpare + drSpare.Item("DBT_AMT")
                                        drUser.Item("DBT_PER") = "100"
                                        drUser.AcceptChanges()
                                        drUser.EndEdit()
                                    Else
                                        If drUser.Item("ORGPERCENT").ToString.Length <> 0 Then
                                            tempAmount = (drUser.Item("ORGPERCENT") * totAmountExSpare) / 100
                                            drUser.BeginEdit()
                                            drUser.Item("DBT_AMT") = tempAmount + drSpare.Item("DBT_AMT")
                                            If dsDebitor.Rows.Count = 2 Then
                                                If (chckCustBasedVAT = "true") Then
                                                    If dsDebitor.Rows(0)("DBT_PER") = "0" Then
                                                        drUser.Item("DBT_PER") = "100"
                                                    Else
                                                        If dsDebitor.Rows(1)("DBT_PER").ToString.Length = 0 Then
                                                            dsDebitor.Rows(0)("DBT_PER") = "100"
                                                        Else
                                                            drUser.Item("DBT_PER") = drUser.Item("DBT_PER") 'drSpare.Item("DBT_PER")
                                                        End If
                                                    End If
                                                Else
                                                    If dsDebitor.Rows(1)("DBT_PER").ToString.Length = 0 Then
                                                        dsDebitor.Rows(0)("DBT_PER") = "100"
                                                    Else
                                                        drUser.Item("DBT_PER") = drUser.Item("DBT_PER") 'drSpare.Item("DBT_PER")
                                                    End If
                                                End If
                                            End If
                                            drUser.AcceptChanges()
                                            drUser.EndEdit()
                                        End If

                                    End If
                                    Exit For
                                End If
                            Next
                            If Not isDebExists Then
                                If dsDebitor.Rows.Count = 1 Then
                                    drUser.BeginEdit()
                                    drUser.Item("DBT_AMT") = totAmountExSpare
                                    drUser.Item("DBT_PER") = "100"
                                    drUser.AcceptChanges()
                                    drUser.EndEdit()
                                Else
                                    If drUser.Item("ORGPERCENT").ToString.Length <> 0 Then
                                        drUser.BeginEdit()
                                        tempAmount = (drUser.Item("ORGPERCENT") * totAmountExSpare) / 100
                                        drUser.Item("DBT_AMT") = tempAmount
                                        If dsDebitor.Rows.Count = 2 Then
                                            If dsDebitor.Rows(1)("DBT_PER").ToString.Length = 0 Or Val(drUser.Item("DBT_PER")) <> 0 Then
                                                dsDebitor.Rows(0)("DBT_PER") = "100"
                                            Else
                                                drUser.Item("DBT_PER") = drUser.Item("DBT_PER")
                                            End If
                                        End If
                                        drUser.Item("ORGPERCENT") = drUser.Item("DBT_PER")
                                        drUser.AcceptChanges()
                                        drUser.EndEdit()
                                    End If

                                End If
                            End If
                        Next
                    End If

                    Dim debitorPer As Decimal = 0D

                    For Each drUser In dsDebitor.Rows
                        If drUser.Item("ID_JOB_DEB") <> HttpContext.Current.Session("ID_CUST") Then
                            If drUser.Item("DBT_PER").ToString.Length <> 0 And Val(drUser.Item("DBT_PER")) <> 0 Then
                                debitorPer = debitorPer + Convert.ToDecimal(drUser.Item("DBT_PER").ToString())
                            End If
                        End If
                    Next

                    For Each drUser In dsDebitor.Rows
                        If drUser.Item("ID_JOB_DEB") = HttpContext.Current.Session("ID_CUST") Then
                            If drUser.Item("DBT_PER").ToString.Length <> 0 And Val(drUser.Item("DBT_PER")) <> 0 Then
                                drUser.BeginEdit()
                                drUser.Item("DBT_AMT") = Round((Round(100 - debitorPer, 2) * totAmount) / 100, 2)
                                drUser.Item("DBT_PER") = Round(100 - debitorPer, 2)
                                drUser.Item("ORGPERCENT") = drUser.Item("DBT_PER")
                                drUser.AcceptChanges()
                                drUser.EndEdit()
                            End If
                        End If
                    Next

                    HttpContext.Current.Session("WODebDetails") = dsDebitor
                    If dsDebitor.Rows.Count > 0 Then
                        For Each dtDebrow As DataRow In dsDebitor.Rows
                            Dim wojDet As New WOJobDetailBO()
                            wojDet.Job_Deb_Name = IIf(IsDBNull(dtDebrow("JOB_DEB_NAME")) = True, "", dtDebrow("JOB_DEB_NAME"))
                            wojDet.Dbt_Per = IIf(IsDBNull(dtDebrow("DBT_PER")) = True, "", dtDebrow("DBT_PER"))
                            wojDet.Dbt_Amt = IIf(IsDBNull(dtDebrow("DBT_AMT")) = True, "", dtDebrow("DBT_AMT"))
                            wojDet.Id_Job_Deb = IIf(IsDBNull(dtDebrow("ID_JOB_DEB")) = True, "", dtDebrow("ID_JOB_DEB"))
                            wojDet.Id_Deb_Seq = IIf(IsDBNull(dtDebrow("ID_DBT_SEQ")) = True, 0, dtDebrow("ID_DBT_SEQ"))
                            wojDet.Deb_Sl_No = IIf(IsDBNull(dtDebrow("SLNO")) = True, "", dtDebrow("SLNO"))
                            wojDet.Spare_Count = IIf(IsDBNull(dtDebrow("SPARECOUNT")) = True, "", dtDebrow("SPARECOUNT"))
                            wojDet.Org_Per = IIf(IsDBNull(dtDebrow("ORGPERCENT")) = True, "", dtDebrow("ORGPERCENT"))

                            details.Add(wojDet)
                        Next
                    End If
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Transactions_frmWOJobDetails", "ReCalculateDebitorTotal", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserId"))
            End Try
            Return details.ToList
        End Function
        Public Function InsertEditDebitoronLine()
            Try
                Dim objdsspare As New DataTable
                Dim objdsdebitor As New DataTable
                Dim tempdr As DataRow() = Nothing

                Dim dsDebitor As New DataTable
                Dim rUser As DataRow
                Dim dsReturnVal As DataSet = Nothing

                Dim dsSpare As New DataTable
                Dim rSpare As DataRow = Nothing
                Dim debitorOL As String = String.Empty
                Dim debitorID As Int32 = 0

                If Not (HttpContext.Current.Session("WOSpareDetails")) Is Nothing Then
                    objdsspare = HttpContext.Current.Session("WOSpareDetails")
                End If
                If Not (HttpContext.Current.Session("WODebDetails")) Is Nothing Then
                    objdsdebitor = HttpContext.Current.Session("WODebDetails")
                End If

                If Not objdsspare Is Nothing Then
                    dsSpare = objdsspare
                Else
                    Exit Function
                End If

                For Each rUser In objdsdebitor.Rows
                    rUser.BeginEdit()
                    rUser.Item("SPARECOUNT") = 0
                    rUser.AcceptChanges()
                    rUser.EndEdit()
                Next

                If dsSpare.Rows.Count = 0 Then
                    dsDebitor = objdsdebitor
                End If

                For Each rSpare In dsSpare.Rows
                    If IsDBNull(rSpare("ID_CUSTOMER")) Then
                        Continue For
                    ElseIf rSpare("ID_CUSTOMER").ToString() <> String.Empty Then
                        debitorOL = rSpare("ID_CUSTOMER").ToString()
                        debitorID = Convert.ToInt32(IIf(IsDBNull(rSpare("ID_DEB_SEQ")) = True, 0, rSpare("ID_DEB_SEQ")))

                        If HttpContext.Current.Session("WODebDetails") Is Nothing Then
                            dsDebitor.Columns.Add("ID_JOB_DEB")
                            dsDebitor.Columns.Add("JOB_DEB_NAME")
                            dsDebitor.Columns.Add("DBT_PER")
                            dsDebitor.Columns.Add("DBT_AMT")
                            dsDebitor.Columns.Add("DEBITOR_TYPE")
                            dsDebitor.Columns.Add("ID_DBT_SEQ") '-------- Added
                            dsDebitor.Columns.Add("SLNO")
                            dsDebitor.Columns.Add("SPARECOUNT")
                            dsDebitor.Columns.Add("ORGPERCENT")
                            dsDebitor.Columns.Add("WO_VAT_PERCENTAGE") 'Spare part Vat Per
                            dsDebitor.Columns.Add("WO_GM_PER") 'Garage Material  Percentage
                            dsDebitor.Columns.Add("WO_GM_VATPER") 'Garage Material Vat Percentage
                            dsDebitor.Columns.Add("WO_LBR_VATPER") 'Labour Vat Percentage
                            dsDebitor.Columns.Add("WO_SPR_DISCPER") 'Spare Part Discount Percentage
                            dsDebitor.Columns.Add("WO_FIXED_VATPER") 'Fixed Price Vat Percentage                        
                            'End of Modification

                            rUser = dsDebitor.NewRow()
                            rUser("ID_JOB_DEB") = debitorOL

                            'To get the Customer Name
                            dsReturnVal = objCustomerDO.Fetch_Customer(debitorOL)

                            Dim drCustomer As DataRow()
                            If dsReturnVal.Tables.Count <> 0 Then
                                drCustomer = dsReturnVal.Tables(0).Select("ID_CUSTOMER  = '" & rUser("ID_JOB_DEB") & "'")
                                If drCustomer.Length = 1 Then
                                    rUser("JOB_DEB_NAME") = drCustomer(0)("CUST_NAME").ToString()
                                End If
                            End If

                            rUser("DBT_PER") = "0"
                            rUser("DBT_AMT") = rSpare.Item("TOTAL_PRICE").ToString()
                            rUser("DEBITOR_TYPE") = "D"
                            rUser("ID_DBT_SEQ") = CStr(IIf(IsDBNull(dsDebitor.Compute("MAX(ID_DBT_SEQ)", "") + 1) = True, 1, dsDebitor.Compute("MAX(ID_DBT_SEQ)", "") + 1))
                            rUser("SLNO") = CStr(IIf(IsDBNull(dsDebitor.Compute("MAX(ID_DBT_SEQ)", "") + 1) = True, 1, dsDebitor.Compute("MAX(ID_DBT_SEQ)", "") + 1))
                            rUser("SPARECOUNT") = 1
                            rUser("ORGPERCENT") = "0"

                            rUser("WO_VAT_PERCENTAGE") = 0.0 'Spare part Vat Per
                            rUser("WO_GM_PER") = 0.0 'Garage Material  Percentage
                            rUser("WO_GM_VATPER") = 0.0 'Garage Material Vat Percentage
                            rUser("WO_LBR_VATPER") = 0.0 'Labour Vat Percentage
                            rUser("WO_SPR_DISCPER") = 0.0
                            rUser("WO_FIXED_VATPER") = 0.0 'Fixed Price Vat Percentage                        

                            dsDebitor.Rows.Add(rUser)

                            'Update the ID_DBT_SEQ(Debitor Id) in the spares dataset
                            rSpare.BeginEdit()
                            rSpare.Item("ID_DBT_SEQ") = rUser.Item("ID_DBT_SEQ")
                            rSpare.AcceptChanges()
                            rSpare.EndEdit()
                        Else
                            dsDebitor = CType(HttpContext.Current.Session("WODebDetails"), DataTable)
                            tempdr = dsDebitor.Select("ID_JOB_DEB='" + debitorOL.ToString() + "'")

                            If tempdr.Length = 1 Then
                                'Record already exist, hence update the amount and update the Debitor Id in the spares dataset
                                'Update the Amount in the debitor dataset
                                tempdr(0).BeginEdit()
                                tempdr(0).Item("SPARECOUNT") = tempdr(0).Item("SPARECOUNT") + 1
                                tempdr(0).AcceptChanges()
                                tempdr(0).EndEdit()

                                'Update the ID_DBT_SEQ(Debitor Id) in the spares dataset
                                rSpare.BeginEdit()
                                rSpare.Item("ID_DEB_SEQ") = tempdr(0).Item("ID_DBT_SEQ")
                                rSpare.AcceptChanges()
                                rSpare.EndEdit()

                            ElseIf tempdr.Length = 0 Then
                                rUser = dsDebitor.NewRow()
                                rUser("ID_JOB_DEB") = debitorOL

                                'To get the Customer Name
                                dsReturnVal = objCustomerDO.Fetch_Customer(debitorOL)

                                Dim drCustomer As DataRow()
                                If dsReturnVal.Tables.Count <> 0 Then
                                    drCustomer = dsReturnVal.Tables(0).Select("ID_CUSTOMER  = '" & rUser("ID_JOB_DEB") & "'")
                                    If drCustomer.Length = 1 Then
                                        rUser("JOB_DEB_NAME") = drCustomer(0)("CUST_NAME").ToString()
                                    End If
                                End If

                                rUser("DBT_PER") = "0"
                                rUser("DBT_AMT") = "0"
                                rUser("DEBITOR_TYPE") = "D"
                                rUser("ID_DBT_SEQ") = CStr(IIf(IsDBNull(dsDebitor.Compute("MAX(ID_DBT_SEQ)", "") + 1) = True, 1, dsDebitor.Compute("MAX(ID_DBT_SEQ)", "") + 1))
                                rUser("SLNO") = CStr(IIf(IsDBNull(dsDebitor.Compute("MAX(ID_DBT_SEQ)", "") + 1) = True, 1, dsDebitor.Compute("MAX(ID_DBT_SEQ)", "") + 1))
                                rUser("SPARECOUNT") = 1
                                rUser("WO_VAT_PERCENTAGE") = 0.0 'Spare part Vat Per
                                rUser("WO_GM_PER") = 0.0 'Garage Material  Percentage
                                rUser("WO_GM_VATPER") = 0.0 'Garage Material Vat Percentage
                                rUser("WO_LBR_VATPER") = 0.0 'Labour Vat Percentage
                                rUser("WO_SPR_DISCPER") = 0.0
                                rUser("ORGPERCENT") = "0"
                                rUser("WO_FIXED_VATPER") = 0.0 'Fixed Price Vat Percentage                        

                                dsDebitor.Rows.Add(rUser)

                                'Update the ID_DBT_SEQ(Debitor Id) in the spares dataset
                                rSpare.BeginEdit()
                                rSpare("ID_DEB_SEQ") = rUser("ID_DBT_SEQ")
                                rSpare.AcceptChanges()
                                rSpare.EndEdit()

                            End If
                        End If
                    End If
                Next

                HttpContext.Current.Session("WODebDetails") = dsDebitor
                HttpContext.Current.Session("WOSpareDetails") = dsSpare

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Transactions_frmWOJobDetails", "InsertEditDebitoronLine", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserId"))
            End Try
        End Function
        Public Function ChangeSpareVatDetails(ByVal debtCustId As String) As List(Of WOJobDetailBO)
            Dim details As New List(Of WOJobDetailBO)()
            Try
                Dim dtSpare As New DataTable
                Dim dsCust As DataSet = Nothing
                Dim objdsvatdisc As New DataSet

                dtSpare = HttpContext.Current.Session("WOSpareDetails")
                objWOJBO.Id_Customer = debtCustId ' custId
                objWOJBO.WO_Id_Veh = HttpContext.Current.Session("Veh_Seq_No") 'vehId
                objWOJBO.Created_By = HttpContext.Current.Session("UserId")

                If Not (HttpContext.Current.Session("WOSpareDetails") Is Nothing) Then
                    For Each dtrow As DataRow In dtSpare.Rows
                        objWOJBO.Item_Sp_Desc = dtrow("Id_Item")
                        objWOJBO.Id_Item = dtrow("Id_Item")
                        objdsvatdisc = objWOJDO.Fetch_Spares(objWOJBO)

                        If objdsvatdisc.Tables.Count > 0 Then
                            objdsvatdisc.Tables(0).DefaultView.RowFilter = "ID_ITEM='" + dtSpare.Rows(0)("ID_ITEM") + "'"
                            If objdsvatdisc.Tables(0).DefaultView.Count = 1 Then
                                dtSpare.Rows(0)("JOBI_VAT_PER") = IIf(IsDBNull(objdsvatdisc.Tables(0).DefaultView.Item(0)("JOBI_VAT_PER")) = True, "", objdsvatdisc.Tables(0).DefaultView.Item(0)("JOBI_VAT_PER"))
                                dtSpare.Rows(0)("ID_Customer") = debtCustId
                            End If

                            dsCust = objWOJDO.Cust_CostPriceDetails(debtCustId)
                            If dsCust.Tables(0).Rows.Count > 0 Then
                                If IIf(IsDBNull(dsCust.Tables(0).Rows(0)("FLG_CPRICE")) = True, False, dsCust.Tables(0).Rows(0)("FLG_CPRICE")) = True And dtSpare.Rows(0)("SPARE_TYPE") <> "EFD" And IIf(IsDBNull(dtSpare.Rows(0)("FLG_EDIT_SP")) = True, False, dtSpare.Rows(0)("FLG_EDIT_SP")) = False Then
                                    dtSpare.Rows(0)("JOBI_SELL_PRICE") = dtSpare.Rows(0)("COST_PRICE") + (dtSpare.Rows(0)("COST_PRICE") * CDbl(dsCust.Tables(0).Rows(0)("CUST_COSTPRICE")) / 100)
                                    dtSpare.Rows(0)("Sp_Item_Price") = dtSpare.Rows(0)("JOBI_SELL_PRICE") * dtSpare.Rows(0)("JOBI_DELIVER_QTY")
                                Else
                                    dtSpare.Rows(0)("JOBI_SELL_PRICE") = dtSpare.Rows(0)("JOBI_SELL_PRICE")
                                End If
                            End If
                        End If
                    Next

                    HttpContext.Current.Session("WOSpareDetails") = dtSpare
                    For Each dtrow As DataRow In dtSpare.Rows
                        Dim wojDet As New WOJobDetailBO()
                        wojDet.Id_WOItem_Seq = IIf(IsDBNull(dtrow("Id_WOITEM_SEQ")) = True, 0, dtrow("Id_WOITEM_SEQ"))
                        wojDet.Id_Wodet_Seq = IIf(IsDBNull(dtrow("Id_Wodet_Seq")) = True, 0, dtrow("Id_Wodet_Seq"))
                        wojDet.Id_Make = IIf(IsDBNull(dtrow("Id_Make")) = True, "", dtrow("Id_Make"))
                        wojDet.Id_Item_Catg_Job_Id = IIf(IsDBNull(dtrow("Id_Item_Catg_Job_Id")) = True, "", dtrow("Id_Item_Catg_Job_Id"))
                        wojDet.Id_Item_Catg = IIf(IsDBNull(dtrow("Id_Item_Catg")) = True, "", dtrow("Id_Item_Catg"))
                        wojDet.Id_Item = IIf(IsDBNull(dtrow("Id_Item")) = True, "", dtrow("Id_Item"))
                        wojDet.Item_Sp_Desc = IIf(IsDBNull(dtrow("Item_Sp_Desc")) = True, "", dtrow("Item_Sp_Desc"))
                        wojDet.Jobi_Order_Qty = IIf(IsDBNull(dtrow("Jobi_Order_Qty")) = True, "0", dtrow("Jobi_Order_Qty"))
                        wojDet.Jobi_Deliver_Qty = IIf(IsDBNull(dtrow("Jobi_Deliver_Qty")) = True, "0", dtrow("Jobi_Deliver_Qty"))
                        wojDet.Jobi_Bo_Qty = IIf(IsDBNull(dtrow("Jobi_BO_Qty")) = True, "0", dtrow("Jobi_BO_Qty"))
                        wojDet.Jobi_Sell_Price = IIf(IsDBNull(dtrow("Jobi_Sell_Price")) = True, "0", dtrow("Jobi_Sell_Price"))
                        wojDet.Jobi_Dis_Per = IIf(IsDBNull(dtrow("Jobi_Dis_Per")) = True, "0", dtrow("Jobi_Dis_Per"))
                        wojDet.Jobi_Vat_Per = IIf(IsDBNull(dtrow("Jobi_Vat_Per")) = True, "0", dtrow("Jobi_Vat_Per"))
                        wojDet.Jobi_Vat_Seq = IIf(IsDBNull(dtrow("Jobi_Vat_Seq")) = True, 0, dtrow("Jobi_Vat_Seq"))
                        wojDet.Jobi_Dis_Seq = IIf(IsDBNull(dtrow("Jobi_Dis_Seq")) = True, 0, dtrow("Jobi_Dis_Seq"))
                        wojDet.Sp_Slno = IIf(IsDBNull(dtrow("Sp_Slno")) = True, "1", dtrow("Sp_Slno"))
                        wojDet.Sp_Make = IIf(IsDBNull(dtrow("Sp_Make")) = True, "", dtrow("Sp_Make"))
                        wojDet.Id_Wh_Item = IIf(IsDBNull(dtrow("Id_Warehouse")) = True, 0, dtrow("Id_Warehouse"))
                        wojDet.Cost_Price = IIf(IsDBNull(dtrow("Cost_Price")) = True, "0", dtrow("Cost_Price"))
                        wojDet.Td_Calc = IIf(IsDBNull(dtrow("Td_Calc")) = True, "1", dtrow("Td_Calc"))
                        wojDet.Id_Deb_Seq = IIf(IsDBNull(dtrow("Id_Deb_Seq")) = True, 0, dtrow("Id_Deb_Seq"))
                        wojDet.Order_Line_Text = IIf(IsDBNull(dtrow("Order_Line_Text")) = True, "", dtrow("Order_Line_Text"))
                        wojDet.Id_Customer = IIf(IsDBNull(dtrow("Id_Customer")) = True, "", dtrow("Id_Customer"))
                        wojDet.Text = IIf(IsDBNull(dtrow("Text")) = True, "", dtrow("Text"))
                        wojDet.Sp_Location = IIf(IsDBNull(dtrow("Sp_Location")) = True, "", dtrow("Sp_Location"))
                        wojDet.Pickinglist_Prev_Printed = IIf(IsDBNull(dtrow("PICKINGLIST_PREV_PRINTED")) = True, "0", dtrow("PICKINGLIST_PREV_PRINTED"))
                        wojDet.Deliverynote_Prev_Printed = IIf(IsDBNull(dtrow("DELIVERYNOTE_PREV_PRINTED")) = True, "0", dtrow("DELIVERYNOTE_PREV_PRINTED"))
                        wojDet.Prev_Picked = IIf(IsDBNull(dtrow("PREV_PICKED")) = True, "0", dtrow("PREV_PICKED"))
                        wojDet.Spare_Type = IIf(IsDBNull(dtrow("SPARE_TYPE")) = True, "ORD", dtrow("SPARE_TYPE"))
                        wojDet.Flg_Force_Vat = IIf(IsDBNull(dtrow("FLG_FORCE_VAT")) = True, "0", dtrow("FLG_FORCE_VAT"))
                        wojDet.Flg_Edit_Sp = IIf(IsDBNull(dtrow("FLG_EDIT_SP")) = True, "0", dtrow("FLG_EDIT_SP"))
                        wojDet.Export_Type = IIf(IsDBNull(dtrow("EXPORT_TYPE")) = True, "", dtrow("EXPORT_TYPE"))
                        wojDet.Sp_Item_Price = IIf(IsDBNull(dtrow("Sp_Item_Price")) = True, "0", dtrow("Sp_Item_Price"))
                        wojDet.ToBe_Picked = IIf(IsDBNull(dtrow("TOBE_PICKED")) = True, "0", dtrow("TOBE_PICKED"))
                        details.Add(wojDet)
                    Next
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Transactions_frmWOJobDetails", "ChangeSpareVatDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserId"))
            End Try
            Return details.ToList

        End Function
        Public Function LoadWOMechanics() As List(Of WOJobDetailBO)
            Dim details As New List(Of WOJobDetailBO)()
            Try
                Dim dtMechanics As New DataTable
                dtMechanics = HttpContext.Current.Session("WOMechanics")
                For Each dtrow As DataRow In dtMechanics.Rows
                    Dim wojDet As New WOJobDetailBO()
                    wojDet.First_Name = IIf(IsDBNull(dtrow("MechanicName")) = True, "", dtrow("MechanicName"))
                    wojDet.Id_Login = IIf(IsDBNull(dtrow("Id_Login")) = True, "", dtrow("Id_Login"))
                    wojDet.Id_Seq = IIf(IsDBNull(dtrow("Id_Seq")) = True, "0", dtrow("Id_Seq"))
                    details.Add(wojDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Transactions_frmWOJobDetails", "WOMechanics", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserId"))
            End Try
            Return details.ToList
        End Function
        Public Function FetchClockTime(ByVal idWONO As String, ByVal idWOPrefix As String, ByVal idJob As String) As String
            Dim dsclocktime As New DataSet
            Dim strout As String
            Dim stroutput As String
            Dim clkTime As String = ""
            Try
                dsclocktime = objWOJDO.Fetch_ClockTime(idWONO, idWOPrefix, idJob)
                If Not IsNothing(dsclocktime) Then
                    If dsclocktime.Tables(1).Rows.Count > 0 Then
                        clkTime = IIf(IsDBNull(dsclocktime.Tables(1).Rows(0)("TimeFormat".ToString)) = True, "", dsclocktime.Tables(1).Rows(0)("TimeFormat".ToString))
                    End If
                    If UCase(clkTime) = UCase("Hrs") Then
                        If dsclocktime.Tables(0).Rows.Count > 0 Then
                            strout = IIf(IsDBNull(dsclocktime.Tables(0).Rows(0)("Hours".ToString)) = True, "0", dsclocktime.Tables(0).Rows(0)("Hours".ToString))
                            strout = IIf(IsDBNull(dsclocktime.Tables(0).Rows(0)("clocktime".ToString)) = True, "0", dsclocktime.Tables(0).Rows(0)("clocktime".ToString))
                            'txtClkTimeShow.Text = strout
                            HttpContext.Current.Session("TxtClkTime") = strout
                            clkTime = strout
                        End If
                    ElseIf UCase(clkTime) = UCase("Hrs & min") Then
                        stroutput = IIf(IsDBNull(dsclocktime.Tables(0).Rows(0)("clocktime".ToString)) = True, "0", dsclocktime.Tables(0).Rows(0)("clocktime".ToString))
                        If stroutput = "0" Then
                            stroutput = "0:00"
                        End If
                        'txtClkTimeShow.Text = stroutput
                        strout = IIf(IsDBNull(dsclocktime.Tables(0).Rows(0)("Hours".ToString)) = True, "0", dsclocktime.Tables(0).Rows(0)("Hours".ToString))
                        HttpContext.Current.Session("TxtClkTime") = stroutput ' strout + "." + ConvertDecMins(IIf(IsDBNull(dsclocktime.Tables(0).Rows(0)("Minutes".ToString)) = True, "0", dsclocktime.Tables(0).Rows(0)("Minutes".ToString)))
                        strout = IIf(IsDBNull(dsclocktime.Tables(0).Rows(0)("clocktime".ToString)) = True, "0", dsclocktime.Tables(0).Rows(0)("clocktime".ToString))
                        clkTime = strout
                    Else
                        If dsclocktime.Tables(0).Rows.Count > 0 Then
                            strout = IIf(IsDBNull(dsclocktime.Tables(0).Rows(0)("Hours".ToString)) = True, "", dsclocktime.Tables(0).Rows(0)("Hours".ToString))
                            If strout <> "" Then
                                strout = strout + ":" + objCommonUtil.ConvertDecMins(IIf(IsDBNull(dsclocktime.Tables(0).Rows(0)("Minutes".ToString)) = True, "", dsclocktime.Tables(0).Rows(0)("Minutes".ToString)))
                                clkTime = strout
                            End If
                        End If
                    End If
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Transactions_frmWOJobDetails", "FetchClockTime", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserId"))
            End Try
            Return clkTime
        End Function
        Public Function CalculateSpDiscount(ByVal spdiscount As String) As List(Of WOJobDetailBO)
            Dim details As New List(Of WOJobDetailBO)()
            Try
                Dim dtSpare As New DataTable
                Dim rSpare As DataRow = Nothing
                Dim SP As Double = 0.0
                Dim CP As Double = 0.0
                Dim OrdQty As Double = 0.0
                Dim QtyDel As Double = 0.0
                Dim QtybackOrd As Double = 0.0
                Dim Discount As Double = 0.0
                Dim VAT As Double = 0.0
                Dim Noth As Decimal = 0.0
                dtSpare = HttpContext.Current.Session("WOSpareDetails")

                For j As Integer = 0 To dtSpare.Rows.Count - 1
                    Dim VATperc As Decimal = 0.0
                    SP = CDbl(dtSpare.Rows(j).Item("JOBI_SELL_PRICE").ToString())
                    CP = CDbl(dtSpare.Rows(j).Item("COST_PRICE").ToString())
                    OrdQty = CDbl(dtSpare.Rows(j).Item("JOBI_ORDER_QTY").ToString())
                    QtyDel = CDbl(dtSpare.Rows(j).Item("JOBI_DELIVER_QTY").ToString())
                    QtybackOrd = CDbl(dtSpare.Rows(j).Item("JOBI_BO_QTY").ToString())
                    Discount = CDbl(dtSpare.Rows(j).Item("JOBI_DIS_PER").ToString())
                    If Discount = 0D Then
                        Discount = IIf(spdiscount = "", 0D, spdiscount)
                    End If
                    VAT = CDbl(dtSpare.Rows(j).Item("JOBI_VAT_PER").ToString())
                    If Convert.ToDouble(Discount) >= 0 Then
                        Noth = Convert.ToDecimal(Convert.ToDouble(Discount))
                    Else
                        Noth = Nothing
                    End If

                    dtSpare.Rows(j).Item("JOBI_DIS_PER") = Convert.ToString(Noth)
                    dtSpare.Rows(j).Item("Sp_Item_Price") = Round(Convert.ToDecimal(Convert.ToDouble(QtyDel) * Convert.ToDouble(SP)) - (Convert.ToDouble(QtyDel) * Convert.ToDouble(SP) * 0.01 * Convert.ToDouble(Discount)), 2)
                Next

                HttpContext.Current.Session("WOSpareDetails") = dtSpare

                For Each dtrow As DataRow In dtSpare.Rows
                    Dim wojDet As New WOJobDetailBO()
                    wojDet.Id_WOItem_Seq = IIf(IsDBNull(dtrow("Id_WOITEM_SEQ")) = True, 0, dtrow("Id_WOITEM_SEQ"))
                    wojDet.Id_Wodet_Seq = IIf(IsDBNull(dtrow("Id_Wodet_Seq")) = True, 0, dtrow("Id_Wodet_Seq"))
                    wojDet.Id_Make = IIf(IsDBNull(dtrow("Id_Make")) = True, "", dtrow("Id_Make"))
                    wojDet.Id_Item_Catg_Job_Id = IIf(IsDBNull(dtrow("Id_Item_Catg_Job_Id")) = True, "", dtrow("Id_Item_Catg_Job_Id"))
                    wojDet.Id_Item_Catg = IIf(IsDBNull(dtrow("Id_Item_Catg")) = True, "", dtrow("Id_Item_Catg"))
                    wojDet.Id_Item = IIf(IsDBNull(dtrow("Id_Item")) = True, "", dtrow("Id_Item"))
                    wojDet.Item_Sp_Desc = IIf(IsDBNull(dtrow("Item_Sp_Desc")) = True, "", dtrow("Item_Sp_Desc"))
                    wojDet.Jobi_Order_Qty = IIf(IsDBNull(dtrow("Jobi_Order_Qty")) = True, "0", dtrow("Jobi_Order_Qty"))
                    wojDet.Jobi_Deliver_Qty = IIf(IsDBNull(dtrow("Jobi_Deliver_Qty")) = True, "0", dtrow("Jobi_Deliver_Qty"))
                    wojDet.Jobi_Bo_Qty = IIf(IsDBNull(dtrow("Jobi_BO_Qty")) = True, "0", dtrow("Jobi_BO_Qty"))
                    wojDet.Jobi_Sell_Price = IIf(IsDBNull(dtrow("Jobi_Sell_Price")) = True, "0", dtrow("Jobi_Sell_Price"))
                    wojDet.Jobi_Dis_Per = IIf(IsDBNull(dtrow("Jobi_Dis_Per")) = True, "0", dtrow("Jobi_Dis_Per"))
                    wojDet.Jobi_Vat_Per = IIf(IsDBNull(dtrow("Jobi_Vat_Per")) = True, "0", dtrow("Jobi_Vat_Per"))
                    wojDet.Jobi_Vat_Seq = IIf(IsDBNull(dtrow("Jobi_Vat_Seq")) = True, 0, dtrow("Jobi_Vat_Seq"))
                    wojDet.Jobi_Dis_Seq = IIf(IsDBNull(dtrow("Jobi_Dis_Seq")) = True, 0, dtrow("Jobi_Dis_Seq"))
                    wojDet.Sp_Slno = IIf(IsDBNull(dtrow("Sp_Slno")) = True, "1", dtrow("Sp_Slno"))
                    wojDet.Sp_Make = IIf(IsDBNull(dtrow("Sp_Make")) = True, "", dtrow("Sp_Make"))
                    wojDet.Id_Wh_Item = IIf(IsDBNull(dtrow("Id_Warehouse")) = True, 0, dtrow("Id_Warehouse"))
                    wojDet.Cost_Price = IIf(IsDBNull(dtrow("Cost_Price")) = True, "0", dtrow("Cost_Price"))
                    wojDet.Td_Calc = IIf(IsDBNull(dtrow("Td_Calc")) = True, "1", dtrow("Td_Calc"))
                    wojDet.Id_Deb_Seq = IIf(IsDBNull(dtrow("Id_Deb_Seq")) = True, 0, dtrow("Id_Deb_Seq"))
                    wojDet.Order_Line_Text = IIf(IsDBNull(dtrow("Order_Line_Text")) = True, "", dtrow("Order_Line_Text"))
                    wojDet.Id_Customer = IIf(IsDBNull(dtrow("Id_Customer")) = True, "", dtrow("Id_Customer"))
                    wojDet.Text = IIf(IsDBNull(dtrow("Text")) = True, "", dtrow("Text"))
                    wojDet.Sp_Location = IIf(IsDBNull(dtrow("Sp_Location")) = True, "", dtrow("Sp_Location"))
                    wojDet.Pickinglist_Prev_Printed = IIf(IsDBNull(dtrow("PICKINGLIST_PREV_PRINTED")) = True, "0", dtrow("PICKINGLIST_PREV_PRINTED"))
                    wojDet.Deliverynote_Prev_Printed = IIf(IsDBNull(dtrow("DELIVERYNOTE_PREV_PRINTED")) = True, "0", dtrow("DELIVERYNOTE_PREV_PRINTED"))
                    wojDet.Prev_Picked = IIf(IsDBNull(dtrow("PREV_PICKED")) = True, "0", dtrow("PREV_PICKED"))
                    wojDet.Spare_Type = IIf(IsDBNull(dtrow("SPARE_TYPE")) = True, "ORD", dtrow("SPARE_TYPE"))
                    wojDet.Flg_Force_Vat = IIf(IsDBNull(dtrow("FLG_FORCE_VAT")) = True, "0", dtrow("FLG_FORCE_VAT"))
                    wojDet.Flg_Edit_Sp = IIf(IsDBNull(dtrow("FLG_EDIT_SP")) = True, "0", dtrow("FLG_EDIT_SP"))
                    wojDet.Export_Type = IIf(IsDBNull(dtrow("EXPORT_TYPE")) = True, "", dtrow("EXPORT_TYPE"))
                    wojDet.Sp_Item_Price = IIf(IsDBNull(dtrow("Sp_Item_Price")) = True, "0", dtrow("Sp_Item_Price"))
                    wojDet.ToBe_Picked = IIf(IsDBNull(dtrow("TOBE_PICKED")) = True, "0", dtrow("TOBE_PICKED"))
                    details.Add(wojDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Transactions_frmWOJobDetails", "CalculateSpDiscount", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserId"))
            End Try
            Return details.ToList

        End Function
        Public Function CheckCreditLimit() As String
            Dim dtDebitor As New DataTable
            Dim objWOHDO As New CARS.WOHeader.WOHeaderDO
            Dim objWOHeaderBO As New WOHeaderBO
            Try
                dtDebitor = HttpContext.Current.Session("WODebDetails")
                For i As Integer = 0 To dtDebitor.Rows.Count - 1
                    Dim TotCrAmt = 0.0, BalCrAmt As Decimal = 0.0
                    Dim dsReturnValTmp As New DataSet

                    objWOHeaderBO.Id_Cust_Wo = dtDebitor.Rows(i).Item("Id_Job_Deb").ToString()
                    dsReturnValTmp = objWOHDO.deb_details(objWOHeaderBO)

                    If dsReturnValTmp.Tables(3).Rows.Count > 0 Then
                        BalCrAmt = Convert.ToDecimal(dsReturnValTmp.Tables(3).Rows(0).Item(0))
                    End If
                    If dsReturnValTmp.Tables(4).Rows.Count > 0 Then
                        TotCrAmt = Convert.ToDecimal(IIf(IsDBNull(dsReturnValTmp.Tables(4).Rows(0).Item(0)), 0, dsReturnValTmp.Tables(4).Rows(0).Item(0)))
                        TotCrAmt = TotCrAmt + Convert.ToDecimal(dtDebitor.Rows(i).Item("DBT_AMT").ToString())
                    End If

                    If dtDebitor.Rows(i).Item("Id_Job_Deb").ToString() <> HttpContext.Current.Session("DEB_ID") Then
                        If dsReturnValTmp.Tables(5).Rows.Count > 0 Then
                            If dsReturnValTmp.Tables(5).Rows(0).Item("Description").ToString.ToUpper <> "CASH" Then
                                ''Checking for customer credit is 0- Infinite credit limit.
                                If BalCrAmt <> 0 Then
                                    If (BalCrAmt - TotCrAmt) < 0 Then
                                        Dim message As String = objErrHandle.GetErrorDesc("CCREDIT") + " " + dtDebitor.Rows(i).Item("Id_Job_Deb").ToString() + objErrHandle.GetErrorDesc("MESS_CONFIRM") '"Credit Limit Exceeds For The Customer..Do want to Continue?"
                                        Return message
                                    End If
                                End If
                            End If
                        End If
                    Else
                        If (HttpContext.Current.Session("WO_CR_TYPE").ToString.ToUpper <> "CASH") Then
                            If BalCrAmt <> 0 Then
                                If (BalCrAmt - TotCrAmt) < 0 Then
                                    Dim message As String = objErrHandle.GetErrorDesc("CCREDIT") + " " + dtDebitor.Rows(i).Item("Id_Job_Deb").ToString() + "." + objErrHandle.GetErrorDesc("MESS_CONFIRM") '"Credit Limit Exceeds For The Customer..Do want to Continue?"
                                    Return message
                                End If
                            Else
                                If dsReturnValTmp.Tables(6).Rows(0).Item("FLG_CUST_NOCREDIT").ToString.ToUpper = "TRUE" Then
                                    Dim message As String = objErrHandle.GetErrorDescParameter("NOCREDIT") + " " + dtDebitor.Rows(i).Item("Id_Job_Deb").ToString()
                                    Return message
                                End If
                            End If

                        End If
                    End If
                    dsReturnValTmp = Nothing
                Next
                Return True

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "WOJobDetails", "chkCreditLimit", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
        End Function
        Public Function LoadReport(ByVal reportType As String, ByVal reportRequest As String) As List(Of WOJobDetailBO)
            Dim details As New List(Of WOJobDetailBO)()
            Try
                Dim strVal As String = ""
                Dim default_pickd As Double = 0
                Dim dtSpare As New DataTable
                Dim WONO As String = HttpContext.Current.Session("WONO")
                Dim WOPREFIX As String = HttpContext.Current.Session("WOPR")
                Dim dtWOSpareParts As New DataTable
                Dim strXMLSpareParts As String = ""

                dtWOSpareParts = HttpContext.Current.Session("WOSpareDetails")
                Dim dv As DataView = dtWOSpareParts.DefaultView
                dv.RowFilter = "Diff = 'S'"
                dtWOSpareParts = dv.ToTable


                Select Case reportType
                    Case "PICKINGLIST"
                        strXMLSpareParts = "<root>"
                        If Not dtWOSpareParts Is Nothing Then
                            For i As Integer = 0 To dtWOSpareParts.DefaultView.Count - 1
                                strXMLSpareParts += "<insert ID_ITEM_JOB=""" + objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("ID_ITEM").ToString) + """"
                                strXMLSpareParts += " ID_MAKE_JOB=""" + objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("ID_MAKE").ToString) + """"
                                strXMLSpareParts += " ID_WAREHOUSE=""" + objCommonUtil.ConvertStr(HttpContext.Current.Session("Id_WH").ToString) + """"
                                strXMLSpareParts += " ID_ITEM_CATG_JOB=""" + objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("Id_Item_Catg").ToString) + """"
                                strXMLSpareParts += " JOBI_ORDER_QTY=""" + objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), dtWOSpareParts.DefaultView(i).Item("JOBI_ORDER_QTY").ToString))) + """"
                                strXMLSpareParts += " JOBI_DELIVER_QTY=""" + IIf(objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("JOBI_DELIVER_QTY").ToString) = "", 0, objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), dtWOSpareParts.DefaultView(i).Item("JOBI_DELIVER_QTY").ToString)))) + """"
                                strXMLSpareParts += " ITEM_DESC=""" + objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("Item_Sp_Desc").ToString) + """"
                                strXMLSpareParts += " PICKINGLIST_PREV_PRINTED=""" + objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("PICKINGLIST_PREV_PRINTED").ToString) + """"

                                strXMLSpareParts += " PREV_PICKED=""" + IIf(objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("PREV_PICKED").Equals(System.DBNull.Value)), default_pickd.ToString, objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), dtWOSpareParts.DefaultView(i).Item("PREV_PICKED").ToString)))) + """"
                                If dtWOSpareParts.DefaultView(i).Item("TOBE_PICKED").Equals(System.DBNull.Value) Then
                                    strXMLSpareParts += " TOBE_PICKED=""" + IIf(objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("TOBE_PICKED").Equals(System.DBNull.Value)), dtWOSpareParts.DefaultView(i).Item("JOBI_DELIVER_QTY").ToString, objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), dtWOSpareParts.DefaultView(i).Item("TOBE_PICKED").ToString)))) + """/>"
                                Else
                                    strXMLSpareParts += " TOBE_PICKED=""" + IIf(objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("TOBE_PICKED").Equals(System.DBNull.Value)), default_pickd.ToString, objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), dtWOSpareParts.DefaultView(i).Item("TOBE_PICKED").ToString)))) + """"
                                End If
                                strXMLSpareParts += " SPARE_TYPE=""" + objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("SPARE_TYPE").ToString) + """"
                                strXMLSpareParts += " FLG_FORCE_VAT=""" + objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("FLG_FORCE_VAT").ToString) + """"
                                strXMLSpareParts += " FLG_EDIT_SP=""" + objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("FLG_EDIT_SP").ToString) + """"
                                strXMLSpareParts += " EXPORT_TYPE=""" + objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("EXPORT_TYPE").ToString) + """/>"
                            Next
                        End If
                        strXMLSpareParts += "</root>"

                        HttpContext.Current.Session("PickingList") = strXMLSpareParts
                        strVal = reportRequest
                        dtSpare = HttpContext.Current.Session("WOSpareDetails")

                        Dim rSpare As DataRow
                        If Not dtSpare Is Nothing Then
                            For Each rSpare In dtSpare.Rows
                                rSpare.BeginEdit()
                                If rSpare("JOBI_ORDER_QTY") = rSpare("JOBI_DELIVER_QTY") Then
                                    rSpare("PICKINGLIST_PREV_PRINTED") = 1
                                Else
                                    rSpare("PICKINGLIST_PREV_PRINTED") = 0
                                End If
                                rSpare.AcceptChanges()
                                rSpare.EndEdit()
                            Next
                        End If

                        If Not dtSpare Is Nothing Then
                            For Each rSpare In dtSpare.Rows
                                rSpare.BeginEdit()
                                rSpare("PREV_PICKED") = rSpare("JOBI_DELIVER_QTY")
                                rSpare.AcceptChanges()
                                rSpare.EndEdit()
                            Next
                        End If

                        If Not dtSpare Is Nothing Then
                            For Each rSpare In dtSpare.Rows
                                rSpare.BeginEdit()
                                If rSpare("JOBI_ORDER_QTY") <> rSpare("JOBI_DELIVER_QTY") Then
                                    rSpare("PREV_PICKED") = rSpare("JOBI_DELIVER_QTY")
                                End If
                                rSpare.AcceptChanges()
                                rSpare.EndEdit()
                            Next
                        End If

                        If Not dtSpare Is Nothing Then
                            For Each rSpare In dtSpare.Rows
                                rSpare.BeginEdit()
                                rSpare("TOBE_PICKED") = rSpare("JOBI_DELIVER_QTY") - rSpare("PREV_PICKED")
                                rSpare.AcceptChanges()
                                rSpare.EndEdit()
                            Next
                        End If

                        HttpContext.Current.Session("WOSpareDetails") = dtSpare

                    Case "DELIVERYNOTE"
                        Dim ds As DataSet
                        objWOJBO.Id_WO_NO = WONO
                        objWOJBO.Id_WO_Prefix = WOPREFIX
                        ds = objWOJDO.LoadWorkOrderSpares(objWOJBO)
                        dtWOSpareParts = ds.Tables(0) 'HttpContext.Current.Session("WOSpareDetails")

                        strXMLSpareParts = "<root>"
                        If Not dtWOSpareParts Is Nothing Then
                            For i As Integer = 0 To dtWOSpareParts.DefaultView.Count - 1
                                strXMLSpareParts += "<insert ID_ITEM_JOB=""" + objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("ID_ITEM_JOB").ToString) + """"
                                strXMLSpareParts += " ID_MAKE_JOB=""" + objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("ID_MAKE_JOB_ID").ToString) + """"
                                strXMLSpareParts += " ID_WAREHOUSE=""" + objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("ID_WAREHOUSE").ToString) + """"
                                strXMLSpareParts += " ID_ITEM_CATG_JOB=""" + objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("ID_ITEM_CATG_JOB_ID").ToString) + """"
                                strXMLSpareParts += " JOBI_ORDER_QTY=""" + objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), dtWOSpareParts.DefaultView(i).Item("JOBI_ORDER_QTY").ToString))) + """"
                                strXMLSpareParts += " JOBI_BO_QTY=""" + objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), dtWOSpareParts.DefaultView(i).Item("JOBI_BO_QTY").ToString))) + """"
                                strXMLSpareParts += " JOBI_SELL_PRICE=""" + objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), dtWOSpareParts.DefaultView(i).Item("JOBI_SELL_PRICE").ToString))) + """"
                                strXMLSpareParts += " JOBI_DIS_PER=""" + objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), dtWOSpareParts.DefaultView(i).Item("JOBI_DIS_PER").ToString))) + """"
                                strXMLSpareParts += " JOBI_DELIVER_QTY=""" + IIf(objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("JOBI_DELIVER_QTY").ToString) = "", 0, objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), dtWOSpareParts.DefaultView(i).Item("JOBI_DELIVER_QTY").ToString)))) + """"
                                strXMLSpareParts += " ITEM_DESC=""" + objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("ITEM_DESC").ToString) + """"
                                strXMLSpareParts += " DELIVERYNOTE_PREV_PRINTED=""" + objCommonUtil.ConvertStr(dtWOSpareParts.DefaultView(i).Item("DELIVERYNOTE_PREV_PRINTED").ToString) + """/>"
                            Next
                        End If
                        strXMLSpareParts += "</root>"

                        HttpContext.Current.Session("DeliveryNote") = strXMLSpareParts
                        'change end
                        Dim rnd As New Random()
                        strVal = reportRequest

                        dtSpare = HttpContext.Current.Session("WOSpareDetails")
                        Dim rSpare As DataRow

                        If Not dtSpare Is Nothing Then
                            For Each rSpare In dtSpare.Rows
                                rSpare.BeginEdit()
                                rSpare("DELIVERYNOTE_PREV_PRINTED") = 1
                                rSpare.AcceptChanges()
                                rSpare.EndEdit()
                            Next
                        End If
                        HttpContext.Current.Session("WOSpareDetails") = dtSpare

                    Case "ORDER"
                        dtSpare = HttpContext.Current.Session("WOSpareDetails")
                        Dim dtTemp As DataTable = OrderListTable()
                        'change end
                        If Not dtTemp Is Nothing Then
                            If dtTemp.Rows.Count > 0 Then
                                HttpContext.Current.Session("RptSpares") = dtTemp 'dsOrder.Tables(1)
                                Dim rnd As New Random()
                                strVal = reportRequest
                            End If
                        End If
                End Select

                For Each dtrow As DataRow In dtSpare.Rows
                    Dim wojDet As New WOJobDetailBO()
                    wojDet.Id_WOItem_Seq = IIf(IsDBNull(dtrow("Id_WOITEM_SEQ")) = True, 0, dtrow("Id_WOITEM_SEQ"))
                    wojDet.Id_Wodet_Seq = IIf(IsDBNull(dtrow("Id_Wodet_Seq")) = True, 0, dtrow("Id_Wodet_Seq"))
                    wojDet.Id_Make = IIf(IsDBNull(dtrow("Id_Make")) = True, "", dtrow("Id_Make"))
                    wojDet.Id_Item_Catg_Job_Id = IIf(IsDBNull(dtrow("Id_Item_Catg_Job_Id")) = True, "", dtrow("Id_Item_Catg_Job_Id"))
                    wojDet.Id_Item_Catg = IIf(IsDBNull(dtrow("Id_Item_Catg")) = True, "", dtrow("Id_Item_Catg"))
                    wojDet.Id_Item = IIf(IsDBNull(dtrow("Id_Item")) = True, "", dtrow("Id_Item"))
                    wojDet.Item_Sp_Desc = IIf(IsDBNull(dtrow("Item_Sp_Desc")) = True, "", dtrow("Item_Sp_Desc"))
                    wojDet.Jobi_Order_Qty = IIf(IsDBNull(dtrow("Jobi_Order_Qty")) = True, "0", dtrow("Jobi_Order_Qty"))
                    wojDet.Jobi_Deliver_Qty = IIf(IsDBNull(dtrow("Jobi_Deliver_Qty")) = True, "0", dtrow("Jobi_Deliver_Qty"))
                    wojDet.Jobi_Bo_Qty = IIf(IsDBNull(dtrow("Jobi_BO_Qty")) = True, "0", dtrow("Jobi_BO_Qty"))
                    wojDet.Jobi_Sell_Price = IIf(IsDBNull(dtrow("Jobi_Sell_Price")) = True, "0", dtrow("Jobi_Sell_Price"))
                    wojDet.Jobi_Dis_Per = IIf(IsDBNull(dtrow("Jobi_Dis_Per")) = True, "0", dtrow("Jobi_Dis_Per"))
                    wojDet.Jobi_Vat_Per = IIf(IsDBNull(dtrow("Jobi_Vat_Per")) = True, "0", dtrow("Jobi_Vat_Per"))
                    wojDet.Jobi_Vat_Seq = IIf(IsDBNull(dtrow("Jobi_Vat_Seq")) = True, 0, dtrow("Jobi_Vat_Seq"))
                    wojDet.Jobi_Dis_Seq = IIf(IsDBNull(dtrow("Jobi_Dis_Seq")) = True, 0, dtrow("Jobi_Dis_Seq"))
                    wojDet.Sp_Slno = IIf(IsDBNull(dtrow("Sp_Slno")) = True, "1", dtrow("Sp_Slno"))
                    wojDet.Sp_Make = IIf(IsDBNull(dtrow("Sp_Make")) = True, "", dtrow("Sp_Make"))
                    wojDet.Id_Wh_Item = IIf(IsDBNull(dtrow("Id_Warehouse")) = True, 0, dtrow("Id_Warehouse"))
                    wojDet.Cost_Price = IIf(IsDBNull(dtrow("Cost_Price")) = True, "0", dtrow("Cost_Price"))
                    wojDet.Td_Calc = IIf(IsDBNull(dtrow("Td_Calc")) = True, "1", dtrow("Td_Calc"))
                    wojDet.Id_Deb_Seq = IIf(IsDBNull(dtrow("Id_Deb_Seq")) = True, 0, dtrow("Id_Deb_Seq"))
                    wojDet.Order_Line_Text = IIf(IsDBNull(dtrow("Order_Line_Text")) = True, "", dtrow("Order_Line_Text"))
                    wojDet.Id_Customer = IIf(IsDBNull(dtrow("Id_Customer")) = True, "", dtrow("Id_Customer"))
                    wojDet.Text = IIf(IsDBNull(dtrow("Text")) = True, "", dtrow("Text"))
                    wojDet.Sp_Location = IIf(IsDBNull(dtrow("Sp_Location")) = True, "", dtrow("Sp_Location"))
                    wojDet.Pickinglist_Prev_Printed = IIf(IsDBNull(dtrow("PICKINGLIST_PREV_PRINTED")) = True, "0", dtrow("PICKINGLIST_PREV_PRINTED"))
                    wojDet.Deliverynote_Prev_Printed = IIf(IsDBNull(dtrow("DELIVERYNOTE_PREV_PRINTED")) = True, "0", dtrow("DELIVERYNOTE_PREV_PRINTED"))
                    wojDet.Prev_Picked = IIf(IsDBNull(dtrow("PREV_PICKED")) = True, "0", dtrow("PREV_PICKED"))
                    wojDet.Spare_Type = IIf(IsDBNull(dtrow("SPARE_TYPE")) = True, "ORD", dtrow("SPARE_TYPE"))
                    wojDet.Flg_Force_Vat = IIf(IsDBNull(dtrow("FLG_FORCE_VAT")) = True, "0", dtrow("FLG_FORCE_VAT"))
                    wojDet.Flg_Edit_Sp = IIf(IsDBNull(dtrow("FLG_EDIT_SP")) = True, "0", dtrow("FLG_EDIT_SP"))
                    wojDet.Export_Type = IIf(IsDBNull(dtrow("EXPORT_TYPE")) = True, "", dtrow("EXPORT_TYPE"))
                    wojDet.Sp_Item_Price = IIf(IsDBNull(dtrow("Sp_Item_Price")) = True, "0", dtrow("Sp_Item_Price"))
                    wojDet.ToBe_Picked = IIf(IsDBNull(dtrow("TOBE_PICKED")) = True, "0", dtrow("TOBE_PICKED"))
                    wojDet.ReportPath = reportRequest.ToString()
                    details.Add(wojDet)
                Next

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "WOJobDetails", "LoadReport", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function OrderListTable() As DataTable

            Dim dtSpares As DataTable = HttpContext.Current.Session("WOSpareDetails")
            'Adding Column to Temp table 
            Dim dtSetdt As New DataTable
            Dim rUser As DataRow

            Dim column As New DataColumn("ID_WOITEM_SEQ", GetType(System.Int32))
            dtSetdt.Columns.Add(column)

            column = New DataColumn("ID_WODET_SEQ_JOB", GetType(System.Int32))
            dtSetdt.Columns.Add(column)

            column = New DataColumn("ID_MAKE_JOB_ID", GetType(System.String))
            dtSetdt.Columns.Add(column)

            column = New DataColumn("SLNO", GetType(System.Int32))
            dtSetdt.Columns.Add(column)

            column = New DataColumn("MAKE", GetType(System.String))
            dtSetdt.Columns.Add(column)

            column = New DataColumn("ID_ITEM_CATG_JOB_ID", GetType(System.String))
            dtSetdt.Columns.Add(column)

            column = New DataColumn("ID_ITEM_CATG_JOB", GetType(System.String))
            dtSetdt.Columns.Add(column)

            column = New DataColumn("ID_ITEM_JOB", GetType(System.String))
            dtSetdt.Columns.Add(column)

            column = New DataColumn("ITEM_DESC", GetType(System.String))
            dtSetdt.Columns.Add(column)

            column = New DataColumn("JOBI_ORDER_QTY", GetType(System.Decimal))
            dtSetdt.Columns.Add(column)

            column = New DataColumn("JOBI_DELIVER_QTY", GetType(System.Decimal))
            dtSetdt.Columns.Add(column)

            column = New DataColumn("JOBI_BO_QTY", GetType(System.Decimal))
            dtSetdt.Columns.Add(column)

            column = New DataColumn("JOBI_SELL_PRICE", GetType(System.Decimal))
            dtSetdt.Columns.Add(column)

            column = New DataColumn("JOBI_DIS_SEQ", GetType(System.String))
            dtSetdt.Columns.Add(column)

            column = New DataColumn("JOBI_DIS_PER", GetType(System.Decimal))
            dtSetdt.Columns.Add(column)

            column = New DataColumn("DISCOUNT_CD", GetType(System.Decimal))
            dtSetdt.Columns.Add(column)

            column = New DataColumn("JOBI_VAT_SEQ", GetType(System.String))
            dtSetdt.Columns.Add(column)

            column = New DataColumn("JOBI_VAT_PER", GetType(System.String))
            dtSetdt.Columns.Add(column)

            column = New DataColumn("TOTAL_PRICE", GetType(System.Decimal))
            dtSetdt.Columns.Add(column)

            column = New DataColumn("ORDER_LINE_TEXT", GetType(System.String))
            dtSetdt.Columns.Add(column)

            column = New DataColumn("CREATED_BY", GetType(System.String))
            dtSetdt.Columns.Add(column)

            column = New DataColumn("CREATEDDATE", GetType(DateTime))
            dtSetdt.Columns.Add(column)

            column = New DataColumn("MODIFIED_BY", GetType(System.String))
            dtSetdt.Columns.Add(column)

            column = New DataColumn("MODIFIEDDATE", GetType(DateTime))
            dtSetdt.Columns.Add(column)

            column = New DataColumn("ID_WO_NO", GetType(System.String))
            dtSetdt.Columns.Add(column)

            column = New DataColumn("ID_WO_PREFIX", GetType(System.String))
            dtSetdt.Columns.Add(column)

            column = New DataColumn("ID_MAKE", GetType(System.String))
            dtSetdt.Columns.Add(column)

            column = New DataColumn("ID_WAREHOUSE", GetType(System.Int32))
            dtSetdt.Columns.Add(column)

            column = New DataColumn("ID_CUST_WO", GetType(System.String))
            dtSetdt.Columns.Add(column)

            column = New DataColumn("TD_CALC", GetType(System.Boolean))
            dtSetdt.Columns.Add(column)

            column = New DataColumn("TEXT", GetType(System.String))
            dtSetdt.Columns.Add(column)

            column = New DataColumn("JOBI_COST_PRICE", GetType(System.Decimal))
            dtSetdt.Columns.Add(column)

            column = New DataColumn("ID_DBT_SEQ", GetType(System.Int32))
            dtSetdt.Columns.Add(column)

            For Each dtrow As DataRow In dtSpares.Rows
                rUser = dtSetdt.NewRow()

                rUser("ID_WOITEM_SEQ") = 0
                rUser("ID_WODET_SEQ_JOB") = 0
                rUser("ID_MAKE_JOB_ID") = IIf(IsDBNull(dtrow("Id_Make")) = True, "", dtrow("Id_Make"))

                rUser("SLNO") = IIf(IsDBNull(dtrow("SP_SLNO")) = True, 1, dtrow("SP_SLNO"))
                rUser("MAKE") = IIf(IsDBNull(dtrow("Sp_Make")) = True, "", dtrow("Sp_Make"))
                rUser("ID_MAKE") = IIf(IsDBNull(dtrow("Id_Make")) = True, "", dtrow("Id_Make"))

                rUser("ID_ITEM_CATG_JOB_ID") = IIf(IsDBNull(dtrow("Id_Item_Catg_Job_Id")) = True, "0", dtrow("Id_Item_Catg_Job_Id"))
                rUser("ID_ITEM_CATG_JOB") = IIf(IsDBNull(dtrow("Id_Item_Catg")) = True, "", dtrow("Id_Item_Catg"))
                rUser("ID_ITEM_JOB") = IIf(IsDBNull(dtrow("Id_Item")) = True, "", dtrow("Id_Item"))

                rUser("ITEM_DESC") = IIf(IsDBNull(dtrow("Item_Sp_Desc")) = True, "", dtrow("Item_Sp_Desc"))
                rUser("JOBI_ORDER_QTY") = IIf(IsDBNull(dtrow("Jobi_Order_Qty")) = True, 0, dtrow("Jobi_Order_Qty"))
                rUser("JOBI_DELIVER_QTY") = IIf(IsDBNull(dtrow("Jobi_Deliver_Qty")) = True, 0, dtrow("Jobi_Deliver_Qty"))

                rUser("JOBI_BO_QTY") = IIf(IsDBNull(dtrow("Jobi_Bo_Qty")) = True, 0, dtrow("Jobi_Bo_Qty"))
                rUser("JOBI_SELL_PRICE") = IIf(IsDBNull(dtrow("Jobi_Sell_Price")) = True, 0, dtrow("Jobi_Sell_Price"))
                rUser("JOBI_COST_PRICE") = IIf(IsDBNull(dtrow("COST_PRICE")) = True, 0, dtrow("COST_PRICE"))

                rUser("JOBI_DIS_PER") = IIf(IsDBNull(dtrow("Jobi_Dis_Per")) = True, 0, dtrow("Jobi_Dis_Per"))
                rUser("JOBI_VAT_PER") = IIf(IsDBNull(dtrow("Jobi_Vat_Per")) = True, 0, dtrow("Jobi_Vat_Per"))
                rUser("TOTAL_PRICE") = IIf(IsDBNull(dtrow("Sp_Item_Price")) = True, 0, dtrow("Sp_Item_Price"))

                rUser("ORDER_LINE_TEXT") = IIf(IsDBNull(dtrow("Order_Line_Text")) = True, "", dtrow("Order_Line_Text"))
                rUser("TD_CALC") = False
                rUser("ID_CUST_WO") = IIf(IsDBNull(dtrow("Id_Customer")) = True, "", dtrow("Id_Customer"))

                rUser("TEXT") = IIf(IsDBNull(dtrow("Text")) = True, "", dtrow("Text"))
                rUser("ID_DBT_SEQ") = IIf(IsDBNull(dtrow("Id_Deb_Seq")) = True, "0", dtrow("Id_Deb_Seq"))
                rUser("ID_WAREHOUSE") = 0

                rUser("ID_WO_PREFIX") = HttpContext.Current.Session("WOPR")
                rUser("ID_WO_NO") = HttpContext.Current.Session("WONO")
                rUser("CREATED_BY") = HttpContext.Current.Session("UserID")

                rUser("CREATEDDATE") = Date.Now.ToString()
                rUser("MODIFIED_BY") = HttpContext.Current.Session("UserID")
                rUser("MODIFIEDDATE") = Date.Now.ToString()

                rUser("JOBI_VAT_SEQ") = "0"
                rUser("JOBI_DIS_SEQ") = "0"
                rUser("DISCOUNT_CD") = 0

                dtSetdt.Rows.Add(rUser)
            Next
            Return dtSetdt
        End Function

        Public Function ReplaceOldSpares(ByVal idItem As String, ByVal idMake As String, ByVal replacementType As String)
            Dim idOldReplacementSpare As String = ""
            Dim replacementId As String = ""
            Dim dsReplacementSpare As DataSet
            Try
                'To check if the replacement sp does not have qty and original sp has qty
                If (idItem <> "") Then
                    replacementId = objWOJDO.Fetch_ReplacementSpares(idItem, idMake, HttpContext.Current.Session("UserID"), replacementType)
                    If (replacementId <> "") Then

                        objWOJBO.Id_Item = replacementId
                        objWOJBO.Id_Customer = HttpContext.Current.Session("IdCustomer")
                        objWOJBO.WO_Id_Veh = HttpContext.Current.Session("Veh_Seq_No") 'vehId
                        objWOJBO.Created_By = HttpContext.Current.Session("UserID")
                        dsReplacementSpare = objWOJDO.Fetch_Spares(objWOJBO)

                        If (dsReplacementSpare.Tables.Count > 0) Then
                            Dim drQty As DataRow() = dsReplacementSpare.Tables(0).Select("ID_ITEM  = '" & replacementId & "'")

                            If CInt(drQty(0)("ITEM_AVAIL_QTY").ToString) <> 0 Then
                                idOldReplacementSpare = replacementId
                            Else
                                idOldReplacementSpare = ""
                            End If
                        Else
                            idOldReplacementSpare = ""
                        End If
                    End If
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "WOJobDetails", "ReplaceOldSpares", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return idOldReplacementSpare
        End Function

        Public Function Get_ConfirmStatus()
            Try
                Dim dsCnfrmDialog As DataSet
                dsCnfrmDialog = objConfigWODO.GetConfigWorkOrder(HttpContext.Current.Session("UserID"))
                If dsCnfrmDialog.Tables(0).Rows.Count > 0 Then
                    If IsDBNull(dsCnfrmDialog.Tables(0).Rows(0)("USE_CNFRM_DIA".ToString)) = True Then
                        HttpContext.Current.Session("UseConfirm") = "False"
                    Else
                        HttpContext.Current.Session("UseConfirm") = IIf((dsCnfrmDialog.Tables(0).Rows(0)("USE_CNFRM_DIA".ToString) = True), "True", "False")
                    End If
                Else
                    HttpContext.Current.Session("UseConfirm") = "False"
                End If

            Catch exth As System.Threading.ThreadAbortException
                Throw exth
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "WOJobDetails", "Get_ConfirmStatus", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
        End Function
        Public Function BindGrid(objWOJBO) As List(Of WOJobDetailBO)
            Dim details As New List(Of WOJobDetailBO)()
            Dim dsWOJDetails As New DataSet
            Dim dtWOJDetails As New DataTable
            Dim dsWODetails As New DataSet
            Dim dtWODetails As New DataTable
            Dim strJobNo As String
            Try

                'dsWODetails = objWOJDO.Load_WorkOrderDetails(objWOJBO)
                'If dsWODetails.Tables.Count > 0 Then
                '    Dim jobNo As String
                '    If dsWODetails.Tables(0).Rows.Count > 0 Then
                '        dtWODetails = dsWODetails.Tables(0)
                '        Dim wojDet As New WOJobDetailBO()
                '        jobNo = dtWODetails.Rows(0)("Id_Job").ToString
                '        wojDet.IdJob = "Job:" + dtWODetails.Rows(0)("Id_Job").ToString
                '        wojDet.Text = ""
                '        wojDet.Nei = "0"
                '        wojDet.Ford = "100"
                '        wojDet.Bestilt = ""
                '        wojDet.Levert = ""
                '        wojDet.Pris = ""
                '        wojDet.Rab = ""
                '        wojDet.Belop = ""
                '        wojDet.JobId = jobNo '""
                '        wojDet.Flag = "1"
                '        wojDet.ForeignJob = ""
                '        wojDet.ItemDesc = ""
                '        details.Add(wojDet)
                '        For Each dtrow As DataRow In dtWODetails.Rows
                '            Dim wojDet1 As New WOJobDetailBO()
                '            wojDet1.IdJob = ""
                '            wojDet1.Text = "Labour"
                '            wojDet1.Nei = "0"
                '            wojDet1.Ford = "100"
                '            wojDet1.Bestilt = ""
                '            wojDet1.Levert = dtrow("WO_Std_Time")
                '            wojDet1.Pris = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("WO_Hourley_Price")) = True, 0D, dtrow("WO_Hourley_Price")))
                '            wojDet1.Rab = ""
                '            Dim totlabamt As String = IIf(IsDBNull(dtrow("WO_Tot_Lab_Amt").ToString()) = True, 0, dtrow("WO_Tot_Lab_Amt").ToString())
                '            wojDet1.Belop = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), totlabamt)
                '            wojDet1.JobId = dtrow("Id_Job") '""
                '            wojDet1.Flag = "1"
                '            wojDet1.ForeignJob = ""
                '            wojDet1.ItemDesc = ""
                '            details.Add(wojDet1)
                '        Next
                '    End If
                '    If dsWODetails.Tables(1).Rows.Count > 0 Then
                '        dtWOJDetails = dsWODetails.Tables(1)
                '        For Each dtrow As DataRow In dtWOJDetails.Rows
                '            Dim wojDet As New WOJobDetailBO()
                '            wojDet.IdJob = dtrow("Id_Item_Job")
                '            wojDet.Text = dtrow("Item_Desc")
                '            wojDet.Nei = "0"
                '            wojDet.Ford = "100"
                '            wojDet.Bestilt = dtrow("JOBI_ORDER_QTY")
                '            wojDet.Levert = dtrow("JOBI_DELIVER_QTY")
                '            wojDet.Pris = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("JOBI_SELL_PRICE")) = True, 0D, dtrow("JOBI_SELL_PRICE")))
                '            wojDet.Rab = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("JOBI_DIS_PER")) = True, 0D, dtrow("JOBI_DIS_PER")))
                '            'Dim totlabamt As String = IIf(IsDBNull(dtrow("WO_Tot_Lab_Amt").ToString()) = True, 0, dtrow("WO_Tot_Lab_Amt").ToString())
                '            wojDet.Belop = (wojDet.Pris * (IIf(IsDBNull(dtrow("JOBI_DELIVER_QTY")) = True, 0, dtrow("JOBI_DELIVER_QTY"))) * 0.01 * wojDet.Rab)
                '            wojDet.JobId = jobNo '""
                '            wojDet.Flag = "0"
                '            wojDet.ForeignJob = ""
                '            wojDet.ItemDesc = dtrow("Item_Desc")
                '            details.Add(wojDet)
                '        Next
                '    End If
                '    Dim wojdet2 As New WOJobDetailBO()
                '    wojdet2.IdJob = ""
                '    wojdet2.Text = ""
                '    wojdet2.Nei = ""
                '    wojdet2.Ford = ""
                '    wojdet2.Bestilt = ""
                '    wojdet2.Levert = ""
                '    wojdet2.Pris = ""
                '    wojdet2.Rab = ""
                '    wojdet2.Belop = ""
                '    wojdet2.JobId = jobNo
                '    wojdet2.Flag = "0"
                '    wojdet2.ForeignJob = ""
                '    wojdet2.ItemDesc = ""
                '    details.Add(wojdet2)
                'Else
                strJobNo = objWOJDO.Fetch_Job_No(objWOJBO) 'Use it later to fetch job no
                'strJobNo = "1"
                Dim wojDet As New WOJobDetailBO()
                wojDet.IdJob = "Job:" + strJobNo
                wojDet.Text = ""
                wojDet.Nei = "0"
                wojDet.Ford = "100"
                wojDet.Bestilt = ""
                wojDet.Levert = ""
                wojDet.Pris = ""
                wojDet.Rab = ""
                wojDet.Belop = ""
                wojDet.JobId = strJobNo '""
                wojDet.Flag = "1"
                wojDet.ForeignJob = ""
                wojDet.ItemDesc = ""
                details.Add(wojDet)


                Dim wojdet1 As New WOJobDetailBO()
                wojdet1.IdJob = ""
                wojdet1.Text = ""
                wojdet1.Nei = ""
                wojdet1.Ford = ""
                wojdet1.Bestilt = ""
                wojdet1.Levert = ""
                wojdet1.Pris = ""
                wojdet1.Rab = ""
                wojdet1.Belop = ""
                wojdet1.JobId = strJobNo
                wojdet1.Flag = "0"
                wojdet1.ForeignJob = ""
                wojdet1.ItemDesc = ""
                details.Add(wojdet1)
                'End If



            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "Load_ConfigDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function AddSpareLine(ByVal idWONO As String, ByVal idWOPrefix As String) As List(Of WOJobDetailBO)
            Dim details As New List(Of WOJobDetailBO)()
            Dim dsWOJDetails As New DataSet
            Dim dtWOJDetails As New DataTable
            Dim strJobNo As String
            Try

                Dim wojDet1 As New WOJobDetailBO()
                objWOJBO.Id_WO_NO = idWONO
                objWOJBO.Id_WO_Prefix = idWOPrefix
                strJobNo = objWOJDO.Fetch_Job_No(objWOJBO)
                'strJobNo = "1"
                wojDet1.IdJob = "Job: " + strJobNo + ""
                wojDet1.Text = ""
                wojDet1.Nei = ""
                wojDet1.Ford = "0"
                wojDet1.Bestilt = ""
                wojDet1.Levert = ""
                wojDet1.Pris = ""
                wojDet1.Rab = ""
                wojDet1.Belop = ""
                wojDet1.JobId = strJobNo
                wojDet1.Flag = "1"
                wojDet1.ForeignJob = ""
                wojDet1.ItemDesc = ""
                details.Add(wojDet1)


            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "AddSpareLine", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function

        Public Function FetchHourlyPrice(objWOJBO, hpmode) As List(Of WOJobDetailBO)
            Dim details As New List(Of WOJobDetailBO)()
            Dim dsWOJLoadHp As New DataSet
            Dim dtWOJLoadHp As New DataTable
            Try

                objWOJBO.Mechpcd_HP = ""
                dsWOJLoadHp = objWOJDO.Fetch_Hourly_Price(objWOJBO)

                Dim hourlyPrice As String = String.Empty
                Dim hpVat As String = String.Empty
                Dim highest As Integer = 0
                Dim totalLabourAmt As Decimal = 0.0


                If dsWOJLoadHp.Tables.Count > 0 Then
                    Dim wojDet As New WOJobDetailBO()
                    If (hpmode = "NEW") Then
                        If dsWOJLoadHp.Tables(0).Rows.Count > 0 Then
                            wojDet.HP_Price = IIf(IsDBNull(hourlyPrice) = True, "0", hourlyPrice)
                            wojDet.Id_Hp_Vat = IIf(IsDBNull(hpVat) = True, "0", hpVat)
                            HttpContext.Current.Session("ID_HPVAT") = IIf(IsDBNull(hpVat) = True, "0", hpVat) 'IIf(IsDBNull(dsWOJLoadHp.Tables(0).Rows(0)("INV_LABOR_TEXT")) = True, "0", dsWOJLoadHp.Tables(0).Rows(0)("INV_LABOR_TEXT"))
                            wojDet.WO_Cust_HourlyPrice = IIf(IsDBNull(dsWOJLoadHp.Tables(0).Rows(0)("CUST_HOURLYPRICE")) = True, "0", dsWOJLoadHp.Tables(0).Rows(0)("CUST_HOURLYPRICE"))
                            HttpContext.Current.Session("WO_Cust_HourlyPrice") = IIf(IsDBNull(dsWOJLoadHp.Tables(0).Rows(0)("CUST_HOURLYPRICE")) = True, "0", dsWOJLoadHp.Tables(0).Rows(0)("CUST_HOURLYPRICE"))
                        End If
                    Else
                        If dsWOJLoadHp.Tables(0).Rows.Count > 0 Then
                            wojDet.HP_Price = IIf(IsDBNull(dsWOJLoadHp.Tables(0).Rows(0)("HP_Price")) = True, "0", dsWOJLoadHp.Tables(0).Rows(0)("HP_Price"))
                            wojDet.Id_Hp_Vat = IIf(IsDBNull(dsWOJLoadHp.Tables(0).Rows(0)("INV_LABOR_TEXT")) = True, "0", dsWOJLoadHp.Tables(0).Rows(0)("INV_LABOR_TEXT"))
                            HttpContext.Current.Session("ID_HPVAT") = IIf(IsDBNull(dsWOJLoadHp.Tables(0).Rows(0)("INV_LABOR_TEXT")) = True, "0", dsWOJLoadHp.Tables(0).Rows(0)("INV_LABOR_TEXT"))
                            wojDet.WO_Cust_HourlyPrice = IIf(IsDBNull(dsWOJLoadHp.Tables(0).Rows(0)("CUST_HOURLYPRICE")) = True, "0", dsWOJLoadHp.Tables(0).Rows(0)("CUST_HOURLYPRICE"))
                            HttpContext.Current.Session("WO_Cust_HourlyPrice") = IIf(IsDBNull(dsWOJLoadHp.Tables(0).Rows(0)("CUST_HOURLYPRICE")) = True, "0", dsWOJLoadHp.Tables(0).Rows(0)("CUST_HOURLYPRICE"))
                        End If
                    End If

                    details.Add(wojDet)
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "Fetch_Hourly_Price", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function

        Public Function Get_Spare(objWOJBO) As List(Of WOJobDetailBO)
            Dim details As New List(Of WOJobDetailBO)()
            Dim flgStckItem As String = ""
            Dim dsWOJSpares As New DataSet
            Dim dtWOJSpares As New DataTable
            Dim dsFetchStckItem As New DataSet
            Dim dsCust As DataSet = Nothing
            Dim dvWOJSpares As New DataView
            Dim SPMake As String
            Try
                SPMake = HttpContext.Current.Session("SPMake")
                dsWOJSpares = objWOJDO.Get_Spare(objWOJBO)
                ' HttpContext.Current.Session("WOJSparePart") = dsWOJSpares
                If dsWOJSpares.Tables.Count > 0 Then
                    'Spares Load
                    If dsWOJSpares.Tables(0).Rows.Count > 0 Then
                        dtWOJSpares = dsWOJSpares.Tables(0)
                        If Not SPMake Is Nothing Then
                            dvWOJSpares = dtWOJSpares.DefaultView
                            dvWOJSpares.RowFilter = "ID_MAKE = '" + SPMake + "'"
                            dtWOJSpares = dvWOJSpares.ToTable
                            HttpContext.Current.Session("SPMake") = Nothing
                        End If
                        For Each dtrow As DataRow In dtWOJSpares.Rows
                            Dim wojDet As New WOJobDetailBO()
                            wojDet.Id_Item = dtrow("Id_Item")
                            wojDet.Id_Sp_Replace = IIf(IsDBNull(dtrow("Id_Replace")) = True, "", dtrow("Id_Replace"))
                            wojDet.Item_Sp_Desc = IIf(IsDBNull(dtrow("Item_Desc")) = True, "", dtrow("Item_Desc"))
                            wojDet.Id_Item_Catg = IIf(IsDBNull(dtrow("Id_Item_Catg")) = True, "", dtrow("Id_Item_Catg"))
                            wojDet.Id_Make = IIf(IsDBNull(dtrow("SUPP_CURRENTNO")) = True, "", dtrow("SUPP_CURRENTNO"))
                            wojDet.Category_Desc = IIf(IsDBNull(dtrow("Cat_Desc")) = True, "", dtrow("Cat_Desc"))
                            wojDet.Sp_Make = IIf(IsDBNull(dtrow("Make")) = True, "", dtrow("Make"))
                            wojDet.Item_Avail_Qty = IIf(IsDBNull(dtrow("Item_Avail_Qty")) = True, 0, dtrow("Item_Avail_Qty"))   'dtrow("Item_Avail_Qty")
                            wojDet.Flg_Allow_Bckord = IIf(IsDBNull(dtrow("Flg_Allow_Bckord")) = True, 0, dtrow("Flg_Allow_Bckord"))
                            wojDet.Jobi_Dis_Per = IIf(IsDBNull(dtrow("Jobi_Dis_Per")) = True, "0", dtrow("Jobi_Dis_Per"))
                            wojDet.Jobi_Vat_Per = IIf(IsDBNull(dtrow("Jobi_Vat_Per")) = True, "0", dtrow("Jobi_Vat_Per"))
                            wojDet.Jobi_Vat_Seq = IIf(IsDBNull(dtrow("Jobi_Vat_Seq")) = True, 0, dtrow("Jobi_Vat_Seq"))
                            wojDet.Sp_Item_Price = IIf(IsDBNull(dtrow("Item_Price")) = True, "", dtrow("Item_Price"))
                            wojDet.Jobi_Dis_Seq = IIf(IsDBNull(dtrow("Jobi_Dis_Seq")) = True, 0, dtrow("Jobi_Dis_Seq"))
                            wojDet.Jobi_Deliver_Qty = IIf(IsDBNull(dtrow("Jobi_Deliver_Qty")) = True, "0", dtrow("Jobi_Deliver_Qty"))
                            wojDet.Jobi_Bo_Qty = IIf(IsDBNull(dtrow("Jobi_Bo_Qty")) = True, "0", dtrow("Jobi_Bo_Qty"))
                            wojDet.Cost_Price = IIf(IsDBNull(dtrow("Cost_Price")) = True, "0", dtrow("Cost_Price"))
                            wojDet.Sp_Disc_Code_Sell = IIf(IsDBNull(dtrow("Disc_Code_Sell")) = True, "", dtrow("Disc_Code_Sell"))
                            wojDet.Sp_Disc_Code_Buy = IIf(IsDBNull(dtrow("Disc_Code_Buy")) = True, "", dtrow("Disc_Code_Buy"))
                            wojDet.Sp_Location = IIf(IsDBNull(dtrow("Location")) = True, "", dtrow("Location"))
                            wojDet.Sp_Item_Description = IIf(IsDBNull(dtrow("IDesc")) = True, "", dtrow("IDesc"))
                            wojDet.Sp_I_Item = IIf(IsDBNull(dtrow("I_Item")) = True, "", dtrow("I_Item"))
                            wojDet.Id_Wh_Item = IIf(IsDBNull(dtrow("Id_Wh_Item")) = True, 0, dtrow("Id_Wh_Item"))
                            wojDet.Env_Id_Item = IIf(IsDBNull(dtrow("Env_Id_Item")) = True, "", dtrow("Env_Id_Item"))
                            wojDet.Env_Id_Make = IIf(IsDBNull(dtrow("Env_Id_Make")) = True, "", dtrow("Env_Id_Make"))
                            wojDet.Env_Id_Warehouse = dtrow("Env_Id_Warehouse")
                            wojDet.Flg_Efd = dtrow("Flg_Efd")

                            dsCust = objWOJDO.Cust_CostPriceDetails(objWOJBO.Id_Customer)
                            If dsCust.Tables(0).Rows.Count > 0 Then
                                If dsCust.Tables(0).Rows(0)("FLG_CPRICE") = True Then
                                    wojDet.Sp_Item_Price = dtrow("COST_PRICE") + (dtrow("COST_PRICE") * CDbl(dsCust.Tables(0).Rows(0)("CUST_COSTPRICE")) / 100)
                                Else
                                    wojDet.Sp_Item_Price = dtrow("Item_Price")
                                End If
                            End If

                            'To check if the replacement sp does not have qty and original sp has qty
                            If (wojDet.Id_Sp_Replace = "") Then
                                wojDet.Id_Old_Sp_Replace = ReplaceOldSpares(wojDet.Id_Item, wojDet.Id_Make, "OLD")
                            End If

                            details.Add(wojDet)
                        Next
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "Get_Spare", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function Save_GridJobDetails(ByVal objWOJBO As WOJobDetailBO, ByVal mode As String) As String()
            Dim strResult As String()
            Try
                If (mode = "Add") Then
                    strResult = objWOJDO.Save_WOJobDetails(objWOJBO)
                Else
                    objWOJBO.Modified_By = HttpContext.Current.Session("UserID")
                    objWOJBO.Dt_Modified = Now
                    strResult = objWOJDO.Update_WOJobDetails(objWOJBO)
                End If

                'strResult = objWOJDO.Save_WOJobDetails(objWOJBO)
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "Save_GridJobDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strResult
        End Function
        Public Function LoadWorkOrderDetails_old(ByVal objWOJBO As WOJobDetailBO) As List(Of WOJobDetailBO)

            Dim dsWOJobs As New DataSet 'No of Jobs
            Dim dtWOJobs As New DataTable 'No of Jobs
            Dim dsWODetails As New DataSet  'Job Number and totals
            Dim dtWODetails As New DataTable 'Job Number and totals
            Dim dsWOJDetails As New DataSet 'Spares (TextLine)
            Dim dtWOJDetails As New DataTable 'Spares (TextLine)
            Dim dsLabDetails As New DataSet 'Labour Details
            Dim dtLabDetails As New DataTable 'Labour Details
            Dim dtLogin As New DataTable 'Login Details

            Dim dsDebtDetails As New DataSet 'Debt Details
            Dim dtDebtDetails As New DataTable 'Debt Details

            Dim strJobNo As String

            Dim jobdetails As New List(Of WOJobDetailBO)()

            Try

                objWOHBO.Id_WO_NO = objWOJBO.Id_WO_NO
                objWOHBO.Id_WO_Prefix = objWOJBO.Id_WO_Prefix
                objWOHBO.Created_By = objWOJBO.Created_By
                dsWOJobs = objWOHDO.Fetch_WOHeader(objWOHBO)

                If (dsWOJobs.Tables.Count > 0) Then
                    dtWOJobs = dsWOJobs.Tables(3)

                    If (dtWOJobs.Rows.Count > 0) Then
                        For Each dtwojobsrow As DataRow In dtWOJobs.Rows
                            Dim details As New List(Of WOJobDetailBO)()
                            strJobNo = dtwojobsrow("Id_Job").ToString()
                            objWOJBO.Id_Job = strJobNo

                            dsWODetails = objWOJDO.Load_WorkOrderDetails(objWOJBO)
                            If (dsWODetails.Tables(2).Rows.Count > 0) Then
                                For Each dtwodebrow As DataRow In dsWODetails.Tables(2).Rows
                                    Dim debdtails As New List(Of WOJobDetailBO)()
                                    If dsWODetails.Tables.Count > 0 Then
                                        Dim jobNo As String
                                        Dim foreignJobNo As Integer
                                        Dim foreignJobText As String = ""

                                        If dsWODetails.Tables(0).Rows.Count > 0 Then
                                            dtWODetails = dsWODetails.Tables(0)
                                            dtDebtDetails = dsWODetails.Tables(2)


                                            Dim wojDet As New WOJobDetailBO()
                                            jobNo = dtWODetails.Rows(0)("Id_Job").ToString
                                            foreignJobNo = Convert.ToInt32(jobNo)
                                            foreignJobText = ""
                                            If (foreignJobNo >= 90 And foreignJobNo <= 99) Then
                                                foreignJobText = "FJ"
                                            Else
                                                foreignJobText = ""
                                            End If
                                            wojDet.IdJob = "Job:" + dtWODetails.Rows(0)("Id_Job").ToString
                                            Dim lastMechanicSaved As String = ""
                                            Dim mecName As String = ""
                                            Dim UserName As String = ""
                                            If (dsWODetails.Tables(6).Rows.Count > 0) Then
                                                dtLabDetails = dsWODetails.Tables(6)
                                                If (dtLabDetails.Rows.Count > 0) Then
                                                    For Each dtrow As DataRow In dtLabDetails.Rows
                                                        Dim mechanic As String = ""
                                                        'Dim mechNm() As String
                                                        mechanic = IIf(IsDBNull(dtrow("Id_Login")) = True, "", dtrow("Id_Login"))
                                                        mecName = IIf(dtrow("Id_Login") = HttpContext.Current.Session("DUser"), "", dtrow("MECHANICNAME"))
                                                        'Dim b As Boolean = mecName.Contains("-")
                                                        'If (b = True) Then
                                                        '    mechNm = mecName.Split("-")
                                                        '    UserName = mechNm(0) + "-" + mechNm(1)
                                                        'Else
                                                        '    UserName = ""
                                                        'End If
                                                    Next
                                                End If
                                            End If
                                            lastMechanicSaved = IIf(IsDBNull(dtWODetails.Rows(0)("Id_Mechanic")) = True, "", dtWODetails.Rows(0)("Id_Mechanic"))
                                            Dim lastMechNm() As String
                                            Dim b As Boolean = lastMechanicSaved.Contains("-")
                                            If (b = True) Then
                                                lastMechNm = lastMechanicSaved.Split("-")
                                                lastMechanicSaved = lastMechNm(0) + "-" + lastMechNm(1)
                                                If (lastMechNm.Count > 2) Then
                                                    wojDet.IdMech = lastMechNm(2)
                                                Else
                                                    wojDet.IdMech = ""
                                                    mecName = ""
                                                End If
                                            Else
                                                lastMechanicSaved = ""
                                                wojDet.IdMech = ""
                                                mecName = ""
                                            End If
                                            wojDet.Text = lastMechanicSaved 'UserName
                                            If dtwodebrow("CUST_TYPE").ToString = "OHC" Then
                                                wojDet.Nei = "0"
                                            ElseIf dtwodebrow("CUST_TYPE").ToString = "INSC" Then
                                                wojDet.Nei = "1"
                                            End If
                                            wojDet.Ford = dtwodebrow("DBT_PER").ToString
                                            wojDet.Bestilt = ""
                                            wojDet.Levert = ""
                                            wojDet.Pris = ""
                                            wojDet.Rab = ""
                                            wojDet.Belop = ""
                                            wojDet.JobId = jobNo '""
                                            wojDet.Flag = "1"
                                            wojDet.ForeignJob = foreignJobText.ToString
                                            wojDet.ItemDesc = ""
                                            wojDet.LineNo = 0
                                            wojDet.Diff = ""
                                            wojDet.IdWODetailseq = dtWODetails.Rows(0)("ID_WODET_SEQ").ToString
                                            wojDet.IdWOItemseq = ""
                                            wojDet.Job_Status = dtWODetails.Rows(0)("JOB_STATUS").ToString
                                            wojDet.IdWOLabSeq = ""
                                            If (dtDebtDetails.Rows.Count > 0) Then
                                                wojDet.Id_Deb_Seq = Convert.ToInt32(dtwodebrow("ID_DBT_SEQ").ToString) 'Convert.ToInt32(dtDebtDetails.Rows(0)("ID_DBT_SEQ").ToString)
                                            Else
                                                wojDet.Id_Deb_Seq = 0
                                            End If

                                            wojDet.Jobi_Bo_Qty = "0"
                                            wojDet.Id_Warehouse = 1
                                            wojDet.Id_Make = ""
                                            wojDet.Sp_Cost_Price = "0"
                                            wojDet.MechanicName = IIf((lastMechanicSaved + wojDet.IdMech) = "", mecName, (lastMechanicSaved + "-" + wojDet.IdMech))
                                            wojDet.DebtType = dtwodebrow("CUST_TYPE").ToString
                                            wojDet.Id_Job_Deb = IIf(IsDBNull(dtwodebrow("Id_Job_Deb")) = True, "", dtwodebrow("Id_Job_Deb"))
                                            debdtails.Add(wojDet)

                                            dtLabDetails = dsWODetails.Tables(6)
                                            'dtLogin = dsWODetails.Tables(7)

                                            For Each dtrow As DataRow In dtLabDetails.Rows
                                                Dim wojDet1 As New WOJobDetailBO()
                                                Dim validuser As String = ""
                                                validuser = IIf(IsDBNull(dtrow("Id_Login")) = True, "", dtrow("Id_Login"))
                                                Dim mechNm() As String
                                                mechNm = dtrow("MECHANICNAME").ToString.Split("-")
                                                UserName = mechNm(0) + "-" + mechNm(1)
                                                wojDet1.IdJob = IIf(validuser = HttpContext.Current.Session("DUser"), "", UserName)
                                                wojDet1.Text = dtrow("WO_Labour_desc")
                                                If dtwodebrow("CUST_TYPE").ToString = "OHC" Then
                                                    wojDet1.Nei = "0"
                                                ElseIf dtwodebrow("CUST_TYPE").ToString = "INSC" Then
                                                    wojDet1.Nei = "1"
                                                End If

                                                wojDet1.Ford = dtwodebrow("DBT_PER").ToString
                                                wojDet1.Bestilt = ""
                                                wojDet1.Levert = dtrow("WO_Labour_Hours")
                                                wojDet1.Pris = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("WO_Hourley_Price")) = True, 0D, dtrow("WO_Hourley_Price")))
                                                Dim totlabamt As String = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("WO_Labour_Hours")) = True, 0D, dtrow("WO_Labour_Hours"))) * objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("WO_Hourley_Price")) = True, 0D, dtrow("WO_Hourley_Price"))) * (objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtwodebrow("DBT_PER")) = True, 0D, dtwodebrow("DBT_PER"))) / 100) 'IIf(IsDBNull(dtrow("WO_Tot_Lab_Amt").ToString()) = True, 0, dtrow("WO_Tot_Lab_Amt").ToString())
                                                wojDet1.Belop = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), totlabamt)
                                                wojDet1.JobId = jobNo '""
                                                wojDet1.Flag = "0"
                                                wojDet1.ForeignJob = foreignJobText.ToString
                                                wojDet1.ItemDesc = ""
                                                wojDet1.Diff = "L"
                                                wojDet1.LineNo = Convert.ToInt32(dtrow("Sl_No").ToString)
                                                wojDet1.IdWODetailseq = dtrow("ID_WODET_SEQ").ToString
                                                wojDet1.IdWOItemseq = ""
                                                wojDet1.Job_Status = dtWODetails.Rows(0)("JOB_STATUS").ToString
                                                wojDet1.IdWOLabSeq = dtrow("ID_WOLAB_SEQ").ToString
                                                wojDet1.Id_Deb_Seq = Convert.ToInt32(dtwodebrow("ID_DBT_SEQ").ToString)
                                                wojDet1.IdMech = dtrow("ID_LOGIN").ToString
                                                wojDet1.Jobi_Bo_Qty = "0"
                                                wojDet1.Id_Warehouse = 1
                                                wojDet1.Id_Make = ""
                                                wojDet1.Sp_Cost_Price = "0"
                                                wojDet1.Rab = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("WO_Lab_Discount")) = True, 0D, dtrow("WO_Lab_Discount")))
                                                Dim mechName As String = ""
                                                mechName = IIf(IsDBNull(dtrow("MECHANICNAME")) = True, "", dtrow("MECHANICNAME"))
                                                mechName = IIf(dtrow("Id_Login") = HttpContext.Current.Session("DUser"), "", dtrow("MECHANICNAME"))
                                                wojDet1.MechanicName = mechName 'dtLogin.Rows(0)("MECHANICNAME").ToString
                                                wojDet1.DebtType = dtwodebrow("CUST_TYPE").ToString
                                                wojDet1.Id_Job_Deb = IIf(IsDBNull(dtwodebrow("Id_Job_Deb")) = True, "", dtwodebrow("Id_Job_Deb"))
                                                'If Convert.ToInt32(dtwodebrow("DBT_PER")) = 0 Then
                                                '    wojDet1.Levert = "0"
                                                '    Dim totLamt As String = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("WO_Labour_Hours")) = True, 0D, dtrow("WO_Labour_Hours"))) * objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("WO_Hourley_Price")) = True, 0D, dtrow("WO_Hourley_Price")))  'IIf(IsDBNull(dtrow("WO_Tot_Lab_Amt").ToString()) = True, 0, dtrow("WO_Tot_Lab_Amt").ToString())
                                                '    wojDet1.Belop = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), totLamt)
                                                'Else
                                                '    wojDet1.Levert = dtrow("WO_Labour_Hours")
                                                '    Dim totLamt As String = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("WO_Labour_Hours")) = True, 0D, dtrow("WO_Labour_Hours"))) * objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("WO_Hourley_Price")) = True, 0D, dtrow("WO_Hourley_Price")))  'IIf(IsDBNull(dtrow("WO_Tot_Lab_Amt").ToString()) = True, 0, dtrow("WO_Tot_Lab_Amt").ToString())
                                                '    wojDet1.Belop = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), totLamt)

                                                'End If


                                                debdtails.Add(wojDet1)
                                            Next
                                        End If


                                        If dsWODetails.Tables(1).Rows.Count > 0 Then
                                            dtWOJDetails = dsWODetails.Tables(1)
                                            For Each dtrow As DataRow In dtWOJDetails.Rows
                                                Dim wojDet As New WOJobDetailBO()
                                                wojDet.IdJob = IIf(IsDBNull(dtrow("Id_Item_Job")) = True, "", dtrow("Id_Item_Job"))
                                                wojDet.Text = dtrow("Item_Desc")
                                                If dtwodebrow("CUST_TYPE").ToString = "OHC" Then
                                                    wojDet.Nei = "0"
                                                ElseIf dtwodebrow("CUST_TYPE").ToString = "INSC" Then
                                                    wojDet.Nei = "1"
                                                End If
                                                wojDet.Ford = dtwodebrow("DBT_PER").ToString
                                                wojDet.Bestilt = dtrow("JOBI_ORDER_QTY")
                                                wojDet.Levert = dtrow("JOBI_DELIVER_QTY")
                                                wojDet.Pris = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("JOBI_SELL_PRICE")) = True, 0D, dtrow("JOBI_SELL_PRICE")))
                                                wojDet.Rab = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("JOBI_DIS_PER")) = True, 0D, dtrow("JOBI_DIS_PER")))
                                                'Dim totlabamt As String = IIf(IsDBNull(dtrow("WO_Tot_Lab_Amt").ToString()) = True, 0, dtrow("WO_Tot_Lab_Amt").ToString())
                                                'wojDet.Belop = (wojDet.Pris * (IIf(IsDBNull(dtrow("JOBI_DELIVER_QTY")) = True, 0, dtrow("JOBI_DELIVER_QTY")))) - (wojDet.Pris * (IIf(IsDBNull(dtrow("JOBI_DELIVER_QTY")) = True, 0, dtrow("JOBI_DELIVER_QTY"))) * 0.01 * wojDet.Rab)
                                                wojDet.Belop = (wojDet.Pris * (IIf(IsDBNull(dtrow("JOBI_DELIVER_QTY")) = True, 0, dtrow("JOBI_DELIVER_QTY")))) * (objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtwodebrow("DBT_PER")) = True, 0D, dtwodebrow("DBT_PER"))) / 100)
                                                wojDet.JobId = jobNo '""
                                                wojDet.Flag = "0"
                                                wojDet.ForeignJob = foreignJobText.ToString
                                                wojDet.ItemDesc = dtrow("Item_Desc")
                                                wojDet.LineNo = Convert.ToInt32(dtrow("Sl_No").ToString)
                                                wojDet.IdWOItemseq = dtrow("ID_WOITEM_SEQ").ToString
                                                wojDet.Job_Status = dtWODetails.Rows(0)("JOB_STATUS").ToString
                                                If (dtrow("TEXT") <> "") Then
                                                    wojDet.Diff = "T" 'Text line need to check
                                                    wojDet.Text = IIf(IsDBNull(dtrow("Text")) = True, "", dtrow("Text"))
                                                    wojDet.Bestilt = ""
                                                    wojDet.Levert = ""
                                                    wojDet.Pris = ""
                                                    wojDet.Rab = ""
                                                Else
                                                    wojDet.Diff = "S"
                                                End If

                                                wojDet.IdWODetailseq = dtrow("ID_WODET_SEQ_JOB").ToString
                                                wojDet.IdWOLabSeq = ""
                                                wojDet.Id_Deb_Seq = Convert.ToInt32(dtwodebrow("ID_DBT_SEQ").ToString)
                                                wojDet.Jobi_Bo_Qty = dtrow("JOBI_BO_QTY").ToString
                                                wojDet.Item_Avail_Qty = IIf(IsDBNull(dtrow("Item_Avail_Qty")) = True, "0", dtrow("Item_Avail_Qty"))
                                                wojDet.IdMech = ""
                                                wojDet.Id_Make = IIf(IsDBNull(dtrow("Id_Make")) = True, "", dtrow("Id_Make"))
                                                wojDet.Id_Warehouse = IIf(IsDBNull(dtrow("Id_Warehouse")) = True, "0", Convert.ToInt32(dtrow("Id_Warehouse").ToString))
                                                wojDet.Sp_Cost_Price = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("JOBI_COST_PRICE")) = True, 0D, dtrow("JOBI_COST_PRICE")))
                                                wojDet.MechanicName = ""
                                                wojDet.DebtType = dtwodebrow("CUST_TYPE").ToString
                                                'If Convert.ToInt32(dtwodebrow("DBT_PER")) = 0 Then
                                                '    wojDet.Levert = "0"
                                                '    wojDet.Belop = (wojDet.Pris * (IIf(IsDBNull(wojDet.Levert) = True, 0, wojDet.Levert)))
                                                'Else
                                                '    wojDet.Levert = dtrow("JOBI_DELIVER_QTY")
                                                '    wojDet.Belop = (wojDet.Pris * (IIf(IsDBNull(wojDet.Levert) = True, 0, wojDet.Levert)))

                                                'End If
                                                wojDet.Id_Job_Deb = IIf(IsDBNull(dtwodebrow("Id_Job_Deb")) = True, "", dtwodebrow("Id_Job_Deb"))
                                                debdtails.Add(wojDet)
                                            Next
                                        End If
                                        If dtWODetails.Rows(0)("WO_OWN_RISK_AMT").ToString > 0 Then
                                            Dim wojDet3 As New WOJobDetailBO()
                                            wojDet3.IdJob = ""
                                            wojDet3.Text = IIf(IsDBNull(dtWODetails.Rows(0)("WO_OWN_RISK_DESC")) = True, "", dtWODetails.Rows(0)("WO_OWN_RISK_DESC")) 'dtWODetails.Rows(0)("WO_OWN_RISK_DESC").ToString

                                            If dtwodebrow("CUST_TYPE").ToString = "OHC" Then
                                                wojDet3.Nei = "0"
                                            ElseIf dtwodebrow("CUST_TYPE").ToString = "INSC" Then
                                                wojDet3.Nei = "1"
                                            End If
                                            wojDet3.Ford = dtwodebrow("DBT_PER").ToString
                                            wojDet3.Bestilt = ""
                                            wojDet3.Levert = ""
                                            wojDet3.Pris = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtWODetails.Rows(0)("WO_OWN_RISK_AMT")) = True, 0D, dtWODetails.Rows(0)("WO_OWN_RISK_AMT")))
                                            wojDet3.Rab = ""
                                            Dim totlabamt As String = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtWODetails.Rows(0)("WO_OWN_RISK_AMT")) = True, 0D, dtWODetails.Rows(0)("WO_OWN_RISK_AMT")))
                                            wojDet3.Belop = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), totlabamt)
                                            If dtwodebrow("CUST_TYPE").ToString = "OHC" Then
                                                wojDet3.Belop = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), totlabamt)
                                            ElseIf dtwodebrow("CUST_TYPE").ToString = "INSC" Then
                                                wojDet3.Belop = "0"
                                            End If
                                            wojDet3.JobId = jobNo '""
                                            wojDet3.Flag = "0"
                                            wojDet3.ForeignJob = foreignJobText.ToString
                                            wojDet3.ItemDesc = ""
                                            wojDet3.LineNo = 0
                                            wojDet3.IdWOItemseq = ""
                                            wojDet3.Job_Status = dtWODetails.Rows(0)("JOB_STATUS").ToString


                                            wojDet3.IdWODetailseq = dtWODetails.Rows(0)("ID_WODET_SEQ")
                                            wojDet3.IdWOLabSeq = ""
                                            wojDet3.Id_Deb_Seq = Convert.ToInt32(dtwodebrow("ID_DBT_SEQ").ToString)
                                            wojDet3.Jobi_Bo_Qty = ""
                                            wojDet3.Item_Avail_Qty = 0
                                            wojDet3.IdMech = ""
                                            wojDet3.Id_Make = ""
                                            wojDet3.Id_Warehouse = 0
                                            wojDet3.Sp_Cost_Price = "0"
                                            wojDet3.MechanicName = ""
                                            wojDet3.DebtType = dtwodebrow("CUST_TYPE").ToString
                                            wojDet3.Id_Job_Deb = IIf(IsDBNull(dtwodebrow("Id_Job_Deb")) = True, "", dtwodebrow("Id_Job_Deb"))
                                            debdtails.Add(wojDet3)
                                        End If



                                        If (Convert.ToInt32(dtwodebrow("DBT_PER")) > 0 And Convert.ToInt32(dtwodebrow("DBT_PER")) <> 100) Then
                                            Dim wojDet4 As New WOJobDetailBO()
                                            wojDet4.IdJob = ""
                                            wojDet4.Text = IIf(IsDBNull(dtwodebrow("WO_OWN_RISK_DESC")) = True, "", dtwodebrow("WO_OWN_RISK_DESC"))
                                            If dtwodebrow("CUST_TYPE").ToString = "OHC" Then
                                                wojDet4.Nei = "0"
                                                wojDet4.Diff = "OR"
                                            ElseIf dtwodebrow("CUST_TYPE").ToString = "INSC" Then
                                                wojDet4.Nei = "1"
                                                wojDet4.Diff = "ORARD"
                                            End If
                                            wojDet4.Ford = dtwodebrow("DBT_PER").ToString
                                            wojDet4.Bestilt = ""
                                            wojDet4.Levert = ""
                                            wojDet4.Pris = ""
                                            wojDet4.Rab = ""
                                            'Dim totlabamt As String = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtWODetails.Rows(0)("WO_OWN_RISK_AMT")) = True, 0D, dtWODetails.Rows(0)("WO_OWN_RISK_AMT")))
                                            wojDet4.Belop = "" 'objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), totlabamt)
                                            If dtwodebrow("CUST_TYPE").ToString = "OHC" Then
                                                wojDet4.Belop = "" 'objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), totlabamt)
                                            ElseIf dtwodebrow("CUST_TYPE").ToString = "INSC" Then
                                                wojDet4.Belop = "0"
                                            End If
                                            wojDet4.JobId = jobNo '""
                                            wojDet4.Flag = "0"
                                            wojDet4.ForeignJob = foreignJobText.ToString
                                            wojDet4.ItemDesc = ""
                                            wojDet4.LineNo = 0
                                            wojDet4.IdWOItemseq = ""
                                            wojDet4.Job_Status = dtWODetails.Rows(0)("JOB_STATUS").ToString


                                            wojDet4.IdWODetailseq = dtWODetails.Rows(0)("ID_WODET_SEQ")
                                            wojDet4.IdWOLabSeq = ""
                                            wojDet4.Id_Deb_Seq = Convert.ToInt32(dtwodebrow("ID_DBT_SEQ").ToString)
                                            wojDet4.Jobi_Bo_Qty = ""
                                            wojDet4.Item_Avail_Qty = 0
                                            wojDet4.IdMech = ""
                                            wojDet4.Id_Make = ""
                                            wojDet4.Id_Warehouse = 0
                                            wojDet4.Sp_Cost_Price = "0"
                                            wojDet4.MechanicName = ""
                                            wojDet4.DebtType = dtwodebrow("CUST_TYPE").ToString
                                            wojDet4.Id_Job_Deb = IIf(IsDBNull(dtwodebrow("Id_Job_Deb")) = True, "", dtwodebrow("Id_Job_Deb"))
                                            debdtails.Add(wojDet4)
                                        End If

                                        Dim dt As New DataTable()
                                        ' dt.TableName = "localCustDetails"
                                        For Each [property] As PropertyInfo In debdtails(0).[GetType]().GetProperties()
                                            dt.Columns.Add(New DataColumn([property].Name, [property].PropertyType))
                                        Next

                                        For Each det As WOJobDetailBO In debdtails
                                            Dim newRow As DataRow = dt.NewRow()
                                            For Each [property] As PropertyInfo In det.[GetType]().GetProperties()
                                                newRow([property].Name) = det.[GetType]().GetProperty([property].Name).GetValue(det, Nothing)
                                            Next
                                            dt.Rows.Add(newRow)
                                        Next

                                        '                                      dt.DefaultView.Sort = "LineNo ASC"

                                        dt = dt.DefaultView.ToTable()
                                        debdtails = Nothing
                                        debdtails = New List(Of WOJobDetailBO)()
                                        For Each dtrow As DataRow In dt.Rows
                                            Dim wojDet As New WOJobDetailBO()
                                            wojDet.IdJob = dtrow("IdJob")
                                            wojDet.Text = dtrow("Text")
                                            wojDet.Nei = dtrow("Nei")
                                            wojDet.Ford = dtrow("Ford")
                                            wojDet.Bestilt = dtrow("Bestilt")
                                            wojDet.Levert = dtrow("Levert")
                                            wojDet.Pris = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("Pris")) = True, 0D, dtrow("Pris")))
                                            wojDet.Rab = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("Rab")) = True, 0D, dtrow("Rab")))
                                            'Dim totlabamt As String = IIf(IsDBNull(dtrow("WO_Tot_Lab_Amt").ToString()) = True, 0, dtrow("WO_Tot_Lab_Amt").ToString())
                                            wojDet.Belop = dtrow("Belop") '(wojDet.Pris * (IIf(IsDBNull(dtrow("Belop")) = True, 0, dtrow("Belop")))) - (wojDet.Pris * (IIf(IsDBNull(dtrow("JOBI_DELIVER_QTY")) = True, 0, dtrow("JOBI_DELIVER_QTY"))) * 0.01 * wojDet.Rab)
                                            wojDet.JobId = dtrow("JobId") '""
                                            wojDet.Flag = dtrow("Flag")
                                            wojDet.ForeignJob = dtrow("ForeignJob")
                                            wojDet.ItemDesc = dtrow("ItemDesc")
                                            wojDet.LineNo = IIf(IsDBNull(dtrow("LineNo").ToString()) = True, "", dtrow("LineNo").ToString())
                                            wojDet.Diff = IIf(IsDBNull(dtrow("Diff").ToString()) = True, 0, dtrow("Diff").ToString())
                                            wojDet.IdWODetailseq = dtrow("IdWODetailseq").ToString
                                            wojDet.IdWOItemseq = dtrow("IdWOItemseq").ToString
                                            wojDet.Job_Status = dtrow("Job_Status").ToString
                                            wojDet.IdWOLabSeq = dtrow("IdWOLabSeq").ToString
                                            wojDet.Id_Deb_Seq = Convert.ToInt32(dtrow("Id_Deb_Seq").ToString)
                                            wojDet.IdMech = dtrow("IdMech").ToString
                                            wojDet.Jobi_Bo_Qty = dtrow("Jobi_Bo_Qty").ToString
                                            wojDet.Id_Make = dtrow("Id_Make").ToString
                                            wojDet.Item_Avail_Qty = dtrow("Item_Avail_Qty").ToString
                                            wojDet.Id_Warehouse = IIf(IsDBNull(dtrow("Id_Warehouse")) = True, "0", Convert.ToInt32(dtrow("Id_Warehouse").ToString))
                                            wojDet.Sp_Cost_Price = IIf(IsDBNull(dtrow("Sp_Cost_Price").ToString()) = True, "0", dtrow("Sp_Cost_Price").ToString())
                                            wojDet.MechanicName = IIf(IsDBNull(dtrow("MechanicName").ToString()) = True, "0", dtrow("MechanicName").ToString())
                                            wojDet.DebtType = dtrow("DebtType").ToString
                                            wojDet.Id_Job_Deb = dtrow("Id_Job_Deb").ToString
                                            debdtails.Add(wojDet)
                                        Next

                                        Dim wojdet2 As New WOJobDetailBO()
                                        wojdet2.IdJob = ""
                                        wojdet2.Text = ""
                                        wojdet2.Nei = ""
                                        wojdet2.Ford = ""
                                        wojdet2.Bestilt = ""
                                        wojdet2.Levert = ""
                                        wojdet2.Pris = ""
                                        wojdet2.Rab = ""
                                        wojdet2.Belop = ""
                                        wojdet2.JobId = jobNo
                                        wojdet2.Flag = "0"
                                        wojdet2.ForeignJob = foreignJobText.ToString
                                        wojdet2.ItemDesc = ""
                                        wojdet2.Job_Status = dtWODetails.Rows(0)("JOB_STATUS").ToString
                                        wojdet2.IdWODetailseq = dtWODetails.Rows(0)("ID_WODET_SEQ").ToString
                                        wojdet2.IdWOItemseq = ""
                                        wojdet2.IdWOLabSeq = ""
                                        wojdet2.Id_Deb_Seq = Convert.ToInt32(dtwodebrow("ID_DBT_SEQ").ToString)
                                        wojdet2.Jobi_Bo_Qty = "0"
                                        wojdet2.Id_Make = ""
                                        wojdet2.Id_Warehouse = 1
                                        wojdet2.Sp_Cost_Price = "0"
                                        wojdet2.MechanicName = ""
                                        wojdet2.DebtType = dtwodebrow("CUST_TYPE").ToString
                                        wojdet2.Id_Job_Deb = IIf(IsDBNull(dtwodebrow("Id_Job_Deb")) = True, "", dtwodebrow("Id_Job_Deb"))
                                        debdtails.Add(wojdet2)
                                    Else
                                        strJobNo = objWOJDO.Fetch_Job_No(objWOJBO) 'Use it later to fetch job no
                                        'strJobNo = "1"
                                        Dim wojDet As New WOJobDetailBO()
                                        wojDet.IdJob = "Job:" + strJobNo
                                        wojDet.Text = ""
                                        wojDet.Nei = "0"
                                        wojDet.Ford = "100"
                                        wojDet.Bestilt = ""
                                        wojDet.Levert = ""
                                        wojDet.Pris = ""
                                        wojDet.Rab = ""
                                        wojDet.Belop = ""
                                        wojDet.JobId = strJobNo '""
                                        wojDet.Flag = "1"
                                        wojDet.ForeignJob = ""
                                        wojDet.ItemDesc = ""
                                        wojDet.IdWODetailseq = ""
                                        wojDet.IdWOItemseq = ""
                                        wojDet.IdWOLabSeq = ""
                                        wojDet.Id_Deb_Seq = 0
                                        wojDet.Jobi_Bo_Qty = "0"
                                        wojDet.Id_Make = ""
                                        wojDet.Id_Warehouse = 1
                                        wojDet.Sp_Cost_Price = "0"
                                        wojDet.MechanicName = ""
                                        wojDet.DebtType = ""
                                        wojDet.Id_Job_Deb = ""
                                        debdtails.Add(wojDet)


                                        Dim wojdet1 As New WOJobDetailBO()
                                        wojdet1.IdJob = ""
                                        wojdet1.Text = ""
                                        wojdet1.Nei = ""
                                        wojdet1.Ford = ""
                                        wojdet1.Bestilt = ""
                                        wojdet1.Levert = ""
                                        wojdet1.Pris = ""
                                        wojdet1.Rab = ""
                                        wojdet1.Belop = ""
                                        wojdet1.JobId = strJobNo
                                        wojdet1.Flag = "0"
                                        wojdet1.ForeignJob = ""
                                        wojdet1.ItemDesc = ""
                                        wojdet1.IdWODetailseq = ""
                                        wojdet1.IdWOItemseq = ""
                                        wojdet1.IdWOLabSeq = ""
                                        wojdet1.Id_Deb_Seq = 0
                                        wojdet1.Jobi_Bo_Qty = "0"
                                        wojdet1.Id_Make = ""
                                        wojdet1.Id_Warehouse = 1
                                        wojdet1.Sp_Cost_Price = "0"
                                        wojdet1.MechanicName = ""
                                        wojdet1.DebtType = ""
                                        wojdet1.Id_Job_Deb = ""
                                        debdtails.Add(wojdet1)
                                    End If
                                    details.AddRange(debdtails)
                                Next

                            End If
                            jobdetails.AddRange(details)

                        Next 'End of No of Jobs
                    Else

                        Dim details As New List(Of WOJobDetailBO)()
                        strJobNo = objWOJDO.Fetch_Job_No(objWOJBO) 'Use it later to fetch job no
                        'strJobNo = "1"
                        Dim wojDet As New WOJobDetailBO()
                        wojDet.IdJob = "Job:" + strJobNo
                        wojDet.Text = ""
                        wojDet.Nei = "0"
                        wojDet.Ford = "100"
                        wojDet.Bestilt = ""
                        wojDet.Levert = ""
                        wojDet.Pris = ""
                        wojDet.Rab = ""
                        wojDet.Belop = ""
                        wojDet.JobId = strJobNo '""
                        wojDet.Flag = "1"
                        wojDet.ForeignJob = ""
                        wojDet.ItemDesc = ""
                        wojDet.IdWODetailseq = ""
                        wojDet.IdWOItemseq = ""
                        wojDet.IdWOLabSeq = ""
                        wojDet.Id_Deb_Seq = 0
                        wojDet.Jobi_Bo_Qty = "0"
                        wojDet.Id_Make = ""
                        wojDet.Id_Warehouse = 1
                        wojDet.Sp_Cost_Price = "0"
                        wojDet.DebtType = "OHC"
                        wojDet.Id_Job_Deb = ""
                        details.Add(wojDet)


                        Dim wojdet1 As New WOJobDetailBO()
                        wojdet1.IdJob = ""
                        wojdet1.Text = ""
                        wojdet1.Nei = ""
                        wojdet1.Ford = ""
                        wojdet1.Bestilt = ""
                        wojdet1.Levert = ""
                        wojdet1.Pris = ""
                        wojdet1.Rab = ""
                        wojdet1.Belop = ""
                        wojdet1.JobId = strJobNo
                        wojdet1.Flag = "0"
                        wojdet1.ForeignJob = ""
                        wojdet1.ItemDesc = ""
                        wojdet1.IdWODetailseq = ""
                        wojdet1.IdWOItemseq = ""
                        wojdet1.IdWOLabSeq = ""
                        wojdet1.Id_Deb_Seq = 0
                        wojdet1.Jobi_Bo_Qty = "0"
                        wojdet1.Id_Make = ""
                        wojdet1.Id_Warehouse = 1
                        wojdet1.Sp_Cost_Price = "0"
                        wojdet1.DebtType = "OHC"
                        wojdet1.Id_Job_Deb = ""
                        details.Add(wojdet1)

                        jobdetails.AddRange(details)
                    End If

                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "LoadWorkOrderDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return jobdetails.ToList
        End Function
        Public Function LoadWorkOrderDetails(ByVal objWOJBO As WOJobDetailBO) As List(Of WOJobDetailBO)

            Dim dsWOJobs As New DataSet 'No of Jobs
            Dim dtWOJobs As New DataTable 'No of Jobs
            Dim dsWODetails As New DataSet  'Job Number and totals
            Dim dtWODetails As New DataTable 'Job Number and totals
            Dim dsWOJDetails As New DataSet 'Spares (TextLine)
            Dim dtWOJDetails As New DataTable 'Spares (TextLine)
            Dim dsLabDetails As New DataSet 'Labour Details
            Dim dtLabDetails As New DataTable 'Labour Details
            Dim dtLogin As New DataTable 'Login Details

            Dim dsDebtDetails As New DataSet 'Debt Details
            Dim dtDebtDetails As New DataTable 'Debt Details

            Dim strJobNo As String

            Dim jobdetails As New List(Of WOJobDetailBO)()
            Dim jobdetails2Deb As New List(Of WOJobDetailBO)()
            Dim jobdetails3Deb As New List(Of WOJobDetailBO)()
            Dim raorLineNo As Integer = 0
            Try

                objWOHBO.Id_WO_NO = objWOJBO.Id_WO_NO
                objWOHBO.Id_WO_Prefix = objWOJBO.Id_WO_Prefix
                objWOHBO.Created_By = objWOJBO.Created_By
                dsWOJobs = objWOHDO.Fetch_WOHeader(objWOHBO)

                If (dsWOJobs.Tables.Count > 0) Then
                    dtWOJobs = dsWOJobs.Tables(3)

                    If (dtWOJobs.Rows.Count > 0) Then
                        For Each dtwojobsrow As DataRow In dtWOJobs.Rows
                            Dim details As New List(Of WOJobDetailBO)()
                            strJobNo = dtwojobsrow("Id_Job").ToString()
                            objWOJBO.Id_Job = strJobNo

                            dsWODetails = objWOJDO.Load_WorkOrderDetails(objWOJBO)
                            If dsWODetails.Tables.Count > 0 Then
                                Dim jobNo As String
                                Dim foreignJobNo As Integer
                                Dim foreignJobText As String = ""

                                If dsWODetails.Tables(0).Rows.Count > 0 Then
                                    dtWODetails = dsWODetails.Tables(0)
                                    dtDebtDetails = dsWODetails.Tables(2)
                                    Dim wojDet As New WOJobDetailBO()
                                    jobNo = dtWODetails.Rows(0)("Id_Job").ToString
                                    foreignJobNo = Convert.ToInt32(jobNo)
                                    foreignJobText = ""
                                    If (foreignJobNo >= 90 And foreignJobNo <= 99) Then
                                        foreignJobText = "FJ"
                                    Else
                                        foreignJobText = ""
                                    End If
                                    wojDet.IdJob = "Job:" + dtWODetails.Rows(0)("Id_Job").ToString
                                    wojDet.WO_Own_Pay_Vat = IIf(IsDBNull(dtWODetails.Rows(0)("WO_Own_Pay_Vat")) = True, False, dtWODetails.Rows(0)("WO_Own_Pay_Vat"))
                                    Dim lastMechanicSaved As String = ""
                                    Dim mecName As String = ""
                                    Dim UserName As String = ""
                                    If (dsWODetails.Tables(6).Rows.Count > 0) Then
                                        dtLabDetails = dsWODetails.Tables(6)
                                        If (dtLabDetails.Rows.Count > 0) Then
                                            For Each dtrow As DataRow In dtLabDetails.Rows
                                                Dim mechanic As String = ""
                                                'Dim mechNm() As String
                                                mechanic = IIf(IsDBNull(dtrow("Id_Login")) = True, "", dtrow("Id_Login"))
                                                mecName = IIf(dtrow("Id_Login") = HttpContext.Current.Session("DUser"), "", dtrow("MECHANICNAME"))
                                                'Dim b As Boolean = mecName.Contains("-")
                                                'If (b = True) Then
                                                '    mechNm = mecName.Split("-")
                                                '    UserName = mechNm(0) + "-" + mechNm(1)
                                                'Else
                                                '    UserName = ""
                                                'End If
                                            Next
                                        End If
                                    End If
                                    lastMechanicSaved = IIf(IsDBNull(dtWODetails.Rows(0)("Id_Mechanic")) = True, "", dtWODetails.Rows(0)("Id_Mechanic"))
                                    Dim lastMechNm() As String
                                    Dim b As Boolean = lastMechanicSaved.Contains("-")
                                    If (b = True) Then
                                        lastMechNm = lastMechanicSaved.Split("-")
                                        lastMechanicSaved = lastMechNm(0) + "-" + lastMechNm(1)
                                        If (lastMechNm.Count > 2) Then
                                            wojDet.IdMech = lastMechNm(2)
                                        Else
                                            wojDet.IdMech = ""
                                            mecName = ""
                                        End If
                                    Else
                                        lastMechanicSaved = ""
                                        wojDet.IdMech = ""
                                        mecName = ""
                                    End If
                                    wojDet.Text = lastMechanicSaved 'UserName
                                    If dtDebtDetails.Rows(0)("CUST_TYPE").ToString = "OHC" Then
                                        wojDet.Nei = "0"
                                    ElseIf dtDebtDetails.Rows(0)("CUST_TYPE").ToString = "INSC" Then
                                        wojDet.Nei = "1"
                                    End If
                                    Dim ford As Integer = dtDebtDetails.Rows(0)("DBT_PER").ToString()
                                    wojDet.Ford = ford
                                    wojDet.Bestilt = ""
                                    wojDet.Levert = ""
                                    wojDet.Pris = ""
                                    Dim rebates As Integer = 0
                                    If dsWODetails.Tables(7).Rows(0)("CUST_DISC_GENERAL").ToString() <> "0" Then
                                        rebates = dsWODetails.Tables(7).Rows(0)("CUST_DISC_GENERAL")
                                        wojDet.Rab = rebates.ToString()
                                    Else
                                        wojDet.Rab = ""
                                    End If
                                    wojDet.Belop = ""
                                    wojDet.JobId = jobNo '""
                                    wojDet.Flag = "1"
                                    wojDet.ForeignJob = foreignJobText.ToString
                                    wojDet.ItemDesc = ""
                                    wojDet.LineNo = 0
                                    wojDet.Diff = ""
                                    wojDet.IdWODetailseq = dtWODetails.Rows(0)("ID_WODET_SEQ").ToString
                                    wojDet.IdWOItemseq = ""
                                    wojDet.Job_Status = dtWODetails.Rows(0)("JOB_STATUS").ToString
                                    wojDet.IdWOLabSeq = ""
                                    If (dtDebtDetails.Rows.Count > 0) Then
                                        wojDet.Id_Deb_Seq = Convert.ToInt32(dtDebtDetails.Rows(0)("ID_DBT_SEQ").ToString) 'Convert.ToInt32(dtDebtDetails.Rows(0)("ID_DBT_SEQ").ToString)
                                    Else
                                        wojDet.Id_Deb_Seq = 0
                                    End If

                                    wojDet.Jobi_Bo_Qty = "0"
                                    wojDet.Id_Warehouse = 1
                                    wojDet.Id_Make = ""
                                    wojDet.Sp_Cost_Price = "0"
                                    wojDet.MechanicName = IIf((lastMechanicSaved + wojDet.IdMech) = "", mecName, (lastMechanicSaved + "-" + wojDet.IdMech))
                                    wojDet.DebtType = dtDebtDetails.Rows(0)("CUST_TYPE").ToString
                                    wojDet.Id_Job_Deb = IIf(IsDBNull(dtDebtDetails.Rows(0)("Id_Job_Deb")) = True, "", dtDebtDetails.Rows(0)("Id_Job_Deb"))
                                    wojDet.WO_Own_Pay_Vat = IIf(IsDBNull(dtWODetails.Rows(0)("WO_Own_Pay_Vat")) = True, False, dtWODetails.Rows(0)("WO_Own_Pay_Vat"))
                                    wojDet.DebtVatPercentage = IIf(IsDBNull(dtDebtDetails.Rows(0)("DEBTOR_VAT_PERCENTAGE")) = True, 0, dtDebtDetails.Rows(0)("DEBTOR_VAT_PERCENTAGE"))
                                    details.Add(wojDet)

                                    dtLabDetails = dsWODetails.Tables(6)
                                    'dtLogin = dsWODetails.Tables(7)

                                    For Each dtrow As DataRow In dtLabDetails.Rows
                                        Dim wojDet1 As New WOJobDetailBO()
                                        Dim validuser As String = ""
                                        validuser = IIf(IsDBNull(dtrow("Id_Login")) = True, "", dtrow("Id_Login"))
                                        Dim mechNm() As String
                                        mechNm = dtrow("MECHANICNAME").ToString.Split("-")
                                        UserName = mechNm(0) + "-" + mechNm(1)
                                        wojDet1.IdJob = IIf(validuser = HttpContext.Current.Session("DUser"), "", UserName)
                                        wojDet1.Text = dtrow("WO_Labour_desc")
                                        If dtDebtDetails.Rows(0)("CUST_TYPE").ToString = "OHC" Then
                                            wojDet1.Nei = "0"
                                        ElseIf dtDebtDetails.Rows(0)("CUST_TYPE").ToString = "INSC" Then
                                            wojDet1.Nei = "1"
                                        End If
                                        wojDet1.Ford = dtDebtDetails.Rows(0)("DBT_PER").ToString
                                        wojDet1.Bestilt = ""
                                        wojDet1.Levert = dtrow("WO_Labour_Hours")
                                        wojDet1.Pris = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("WO_Hourley_Price")) = True, 0D, dtrow("WO_Hourley_Price")))
                                        Dim totlabamt As String = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("WO_Labour_Hours")) = True, 0D, dtrow("WO_Labour_Hours"))) * objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("WO_Hourley_Price")) = True, 0D, dtrow("WO_Hourley_Price"))) * (objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtDebtDetails.Rows(0)("DBT_PER")) = True, 0D, dtDebtDetails.Rows(0)("DBT_PER"))) / 100) 'IIf(IsDBNull(dtrow("WO_Tot_Lab_Amt").ToString()) = True, 0, dtrow("WO_Tot_Lab_Amt").ToString())
                                        wojDet1.Belop = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), totlabamt)
                                        wojDet1.JobId = jobNo '""
                                        wojDet1.Flag = "0"
                                        wojDet1.ForeignJob = foreignJobText.ToString
                                        wojDet1.ItemDesc = ""
                                        wojDet1.Diff = "L"
                                        wojDet1.LineNo = Convert.ToInt32(dtrow("Sl_No").ToString)
                                        raorLineNo = Convert.ToInt32(dtrow("Sl_No").ToString)
                                        wojDet1.IdWODetailseq = dtrow("ID_WODET_SEQ").ToString
                                        wojDet1.IdWOItemseq = ""
                                        wojDet1.Job_Status = dtWODetails.Rows(0)("JOB_STATUS").ToString
                                        wojDet1.IdWOLabSeq = dtrow("ID_WOLAB_SEQ").ToString
                                        wojDet1.Id_Deb_Seq = Convert.ToInt32(dtDebtDetails.Rows(0)("ID_DBT_SEQ").ToString)
                                        wojDet1.IdMech = dtrow("ID_LOGIN").ToString
                                        wojDet1.Jobi_Bo_Qty = "0"
                                        wojDet1.Id_Warehouse = 1
                                        wojDet1.Id_Make = ""
                                        wojDet1.Sp_Cost_Price = "0"
                                        rebates = IIf(IsDBNull(dtrow("WO_Lab_Discount")) = True, "0", dtrow("WO_Lab_Discount"))
                                        wojDet1.Rab = rebates.ToString()
                                        Dim mechName As String = ""
                                        mechName = IIf(IsDBNull(dtrow("MECHANICNAME")) = True, "", dtrow("MECHANICNAME"))
                                        mechName = IIf(dtrow("Id_Login") = HttpContext.Current.Session("DUser"), "", dtrow("MECHANICNAME"))
                                        wojDet1.MechanicName = mechName 'dtLogin.Rows(0)("MECHANICNAME").ToString
                                        wojDet1.DebtType = dtDebtDetails.Rows(0)("CUST_TYPE").ToString
                                        wojDet1.Id_Job_Deb = IIf(IsDBNull(dtDebtDetails.Rows(0)("Id_Job_Deb")) = True, "", dtDebtDetails.Rows(0)("Id_Job_Deb"))
                                        wojDet1.WO_Own_Pay_Vat = IIf(IsDBNull(dtWODetails.Rows(0)("WO_Own_Pay_Vat")) = True, False, dtWODetails.Rows(0)("WO_Own_Pay_Vat"))
                                        details.Add(wojDet1)
                                    Next
                                End If
                                If dsWODetails.Tables(1).Rows.Count > 0 Then
                                    dtWOJDetails = dsWODetails.Tables(1)
                                    For Each dtrow As DataRow In dtWOJDetails.Rows
                                        Dim wojDet As New WOJobDetailBO()
                                        wojDet.IdJob = IIf(IsDBNull(dtrow("Id_Item_Job")) = True, "", dtrow("Id_Item_Job"))
                                        wojDet.Text = dtrow("Item_Desc")
                                        If dtDebtDetails.Rows(0)("CUST_TYPE").ToString = "OHC" Then
                                            wojDet.Nei = "0"
                                        ElseIf dtDebtDetails.Rows(0)("CUST_TYPE").ToString = "INSC" Then
                                            wojDet.Nei = "1"
                                        End If
                                        wojDet.Ford = dtDebtDetails.Rows(0)("DBT_PER").ToString
                                        wojDet.Bestilt = dtrow("JOBI_ORDER_QTY")
                                        wojDet.Levert = dtrow("JOBI_DELIVER_QTY")
                                        wojDet.Pris = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("JOBI_SELL_PRICE")) = True, 0D, dtrow("JOBI_SELL_PRICE")))
                                        Dim rebate As Integer = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("JOBI_DIS_PER")) = True, 0D, dtrow("JOBI_DIS_PER")))
                                        wojDet.Rab = rebate.ToString
                                        'Dim totlabamt As String = IIf(IsDBNull(dtrow("WO_Tot_Lab_Amt").ToString()) = True, 0, dtrow("WO_Tot_Lab_Amt").ToString())
                                        'wojDet.Belop = (wojDet.Pris * (IIf(IsDBNull(dtrow("JOBI_DELIVER_QTY")) = True, 0, dtrow("JOBI_DELIVER_QTY")))) - (wojDet.Pris * (IIf(IsDBNull(dtrow("JOBI_DELIVER_QTY")) = True, 0, dtrow("JOBI_DELIVER_QTY"))) * 0.01 * wojDet.Rab)
                                        wojDet.Belop = (wojDet.Pris * (IIf(IsDBNull(dtrow("JOBI_DELIVER_QTY")) = True, 0, dtrow("JOBI_DELIVER_QTY")))) * (objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtDebtDetails.Rows(0)("DBT_PER")) = True, 0D, dtDebtDetails.Rows(0)("DBT_PER"))) / 100)
                                        wojDet.JobId = jobNo '""
                                        wojDet.Flag = "0"
                                        wojDet.ForeignJob = foreignJobText.ToString
                                        wojDet.ItemDesc = dtrow("Item_Desc")
                                        wojDet.LineNo = Convert.ToInt32(dtrow("Sl_No").ToString)
                                        raorLineNo = Convert.ToInt32(dtrow("Sl_No").ToString)
                                        wojDet.IdWOItemseq = dtrow("ID_WOITEM_SEQ").ToString
                                        wojDet.Job_Status = dtWODetails.Rows(0)("JOB_STATUS").ToString
                                        If (dtrow("TEXT") <> "") Then
                                            wojDet.Diff = "T" 'Text line need to check
                                            wojDet.Text = IIf(IsDBNull(dtrow("Text")) = True, "", dtrow("Text"))
                                            wojDet.Bestilt = ""
                                            wojDet.Levert = ""
                                            wojDet.Pris = ""
                                            wojDet.Rab = ""
                                        Else
                                            wojDet.Diff = "S"
                                        End If

                                        wojDet.IdWODetailseq = dtrow("ID_WODET_SEQ_JOB").ToString
                                        wojDet.Id_Item_Catg_Job_Id = dtrow("Id_Item_Catg_Job_Id").ToString
                                        wojDet.IdWOLabSeq = ""
                                        wojDet.Id_Deb_Seq = Convert.ToInt32(dtDebtDetails.Rows(0)("ID_DBT_SEQ").ToString)
                                        wojDet.Jobi_Bo_Qty = dtrow("JOBI_BO_QTY").ToString
                                        wojDet.Item_Avail_Qty = IIf(IsDBNull(dtrow("Item_Avail_Qty")) = True, "0", dtrow("Item_Avail_Qty"))
                                        wojDet.IdMech = ""
                                        wojDet.Id_Make = IIf(IsDBNull(dtrow("Id_Make")) = True, "", dtrow("Id_Make"))
                                        wojDet.Id_Warehouse = IIf(IsDBNull(dtrow("Id_Warehouse")) = True, "0", Convert.ToInt32(dtrow("Id_Warehouse").ToString))
                                        wojDet.Sp_Cost_Price = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("JOBI_COST_PRICE")) = True, 0D, dtrow("JOBI_COST_PRICE")))
                                        wojDet.MechanicName = ""
                                        wojDet.DebtType = dtDebtDetails.Rows(0)("CUST_TYPE").ToString
                                        wojDet.Id_Job_Deb = IIf(IsDBNull(dtDebtDetails.Rows(0)("Id_Job_Deb")) = True, "", dtDebtDetails.Rows(0)("Id_Job_Deb"))
                                        wojDet.WO_Own_Pay_Vat = IIf(IsDBNull(dtWODetails.Rows(0)("WO_Own_Pay_Vat")) = True, False, dtWODetails.Rows(0)("WO_Own_Pay_Vat"))
                                        wojDet.SpareDiscount = IIf(IsDBNull(dtrow("Spare_Discount")) = True, 0, dtrow("Spare_Discount"))
                                        details.Add(wojDet)
                                    Next
                                End If

                                'Own Risk Amt
                                If dtWODetails.Rows(0)("WO_OWN_RISK_AMT").ToString > 0 And strJobNo = "1" Then
                                    Dim wojDet3 As New WOJobDetailBO()
                                    wojDet3.IdJob = ""
                                    wojDet3.Text = IIf(IsDBNull(dtWODetails.Rows(0)("WO_OWN_RISK_DESC")) = True, "", dtWODetails.Rows(0)("WO_OWN_RISK_DESC")) 'dtWODetails.Rows(0)("WO_OWN_RISK_DESC").ToString

                                    If dtDebtDetails.Rows(0)("CUST_TYPE").ToString = "OHC" Then
                                        wojDet3.Nei = "0"
                                    ElseIf dtDebtDetails.Rows(0)("CUST_TYPE").ToString = "INSC" Then
                                        wojDet3.Nei = "1"
                                    End If
                                    wojDet3.Ford = dtDebtDetails.Rows(0)("DBT_PER").ToString
                                    wojDet3.Bestilt = ""
                                    wojDet3.Levert = ""
                                    wojDet3.Pris = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtWODetails.Rows(0)("WO_OWN_RISK_AMT")) = True, 0D, dtWODetails.Rows(0)("WO_OWN_RISK_AMT")))
                                    wojDet3.Rab = ""
                                    Dim totlabamt As String = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtWODetails.Rows(0)("WO_OWN_RISK_AMT")) = True, 0D, dtWODetails.Rows(0)("WO_OWN_RISK_AMT")))
                                    wojDet3.Belop = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), totlabamt)

                                    If dtDebtDetails.Rows.Count > 2 Then
                                        If dtDebtDetails.Rows(2)("CUST_TYPE").ToString = "MISC" Then
                                            If (dtDebtDetails.Rows(2)("OWN RISK AMOUNT").ToString > 0) Then
                                                wojDet3.Belop = "0"
                                            End If
                                        Else
                                            If dtDebtDetails.Rows(0)("CUST_TYPE").ToString = "OHC" Then
                                                wojDet3.Belop = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), totlabamt)
                                            ElseIf dtDebtDetails.Rows(0)("CUST_TYPE").ToString = "INSC" Then
                                                wojDet3.Belop = "0"
                                            End If
                                        End If
                                    ElseIf (dtDebtDetails.Rows.Count = 2) Then
                                        If (dtDebtDetails.Rows(1)("CUST_TYPE").ToString = "MISC") And (dtDebtDetails.Rows(1)("OWN RISK AMOUNT").ToString > 0) Then
                                            wojDet3.Belop = "0"
                                        End If
                                    Else
                                        If dtDebtDetails.Rows(0)("CUST_TYPE").ToString = "OHC" Then
                                            wojDet3.Belop = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), totlabamt)
                                        ElseIf dtDebtDetails.Rows(0)("CUST_TYPE").ToString = "INSC" Then
                                            wojDet3.Belop = "0"
                                        End If
                                    End If

                                    wojDet3.JobId = jobNo '""
                                    wojDet3.Flag = "0"
                                    wojDet3.ForeignJob = foreignJobText.ToString
                                    wojDet3.ItemDesc = ""
                                    wojDet3.LineNo = IIf(IsDBNull(dtWODetails.Rows(0)("WO_OWN_RISK_SL_NO")) = True, "0", dtWODetails.Rows(0)("WO_OWN_RISK_SL_NO"))
                                    raorLineNo = IIf(IsDBNull(dtWODetails.Rows(0)("WO_OWN_RISK_SL_NO")) = True, "0", dtWODetails.Rows(0)("WO_OWN_RISK_SL_NO"))
                                    wojDet3.IdWOItemseq = ""
                                    wojDet3.Job_Status = dtWODetails.Rows(0)("JOB_STATUS").ToString
                                    wojDet3.Diff = "OR"
                                    wojDet3.IdWODetailseq = dtWODetails.Rows(0)("ID_WODET_SEQ")
                                    wojDet3.IdWOLabSeq = ""
                                    wojDet3.Id_Deb_Seq = Convert.ToInt32(dtDebtDetails.Rows(0)("ID_DBT_SEQ").ToString)
                                    wojDet3.Jobi_Bo_Qty = ""
                                    wojDet3.Item_Avail_Qty = 0
                                    wojDet3.IdMech = ""
                                    wojDet3.Id_Make = ""
                                    wojDet3.Id_Warehouse = 0
                                    wojDet3.Sp_Cost_Price = "0"
                                    wojDet3.MechanicName = ""
                                    wojDet3.DebtType = dtDebtDetails.Rows(0)("CUST_TYPE").ToString
                                    wojDet3.Id_Job_Deb = IIf(IsDBNull(dtDebtDetails.Rows(0)("Id_Job_Deb")) = True, "", dtDebtDetails.Rows(0)("Id_Job_Deb"))
                                    wojDet3.WO_Own_Pay_Vat = IIf(IsDBNull(dtWODetails.Rows(0)("WO_Own_Pay_Vat")) = True, False, dtWODetails.Rows(0)("WO_Own_Pay_Vat"))
                                    details.Add(wojDet3)
                                End If

                                'Reduction After Own Risk and Reduction Before Own Risk
                                If dtDebtDetails.Rows.Count > 0 Then
                                    Dim redType As String = "NoRed" 'No Reduction by default
                                    Dim redDesc As String = ""
                                    If (dtDebtDetails.Rows(0)("Reduction_Per").ToString > 0 Or dtDebtDetails.Rows(0)("Reduction_Amount").ToString > 0) And strJobNo = "1" Then
                                        Dim wojDetRAOR As New WOJobDetailBO()
                                        wojDetRAOR.IdJob = ""

                                        If (dtDebtDetails.Rows(0)("Reduction_Before_OR").ToString = "False" And dtDebtDetails.Rows(0)("Reduction_After_OR").ToString = "False") Then
                                            redType = "NoRed"
                                            redDesc = ""
                                        ElseIf (dtDebtDetails.Rows(0)("Reduction_Before_OR").ToString = "True" And dtDebtDetails.Rows(0)("Reduction_After_OR").ToString = "False") Then
                                            redType = "RBOR"
                                            redDesc = "Reduction Before Own Risk"
                                        ElseIf (dtDebtDetails.Rows(0)("Reduction_Before_OR").ToString = "False" And dtDebtDetails.Rows(0)("Reduction_After_OR").ToString = "True") Then
                                            redType = "RAOR"
                                            redDesc = "Reduction After Own Risk"
                                        End If

                                        wojDetRAOR.Text = redDesc  'IIf(IsDBNull(dtWODetails.Rows(0)("WO_OWN_RISK_DESC")) = True, "", dtWODetails.Rows(0)("WO_OWN_RISK_DESC")) 'dtWODetails.Rows(0)("WO_OWN_RISK_DESC").ToString
                                        'wojDetRAOR.ReductionType = redType
                                        If dtDebtDetails.Rows(0)("CUST_TYPE").ToString = "OHC" Then
                                            wojDetRAOR.Nei = "0"
                                        ElseIf dtDebtDetails.Rows(0)("CUST_TYPE").ToString = "INSC" Then
                                            wojDetRAOR.Nei = "1"
                                        End If
                                        wojDetRAOR.Ford = dtDebtDetails.Rows(0)("Reduction_Per").ToString
                                        wojDetRAOR.Bestilt = ""
                                        wojDetRAOR.Levert = ""
                                        'wojDetRAOR.Pris = "" 'objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtWODetails.Rows(0)("WO_OWN_RISK_AMT")) = True, 0D, dtWODetails.Rows(0)("WO_OWN_RISK_AMT")))
                                        wojDetRAOR.Rab = ""
                                        Dim totlabamt As String = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtDebtDetails.Rows(0)("REDUCTION_AMOUNT")) = True, 0D, dtDebtDetails.Rows(0)("REDUCTION_AMOUNT")))
                                        wojDetRAOR.Belop = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), totlabamt)
                                        If (dtDebtDetails.Rows(0)("Reduction_Per").ToString > 0) Then
                                            wojDetRAOR.Pris = ""
                                        Else
                                            wojDetRAOR.Pris = wojDetRAOR.Belop
                                        End If
                                        wojDetRAOR.JobId = jobNo '""
                                        wojDetRAOR.Flag = "0"
                                        wojDetRAOR.ForeignJob = foreignJobText.ToString
                                        wojDetRAOR.ItemDesc = ""
                                        wojDetRAOR.LineNo = raorLineNo + 1
                                        wojDetRAOR.IdWOItemseq = ""
                                        wojDetRAOR.Job_Status = dtWODetails.Rows(0)("JOB_STATUS").ToString
                                        wojDetRAOR.Diff = redType
                                        wojDetRAOR.IdWODetailseq = dtWODetails.Rows(0)("ID_WODET_SEQ")
                                        wojDetRAOR.IdWOLabSeq = ""
                                        wojDetRAOR.Id_Deb_Seq = Convert.ToInt32(dtDebtDetails.Rows(0)("ID_DBT_SEQ").ToString)
                                        wojDetRAOR.Jobi_Bo_Qty = ""
                                        wojDetRAOR.Item_Avail_Qty = 0
                                        wojDetRAOR.IdMech = ""
                                        wojDetRAOR.Id_Make = ""
                                        wojDetRAOR.Id_Warehouse = 0
                                        wojDetRAOR.Sp_Cost_Price = "0"
                                        wojDetRAOR.MechanicName = ""
                                        wojDetRAOR.DebtType = dtDebtDetails.Rows(0)("CUST_TYPE").ToString
                                        wojDetRAOR.Id_Job_Deb = IIf(IsDBNull(dtDebtDetails.Rows(0)("Id_Job_Deb")) = True, "", dtDebtDetails.Rows(0)("Id_Job_Deb"))
                                        wojDetRAOR.WO_Own_Pay_Vat = IIf(IsDBNull(dtWODetails.Rows(0)("WO_Own_Pay_Vat")) = True, False, dtWODetails.Rows(0)("WO_Own_Pay_Vat"))
                                        details.Add(wojDetRAOR)
                                    End If
                                End If


                                Dim dt As New DataTable()
                                ' dt.TableName = "localCustDetails"
                                For Each [property] As PropertyInfo In details(0).[GetType]().GetProperties()
                                    dt.Columns.Add(New DataColumn([property].Name, [property].PropertyType))
                                Next

                                For Each det As WOJobDetailBO In details
                                    Dim newRow As DataRow = dt.NewRow()
                                    For Each [property] As PropertyInfo In det.[GetType]().GetProperties()
                                        newRow([property].Name) = det.[GetType]().GetProperty([property].Name).GetValue(det, Nothing)
                                    Next
                                    dt.Rows.Add(newRow)
                                Next

                                dt.DefaultView.Sort = "LineNo ASC"
                                HttpContext.Current.Session("WOSpareDetails") = dt 'dsWODetails.Tables(1)

                                dt = dt.DefaultView.ToTable()
                                details = Nothing
                                details = New List(Of WOJobDetailBO)()
                                For Each dtrow As DataRow In dt.Rows
                                    Dim wojDet As New WOJobDetailBO()
                                    wojDet.IdJob = dtrow("IdJob")
                                    wojDet.Text = dtrow("Text")
                                    wojDet.Nei = dtrow("Nei")
                                    wojDet.Ford = dtrow("Ford")
                                    wojDet.Bestilt = dtrow("Bestilt")
                                    wojDet.Levert = dtrow("Levert")
                                    wojDet.Pris = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("Pris")) = True, 0D, dtrow("Pris")))
                                    wojDet.Rab = IIf(IsDBNull(dtrow("Rab")) = True, "0", dtrow("Rab"))
                                    'Dim totlabamt As String = IIf(IsDBNull(dtrow("WO_Tot_Lab_Amt").ToString()) = True, 0, dtrow("WO_Tot_Lab_Amt").ToString())
                                    wojDet.Belop = dtrow("Belop") '(wojDet.Pris * (IIf(IsDBNull(dtrow("Belop")) = True, 0, dtrow("Belop")))) - (wojDet.Pris * (IIf(IsDBNull(dtrow("JOBI_DELIVER_QTY")) = True, 0, dtrow("JOBI_DELIVER_QTY"))) * 0.01 * wojDet.Rab)
                                    wojDet.JobId = dtrow("JobId") '""
                                    wojDet.Flag = dtrow("Flag")
                                    wojDet.ForeignJob = dtrow("ForeignJob")
                                    wojDet.ItemDesc = dtrow("ItemDesc")
                                    wojDet.LineNo = IIf(IsDBNull(dtrow("LineNo").ToString()) = True, "", dtrow("LineNo").ToString())
                                    wojDet.Diff = IIf(IsDBNull(dtrow("Diff").ToString()) = True, 0, dtrow("Diff").ToString())
                                    wojDet.IdWODetailseq = dtrow("IdWODetailseq").ToString
                                    wojDet.IdWOItemseq = dtrow("IdWOItemseq").ToString
                                    wojDet.Job_Status = dtrow("Job_Status").ToString
                                    wojDet.IdWOLabSeq = dtrow("IdWOLabSeq").ToString
                                    wojDet.Id_Deb_Seq = Convert.ToInt32(dtrow("Id_Deb_Seq").ToString)
                                    wojDet.IdMech = dtrow("IdMech").ToString
                                    wojDet.Jobi_Bo_Qty = dtrow("Jobi_Bo_Qty").ToString
                                    wojDet.Id_Make = dtrow("Id_Make").ToString
                                    wojDet.Item_Avail_Qty = dtrow("Item_Avail_Qty").ToString
                                    wojDet.Id_Warehouse = IIf(IsDBNull(dtrow("Id_Warehouse")) = True, "0", Convert.ToInt32(dtrow("Id_Warehouse").ToString))
                                    wojDet.Sp_Cost_Price = IIf(IsDBNull(dtrow("Sp_Cost_Price").ToString()) = True, "0", dtrow("Sp_Cost_Price").ToString())
                                    wojDet.MechanicName = IIf(IsDBNull(dtrow("MechanicName").ToString()) = True, "0", dtrow("MechanicName").ToString())
                                    wojDet.DebtType = dtrow("DebtType").ToString
                                    wojDet.Id_Job_Deb = dtrow("Id_Job_Deb").ToString
                                    wojDet.WO_Own_Pay_Vat = IIf(IsDBNull(dtrow("WO_Own_Pay_Vat")) = True, False, dtrow("WO_Own_Pay_Vat"))
                                    wojDet.SpareDiscount = IIf(IsDBNull(dtrow("SpareDiscount")) = True, 0, dtrow("SpareDiscount"))
                                    wojDet.DebtVatPercentage = dtrow("DebtVatPercentage")
                                    details.Add(wojDet)
                                Next

                                Dim wojdet2 As New WOJobDetailBO()
                                wojdet2.IdJob = ""
                                wojdet2.Text = ""
                                wojdet2.Nei = ""
                                wojdet2.Ford = "0"
                                wojdet2.Bestilt = ""
                                wojdet2.Levert = ""
                                wojdet2.Pris = ""
                                wojdet2.Rab = ""
                                wojdet2.Belop = ""
                                wojdet2.JobId = jobNo
                                wojdet2.Flag = "0"
                                wojdet2.ForeignJob = foreignJobText.ToString
                                wojdet2.ItemDesc = ""
                                wojdet2.Job_Status = dtWODetails.Rows(0)("JOB_STATUS").ToString
                                wojdet2.IdWODetailseq = dtWODetails.Rows(0)("ID_WODET_SEQ").ToString
                                wojdet2.IdWOItemseq = ""
                                wojdet2.IdWOLabSeq = ""
                                wojdet2.Id_Deb_Seq = Convert.ToInt32(dtDebtDetails.Rows(0)("ID_DBT_SEQ").ToString)
                                wojdet2.Jobi_Bo_Qty = "0"
                                wojdet2.Id_Make = ""
                                wojdet2.Id_Warehouse = 1
                                wojdet2.Sp_Cost_Price = "0"
                                wojdet2.MechanicName = ""
                                wojdet2.DebtType = dtDebtDetails.Rows(0)("CUST_TYPE").ToString
                                wojdet2.Id_Job_Deb = IIf(IsDBNull(dtDebtDetails.Rows(0)("Id_Job_Deb")) = True, "", dtDebtDetails.Rows(0)("Id_Job_Deb"))
                                wojdet2.WO_Own_Pay_Vat = IIf(IsDBNull(dtWODetails.Rows(0)("WO_Own_Pay_Vat")) = True, False, dtWODetails.Rows(0)("WO_Own_Pay_Vat"))
                                wojdet2.SpareDiscount = 0
                                details.Add(wojdet2)
                            Else
                                strJobNo = objWOJDO.Fetch_Job_No(objWOJBO) 'Use it later to fetch job no
                                'strJobNo = "1"
                                Dim wojDet As New WOJobDetailBO()
                                wojDet.IdJob = "Job:" + strJobNo
                                wojDet.Text = ""
                                wojDet.Nei = "0"
                                wojDet.Ford = "100"
                                wojDet.Bestilt = ""
                                wojDet.Levert = ""
                                wojDet.Pris = ""
                                wojDet.Rab = ""
                                wojDet.Belop = ""
                                wojDet.JobId = strJobNo '""
                                wojDet.Flag = "1"
                                wojDet.ForeignJob = ""
                                wojDet.ItemDesc = ""
                                wojDet.IdWODetailseq = ""
                                wojDet.IdWOItemseq = ""
                                wojDet.IdWOLabSeq = ""
                                wojDet.Id_Deb_Seq = 0
                                wojDet.Jobi_Bo_Qty = "0"
                                wojDet.Id_Make = ""
                                wojDet.Id_Warehouse = 1
                                wojDet.Sp_Cost_Price = "0"
                                wojDet.MechanicName = ""
                                wojDet.DebtType = "OHC"
                                wojDet.Id_Job_Deb = ""
                                wojDet.WO_Own_Pay_Vat = False
                                wojDet.SpareDiscount = 0
                                wojDet.DebtVatPercentage = 0
                                details.Add(wojDet)


                                Dim wojdet1 As New WOJobDetailBO()
                                wojdet1.IdJob = ""
                                wojdet1.Text = ""
                                wojdet1.Nei = ""
                                wojdet1.Ford = "0"
                                wojdet1.Bestilt = ""
                                wojdet1.Levert = ""
                                wojdet1.Pris = ""
                                wojdet1.Rab = ""
                                wojdet1.Belop = ""
                                wojdet1.JobId = strJobNo
                                wojdet1.Flag = "0"
                                wojdet1.ForeignJob = ""
                                wojdet1.ItemDesc = ""
                                wojdet1.IdWODetailseq = ""
                                wojdet1.IdWOItemseq = ""
                                wojdet1.IdWOLabSeq = ""
                                wojdet1.Id_Deb_Seq = 0
                                wojdet1.Jobi_Bo_Qty = "0"
                                wojdet1.Id_Make = ""
                                wojdet1.Id_Warehouse = 1
                                wojdet1.Sp_Cost_Price = "0"
                                wojdet1.MechanicName = ""
                                wojdet1.DebtType = "OHC"
                                wojdet1.Id_Job_Deb = ""
                                wojdet1.WO_Own_Pay_Vat = False
                                wojdet1.SpareDiscount = 0
                                wojdet1.DebtVatPercentage = 0
                                details.Add(wojdet1)
                            End If

                            jobdetails.AddRange(details)
                        Next 'End of No of Jobs
                    Else

                        Dim details As New List(Of WOJobDetailBO)()
                        strJobNo = objWOJDO.Fetch_Job_No(objWOJBO) 'Use it later to fetch job no
                        'strJobNo = "1"
                        Dim wojDet As New WOJobDetailBO()
                        wojDet.IdJob = "Job:" + strJobNo
                        wojDet.Text = ""
                        wojDet.Nei = "0"
                        wojDet.Ford = "100"
                        wojDet.Bestilt = ""
                        wojDet.Levert = ""
                        wojDet.Pris = ""
                        wojDet.Rab = ""
                        wojDet.Belop = ""
                        wojDet.JobId = strJobNo '""
                        wojDet.Flag = "1"
                        wojDet.ForeignJob = ""
                        wojDet.ItemDesc = ""
                        wojDet.IdWODetailseq = ""
                        wojDet.IdWOItemseq = ""
                        wojDet.IdWOLabSeq = ""
                        wojDet.Id_Deb_Seq = 0
                        wojDet.Jobi_Bo_Qty = "0"
                        wojDet.Id_Make = ""
                        wojDet.Id_Warehouse = 1
                        wojDet.Sp_Cost_Price = "0"
                        wojDet.MechanicName = ""
                        wojDet.DebtType = "OHC"
                        wojDet.Id_Job_Deb = ""
                        wojDet.WO_Own_Pay_Vat = False
                        wojDet.SpareDiscount = 0
                        details.Add(wojDet)


                        Dim wojdet1 As New WOJobDetailBO()
                        wojdet1.IdJob = ""
                        wojdet1.Text = ""
                        wojdet1.Nei = ""
                        wojdet1.Ford = "0"
                        wojdet1.Bestilt = ""
                        wojdet1.Levert = ""
                        wojdet1.Pris = ""
                        wojdet1.Rab = ""
                        wojdet1.Belop = ""
                        wojdet1.JobId = strJobNo
                        wojdet1.Flag = "0"
                        wojdet1.ForeignJob = ""
                        wojdet1.ItemDesc = ""
                        wojdet1.IdWODetailseq = ""
                        wojdet1.IdWOItemseq = ""
                        wojdet1.IdWOLabSeq = ""
                        wojdet1.Id_Deb_Seq = 0
                        wojdet1.Jobi_Bo_Qty = "0"
                        wojdet1.Id_Make = ""
                        wojdet1.Id_Warehouse = 1
                        wojdet1.Sp_Cost_Price = "0"
                        wojdet1.MechanicName = ""
                        wojdet1.DebtType = "OHC"
                        wojdet1.Id_Job_Deb = ""
                        wojdet1.WO_Own_Pay_Vat = False
                        wojdet1.SpareDiscount = 0
                        details.Add(wojdet1)

                        jobdetails.AddRange(details)
                    End If

                End If

                'Second Debitor
                If dsWODetails.Tables.Count > 0 Then
                    '
                    If (dsWOJobs.Tables.Count > 0) Then
                        dtWOJobs = dsWOJobs.Tables(3)

                        If (dtWOJobs.Rows.Count > 0) Then
                            For Each dtwojobsrow As DataRow In dtWOJobs.Rows
                                Dim details As New List(Of WOJobDetailBO)()
                                strJobNo = dtwojobsrow("Id_Job").ToString()
                                objWOJBO.Id_Job = strJobNo

                                dsWODetails = objWOJDO.Load_WorkOrderDetails(objWOJBO)
                                If dsWODetails.Tables(2).Rows.Count > 1 Then
                                    dtDebtDetails = dsWODetails.Tables(2)
                                    If dtDebtDetails.Rows(1)("DEB_STATUS").ToString <> "DEL" Then
                                        If dsWODetails.Tables.Count > 0 Then
                                            Dim jobNo As String
                                            Dim foreignJobNo As Integer
                                            Dim foreignJobText As String = ""

                                            If dsWODetails.Tables(0).Rows.Count > 0 Then
                                                dtWODetails = dsWODetails.Tables(0)
                                                dtDebtDetails = dsWODetails.Tables(2)
                                                Dim wojDet As New WOJobDetailBO()
                                                jobNo = dtWODetails.Rows(0)("Id_Job").ToString
                                                foreignJobNo = Convert.ToInt32(jobNo)
                                                foreignJobText = ""
                                                If (foreignJobNo >= 90 And foreignJobNo <= 99) Then
                                                    foreignJobText = "FJ"
                                                Else
                                                    foreignJobText = ""
                                                End If
                                                wojDet.IdJob = "Job:" + dtWODetails.Rows(0)("Id_Job").ToString
                                                Dim lastMechanicSaved As String = ""
                                                Dim mecName As String = ""
                                                Dim UserName As String = ""
                                                If (dsWODetails.Tables(6).Rows.Count > 0) Then
                                                    dtLabDetails = dsWODetails.Tables(6)
                                                    If (dtLabDetails.Rows.Count > 0) Then
                                                        For Each dtrow As DataRow In dtLabDetails.Rows
                                                            Dim mechanic As String = ""
                                                            'Dim mechNm() As String
                                                            mechanic = IIf(IsDBNull(dtrow("Id_Login")) = True, "", dtrow("Id_Login"))
                                                            mecName = IIf(dtrow("Id_Login") = HttpContext.Current.Session("DUser"), "", dtrow("MECHANICNAME"))
                                                            'Dim b As Boolean = mecName.Contains("-")
                                                            'If (b = True) Then
                                                            '    mechNm = mecName.Split("-")
                                                            '    UserName = mechNm(0) + "-" + mechNm(1)
                                                            'Else
                                                            '    UserName = ""
                                                            'End If
                                                        Next
                                                    End If
                                                End If
                                                lastMechanicSaved = IIf(IsDBNull(dtWODetails.Rows(0)("Id_Mechanic")) = True, "", dtWODetails.Rows(0)("Id_Mechanic"))
                                                Dim lastMechNm() As String
                                                Dim b As Boolean = lastMechanicSaved.Contains("-")
                                                If (b = True) Then
                                                    lastMechNm = lastMechanicSaved.Split("-")
                                                    lastMechanicSaved = lastMechNm(0) + "-" + lastMechNm(1)
                                                    If (lastMechNm.Count > 2) Then
                                                        wojDet.IdMech = lastMechNm(2)
                                                    Else
                                                        wojDet.IdMech = ""
                                                        mecName = ""
                                                    End If
                                                Else
                                                    lastMechanicSaved = ""
                                                    wojDet.IdMech = ""
                                                    mecName = ""
                                                End If
                                                wojDet.Text = lastMechanicSaved 'UserName
                                                If dtDebtDetails.Rows(1)("CUST_TYPE").ToString = "OHC" Then
                                                    wojDet.Nei = "0"
                                                ElseIf dtDebtDetails.Rows(1)("CUST_TYPE").ToString = "INSC" Then
                                                    wojDet.Nei = "1"
                                                ElseIf dtDebtDetails.Rows(1)("CUST_TYPE").ToString = "INTC" Then
                                                    wojDet.Nei = "2"
                                                ElseIf dtDebtDetails.Rows(1)("CUST_TYPE").ToString = "CLA" Then
                                                    wojDet.Nei = "3"
                                                ElseIf dtDebtDetails.Rows(1)("CUST_TYPE").ToString = "MISC" Then
                                                    wojDet.Nei = "4"
                                                End If
                                                wojDet.Ford = dtDebtDetails.Rows(1)("DBT_PER").ToString
                                                wojDet.Bestilt = ""
                                                wojDet.Levert = ""
                                                wojDet.Pris = ""
                                                Dim rebate As Integer = 0
                                                If dsWODetails.Tables(7).Rows(1)("CUST_DISC_GENERAL").ToString() <> "0" Then
                                                    rebate = dsWODetails.Tables(7).Rows(1)("CUST_DISC_GENERAL")
                                                    wojDet.Rab = rebate.ToString()
                                                Else
                                                    wojDet.Rab = ""
                                                End If
                                                wojDet.Belop = ""
                                                wojDet.JobId = jobNo '""
                                                wojDet.Flag = "1"
                                                wojDet.ForeignJob = foreignJobText.ToString
                                                wojDet.ItemDesc = ""
                                                wojDet.LineNo = 0
                                                wojDet.Diff = ""
                                                wojDet.IdWODetailseq = dtWODetails.Rows(0)("ID_WODET_SEQ").ToString
                                                wojDet.IdWOItemseq = ""
                                                wojDet.Job_Status = dtWODetails.Rows(0)("JOB_STATUS").ToString
                                                wojDet.IdWOLabSeq = ""
                                                If (dtDebtDetails.Rows.Count > 1) Then
                                                    wojDet.Id_Deb_Seq = Convert.ToInt32(dtDebtDetails.Rows(1)("ID_DBT_SEQ").ToString) 'Convert.ToInt32(dtDebtDetails.Rows(0)("ID_DBT_SEQ").ToString)
                                                Else
                                                    wojDet.Id_Deb_Seq = 0
                                                End If

                                                wojDet.Jobi_Bo_Qty = "0"
                                                wojDet.Id_Warehouse = 1
                                                wojDet.Id_Make = ""
                                                wojDet.Sp_Cost_Price = "0"
                                                wojDet.MechanicName = IIf((lastMechanicSaved + wojDet.IdMech) = "", mecName, (lastMechanicSaved + "-" + wojDet.IdMech))
                                                wojDet.DebtType = dtDebtDetails.Rows(1)("CUST_TYPE").ToString
                                                wojDet.Id_Job_Deb = IIf(IsDBNull(dtDebtDetails.Rows(1)("Id_Job_Deb")) = True, "", dtDebtDetails.Rows(1)("Id_Job_Deb"))
                                                wojDet.WO_Own_Pay_Vat = IIf(IsDBNull(dtWODetails.Rows(0)("WO_Own_Pay_Vat")) = True, False, dtWODetails.Rows(0)("WO_Own_Pay_Vat"))
                                                wojDet.SplitPercent = dtDebtDetails.Rows(1)("DBT_PER").ToString
                                                wojDet.DebtVatPercentage = IIf(IsDBNull(dtDebtDetails.Rows(1)("DEBTOR_VAT_PERCENTAGE")) = True, 0, dtDebtDetails.Rows(1)("DEBTOR_VAT_PERCENTAGE"))
                                                details.Add(wojDet)

                                                dtLabDetails = dsWODetails.Tables(6)
                                                'dtLogin = dsWODetails.Tables(7)

                                                For Each dtrow As DataRow In dtLabDetails.Rows
                                                    Dim wojDet1 As New WOJobDetailBO()
                                                    Dim validuser As String = ""
                                                    validuser = IIf(IsDBNull(dtrow("Id_Login")) = True, "", dtrow("Id_Login"))
                                                    Dim mechNm() As String
                                                    mechNm = dtrow("MECHANICNAME").ToString.Split("-")
                                                    UserName = mechNm(0) + "-" + mechNm(1)
                                                    wojDet1.IdJob = IIf(validuser = HttpContext.Current.Session("DUser"), "", UserName)
                                                    wojDet1.Text = dtrow("WO_Labour_desc")
                                                    If dtDebtDetails.Rows(1)("CUST_TYPE").ToString = "OHC" Then
                                                        wojDet1.Nei = "0"
                                                    ElseIf dtDebtDetails.Rows(1)("CUST_TYPE").ToString = "INSC" Then
                                                        wojDet1.Nei = "1"
                                                    ElseIf dtDebtDetails.Rows(1)("CUST_TYPE").ToString = "INTC" Then
                                                        wojDet1.Nei = "2"
                                                    ElseIf dtDebtDetails.Rows(1)("CUST_TYPE").ToString = "CLA" Then
                                                        wojDet1.Nei = "3"
                                                    ElseIf dtDebtDetails.Rows(1)("CUST_TYPE").ToString = "MISC" Then
                                                        wojDet1.Nei = "4"
                                                    End If
                                                    wojDet1.Ford = dtDebtDetails.Rows(1)("DBT_PER").ToString
                                                    wojDet1.Bestilt = ""
                                                    wojDet1.Levert = dtrow("WO_Labour_Hours")
                                                    wojDet1.Pris = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("WO_Hourley_Price")) = True, 0D, dtrow("WO_Hourley_Price")))
                                                    Dim totlabamt As String = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("WO_Labour_Hours")) = True, 0D, dtrow("WO_Labour_Hours"))) * objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("WO_Hourley_Price")) = True, 0D, dtrow("WO_Hourley_Price"))) * (objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtDebtDetails.Rows(1)("DBT_PER")) = True, 0D, dtDebtDetails.Rows(1)("DBT_PER"))) / 100) 'IIf(IsDBNull(dtrow("WO_Tot_Lab_Amt").ToString()) = True, 0, dtrow("WO_Tot_Lab_Amt").ToString())
                                                    wojDet1.Belop = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), totlabamt)
                                                    wojDet1.JobId = jobNo '""
                                                    wojDet1.Flag = "0"
                                                    wojDet1.ForeignJob = foreignJobText.ToString
                                                    wojDet1.ItemDesc = ""
                                                    wojDet1.Diff = "L"
                                                    wojDet1.LineNo = Convert.ToInt32(dtrow("Sl_No").ToString)
                                                    wojDet1.IdWODetailseq = dtrow("ID_WODET_SEQ").ToString
                                                    wojDet1.IdWOItemseq = ""
                                                    wojDet1.Job_Status = dtWODetails.Rows(0)("JOB_STATUS").ToString
                                                    wojDet1.IdWOLabSeq = dtrow("ID_WOLAB_SEQ").ToString
                                                    wojDet1.Id_Deb_Seq = Convert.ToInt32(dtDebtDetails.Rows(1)("ID_DBT_SEQ").ToString)
                                                    wojDet1.IdMech = dtrow("ID_LOGIN").ToString
                                                    wojDet1.Jobi_Bo_Qty = "0"
                                                    wojDet1.Id_Warehouse = 1
                                                    wojDet1.Id_Make = ""
                                                    wojDet1.Sp_Cost_Price = "0"
                                                    'Debitor Discount
                                                    'wojDet1.Rab = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("WO_Lab_Discount")) = True, 0D, dtrow("WO_Lab_Discount")))

                                                    Dim mechName As String = ""
                                                    mechName = IIf(IsDBNull(dtrow("MECHANICNAME")) = True, "", dtrow("MECHANICNAME"))
                                                    mechName = IIf(dtrow("Id_Login") = HttpContext.Current.Session("DUser"), "", dtrow("MECHANICNAME"))
                                                    wojDet1.MechanicName = mechName 'dtLogin.Rows(0)("MECHANICNAME").ToString
                                                    wojDet1.DebtType = dtDebtDetails.Rows(1)("CUST_TYPE").ToString
                                                    wojDet1.Id_Job_Deb = IIf(IsDBNull(dtDebtDetails.Rows(1)("Id_Job_Deb")) = True, "", dtDebtDetails.Rows(1)("Id_Job_Deb"))
                                                    wojDet1.WO_Own_Pay_Vat = IIf(IsDBNull(dtWODetails.Rows(0)("WO_Own_Pay_Vat")) = True, False, dtWODetails.Rows(0)("WO_Own_Pay_Vat"))
                                                    wojDet1.SplitPercent = dtDebtDetails.Rows(1)("DBT_PER").ToString

                                                    wojDet1.Rab = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtDebtDetails.Rows(1)("DISCOUNT PERCENTAGE")) = True, 0D, dtDebtDetails.Rows(1)("DISCOUNT PERCENTAGE")))

                                                    Dim debitorDisc As Decimal = IIf(IsDBNull(dtDebtDetails.Rows(1)("DISCOUNT PERCENTAGE")) = True, 0D, dtDebtDetails.Rows(1)("DISCOUNT PERCENTAGE"))
                                                    If (debitorDisc > 0) Then
                                                        rebate = IIf(IsDBNull(dtDebtDetails.Rows(1)("DISCOUNT PERCENTAGE")) = True, "0", dtDebtDetails.Rows(1)("DISCOUNT PERCENTAGE"))
                                                    ElseIf ((IIf(IsDBNull(dtDebtDetails.Rows(1)("CUST_LABOUR_DISC")) = True, 0D, dtDebtDetails.Rows(1)("CUST_LABOUR_DISC"))) > 0) Then
                                                        rebate = IIf(IsDBNull(dtDebtDetails.Rows(1)("CUST_LABOUR_DISC")) = True, 0D, dtDebtDetails.Rows(1)("CUST_LABOUR_DISC"))
                                                    ElseIf ((IIf(IsDBNull(dtDebtDetails.Rows(1)("CUST_GENERAL_DISC")) = True, 0D, dtDebtDetails.Rows(1)("CUST_GENERAL_DISC"))) > 0) Then
                                                        rebate = IIf(IsDBNull(dtDebtDetails.Rows(1)("CUST_GENERAL_DISC")) = True, 0D, dtDebtDetails.Rows(1)("CUST_GENERAL_DISC"))
                                                    Else
                                                        rebate = "0"
                                                    End If
                                                    wojDet1.DebitorDiscount = IIf(IsDBNull(dtDebtDetails.Rows(1)("DISCOUNT PERCENTAGE")) = True, "0", dtDebtDetails.Rows(1)("DISCOUNT PERCENTAGE"))
                                                    wojDet1.CustGenDiscount = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtDebtDetails.Rows(1)("CUST_GENERAL_DISC")) = True, "0", dtDebtDetails.Rows(1)("CUST_GENERAL_DISC")))
                                                    wojDet1.CustLabDiscount = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtDebtDetails.Rows(1)("CUST_LABOUR_DISC")) = True, "0", dtDebtDetails.Rows(1)("CUST_LABOUR_DISC")))
                                                    wojDet1.CustSpareDiscount = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtDebtDetails.Rows(1)("CUST_SPARE_DISC")) = True, "0", dtDebtDetails.Rows(1)("CUST_SPARE_DISC")))

                                                    wojDet1.Rab = rebate.ToString
                                                    details.Add(wojDet1)
                                                Next
                                            End If
                                            If dsWODetails.Tables(1).Rows.Count > 0 Then
                                                dtWOJDetails = dsWODetails.Tables(1)
                                                For Each dtrow As DataRow In dtWOJDetails.Rows
                                                    Dim wojDet As New WOJobDetailBO()
                                                    wojDet.IdJob = IIf(IsDBNull(dtrow("Id_Item_Job")) = True, "", dtrow("Id_Item_Job"))
                                                    wojDet.Text = dtrow("Item_Desc")
                                                    If dtDebtDetails.Rows(1)("CUST_TYPE").ToString = "OHC" Then
                                                        wojDet.Nei = "0"
                                                    ElseIf dtDebtDetails.Rows(1)("CUST_TYPE").ToString = "INSC" Then
                                                        wojDet.Nei = "1"
                                                    ElseIf dtDebtDetails.Rows(1)("CUST_TYPE").ToString = "INTC" Then
                                                        wojDet.Nei = "2"
                                                    ElseIf dtDebtDetails.Rows(1)("CUST_TYPE").ToString = "CLA" Then
                                                        wojDet.Nei = "3"
                                                    ElseIf dtDebtDetails.Rows(1)("CUST_TYPE").ToString = "MISC" Then
                                                        wojDet.Nei = "4"
                                                    End If
                                                    wojDet.Ford = dtDebtDetails.Rows(1)("DBT_PER").ToString
                                                    wojDet.Bestilt = dtrow("JOBI_ORDER_QTY")
                                                    wojDet.Levert = dtrow("JOBI_DELIVER_QTY")
                                                    wojDet.Pris = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("JOBI_SELL_PRICE")) = True, 0D, dtrow("JOBI_SELL_PRICE")))
                                                    'Debitor Discount
                                                    'wojDet.Rab = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("JOBI_DIS_PER")) = True, 0D, dtrow("JOBI_DIS_PER")))
                                                    wojDet.Rab = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtDebtDetails.Rows(1)("DISCOUNT PERCENTAGE")) = True, 0D, dtDebtDetails.Rows(1)("DISCOUNT PERCENTAGE")))

                                                    'Dim totlabamt As String = IIf(IsDBNull(dtrow("WO_Tot_Lab_Amt").ToString()) = True, 0, dtrow("WO_Tot_Lab_Amt").ToString())
                                                    'wojDet.Belop = (wojDet.Pris * (IIf(IsDBNull(dtrow("JOBI_DELIVER_QTY")) = True, 0, dtrow("JOBI_DELIVER_QTY")))) - (wojDet.Pris * (IIf(IsDBNull(dtrow("JOBI_DELIVER_QTY")) = True, 0, dtrow("JOBI_DELIVER_QTY"))) * 0.01 * wojDet.Rab)
                                                    wojDet.Belop = (wojDet.Pris * (IIf(IsDBNull(dtrow("JOBI_DELIVER_QTY")) = True, 0, dtrow("JOBI_DELIVER_QTY")))) * (objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtDebtDetails.Rows(1)("DBT_PER")) = True, 0D, dtDebtDetails.Rows(1)("DBT_PER"))) / 100)
                                                    wojDet.JobId = jobNo '""
                                                    wojDet.Flag = "0"
                                                    wojDet.ForeignJob = foreignJobText.ToString
                                                    wojDet.ItemDesc = dtrow("Item_Desc")
                                                    wojDet.LineNo = Convert.ToInt32(dtrow("Sl_No").ToString)
                                                    wojDet.IdWOItemseq = dtrow("ID_WOITEM_SEQ").ToString
                                                    wojDet.Job_Status = dtWODetails.Rows(0)("JOB_STATUS").ToString
                                                    If (dtrow("TEXT") <> "") Then
                                                        wojDet.Diff = "T" 'Text line need to check
                                                        wojDet.Text = IIf(IsDBNull(dtrow("Text")) = True, "", dtrow("Text"))
                                                        wojDet.Bestilt = ""
                                                        wojDet.Levert = ""
                                                        wojDet.Pris = ""
                                                        wojDet.Rab = ""
                                                    Else
                                                        wojDet.Diff = "S"
                                                    End If

                                                    wojDet.IdWODetailseq = dtrow("ID_WODET_SEQ_JOB").ToString
                                                    wojDet.IdWOLabSeq = ""
                                                    wojDet.Id_Deb_Seq = Convert.ToInt32(dtDebtDetails.Rows(1)("ID_DBT_SEQ").ToString)
                                                    wojDet.Jobi_Bo_Qty = dtrow("JOBI_BO_QTY").ToString
                                                    wojDet.Item_Avail_Qty = IIf(IsDBNull(dtrow("Item_Avail_Qty")) = True, "0", dtrow("Item_Avail_Qty"))
                                                    wojDet.IdMech = ""
                                                    wojDet.Id_Make = IIf(IsDBNull(dtrow("Id_Make")) = True, "", dtrow("Id_Make"))
                                                    wojDet.Id_Warehouse = IIf(IsDBNull(dtrow("Id_Warehouse")) = True, "0", Convert.ToInt32(dtrow("Id_Warehouse").ToString))
                                                    wojDet.Sp_Cost_Price = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("JOBI_COST_PRICE")) = True, 0D, dtrow("JOBI_COST_PRICE")))
                                                    wojDet.MechanicName = ""
                                                    wojDet.DebtType = dtDebtDetails.Rows(1)("CUST_TYPE").ToString
                                                    wojDet.Id_Job_Deb = IIf(IsDBNull(dtDebtDetails.Rows(1)("Id_Job_Deb")) = True, "", dtDebtDetails.Rows(1)("Id_Job_Deb"))
                                                    wojDet.WO_Own_Pay_Vat = IIf(IsDBNull(dtWODetails.Rows(0)("WO_Own_Pay_Vat")) = True, False, dtWODetails.Rows(0)("WO_Own_Pay_Vat"))
                                                    wojDet.SplitPercent = dtDebtDetails.Rows(1)("DBT_PER").ToString
                                                    Dim rebate As Integer = 0
                                                    Dim debitorDisc As Decimal = IIf(IsDBNull(dtDebtDetails.Rows(1)("DISCOUNT PERCENTAGE")) = True, 0D, dtDebtDetails.Rows(1)("DISCOUNT PERCENTAGE"))
                                                    If (debitorDisc > 0) Then
                                                        rebate = IIf(IsDBNull(dtDebtDetails.Rows(1)("DISCOUNT PERCENTAGE")) = True, 0, dtDebtDetails.Rows(1)("DISCOUNT PERCENTAGE"))
                                                    ElseIf ((IIf(IsDBNull(dtDebtDetails.Rows(1)("CUST_SPARE_DISC")) = True, 0D, dtDebtDetails.Rows(1)("CUST_SPARE_DISC"))) > 0) Then
                                                        rebate = IIf(IsDBNull(dtDebtDetails.Rows(1)("CUST_SPARE_DISC")) = True, 0D, dtDebtDetails.Rows(1)("CUST_SPARE_DISC"))
                                                    ElseIf ((IIf(IsDBNull(dtDebtDetails.Rows(1)("CUST_GENERAL_DISC")) = True, 0D, dtDebtDetails.Rows(1)("CUST_GENERAL_DISC"))) > 0) Then
                                                        rebate = IIf(IsDBNull(dtDebtDetails.Rows(1)("CUST_GENERAL_DISC")) = True, 0D, dtDebtDetails.Rows(1)("CUST_GENERAL_DISC"))
                                                    ElseIf ((IIf(IsDBNull(dtrow("SPARE_DISCOUNT")) = True, 0, dtrow("SPARE_DISCOUNT"))) > 0) Then
                                                        rebate = IIf(IsDBNull(dtrow("SPARE_DISCOUNT")) = True, 0, dtrow("SPARE_DISCOUNT"))
                                                    Else
                                                        rebate = 0
                                                    End If
                                                    wojDet.Rab = rebate.ToString()

                                                    wojDet.DebitorDiscount = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtDebtDetails.Rows(1)("DISCOUNT PERCENTAGE")) = True, "0", dtDebtDetails.Rows(1)("DISCOUNT PERCENTAGE")))
                                                    wojDet.CustGenDiscount = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtDebtDetails.Rows(1)("CUST_GENERAL_DISC")) = True, "0", dtDebtDetails.Rows(1)("CUST_GENERAL_DISC")))
                                                    wojDet.CustLabDiscount = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtDebtDetails.Rows(1)("CUST_LABOUR_DISC")) = True, "0", dtDebtDetails.Rows(1)("CUST_LABOUR_DISC")))
                                                    wojDet.CustSpareDiscount = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtDebtDetails.Rows(1)("CUST_SPARE_DISC")) = True, "0", dtDebtDetails.Rows(1)("CUST_SPARE_DISC")))
                                                    wojDet.SpareDiscount = IIf(IsDBNull(dtrow("Spare_Discount")) = True, 0, dtrow("Spare_Discount"))
                                                    details.Add(wojDet)
                                                Next
                                            End If

                                            'Own Risk Amt
                                            If dtWODetails.Rows(0)("WO_OWN_RISK_AMT").ToString > 0 And strJobNo = "1" Then
                                                Dim wojDet3 As New WOJobDetailBO()
                                                wojDet3.IdJob = ""
                                                wojDet3.Text = "Own Risk Charged" 'IIf(IsDBNull(dtWODetails.Rows(0)("WO_OWN_RISK_DESC")) = True, "", dtWODetails.Rows(0)("WO_OWN_RISK_DESC")) 'dtWODetails.Rows(0)("WO_OWN_RISK_DESC").ToString

                                                If dtDebtDetails.Rows(1)("CUST_TYPE").ToString = "OHC" Then
                                                    wojDet3.Nei = "0"
                                                ElseIf dtDebtDetails.Rows(1)("CUST_TYPE").ToString = "INSC" Then
                                                    wojDet3.Nei = "1"
                                                ElseIf dtDebtDetails.Rows(1)("CUST_TYPE").ToString = "INTC" Then
                                                    wojDet3.Nei = "2"
                                                ElseIf dtDebtDetails.Rows(1)("CUST_TYPE").ToString = "CLA" Then
                                                    wojDet3.Nei = "3"
                                                ElseIf dtDebtDetails.Rows(1)("CUST_TYPE").ToString = "MISC" Then
                                                    wojDet3.Nei = "4"
                                                End If
                                                wojDet3.Ford = dtDebtDetails.Rows(1)("DBT_PER").ToString
                                                wojDet3.Bestilt = ""
                                                wojDet3.Levert = ""
                                                wojDet3.Pris = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtWODetails.Rows(0)("WO_OWN_RISK_AMT")) = True, 0D, dtWODetails.Rows(0)("WO_OWN_RISK_AMT")))
                                                wojDet3.Rab = ""
                                                Dim totlabamt As String = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtWODetails.Rows(0)("WO_OWN_RISK_AMT")) = True, 0D, dtWODetails.Rows(0)("WO_OWN_RISK_AMT")))
                                                wojDet3.Belop = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), totlabamt)
                                                If dtDebtDetails.Rows(1)("CUST_TYPE").ToString = "OHC" Then
                                                    wojDet3.Belop = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), totlabamt)
                                                ElseIf dtDebtDetails.Rows(1)("CUST_TYPE").ToString = "INSC" Then
                                                    'Dim ownRiskAmt As Integer = (-1 * Convert.ToInt32(totlabamt))
                                                    wojDet3.Belop = (-1 * Convert.ToDecimal(IIf(IsDBNull(dtWODetails.Rows(0)("WO_OWN_RISK_AMT")) = True, 0, dtWODetails.Rows(0)("WO_OWN_RISK_AMT"))))
                                                ElseIf dtDebtDetails.Rows(1)("CUST_TYPE").ToString = "MISC" Then
                                                    wojDet3.Belop = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), dtDebtDetails.Rows(1)("OWN RISK AMOUNT").ToString)
                                                End If
                                                wojDet3.JobId = jobNo '""
                                                wojDet3.Flag = "0"
                                                wojDet3.ForeignJob = foreignJobText.ToString
                                                wojDet3.ItemDesc = ""
                                                wojDet3.LineNo = IIf(IsDBNull(dtWODetails.Rows(0)("WO_OWN_RISK_SL_NO")) = True, "0", dtWODetails.Rows(0)("WO_OWN_RISK_SL_NO"))
                                                wojDet3.IdWOItemseq = ""
                                                wojDet3.Job_Status = dtWODetails.Rows(0)("JOB_STATUS").ToString
                                                wojDet3.Diff = "OR"
                                                wojDet3.IdWODetailseq = dtWODetails.Rows(0)("ID_WODET_SEQ")
                                                wojDet3.IdWOLabSeq = ""
                                                wojDet3.Id_Deb_Seq = Convert.ToInt32(dtDebtDetails.Rows(1)("ID_DBT_SEQ").ToString)
                                                wojDet3.Jobi_Bo_Qty = ""
                                                wojDet3.Item_Avail_Qty = 0
                                                wojDet3.IdMech = ""
                                                wojDet3.Id_Make = ""
                                                wojDet3.Id_Warehouse = 0
                                                wojDet3.Sp_Cost_Price = "0"
                                                wojDet3.MechanicName = ""
                                                wojDet3.DebtType = dtDebtDetails.Rows(1)("CUST_TYPE").ToString
                                                wojDet3.Id_Job_Deb = IIf(IsDBNull(dtDebtDetails.Rows(1)("Id_Job_Deb")) = True, "", dtDebtDetails.Rows(1)("Id_Job_Deb"))
                                                wojDet3.WO_Own_Pay_Vat = IIf(IsDBNull(dtWODetails.Rows(0)("WO_Own_Pay_Vat")) = True, False, dtWODetails.Rows(0)("WO_Own_Pay_Vat"))
                                                wojDet3.SplitPercent = dtDebtDetails.Rows(1)("DBT_PER").ToString
                                                details.Add(wojDet3)
                                            End If

                                            'Reduction After Own Risk and Reduction Before Own Risk
                                            If dtDebtDetails.Rows.Count > 1 Then
                                                Dim redType As String = "NoRed" 'No Reduction by default
                                                Dim redDesc As String = ""
                                                If ((dtDebtDetails.Rows(1)("Reduction_Per").ToString > 0 Or dtDebtDetails.Rows(0)("Reduction_Amount").ToString > 0) And strJobNo = "1") Then
                                                    Dim wojDetRAOR As New WOJobDetailBO()
                                                    wojDetRAOR.IdJob = ""

                                                    If (dtDebtDetails.Rows(1)("Reduction_Before_OR").ToString = "False" And dtDebtDetails.Rows(1)("Reduction_After_OR").ToString = "False") Then
                                                        redType = "NoRed"
                                                        redDesc = ""
                                                    ElseIf (dtDebtDetails.Rows(1)("Reduction_Before_OR").ToString = "True" And dtDebtDetails.Rows(1)("Reduction_After_OR").ToString = "False") Then
                                                        redType = "RBOR"
                                                        redDesc = "Reduction Before Own Risk Charged"
                                                    ElseIf (dtDebtDetails.Rows(1)("Reduction_Before_OR").ToString = "False" And dtDebtDetails.Rows(1)("Reduction_After_OR").ToString = "True") Then
                                                        redType = "RAOR"
                                                        redDesc = "Reduction After Own Risk  Charged"
                                                    End If

                                                    wojDetRAOR.Text = redDesc  'IIf(IsDBNull(dtWODetails.Rows(0)("WO_OWN_RISK_DESC")) = True, "", dtWODetails.Rows(0)("WO_OWN_RISK_DESC")) 'dtWODetails.Rows(0)("WO_OWN_RISK_DESC").ToString
                                                    'wojDetRAOR.ReductionType = redType
                                                    wojDetRAOR.Diff = redType
                                                    If dtDebtDetails.Rows(1)("CUST_TYPE").ToString = "OHC" Then
                                                        wojDetRAOR.Nei = "0"
                                                    ElseIf dtDebtDetails.Rows(1)("CUST_TYPE").ToString = "INSC" Then
                                                        wojDetRAOR.Nei = "1"
                                                    ElseIf dtDebtDetails.Rows(1)("CUST_TYPE").ToString = "INTC" Then
                                                        wojDetRAOR.Nei = "2"
                                                    ElseIf dtDebtDetails.Rows(1)("CUST_TYPE").ToString = "CLA" Then
                                                        wojDetRAOR.Nei = "3"
                                                    ElseIf dtDebtDetails.Rows(1)("CUST_TYPE").ToString = "MISC" Then
                                                        wojDetRAOR.Nei = "4"
                                                    End If
                                                    wojDetRAOR.Ford = dtDebtDetails.Rows(1)("Reduction_Per").ToString
                                                    wojDetRAOR.Bestilt = ""
                                                    wojDetRAOR.Levert = ""
                                                    'wojDetRAOR.Pris = "" 'objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtWODetails.Rows(0)("WO_OWN_RISK_AMT")) = True, 0D, dtWODetails.Rows(0)("WO_OWN_RISK_AMT")))
                                                    wojDetRAOR.Rab = ""
                                                    Dim totlabamt As String = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtDebtDetails.Rows(1)("REDUCTION_AMOUNT")) = True, 0D, dtDebtDetails.Rows(1)("REDUCTION_AMOUNT")))
                                                    wojDetRAOR.Belop = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), totlabamt)


                                                    If dtDebtDetails.Rows(1)("CUST_TYPE").ToString = "OHC" Then
                                                        wojDetRAOR.Belop = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), totlabamt)
                                                    ElseIf dtDebtDetails.Rows(1)("CUST_TYPE").ToString = "INSC" Then
                                                        'Dim ownRiskAmt As Integer = (-1 * Convert.ToInt32(totlabamt))
                                                        wojDetRAOR.Belop = (-1 * Convert.ToDecimal(IIf(IsDBNull(dtDebtDetails.Rows(1)("REDUCTION_AMOUNT")) = True, 0, dtDebtDetails.Rows(1)("REDUCTION_AMOUNT"))))
                                                    ElseIf dtDebtDetails.Rows(1)("CUST_TYPE").ToString = "MISC" Then
                                                        wojDetRAOR.Belop = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), dtDebtDetails.Rows(1)("REDUCTION_AMOUNT").ToString)
                                                    End If

                                                    If (dtDebtDetails.Rows(0)("Reduction_Per").ToString > 0) Then
                                                        wojDetRAOR.Pris = ""
                                                    Else
                                                        wojDetRAOR.Pris = wojDetRAOR.Belop
                                                    End If
                                                    wojDetRAOR.JobId = jobNo '""
                                                    wojDetRAOR.Flag = "0"
                                                    wojDetRAOR.ForeignJob = foreignJobText.ToString
                                                    wojDetRAOR.ItemDesc = ""
                                                    wojDetRAOR.LineNo = raorLineNo + 1
                                                    wojDetRAOR.IdWOItemseq = ""
                                                    wojDetRAOR.Job_Status = dtWODetails.Rows(0)("JOB_STATUS").ToString
                                                    wojDetRAOR.IdWODetailseq = dtWODetails.Rows(0)("ID_WODET_SEQ")
                                                    wojDetRAOR.IdWOLabSeq = ""
                                                    wojDetRAOR.Id_Deb_Seq = Convert.ToInt32(dtDebtDetails.Rows(1)("ID_DBT_SEQ").ToString)
                                                    wojDetRAOR.Jobi_Bo_Qty = ""
                                                    wojDetRAOR.Item_Avail_Qty = 0
                                                    wojDetRAOR.IdMech = ""
                                                    wojDetRAOR.Id_Make = ""
                                                    wojDetRAOR.Id_Warehouse = 0
                                                    wojDetRAOR.Sp_Cost_Price = "0"
                                                    wojDetRAOR.MechanicName = ""
                                                    wojDetRAOR.DebtType = dtDebtDetails.Rows(1)("CUST_TYPE").ToString
                                                    wojDetRAOR.Id_Job_Deb = IIf(IsDBNull(dtDebtDetails.Rows(1)("Id_Job_Deb")) = True, "", dtDebtDetails.Rows(1)("Id_Job_Deb"))
                                                    wojDetRAOR.WO_Own_Pay_Vat = IIf(IsDBNull(dtWODetails.Rows(0)("WO_Own_Pay_Vat")) = True, False, dtWODetails.Rows(0)("WO_Own_Pay_Vat"))
                                                    details.Add(wojDetRAOR)
                                                End If
                                            End If

                                            Dim dt As New DataTable()
                                            ' dt.TableName = "localCustDetails"
                                            For Each [property] As PropertyInfo In details(0).[GetType]().GetProperties()
                                                dt.Columns.Add(New DataColumn([property].Name, [property].PropertyType))
                                            Next

                                            For Each det As WOJobDetailBO In details
                                                Dim newRow As DataRow = dt.NewRow()
                                                For Each [property] As PropertyInfo In det.[GetType]().GetProperties()
                                                    newRow([property].Name) = det.[GetType]().GetProperty([property].Name).GetValue(det, Nothing)
                                                Next
                                                dt.Rows.Add(newRow)
                                            Next

                                            dt.DefaultView.Sort = "LineNo ASC"

                                            dt = dt.DefaultView.ToTable()
                                            details = Nothing
                                            details = New List(Of WOJobDetailBO)()
                                            For Each dtrow As DataRow In dt.Rows
                                                Dim wojDet As New WOJobDetailBO()
                                                wojDet.IdJob = dtrow("IdJob")
                                                wojDet.Text = dtrow("Text")
                                                wojDet.Nei = dtrow("Nei")
                                                wojDet.Ford = dtrow("Ford")
                                                wojDet.Bestilt = dtrow("Bestilt")
                                                wojDet.Levert = dtrow("Levert")
                                                wojDet.Pris = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("Pris")) = True, 0D, dtrow("Pris")))
                                                wojDet.Rab = IIf(IsDBNull(dtrow("Rab")) = True, "0", dtrow("Rab"))
                                                'Dim totlabamt As String = IIf(IsDBNull(dtrow("WO_Tot_Lab_Amt").ToString()) = True, 0, dtrow("WO_Tot_Lab_Amt").ToString())
                                                wojDet.Belop = dtrow("Belop") '(wojDet.Pris * (IIf(IsDBNull(dtrow("Belop")) = True, 0, dtrow("Belop")))) - (wojDet.Pris * (IIf(IsDBNull(dtrow("JOBI_DELIVER_QTY")) = True, 0, dtrow("JOBI_DELIVER_QTY"))) * 0.01 * wojDet.Rab)
                                                wojDet.JobId = dtrow("JobId") '""
                                                wojDet.Flag = dtrow("Flag")
                                                wojDet.ForeignJob = dtrow("ForeignJob")
                                                wojDet.ItemDesc = dtrow("ItemDesc")
                                                wojDet.LineNo = IIf(IsDBNull(dtrow("LineNo").ToString()) = True, "", dtrow("LineNo").ToString())
                                                wojDet.Diff = IIf(IsDBNull(dtrow("Diff").ToString()) = True, 0, dtrow("Diff").ToString())
                                                wojDet.IdWODetailseq = dtrow("IdWODetailseq").ToString
                                                wojDet.IdWOItemseq = dtrow("IdWOItemseq").ToString
                                                wojDet.Job_Status = dtrow("Job_Status").ToString
                                                wojDet.IdWOLabSeq = dtrow("IdWOLabSeq").ToString
                                                wojDet.Id_Deb_Seq = Convert.ToInt32(dtrow("Id_Deb_Seq").ToString)
                                                wojDet.IdMech = dtrow("IdMech").ToString
                                                wojDet.Jobi_Bo_Qty = dtrow("Jobi_Bo_Qty").ToString
                                                wojDet.Id_Make = dtrow("Id_Make").ToString
                                                wojDet.Item_Avail_Qty = dtrow("Item_Avail_Qty").ToString
                                                wojDet.Id_Warehouse = IIf(IsDBNull(dtrow("Id_Warehouse")) = True, "0", Convert.ToInt32(dtrow("Id_Warehouse").ToString))
                                                wojDet.Sp_Cost_Price = IIf(IsDBNull(dtrow("Sp_Cost_Price").ToString()) = True, "0", dtrow("Sp_Cost_Price").ToString())
                                                wojDet.MechanicName = IIf(IsDBNull(dtrow("MechanicName").ToString()) = True, "0", dtrow("MechanicName").ToString())
                                                wojDet.DebtType = dtrow("DebtType").ToString
                                                wojDet.Id_Job_Deb = dtrow("Id_Job_Deb").ToString
                                                wojDet.WO_Own_Pay_Vat = IIf(IsDBNull(dtrow("WO_Own_Pay_Vat")) = True, False, dtrow("WO_Own_Pay_Vat"))
                                                wojDet.SplitPercent = dtrow("SplitPercent").ToString
                                                wojDet.DebitorDiscount = dtrow("DebitorDiscount").ToString
                                                wojDet.CustGenDiscount = dtrow("CustGenDiscount").ToString
                                                wojDet.CustLabDiscount = dtrow("CustLabDiscount").ToString
                                                wojDet.CustSpareDiscount = dtrow("CustSpareDiscount").ToString
                                                wojDet.SpareDiscount = IIf(IsDBNull(dtrow("SpareDiscount")) = True, 0, dtrow("SpareDiscount"))
                                                wojDet.DebtVatPercentage = dtrow("DebtVatPercentage")
                                                details.Add(wojDet)
                                            Next

                                            Dim wojdet2 As New WOJobDetailBO()
                                            wojdet2.IdJob = ""
                                            wojdet2.Text = ""
                                            wojdet2.Nei = ""
                                            wojdet2.Ford = dtDebtDetails.Rows(1)("DBT_PER").ToString
                                            wojdet2.Bestilt = ""
                                            wojdet2.Levert = ""
                                            wojdet2.Pris = ""
                                            wojdet2.Rab = ""
                                            wojdet2.Belop = ""
                                            wojdet2.JobId = jobNo
                                            wojdet2.Flag = "0"
                                            wojdet2.ForeignJob = foreignJobText.ToString
                                            wojdet2.ItemDesc = ""
                                            wojdet2.Job_Status = dtWODetails.Rows(0)("JOB_STATUS").ToString
                                            wojdet2.IdWODetailseq = dtWODetails.Rows(0)("ID_WODET_SEQ").ToString
                                            wojdet2.IdWOItemseq = ""
                                            wojdet2.IdWOLabSeq = ""
                                            wojdet2.Id_Deb_Seq = Convert.ToInt32(dtDebtDetails.Rows(1)("ID_DBT_SEQ").ToString)
                                            wojdet2.Jobi_Bo_Qty = "0"
                                            wojdet2.Id_Make = ""
                                            wojdet2.Id_Warehouse = 1
                                            wojdet2.Sp_Cost_Price = "0"
                                            wojdet2.MechanicName = ""
                                            wojdet2.DebtType = dtDebtDetails.Rows(1)("CUST_TYPE").ToString
                                            wojdet2.Id_Job_Deb = IIf(IsDBNull(dtDebtDetails.Rows(1)("Id_Job_Deb")) = True, "", dtDebtDetails.Rows(1)("Id_Job_Deb"))
                                            wojdet2.WO_Own_Pay_Vat = IIf(IsDBNull(dtWODetails.Rows(0)("WO_Own_Pay_Vat")) = True, False, dtWODetails.Rows(0)("WO_Own_Pay_Vat"))
                                            wojdet2.SplitPercent = dtDebtDetails.Rows(1)("DBT_PER").ToString
                                            wojdet2.SpareDiscount = 0
                                            wojdet2.DebtVatPercentage = 0
                                            details.Add(wojdet2)
                                        Else
                                            strJobNo = objWOJDO.Fetch_Job_No(objWOJBO) 'Use it later to fetch job no
                                            'strJobNo = "1"
                                            Dim wojDet As New WOJobDetailBO()
                                            wojDet.IdJob = "Job:" + strJobNo
                                            wojDet.Text = ""
                                            wojDet.Nei = "0"
                                            wojDet.Ford = "100"
                                            wojDet.Bestilt = ""
                                            wojDet.Levert = ""
                                            wojDet.Pris = ""
                                            wojDet.Rab = ""
                                            wojDet.Belop = ""
                                            wojDet.JobId = strJobNo '""
                                            wojDet.Flag = "1"
                                            wojDet.ForeignJob = ""
                                            wojDet.ItemDesc = ""
                                            wojDet.IdWODetailseq = ""
                                            wojDet.IdWOItemseq = ""
                                            wojDet.IdWOLabSeq = ""
                                            wojDet.Id_Deb_Seq = 0
                                            wojDet.Jobi_Bo_Qty = "0"
                                            wojDet.Id_Make = ""
                                            wojDet.Id_Warehouse = 1
                                            wojDet.Sp_Cost_Price = "0"
                                            wojDet.MechanicName = ""
                                            wojDet.DebtType = dtDebtDetails.Rows(1)("CUST_TYPE").ToString
                                            wojDet.Id_Job_Deb = ""
                                            wojDet.WO_Own_Pay_Vat = False
                                            wojDet.SplitPercent = "0"
                                            wojDet.SpareDiscount = 0
                                            wojDet.DebtVatPercentage = 0
                                            details.Add(wojDet)


                                            Dim wojdet1 As New WOJobDetailBO()
                                            wojdet1.IdJob = ""
                                            wojdet1.Text = ""
                                            wojdet1.Nei = ""
                                            wojdet1.Ford = dtDebtDetails.Rows(1)("DBT_PER").ToString
                                            wojdet1.Bestilt = ""
                                            wojdet1.Levert = ""
                                            wojdet1.Pris = ""
                                            wojdet1.Rab = ""
                                            wojdet1.Belop = ""
                                            wojdet1.JobId = strJobNo
                                            wojdet1.Flag = "0"
                                            wojdet1.ForeignJob = ""
                                            wojdet1.ItemDesc = ""
                                            wojdet1.IdWODetailseq = ""
                                            wojdet1.IdWOItemseq = ""
                                            wojdet1.IdWOLabSeq = ""
                                            wojdet1.Id_Deb_Seq = 0
                                            wojdet1.Jobi_Bo_Qty = "0"
                                            wojdet1.Id_Make = ""
                                            wojdet1.Id_Warehouse = 1
                                            wojdet1.Sp_Cost_Price = "0"
                                            wojdet1.MechanicName = ""
                                            wojdet1.DebtType = dtDebtDetails.Rows(1)("CUST_TYPE").ToString
                                            wojdet1.Id_Job_Deb = ""
                                            wojdet1.WO_Own_Pay_Vat = False
                                            wojdet1.SplitPercent = "0"
                                            wojdet1.SpareDiscount = 0
                                            wojdet1.DebtVatPercentage = 0
                                            details.Add(wojdet1)
                                        End If
                                    End If
                                End If
                                jobdetails2Deb.AddRange(details)
                            Next 'End of No of Jobs
                        Else

                            Dim details As New List(Of WOJobDetailBO)()
                            strJobNo = objWOJDO.Fetch_Job_No(objWOJBO) 'Use it later to fetch job no
                            'strJobNo = "1"
                            Dim wojDet As New WOJobDetailBO()
                            wojDet.IdJob = "Job:" + strJobNo
                            wojDet.Text = ""
                            wojDet.Nei = "0"
                            wojDet.Ford = "100"
                            wojDet.Bestilt = ""
                            wojDet.Levert = ""
                            wojDet.Pris = ""
                            wojDet.Rab = ""
                            wojDet.Belop = ""
                            wojDet.JobId = strJobNo '""
                            wojDet.Flag = "1"
                            wojDet.ForeignJob = ""
                            wojDet.ItemDesc = ""
                            wojDet.IdWODetailseq = ""
                            wojDet.IdWOItemseq = ""
                            wojDet.IdWOLabSeq = ""
                            wojDet.Id_Deb_Seq = 0
                            wojDet.Jobi_Bo_Qty = "0"
                            wojDet.Id_Make = ""
                            wojDet.Id_Warehouse = 1
                            wojDet.Sp_Cost_Price = "0"
                            wojDet.MechanicName = ""
                            wojDet.DebtType = dtDebtDetails.Rows(1)("CUST_TYPE").ToString
                            wojDet.Id_Job_Deb = ""
                            wojDet.WO_Own_Pay_Vat = False
                            wojDet.SplitPercent = "0"
                            wojDet.SpareDiscount = 0
                            wojDet.DebtVatPercentage = 0
                            details.Add(wojDet)


                            Dim wojdet1 As New WOJobDetailBO()
                            wojdet1.IdJob = ""
                            wojdet1.Text = ""
                            wojdet1.Nei = ""
                            wojdet1.Ford = dtDebtDetails.Rows(1)("DBT_PER").ToString
                            wojdet1.Bestilt = ""
                            wojdet1.Levert = ""
                            wojdet1.Pris = ""
                            wojdet1.Rab = ""
                            wojdet1.Belop = ""
                            wojdet1.JobId = strJobNo
                            wojdet1.Flag = "0"
                            wojdet1.ForeignJob = ""
                            wojdet1.ItemDesc = ""
                            wojdet1.IdWODetailseq = ""
                            wojdet1.IdWOItemseq = ""
                            wojdet1.IdWOLabSeq = ""
                            wojdet1.Id_Deb_Seq = 0
                            wojdet1.Jobi_Bo_Qty = "0"
                            wojdet1.Id_Make = ""
                            wojdet1.Id_Warehouse = 1
                            wojdet1.Sp_Cost_Price = "0"
                            wojdet1.MechanicName = ""
                            wojdet1.DebtType = dtDebtDetails.Rows(1)("CUST_TYPE").ToString
                            wojdet1.Id_Job_Deb = ""
                            wojdet1.WO_Own_Pay_Vat = False
                            wojdet1.SplitPercent = "0"
                            wojdet1.SpareDiscount = 0
                            wojdet1.DebtVatPercentage = 0
                            details.Add(wojdet1)

                            jobdetails2Deb.AddRange(details)
                        End If

                    End If

                    jobdetails.AddRange(jobdetails2Deb)
                    'End If

                End If

                'third debitor
                If dsWODetails.Tables.Count > 0 Then
                    'If dsWODetails.Tables(2).Rows.Count > 2 Then
                    If (dsWOJobs.Tables.Count > 0) Then
                        dtWOJobs = dsWOJobs.Tables(3)

                        If (dtWOJobs.Rows.Count > 0) Then
                            For Each dtwojobsrow As DataRow In dtWOJobs.Rows
                                Dim details As New List(Of WOJobDetailBO)()
                                strJobNo = dtwojobsrow("Id_Job").ToString()
                                objWOJBO.Id_Job = strJobNo

                                dsWODetails = objWOJDO.Load_WorkOrderDetails(objWOJBO)
                                If dsWODetails.Tables(2).Rows.Count > 2 Then
                                    dtDebtDetails = dsWODetails.Tables(2)
                                    If dtDebtDetails.Rows(2)("DEB_STATUS").ToString <> "DEL" Then
                                        If dsWODetails.Tables.Count > 0 Then
                                            Dim jobNo As String
                                            Dim foreignJobNo As Integer
                                            Dim foreignJobText As String = ""

                                            If dsWODetails.Tables(0).Rows.Count > 0 Then
                                                dtWODetails = dsWODetails.Tables(0)
                                                dtDebtDetails = dsWODetails.Tables(2)
                                                Dim wojDet As New WOJobDetailBO()
                                                jobNo = dtWODetails.Rows(0)("Id_Job").ToString
                                                foreignJobNo = Convert.ToInt32(jobNo)
                                                foreignJobText = ""
                                                If (foreignJobNo >= 90 And foreignJobNo <= 99) Then
                                                    foreignJobText = "FJ"
                                                Else
                                                    foreignJobText = ""
                                                End If
                                                wojDet.IdJob = "Job:" + dtWODetails.Rows(0)("Id_Job").ToString
                                                Dim lastMechanicSaved As String = ""
                                                Dim mecName As String = ""
                                                Dim UserName As String = ""
                                                If (dsWODetails.Tables(6).Rows.Count > 0) Then
                                                    dtLabDetails = dsWODetails.Tables(6)
                                                    If (dtLabDetails.Rows.Count > 0) Then
                                                        For Each dtrow As DataRow In dtLabDetails.Rows
                                                            Dim mechanic As String = ""
                                                            'Dim mechNm() As String
                                                            mechanic = IIf(IsDBNull(dtrow("Id_Login")) = True, "", dtrow("Id_Login"))
                                                            mecName = IIf(dtrow("Id_Login") = HttpContext.Current.Session("DUser"), "", dtrow("MECHANICNAME"))
                                                            'Dim b As Boolean = mecName.Contains("-")
                                                            'If (b = True) Then
                                                            '    mechNm = mecName.Split("-")
                                                            '    UserName = mechNm(0) + "-" + mechNm(1)
                                                            'Else
                                                            '    UserName = ""
                                                            'End If
                                                        Next
                                                    End If
                                                End If
                                                lastMechanicSaved = IIf(IsDBNull(dtWODetails.Rows(0)("Id_Mechanic")) = True, "", dtWODetails.Rows(0)("Id_Mechanic"))
                                                Dim lastMechNm() As String
                                                Dim b As Boolean = lastMechanicSaved.Contains("-")
                                                If (b = True) Then
                                                    lastMechNm = lastMechanicSaved.Split("-")
                                                    lastMechanicSaved = lastMechNm(0) + "-" + lastMechNm(1)
                                                    If (lastMechNm.Count > 2) Then
                                                        wojDet.IdMech = lastMechNm(2)
                                                    Else
                                                        wojDet.IdMech = ""
                                                        mecName = ""
                                                    End If
                                                Else
                                                    lastMechanicSaved = ""
                                                    wojDet.IdMech = ""
                                                    mecName = ""
                                                End If
                                                wojDet.Text = lastMechanicSaved 'UserName
                                                If dtDebtDetails.Rows(2)("CUST_TYPE").ToString = "OHC" Then
                                                    wojDet.Nei = "0"
                                                ElseIf dtDebtDetails.Rows(2)("CUST_TYPE").ToString = "INSC" Then
                                                    wojDet.Nei = "1"
                                                ElseIf dtDebtDetails.Rows(2)("CUST_TYPE").ToString = "INTC" Then
                                                    wojDet.Nei = "2"
                                                ElseIf dtDebtDetails.Rows(2)("CUST_TYPE").ToString = "CLA" Then
                                                    wojDet.Nei = "3"
                                                ElseIf dtDebtDetails.Rows(2)("CUST_TYPE").ToString = "MISC" Then
                                                    wojDet.Nei = "4"
                                                End If
                                                wojDet.Ford = dtDebtDetails.Rows(2)("DBT_PER").ToString
                                                wojDet.Bestilt = ""
                                                wojDet.Levert = ""
                                                wojDet.Pris = ""
                                                Dim rebate As Integer = 0
                                                If dsWODetails.Tables(7).Rows(2)("CUST_DISC_GENERAL").ToString() <> "0" Then
                                                    rebate = dsWODetails.Tables(7).Rows(2)("CUST_DISC_GENERAL")
                                                    wojDet.Rab = rebate.ToString()
                                                Else
                                                    wojDet.Rab = ""
                                                End If
                                                wojDet.Belop = ""
                                                wojDet.JobId = jobNo '""
                                                wojDet.Flag = "1"
                                                wojDet.ForeignJob = foreignJobText.ToString
                                                wojDet.ItemDesc = ""
                                                wojDet.LineNo = 0
                                                wojDet.Diff = ""
                                                wojDet.IdWODetailseq = dtWODetails.Rows(0)("ID_WODET_SEQ").ToString
                                                wojDet.IdWOItemseq = ""
                                                wojDet.Job_Status = dtWODetails.Rows(0)("JOB_STATUS").ToString
                                                wojDet.IdWOLabSeq = ""
                                                If (dtDebtDetails.Rows.Count > 1) Then
                                                    wojDet.Id_Deb_Seq = Convert.ToInt32(dtDebtDetails.Rows(2)("ID_DBT_SEQ").ToString) 'Convert.ToInt32(dtDebtDetails.Rows(0)("ID_DBT_SEQ").ToString)
                                                Else
                                                    wojDet.Id_Deb_Seq = 0
                                                End If

                                                wojDet.Jobi_Bo_Qty = "0"
                                                wojDet.Id_Warehouse = 1
                                                wojDet.Id_Make = ""
                                                wojDet.Sp_Cost_Price = "0"
                                                wojDet.MechanicName = IIf((lastMechanicSaved + wojDet.IdMech) = "", mecName, (lastMechanicSaved + "-" + wojDet.IdMech))
                                                wojDet.DebtType = dtDebtDetails.Rows(2)("CUST_TYPE").ToString
                                                wojDet.Id_Job_Deb = IIf(IsDBNull(dtDebtDetails.Rows(2)("Id_Job_Deb")) = True, "", dtDebtDetails.Rows(2)("Id_Job_Deb"))
                                                wojDet.WO_Own_Pay_Vat = IIf(IsDBNull(dtWODetails.Rows(0)("WO_Own_Pay_Vat")) = True, False, dtWODetails.Rows(0)("WO_Own_Pay_Vat"))
                                                wojDet.SplitPercent = dtDebtDetails.Rows(2)("DBT_PER").ToString
                                                wojDet.DebtVatPercentage = IIf(IsDBNull(dtDebtDetails.Rows(2)("DEBTOR_VAT_PERCENTAGE")) = True, False, dtDebtDetails.Rows(2)("DEBTOR_VAT_PERCENTAGE"))
                                                details.Add(wojDet)

                                                dtLabDetails = dsWODetails.Tables(6)
                                                'dtLogin = dsWODetails.Tables(7)

                                                For Each dtrow As DataRow In dtLabDetails.Rows
                                                    Dim wojDet1 As New WOJobDetailBO()
                                                    Dim validuser As String = ""
                                                    validuser = IIf(IsDBNull(dtrow("Id_Login")) = True, "", dtrow("Id_Login"))
                                                    Dim mechNm() As String
                                                    mechNm = dtrow("MECHANICNAME").ToString.Split("-")
                                                    UserName = mechNm(0) + "-" + mechNm(1)
                                                    wojDet1.IdJob = IIf(validuser = HttpContext.Current.Session("DUser"), "", UserName)
                                                    wojDet1.Text = dtrow("WO_Labour_desc")
                                                    If dtDebtDetails.Rows(2)("CUST_TYPE").ToString = "OHC" Then
                                                        wojDet1.Nei = "0"
                                                    ElseIf dtDebtDetails.Rows(2)("CUST_TYPE").ToString = "INSC" Then
                                                        wojDet1.Nei = "1"
                                                    ElseIf dtDebtDetails.Rows(2)("CUST_TYPE").ToString = "INTC" Then
                                                        wojDet1.Nei = "2"
                                                    ElseIf dtDebtDetails.Rows(2)("CUST_TYPE").ToString = "CLA" Then
                                                        wojDet1.Nei = "3"
                                                    ElseIf dtDebtDetails.Rows(2)("CUST_TYPE").ToString = "MISC" Then
                                                        wojDet1.Nei = "4"
                                                    End If
                                                    wojDet1.Ford = dtDebtDetails.Rows(2)("DBT_PER").ToString
                                                    wojDet1.Bestilt = ""
                                                    wojDet1.Levert = dtrow("WO_Labour_Hours")
                                                    wojDet1.Pris = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("WO_Hourley_Price")) = True, 0D, dtrow("WO_Hourley_Price")))
                                                    Dim totlabamt As String = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("WO_Labour_Hours")) = True, 0D, dtrow("WO_Labour_Hours"))) * objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("WO_Hourley_Price")) = True, 0D, dtrow("WO_Hourley_Price"))) * (objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtDebtDetails.Rows(2)("DBT_PER")) = True, 0D, dtDebtDetails.Rows(2)("DBT_PER"))) / 100) 'IIf(IsDBNull(dtrow("WO_Tot_Lab_Amt").ToString()) = True, 0, dtrow("WO_Tot_Lab_Amt").ToString())
                                                    wojDet1.Belop = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), totlabamt)
                                                    wojDet1.JobId = jobNo '""
                                                    wojDet1.Flag = "0"
                                                    wojDet1.ForeignJob = foreignJobText.ToString
                                                    wojDet1.ItemDesc = ""
                                                    wojDet1.Diff = "L"
                                                    wojDet1.LineNo = Convert.ToInt32(dtrow("Sl_No").ToString)
                                                    wojDet1.IdWODetailseq = dtrow("ID_WODET_SEQ").ToString
                                                    wojDet1.IdWOItemseq = ""
                                                    wojDet1.Job_Status = dtWODetails.Rows(0)("JOB_STATUS").ToString
                                                    wojDet1.IdWOLabSeq = dtrow("ID_WOLAB_SEQ").ToString
                                                    wojDet1.Id_Deb_Seq = Convert.ToInt32(dtDebtDetails.Rows(2)("ID_DBT_SEQ").ToString)
                                                    wojDet1.IdMech = dtrow("ID_LOGIN").ToString
                                                    wojDet1.Jobi_Bo_Qty = "0"
                                                    wojDet1.Id_Warehouse = 1
                                                    wojDet1.Id_Make = ""
                                                    wojDet1.Sp_Cost_Price = "0"
                                                    'Debitor Discount
                                                    'wojDet1.Rab = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("WO_Lab_Discount")) = True, 0D, dtrow("WO_Lab_Discount")))
                                                    wojDet1.Rab = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtDebtDetails.Rows(2)("DISCOUNT PERCENTAGE")) = True, 0D, dtDebtDetails.Rows(2)("DISCOUNT PERCENTAGE")))

                                                    Dim mechName As String = ""
                                                    mechName = IIf(IsDBNull(dtrow("MECHANICNAME")) = True, "", dtrow("MECHANICNAME"))
                                                    mechName = IIf(dtrow("Id_Login") = HttpContext.Current.Session("DUser"), "", dtrow("MECHANICNAME"))
                                                    wojDet1.MechanicName = mechName 'dtLogin.Rows(0)("MECHANICNAME").ToString
                                                    wojDet1.DebtType = dtDebtDetails.Rows(2)("CUST_TYPE").ToString
                                                    wojDet1.Id_Job_Deb = IIf(IsDBNull(dtDebtDetails.Rows(2)("Id_Job_Deb")) = True, "", dtDebtDetails.Rows(2)("Id_Job_Deb"))
                                                    wojDet1.WO_Own_Pay_Vat = IIf(IsDBNull(dtWODetails.Rows(0)("WO_Own_Pay_Vat")) = True, False, dtWODetails.Rows(0)("WO_Own_Pay_Vat"))
                                                    wojDet1.SplitPercent = dtDebtDetails.Rows(2)("DBT_PER").ToString

                                                    Dim rebates As Integer = 0
                                                    Dim debitorDisc As Decimal = IIf(IsDBNull(dtDebtDetails.Rows(2)("DISCOUNT PERCENTAGE")) = True, 0D, dtDebtDetails.Rows(2)("DISCOUNT PERCENTAGE"))
                                                    If (debitorDisc > 0) Then
                                                        rebates = IIf(IsDBNull(dtDebtDetails.Rows(2)("DISCOUNT PERCENTAGE")) = True, 0, dtDebtDetails.Rows(2)("DISCOUNT PERCENTAGE"))
                                                    ElseIf ((IIf(IsDBNull(dtDebtDetails.Rows(2)("CUST_LABOUR_DISC")) = True, 0, dtDebtDetails.Rows(2)("CUST_LABOUR_DISC"))) > 0) Then
                                                        rebates = IIf(IsDBNull(dtDebtDetails.Rows(2)("CUST_LABOUR_DISC")) = True, "0", dtDebtDetails.Rows(2)("CUST_LABOUR_DISC"))
                                                    ElseIf ((IIf(IsDBNull(dtDebtDetails.Rows(2)("CUST_GENERAL_DISC")) = True, 0, dtDebtDetails.Rows(2)("CUST_GENERAL_DISC"))) > 0) Then
                                                        rebates = IIf(IsDBNull(dtDebtDetails.Rows(2)("CUST_GENERAL_DISC")) = True, "0", dtDebtDetails.Rows(2)("CUST_GENERAL_DISC"))
                                                    Else
                                                        rebates = 0
                                                    End If
                                                    wojDet1.DebitorDiscount = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtDebtDetails.Rows(2)("DISCOUNT PERCENTAGE")) = True, "0", dtDebtDetails.Rows(2)("DISCOUNT PERCENTAGE")))
                                                    wojDet1.CustGenDiscount = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtDebtDetails.Rows(2)("CUST_GENERAL_DISC")) = True, "0", dtDebtDetails.Rows(2)("CUST_GENERAL_DISC")))
                                                    wojDet1.CustLabDiscount = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtDebtDetails.Rows(2)("CUST_LABOUR_DISC")) = True, "0", dtDebtDetails.Rows(2)("CUST_LABOUR_DISC")))
                                                    wojDet1.CustSpareDiscount = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtDebtDetails.Rows(2)("CUST_SPARE_DISC")) = True, "0", dtDebtDetails.Rows(2)("CUST_SPARE_DISC")))
                                                    wojDet1.SpareDiscount = 0
                                                    wojDet1.Rab = rebates.ToString

                                                    details.Add(wojDet1)
                                                Next
                                            End If
                                            If dsWODetails.Tables(1).Rows.Count > 0 Then
                                                dtWOJDetails = dsWODetails.Tables(1)
                                                For Each dtrow As DataRow In dtWOJDetails.Rows
                                                    Dim wojDet As New WOJobDetailBO()
                                                    wojDet.IdJob = IIf(IsDBNull(dtrow("Id_Item_Job")) = True, "", dtrow("Id_Item_Job"))
                                                    wojDet.Text = dtrow("Item_Desc")
                                                    If dtDebtDetails.Rows(2)("CUST_TYPE").ToString = "OHC" Then
                                                        wojDet.Nei = "0"
                                                    ElseIf dtDebtDetails.Rows(2)("CUST_TYPE").ToString = "INSC" Then
                                                        wojDet.Nei = "1"
                                                    ElseIf dtDebtDetails.Rows(2)("CUST_TYPE").ToString = "INTC" Then
                                                        wojDet.Nei = "2"
                                                    ElseIf dtDebtDetails.Rows(2)("CUST_TYPE").ToString = "CLA" Then
                                                        wojDet.Nei = "3"
                                                    ElseIf dtDebtDetails.Rows(2)("CUST_TYPE").ToString = "MISC" Then
                                                        wojDet.Nei = "4"
                                                    End If
                                                    wojDet.Ford = dtDebtDetails.Rows(2)("DBT_PER").ToString
                                                    wojDet.Bestilt = dtrow("JOBI_ORDER_QTY")
                                                    wojDet.Levert = dtrow("JOBI_DELIVER_QTY")
                                                    wojDet.Pris = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("JOBI_SELL_PRICE")) = True, 0D, dtrow("JOBI_SELL_PRICE")))
                                                    'Debitor Discount
                                                    'wojDet.Rab = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("JOBI_DIS_PER")) = True, 0D, dtrow("JOBI_DIS_PER")))
                                                    wojDet.Rab = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtDebtDetails.Rows(2)("DISCOUNT PERCENTAGE")) = True, 0D, dtDebtDetails.Rows(2)("DISCOUNT PERCENTAGE")))

                                                    'Dim totlabamt As String = IIf(IsDBNull(dtrow("WO_Tot_Lab_Amt").ToString()) = True, 0, dtrow("WO_Tot_Lab_Amt").ToString())
                                                    'wojDet.Belop = (wojDet.Pris * (IIf(IsDBNull(dtrow("JOBI_DELIVER_QTY")) = True, 0, dtrow("JOBI_DELIVER_QTY")))) - (wojDet.Pris * (IIf(IsDBNull(dtrow("JOBI_DELIVER_QTY")) = True, 0, dtrow("JOBI_DELIVER_QTY"))) * 0.01 * wojDet.Rab)
                                                    wojDet.Belop = (wojDet.Pris * (IIf(IsDBNull(dtrow("JOBI_DELIVER_QTY")) = True, 0, dtrow("JOBI_DELIVER_QTY")))) * (objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtDebtDetails.Rows(1)("DBT_PER")) = True, 0D, dtDebtDetails.Rows(1)("DBT_PER"))) / 100)
                                                    wojDet.JobId = jobNo '""
                                                    wojDet.Flag = "0"
                                                    wojDet.ForeignJob = foreignJobText.ToString
                                                    wojDet.ItemDesc = dtrow("Item_Desc")
                                                    wojDet.LineNo = Convert.ToInt32(dtrow("Sl_No").ToString)
                                                    wojDet.IdWOItemseq = dtrow("ID_WOITEM_SEQ").ToString
                                                    wojDet.Job_Status = dtWODetails.Rows(0)("JOB_STATUS").ToString
                                                    If (dtrow("TEXT") <> "") Then
                                                        wojDet.Diff = "T" 'Text line need to check
                                                        wojDet.Text = IIf(IsDBNull(dtrow("Text")) = True, "", dtrow("Text"))
                                                        wojDet.Bestilt = ""
                                                        wojDet.Levert = ""
                                                        wojDet.Pris = ""
                                                        wojDet.Rab = ""
                                                    Else
                                                        wojDet.Diff = "S"
                                                    End If

                                                    wojDet.IdWODetailseq = dtrow("ID_WODET_SEQ_JOB").ToString
                                                    wojDet.IdWOLabSeq = ""
                                                    wojDet.Id_Deb_Seq = Convert.ToInt32(dtDebtDetails.Rows(2)("ID_DBT_SEQ").ToString)
                                                    wojDet.Jobi_Bo_Qty = dtrow("JOBI_BO_QTY").ToString
                                                    wojDet.Item_Avail_Qty = IIf(IsDBNull(dtrow("Item_Avail_Qty")) = True, "0", dtrow("Item_Avail_Qty"))
                                                    wojDet.IdMech = ""
                                                    wojDet.Id_Make = IIf(IsDBNull(dtrow("Id_Make")) = True, "", dtrow("Id_Make"))
                                                    wojDet.Id_Warehouse = IIf(IsDBNull(dtrow("Id_Warehouse")) = True, "0", Convert.ToInt32(dtrow("Id_Warehouse").ToString))
                                                    wojDet.Sp_Cost_Price = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("JOBI_COST_PRICE")) = True, 0D, dtrow("JOBI_COST_PRICE")))
                                                    wojDet.MechanicName = ""
                                                    wojDet.DebtType = dtDebtDetails.Rows(2)("CUST_TYPE").ToString
                                                    wojDet.Id_Job_Deb = IIf(IsDBNull(dtDebtDetails.Rows(2)("Id_Job_Deb")) = True, "", dtDebtDetails.Rows(2)("Id_Job_Deb"))
                                                    wojDet.WO_Own_Pay_Vat = IIf(IsDBNull(dtWODetails.Rows(0)("WO_Own_Pay_Vat")) = True, False, dtWODetails.Rows(0)("WO_Own_Pay_Vat"))
                                                    wojDet.SplitPercent = dtDebtDetails.Rows(2)("DBT_PER").ToString

                                                    Dim rebate As Integer = 0
                                                    Dim debitorDisc As Decimal = IIf(IsDBNull(dtDebtDetails.Rows(2)("DISCOUNT PERCENTAGE")) = True, 0D, dtDebtDetails.Rows(2)("DISCOUNT PERCENTAGE"))
                                                    If (debitorDisc > 0) Then
                                                        rebate = IIf(IsDBNull(dtDebtDetails.Rows(2)("DISCOUNT PERCENTAGE")) = True, 0D, dtDebtDetails.Rows(2)("DISCOUNT PERCENTAGE"))
                                                    ElseIf ((IIf(IsDBNull(dtDebtDetails.Rows(2)("CUST_SPARE_DISC")) = True, 0D, dtDebtDetails.Rows(2)("CUST_SPARE_DISC"))) > 0) Then
                                                        rebate = IIf(IsDBNull(dtDebtDetails.Rows(2)("CUST_SPARE_DISC")) = True, 0D, dtDebtDetails.Rows(2)("CUST_SPARE_DISC"))
                                                    ElseIf ((IIf(IsDBNull(dtDebtDetails.Rows(2)("CUST_GENERAL_DISC")) = True, 0D, dtDebtDetails.Rows(2)("CUST_GENERAL_DISC"))) > 0) Then
                                                        rebate = IIf(IsDBNull(dtDebtDetails.Rows(2)("CUST_GENERAL_DISC")) = True, 0D, dtDebtDetails.Rows(2)("CUST_GENERAL_DISC"))
                                                    ElseIf (dtrow("SPARE_DISCOUNT") > 0) Then
                                                        rebate = dtrow("SPARE_DISCOUNT")
                                                    Else
                                                        rebate = 0
                                                    End If

                                                    wojDet.Rab = rebate.ToString
                                                    wojDet.DebitorDiscount = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtDebtDetails.Rows(2)("DISCOUNT PERCENTAGE")) = True, "0", dtDebtDetails.Rows(2)("DISCOUNT PERCENTAGE")))
                                                    wojDet.CustGenDiscount = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtDebtDetails.Rows(2)("CUST_GENERAL_DISC")) = True, "0", dtDebtDetails.Rows(2)("CUST_GENERAL_DISC")))
                                                    wojDet.CustLabDiscount = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtDebtDetails.Rows(2)("CUST_LABOUR_DISC")) = True, "0", dtDebtDetails.Rows(2)("CUST_LABOUR_DISC")))
                                                    wojDet.CustSpareDiscount = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtDebtDetails.Rows(2)("CUST_SPARE_DISC")) = True, "0", dtDebtDetails.Rows(2)("CUST_SPARE_DISC")))
                                                    wojDet.SpareDiscount = IIf(IsDBNull(dtrow("Spare_Discount")) = True, "", dtrow("Spare_Discount"))
                                                    details.Add(wojDet)
                                                Next
                                            End If

                                            'Own Risk Amt
                                            If dtWODetails.Rows(0)("WO_OWN_RISK_AMT").ToString > 0 And strJobNo = "1" Then
                                                Dim wojDet3 As New WOJobDetailBO()
                                                wojDet3.IdJob = ""
                                                wojDet3.Text = "Own Risk Charged" 'IIf(IsDBNull(dtWODetails.Rows(0)("WO_OWN_RISK_DESC")) = True, "", dtWODetails.Rows(0)("WO_OWN_RISK_DESC")) 'dtWODetails.Rows(0)("WO_OWN_RISK_DESC").ToString

                                                If dtDebtDetails.Rows(2)("CUST_TYPE").ToString = "OHC" Then
                                                    wojDet3.Nei = "0"
                                                ElseIf dtDebtDetails.Rows(2)("CUST_TYPE").ToString = "INSC" Then
                                                    wojDet3.Nei = "1"
                                                ElseIf dtDebtDetails.Rows(2)("CUST_TYPE").ToString = "INTC" Then
                                                    wojDet3.Nei = "2"
                                                ElseIf dtDebtDetails.Rows(2)("CUST_TYPE").ToString = "CLA" Then
                                                    wojDet3.Nei = "3"
                                                ElseIf dtDebtDetails.Rows(2)("CUST_TYPE").ToString = "MISC" Then
                                                    wojDet3.Nei = "4"
                                                End If
                                                wojDet3.Ford = dtDebtDetails.Rows(2)("DBT_PER").ToString
                                                wojDet3.Bestilt = ""
                                                wojDet3.Levert = ""
                                                wojDet3.Pris = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtWODetails.Rows(0)("WO_OWN_RISK_AMT")) = True, 0D, dtWODetails.Rows(0)("WO_OWN_RISK_AMT")))
                                                wojDet3.Rab = ""
                                                Dim totlabamt As String = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtWODetails.Rows(0)("WO_OWN_RISK_AMT")) = True, 0D, dtWODetails.Rows(0)("WO_OWN_RISK_AMT")))
                                                wojDet3.Belop = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), totlabamt)
                                                If dtDebtDetails.Rows(2)("CUST_TYPE").ToString = "OHC" Then
                                                    wojDet3.Belop = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), totlabamt)
                                                ElseIf dtDebtDetails.Rows(2)("CUST_TYPE").ToString = "INSC" Then
                                                    wojDet3.Belop = "0"
                                                ElseIf dtDebtDetails.Rows(2)("CUST_TYPE").ToString = "MISC" Then
                                                    'wojDet3.Belop = dtWODetails.Rows(0)("WO_OWN_RISK_AMT").ToString()
                                                    If (IIf(IsDBNull(dtDebtDetails.Rows(2)("OWN RISK AMOUNT")), 0, dtDebtDetails.Rows(2)("OWN RISK AMOUNT")) > 0) Then
                                                        wojDet3.Belop = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), dtDebtDetails.Rows(2)("OWN RISK AMOUNT").ToString)
                                                    Else
                                                        wojDet3.Belop = "0" '(-1 * Convert.ToDecimal(IIf(IsDBNull(dtWODetails.Rows(0)("WO_OWN_RISK_AMT")) = True, 0, dtWODetails.Rows(0)("WO_OWN_RISK_AMT"))))
                                                    End If
                                                End If
                                                wojDet3.JobId = jobNo '""
                                                wojDet3.Flag = "0"
                                                wojDet3.ForeignJob = foreignJobText.ToString
                                                wojDet3.ItemDesc = ""
                                                wojDet3.LineNo = IIf(IsDBNull(dtWODetails.Rows(0)("WO_OWN_RISK_SL_NO")) = True, "0", dtWODetails.Rows(0)("WO_OWN_RISK_SL_NO"))
                                                wojDet3.IdWOItemseq = ""
                                                wojDet3.Job_Status = dtWODetails.Rows(0)("JOB_STATUS").ToString
                                                wojDet3.Diff = "OR"
                                                wojDet3.IdWODetailseq = dtWODetails.Rows(0)("ID_WODET_SEQ")
                                                wojDet3.IdWOLabSeq = ""
                                                wojDet3.Id_Deb_Seq = Convert.ToInt32(dtDebtDetails.Rows(2)("ID_DBT_SEQ").ToString)
                                                wojDet3.Jobi_Bo_Qty = ""
                                                wojDet3.Item_Avail_Qty = 0
                                                wojDet3.IdMech = ""
                                                wojDet3.Id_Make = ""
                                                wojDet3.Id_Warehouse = 0
                                                wojDet3.Sp_Cost_Price = "0"
                                                wojDet3.MechanicName = ""
                                                wojDet3.DebtType = dtDebtDetails.Rows(2)("CUST_TYPE").ToString
                                                wojDet3.Id_Job_Deb = IIf(IsDBNull(dtDebtDetails.Rows(2)("Id_Job_Deb")) = True, "", dtDebtDetails.Rows(2)("Id_Job_Deb"))
                                                wojDet3.WO_Own_Pay_Vat = IIf(IsDBNull(dtWODetails.Rows(0)("WO_Own_Pay_Vat")) = True, False, dtWODetails.Rows(0)("WO_Own_Pay_Vat"))
                                                wojDet3.SplitPercent = dtDebtDetails.Rows(2)("DBT_PER").ToString
                                                details.Add(wojDet3)
                                            End If

                                            'Reduction After Own Risk and Reduction Before Own Risk
                                            If dtDebtDetails.Rows.Count > 1 Then
                                                Dim redType As String = "NoRed" 'No Reduction by default
                                                Dim redDesc As String = ""
                                                If ((dtDebtDetails.Rows(2)("Reduction_Per").ToString > 0 Or dtDebtDetails.Rows(2)("Reduction_Amount").ToString > 0) And strJobNo = "1") Then
                                                    Dim wojDetRAOR As New WOJobDetailBO()
                                                    wojDetRAOR.IdJob = ""

                                                    If (dtDebtDetails.Rows(2)("Reduction_Before_OR").ToString = "False" And dtDebtDetails.Rows(2)("Reduction_After_OR").ToString = "False") Then
                                                        redType = "NoRed"
                                                        redDesc = ""
                                                    ElseIf (dtDebtDetails.Rows(2)("Reduction_Before_OR").ToString = "True" And dtDebtDetails.Rows(2)("Reduction_After_OR").ToString = "False") Then
                                                        redType = "RBOR"
                                                        redDesc = "Reduction Before Own Risk Charged"
                                                    ElseIf (dtDebtDetails.Rows(2)("Reduction_Before_OR").ToString = "False" And dtDebtDetails.Rows(2)("Reduction_After_OR").ToString = "True") Then
                                                        redType = "RAOR"
                                                        redDesc = "Reduction After Own Risk  Charged"
                                                    End If

                                                    wojDetRAOR.Text = redDesc  'IIf(IsDBNull(dtWODetails.Rows(0)("WO_OWN_RISK_DESC")) = True, "", dtWODetails.Rows(0)("WO_OWN_RISK_DESC")) 'dtWODetails.Rows(0)("WO_OWN_RISK_DESC").ToString
                                                    'wojDetRAOR.ReductionType = redType
                                                    wojDetRAOR.Diff = redType
                                                    If dtDebtDetails.Rows(2)("CUST_TYPE").ToString = "OHC" Then
                                                        wojDetRAOR.Nei = "0"
                                                    ElseIf dtDebtDetails.Rows(2)("CUST_TYPE").ToString = "INSC" Then
                                                        wojDetRAOR.Nei = "1"
                                                    ElseIf dtDebtDetails.Rows(2)("CUST_TYPE").ToString = "INTC" Then
                                                        wojDetRAOR.Nei = "2"
                                                    ElseIf dtDebtDetails.Rows(2)("CUST_TYPE").ToString = "CLA" Then
                                                        wojDetRAOR.Nei = "3"
                                                    ElseIf dtDebtDetails.Rows(2)("CUST_TYPE").ToString = "MISC" Then
                                                        wojDetRAOR.Nei = "4"
                                                    End If
                                                    wojDetRAOR.Ford = dtDebtDetails.Rows(2)("Reduction_Per").ToString
                                                    wojDetRAOR.Bestilt = ""
                                                    wojDetRAOR.Levert = ""
                                                    'wojDetRAOR.Pris = "" 'objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtWODetails.Rows(0)("WO_OWN_RISK_AMT")) = True, 0D, dtWODetails.Rows(0)("WO_OWN_RISK_AMT")))
                                                    wojDetRAOR.Rab = ""
                                                    Dim totlabamt As String = "0" 'objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtDebtDetails.Rows(1)("REDUCTION_AMOUNT")) = True, 0D, dtDebtDetails.Rows(1)("REDUCTION_AMOUNT")))
                                                    wojDetRAOR.Belop = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), totlabamt)
                                                    If (dtDebtDetails.Rows(0)("Reduction_Per").ToString > 0) Then
                                                        wojDetRAOR.Pris = ""
                                                    Else
                                                        wojDetRAOR.Pris = wojDetRAOR.Belop
                                                    End If
                                                    wojDetRAOR.JobId = jobNo '""
                                                    wojDetRAOR.Flag = "0"
                                                    wojDetRAOR.ForeignJob = foreignJobText.ToString
                                                    wojDetRAOR.ItemDesc = ""
                                                    wojDetRAOR.LineNo = raorLineNo + 1
                                                    wojDetRAOR.IdWOItemseq = ""
                                                    wojDetRAOR.Job_Status = dtWODetails.Rows(0)("JOB_STATUS").ToString
                                                    wojDetRAOR.IdWODetailseq = dtWODetails.Rows(0)("ID_WODET_SEQ")
                                                    wojDetRAOR.IdWOLabSeq = ""
                                                    wojDetRAOR.Id_Deb_Seq = Convert.ToInt32(dtDebtDetails.Rows(2)("ID_DBT_SEQ").ToString)
                                                    wojDetRAOR.Jobi_Bo_Qty = ""
                                                    wojDetRAOR.Item_Avail_Qty = 0
                                                    wojDetRAOR.IdMech = ""
                                                    wojDetRAOR.Id_Make = ""
                                                    wojDetRAOR.Id_Warehouse = 0
                                                    wojDetRAOR.Sp_Cost_Price = "0"
                                                    wojDetRAOR.MechanicName = ""
                                                    wojDetRAOR.DebtType = dtDebtDetails.Rows(2)("CUST_TYPE").ToString
                                                    wojDetRAOR.Id_Job_Deb = IIf(IsDBNull(dtDebtDetails.Rows(2)("Id_Job_Deb")) = True, "", dtDebtDetails.Rows(2)("Id_Job_Deb"))
                                                    wojDetRAOR.WO_Own_Pay_Vat = IIf(IsDBNull(dtWODetails.Rows(0)("WO_Own_Pay_Vat")) = True, False, dtWODetails.Rows(0)("WO_Own_Pay_Vat"))
                                                    details.Add(wojDetRAOR)
                                                End If
                                            End If

                                            Dim dt As New DataTable()
                                            ' dt.TableName = "localCustDetails"
                                            For Each [property] As PropertyInfo In details(0).[GetType]().GetProperties()
                                                dt.Columns.Add(New DataColumn([property].Name, [property].PropertyType))
                                            Next

                                            For Each det As WOJobDetailBO In details
                                                Dim newRow As DataRow = dt.NewRow()
                                                For Each [property] As PropertyInfo In det.[GetType]().GetProperties()
                                                    newRow([property].Name) = det.[GetType]().GetProperty([property].Name).GetValue(det, Nothing)
                                                Next
                                                dt.Rows.Add(newRow)
                                            Next

                                            dt.DefaultView.Sort = "LineNo ASC"

                                            dt = dt.DefaultView.ToTable()

                                            details = Nothing
                                            details = New List(Of WOJobDetailBO)()
                                            For Each dtrow As DataRow In dt.Rows
                                                Dim wojDet As New WOJobDetailBO()
                                                wojDet.IdJob = dtrow("IdJob")
                                                wojDet.Text = dtrow("Text")
                                                wojDet.Nei = dtrow("Nei")
                                                wojDet.Ford = dtrow("Ford")
                                                wojDet.Bestilt = dtrow("Bestilt")
                                                wojDet.Levert = dtrow("Levert")
                                                wojDet.Pris = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("Pris")) = True, 0D, dtrow("Pris")))
                                                wojDet.Rab = IIf(IsDBNull(dtrow("Rab")) = True, "0", dtrow("Rab"))
                                                'Dim totlabamt As String = IIf(IsDBNull(dtrow("WO_Tot_Lab_Amt").ToString()) = True, 0, dtrow("WO_Tot_Lab_Amt").ToString())
                                                wojDet.Belop = dtrow("Belop") '(wojDet.Pris * (IIf(IsDBNull(dtrow("Belop")) = True, 0, dtrow("Belop")))) - (wojDet.Pris * (IIf(IsDBNull(dtrow("JOBI_DELIVER_QTY")) = True, 0, dtrow("JOBI_DELIVER_QTY"))) * 0.01 * wojDet.Rab)
                                                wojDet.JobId = dtrow("JobId") '""
                                                wojDet.Flag = dtrow("Flag")
                                                wojDet.ForeignJob = dtrow("ForeignJob")
                                                wojDet.ItemDesc = dtrow("ItemDesc")
                                                wojDet.LineNo = IIf(IsDBNull(dtrow("LineNo").ToString()) = True, "", dtrow("LineNo").ToString())
                                                wojDet.Diff = IIf(IsDBNull(dtrow("Diff").ToString()) = True, 0, dtrow("Diff").ToString())
                                                wojDet.IdWODetailseq = dtrow("IdWODetailseq").ToString
                                                wojDet.IdWOItemseq = dtrow("IdWOItemseq").ToString
                                                wojDet.Job_Status = dtrow("Job_Status").ToString
                                                wojDet.IdWOLabSeq = dtrow("IdWOLabSeq").ToString
                                                wojDet.Id_Deb_Seq = Convert.ToInt32(dtrow("Id_Deb_Seq").ToString)
                                                wojDet.IdMech = dtrow("IdMech").ToString
                                                wojDet.Jobi_Bo_Qty = dtrow("Jobi_Bo_Qty").ToString
                                                wojDet.Id_Make = dtrow("Id_Make").ToString
                                                wojDet.Item_Avail_Qty = dtrow("Item_Avail_Qty").ToString
                                                wojDet.Id_Warehouse = IIf(IsDBNull(dtrow("Id_Warehouse")) = True, "0", Convert.ToInt32(dtrow("Id_Warehouse").ToString))
                                                wojDet.Sp_Cost_Price = IIf(IsDBNull(dtrow("Sp_Cost_Price").ToString()) = True, "0", dtrow("Sp_Cost_Price").ToString())
                                                wojDet.MechanicName = IIf(IsDBNull(dtrow("MechanicName").ToString()) = True, "0", dtrow("MechanicName").ToString())
                                                wojDet.DebtType = dtrow("DebtType").ToString
                                                wojDet.Id_Job_Deb = dtrow("Id_Job_Deb").ToString
                                                wojDet.WO_Own_Pay_Vat = IIf(IsDBNull(dtrow("WO_Own_Pay_Vat")) = True, False, dtrow("WO_Own_Pay_Vat"))
                                                wojDet.SplitPercent = dtrow("SplitPercent").ToString
                                                wojDet.DebitorDiscount = dtrow("DebitorDiscount").ToString
                                                wojDet.CustGenDiscount = dtrow("CustGenDiscount").ToString
                                                wojDet.CustLabDiscount = dtrow("CustLabDiscount").ToString
                                                wojDet.CustSpareDiscount = dtrow("CustSpareDiscount").ToString
                                                wojDet.SpareDiscount = IIf(IsDBNull(dtrow("SpareDiscount")) = True, 0, dtrow("SpareDiscount"))
                                                wojDet.DebtVatPercentage = dtrow("DebtVatPercentage")
                                                details.Add(wojDet)
                                            Next

                                            Dim wojdet2 As New WOJobDetailBO()
                                            wojdet2.IdJob = ""
                                            wojdet2.Text = ""
                                            wojdet2.Nei = ""
                                            wojdet2.Ford = dtDebtDetails.Rows(2)("DBT_PER").ToString
                                            wojdet2.Bestilt = ""
                                            wojdet2.Levert = ""
                                            wojdet2.Pris = ""
                                            wojdet2.Rab = ""
                                            wojdet2.Belop = ""
                                            wojdet2.JobId = jobNo
                                            wojdet2.Flag = "0"
                                            wojdet2.ForeignJob = foreignJobText.ToString
                                            wojdet2.ItemDesc = ""
                                            wojdet2.Job_Status = dtWODetails.Rows(0)("JOB_STATUS").ToString
                                            wojdet2.IdWODetailseq = dtWODetails.Rows(0)("ID_WODET_SEQ").ToString
                                            wojdet2.IdWOItemseq = ""
                                            wojdet2.IdWOLabSeq = ""
                                            wojdet2.Id_Deb_Seq = Convert.ToInt32(dtDebtDetails.Rows(2)("ID_DBT_SEQ").ToString)
                                            wojdet2.Jobi_Bo_Qty = "0"
                                            wojdet2.Id_Make = ""
                                            wojdet2.Id_Warehouse = 1
                                            wojdet2.Sp_Cost_Price = "0"
                                            wojdet2.MechanicName = ""
                                            wojdet2.DebtType = dtDebtDetails.Rows(2)("CUST_TYPE").ToString
                                            wojdet2.Id_Job_Deb = IIf(IsDBNull(dtDebtDetails.Rows(2)("Id_Job_Deb")) = True, "", dtDebtDetails.Rows(2)("Id_Job_Deb"))
                                            wojdet2.WO_Own_Pay_Vat = IIf(IsDBNull(dtWODetails.Rows(0)("WO_Own_Pay_Vat")) = True, False, dtWODetails.Rows(0)("WO_Own_Pay_Vat"))
                                            wojdet2.SplitPercent = dtDebtDetails.Rows(2)("DBT_PER").ToString
                                            wojdet2.SpareDiscount = 0
                                            wojdet2.DebtVatPercentage = 0
                                            details.Add(wojdet2)
                                        Else
                                            strJobNo = objWOJDO.Fetch_Job_No(objWOJBO) 'Use it later to fetch job no
                                            'strJobNo = "1"
                                            Dim wojDet As New WOJobDetailBO()
                                            wojDet.IdJob = "Job:" + strJobNo
                                            wojDet.Text = ""
                                            wojDet.Nei = "0"
                                            wojDet.Ford = "100"
                                            wojDet.Bestilt = ""
                                            wojDet.Levert = ""
                                            wojDet.Pris = ""
                                            wojDet.Rab = ""
                                            wojDet.Belop = ""
                                            wojDet.JobId = strJobNo '""
                                            wojDet.Flag = "1"
                                            wojDet.ForeignJob = ""
                                            wojDet.ItemDesc = ""
                                            wojDet.IdWODetailseq = ""
                                            wojDet.IdWOItemseq = ""
                                            wojDet.IdWOLabSeq = ""
                                            wojDet.Id_Deb_Seq = 0
                                            wojDet.Jobi_Bo_Qty = "0"
                                            wojDet.Id_Make = ""
                                            wojDet.Id_Warehouse = 1
                                            wojDet.Sp_Cost_Price = "0"
                                            wojDet.MechanicName = ""
                                            wojDet.DebtType = dtDebtDetails.Rows(2)("CUST_TYPE").ToString
                                            wojDet.Id_Job_Deb = ""
                                            wojDet.WO_Own_Pay_Vat = False
                                            wojDet.SplitPercent = "0"
                                            wojDet.SpareDiscount = 0
                                            wojDet.DebtVatPercentage = 0
                                            details.Add(wojDet)


                                            Dim wojdet1 As New WOJobDetailBO()
                                            wojdet1.IdJob = ""
                                            wojdet1.Text = ""
                                            wojdet1.Nei = ""
                                            wojdet1.Ford = dtDebtDetails.Rows(2)("DBT_PER").ToString
                                            wojdet1.Bestilt = ""
                                            wojdet1.Levert = ""
                                            wojdet1.Pris = ""
                                            wojdet1.Rab = ""
                                            wojdet1.Belop = ""
                                            wojdet1.JobId = strJobNo
                                            wojdet1.Flag = "0"
                                            wojdet1.ForeignJob = ""
                                            wojdet1.ItemDesc = ""
                                            wojdet1.IdWODetailseq = ""
                                            wojdet1.IdWOItemseq = ""
                                            wojdet1.IdWOLabSeq = ""
                                            wojdet1.Id_Deb_Seq = 0
                                            wojdet1.Jobi_Bo_Qty = "0"
                                            wojdet1.Id_Make = ""
                                            wojdet1.Id_Warehouse = 1
                                            wojdet1.Sp_Cost_Price = "0"
                                            wojdet1.MechanicName = ""
                                            wojdet1.DebtType = dtDebtDetails.Rows(2)("CUST_TYPE").ToString
                                            wojdet1.Id_Job_Deb = ""
                                            wojdet1.WO_Own_Pay_Vat = False
                                            wojdet1.SplitPercent = "0"
                                            wojdet1.SpareDiscount = 0
                                            wojdet1.DebtVatPercentage = 0
                                            details.Add(wojdet1)
                                        End If
                                    End If
                                End If
                                jobdetails3Deb.AddRange(details)
                            Next 'End of No of Jobs
                        Else

                            Dim details As New List(Of WOJobDetailBO)()
                            strJobNo = objWOJDO.Fetch_Job_No(objWOJBO) 'Use it later to fetch job no
                            'strJobNo = "1"
                            Dim wojDet As New WOJobDetailBO()
                            wojDet.IdJob = "Job:" + strJobNo
                            wojDet.Text = ""
                            wojDet.Nei = "0"
                            wojDet.Ford = "100"
                            wojDet.Bestilt = ""
                            wojDet.Levert = ""
                            wojDet.Pris = ""
                            wojDet.Rab = ""
                            wojDet.Belop = ""
                            wojDet.JobId = strJobNo '""
                            wojDet.Flag = "1"
                            wojDet.ForeignJob = ""
                            wojDet.ItemDesc = ""
                            wojDet.IdWODetailseq = ""
                            wojDet.IdWOItemseq = ""
                            wojDet.IdWOLabSeq = ""
                            wojDet.Id_Deb_Seq = 0
                            wojDet.Jobi_Bo_Qty = "0"
                            wojDet.Id_Make = ""
                            wojDet.Id_Warehouse = 1
                            wojDet.Sp_Cost_Price = "0"
                            wojDet.MechanicName = ""
                            wojDet.DebtType = dtDebtDetails.Rows(2)("CUST_TYPE").ToString
                            wojDet.Id_Job_Deb = ""
                            wojDet.WO_Own_Pay_Vat = False
                            wojDet.SplitPercent = "0"
                            wojDet.SpareDiscount = 0
                            wojDet.DebtVatPercentage = 0
                            details.Add(wojDet)


                            Dim wojdet1 As New WOJobDetailBO()
                            wojdet1.IdJob = ""
                            wojdet1.Text = ""
                            wojdet1.Nei = ""
                            wojdet1.Ford = dtDebtDetails.Rows(2)("DBT_PER").ToString
                            wojdet1.Bestilt = ""
                            wojdet1.Levert = ""
                            wojdet1.Pris = ""
                            wojdet1.Rab = ""
                            wojdet1.Belop = ""
                            wojdet1.JobId = strJobNo
                            wojdet1.Flag = "0"
                            wojdet1.ForeignJob = ""
                            wojdet1.ItemDesc = ""
                            wojdet1.IdWODetailseq = ""
                            wojdet1.IdWOItemseq = ""
                            wojdet1.IdWOLabSeq = ""
                            wojdet1.Id_Deb_Seq = 0
                            wojdet1.Jobi_Bo_Qty = "0"
                            wojdet1.Id_Make = ""
                            wojdet1.Id_Warehouse = 1
                            wojdet1.Sp_Cost_Price = "0"
                            wojdet1.MechanicName = ""
                            wojdet1.DebtType = dtDebtDetails.Rows(2)("CUST_TYPE").ToString
                            wojdet1.Id_Job_Deb = ""
                            wojdet1.WO_Own_Pay_Vat = False
                            wojdet1.SplitPercent = "0"
                            wojdet1.SpareDiscount = 0
                            wojdet1.DebtVatPercentage = 0
                            details.Add(wojdet1)

                            jobdetails3Deb.AddRange(details)
                        End If

                    End If

                    jobdetails.AddRange(jobdetails3Deb)

                    ' End If

                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "LoadWorkOrderDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return jobdetails.ToList
        End Function
        Public Function Delete_Save_JobDetails(ByVal objWOJBO As WOJobDetailBO, ByVal mode As String) As String()
            Dim strResult As String()
            Try
                If (mode = "Add") Then
                    strResult = objWOJDO.Update_WOJobDetails(objWOJBO)
                Else
                    objWOJBO.Modified_By = HttpContext.Current.Session("UserID")
                    objWOJBO.Dt_Modified = Now
                    strResult = objWOJDO.Update_Delete_WOJobDetails(objWOJBO)
                End If

                'strResult = objWOJDO.Save_WOJobDetails(objWOJBO)
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "Save_GridJobDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strResult
        End Function
        Public Function FetchSpareMake(ByVal q As String) As List(Of WOJobDetailBO)
            Dim dsMake As New DataSet
            Dim dtMake As DataTable
            Dim makeSearchResult As New List(Of WOJobDetailBO)()
            Try
                dsMake = objWOJDO.FetchSpareMake(q)

                If dsMake.Tables.Count > 0 Then
                    dtMake = dsMake.Tables(0)
                End If
                ' If q <> String.Empty Then
                For Each dtrow As DataRow In dtMake.Rows
                    Dim msr As New WOJobDetailBO()
                    msr.Sp_Make = dtrow("ID_SETTINGS").ToString

                    makeSearchResult.Add(msr)
                Next
                'End If
            Catch ex As Exception
                Throw ex
            End Try
            Return makeSearchResult
        End Function
        Public Function FetchSpareLocation(ByVal q As String) As List(Of WOJobDetailBO)
            Dim dsLoc As New DataSet
            Dim dtLoc As DataTable
            Dim makeSearchResult As New List(Of WOJobDetailBO)()
            Try
                dsLoc = objWOJDO.FetchSpareMake(q)

                If dsLoc.Tables.Count > 0 Then
                    dtLoc = dsLoc.Tables(1)
                End If
                If dtLoc.Rows.Count > 0 Then
                    For Each dtrow As DataRow In dtLoc.Rows
                        Dim msr As New WOJobDetailBO()
                        msr.Sp_Location = dtrow("LOCATION").ToString
                        If dsLoc.Tables(2).Rows.Count > 0 Then
                            msr.Id_Make = IIf(IsDBNull(dsLoc.Tables(2).Rows(0)("ID_MAKE")) = True, "", dsLoc.Tables(2).Rows(0)("ID_MAKE"))
                            msr.SP_SupplierID = IIf(IsDBNull(dsLoc.Tables(2).Rows(0)("ID_SUPPLIER")) = True, "", dsLoc.Tables(2).Rows(0)("ID_SUPPLIER"))
                            msr.Item_Sp_Desc = IIf(IsDBNull(dsLoc.Tables(2).Rows(0)("LOCATION")) = True, "", dsLoc.Tables(2).Rows(0)("LOCATION"))
                            msr.Sp_FlgStockItem = IIf(IsDBNull(dsLoc.Tables(2).Rows(0)("FLG_STOCK_ITEM")) = True, "0", dsLoc.Tables(2).Rows(0)("FLG_STOCK_ITEM"))
                            msr.SP_FlgStockItemStatus = IIf(IsDBNull(dsLoc.Tables(2).Rows(0)("FLG_STOCKITEM_STATUS")) = True, "0", dsLoc.Tables(2).Rows(0)("FLG_STOCKITEM_STATUS"))
                            msr.SP_FlgNonStockItemStatus = IIf(IsDBNull(dsLoc.Tables(2).Rows(0)("FLG_NONSTOCKITEM_STATUS")) = True, "0", dsLoc.Tables(2).Rows(0)("FLG_NONSTOCKITEM_STATUS"))
                        Else
                            msr.Sp_FlgStockItem = True
                            msr.SP_FlgStockItemStatus = True
                            msr.SP_FlgNonStockItemStatus = True
                        End If
                        makeSearchResult.Add(msr)
                    Next
                End If
            Catch ex As Exception
                Throw ex
            End Try
            Return makeSearchResult
        End Function
        Public Function FetchSpareSupplier(ByVal q As String) As List(Of WOJobDetailBO)
            Dim dsSupplier As New DataSet
            Dim dtSupplier As DataTable
            Dim suppSearchResult As New List(Of WOJobDetailBO)()
            Try
                dsSupplier = objWOJDO.FetchSpareSupplier(q)

                If dsSupplier.Tables.Count > 0 Then
                    dtSupplier = dsSupplier.Tables(0)
                End If
                ' If q <> String.Empty Then
                For Each dtrow As DataRow In dtSupplier.Rows
                    Dim suppsr As New WOJobDetailBO()
                    suppsr.SP_SupplierID = dtrow("SUPPLIER ID").ToString
                    suppsr.SP_CurrentNo = dtrow("SUPPLIER_NO").ToString
                    suppsr.SP_SupplierName = dtrow("SUPPLIER").ToString

                    suppSearchResult.Add(suppsr)
                Next
                'End If
            Catch ex As Exception
                Throw ex
            End Try
            Return suppSearchResult
        End Function
        Public Function SaveSpareSett(ByVal objWOJBO As WOJobDetailBO) As String
            Dim strResult As String
            Try

                strResult = objWOJDO.Save_SpSettings(objWOJBO)

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "Save_GridJobDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strResult
        End Function
        Public Function DeleteTextLine(ByVal objWOJBO As WOJobDetailBO) As String
            Dim strResult As String
            Try
                strResult = objWOJDO.Del_TextLine(objWOJBO)
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "DeleteTextLine", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strResult
        End Function

        Public Function Delete_Job_Debitor(objWOHeaderBO) As String()
            Dim strResult As String = ""
            Dim strArray As Array
            Dim strErrArr As Array
            Dim strError As String
            Dim strRecordsDeleted As String = ""
            Dim strRecordsNotDeleted As String = ""
            Try
                strResult = objWOJDO.Delete_Job_Debitor(objWOHeaderBO)
                strArray = strResult.Split(",")
                strError = strArray(0)
                strErrArr = strError.Split(";")
                strRecordsDeleted = CStr(strArray(1))
                strRecordsNotDeleted = CStr(strArray(2))
                If strRecordsDeleted <> "" Then
                    strArray(0) = strErrArr(0)
                    strArray(1) = objErrHandle.GetErrorDescParameter("DDEL", strRecordsDeleted)
                    strArray(2) = strErrArr(1)
                    If strArray(2) <> "0" Then
                        strArray(2) = "Spare Parts in the job and this will get back into Stock" 'objErrHandle.GetErrorDescParameter("MSG162")
                    Else
                        strArray(2) = ""
                    End If
                End If

                If strRecordsNotDeleted <> "" Then
                    strArray(0) = "NDEL"
                    strArray(1) = objErrHandle.GetErrorDesc("UNDEL")
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOHeader", "Delete_Job_Debitor", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strArray
        End Function

        Public Function FetchDeleteJob(objWOJBO) As List(Of WOJobDetailBO)
            Dim details As New List(Of WOJobDetailBO)()
            Dim dsWODelJob As New DataSet
            Dim dtWODelJob As New DataTable
            Dim jobdetails As New List(Of WOJobDetailBO)()
            Try
                dsWODelJob = objWOJDO.LoadDelJobDet(objWOJBO)
                dtWODelJob = dsWODelJob.Tables(0)
                If dsWODelJob.Tables(0).Rows.Count > 0 Then
                    For Each dtrow As DataRow In dtWODelJob.Rows
                        Dim wohDet As New WOJobDetailBO()
                        wohDet.Id_Job = dtrow("ID_JOB_ID").ToString()
                        wohDet.Id_Customer = dtrow("ID_CUSTOMER").ToString()
                        wohDet.DebtType = dtrow("CUST_TYPE").ToString()
                        details.Add(wohDet)
                    Next
                End If
                If dsWODelJob.Tables(1).Rows.Count > 0 Then
                    dtWODelJob = dsWODelJob.Tables(1)
                    For Each dtrow As DataRow In dtWODelJob.Rows
                        Dim wojDet As New WOJobDetailBO()
                        wojDet.Id_Job = dtrow("ID_JOB_ID").ToString()
                        wojDet.Id_Customer = dtrow("ID_CUSTOMER").ToString()
                        wojDet.DebtType = dtrow("CUST_TYPE").ToString()
                        details.Add(wojDet)
                    Next
                End If
                jobdetails.AddRange(details)
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "FetchDeleteJob", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return jobdetails.ToList
        End Function
        Public Function InvoiceProcess(ByVal idWoNo As String, ByVal idWoPr As String) As String()
            Dim strArray As Array
            Try
                Dim dsWOJobs As New DataSet 'No of Jobs
                Dim dtWOJobs As New DataTable 'No of Jobs
                Dim dsWODetails As New DataSet  'Job Number and totals
                Dim dtWODetails As New DataTable 'Job Number and totals
                Dim strJobNo As String
                Dim InvoiceListXML As String = ""
                Dim strRetVal As String = ""
                Dim strInvLstXml As String = ""

                objWOHBO.Id_WO_NO = idWoNo
                objWOHBO.Id_WO_Prefix = idWoPr
                objWOHBO.Created_By = HttpContext.Current.Session("UserID")
                dsWOJobs = objWOHDO.Fetch_WOHeader(objWOHBO)
                If (dsWOJobs.Tables.Count > 0) Then
                    dtWOJobs = dsWOJobs.Tables(3)

                    If (dtWOJobs.Rows.Count > 0) Then
                        For Each dtwojobsrow As DataRow In dtWOJobs.Rows
                            Dim details As New List(Of WOJobDetailBO)()
                            strJobNo = dtwojobsrow("Id_Job").ToString()
                            objWOJBO.Id_Job = strJobNo
                            objWOJBO.Id_WO_NO = idWoNo
                            objWOJBO.Id_WO_Prefix = idWoPr
                            dsWODetails = objWOJDO.WorkDetails(objWOJBO)
                            If dsWODetails.Tables.Count > 0 Then
                                dtWODetails = dsWODetails.Tables(0)
                                For Each dtwodetrow As DataRow In dtWODetails.Rows
                                    InvoiceListXML += "<INV_GENERATE " _
                                    + " ID_WO_PREFIX=""" + objCommonUtil.ConvertStr(idWoPr) + """ " _
                                    + " ID_WO_NO=""" + objCommonUtil.ConvertStr(idWoNo) + """ " _
                                    + " ID_WODET_SEQ=""" + objCommonUtil.ConvertStr(dtwodetrow("ID_WODET_SEQ")) + """ " _
                                    + " ID_JOB_DEB=""" + objCommonUtil.ConvertStr(dtwodetrow("ID_JOB_DEB")) + """ " _
                                    + " FLG_BATCH=""" + objCommonUtil.ConvertStr(dtwodetrow("FLG_CUST_BATCHINV")) + """ " _
                                    + " IV_DATE =""" + "" + """ " _
                                 + "/>"
                                Next
                            End If
                        Next
                    End If
                End If

                InvoiceListXML = "<ROOT>" + InvoiceListXML + "</ROOT>"
                strRetVal = objInvDetDO.Generate_Invoices_Intermediate(InvoiceListXML, HttpContext.Current.Session("UserID"), strInvLstXml)
                strInvLstXml = strInvLstXml.Replace("INVNO", "ID_INV_NO")
                HttpContext.Current.Session("xmlInvNos") = strInvLstXml
                HttpContext.Current.Session("RptType") = "INVOICE"
                strArray = strRetVal.Split(",") 'Need to initialize array(1)
                strRetVal = strArray(0)
                If strRetVal = "OFL" Then
                    strArray(0) = "ERROR"
                    strArray(1) = objErrHandle.GetErrorDesc("INVNOOFL")
                ElseIf strRetVal = "NOCONFIG" Then
                    strArray(0) = "ERROR"
                    strArray(1) = objErrHandle.GetErrorDesc("NOCONFIG")
                    'START
                ElseIf strRetVal = "INVWRNPAY" Then
                    strArray(0) = "ERROR"
                    strArray(1) = objErrHandle.GetErrorDesc("INVWRNPAY")
                    'END
                ElseIf strRetVal <> "0" And strRetVal <> "WARN" And strRetVal <> "INVOICED" Then
                    strArray(0) = "ERROR"
                    strArray(1) = objErrHandle.GetErrorDesc("INVERR")
                Else
                    If strRetVal = "WARN" Then
                        strArray(0) = "ERROR"
                        strArray(1) = objErrHandle.GetErrorDesc("INVWRN")
                    End If
                    strArray(0) = "SUCCESS"
                    strArray(1) = objErrHandle.GetErrorDescParameter("CREATE", objErrHandle.GetErrorDesc("INV"))

                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "InvoiceProcess", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strArray

        End Function

        Public Function InvoiceBasisProcess(ByVal idWoNo As String, ByVal idWoPr As String) As String
            Dim strResult As String
            Try
                Dim dsWOJobs As New DataSet 'No of Jobs
                Dim dtWOJobs As New DataTable 'No of Jobs
                Dim dsWODetails As New DataSet  'Job Number and totals
                Dim dtWODetails As New DataTable 'Job Number and totals
                Dim strJobNo As String
                Dim InvoiceListXML As String = ""
                objWOHBO.Id_WO_NO = idWoNo
                objWOHBO.Id_WO_Prefix = idWoPr
                objWOHBO.Created_By = HttpContext.Current.Session("UserID")
                dsWOJobs = objWOHDO.Fetch_WOHeader(objWOHBO)
                If (dsWOJobs.Tables.Count > 0) Then
                    dtWOJobs = dsWOJobs.Tables(3)

                    If (dtWOJobs.Rows.Count > 0) Then
                        For Each dtwojobsrow As DataRow In dtWOJobs.Rows
                            Dim details As New List(Of WOJobDetailBO)()
                            strJobNo = dtwojobsrow("Id_Job").ToString()
                            objWOJBO.Id_Job = strJobNo
                            objWOJBO.Id_WO_NO = idWoNo
                            objWOJBO.Id_WO_Prefix = idWoPr
                            dsWODetails = objWOJDO.WorkDetails(objWOJBO)
                            If dsWODetails.Tables.Count > 0 Then
                                dtWODetails = dsWODetails.Tables(0)
                                For Each dtwodetrow As DataRow In dtWODetails.Rows
                                    InvoiceListXML += "<INV_GENERATE " _
                                    + " ID_WO_PREFIX=""" + objCommonUtil.ConvertStr(idWoPr) + """ " _
                                    + " ID_WO_NO=""" + objCommonUtil.ConvertStr(idWoNo) + """ " _
                                    + " ID_WODET_SEQ=""" + objCommonUtil.ConvertStr(dtwodetrow("ID_WODET_SEQ")) + """ " _
                                    + " ID_JOB_DEB=""" + objCommonUtil.ConvertStr(dtwodetrow("ID_JOB_DEB")) + """ " _
                                    + " FLG_BATCH=""" + objCommonUtil.ConvertStr(dtwodetrow("FLG_CUST_BATCHINV")) + """ " _
                                    + " IV_DATE =""" + "" + """ " _
                                 + "/>"
                                Next
                            End If
                        Next
                    End If
                End If

                InvoiceListXML = "<ROOT>" + InvoiceListXML + "</ROOT>"
                HttpContext.Current.Session("xmlInvNos") = InvoiceListXML
                HttpContext.Current.Session("RptType") = "INVOICEBASIS"

                If (InvoiceListXML <> "") Then
                    strResult = "SUCCESS"
                Else
                    strResult = "ERROR"
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "InvoiceBasisProcess", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strResult

        End Function
        Public Function UpdateVehOwner(ByVal vehicleId As String, ByVal customerId As String) As String
            Dim strRt As String
            objWOJBO.WO_Id_Veh = vehicleId
            objWOJBO.Id_Customer = customerId
            strRt = objWOJDO.UpdVehOwner(objWOJBO)
            Return strRt
        End Function

        Public Function GenerateXML(ByVal idWoNo As String, ByVal idWoPr As String) As String
            Dim strRetEHF As String = ""
            Try
                'CreateXML()
                strRetEHF = GenXML(idWoNo, idWoPr)
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "GenerateXML", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strRetEHF
        End Function
        Public Function GenXML(ByVal idWoNo As String, ByVal idWoPr As String)
            Try
                'invNo = "D8082"
                Dim pStrClassName = "EHF"
                Dim newlog As DirectoryInfo
                Dim fileServerPath As String = System.Configuration.ConfigurationManager.AppSettings("MSG_Error_Log_Path") + "\" + pStrClassName + "\"
                Dim logfilepath As String = String.Empty
                Dim logfilestream As FileStream
                Dim dsEHFInfo As DataSet
                Dim dsInvInfo As DataSet

                'Dim invXML As String
                'invXML = "<OPTIONS FLG_COPYTEXT='FALSE' /><ID_INV_NO ID_INV_NO='D8082     ' FLG_INVORCN='FALSE' /><ID_INV_NO ID_INV_NO='D8082     ' FLG_INVORCN='FALSE' /><ID_INV_NO ID_INV_NO='D8082     ' FLG_INVORCN='FALSE' />"
                'invXML = "<ROOT>" + invXML + "</ROOT>"
                dsInvInfo = objWOJDO.Fetch_INV_Info(idWoNo, idWoPr)

                For j As Integer = 0 To dsInvInfo.Tables(0).Rows.Count - 1
                    dsEHFInfo = objWOJDO.Fetch_EHF_Info(dsInvInfo.Tables(0).Rows(j)("ID_INV_NO"))

                    'Constructing Path and File Name
                    logfilepath = fileServerPath
                    newlog = New DirectoryInfo(logfilepath)
                    logfilepath = newlog.FullName + dsEHFInfo.Tables(1).Rows(0)("ID_INV_NO").ToString().Trim() + ".xml"

                    'Create XML declaration
                    Dim declaration As XmlNode
                    Dim strXML As New XmlDocument
                    declaration = strXML.CreateXmlDeclaration("1.0", "UTF-8", "yes")
                    'declaration = strXML.CreateNode(XmlNodeType.XmlDeclaration, Nothing, Nothing)
                    strXML.AppendChild(declaration)

                    'Make the root Element first - Invoice
                    Dim root As XmlElement
                    root = strXML.CreateElement("Invoice", "urn:oasis:names:specification:ubl:schema:xsd:Invoice-2")
                    root.SetAttribute("xmlns:cac", "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2")
                    root.SetAttribute("xmlns:cbc", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    root.SetAttribute("xmlns:ccts", "http://wwwurn:un:unece:uncefact:documentation:2")
                    root.SetAttribute("xmlns:qdt", "urn:oasis:names:specification:ubl:schema:xsd:QualifiedDatatypes-2")
                    root.SetAttribute("xmlns:udt", "urn:un:unece:uncefact:data:specification:UnqualifiedDataTypesSchemaModule:2")
                    strXML.AppendChild(root)

                    'Creating Child Element of Invoice
                    Dim ublversionid As XmlElement
                    ublversionid = strXML.CreateElement("UBLVersionID", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    ublversionid.Prefix = "cbc"
                    ublversionid.InnerText = "2.1"
                    root.AppendChild(ublversionid)

                    'Creating Child Element of Invoice
                    Dim customizationid As XmlElement
                    customizationid = strXML.CreateElement("CustomizationID", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    customizationid.Prefix = "cbc"
                    customizationid.InnerText = "urn:www.cenbii.eu:transaction:biitrns010:ver2.0:extended:urn:www.peppol.eu:bis:peppol5a:ver2.0:extended:urn:www.difi.no:ehf:faktura:ver2.0"
                    root.AppendChild(customizationid)


                    Dim profileid As XmlElement
                    profileid = strXML.CreateElement("ProfileID", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    profileid.Prefix = "cbc"
                    profileid.InnerText = "urn:www.cenbii.eu:profile:bii05:ver2.0"
                    root.AppendChild(profileid)

                    Dim invoiceid As XmlElement
                    invoiceid = strXML.CreateElement("ID", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    invoiceid.Prefix = "cbc"
                    invoiceid.InnerText = dsEHFInfo.Tables(0).Rows(0)("INVOICENO").ToString()
                    root.AppendChild(invoiceid)


                    Dim issuedate As XmlElement
                    Dim dtInv As String
                    issuedate = strXML.CreateElement("IssueDate", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    issuedate.Prefix = "cbc"
                    Dim dtIn As Date = CDate(dsEHFInfo.Tables(0).Rows(0)("INVOICEDATE"))
                    dtInv = dtIn.ToString("yyyy-MM-dd")
                    issuedate.InnerText = dtInv
                    root.AppendChild(issuedate)


                    Dim invoicetypecode As XmlElement
                    invoicetypecode = strXML.CreateElement("InvoiceTypeCode", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    invoicetypecode.Prefix = "cbc"
                    invoicetypecode.SetAttribute("listID", "UNCL1001")
                    invoicetypecode.InnerText = "Z01"
                    root.AppendChild(invoicetypecode)

                    Dim note As XmlElement
                    note = strXML.CreateElement("Note", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    note.Prefix = "cbc"
                    note.InnerText = "Invoice text"
                    root.AppendChild(note)



                    Dim taxpointdate As XmlElement
                    taxpointdate = strXML.CreateElement("TaxPointDate", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    taxpointdate.Prefix = "cbc"
                    taxpointdate.InnerText = dtInv 'dsEHFInfo.Tables(0).Rows(0)("INVOICEDATE").ToString()
                    root.AppendChild(taxpointdate)

                    Dim documentcurrencycode As XmlElement
                    documentcurrencycode = strXML.CreateElement("DocumentCurrencyCode", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    documentcurrencycode.Prefix = "cbc"
                    documentcurrencycode.SetAttribute("listID", "ISO4217")
                    documentcurrencycode.InnerText = dsEHFInfo.Tables(0).Rows(0)("Currency_code").ToString()
                    root.AppendChild(documentcurrencycode)


                    'Creating Child Element of Invoice
                    'Dim orderreference As XmlElement
                    'orderreference = strXML.CreateElement("OrderReference", "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2")
                    'orderreference.Prefix = "cac"

                    ''Creating Child Element of OrderReference
                    'Dim orderreferenceid As XmlElement
                    'orderreferenceid = strXML.CreateElement("ID", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    'orderreferenceid.Prefix = "cbc"
                    'orderreferenceid.InnerText = dsEHFInfo.Tables(0).Rows(0)("WORKORDERPREFIX").ToString() + dsEHFInfo.Tables(0).Rows(0)("WORKORDERNO").ToString()
                    'orderreference.AppendChild(orderreferenceid)
                    'root.AppendChild(orderreference)


                    ''ContractDocumentReference
                    Dim contractdocumentreference As XmlElement
                    contractdocumentreference = strXML.CreateElement("ContractDocumentReference", "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2")
                    contractdocumentreference.Prefix = "cac"

                    'Creating Child Element of ContractDocumentReference
                    Dim contractdocumentreferenceid As XmlElement
                    contractdocumentreferenceid = strXML.CreateElement("ID", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    contractdocumentreferenceid.Prefix = "cbc"
                    contractdocumentreferenceid.InnerText = "K987654321"
                    contractdocumentreference.AppendChild(contractdocumentreferenceid)
                    root.AppendChild(contractdocumentreference)

                    '  For i As Integer = 0 To 2 'dsEHFInfo.Tables(0).Rows.Count
                    'Creating Child Element of Invoice
                    Dim accountingsupplierparty As XmlElement
                    accountingsupplierparty = strXML.CreateElement("AccountingSupplierParty", "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2")
                    accountingsupplierparty.Prefix = "cac"

                    'Creating Child Element of accountingsupplierparty
                    Dim party As XmlElement
                    party = strXML.CreateElement("Party", "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2")
                    party.Prefix = "cac"

                    Dim partyname As XmlElement
                    partyname = strXML.CreateElement("PartyName", "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2")
                    partyname.Prefix = "cac"

                    Dim name As XmlElement
                    name = strXML.CreateElement("Name", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    name.Prefix = "cbc"
                    name.InnerText = dsEHFInfo.Tables(0).Rows(0)("SUBSIDIARYNAME").ToString()
                    partyname.AppendChild(name)

                    Dim postaladdress As XmlElement
                    postaladdress = strXML.CreateElement("PostalAddress", "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2")
                    postaladdress.Prefix = "cac"

                    Dim postbox As XmlElement
                    postbox = strXML.CreateElement("Postbox", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    postbox.Prefix = "cbc"
                    postbox.InnerText = dsEHFInfo.Tables(0).Rows(0)("SUBSIDIARYADDRESS1").ToString()
                    postaladdress.AppendChild(postbox)

                    Dim streetname As XmlElement
                    streetname = strXML.CreateElement("StreetName", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    streetname.Prefix = "cbc"
                    streetname.InnerText = IIf(IsDBNull(dsEHFInfo.Tables(0).Rows(0)("SUBSIDIARYADDRESS2")), "0", dsEHFInfo.Tables(0).Rows(0)("SUBSIDIARYADDRESS2"))
                    postaladdress.AppendChild(streetname)

                    'Omit the tag
                    Dim buildingnumber As XmlElement
                    buildingnumber = strXML.CreateElement("BuildingNumber", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    buildingnumber.Prefix = "cbc"
                    buildingnumber.InnerText = "0" 'IIf(IsDBNull(dsEHFInfo.Tables(0).Rows(0)("SUBSIDIARYADDRESS2")), 0, dsEHFInfo.Tables(0).Rows(0)("SUBSIDIARYADDRESS2"))
                    postaladdress.AppendChild(buildingnumber)

                    Dim cityname As XmlElement
                    cityname = strXML.CreateElement("CityName", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    cityname.Prefix = "cbc"
                    cityname.InnerText = IIf(IsDBNull(dsEHFInfo.Tables(0).Rows(0)("SUBSIDIARYCITY")), 0, dsEHFInfo.Tables(0).Rows(0)("SUBSIDIARYCITY"))
                    postaladdress.AppendChild(cityname)

                    Dim postalzone As XmlElement
                    postalzone = strXML.CreateElement("PostalZone", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    postalzone.Prefix = "cbc"
                    postalzone.InnerText = IIf(IsDBNull(dsEHFInfo.Tables(0).Rows(0)("SUBSIDIARYZIPCODE")), 0, dsEHFInfo.Tables(0).Rows(0)("SUBSIDIARYZIPCODE"))
                    postaladdress.AppendChild(postalzone)

                    Dim country As XmlElement
                    country = strXML.CreateElement("Country", "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2")
                    country.Prefix = "cac"

                    Dim identificationcode As XmlElement
                    identificationcode = strXML.CreateElement("IdentificationCode", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    identificationcode.Prefix = "cbc"
                    identificationcode.SetAttribute("listID", "ISO3166-1:Alpha2")
                    identificationcode.InnerText = "NO" 'IIf(IsDBNull(dsEHFInfo.Tables(0).Rows(0)("SUBSIDIARYCITY")), 0, dsEHFInfo.Tables(0).Rows(0)("SUBSIDIARYCITY"))
                    country.AppendChild(identificationcode)
                    postaladdress.AppendChild(country)

                    Dim partytaxscheme As XmlElement
                    partytaxscheme = strXML.CreateElement("PartyTaxScheme", "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2")
                    partytaxscheme.Prefix = "cac"

                    Dim companyidtax As XmlElement
                    companyidtax = strXML.CreateElement("CompanyID", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    companyidtax.Prefix = "cbc"
                    companyidtax.SetAttribute("schemeID", "NO:VAT")
                    companyidtax.InnerText = dsEHFInfo.Tables(0).Rows(0)("SUBSIDIARYORGANIZATIONNO").ToString().Trim() + "MVA"
                    '"999999999MVA" 
                    partytaxscheme.AppendChild(companyidtax)

                    Dim taxscheme As XmlElement
                    taxscheme = strXML.CreateElement("TaxScheme", "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2")
                    taxscheme.Prefix = "cac"

                    Dim vatid As XmlElement
                    vatid = strXML.CreateElement("ID", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    vatid.Prefix = "cbc"
                    vatid.InnerText = "VAT" 'IIf(IsDBNull(dsEHFInfo.Tables(0).Rows(0)("SUBSIDIARYCITY")), 0, dsEHFInfo.Tables(0).Rows(0)("SUBSIDIARYCITY"))
                    taxscheme.AppendChild(vatid)
                    partytaxscheme.AppendChild(taxscheme)


                    Dim partylegalentity As XmlElement
                    partylegalentity = strXML.CreateElement("PartyLegalEntity", "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2")
                    partylegalentity.Prefix = "cac"

                    Dim registrationname As XmlElement
                    registrationname = strXML.CreateElement("RegistrationName", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    registrationname.Prefix = "cbc"
                    registrationname.InnerText = dsEHFInfo.Tables(0).Rows(0)("SUBSIDIARYNAME").ToString()
                    partylegalentity.AppendChild(registrationname)

                    Dim companyidlegalentity As XmlElement
                    companyidlegalentity = strXML.CreateElement("CompanyID", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    companyidlegalentity.Prefix = "cbc"
                    companyidlegalentity.SetAttribute("schemeID", "NO:ORGNR")
                    companyidlegalentity.SetAttribute("schemeName", "Foretaksregisteret")
                    companyidlegalentity.InnerText = dsEHFInfo.Tables(0).Rows(0)("SUBSIDIARYORGANIZATIONNO").ToString().Trim()

                    partylegalentity.AppendChild(companyidlegalentity)

                    Dim contact As XmlElement
                    contact = strXML.CreateElement("Contact", "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2")
                    contact.Prefix = "cac"

                    Dim contactid As XmlElement
                    contactid = strXML.CreateElement("ID", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    contactid.Prefix = "cbc"
                    contactid.InnerText = dsEHFInfo.Tables(0).Rows(0)("SS_MGR_NAME").ToString()  ''Manager Name
                    contact.AppendChild(contactid)


                    party.AppendChild(partyname)
                    party.AppendChild(postaladdress)
                    party.AppendChild(partytaxscheme)
                    party.AppendChild(partylegalentity)
                    party.AppendChild(contact)
                    accountingsupplierparty.AppendChild(party)
                    root.AppendChild(accountingsupplierparty)

                    'AccountingCustomerParty
                    Dim accountingcustomerparty As XmlElement
                    accountingcustomerparty = strXML.CreateElement("AccountingCustomerParty", "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2")
                    accountingcustomerparty.Prefix = "cac"

                    Dim partycustomer As XmlElement
                    partycustomer = strXML.CreateElement("Party", "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2")
                    partycustomer.Prefix = "cac"

                    Dim partyidentification As XmlElement
                    partyidentification = strXML.CreateElement("PartyIdentification", "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2")
                    partyidentification.Prefix = "cac"

                    Dim customerpartyid As XmlElement
                    customerpartyid = strXML.CreateElement("ID", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    customerpartyid.Prefix = "cbc"
                    customerpartyid.SetAttribute("schemeID", "NO:VAT")
                    customerpartyid.InnerText = dsEHFInfo.Tables(0).Rows(0)("CUSTOMERID").ToString()
                    partyidentification.AppendChild(customerpartyid)

                    Dim partynameCustomer As XmlElement
                    partynameCustomer = strXML.CreateElement("PartyName", "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2")
                    partynameCustomer.Prefix = "cac"

                    Dim namecustomer As XmlElement
                    namecustomer = strXML.CreateElement("Name", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    namecustomer.Prefix = "cbc"
                    namecustomer.InnerText = dsEHFInfo.Tables(0).Rows(0)("CUSTOMERNAME").ToString()
                    partynameCustomer.AppendChild(namecustomer)


                    Dim customerpostaladdress As XmlElement
                    customerpostaladdress = strXML.CreateElement("PostalAddress", "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2")
                    customerpostaladdress.Prefix = "cac"


                    Dim customerstreetname As XmlElement
                    customerstreetname = strXML.CreateElement("StreetName", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    customerstreetname.Prefix = "cbc"
                    customerstreetname.InnerText = IIf(IsDBNull(dsEHFInfo.Tables(0).Rows(0)("CUSTOMERADDRESS1")), "0", dsEHFInfo.Tables(0).Rows(0)("CUSTOMERADDRESS1"))
                    customerpostaladdress.AppendChild(customerstreetname)

                    Dim customerbuildingnumber As XmlElement
                    customerbuildingnumber = strXML.CreateElement("BuildingNumber", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    customerbuildingnumber.Prefix = "cbc"
                    customerbuildingnumber.InnerText = IIf(IsDBNull(dsEHFInfo.Tables(0).Rows(0)("CUSTOMERADDRESS2")), 0, dsEHFInfo.Tables(0).Rows(0)("CUSTOMERADDRESS2"))
                    customerpostaladdress.AppendChild(customerbuildingnumber)

                    Dim customercityname As XmlElement
                    customercityname = strXML.CreateElement("CityName", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    customercityname.Prefix = "cbc"
                    customercityname.InnerText = IIf(IsDBNull(dsEHFInfo.Tables(0).Rows(0)("CUSTOMERCITY")), 0, dsEHFInfo.Tables(0).Rows(0)("CUSTOMERCITY"))
                    customerpostaladdress.AppendChild(customercityname)

                    Dim customerpostalzone As XmlElement
                    customerpostalzone = strXML.CreateElement("PostalZone", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    customerpostalzone.Prefix = "cbc"
                    customerpostalzone.InnerText = IIf(IsDBNull(dsEHFInfo.Tables(0).Rows(0)("CUSTOMERZIPCODE")), 0, dsEHFInfo.Tables(0).Rows(0)("CUSTOMERZIPCODE"))
                    customerpostaladdress.AppendChild(customerpostalzone)

                    Dim customercountry As XmlElement
                    customercountry = strXML.CreateElement("Country", "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2")
                    customercountry.Prefix = "cac"

                    Dim customeridentificationcode As XmlElement
                    customeridentificationcode = strXML.CreateElement("IdentificationCode", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    customeridentificationcode.Prefix = "cbc"
                    customeridentificationcode.SetAttribute("listID", "ISO3166-1:Alpha2")
                    customeridentificationcode.InnerText = "NO" 'IIf(IsDBNull(dsEHFInfo.Tables(0).Rows(0)("SUBSIDIARYCITY")), 0, dsEHFInfo.Tables(0).Rows(0)("SUBSIDIARYCITY"))
                    customercountry.AppendChild(customeridentificationcode)
                    customerpostaladdress.AppendChild(customercountry)


                    Dim customerpartylegalentity As XmlElement
                    customerpartylegalentity = strXML.CreateElement("PartyLegalEntity", "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2")
                    customerpartylegalentity.Prefix = "cac"

                    Dim custcompanyidlegalentity As XmlElement
                    custcompanyidlegalentity = strXML.CreateElement("CompanyID", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    custcompanyidlegalentity.Prefix = "cbc"
                    custcompanyidlegalentity.SetAttribute("schemeID", "NO:ORGNR")
                    custcompanyidlegalentity.InnerText = dsEHFInfo.Tables(0).Rows(0)("CUST_COMPANY_NO").ToString().Trim() ''Cust_company_no 
                    customerpartylegalentity.AppendChild(custcompanyidlegalentity)


                    Dim custcontact As XmlElement
                    custcontact = strXML.CreateElement("Contact", "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2")
                    custcontact.Prefix = "cac"

                    Dim custcontactid As XmlElement
                    custcontactid = strXML.CreateElement("ID", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    custcontactid.Prefix = "cbc"
                    custcontactid.InnerText = dsEHFInfo.Tables(0).Rows(0)("CUST_CONTACT_PERSON").ToString() ''cust_contact_Person
                    custcontact.AppendChild(custcontactid)


                    partycustomer.AppendChild(partyidentification)
                    partycustomer.AppendChild(partynameCustomer)
                    partycustomer.AppendChild(customerpostaladdress)
                    partycustomer.AppendChild(customerpartylegalentity)
                    partycustomer.AppendChild(custcontact)
                    accountingcustomerparty.AppendChild(partycustomer)
                    root.AppendChild(accountingcustomerparty)


                    'Delivery
                    Dim delivery As XmlElement
                    delivery = strXML.CreateElement("Delivery", "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2")
                    delivery.Prefix = "cac"

                    Dim actualdeliverydate As XmlElement
                    actualdeliverydate = strXML.CreateElement("ActualDeliveryDate", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    actualdeliverydate.Prefix = "cbc"
                    actualdeliverydate.InnerText = dtInv 'dsEHFInfo.Tables(0).Rows(0)("INVOICEDATE").ToString()
                    delivery.AppendChild(actualdeliverydate)

                    Dim deliverylocation As XmlElement
                    deliverylocation = strXML.CreateElement("DeliveryLocation", "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2")
                    deliverylocation.Prefix = "cac"

                    Dim address As XmlElement
                    address = strXML.CreateElement("Address", "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2")
                    address.Prefix = "cac"


                    Dim delvstreetname As XmlElement
                    delvstreetname = strXML.CreateElement("StreetName", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    delvstreetname.Prefix = "cbc"
                    delvstreetname.InnerText = IIf(IsDBNull(dsEHFInfo.Tables(0).Rows(0)("CUSTOMERADDRESS1")), "", dsEHFInfo.Tables(0).Rows(0)("CUSTOMERADDRESS1"))
                    address.AppendChild(delvstreetname)

                    Dim delvbuildingnumber As XmlElement
                    delvbuildingnumber = strXML.CreateElement("BuildingNumber", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    delvbuildingnumber.Prefix = "cbc"
                    delvbuildingnumber.InnerText = IIf(IsDBNull(dsEHFInfo.Tables(0).Rows(0)("CUSTOMERADDRESS2")), "", dsEHFInfo.Tables(0).Rows(0)("CUSTOMERADDRESS2"))
                    address.AppendChild(delvbuildingnumber)

                    Dim delvcityname As XmlElement
                    delvcityname = strXML.CreateElement("CityName", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    delvcityname.Prefix = "cbc"
                    delvcityname.InnerText = dsEHFInfo.Tables(0).Rows(0)("CUSTOMERCITY").ToString()
                    address.AppendChild(delvcityname)

                    Dim delvpostalzone As XmlElement
                    delvpostalzone = strXML.CreateElement("PostalZone", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    delvpostalzone.Prefix = "cbc"
                    delvpostalzone.InnerText = dsEHFInfo.Tables(0).Rows(0)("CUSTOMERZIPCODE").ToString()
                    address.AppendChild(delvpostalzone)

                    Dim delvcountry As XmlElement
                    delvcountry = strXML.CreateElement("Country", "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2")
                    delvcountry.Prefix = "cac"

                    Dim delvidentificationcode As XmlElement
                    delvidentificationcode = strXML.CreateElement("IdentificationCode", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    delvidentificationcode.Prefix = "cbc"
                    delvidentificationcode.SetAttribute("listID", "ISO3166-1:Alpha2")
                    delvidentificationcode.InnerText = "NO" 'IIf(IsDBNull(dsEHFInfo.Tables(0).Rows(0)("SUBSIDIARYCITY")), 0, dsEHFInfo.Tables(0).Rows(0)("SUBSIDIARYCITY"))
                    delvcountry.AppendChild(delvidentificationcode)
                    address.AppendChild(delvcountry)


                    deliverylocation.AppendChild(address)
                    delivery.AppendChild(deliverylocation)
                    root.AppendChild(delivery)
                    ' Next

                    'Creating Child Element of PaymentMeans
                    Dim paymentmeans As XmlElement
                    paymentmeans = strXML.CreateElement("PaymentMeans", "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2")
                    paymentmeans.Prefix = "cac"

                    Dim paymentmeanscode As XmlElement
                    paymentmeanscode = strXML.CreateElement("PaymentMeansCode", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    paymentmeanscode.Prefix = "cbc"
                    paymentmeanscode.InnerText = "31"
                    paymentmeanscode.SetAttribute("listID", "UNCL4461")
                    paymentmeans.AppendChild(paymentmeanscode)

                    Dim paymentduedate As XmlElement
                    Dim ddatestr As String
                    Dim ddate As Date
                    paymentduedate = strXML.CreateElement("PaymentDueDate", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    paymentduedate.Prefix = "cbc"
                    ddate = CDate(IIf(IsDBNull(dsEHFInfo.Tables(0).Rows(0)("DUEDATE")), "", dsEHFInfo.Tables(0).Rows(0)("DUEDATE")))
                    ddatestr = ddate.ToString("yyyy-MM-dd")
                    paymentduedate.InnerText = ddatestr
                    paymentmeans.AppendChild(paymentduedate)

                    Dim paymentid As XmlElement
                    paymentid = strXML.CreateElement("PaymentID", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    paymentid.Prefix = "cbc"
                    paymentid.InnerText = "0"
                    paymentmeans.AppendChild(paymentid)

                    Dim payeefinancialaccount As XmlElement
                    payeefinancialaccount = strXML.CreateElement("PayeeFinancialAccount", "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2")
                    payeefinancialaccount.Prefix = "cac"

                    Dim payeefinancialaccountid As XmlElement
                    payeefinancialaccountid = strXML.CreateElement("ID", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    payeefinancialaccountid.Prefix = "cbc"
                    payeefinancialaccountid.InnerText = "1111"
                    payeefinancialaccountid.SetAttribute("schemeID", "BBAN")
                    payeefinancialaccount.AppendChild(payeefinancialaccountid)

                    paymentmeans.AppendChild(payeefinancialaccount)
                    root.AppendChild(paymentmeans)


                    'Creating Child Element of TaxTotal
                    Dim dtEHFInfo As DataTable
                    Dim dtEHFInfoOwnRisk As DataTable
                    Dim dv As DataView
                    Dim dvOR As DataView
                    dtEHFInfo = dsEHFInfo.Tables(0)
                    dv = dtEHFInfo.DefaultView
                    dv.RowFilter = "VATTYPE = 'S'"
                    dtEHFInfo = dv.ToTable

                    dtEHFInfoOwnRisk = dsEHFInfo.Tables(0)
                    dvOR = dtEHFInfoOwnRisk.DefaultView
                    dvOR.RowFilter = "VATTYPE = 'E'"
                    dtEHFInfoOwnRisk = dvOR.ToTable

                    Dim taxtotal As XmlElement
                    taxtotal = strXML.CreateElement("TaxTotal", "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2")
                    taxtotal.Prefix = "cac"

                    Dim taxamount As XmlElement
                    taxamount = strXML.CreateElement("TaxAmount", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    taxamount.Prefix = "cbc"
                    taxamount.InnerText = objCommonUtil.GetDefaultLangNoFormat("English", IIf(IsDBNull(dsEHFInfo.Tables(0).Rows(0)("TOFINDVAT")), "0", dsEHFInfo.Tables(0).Rows(0)("TOFINDVAT")))
                    taxamount.SetAttribute("currencyID", dsEHFInfo.Tables(0).Rows(0)("CURRENCY_CODE"))
                    taxtotal.AppendChild(taxamount)


                    If dtEHFInfo.Rows.Count > 0 Then


                        Dim taxsubtotal As XmlElement
                        taxsubtotal = strXML.CreateElement("TaxSubtotal", "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2")
                        taxsubtotal.Prefix = "cac"

                        Dim taxableamount As XmlElement
                        taxableamount = strXML.CreateElement("TaxableAmount", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                        taxableamount.Prefix = "cbc"
                        taxableamount.InnerText = objCommonUtil.GetDefaultLangNoFormat("English", IIf(IsDBNull(dtEHFInfo.Rows(0)("VATCALCULATEDFROM")), "0", dtEHFInfo.Rows(0)("VATCALCULATEDFROM"))) 'IIf(IsDBNull(dsEHFInfo.Tables(0).Rows(0)("VATCALCULATEDFROM")), "0", dsEHFInfo.Tables(0).Rows(0)("VATCALCULATEDFROM"))
                        taxableamount.SetAttribute("currencyID", dtEHFInfo.Rows(0)("CURRENCY_CODE"))
                        taxsubtotal.AppendChild(taxableamount)

                        Dim tsubtaxamount As XmlElement
                        tsubtaxamount = strXML.CreateElement("TaxAmount", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                        tsubtaxamount.Prefix = "cbc"
                        tsubtaxamount.InnerText = objCommonUtil.GetDefaultLangNoFormat("English", IIf(IsDBNull(dtEHFInfo.Rows(0)("TOFINDVAT")), "0", dtEHFInfo.Rows(0)("TOFINDVAT"))) 'IIf(IsDBNull(dsEHFInfo.Tables(0).Rows(0)("TOFINDVAT")), "0", dsEHFInfo.Tables(0).Rows(0)("TOFINDVAT"))
                        tsubtaxamount.SetAttribute("currencyID", dtEHFInfo.Rows(0)("CURRENCY_CODE"))
                        taxsubtotal.AppendChild(tsubtaxamount)

                        Dim taxcategory As XmlElement
                        taxcategory = strXML.CreateElement("TaxCategory", "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2")
                        taxcategory.Prefix = "cac"

                        Dim taxcatgid As XmlElement
                        taxcatgid = strXML.CreateElement("ID", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                        taxcatgid.Prefix = "cbc"
                        taxcatgid.InnerText = "S"
                        taxcatgid.SetAttribute("schemeID", "UNCL5305")
                        taxcategory.AppendChild(taxcatgid)

                        Dim taxpercent As XmlElement
                        taxpercent = strXML.CreateElement("Percent", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                        taxpercent.Prefix = "cbc"
                        taxpercent.InnerText = objCommonUtil.GetDefaultLangNoFormat("English", IIf(IsDBNull(dtEHFInfo.Rows(0)("VATPERCENTAGE")), "0", dtEHFInfo.Rows(0)("VATPERCENTAGE"))) 'IIf(IsDBNull(dsEHFInfo.Tables(0).Rows(0)("VATPER")), "0", dsEHFInfo.Tables(0).Rows(0)("VATPER"))
                        taxcategory.AppendChild(taxpercent)

                        Dim taxtottaxscheme As XmlElement
                        taxtottaxscheme = strXML.CreateElement("TaxScheme", "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2")
                        taxtottaxscheme.Prefix = "cac"

                        Dim taxschemeid As XmlElement
                        taxschemeid = strXML.CreateElement("ID", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                        taxschemeid.Prefix = "cbc"
                        taxschemeid.InnerText = "VAT"
                        taxtottaxscheme.AppendChild(taxschemeid)

                        taxcategory.AppendChild(taxtottaxscheme)
                        taxsubtotal.AppendChild(taxcategory)
                        taxtotal.AppendChild(taxsubtotal)

                    End If
                    'Ownrisk
                    If dtEHFInfoOwnRisk.Rows.Count > 0 Then
                        Dim taxsubtotalor As XmlElement
                        taxsubtotalor = strXML.CreateElement("TaxSubtotal", "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2")
                        taxsubtotalor.Prefix = "cac"

                        Dim taxableamountor As XmlElement
                        taxableamountor = strXML.CreateElement("TaxableAmount", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                        taxableamountor.Prefix = "cbc"
                        taxableamountor.InnerText = objCommonUtil.GetDefaultLangNoFormat("English", IIf(IsDBNull(dtEHFInfoOwnRisk.Rows(0)("OWNRISKAMOUNT")), "0", dtEHFInfoOwnRisk.Rows(0)("OWNRISKAMOUNT"))) 'IIf(IsDBNull(dsEHFInfo.Tables(0).Rows(0)("VATCALCULATEDFROM")), "0", dsEHFInfo.Tables(0).Rows(0)("VATCALCULATEDFROM"))
                        taxableamountor.SetAttribute("currencyID", dtEHFInfoOwnRisk.Rows(0)("CURRENCY_CODE"))
                        taxsubtotalor.AppendChild(taxableamountor)

                        Dim tsubtaxamountor As XmlElement
                        tsubtaxamountor = strXML.CreateElement("TaxAmount", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                        tsubtaxamountor.Prefix = "cbc"
                        tsubtaxamountor.InnerText = "0"
                        tsubtaxamountor.SetAttribute("currencyID", dtEHFInfoOwnRisk.Rows(0)("CURRENCY_CODE"))
                        taxsubtotalor.AppendChild(tsubtaxamountor)

                        Dim taxcategoryor As XmlElement
                        taxcategoryor = strXML.CreateElement("TaxCategory", "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2")
                        taxcategoryor.Prefix = "cac"

                        Dim taxcatgidor As XmlElement
                        taxcatgidor = strXML.CreateElement("ID", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                        taxcatgidor.Prefix = "cbc"
                        taxcatgidor.InnerText = "E"
                        taxcatgidor.SetAttribute("schemeID", "UNCL5305")
                        taxcategoryor.AppendChild(taxcatgidor)

                        Dim taxpercentor As XmlElement
                        taxpercentor = strXML.CreateElement("Percent", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                        taxpercentor.Prefix = "cbc"
                        taxpercentor.InnerText = "0" 'objCommonUtil.GetDefaultLangNoFormat("English", IIf(IsDBNull(dsEHFInfo.Tables(0).Rows(0)("VATPERCENTAGE")), "0", dsEHFInfo.Tables(0).Rows(0)("VATPERCENTAGE"))) 'IIf(IsDBNull(dsEHFInfo.Tables(0).Rows(0)("VATPER")), "0", dsEHFInfo.Tables(0).Rows(0)("VATPER"))
                        taxcategoryor.AppendChild(taxpercentor)

                        Dim taxexemptionreason As XmlElement
                        taxexemptionreason = strXML.CreateElement("TaxExemptionReason", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                        taxexemptionreason.Prefix = "cbc"
                        taxexemptionreason.InnerText = "OWNRISK" 'objCommonUtil.GetDefaultLangNoFormat("English", IIf(IsDBNull(dsEHFInfo.Tables(0).Rows(0)("VATPERCENTAGE")), "0", dsEHFInfo.Tables(0).Rows(0)("VATPERCENTAGE"))) 'IIf(IsDBNull(dsEHFInfo.Tables(0).Rows(0)("VATPER")), "0", dsEHFInfo.Tables(0).Rows(0)("VATPER"))
                        taxcategoryor.AppendChild(taxexemptionreason)

                        Dim taxtottaxschemeor As XmlElement
                        taxtottaxschemeor = strXML.CreateElement("TaxScheme", "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2")
                        taxtottaxschemeor.Prefix = "cac"

                        Dim taxschemeidor As XmlElement
                        taxschemeidor = strXML.CreateElement("ID", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                        taxschemeidor.Prefix = "cbc"
                        taxschemeidor.InnerText = "VAT"
                        taxtottaxschemeor.AppendChild(taxschemeidor)

                        taxcategoryor.AppendChild(taxtottaxschemeor)
                        taxsubtotalor.AppendChild(taxcategoryor)
                        taxtotal.AppendChild(taxsubtotalor)
                    End If

                    root.AppendChild(taxtotal)


                    'Creating Child Element of LegalMonetaryTotal
                    Dim legalmonetarytotal As XmlElement
                    legalmonetarytotal = strXML.CreateElement("LegalMonetaryTotal", "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2")
                    legalmonetarytotal.Prefix = "cac"

                    Dim lmlineextensionamount As XmlElement
                    lmlineextensionamount = strXML.CreateElement("LineExtensionAmount", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    lmlineextensionamount.Prefix = "cbc"
                    lmlineextensionamount.InnerText = objCommonUtil.GetDefaultLangNoFormat("English", IIf(IsDBNull(dsEHFInfo.Tables(0).Rows(0)("INVOICESUM")), "0", dsEHFInfo.Tables(0).Rows(0)("INVOICESUM"))) 'IIf(IsDBNull(dsEHFInfo.Tables(0).Rows(0)("INVOICESUM")), "0", dsEHFInfo.Tables(0).Rows(0)("INVOICESUM"))
                    lmlineextensionamount.SetAttribute("currencyID", dsEHFInfo.Tables(0).Rows(0)("CURRENCY_CODE"))
                    legalmonetarytotal.AppendChild(lmlineextensionamount)

                    Dim taxexclusiveamount As XmlElement
                    taxexclusiveamount = strXML.CreateElement("TaxExclusiveAmount", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    taxexclusiveamount.Prefix = "cbc"
                    taxexclusiveamount.InnerText = objCommonUtil.GetDefaultLangNoFormat("English", IIf(IsDBNull(dsEHFInfo.Tables(0).Rows(0)("INVOICESUM")), "0", dsEHFInfo.Tables(0).Rows(0)("INVOICESUM"))) 'IIf(IsDBNull(dsEHFInfo.Tables(0).Rows(0)("INVOICESUM")), "0", dsEHFInfo.Tables(0).Rows(0)("INVOICESUM"))
                    taxexclusiveamount.SetAttribute("currencyID", dsEHFInfo.Tables(0).Rows(0)("CURRENCY_CODE"))
                    legalmonetarytotal.AppendChild(taxexclusiveamount)

                    Dim taxinclusiveamount As XmlElement
                    taxinclusiveamount = strXML.CreateElement("TaxInclusiveAmount", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    taxinclusiveamount.Prefix = "cbc"
                    taxinclusiveamount.InnerText = objCommonUtil.GetDefaultLangNoFormat("English", IIf(IsDBNull(dsEHFInfo.Tables(0).Rows(0)("ROUNDEDTOTAL")), "0", dsEHFInfo.Tables(0).Rows(0)("ROUNDEDTOTAL"))) 'IIf(IsDBNull(dsEHFInfo.Tables(0).Rows(0)("ROUNDEDTOTAL")), "0", dsEHFInfo.Tables(0).Rows(0)("ROUNDEDTOTAL"))
                    taxinclusiveamount.SetAttribute("currencyID", dsEHFInfo.Tables(0).Rows(0)("CURRENCY_CODE"))
                    legalmonetarytotal.AppendChild(taxinclusiveamount)

                    Dim allowancetotalamount As XmlElement
                    allowancetotalamount = strXML.CreateElement("AllowanceTotalAmount", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    allowancetotalamount.Prefix = "cbc"
                    allowancetotalamount.InnerText = "0"
                    allowancetotalamount.SetAttribute("currencyID", dsEHFInfo.Tables(0).Rows(0)("CURRENCY_CODE"))
                    legalmonetarytotal.AppendChild(allowancetotalamount)

                    Dim chargetotalamount As XmlElement
                    chargetotalamount = strXML.CreateElement("ChargeTotalAmount", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    chargetotalamount.Prefix = "cbc"
                    chargetotalamount.InnerText = "0"
                    chargetotalamount.SetAttribute("currencyID", dsEHFInfo.Tables(0).Rows(0)("CURRENCY_CODE"))
                    legalmonetarytotal.AppendChild(chargetotalamount)

                    Dim prepaidamount As XmlElement
                    prepaidamount = strXML.CreateElement("PrepaidAmount", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    prepaidamount.Prefix = "cbc"
                    prepaidamount.InnerText = "0"
                    prepaidamount.SetAttribute("currencyID", dsEHFInfo.Tables(0).Rows(0)("CURRENCY_CODE"))
                    legalmonetarytotal.AppendChild(prepaidamount)

                    Dim payableroundingamount As XmlElement
                    payableroundingamount = strXML.CreateElement("PayableRoundingAmount", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    payableroundingamount.Prefix = "cbc"
                    payableroundingamount.InnerText = objCommonUtil.GetDefaultLangNoFormat("English", IIf(IsDBNull(dsEHFInfo.Tables(0).Rows(0)("ROUNDINGAMT")), "0", dsEHFInfo.Tables(0).Rows(0)("ROUNDINGAMT"))) 'dsEHFInfo.Tables(0).Rows(0)("ROUNDINGAMT")
                    payableroundingamount.SetAttribute("currencyID", dsEHFInfo.Tables(0).Rows(0)("CURRENCY_CODE"))
                    legalmonetarytotal.AppendChild(payableroundingamount)

                    Dim payableamount As XmlElement
                    payableamount = strXML.CreateElement("PayableAmount", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                    payableamount.Prefix = "cbc"
                    payableamount.InnerText = objCommonUtil.GetDefaultLangNoFormat("English", IIf(IsDBNull(dsEHFInfo.Tables(0).Rows(0)("ROUNDEDTOTAL")), "0", dsEHFInfo.Tables(0).Rows(0)("ROUNDEDTOTAL"))) 'dsEHFInfo.Tables(0).Rows(0)("ROUNDEDTOTAL")
                    payableamount.SetAttribute("currencyID", dsEHFInfo.Tables(0).Rows(0)("CURRENCY_CODE"))
                    legalmonetarytotal.AppendChild(payableamount)
                    root.AppendChild(legalmonetarytotal)


                    'Invoice Line
                    For i As Integer = 0 To dsEHFInfo.Tables(0).Rows.Count - 1
                        'Creating Child Element of Invoice
                        Dim invoiceline As XmlElement
                        invoiceline = strXML.CreateElement("InvoiceLine", "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2")
                        invoiceline.Prefix = "cac"

                        Dim invoicelineid As XmlElement
                        invoicelineid = strXML.CreateElement("ID", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                        invoicelineid.Prefix = "cbc"
                        invoicelineid.InnerText = (i + 1).ToString()
                        invoiceline.AppendChild(invoicelineid)

                        Dim invoicedquantity As XmlElement
                        invoicedquantity = strXML.CreateElement("InvoicedQuantity", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                        invoicedquantity.Prefix = "cbc"
                        invoicedquantity.SetAttribute("unitCode", "NMP")
                        invoicedquantity.SetAttribute("unitCodeListID", "UNECERec20")
                        invoicedquantity.InnerText = objCommonUtil.GetDefaultLangNoFormat("English", IIf(IsDBNull(dsEHFInfo.Tables(0).Rows(i)("DELIVEREDQTY/TIME")), "0", dsEHFInfo.Tables(0).Rows(i)("DELIVEREDQTY/TIME"))) 'dsEHFInfo.Tables(0).Rows(i)("DELIVEREDQTY/TIME")
                        invoiceline.AppendChild(invoicedquantity)

                        Dim lineextensionamount As XmlElement
                        lineextensionamount = strXML.CreateElement("LineExtensionAmount", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                        lineextensionamount.Prefix = "cbc"
                        lineextensionamount.SetAttribute("currencyID", dsEHFInfo.Tables(0).Rows(0)("CURRENCY_CODE"))
                        lineextensionamount.InnerText = objCommonUtil.GetDefaultLangNoFormat("English", IIf(IsDBNull(dsEHFInfo.Tables(0).Rows(i)("TOTALAMOUNT")), "0", dsEHFInfo.Tables(0).Rows(i)("TOTALAMOUNT"))) 'dsEHFInfo.Tables(0).Rows(i)("TOTALAMOUNT")
                        invoiceline.AppendChild(lineextensionamount)

                        Dim accountingcost As XmlElement
                        accountingcost = strXML.CreateElement("AccountingCost", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                        accountingcost.Prefix = "cbc"
                        accountingcost.InnerText = objCommonUtil.GetDefaultLangNoFormat("English", IIf(IsDBNull(dsEHFInfo.Tables(0).Rows(i)("COST_PRICE1")), "0", dsEHFInfo.Tables(0).Rows(i)("COST_PRICE1"))) 'dsEHFInfo.Tables(0).Rows(i)("COST_PRICE1")
                        invoiceline.AppendChild(accountingcost)

                        Dim orderlinereference As XmlElement
                        orderlinereference = strXML.CreateElement("OrderLineReference", "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2")
                        orderlinereference.Prefix = "cac"

                        Dim lineid As XmlElement
                        lineid = strXML.CreateElement("LineID", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                        lineid.Prefix = "cbc"
                        lineid.InnerText = dsEHFInfo.Tables(0).Rows(i)("WORKORDERPREFIX") + dsEHFInfo.Tables(0).Rows(i)("WORKORDERNO") + "-" + dsEHFInfo.Tables(0).Rows(i)("SPAREPARTNO/LABOURID")
                        orderlinereference.AppendChild(lineid)
                        invoiceline.AppendChild(orderlinereference)


                        'Dim invltaxtotal As XmlElement
                        'invltaxtotal = strXML.CreateElement("TaxTotal", "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2")
                        'invltaxtotal.Prefix = "cac"

                        'Dim invltaxamount As XmlElement
                        'invltaxamount = strXML.CreateElement("TaxAmount", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                        'invltaxamount.Prefix = "cbc"
                        'invltaxamount.InnerText = objCommonUtil.GetDefaultLangNoFormat("English", IIf(IsDBNull(dsEHFInfo.Tables(0).Rows(i)("VATAM0UNT")), "0", dsEHFInfo.Tables(0).Rows(i)("VATAM0UNT"))) 'dsEHFInfo.Tables(0).Rows(i)("VATAM0UNT")
                        'invltaxamount.SetAttribute("currencyID", dsEHFInfo.Tables(0).Rows(i)("CURRENCY_CODE"))
                        'invltaxtotal.AppendChild(invltaxamount)
                        'invoiceline.AppendChild(invltaxtotal)

                        Dim allowancecharge As XmlElement
                        allowancecharge = strXML.CreateElement("AllowanceCharge", "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2")
                        allowancecharge.Prefix = "cac"

                        Dim chargeindicator As XmlElement
                        chargeindicator = strXML.CreateElement("ChargeIndicator", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                        chargeindicator.Prefix = "cbc"
                        chargeindicator.InnerText = "false"
                        allowancecharge.AppendChild(chargeindicator)

                        Dim allowancechargereason As XmlElement
                        allowancechargereason = strXML.CreateElement("AllowanceChargeReason", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                        allowancechargereason.Prefix = "cbc"
                        allowancechargereason.InnerText = objCommonUtil.GetDefaultLangNoFormat("English", IIf(IsDBNull(dsEHFInfo.Tables(0).Rows(i)("DISCOUNT")), "0", dsEHFInfo.Tables(0).Rows(i)("DISCOUNT"))).ToString() + "% Rabatt"
                        allowancecharge.AppendChild(allowancechargereason)

                        Dim amount As XmlElement
                        amount = strXML.CreateElement("Amount", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                        amount.Prefix = "cbc"
                        amount.InnerText = objCommonUtil.GetDefaultLangNoFormat("English", IIf(IsDBNull(dsEHFInfo.Tables(0).Rows(i)("LINE_DISCOUNT")), "0", dsEHFInfo.Tables(0).Rows(i)("LINE_DISCOUNT"))) 'dsEHFInfo.Tables(0).Rows(i)("LINE_DISCOUNT")
                        amount.SetAttribute("currencyID", dsEHFInfo.Tables(0).Rows(i)("CURRENCY_CODE"))
                        allowancecharge.AppendChild(amount)


                        invoiceline.AppendChild(allowancecharge)



                        Dim item As XmlElement
                        item = strXML.CreateElement("Item", "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2")
                        item.Prefix = "cac"

                        Dim iname As XmlElement
                        iname = strXML.CreateElement("Name", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                        iname.Prefix = "cbc"
                        iname.InnerText = dsEHFInfo.Tables(0).Rows(i)("SPAREPARTNAME/LABOUR")
                        item.AppendChild(iname)

                        Dim sellersitemidentification As XmlElement
                        sellersitemidentification = strXML.CreateElement("SellersItemIdentification", "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2")
                        sellersitemidentification.Prefix = "cac"

                        Dim sellersitemidentificationid As XmlElement
                        sellersitemidentificationid = strXML.CreateElement("ID", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                        sellersitemidentificationid.Prefix = "cbc"
                        sellersitemidentificationid.InnerText = dsEHFInfo.Tables(0).Rows(i)("SPAREPARTNO/LABOURID")
                        sellersitemidentification.AppendChild(sellersitemidentificationid)
                        item.AppendChild(sellersitemidentification)

                        Dim classifiedtaxcategory As XmlElement
                        classifiedtaxcategory = strXML.CreateElement("ClassifiedTaxCategory", "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2")
                        classifiedtaxcategory.Prefix = "cac"

                        Dim classifiedtaxcategoryid As XmlElement
                        classifiedtaxcategoryid = strXML.CreateElement("ID", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                        classifiedtaxcategoryid.Prefix = "cbc"
                        classifiedtaxcategoryid.InnerText = dsEHFInfo.Tables(0).Rows(i)("VATTYPE")
                        classifiedtaxcategoryid.SetAttribute("schemeID", "UNCL5305")
                        classifiedtaxcategory.AppendChild(classifiedtaxcategoryid)

                        Dim percent As XmlElement
                        percent = strXML.CreateElement("Percent", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                        percent.Prefix = "cbc"
                        percent.InnerText = objCommonUtil.GetDefaultLangNoFormat("English", IIf(IsDBNull(dsEHFInfo.Tables(0).Rows(i)("LINE_VAT_PERCENTAGE")), "0", dsEHFInfo.Tables(0).Rows(i)("LINE_VAT_PERCENTAGE"))) 'dsEHFInfo.Tables(0).Rows(i)("VATPERCENTAGE")
                        classifiedtaxcategory.AppendChild(percent)

                        Dim invltaxscheme As XmlElement
                        invltaxscheme = strXML.CreateElement("TaxScheme", "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2")
                        invltaxscheme.Prefix = "cac"

                        Dim invltaxschemeid As XmlElement
                        invltaxschemeid = strXML.CreateElement("ID", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                        invltaxschemeid.Prefix = "cbc"
                        invltaxschemeid.InnerText = "VAT"
                        invltaxscheme.AppendChild(invltaxschemeid)

                        classifiedtaxcategory.AppendChild(invltaxscheme)
                        item.AppendChild(classifiedtaxcategory)
                        invoiceline.AppendChild(item)

                        Dim price As XmlElement
                        price = strXML.CreateElement("Price", "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2")
                        price.Prefix = "cac"

                        'Amount per line
                        Dim priceamount As XmlElement
                        priceamount = strXML.CreateElement("PriceAmount", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2")
                        priceamount.Prefix = "cbc"
                        priceamount.InnerText = objCommonUtil.GetDefaultLangNoFormat("English", IIf(IsDBNull(dsEHFInfo.Tables(0).Rows(i)("PRICE")), "0", dsEHFInfo.Tables(0).Rows(i)("PRICE"))) 'dsEHFInfo.Tables(0).Rows(i)("PRICE")
                        priceamount.SetAttribute("currencyID", dsEHFInfo.Tables(0).Rows(i)("CURRENCY_CODE"))
                        price.AppendChild(priceamount)

                        invoiceline.AppendChild(price)
                        root.AppendChild(invoiceline)

                    Next


                    'To create the file
                    If Not newlog.Exists() Then
                        newlog.Create()
                        logfilestream = File.Create(logfilepath)
                        logfilestream.Close()
                    Else
                        If File.Exists(logfilepath) Then
                            File.Delete(logfilepath)

                            newlog.Create()
                            logfilestream = File.Create(logfilepath)
                            logfilestream.Close()
                        End If
                    End If

                    'Now save/write the XML file into server root location
                    strXML.Save(logfilepath)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "GenXML", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return True
        End Function

     



    End Class
End Namespace




