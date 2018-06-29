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
Imports Microsoft.VisualBasic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports Microsoft.Practices.EnterpriseLibrary.Data.Sql
Imports System.Data.Common
Imports System.Windows.Forms
Namespace CARS.Services.WOHeader
    Public Class WOHeader
        Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
        Shared objWOHBO As New WOHeaderBO
        Shared objWOHDO As New CARS.WOHeader.WOHeaderDO
        Shared objConfigWODO As New CARS.ConfigWorkOrder.ConfigWorkOrderDO
        Shared objCommonUtil As New Utilities.CommonUtility
        Dim objMultiLangBO As New MultiLingualBO
        Dim objMultiLangDO As New MultiLingual.MultiLingualDO
        Public Function Fetch_WOH_OrderTypes() As List(Of WOHeaderBO)
            Dim details As New List(Of WOHeaderBO)()
            Dim dsWOHDetails As New DataSet
            Dim dtWOHDetails As New DataTable
            Try
                dsWOHDetails = objWOHDO.Fetch_WO_Config()
                If dsWOHDetails.Tables.Count > 0 Then
                    dtWOHDetails = dsWOHDetails.Tables(0)
                    For Each dtrow As DataRow In dtWOHDetails.Rows
                        Dim wohDet As New WOHeaderBO()
                        wohDet.Id_Settings = dtrow("Id_Settings").ToString()
                        wohDet.Description = dtrow("Description").ToString()
                        wohDet.WOCdate = dtrow("Cdate").ToString()
                        details.Add(wohDet)
                    Next
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOHeader", "Fetch_WOH_OrderTypes", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function Fetch_WOH_OrderStatus(ByVal OrdType As String, ByVal ScreenName As String) As List(Of WOHeaderBO)
            Dim details As New List(Of WOHeaderBO)()
            Dim dsWOHDetails As New DataSet
            Dim dsConfigStatus As New DataSet
            Dim dtWOHDetails As New DataTable
            Dim rStatus As DataRow
            Dim dtStatus As New DataTable
            Dim statusSett As String
            dtStatus.Columns.Add("ID_SETTINGS")
            dtStatus.Columns.Add("DESCRIPTION")
            Try
                objMultiLangBO.ScreenName = ScreenName
                objMultiLangBO.LangName = System.Configuration.ConfigurationManager.AppSettings("Language").ToString()
                dsWOHDetails = objMultiLangDO.GetScreenData(objMultiLangBO)
                If dsWOHDetails.Tables.Count > 0 Then
                    If dsWOHDetails.Tables(0).Rows.Count > 0 Then
                        dtWOHDetails = dsWOHDetails.Tables(0)
                    End If
                End If
                If OrdType = "ORD" Then
                    dtWOHDetails.DefaultView.RowFilter = "CTRL_VALUE='RES'"
                    rStatus = dtStatus.NewRow()
                    rStatus(0) = dtWOHDetails.DefaultView.Item(0).Item("CTRL_VALUE").ToString
                    rStatus(1) = dtWOHDetails.DefaultView.Item(0).Item("CAPTION").ToString
                    dtStatus.Rows.Add(rStatus)

                    dtWOHDetails.DefaultView.RowFilter = "CTRL_VALUE='CSA'"
                    rStatus = dtStatus.NewRow()
                    rStatus(0) = dtWOHDetails.DefaultView.Item(0).Item("CTRL_VALUE").ToString
                    rStatus(1) = dtWOHDetails.DefaultView.Item(0).Item("CAPTION").ToString
                    dtStatus.Rows.Add(rStatus)

                    dtWOHDetails.DefaultView.RowFilter = "CTRL_VALUE='JST'"
                    rStatus = dtStatus.NewRow()
                    rStatus(0) = dtWOHDetails.DefaultView.Item(0).Item("CTRL_VALUE").ToString
                    rStatus(1) = dtWOHDetails.DefaultView.Item(0).Item("CAPTION").ToString
                    dtStatus.Rows.Add(rStatus)

                    dtWOHDetails.DefaultView.RowFilter = "CTRL_VALUE='JCD'"
                    rStatus = dtStatus.NewRow()
                    rStatus(0) = dtWOHDetails.DefaultView.Item(0).Item("CTRL_VALUE").ToString
                    rStatus(1) = dtWOHDetails.DefaultView.Item(0).Item("CAPTION").ToString
                    dtStatus.Rows.Add(rStatus)

                    dtWOHDetails.DefaultView.RowFilter = "CTRL_VALUE='INV'"
                    rStatus = dtStatus.NewRow()
                    rStatus(0) = dtWOHDetails.DefaultView.Item(0).Item("CTRL_VALUE").ToString
                    rStatus(1) = dtWOHDetails.DefaultView.Item(0).Item("CAPTION").ToString
                    dtStatus.Rows.Add(rStatus)

                    dtWOHDetails.DefaultView.RowFilter = "CTRL_VALUE='PINV'"
                    rStatus = dtStatus.NewRow()
                    rStatus(0) = dtWOHDetails.DefaultView.Item(0).Item("CTRL_VALUE").ToString
                    rStatus(1) = dtWOHDetails.DefaultView.Item(0).Item("CAPTION").ToString
                    dtStatus.Rows.Add(rStatus)

                    dtWOHDetails.DefaultView.RowFilter = "CTRL_VALUE='DEL'"
                    rStatus = dtStatus.NewRow()
                    rStatus(0) = dtWOHDetails.DefaultView.Item(0).Item("CTRL_VALUE").ToString
                    rStatus(1) = dtWOHDetails.DefaultView.Item(0).Item("CAPTION").ToString
                    dtStatus.Rows.Add(rStatus)

                    dtWOHDetails.DefaultView.RowFilter = "CTRL_VALUE='RINV'"
                    rStatus = dtStatus.NewRow()
                    rStatus(0) = dtWOHDetails.DefaultView.Item(0).Item("CTRL_VALUE").ToString
                    rStatus(1) = dtWOHDetails.DefaultView.Item(0).Item("CAPTION").ToString
                    dtStatus.Rows.Add(rStatus)

                    dtWOHDetails.DefaultView.RowFilter = "CTRL_VALUE='RWRK'"
                    rStatus = dtStatus.NewRow()
                    rStatus(0) = dtWOHDetails.DefaultView.Item(0).Item("CTRL_VALUE").ToString
                    rStatus(1) = dtWOHDetails.DefaultView.Item(0).Item("CAPTION").ToString
                    dtStatus.Rows.Add(rStatus)
                ElseIf OrdType = "KRE" Then
                    dtWOHDetails.DefaultView.RowFilter = "CTRL_VALUE='RES'"
                    rStatus = dtStatus.NewRow()
                    rStatus(0) = dtWOHDetails.DefaultView.Item(0).Item("CTRL_VALUE").ToString
                    rStatus(1) = dtWOHDetails.DefaultView.Item(0).Item("CAPTION").ToString
                    dtStatus.Rows.Add(rStatus)

                    dtWOHDetails.DefaultView.RowFilter = "CTRL_VALUE='CSA'"
                    rStatus = dtStatus.NewRow()
                    rStatus(0) = dtWOHDetails.DefaultView.Item(0).Item("CTRL_VALUE").ToString
                    rStatus(1) = dtWOHDetails.DefaultView.Item(0).Item("CAPTION").ToString
                    dtStatus.Rows.Add(rStatus)

                    dtWOHDetails.DefaultView.RowFilter = "CTRL_VALUE='JST'"
                    rStatus = dtStatus.NewRow()
                    rStatus(0) = dtWOHDetails.DefaultView.Item(0).Item("CTRL_VALUE").ToString
                    rStatus(1) = dtWOHDetails.DefaultView.Item(0).Item("CAPTION").ToString
                    dtStatus.Rows.Add(rStatus)

                    dtWOHDetails.DefaultView.RowFilter = "CTRL_VALUE='JCD'"
                    rStatus = dtStatus.NewRow()
                    rStatus(0) = dtWOHDetails.DefaultView.Item(0).Item("CTRL_VALUE").ToString
                    rStatus(1) = dtWOHDetails.DefaultView.Item(0).Item("CAPTION").ToString
                    dtStatus.Rows.Add(rStatus)

                    dtWOHDetails.DefaultView.RowFilter = "CTRL_VALUE='INV'"
                    rStatus = dtStatus.NewRow()
                    rStatus(0) = dtWOHDetails.DefaultView.Item(0).Item("CTRL_VALUE").ToString
                    rStatus(1) = dtWOHDetails.DefaultView.Item(0).Item("CAPTION").ToString
                    dtStatus.Rows.Add(rStatus)

                    dtWOHDetails.DefaultView.RowFilter = "CTRL_VALUE='PINV'"
                    rStatus = dtStatus.NewRow()
                    rStatus(0) = dtWOHDetails.DefaultView.Item(0).Item("CTRL_VALUE").ToString
                    rStatus(1) = dtWOHDetails.DefaultView.Item(0).Item("CAPTION").ToString
                    dtStatus.Rows.Add(rStatus)

                    dtWOHDetails.DefaultView.RowFilter = "CTRL_VALUE='DEL'"
                    rStatus = dtStatus.NewRow()
                    rStatus(0) = dtWOHDetails.DefaultView.Item(0).Item("CTRL_VALUE").ToString
                    rStatus(1) = dtWOHDetails.DefaultView.Item(0).Item("CAPTION").ToString
                    dtStatus.Rows.Add(rStatus)

                    dtWOHDetails.DefaultView.RowFilter = "CTRL_VALUE='RINV'"
                    rStatus = dtStatus.NewRow()
                    rStatus(0) = dtWOHDetails.DefaultView.Item(0).Item("CTRL_VALUE").ToString
                    rStatus(1) = dtWOHDetails.DefaultView.Item(0).Item("CAPTION").ToString
                    dtStatus.Rows.Add(rStatus)

                    dtWOHDetails.DefaultView.RowFilter = "CTRL_VALUE='RWRK'"
                    rStatus = dtStatus.NewRow()
                    rStatus(0) = dtWOHDetails.DefaultView.Item(0).Item("CTRL_VALUE").ToString
                    rStatus(1) = dtWOHDetails.DefaultView.Item(0).Item("CAPTION").ToString
                    dtStatus.Rows.Add(rStatus)
                End If

                For Each dtrow As DataRow In dtStatus.Rows
                    Dim wohDet As New WOHeaderBO()
                    wohDet.Id_Settings = dtrow("Id_Settings").ToString()
                    wohDet.Description = dtrow("Description").ToString()
                    details.Add(wohDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOHeader", "FetchWOStatus", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function FetchWOStatus(ByVal OrdType As String, ByVal ScreenName As String) As List(Of WOHeaderBO)
            Dim details As New List(Of WOHeaderBO)()
            Dim dsWOHDetails As New DataSet
            Dim dsConfigStatus As New DataSet
            Dim dtWOHDetails As New DataTable
            Dim rStatus As DataRow
            Dim dtStatus As New DataTable
            Dim statusSett As String
            dtStatus.Columns.Add("ID_SETTINGS")
            dtStatus.Columns.Add("DESCRIPTION")
            Try
                objMultiLangBO.ScreenName = ScreenName
                objMultiLangBO.LangName = System.Configuration.ConfigurationManager.AppSettings("Language").ToString()
                dsWOHDetails = objMultiLangDO.GetScreenData(objMultiLangBO)
                If dsWOHDetails.Tables.Count > 0 Then
                    If dsWOHDetails.Tables(0).Rows.Count > 0 Then
                        dtWOHDetails = dsWOHDetails.Tables(0)
                    End If
                End If
                If OrdType = "ORD" Then
                    dtWOHDetails.DefaultView.RowFilter = "CTRL_VALUE='RES'"
                    rStatus = dtStatus.NewRow()
                    rStatus(0) = dtWOHDetails.DefaultView.Item(0).Item("CTRL_VALUE").ToString
                    rStatus(1) = dtWOHDetails.DefaultView.Item(0).Item("CAPTION").ToString
                    dtStatus.Rows.Add(rStatus)

                    dtWOHDetails.DefaultView.RowFilter = "CTRL_VALUE='CSA'"
                    rStatus = dtStatus.NewRow()
                    rStatus(0) = dtWOHDetails.DefaultView.Item(0).Item("CTRL_VALUE").ToString
                    rStatus(1) = dtWOHDetails.DefaultView.Item(0).Item("CAPTION").ToString
                    dtStatus.Rows.Add(rStatus)

                    dtWOHDetails.DefaultView.RowFilter = "CTRL_VALUE='JST'"
                    rStatus = dtStatus.NewRow()
                    rStatus(0) = dtWOHDetails.DefaultView.Item(0).Item("CTRL_VALUE").ToString
                    rStatus(1) = dtWOHDetails.DefaultView.Item(0).Item("CAPTION").ToString
                    dtStatus.Rows.Add(rStatus)

                    dtWOHDetails.DefaultView.RowFilter = "CTRL_VALUE='JCD'"
                    rStatus = dtStatus.NewRow()
                    rStatus(0) = dtWOHDetails.DefaultView.Item(0).Item("CTRL_VALUE").ToString
                    rStatus(1) = dtWOHDetails.DefaultView.Item(0).Item("CAPTION").ToString
                    dtStatus.Rows.Add(rStatus)

                    dtWOHDetails.DefaultView.RowFilter = "CTRL_VALUE='INV'"
                    rStatus = dtStatus.NewRow()
                    rStatus(0) = dtWOHDetails.DefaultView.Item(0).Item("CTRL_VALUE").ToString
                    rStatus(1) = dtWOHDetails.DefaultView.Item(0).Item("CAPTION").ToString
                    dtStatus.Rows.Add(rStatus)

                    dtWOHDetails.DefaultView.RowFilter = "CTRL_VALUE='PINV'"
                    rStatus = dtStatus.NewRow()
                    rStatus(0) = dtWOHDetails.DefaultView.Item(0).Item("CTRL_VALUE").ToString
                    rStatus(1) = dtWOHDetails.DefaultView.Item(0).Item("CAPTION").ToString
                    dtStatus.Rows.Add(rStatus)

                    dtWOHDetails.DefaultView.RowFilter = "CTRL_VALUE='DEL'"
                    rStatus = dtStatus.NewRow()
                    rStatus(0) = dtWOHDetails.DefaultView.Item(0).Item("CTRL_VALUE").ToString
                    rStatus(1) = dtWOHDetails.DefaultView.Item(0).Item("CAPTION").ToString
                    dtStatus.Rows.Add(rStatus)

                    dtWOHDetails.DefaultView.RowFilter = "CTRL_VALUE='RINV'"
                    rStatus = dtStatus.NewRow()
                    rStatus(0) = dtWOHDetails.DefaultView.Item(0).Item("CTRL_VALUE").ToString
                    rStatus(1) = dtWOHDetails.DefaultView.Item(0).Item("CAPTION").ToString
                    dtStatus.Rows.Add(rStatus)

                    dtWOHDetails.DefaultView.RowFilter = "CTRL_VALUE='RWRK'"
                    rStatus = dtStatus.NewRow()
                    rStatus(0) = dtWOHDetails.DefaultView.Item(0).Item("CTRL_VALUE").ToString
                    rStatus(1) = dtWOHDetails.DefaultView.Item(0).Item("CAPTION").ToString
                    dtStatus.Rows.Add(rStatus)
                ElseIf OrdType = "KRE" Then
                    dtWOHDetails.DefaultView.RowFilter = "CTRL_VALUE='RES'"
                    rStatus = dtStatus.NewRow()
                    rStatus(0) = dtWOHDetails.DefaultView.Item(0).Item("CTRL_VALUE").ToString
                    rStatus(1) = dtWOHDetails.DefaultView.Item(0).Item("CAPTION").ToString
                    dtStatus.Rows.Add(rStatus)

                    dtWOHDetails.DefaultView.RowFilter = "CTRL_VALUE='CSA'"
                    rStatus = dtStatus.NewRow()
                    rStatus(0) = dtWOHDetails.DefaultView.Item(0).Item("CTRL_VALUE").ToString
                    rStatus(1) = dtWOHDetails.DefaultView.Item(0).Item("CAPTION").ToString
                    dtStatus.Rows.Add(rStatus)

                    dtWOHDetails.DefaultView.RowFilter = "CTRL_VALUE='JST'"
                    rStatus = dtStatus.NewRow()
                    rStatus(0) = dtWOHDetails.DefaultView.Item(0).Item("CTRL_VALUE").ToString
                    rStatus(1) = dtWOHDetails.DefaultView.Item(0).Item("CAPTION").ToString
                    dtStatus.Rows.Add(rStatus)

                    dtWOHDetails.DefaultView.RowFilter = "CTRL_VALUE='JCD'"
                    rStatus = dtStatus.NewRow()
                    rStatus(0) = dtWOHDetails.DefaultView.Item(0).Item("CTRL_VALUE").ToString
                    rStatus(1) = dtWOHDetails.DefaultView.Item(0).Item("CAPTION").ToString
                    dtStatus.Rows.Add(rStatus)

                    dtWOHDetails.DefaultView.RowFilter = "CTRL_VALUE='INV'"
                    rStatus = dtStatus.NewRow()
                    rStatus(0) = dtWOHDetails.DefaultView.Item(0).Item("CTRL_VALUE").ToString
                    rStatus(1) = dtWOHDetails.DefaultView.Item(0).Item("CAPTION").ToString
                    dtStatus.Rows.Add(rStatus)

                    dtWOHDetails.DefaultView.RowFilter = "CTRL_VALUE='PINV'"
                    rStatus = dtStatus.NewRow()
                    rStatus(0) = dtWOHDetails.DefaultView.Item(0).Item("CTRL_VALUE").ToString
                    rStatus(1) = dtWOHDetails.DefaultView.Item(0).Item("CAPTION").ToString
                    dtStatus.Rows.Add(rStatus)

                    dtWOHDetails.DefaultView.RowFilter = "CTRL_VALUE='DEL'"
                    rStatus = dtStatus.NewRow()
                    rStatus(0) = dtWOHDetails.DefaultView.Item(0).Item("CTRL_VALUE").ToString
                    rStatus(1) = dtWOHDetails.DefaultView.Item(0).Item("CAPTION").ToString
                    dtStatus.Rows.Add(rStatus)

                    dtWOHDetails.DefaultView.RowFilter = "CTRL_VALUE='RINV'"
                    rStatus = dtStatus.NewRow()
                    rStatus(0) = dtWOHDetails.DefaultView.Item(0).Item("CTRL_VALUE").ToString
                    rStatus(1) = dtWOHDetails.DefaultView.Item(0).Item("CAPTION").ToString
                    dtStatus.Rows.Add(rStatus)

                    dtWOHDetails.DefaultView.RowFilter = "CTRL_VALUE='RWRK'"
                    rStatus = dtStatus.NewRow()
                    rStatus(0) = dtWOHDetails.DefaultView.Item(0).Item("CTRL_VALUE").ToString
                    rStatus(1) = dtWOHDetails.DefaultView.Item(0).Item("CAPTION").ToString
                    dtStatus.Rows.Add(rStatus)
                End If


                dsConfigStatus = objConfigWODO.GetConfigWorkOrder(HttpContext.Current.Session("UserID"))

                If dsConfigStatus.Tables(0).Rows.Count > 0 Then
                    statusSett = dsConfigStatus.Tables(0).Rows(0)("WO_ID_SETTINGS").ToString
                End If
                For Each dtrow As DataRow In dtStatus.Rows
                    Dim wohDet As New WOHeaderBO()
                    wohDet.Id_Settings = dtrow("Id_Settings").ToString()
                    wohDet.Description = dtrow("Description").ToString()
                    wohDet.Tmp_Id_Settings = statusSett
                    details.Add(wohDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOHeader", "FetchWOStatus", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList

        End Function
        Public Function Fetch_WOH_Customer() As List(Of WOHeaderBO)
            Dim details As New List(Of WOHeaderBO)()
            Dim dsWOHDetails As New DataSet
            Dim dtWOHDetails As New DataTable
            Try
                dsWOHDetails = objWOHDO.Fetch_WO_Config()
                If dsWOHDetails.Tables.Count > 0 Then
                    If dsWOHDetails.Tables(2).Rows.Count > 0 Then
                        dtWOHDetails = dsWOHDetails.Tables(2)
                        For Each dtrow As DataRow In dtWOHDetails.Rows
                            Dim wohDet As New WOHeaderBO()
                            wohDet.Cust_ID = dtrow("ID_CUST").ToString()
                            wohDet.WO_Cust_Name = dtrow("CUST_NAME").ToString()
                            wohDet.Id_Cust_Group_Seq = Convert.ToInt32(dtrow("ID_CUST_GRP_SEQ").ToString())
                            wohDet.Cust_Group = dtrow("CUSG_DESCRIPTION").ToString()
                            wohDet.Cust_Description = dtrow("CUSTDESC").ToString()
                            wohDet.WO_Cust_Phone_Off = dtrow("OFF_PHONE").ToString()
                            wohDet.WO_Cust_Phone_Home = dtrow("HOME_PHONE").ToString()
                            wohDet.WO_Cust_Phone_Mobile = dtrow("MOBILE_PHONE").ToString()
                            wohDet.WO_Cust_Add1 = dtrow("PERM_ADD1").ToString()
                            wohDet.Cust_Perm_Add2 = dtrow("PERM_ADD2").ToString()
                            wohDet.Bill_Add1 = dtrow("BILL_ADD1").ToString()
                            wohDet.Bill_Add2 = dtrow("BILL_ADD2").ToString()
                            wohDet.Id_Zipcode_WO = dtrow("ZIPCODE").ToString()
                            details.Add(wohDet)
                        Next
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOHeader", "Fetch_WOH_Customer", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function Fetch_WOH_Vehicle(ByVal VehicleId As String) As List(Of WOHeaderBO)
            Dim details As New List(Of WOHeaderBO)()
            Dim dsWOHDetails As New DataSet
            Dim dtWOHDetails As New DataTable
            Dim objWOHeaderBO As New WOHeaderBO
            Dim dsConfigWorkOrder As New DataSet
            Try
                objWOHeaderBO.Id_Veh_Seq_WO = VehicleId
                dsWOHDetails = objWOHDO.Veh_Sel_Detail(objWOHeaderBO)
                HttpContext.Current.Session("MoreVehInfo") = dsWOHDetails
                objWOHeaderBO.Created_By = HttpContext.Current.Session("UserID")
                dsConfigWorkOrder = objConfigWODO.GetConfigWorkOrder(HttpContext.Current.Session("UserID"))
                If dsWOHDetails.Tables.Count > 0 Then
                    If dsWOHDetails.Tables(0).Rows.Count > 0 Then
                        dtWOHDetails = dsWOHDetails.Tables(0)

                        For Each dtrow As DataRow In dtWOHDetails.Rows
                            Dim wohDet As New WOHeaderBO()
                            Dim VACostPr, VASellPrice As String

                            If dsConfigWorkOrder.Tables(0).Rows.Count > 0 Then
                                If IIf(IsDBNull(dsConfigWorkOrder.Tables(0).Rows(0)("USE_DELV_ADDRESS")) = True, "", dsConfigWorkOrder.Tables(0).Rows(0)("USE_DELV_ADDRESS")) = "True" Then
                                    wohDet.PCountry = dtrow("BCOUNTRY").ToString()
                                    wohDet.PState = dtrow("BCity").ToString()
                                    wohDet.PZipcode = dtrow("BZipCode").ToString()
                                Else
                                    wohDet.PCountry = dtrow("PCOUNTRY").ToString()
                                    wohDet.PState = dtrow("PCity").ToString()
                                    wohDet.PZipcode = dtrow("PZipCode").ToString()
                                End If
                            End If

                            VACostPr = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(dtrow("COST_PRICE").ToString() = "", "0", dtrow("COST_PRICE").ToString()))
                            VASellPrice = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(dtrow("SELL_PRICE").ToString() = "", "0", dtrow("SELL_PRICE").ToString()))
                            wohDet.Id_Veh_Seq_WO = dtrow("ID_VEH_SEQ").ToString()
                            HttpContext.Current.Session("VEH_SEQ_NO") = dtrow("ID_VEH_SEQ").ToString()
                            wohDet.WO_Veh_Reg_NO = dtrow("VEH_REG_NO").ToString()
                            HttpContext.Current.Session("VEH_REG_NO") = dtrow("VEH_REG_NO").ToString()
                            wohDet.Veh_Int_No = dtrow("VEH_INTERN_NO").ToString()
                            wohDet.WO_Veh_Vin = dtrow("VEH_VIN").ToString()
                            wohDet.Id_Make = dtrow("VEH_MAKE_CODE").ToString()
                            wohDet.Id_Model = dtrow("ID_MODEL_VEH").ToString()
                            wohDet.Veh_Make = dtrow("MAKE").ToString()
                            wohDet.WO_Veh_Mileage = dtrow("VEH_MILEAGE").ToString()
                            wohDet.Van_Num = dtrow("VA_ORDER").ToString()
                            wohDet.VA_Cost_Price = Convert.ToDecimal(VACostPr)
                            wohDet.VA_Sell_Price = Convert.ToDecimal(VASellPrice)
                            wohDet.Veh_Grpdesc = dtrow("ID_GROUP_VEH").ToString()
                            wohDet.WO_Cust_Name = dtrow("CUST_NAME").ToString()
                            wohDet.Veh_OwnerName = dtrow("VEH_OWNER").ToString()
                            wohDet.Veh_Driver = dtrow("VEH_DRIVER").ToString()
                            wohDet.Veh_Phone1 = dtrow("VEH_PHONE1").ToString()
                            wohDet.Veh_Mobile = dtrow("VEH_MOBILE").ToString()
                            wohDet.Veh_Drv_Emailid = dtrow("VEH_DRV_IDEMIAL").ToString()
                            wohDet.Dt_Veh_Regn = objCommonUtil.GetCurrentLanguageDate(IIf(IsDBNull(dtrow("Dt_Veh_Ergn").ToString()) = True, "", dtrow("Dt_Veh_Ergn").ToString()))
                            'wohDet.Dt_Veh_Last_Regn = dtrow("LAST_REG_DATE").ToString()
                            wohDet.Dt_Veh_Last_Regn = objCommonUtil.GetCurrentLanguageDate(IIf(IsDBNull(dtrow("LAST_REG_DATE").ToString()) = True, "", dtrow("LAST_REG_DATE").ToString()))
                            wohDet.Veh_Srv_Type = IIf(IsDBNull(dtrow("ID_SER_TYP").ToString()) = True, "", dtrow("ID_SER_TYP").ToString())
                            'wohDet.Dt_Veh_Mil_Regn = dtrow("DT_VEH_MIL_REGN").ToString()
                            wohDet.Dt_Veh_Mil_Regn = objCommonUtil.GetCurrentLanguageDate(IIf(IsDBNull(dtrow("DT_VEH_MIL_REGN").ToString()) = True, "", dtrow("DT_VEH_MIL_REGN").ToString()))
                            wohDet.WO_Veh_Hrs = dtrow("VEH_HRS").ToString()
                            'wohDet.Dt_Veh_Hrs_Regn = dtrow("DT_VEH_HRS_ERGN").ToString()
                            wohDet.Dt_Veh_Mil_Regn = objCommonUtil.GetCurrentLanguageDate(IIf(IsDBNull(dtrow("DT_VEH_HRS_ERGN").ToString()) = True, "", dtrow("DT_VEH_HRS_ERGN").ToString()))
                            wohDet.Veh_Annot = IIf(IsDBNull(dtrow("VEH_ANNOT").ToString()) = True, "", dtrow("VEH_ANNOT").ToString())
                            wohDet.Id_Model_RP = IIf(IsDBNull(dtrow("ID_MODEL_RP").ToString()) = True, "", dtrow("ID_MODEL_RP").ToString())
                            wohDet.Cust_ID = dtrow("ID_CUSTOMER").ToString()
                            wohDet.WO_Cust_Name = dtrow("CUST_NAME").ToString()
                            wohDet.Cust_Contactperson = dtrow("Cust_Contact_Person").ToString()
                            wohDet.WO_Cust_Phone_Off = dtrow("CUST_PHONE_OFF").ToString()
                            wohDet.WO_Cust_Phone_Home = dtrow("CUST_PHONE_HOME").ToString()
                            wohDet.WO_Cust_Phone_Mobile = dtrow("CUST_PHONE_MOBILE").ToString()
                            wohDet.Cust_Fax = dtrow("CUST_FAX").ToString()
                            wohDet.Cust_Email = dtrow("CUST_ID_EMAIL").ToString()
                            wohDet.WO_Cust_Add1 = dtrow("CUST_PERM_ADD1").ToString()
                            wohDet.Cust_Perm_Add2 = dtrow("CUST_PERM_ADD2").ToString()
                            wohDet.Bill_Add1 = dtrow("CUST_BILL_ADD1").ToString()
                            wohDet.Bill_Add2 = dtrow("CUST_BILL_ADD2").ToString()
                            wohDet.Cust_Account_No = dtrow("CUST_ACCOUNT_NO").ToString()
                            'wohDet.Cust_Credit_Limit = dtrow("Cust_Credit_Limit").ToString()
                            wohDet.Cust_Credit_Limit = IIf((dtrow("Cust_Credit_Limit").ToString() = "") = True, 0, dtrow("Cust_Credit_Limit").ToString())
                            'wohDet.Id_Cust_Group_Seq = dtrow("CGROUP").ToString()
                            wohDet.Id_Cust_Group_Seq = IIf((dtrow("CGROUP").ToString() = "") = True, 0, dtrow("CGROUP").ToString())
                            wohDet.Pay_Term = dtrow("PayTerm").ToString()
                            wohDet.Pay_Type = dtrow("PayType").ToString()
                            'wohDet.Id_Pay_Terms_WO = dtrow("ID_Cust_Pay_Term").ToString()
                            wohDet.Id_Pay_Terms_WO = IIf((dtrow("ID_Cust_Pay_Term").ToString() = "") = True, 0, dtrow("ID_Cust_Pay_Term").ToString())
                            'wohDet.Id_Pay_Type_WO = dtrow("ID_CUST_PAY_TYPE").ToString()
                            wohDet.Id_Pay_Type_WO = IIf((dtrow("ID_CUST_PAY_TYPE").ToString() = "") = True, 0, dtrow("ID_CUST_PAY_TYPE").ToString())
                            wohDet.Cust_Pricecode = dtrow("ID_CUST_PC_CODE").ToString()
                            details.Add(wohDet)
                        Next
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOHeader", "Fetch_WOH_Vehicle", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function Fetch_WOH_ZipCode() As List(Of WOHeaderBO)
            Dim details As New List(Of WOHeaderBO)()
            Dim dsWOHDetails As New DataSet
            Dim dtWOHDetails As New DataTable
            Try
                dsWOHDetails = objWOHDO.Fetch_WO_Config()
                If dsWOHDetails.Tables.Count > 0 Then
                    If dsWOHDetails.Tables(4).Rows.Count > 0 Then
                        dtWOHDetails = dsWOHDetails.Tables(4)
                        For Each dtrow As DataRow In dtWOHDetails.Rows
                            Dim wohDet As New WOHeaderBO()
                            wohDet.Id_Zipcode_WO = dtrow("ZipCode").ToString()
                            wohDet.Id_Country = dtrow("ZIP_ID_COUNTRY").ToString()
                            wohDet.Id_State = Convert.ToInt32(dtrow("ZIP_ID_STATE").ToString())
                            wohDet.PCountry = dtrow("County").ToString()
                            wohDet.PState = dtrow("State").ToString()
                            wohDet.City = dtrow("City").ToString()
                            wohDet.Canzip = dtrow("Canzip").ToString()
                            details.Add(wohDet)
                        Next
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOHeader", "Fetch_WOH_ZipCode", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function Fetch_WOH_PayTypes() As List(Of WOHeaderBO)
            Dim details As New List(Of WOHeaderBO)()
            Dim dsWOHDetails As New DataSet
            Dim dtWOHDetails As New DataTable
            Try
                dsWOHDetails = objWOHDO.Fetch_WO_Config()
                If dsWOHDetails.Tables.Count > 0 Then
                    If dsWOHDetails.Tables(5).Rows.Count > 0 Then
                        dtWOHDetails = dsWOHDetails.Tables(5)
                        For Each dtrow As DataRow In dtWOHDetails.Rows
                            Dim wohDet As New WOHeaderBO()
                            wohDet.Id_Settings = dtrow("ID_SETTINGS").ToString()
                            wohDet.Description = dtrow("DESCRIPTION").ToString()
                            details.Add(wohDet)
                        Next
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOHeader", "Fetch_WOH_PayTypes", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function Fetch_WOH_Veh_Make() As List(Of WOHeaderBO)
            Dim details As New List(Of WOHeaderBO)()
            Dim dsWOHDetails As New DataSet
            Dim dtWOHDetails As New DataTable
            Try
                dsWOHDetails = objWOHDO.Fetch_WO_Config()
                If dsWOHDetails.Tables.Count > 0 Then
                    If dsWOHDetails.Tables(6).Rows.Count > 0 Then
                        dtWOHDetails = dsWOHDetails.Tables(6)
                        For Each dtrow As DataRow In dtWOHDetails.Rows
                            Dim wohDet As New WOHeaderBO()
                            wohDet.Id_Make = dtrow("ID_MAKE_VEH").ToString()
                            wohDet.Veh_Make = dtrow("MAKE").ToString()
                            details.Add(wohDet)
                        Next
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOHeader", "Fetch_WOH_Veh_Make", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function LoadModel() As List(Of WOHeaderBO)
            Dim details As New List(Of WOHeaderBO)()
            Dim dsWOHDetails As New DataSet
            Dim dtWOHDetails As New DataTable
            Try
                dsWOHDetails = objWOHDO.Fetch_WO_Config()
                If dsWOHDetails.Tables.Count > 0 Then
                    If dsWOHDetails.Tables(11).Rows.Count > 0 Then
                        dtWOHDetails = dsWOHDetails.Tables(11)
                        For Each dtrow As DataRow In dtWOHDetails.Rows
                            Dim wohDet As New WOHeaderBO()
                            wohDet.Id_Model = dtrow("ID_MODEL").ToString()
                            wohDet.Model_Desc = dtrow("MODEL_DESC").ToString()
                            details.Add(wohDet)
                        Next
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOHeader", "LoadModel", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function Fetch_WOH_Cust_Group() As List(Of WOHeaderBO)
            Dim details As New List(Of WOHeaderBO)()
            Dim dsWOHDetails As New DataSet
            Dim dtWOHDetails As New DataTable
            Try
                dsWOHDetails = objWOHDO.Fetch_WO_Config()
                If dsWOHDetails.Tables.Count > 0 Then
                    If dsWOHDetails.Tables(7).Rows.Count > 0 Then
                        dtWOHDetails = dsWOHDetails.Tables(7)
                        For Each dtrow As DataRow In dtWOHDetails.Rows
                            Dim wohDet As New WOHeaderBO()
                            wohDet.Id_Cust_Group_Seq = dtrow("ID_CUST_GRP_SEQ").ToString()
                            wohDet.Cust_Group = dtrow("CUSG_DESCRIPTION").ToString()
                            details.Add(wohDet)
                        Next
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOHeader", "Fetch_WOH_Cust_Group", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function Fetch_WOH_Pay_Terms() As List(Of WOHeaderBO)
            Dim details As New List(Of WOHeaderBO)()
            Dim dsWOHDetails As New DataSet
            Dim dtWOHDetails As New DataTable
            Try
                dsWOHDetails = objWOHDO.Fetch_WO_Config()
                If dsWOHDetails.Tables.Count > 0 Then
                    If dsWOHDetails.Tables(8).Rows.Count > 0 Then
                        dtWOHDetails = dsWOHDetails.Tables(8)
                        For Each dtrow As DataRow In dtWOHDetails.Rows
                            Dim wohDet As New WOHeaderBO()
                            wohDet.Id_Settings = dtrow("ID_SETTINGS").ToString()
                            wohDet.Description = dtrow("DESCRIPTION").ToString()
                            details.Add(wohDet)
                        Next
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOHeader", "Fetch_WOH_Pay_Terms", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function Fetch_WOH_Cust_Grp_Details() As List(Of WOHeaderBO)
            Dim details As New List(Of WOHeaderBO)()
            Dim dsWOHDetails As New DataSet
            Dim dtWOHDetails As New DataTable
            Try
                dsWOHDetails = objWOHDO.Fetch_WO_Config()
                If dsWOHDetails.Tables.Count > 0 Then
                    If dsWOHDetails.Tables(9).Rows.Count > 0 Then
                        dtWOHDetails = dsWOHDetails.Tables(9)
                        For Each dtrow As DataRow In dtWOHDetails.Rows
                            Dim wohDet As New WOHeaderBO()
                            wohDet.Id_Settings = dtrow("ID_SETTINGS").ToString()
                            wohDet.Description = dtrow("DESCRIPTION").ToString()
                            wohDet.Pay_Type = dtrow("PAY_TYPE").ToString()
                            wohDet.Pay_Term = dtrow("PAY_TERM").ToString()
                            wohDet.Cust_Pricecode = dtrow("PRICE_CODE").ToString()
                            wohDet.Cust_Discount_Code = dtrow("DISCOUNT_CODE").ToString()
                            wohDet.VAT = dtrow("VAT").ToString()
                            wohDet.Id_Pay_Currency = dtrow("ID_PAY_CURRENCY").ToString()
                            wohDet.Flg_Disp_Int_Note = dsWOHDetails.Tables(10).Rows(0)("FLG_DISP_INT_NOTE").ToString()
                            details.Add(wohDet)
                        Next
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOHeader", "Fetch_WOH_Cust_Grp_Details", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function Fetch_WOH_Payment_Details(ByVal objWOHBO As WOHeaderBO) As List(Of WOHeaderBO)
            Dim details As New List(Of WOHeaderBO)()
            Dim dsWOHDetails As New DataSet
            Dim dtWOHDetails As New DataTable
            Dim IdCustGrpSeq As String
            Dim drUser As DataRow()

            Try
                IdCustGrpSeq = objWOHBO.Id_Cust_Group_Seq
                dsWOHDetails = objWOHDO.Fetch_WO_Config()

                drUser = dsWOHDetails.Tables(9).Select("ID_SETTINGS = '" & IdCustGrpSeq & "' ")
                dsWOHDetails.AcceptChanges()
                If dsWOHDetails.Tables.Count > 0 Then
                    Dim wohDet As New WOHeaderBO()
                    If HttpContext.Current.Session("PrevPayterm") <> "" Then
                        If Convert.ToInt16(HttpContext.Current.Session("PrevPayterm").ToString.Split(" ")(0)) < Convert.ToInt16(drUser(0)("PAY_TERM").ToString().Split(" ")(0)) Then
                            wohDet.ErrorMessage = "Payterm Increase."
                        Else
                            wohDet.ErrorMessage = ""
                        End If
                    Else
                        wohDet.ErrorMessage = ""
                    End If
                    wohDet.Pay_Type = drUser(0)("Pay_Type").ToString()
                    wohDet.Pay_Term = drUser(0)("Pay_Term").ToString()
                    HttpContext.Current.Session("PrevPayterm") = wohDet.Pay_Term
                    'HttpContext.Current.Session("PrevPayType") = wohDet.Pay_Type
                    details.Add(wohDet)
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOHeader", "Fetch_WOH_Cust_Grp_Details", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function Fetch_DefectNote(ByVal objWOHBO As WOHeaderBO) As String
            Dim details As New List(Of WOHeaderBO)()
            Dim dsWOHDetails As New DataSet
            Dim dtWOHDetails As New DataTable
            Try

                dsWOHDetails = objWOHDO.Fetch_DefectNote(objWOHBO)
                If dsWOHDetails.Tables(0).Rows.Count > 0 Then
                    Return True
                Else
                    Return False
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOHeader", "Fetch_DefectNote", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try

        End Function
        Public Function checkJobNo(ByVal objWOHBO As WOHeaderBO) As String
            Dim details As New List(Of WOHeaderBO)()
            Dim dsWOHDetails As New DataSet
            Dim dtWOHDetails As New DataTable
            Try

                dsWOHDetails = objWOHDO.Check_JobNo(objWOHBO)
                If dsWOHDetails.Tables(0).Rows.Count > 0 Then
                    Dim message As String = "Job_No already Exists."
                    Return message
                Else
                    Return False
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOHeader", "Fetch_DefectNote", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try

        End Function
        Public Function Fetch_DefectNotesGrid(ByVal objWOHBO As WOHeaderBO) As List(Of WOHeaderBO)
            Dim details As New List(Of WOHeaderBO)()
            Dim dsWOHDetails As New DataSet
            Dim dtWOHDetails As New DataTable
            Dim vehSeq As String
            Dim dvDefectNote As New DataView
            Try

                dsWOHDetails = objWOHDO.Fetch_Defects()
                vehSeq = objWOHBO.Id_Veh_Seq_WO
                If dsWOHDetails.Tables(0).Rows.Count > 0 Then
                    dtWOHDetails = dsWOHDetails.Tables(0)
                    dvDefectNote = dtWOHDetails.DefaultView
                    dvDefectNote.RowFilter = "VehSeq=" + vehSeq
                    dtWOHDetails = dvDefectNote.ToTable
                    For Each dtrow As DataRow In dtWOHDetails.Rows
                        Dim wohDet As New WOHeaderBO()
                        wohDet.DefectId = dtrow("DefectId").ToString()
                        wohDet.Description = dtrow("Description").ToString()
                        wohDet.Status = dtrow("STATUS").ToString()
                        wohDet.Dt_Created = dtrow("DT_Created").ToString()
                        wohDet.Id_Veh_Seq_WO = dtrow("VehSeq").ToString()
                        wohDet.OrderNo = dtrow("WorkOrder").ToString()
                        wohDet.IsStatus = dtrow("isSTATUS").ToString()
                        details.Add(wohDet)
                    Next
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOHeader", "Fetch_DefectNotesGrid", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function SaveDefect(ByVal objWOHBO As WOHeaderBO) As String
            Dim strRet As String
            Dim dsWOHDetails As New DataSet
            Dim dtWOHDetails As New DataTable
            Try

                dsWOHDetails = objWOHDO.Add_Defects(objWOHBO)

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOHeader", "SaveDefect", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strRet
        End Function
        Public Function Fetch_Alpha_Vehicle(ByVal vehicle As String) As List(Of WOHeaderBO)
            Dim details As New List(Of WOHeaderBO)()
            Dim dsWOHDetails As New DataSet
            Dim dtWOHDetails As New DataTable
            Try
                dsWOHDetails = objWOHDO.Fetch_Alpha_Vehicle(vehicle)
                If dsWOHDetails.Tables.Count > 0 Then
                    If dsWOHDetails.Tables(0).Rows.Count > 0 Then
                        dtWOHDetails = dsWOHDetails.Tables(0)
                        For Each dtrow As DataRow In dtWOHDetails.Rows
                            Dim wohDet As New WOHeaderBO()
                            wohDet.WO_Veh_Reg_NO = dtrow("REGNO").ToString()
                            wohDet.Veh_Int_No = dtrow("INTNO").ToString()
                            wohDet.WO_Veh_Vin = dtrow("VIN").ToString()
                            wohDet.Veh_Det = dtrow("VEH_DET").ToString()
                            wohDet.Veh_Make = dtrow("MAKE").ToString()
                            wohDet.Id_Model = dtrow("MODEL").ToString()
                            details.Add(wohDet)
                        Next
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOHeader", "Fetch_Alpha_Vehicle", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function AddWOHeader(ByVal objWOHBO As WOHeaderBO) As List(Of WOHeaderBO)
            Dim strResult As String = ""
            Dim strArray As Array
            Dim details As New List(Of WOHeaderBO)()
            HttpContext.Current.Session("WONO") = Nothing
            HttpContext.Current.Session("WOPR") = Nothing
            Dim strMake, strModel, idModel As String
            Dim dsModel As New DataSet
            Try
                strMake = objWOHBO.Id_Make
                strModel = objWOHBO.Id_Model

                ''dsModel = objWOHDO.Fetch_Mdl_Seq(strMake, strModel)
                'If dsModel.Tables(0).Rows.Count > 0 Then
                '    idModel = dsModel.Tables(0).Rows(0)("ID_MG_SEQ").ToString()
                '    objWOHBO.Id_Model = idModel
                'End If
                strResult = objWOHDO.Add_WOHeader(objWOHBO)
                strArray = strResult.Split(";")
                Dim wohDet As New WOHeaderBO()

                If strArray.Length.ToString = 2 Then
                    If strArray(1) = "547" Then
                        wohDet.ErrorMessage = objErrHandle.GetErrorDesc("USEUPDT").ToString
                        wohDet.SuccessMessage = ""

                    End If
                    If strArray(1) = "DUPVEH" Then
                        wohDet.ErrorMessage = objErrHandle.GetErrorDesc("VEHEXISTS").ToString
                        wohDet.SuccessMessage = ""

                    End If
                End If
                If strArray.Length.ToString > 4 Then
                    HttpContext.Current.Session("WONO") = strArray(0)
                    HttpContext.Current.Session("WOPR") = strArray(1)
                    HttpContext.Current.Session("IdCustomer") = strArray(2)
                    HttpContext.Current.Session("Veh_Seq_No") = strArray(3)
                    wohDet.Id_WO_NO = strArray(0)
                    wohDet.Id_WO_Prefix = strArray(1)
                    wohDet.Id_Cust_Wo = strArray(2)
                    wohDet.Id_Veh_Seq_WO = strArray(3)
                    wohDet.ErrorMessage = ""
                    wohDet.SuccessMessage = "INSFLG"

                ElseIf strArray.Length.ToString > 3 Then
                    HttpContext.Current.Session("WONO") = strArray(0)
                    HttpContext.Current.Session("WOPR") = strArray(1)
                    wohDet.Id_WO_NO = strArray(0)
                    wohDet.Id_WO_Prefix = strArray(1)
                    wohDet.Id_Cust_Wo = strArray(2)
                    wohDet.Id_Veh_Seq_WO = ""
                    wohDet.ErrorMessage = ""
                    wohDet.SuccessMessage = "INSFLG"
                ElseIf strArray(1) = "INSIDEXT" Then
                    wohDet.ErrorMessage = objErrHandle.GetErrorDesc("CIDEXT").ToString
                    wohDet.SuccessMessage = ""
                ElseIf strArray.Length.ToString = 1 Then
                    wohDet.ErrorMessage = objErrHandle.GetErrorDesc("CRPR").ToString
                    wohDet.SuccessMessage = ""
                Else
                    HttpContext.Current.Session("WONO") = strArray(0)
                    HttpContext.Current.Session("WOPR") = strArray(1)
                    wohDet.Id_WO_NO = strArray(0)
                    wohDet.Id_WO_Prefix = strArray(1)
                    wohDet.Id_Cust_Wo = ""
                    wohDet.Id_Veh_Seq_WO = ""
                    wohDet.ErrorMessage = ""
                    wohDet.SuccessMessage = ""
                End If
                details.Add(wohDet)
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOHeader", "AddWOHeader", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function UpdateWOHeader(ByVal objWOHBO As WOHeaderBO) As List(Of WOHeaderBO)
            Dim strResult As String = ""
            Dim strArray As Array
            Dim details As New List(Of WOHeaderBO)()
            Try
                strResult = objWOHDO.Update_WOHeader(objWOHBO)
                strArray = strResult.Split(";")
                Dim wohDet As New WOHeaderBO()
                If strArray(0) = "UPDFLG" Then
                    wohDet.ErrorMessage = ""
                    wohDet.SuccessMessage = objErrHandle.GetErrorDesc("WO") + " " + objErrHandle.GetErrorDescParameter("UPD", HttpContext.Current.Session("WOPR") & " " & HttpContext.Current.Session("WONO"))
                Else
                    wohDet.ErrorMessage = objErrHandle.GetErrorDesc("USEUPDT")
                    wohDet.SuccessMessage = ""
                End If
                details.Add(wohDet)
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOHeader", "UpdateWOHeader", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function Fetch_WOH_WoNodetails(ByVal objWOHeaderBO As WOHeaderBO) As List(Of WOHeaderBO)
            Dim details As New List(Of WOHeaderBO)()
            Dim dsWOHDetails As New DataSet
            Dim dtWOHDetails As New DataTable
            Try
                objWOHeaderBO.Created_By = HttpContext.Current.Session("UserID")
                dsWOHDetails = objWOHDO.Fetch_WOHeader(objWOHeaderBO)
                HttpContext.Current.Session("WOHDetails") = dsWOHDetails
                If dsWOHDetails.Tables.Count > 0 Then
                    If dsWOHDetails.Tables(0).Rows.Count > 0 Then
                        dtWOHDetails = dsWOHDetails.Tables(0)
                        For Each dtrow As DataRow In dtWOHDetails.Rows
                            Dim wohDet As New WOHeaderBO()
                            Dim VACostPr, VASellPrice As String
                            VACostPr = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(dtrow("VA_COST_PRICE").ToString() = "", "0", dtrow("VA_COST_PRICE").ToString()))
                            VASellPrice = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(dtrow("VA_SELL_PRICE").ToString() = "", "0", dtrow("VA_SELL_PRICE").ToString()))
                            wohDet.Id_WO_NO = dtrow("ID_WO_NO").ToString()
                            wohDet.Id_WO_Prefix = dtrow("ID_WO_PREFIX").ToString()
                            wohDet.WO_Type = dtrow("WO_TYPE_WOH").ToString()
                            wohDet.WO_Status = dtrow("WO_STATUS").ToString()
                            wohDet.WO_Tm_Deliv = dtrow("WO_TM_DELIV").ToString()
                            wohDet.Dt_Finish = dtrow("DT_FINISH").ToString()
                            wohDet.Id_Pay_Type_WO = dtrow("ID_PAY_TYPE_WO").ToString()
                            wohDet.Id_Pay_Terms_WO = dtrow("ID_PAY_TERMS_WO").ToString()
                            wohDet.WO_Annot = dtrow("WO_ANNOT").ToString()
                            wohDet.Cust_ID = dtrow("IV_CUSTID").ToString()
                            wohDet.Id_Cust_Wo = dtrow("ID_CUST_WO").ToString()
                            HttpContext.Current.Session("IdCustomer") = dtrow("ID_CUST_WO").ToString()
                            wohDet.WO_Cust_Name = dtrow("WO_CUST_NAME").ToString()
                            wohDet.WO_Cust_Add1 = dtrow("WO_CUST_PERM_ADD1").ToString()
                            wohDet.Cust_Perm_Add2 = dtrow("WO_CUST_PERM_ADD2").ToString()
                            wohDet.Id_Zipcode_WO = dtrow("ID_ZIPCODE_WO").ToString()
                            wohDet.WO_Cust_Phone_Off = dtrow("WO_CUST_PHONE_OFF").ToString()
                            wohDet.WO_Cust_Phone_Home = dtrow("WO_CUST_PHONE_HOME").ToString()
                            wohDet.WO_Cust_Phone_Mobile = dtrow("WO_CUST_PHONE_MOBILE").ToString()
                            wohDet.Id_Veh_Seq_WO = IIf(IsDBNull(dtrow("ID_VEH_SEQ_WO")) = True, 0, dtrow("ID_VEH_SEQ_WO").ToString())
                            wohDet.WO_Veh_Reg_NO = dtrow("WO_VEH_REG_NO").ToString()
                            wohDet.Veh_Int_No = dtrow("WO_VEH_INTERN_NO").ToString()
                            wohDet.WO_Veh_Vin = dtrow("WO_VEH_VIN").ToString()
                            wohDet.WO_Veh_Mileage = IIf(IsDBNull(dtrow("WO_VEH_MILEAGE")) = True, 0, dtrow("WO_VEH_MILEAGE").ToString())
                            wohDet.WO_Veh_Hrs = IIf(IsDBNull(dtrow("WO_VEH_HRS")) = True, 0, dtrow("WO_VEH_HRS").ToString())
                            wohDet.Dt_Order = dtrow("DT_ORDER").ToString()
                            wohDet.Dt_Delivery = dtrow("DT_DELIVERY").ToString()
                            wohDet.PCountry = dtrow("PCOUNTRY").ToString()
                            wohDet.PState = dtrow("PSTATE").ToString()
                            wohDet.PCity = dtrow("PCITY").ToString()
                            wohDet.Pay_Term = dtrow("PAYTERM").ToString()
                            wohDet.Pay_Type = dtrow("PAYTYPE").ToString()
                            wohDet.Id_Cust_Group_Seq = IIf(IsDBNull(dtrow("WO_CUST_GROUPID")) = True, 0, dtrow("WO_CUST_GROUPID").ToString())
                            wohDet.Buspek_Control_No = dtrow("BUS_PEK_CONTROL_NUM").ToString()
                            wohDet.Dt_Created = dtrow("DT_CREATED").ToString()
                            wohDet.Created_By = dtrow("CREATED_BY").ToString()
                            wohDet.Dt_Modified = dtrow("DT_MODIFIED").ToString()
                            wohDet.Modified_By = dtrow("MODIFIED_BY").ToString()
                            wohDet.Dt_Mileage_Update = dtrow("DT_MILEAGE_UPDATE").ToString()
                            wohDet.Dt_Hours_Update = dtrow("DT_HOURS_UPDATE").ToString()
                            wohDet.La_Dept_Account_No = dtrow("LA_DEPT_ACCOUNT_NO").ToString()
                            wohDet.Dbs_Filename = dtrow("DBS_FLNAME").ToString()
                            wohDet.VA_Cost_Price = Convert.ToDecimal(VACostPr)
                            wohDet.VA_Sell_Price = Convert.ToDecimal(VASellPrice)
                            wohDet.Van_Num = dtrow("VA_NUMBER").ToString()
                            wohDet.Int_Note = dtrow("INT_NOTE").ToString()
                            wohDet.Flg_Disp_Int_Note = dtrow("FLG_DISP_INT_NOTE").ToString()
                            wohDet.Ref_Wo_No = IIf(IsDBNull(dtrow("WO_REF_NO").ToString()) = True, "", dtrow("WO_REF_NO").ToString())
                            'details.Add(wohDet)
                            HttpContext.Current.Session("WONO") = dtrow("ID_WO_NO").ToString()
                            HttpContext.Current.Session("WOPR") = dtrow("ID_WO_PREFIX").ToString()
                            HttpContext.Current.Session("PrevPayterm") = dtrow("PAYTERM").ToString()
                            HttpContext.Current.Session("PrevPayType") = dtrow("PAYTYPE").ToString()
                            If dsWOHDetails.Tables(2).Rows.Count > 0 Then
                                ' check this changed the column name " ID_MAKE_VEH "  to " VEH_MAKE_CODE "
                                If (dsWOHDetails.Tables(2).Columns.Contains("ID_MAKE_VEH")) Then
                                    wohDet.Veh_Make = dsWOHDetails.Tables(2).Rows(0)("ID_MAKE_VEH")
                                ElseIf (dsWOHDetails.Tables(2).Columns.Contains("VEH_MAKE_CODE")) Then
                                    wohDet.Veh_Make = IIf(IsDBNull(dsWOHDetails.Tables(2).Rows(0)("VEH_MAKE_CODE")) = True, "", dsWOHDetails.Tables(2).Rows(0)("VEH_MAKE_CODE"))
                                End If
                                wohDet.Id_Model = IIf(IsDBNull(dsWOHDetails.Tables(2).Rows(0)("ID_MODEL_VEH")) = True, "", dsWOHDetails.Tables(2).Rows(0)("ID_MODEL_VEH"))

                            End If
                            details.Add(wohDet)
                        Next
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOHeader", "Fetch_WOH_WoNodetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function Fetch_WOH_Cust_Details(ByVal CustId As String) As List(Of WOHeaderBO)
            Dim details As New List(Of WOHeaderBO)()
            Dim dsWOHDetails As New DataSet
            Dim dtWOHDetails As New DataTable
            Dim objWOHeaderBO As New WOHeaderBO
            Dim wohDet As New WOHeaderBO()
            Dim dsConfigWorkOrder As New DataSet

            Try
                objWOHeaderBO.Created_By = HttpContext.Current.Session("UserID")
                dsConfigWorkOrder = objConfigWODO.GetConfigWorkOrder(HttpContext.Current.Session("UserID"))
                objWOHeaderBO.Id_Cust_Wo = CustId
                dsWOHDetails = objWOHDO.Cust_Sel_Detail(objWOHeaderBO)
                If dsWOHDetails.Tables.Count > 0 Then
                    If dsWOHDetails.Tables(0).Rows.Count > 0 Then
                        dtWOHDetails = dsWOHDetails.Tables(0)
                        For Each dtrow As DataRow In dtWOHDetails.Rows
                            If dsConfigWorkOrder.Tables(0).Rows.Count > 0 Then
                                If IIf(IsDBNull(dsConfigWorkOrder.Tables(0).Rows(0)("USE_DELV_ADDRESS")) = True, "", dsConfigWorkOrder.Tables(0).Rows(0)("USE_DELV_ADDRESS")) = "True" Then
                                    wohDet.WO_Cust_Add1 = dtrow("CUST_BILL_ADD1").ToString()
                                    wohDet.Cust_Perm_Add2 = dtrow("CUST_BILL_ADD2").ToString()
                                    wohDet.PCountry = dtrow("BCOUNTRY").ToString()
                                    wohDet.PState = dtrow("BCity").ToString()
                                    wohDet.PZipcode = dtrow("BZipCode").ToString()
                                Else
                                    wohDet.WO_Cust_Add1 = dtrow("CUST_PERM_ADD1").ToString()
                                    wohDet.Cust_Perm_Add2 = dtrow("CUST_PERM_ADD2").ToString()
                                    wohDet.PCountry = dtrow("PCOUNTRY").ToString()
                                    wohDet.PState = dtrow("PCity").ToString()
                                    wohDet.PZipcode = dtrow("PZipCode").ToString()
                                End If
                            End If
                            wohDet.Cust_ID = dtrow("ID_CUSTOMER").ToString()
                            wohDet.WO_Cust_Name = dtrow("CUST_NAME").ToString()
                            wohDet.Cust_Contactperson = dtrow("Cust_Contact_Person").ToString()
                            wohDet.WO_Cust_Phone_Off = dtrow("CUST_PHONE_OFF").ToString()
                            wohDet.WO_Cust_Phone_Home = dtrow("CUST_PHONE_HOME").ToString()
                            wohDet.WO_Cust_Phone_Mobile = dtrow("CUST_PHONE_MOBILE").ToString()
                            wohDet.Cust_Fax = dtrow("CUST_FAX").ToString()
                            wohDet.Cust_Email = dtrow("CUST_ID_EMAIL").ToString()
                            wohDet.Cust_Pricecode = dtrow("ID_CUST_PC_CODE").ToString()
                            wohDet.Description = dtrow("ID_CUST_PC_CODE").ToString()
                            wohDet.Cust_Discount_Code = dtrow("DISCOUNT").ToString()
                            wohDet.Cust_Group = dtrow("CGROUP").ToString()
                            wohDet.Pay_Type = dtrow("PayType").ToString()
                            wohDet.Pay_Term = dtrow("PayTerm").ToString()
                            wohDet.Id_Pay_Type_WO = dtrow("ID_CUST_PAY_TYPE").ToString()
                            wohDet.Id_Pay_Terms_WO = dtrow("ID_Cust_Pay_Term").ToString()
                            wohDet.Cust_Credit_Limit = dtrow("CUST_CREDIT_LIMIT").ToString()
                            wohDet.Cust_Account_No = dtrow("CUST_ACCOUNT_NO").ToString()
                            wohDet.Cust_Company_No = dtrow("Cust_Company_No").ToString()
                            wohDet.Cust_Company_Description = dtrow("Cust_Company_Description").ToString()
                            wohDet.Flg_Private_Comp = dtrow("Flg_Private_Comp")
                            wohDet.Cust_Last_Name = IIf(IsDBNull(dtrow("Cust_Last_Name")) = True, "", dtrow("Cust_Last_Name").ToString())
                            HttpContext.Current.Session("PrevPayterm") = dtrow("PayTerm").ToString()
                            HttpContext.Current.Session("PrevPayType") = dtrow("PayType").ToString()
                            wohDet.Cust_Disc_General = IIf(IsDBNull(dtrow("CUST_DISC_GENERAL")) = True, "", dtrow("CUST_DISC_GENERAL").ToString())
                            wohDet.Cust_Disc_Labour = IIf(IsDBNull(dtrow("CUST_DISC_LABOUR")) = True, "", dtrow("CUST_DISC_LABOUR").ToString())
                            wohDet.Cust_Disc_Spares = IIf(IsDBNull(dtrow("CUST_DISC_SPARES")) = True, "", dtrow("CUST_DISC_SPARES").ToString())
                        Next
                    End If
                    If dsWOHDetails.Tables(2).Rows.Count > 0 Then
                        dtWOHDetails = dsWOHDetails.Tables(2)
                        For Each dtrow As DataRow In dtWOHDetails.Rows
                            wohDet.LastInvDate = dtrow("LastInvDate").ToString()
                        Next
                    End If
                    details.Add(wohDet)

                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOHeader", "Fetch_WOH_Cust_Details", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function Fetch_Veh_Det(ByVal CustId As String) As List(Of WOHeaderBO)
            Dim details As New List(Of WOHeaderBO)()
            Dim dsWOHDetails As New DataSet
            Dim dtWOHDetails As New DataTable
            Dim objWOHeaderBO As New WOHeaderBO
            Try
                objWOHeaderBO.Id_Cust_Wo = CustId
                dsWOHDetails = objWOHDO.Cust_Sel_Detail(objWOHeaderBO)
                If dsWOHDetails.Tables.Count > 0 Then
                    If dsWOHDetails.Tables(1).Rows.Count > 0 Then
                        dtWOHDetails = dsWOHDetails.Tables(1)
                        For Each dtrow As DataRow In dtWOHDetails.Rows
                            Dim wohDet As New WOHeaderBO()
                            wohDet.Veh_Det = dtrow("VEH_DET").ToString()
                            wohDet.Id_Veh_Seq_WO = dtrow("ID_VEH_SEQ").ToString()
                            wohDet.ErrorMessage = objErrHandle.GetErrorDesc("VEHCONFIRM").Trim.ToString()
                            details.Add(wohDet)
                        Next
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOHeader", "Fetch_WOH_Cust_Details", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function

        Public Function Fetch_WOH_Vehicle_Details(ByVal objWOHeaderBO As WOHeaderBO) As List(Of WOHeaderBO)
            Dim details As New List(Of WOHeaderBO)()
            Dim dsWOHDetails As New DataSet
            Dim dtWOHDetails As New DataTable
            Dim dsConfigWorkOrder As New DataSet

            Try
                dsConfigWorkOrder = objConfigWODO.GetConfigWorkOrder(HttpContext.Current.Session("UserID"))
                dsWOHDetails = objWOHDO.Fetch_WOHeader(objWOHeaderBO)
                If dsWOHDetails.Tables.Count > 0 Then
                    If dsWOHDetails.Tables(2).Rows.Count > 0 Then
                        dtWOHDetails = dsWOHDetails.Tables(2)
                        For Each dtrow As DataRow In dtWOHDetails.Rows
                            Dim wohDet As New WOHeaderBO()
                            Dim VACostPr, VASellPrice As String
                            VACostPr = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(dtrow("COST_PRICE").ToString() = "", "0", dtrow("COST_PRICE").ToString()))
                            VASellPrice = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(dtrow("SELL_PRICE").ToString() = "", "0", dtrow("SELL_PRICE").ToString()))
                            wohDet.Cust_ID = dtrow("ID_CUSTOMER").ToString()
                            wohDet.WO_Cust_Name = dtrow("CUST_NAME").ToString()
                            wohDet.Cust_Contactperson = dtrow("Cust_Contact_Person").ToString()
                            wohDet.WO_Cust_Phone_Off = dtrow("CUST_PHONE_OFF").ToString()
                            wohDet.WO_Cust_Phone_Home = dtrow("CUST_PHONE_HOME").ToString()
                            wohDet.WO_Cust_Phone_Mobile = dtrow("CUST_PHONE_MOBILE").ToString()
                            wohDet.Cust_Fax = dtrow("CUST_FAX").ToString()
                            wohDet.Cust_Email = dtrow("CUST_ID_EMAIL").ToString()
                            wohDet.Cust_Account_No = dtrow("CUST_ACCOUNT_NO").ToString()
                            wohDet.Cust_Credit_Limit = dtrow("Cust_Credit_Limit").ToString()
                            wohDet.Id_Veh_Seq_WO = dtrow("ID_VEH_SEQ").ToString()
                            wohDet.WO_Veh_Reg_NO = dtrow("VEH_REG_NO").ToString()
                            wohDet.Veh_Int_No = dtrow("VEH_INTERN_NO").ToString()
                            wohDet.WO_Veh_Vin = dtrow("VEH_VIN").ToString()
                            wohDet.WO_Veh_Mileage = dtrow("VEH_MILEAGE").ToString()
                            wohDet.WO_Veh_Hrs = dtrow("VEH_HRS").ToString()
                            wohDet.Veh_Type = dtrow("VEH_TYPE").ToString()
                            wohDet.Veh_Mdl_Year = dtrow("VEH_MDL_YEAR").ToString()
                            wohDet.Dt_Veh_Regn = dtrow("DT_VEH_ERGN").ToString()
                            wohDet.Id_Pay_Terms_WO = dtrow("ID_Cust_Pay_Term").ToString()
                            wohDet.Id_Pay_Type_WO = dtrow("ID_CUST_PAY_TYPE").ToString()
                            wohDet.Id_Make = dtrow("ID_MAKE_VEH").ToString()
                            wohDet.Id_Model = dtrow("ID_MODEL_VEH").ToString()
                            wohDet.Veh_Driver = dtrow("VEH_DRIVER").ToString()
                            wohDet.Veh_Mobile = dtrow("VEH_MOBILE").ToString()
                            wohDet.Veh_Phone1 = dtrow("VEH_PHONE1").ToString()
                            wohDet.Veh_Drv_Emailid = dtrow("VEH_DRV_IDEMIAL").ToString()
                            wohDet.Veh_Annot = dtrow("VEH_ANNOT").ToString()
                            wohDet.Dt_Veh_Mil_Regn = dtrow("DT_VEH_MIL_REGN").ToString()
                            wohDet.Dt_Veh_Hrs_Regn = dtrow("DT_VEH_HRS_ERGN").ToString()
                            wohDet.Veh_Make = dtrow("MAKE").ToString()
                            wohDet.Id_Cust_Group_Seq = dtrow("CGROUP").ToString()
                            wohDet.Pay_Term = dtrow("PayTerm").ToString()
                            wohDet.Pay_Type = dtrow("PayType").ToString()
                            wohDet.Cust_Pricecode = dtrow("ID_CUST_PC_CODE").ToString()
                            wohDet.VA_Order = dtrow("VA_ORDER").ToString()
                            wohDet.VA_Cost_Price = Convert.ToDecimal(VACostPr)
                            wohDet.VA_Sell_Price = Convert.ToDecimal(VASellPrice)
                            If dsConfigWorkOrder.Tables(0).Rows.Count > 0 Then
                                If IIf(IsDBNull(dsConfigWorkOrder.Tables(0).Rows(0)("USE_DELV_ADDRESS")) = True, "", dsConfigWorkOrder.Tables(0).Rows(0)("USE_DELV_ADDRESS")) = "True" Then
                                    wohDet.WO_Cust_Add1 = dtrow("CUST_BILL_ADD1").ToString()
                                    wohDet.Cust_Perm_Add2 = dtrow("CUST_BILL_ADD2").ToString()
                                    wohDet.PCountry = dtrow("BCOUNTRY").ToString()
                                    wohDet.PState = dtrow("BState").ToString()
                                    wohDet.PZipcode = dtrow("BZipCode").ToString()
                                Else
                                    wohDet.WO_Cust_Add1 = dtrow("CUST_PERM_ADD1").ToString()
                                    wohDet.Cust_Perm_Add2 = dtrow("CUST_PERM_ADD2").ToString()
                                    wohDet.PCountry = dtrow("PCOUNTRY").ToString()
                                    wohDet.PState = dtrow("PState").ToString()
                                    wohDet.PZipcode = dtrow("PZipCode").ToString()
                                End If
                            End If
                            details.Add(wohDet)
                        Next
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOHeader", "Fetch_WOH_Vehicle_Details", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function Fetch_WOH_Job_Details(ByVal objWOHeaderBO As WOHeaderBO) As List(Of WOHeaderBO)
            Dim details As New List(Of WOHeaderBO)()
            Dim dsWOHDetails As New DataSet
            Dim dtWOHDetails As New DataTable
            Try
                dsWOHDetails = objWOHDO.Fetch_WOHeader(objWOHeaderBO)
                If dsWOHDetails.Tables.Count > 0 Then
                    If dsWOHDetails.Tables(3).Rows.Count > 0 Then
                        dtWOHDetails = dsWOHDetails.Tables(3)
                        For Each dtrow As DataRow In dtWOHDetails.Rows
                            Dim wohDet As New WOHeaderBO()
                            wohDet.Id_Job = dtrow("ID_JOB").ToString()
                            wohDet.WO_Job_Txt = dtrow("WO_JOB_TXT").ToString()
                            wohDet.WO_Status = dtrow("STATUS").ToString()
                            wohDet.HpFlag = dtrow("HPFlag").ToString()
                            wohDet.Debitor = dtrow("deb").ToString()
                            wohDet.Job_Amt = dtrow("JOB_AMT").ToString()
                            wohDet.Job_ExVat_Amt = dtrow("JOB_EXVAT_AMT").ToString()
                            wohDet.Job_Status = dtrow("JOB_STATUS").ToString()
                            details.Add(wohDet)
                        Next
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOHeader", "Fetch_WOH_Job_Details", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function Fetch_WOH_Mech_Details(ByVal objWOHeaderBO As WOHeaderBO) As List(Of WOHeaderBO)
            Dim details As New List(Of WOHeaderBO)()
            Dim dsWOHDetails As New DataSet
            Dim dtWOHDetails As New DataTable
            Try
                dsWOHDetails = objWOHDO.Fetch_WOHeader(objWOHeaderBO)
                If dsWOHDetails.Tables.Count > 0 Then
                    If dsWOHDetails.Tables(4).Rows.Count > 0 Then
                        dtWOHDetails = dsWOHDetails.Tables(4)
                        For Each dtrow As DataRow In dtWOHDetails.Rows
                            Dim wohDet As New WOHeaderBO()
                            wohDet.Id_WO_NO = dtrow("ORDERNO").ToString()
                            wohDet.Id_Job = dtrow("JOBNO").ToString()
                            wohDet.MechanicName = dtrow("MECHANICNAME").ToString()
                            wohDet.TotClockedTime = dtrow("TOTCLOCKEDTIME").ToString()
                            wohDet.MechStatus = dtrow("STATUS").ToString()
                            wohDet.MechCode = dtrow("MECHANICCODE").ToString()
                            details.Add(wohDet)
                        Next
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOHeader", "Fetch_WOH_Mech_Details", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function Fetch_Veh_Model(ByVal objWOHeaderBO As WOHeaderBO) As List(Of WOHeaderBO)
            Dim details As New List(Of WOHeaderBO)()
            Dim dsWOHDetails As New DataSet
            Dim dtWOHDetails As New DataTable
            Try
                dsWOHDetails = objWOHDO.Veh_Model_group(objWOHeaderBO)
                If dsWOHDetails.Tables.Count > 0 Then
                    If dsWOHDetails.Tables(0).Rows.Count > 0 Then
                        dtWOHDetails = dsWOHDetails.Tables(0)
                        For Each dtrow As DataRow In dtWOHDetails.Rows
                            Dim wohDet As New WOHeaderBO()
                            wohDet.Id_Model = dtrow("MG_ID_MODEL_GRP").ToString()
                            wohDet.Model_Desc = dtrow("ID_MG_SEQ").ToString()
                            details.Add(wohDet)
                        Next
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOHeader", "Fetch_Veh_Model", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function Load_All_Model() As List(Of WOHeaderBO)
            Dim details As New List(Of WOHeaderBO)()
            Dim dsWOHDetails As New DataSet
            Dim dtWOHDetails As New DataTable
            Try
                dsWOHDetails = objWOHDO.Load_Model_Grp()
                If dsWOHDetails.Tables.Count > 0 Then
                    If dsWOHDetails.Tables(0).Rows.Count > 0 Then
                        dtWOHDetails = dsWOHDetails.Tables(0)
                        For Each dtrow As DataRow In dtWOHDetails.Rows
                            Dim wohDet As New WOHeaderBO()
                            wohDet.Id_Model = dtrow("ID_MODELGRP").ToString()
                            wohDet.Model_Desc = dtrow("ID_MG_SEQ").ToString()
                            details.Add(wohDet)
                        Next
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOHeader", "Load_All_Model", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function Update_Customerdetails(ByVal objWOHeaderBO As WOHeaderBO) As String()
            Dim details As New List(Of WOHeaderBO)()
            Dim dsWOHDetails As New DataSet
            Dim dtWOHDetails As New DataTable
            Dim strStatus As String
            Dim strArray As Array
            Try
                strStatus = objWOHDO.Update_Customerdetails(objWOHeaderBO)
                strArray = strStatus.Split(";")
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOHeader", "Fetch_Veh_Model", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strArray
        End Function
        Public Function Fetch_WOH_OrderJobs(ByVal objWOHeaderBO As WOHeaderBO) As List(Of WOHeaderBO)
            Dim details As New List(Of WOHeaderBO)()
            Dim dsWOHDetails As New DataSet
            Dim dtWOHDetails As New DataTable
            Try
                dsWOHDetails = HttpContext.Current.Session("WOHDetails")
                If dsWOHDetails.Tables.Count > 0 Then
                    If dsWOHDetails.Tables(3).Rows.Count > 0 Then
                        dtWOHDetails = dsWOHDetails.Tables(3)
                        For Each dtrow As DataRow In dtWOHDetails.Rows
                            Dim wohDet As New WOHeaderBO()
                            wohDet.Id_Job = dtrow("ID_JOB").ToString()
                            wohDet.WO_Job_Txt = dtrow("WO_JOB_TXT").ToString()
                            wohDet.Job_Status = dtrow("JOB_STATUS").ToString()
                            wohDet.HpFlag = dtrow("HPFlag").ToString()
                            wohDet.Debitor = dtrow("Deb").ToString()
                            wohDet.Job_Amt = dtrow("JOB_AMT").ToString()
                            wohDet.Job_ExVat_Amt = dtrow("JOB_EXVAT_AMT").ToString()
                            details.Add(wohDet)
                        Next
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOHeader", "Fetch_WOH_OrderJobs", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function Fetch_WOH_MechGrid(ByVal objWOHeaderBO As WOHeaderBO) As List(Of WOHeaderBO)
            Dim details As New List(Of WOHeaderBO)()
            Dim dsWOHDetails As New DataSet
            Dim dtWOHDetails As New DataTable
            Try
                dsWOHDetails = HttpContext.Current.Session("WOHDetails")
                If dsWOHDetails.Tables.Count > 0 Then
                    If dsWOHDetails.Tables(4).Rows.Count > 0 Then
                        dtWOHDetails = dsWOHDetails.Tables(4)
                        For Each dtrow As DataRow In dtWOHDetails.Rows
                            Dim wohDet As New WOHeaderBO()
                            wohDet.OrderNo = dtrow("ORDERNO").ToString()
                            wohDet.Id_Job = dtrow("JOBNO").ToString()
                            wohDet.MechanicName = dtrow("MECHANICNAME").ToString()
                            wohDet.TotClockedTime = dtrow("TOTCLOCKEDTIME").ToString()
                            wohDet.CompStatus = dtrow("COMPSTATUS").ToString()
                            wohDet.ClockIn = dtrow("CLOCKIN").ToString()
                            wohDet.ClockOut = dtrow("CLOCKOUT").ToString()
                            wohDet.MechCode = dtrow("MECHANICCODE").ToString()
                            wohDet.MechStatus = dtrow("Status").ToString()
                            details.Add(wohDet)
                        Next
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOHeader", "Fetch_WOH_Mech_Details", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function Fetch_NonInvoiced_Orders(ByVal objWOHeaderBO As WOHeaderBO) As List(Of WOHeaderBO)
            Dim details As New List(Of WOHeaderBO)()
            Dim dsNIOrderDetails As New DataSet
            Dim dtNIOrderDetails As New DataTable
            Dim dspageSize As New DataSet
            Dim pageSize As Integer
            Try
                dspageSize = objWOHDO.Fetch_NonInvoiced_Orders(objWOHeaderBO)
                pageSize = CInt(dspageSize.Tables(1).Rows(0)("TotalCount").ToString)
                objWOHeaderBO.PageSize = pageSize
                dsNIOrderDetails = objWOHDO.Fetch_NonInvoiced_Orders(objWOHeaderBO)
                If dsNIOrderDetails.Tables.Count > 0 Then
                    If dsNIOrderDetails.Tables(0).Rows.Count > 0 Then
                        dtNIOrderDetails = dsNIOrderDetails.Tables(0)
                        For Each dtrow As DataRow In dtNIOrderDetails.Rows
                            Dim wohDet As New WOHeaderBO()
                            wohDet.OrderNo = dtrow("OrderNumber").ToString()
                            wohDet.Id_WO_NO = dtrow("ID_WO_NO").ToString()
                            wohDet.Id_WO_Prefix = dtrow("ID_WO_PREFIX").ToString()
                            wohDet.WO_Veh_Reg_NO = dtrow("RegNo").ToString()
                            wohDet.Jobs = dtrow("Jobs").ToString()
                            details.Add(wohDet)
                        Next
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOHeader", "Fetch_WOH_Mech_Details", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function Update_Vehicledetails(ByVal objWOHeaderBO As WOHeaderBO) As String()
            Dim details As New List(Of WOHeaderBO)()
            Dim dsWOHDetails As New DataSet
            Dim dtWOHDetails As New DataTable
            Dim strStatus As String
            Dim strArray As Array
            Try
                strStatus = objWOHDO.Update_VehicleDetails(objWOHeaderBO)
                strArray = strStatus.Split(";")
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOHeader", "Fetch_Veh_Model", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strArray
        End Function
        Public Function Delete_Job(objWOHeaderBO) As String()
            Dim strResult As String = ""
            Dim strArray As Array
            Dim strErrArr As Array
            Dim strError As String
            Dim strRecordsDeleted As String = ""
            Dim strRecordsNotDeleted As String = ""
            Try
                strResult = objWOHDO.Delete_WOHeader(objWOHeaderBO)
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
                objErrHandle.WriteErrorLog(1, "Services.WOHeader", "Delete_Job", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strArray
        End Function
        Public Function CreditLimit_Customer(ByVal objWOHeaderBO As WOHeaderBO) As String
            Dim TotCrAmt = 0.0, BalCrAmt As Decimal = 0.0
            Dim dsReturnValTmp As New DataSet
            Try

                dsReturnValTmp = objWOHDO.deb_details(objWOHeaderBO)

                If dsReturnValTmp.Tables(3).Rows.Count > 0 Then
                    BalCrAmt = Convert.ToDecimal(dsReturnValTmp.Tables(3).Rows(0).Item(0))
                End If
                If dsReturnValTmp.Tables(4).Rows.Count > 0 Then
                    TotCrAmt = Convert.ToDecimal(IIf(IsDBNull(dsReturnValTmp.Tables(4).Rows(0).Item(0)), 0, dsReturnValTmp.Tables(4).Rows(0).Item(0)))

                End If

                If objWOHeaderBO.Id_Cust_Wo <> HttpContext.Current.Session("DEB_ID") Then
                    If dsReturnValTmp.Tables(5).Rows.Count > 0 Then
                        If dsReturnValTmp.Tables(5).Rows(0).Item("Description").ToString.ToUpper <> "CASH" Then
                            ''Checking for customer credit is 0- Infinite credit limit.
                            If BalCrAmt <> 0 Then
                                If (BalCrAmt - TotCrAmt) < 0 Then
                                    'Put confirmation box
                                    'HdnCreditLimit.Value = "False"
                                    'ShowConfirmation_Limit(oErrHandle.GetErrorDescParameter("CCREDIT") + " " + txtSrchCust.Text + ". " + oErrHandle.GetErrorDesc("MESS_CONFIRM"))
                                    Dim message As String = "Credit Limit Exceeds For The Customer..Do want to Continue?"
                                    Return message
                                End If
                            End If
                        End If
                    End If
                Else
                    If Not HttpContext.Current.Session("WO_CR_TYPE") Is Nothing Then
                        If (HttpContext.Current.Session("WO_CR_TYPE").ToString.ToUpper <> "CASH") Then
                            If BalCrAmt <> 0 Then
                                If (BalCrAmt - TotCrAmt) < 0 Then
                                    'Put confirmation box
                                    'HdnCreditLimit.Value = "False"
                                    'ShowConfirmation_Limit(oErrHandle.GetErrorDescParameter("CCREDIT") + " " + txtSrchCust.Text + ". " + oErrHandle.GetErrorDesc("MESS_CONFIRM"))
                                    Dim message As String = "Credit Limit Exceeds For The Customer..Do want to Continue?"
                                    Return message
                                End If
                            Else
                                If dsReturnValTmp.Tables(6).Rows(0).Item("FLG_CUST_NOCREDIT").ToString.ToUpper = "TRUE" Then
                                    'RTlblError.Text = "<Font color=""blue"">" + oErrHandle.GetErrorDescParameter("NOCREDIT", txtSrchCust.Text) + "</Font>"
                                    Dim message As String = "No Credit Limit Exists for the Customer."
                                    Return message
                                End If
                            End If

                        End If
                    End If

                End If
                dsReturnValTmp = Nothing


            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOHeader", "CreditLimit_Customer", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return True
        End Function
        Public Function Vehicle_Check(ByVal objWOHeaderBO As WOHeaderBO) As String
            Dim dsReturnValTmp As New DataSet
            Try
                dsReturnValTmp = objWOHDO.Check_Veh_Exist(objWOHeaderBO)
                If dsReturnValTmp.Tables(0).Rows.Count > 0 Then
                    Return True
                Else
                    Return False
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOHeader", "CreditLimit_Customer", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
        End Function
        Public Function Customer_Check(ByVal objWOHeaderBO As WOHeaderBO) As String
            Dim dsReturnValTmp As New DataSet
            Try
                dsReturnValTmp = objWOHDO.Check_Cust_Exist(objWOHeaderBO)
                If dsReturnValTmp.Tables(0).Rows.Count > 0 Then
                    Return True
                Else
                    Return False
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOHeader", "CreditLimit_Customer", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
        End Function

    End Class
End Namespace

