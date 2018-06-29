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
Namespace CARS.Services.ConfigWO
    Public Class ConfigWorkOrder
        Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
        Shared objConfigWODO As New CARS.ConfigWorkOrder.ConfigWorkOrderDO
        Shared objCommonUtil As New CARS.Utilities.CommonUtility
        Shared objConfigSettingsDO As New CARS.ConfigSettings.ConfigSettingsDO

        Public Function FetchConfigWorkOder(ByVal subId As String, ByVal deptId As String) As Collection
            Dim dsConfig As New DataSet
            Dim dtConfig As New DataTable
            Dim dtConfigColl As New Collection
            'Dim deptId As String = HttpContext.Current.Session("UserDept")
            'Dim subId As String = HttpContext.Current.Session("UserSubsidiary")
            Try
                'WORK ORDER Settings
                dsConfig = objConfigWODO.FetchConfigWorkOderDetails(deptId, subId)
                HttpContext.Current.Session("ConfigWorkOrderDetails") = dsConfig
                If dsConfig.Tables.Count > 0 Then
                    If (dsConfig.Tables(0).Rows.Count > 0) Then
                        dtConfig = dsConfig.Tables(0)
                        Dim details As New List(Of ConfigWorkOrderBO)()
                        For Each dtrow As DataRow In dtConfig.Rows
                            Dim workCode As New ConfigWorkOrderBO()
                            workCode.WOPr = dtrow("WO_PREFIX")
                            workCode.Ord_Ser = dtrow("WO_SERIES").ToString()
                            workCode.WO_VAT_CalcRisk = IIf(IsDBNull(dtrow("WO_VAT_CalcRisk")) = True, "0", dtrow("WO_VAT_CalcRisk"))
                            workCode.WO_GMPrice_Perc = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("WO_GAR_MATPRICE_PER")) = True, "0", dtrow("WO_GAR_MATPRICE_PER")))
                            workCode.WO_Charege_Base = IIf(IsDBNull(dtrow("WO_CHAREGE_BASE")) = True, "", dtrow("WO_Charege_Base"))
                            workCode.WO_Discount_Base = IIf(IsDBNull(dtrow("WO_DISCOUNT_BASE")) = True, "", dtrow("WO_DISCOUNT_BASE"))
                            workCode.WO_Curr_Series = IIf(IsDBNull(dtrow("WO_Cur_Series")) = True, "", dtrow("WO_Cur_Series"))
                            workCode.Use_Delv_Address = IIf(IsDBNull(dtrow("Use_Delv_Address")) = True, "0", dtrow("Use_Delv_Address"))
                            workCode.Use_Manual_Rwrk = IIf(IsDBNull(dtrow("Use_Manual_Rwrk")) = True, "0", dtrow("Use_Manual_Rwrk"))
                            workCode.Use_Vehicle_Sp = IIf(IsDBNull(dtrow("Use_Vehicle_Sp")) = True, "0", dtrow("Use_Vehicle_Sp"))
                            workCode.Use_Pc_Job = IIf(IsDBNull(dtrow("Use_Pc_Job")) = True, "0", dtrow("Use_Pc_Job"))
                            workCode.WO_Status = IIf(IsDBNull(dtrow("WO_ID_SETTINGS")) = True, "", dtrow("WO_ID_SETTINGS"))
                            workCode.Use_Default_Cust = IIf(IsDBNull(dtrow("Use_Def_Cust")) = True, "0", dtrow("Use_Def_Cust"))
                            workCode.IdCustomer = IIf(IsDBNull(dtrow("Id_Customer")) = True, "", dtrow("Id_Customer"))
                            workCode.Use_Cnfrm_Dialogue = IIf(IsDBNull(dtrow("Use_Cnfrm_Dia")) = True, "0", dtrow("Use_Cnfrm_Dia"))
                            workCode.Use_SaveJob_Grid = IIf(IsDBNull(dtrow("Use_Save_Job_Grid")) = True, "0", dtrow("Use_Save_Job_Grid"))
                            workCode.Use_VA_ACC_Code = IIf(IsDBNull(dtrow("Use_VA_ACC_Code")) = True, "0", dtrow("Use_VA_ACC_Code"))
                            workCode.VA_ACC_Code = IIf(IsDBNull(dtrow("VA_ACC_Code")) = True, "", dtrow("VA_ACC_Code"))
                            workCode.Use_All_Spare_Search = IIf(IsDBNull(dtrow("Use_All_Spare_Search")) = True, "0", dtrow("Use_All_Spare_Search"))
                            workCode.Disp_Rinv_Pinv = IIf(IsDBNull(dtrow("Disp_Rinv_Pinv")) = True, "0", dtrow("Disp_Rinv_Pinv"))
                            workCode.Id_Subsidery = subId
                            workCode.Id_Dept = deptId
                            details.Add(workCode)
                        Next
                        dtConfigColl.Add(details)
                    ElseIf (dsConfig.Tables(0).Rows.Count = 0) Then
                        dtConfig = dsConfig.Tables(0)
                        Dim details As New List(Of ConfigWorkOrderBO)()
                        dtConfigColl.Add(details)
                    End If
                End If

                'Product Group Mapping- Disc Code
                dsConfig = objConfigWODO.GetConfigDiscCode(deptId, subId)
                HttpContext.Current.Session("ConfigDiscCode") = dsConfig

                If dsConfig.Tables.Count > 0 Then
                    If (dsConfig.Tables(0).Rows.Count > 0) Then
                        dtConfig = dsConfig.Tables(0)
                        Dim details As New List(Of ConfigWorkOrderBO)()
                        For Each dtrow As DataRow In dtConfig.Rows
                            Dim prodGrp As New ConfigWorkOrderBO()
                            prodGrp.Id_Disc_Seq = dtrow("Id_Discount_Seq")
                            prodGrp.Product_Group = dtrow("Catg_Desc").ToString()
                            prodGrp.Id_Item_Catg_Map = dtrow("Id_Item_Catg_Map")
                            prodGrp.Disc_Code = dtrow("discode")
                            prodGrp.VAT_Code = dtrow("vatcode")
                            prodGrp.Description = IIf(IsDBNull(dtrow("Description")) = True, "", dtrow("Description"))
                            details.Add(prodGrp)
                        Next
                        dtConfigColl.Add(details)
                    ElseIf (dsConfig.Tables(0).Rows.Count = 0) Then
                        dtConfig = dsConfig.Tables(0)
                        Dim details As New List(Of ConfigWorkOrderBO)()
                        dtConfigColl.Add(details)
                    End If
                End If

                'PayType
                dsConfig = objConfigSettingsDO.Fetch_PayType("PAYTYPE")
                If dsConfig.Tables.Count > 0 Then
                    If (dsConfig.Tables(0).Rows.Count > 0) Then
                        dtConfig = dsConfig.Tables(0)
                        Dim details As New List(Of ConfigWorkOrderBO)()
                        For Each dtrow As DataRow In dtConfig.Rows
                            Dim payType As New ConfigWorkOrderBO()
                            payType.IdSettings = dtrow("Id_Settings")
                            payType.Description = dtrow("Description").ToString()
                            payType.Remarks = dtrow("Remarks").ToString()
                            details.Add(payType)
                        Next
                        dtConfigColl.Add(details)
                    ElseIf (dsConfig.Tables(0).Rows.Count = 0) Then
                        dtConfig = dsConfig.Tables(0)
                        Dim details As New List(Of ConfigWorkOrderBO)()
                        dtConfigColl.Add(details)
                    End If
                End If

                'VAT Codes
                dsConfig = objConfigSettingsDO.Fetch_VATCodes()
                If dsConfig.Tables.Count > 0 Then
                    If (dsConfig.Tables(0).Rows.Count > 0) Then
                        dtConfig = dsConfig.Tables(0)
                        Dim details As New List(Of ConfigWorkOrderBO)()
                        For Each dtrow As DataRow In dtConfig.Rows
                            Dim vatCode As New ConfigWorkOrderBO()
                            vatCode.Id_Vat_Seq = dtrow("Id_Vat_Seq")
                            vatCode.VatCodeOnCust = IIf(IsDBNull(dtrow("VatCodeOnCust")) = True, "", dtrow("VatCodeOnCust"))
                            vatCode.VatCodeOnItem = IIf(IsDBNull(dtrow("VatCodeOnItem")) = True, "", dtrow("VatCodeOnItem"))
                            vatCode.VatCodeOnVehicle = IIf(IsDBNull(dtrow("VatCodeOnVehicle")) = True, "", dtrow("VatCodeOnVehicle"))
                            vatCode.VatCodeOnOrderLine = IIf(IsDBNull(dtrow("VatCodeOnOrderLine")) = True, "", dtrow("VatCodeOnOrderLine"))
                            vatCode.Vat_Acccode = IIf(IsDBNull(dtrow("Vat_AccCode")) = True, "", dtrow("Vat_AccCode"))
                            vatCode.LastChangedBy = IIf(IsDBNull(dtrow("LastChangedBy")) = True, "", dtrow("LastChangedBy"))
                            'vatCode.LastChangedOn = IIf(IsDBNull(dtrow("LastChangedOn")) = True, "", dtrow("LastChangedOn"))

                            If (IsDBNull(dtrow("LastChangedOn").ToString())) Then
                                vatCode.LastChangedOn = ""
                            Else
                                vatCode.LastChangedOn = objCommonUtil.GetCurrentLanguageDate(dtrow("LastChangedOn").ToString())
                            End If

                            vatCode.VatStatus = IIf(IsDBNull(dtrow("Status")) = True, "", dtrow("Status"))
                            details.Add(vatCode)
                        Next
                        dtConfigColl.Add(details)
                    ElseIf (dsConfig.Tables(0).Rows.Count = 0) Then
                        dtConfig = dsConfig.Tables(0)
                        Dim details As New List(Of ConfigWorkOrderBO)()
                        dtConfigColl.Add(details)
                    End If
                End If


                'For Drop downs
                dsConfig = objConfigWODO.GetDisListData()
                HttpContext.Current.Session("WorkOrderConfigDetails") = dsConfig
                'Customer 
                If dsConfig.Tables.Count > 0 Then
                    If (dsConfig.Tables(0).Rows.Count > 0) Then
                        dtConfig = dsConfig.Tables(0)
                        Dim details As New List(Of ConfigWorkOrderBO)()
                        For Each dtrow As DataRow In dtConfig.Rows
                            Dim workCode As New ConfigWorkOrderBO()
                            workCode.IdSettings = dtrow("Id_Customer")
                            workCode.Description = dtrow("Cust_Name").ToString()
                            details.Add(workCode)
                        Next
                        dtConfigColl.Add(details)
                    ElseIf (dsConfig.Tables(0).Rows.Count = 0) Then
                        dtConfig = dsConfig.Tables(0)
                        Dim details As New List(Of ConfigWorkOrderBO)()
                        dtConfigColl.Add(details)
                    End If
                End If

                'Discount Code
                If dsConfig.Tables.Count > 0 Then
                    If (dsConfig.Tables(1).Rows.Count > 0) Then
                        dtConfig = dsConfig.Tables(1)
                        Dim details As New List(Of ConfigWorkOrderBO)()
                        For Each dtrow As DataRow In dtConfig.Rows
                            Dim workCode As New ConfigWorkOrderBO()
                            workCode.IdSettings = dtrow("Id_Settings")
                            workCode.Description = dtrow("Description").ToString()
                            details.Add(workCode)
                        Next
                        dtConfigColl.Add(details)
                    ElseIf (dsConfig.Tables(1).Rows.Count = 0) Then
                        dtConfig = dsConfig.Tables(1)
                        Dim details As New List(Of ConfigWorkOrderBO)()
                        dtConfigColl.Add(details)
                    End If
                End If

                'VAT Code
                If dsConfig.Tables.Count > 0 Then
                    If (dsConfig.Tables(2).Rows.Count > 0) Then
                        dtConfig = dsConfig.Tables(2)
                        Dim details As New List(Of ConfigWorkOrderBO)()
                        For Each dtrow As DataRow In dtConfig.Rows
                            Dim workCode As New ConfigWorkOrderBO()
                            workCode.IdSettings = dtrow("Id_Settings")
                            workCode.Description = dtrow("Description").ToString()
                            details.Add(workCode)
                        Next
                        dtConfigColl.Add(details)
                    ElseIf (dsConfig.Tables(2).Rows.Count = 0) Then
                        dtConfig = dsConfig.Tables(2)
                        Dim details As New List(Of ConfigWorkOrderBO)()
                        dtConfigColl.Add(details)
                    End If
                End If

                'Product Group
                If dsConfig.Tables.Count > 0 Then
                    If (dsConfig.Tables(3).Rows.Count > 0) Then
                        dtConfig = dsConfig.Tables(3)
                        Dim details As New List(Of ConfigWorkOrderBO)()
                        For Each dtrow As DataRow In dtConfig.Rows
                            Dim workCode As New ConfigWorkOrderBO()
                            workCode.IdSettings = dtrow("Id_Item_Catg")
                            workCode.Description = dtrow("Catg_Desc").ToString()
                            details.Add(workCode)
                        Next
                        dtConfigColl.Add(details)
                    ElseIf (dsConfig.Tables(3).Rows.Count = 0) Then
                        dtConfig = dsConfig.Tables(3)
                        Dim details As New List(Of ConfigWorkOrderBO)()
                        dtConfigColl.Add(details)
                    End If
                End If


            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigWorkOrder", "FetchConfigWorkOder", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return dtConfigColl
        End Function

        'Public Function SaveProductGroup(ByVal xmlDoc As String) As String()
        '    Dim strResult As String = ""
        '    Dim strArray As Array
        '    Dim strError As String
        '    Dim strSaved As String = ""
        '    Dim strInscount As String = ""
        '    Try
        '        strResult = objConfigWODO.SaveProdDiscGrp(xmlDoc)
        '        strArray = strResult.Split(",")
        '        strError = strArray(0)
        '        strSaved = CStr(strArray(0))
        '        strInscount = CStr(strArray(1))

        '        If strSaved = "0" Then
        '            If Len(strInscount) <> 0 Then
        '                strArray(0) = "SAVED"
        '                strArray(1) = objErrHandle.GetErrorDescParameter("INS", objErrHandle.GetErrorDesc("PGMAP"))
        '            End If
        '        Else
        '            strArray(0) = "NSAVED"
        '            strArray(1) = "<Font color=""red"">" + strSaved + "<font>"
        '        End If


        '    Catch ex As Exception
        '        objErrHandle.WriteErrorLog(1, "Services.ConfigGeneral", "SaveProductGroup", ex.Message, HttpContext.Current.Session("UserID"))
        '    End Try
        '    Return strArray
        'End Function

        'Public Function UpdateProductGroup(ByVal xmlDoc As String) As String()
        '    Dim strResult As String = ""
        '    Dim strArray As Array
        '    Dim strError As String
        '    Dim strSaved As String = ""
        '    Dim strInscount As String = ""
        '    Try
        '        strResult = objConfigWODO.UpdateProdDiscGrp(xmlDoc)
        '        strArray = strResult.Split(",")
        '        strError = strArray(0)
        '        strSaved = CStr(strArray(0))
        '        strInscount = CStr(strArray(1))

        '        If strSaved = "0" Then
        '            If Len(strInscount) <> 0 Then
        '                strArray(0) = "UPDATED"
        '                strArray(1) = objErrHandle.GetErrorDescParameter("DUPDATE", objErrHandle.GetErrorDesc("PGMAP"))
        '            End If
        '        Else
        '            strArray(0) = "NUPDATED"
        '            strArray(1) = strSaved
        '        End If


        '    Catch ex As Exception
        '        objErrHandle.WriteErrorLog(1, "Services.ConfigGeneral", "SaveProductGroup", ex.Message, HttpContext.Current.Session("UserID"))
        '    End Try
        '    Return strArray
        'End Function

        Public Function SavePayType(ByVal xmlDoc As String) As String()
            Dim strResult As String = ""
            Dim strArray As Array
            Dim strError As String
            Dim strSaved As String = ""
            Dim strCannotSaved As String = ""
            Try
                strResult = objConfigSettingsDO.AddPaymentType(xmlDoc)
                strArray = strResult.Split(",")
                strError = strArray(0)
                strSaved = CStr(strArray(1))
                strCannotSaved = CStr(strArray(2))

                If strSaved <> "" Then
                    strArray(0) = "SAVED"
                    strArray(1) = objErrHandle.GetErrorDescParameter("INS", objErrHandle.GetErrorDesc("PT"))
                Else
                    strArray(0) = "NSAVED"
                    strArray(1) = strCannotSaved
                End If


            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigGeneral", "SavePayType", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strArray
        End Function
        Public Function UpdatePayType(ByVal xmlDoc As String) As String()
            Dim strResult As String = ""
            Dim strArray As Array
            Dim strError As String
            Dim strSaved As String = ""
            Dim strCannotSaved As String = ""
            Try
                strResult = objConfigSettingsDO.UpdatePaymentType(xmlDoc)
                strArray = strResult.Split(",")
                strError = strArray(0)
                strSaved = CStr(strArray(0))
                strCannotSaved = CStr(strArray(1))

                If strSaved = "0" Then
                    If (strCannotSaved <> "0") Then
                        strArray(0) = "UPDATED"
                        strArray(1) = objErrHandle.GetErrorDescParameter("DUPDATE", objErrHandle.GetErrorDesc("PT"))
                    End If
                Else
                    strArray(0) = "NUPDATED"
                    strArray(1) = strCannotSaved
                End If


            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigGeneral", "UpdatePayType", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strArray
        End Function
        Public Function DeletePayType(ByVal xmlDoc As String) As String()
            Dim strResult As String = ""
            Dim strArray As Array
            Dim strError As String
            Dim strRecordsDeleted As String = ""
            Dim strRecordsNotDeleted As String = ""
            Try
                strResult = objConfigSettingsDO.DeleteHPConfig(xmlDoc)
                strArray = strResult.Split(",")
                strError = strArray(0)
                strRecordsDeleted = CStr(strArray(1))
                strRecordsNotDeleted = CStr(strArray(2))

                If strRecordsDeleted <> "" Then
                    strArray(0) = "DEL"
                    strArray(1) = objErrHandle.GetErrorDescParameter("DDEL", strRecordsDeleted)
                ElseIf strRecordsNotDeleted <> "" Then
                    strArray(0) = "NDEL"
                    strArray(1) = objErrHandle.GetErrorDesc("UNDEL")
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigGeneral", "DeletePayType", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strArray
        End Function
        Public Function SaveVATCode(ByVal xmlDoc As String) As String()
            Dim strResult As String = ""
            Dim strArray As Array
            Dim strError As String
            Dim strSaved As String = ""
            Dim count As String = ""
            Try
                strResult = objConfigWODO.SaveVATCode(xmlDoc)
                strArray = strResult.Split(",")
                strError = strArray(0)
                strSaved = CStr(strArray(0))
                count = CStr(strArray(1))

                If strSaved = "0" Then
                    strArray(0) = "SAVED"
                    strArray(1) = objErrHandle.GetErrorDescParameter("INS", objErrHandle.GetErrorDesc("VAT"))
                ElseIf strResult <> "0" Then
                    strArray(0) = "NSAVED"
                    strArray(1) = objErrHandle.GetErrorDesc("RDE")
                End If


            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigGeneral", "SaveVATCode", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strArray
        End Function

        Public Function UpdateVATCode(ByVal xmlDoc As String) As String()
            Dim strResult As String = ""
            Dim strArray As Array
            Dim strError As String
            Dim strSaved As String = ""
            Dim count As String = ""
            Try
                strResult = objConfigWODO.UpdateVATCode(xmlDoc)
                strArray = strResult.Split(",")
                strError = strArray(0)
                strSaved = CStr(strArray(0))
                count = CStr(strArray(1))

                If strSaved = "0" Then
                    strArray(0) = "UPDATED"
                    strArray(1) = objErrHandle.GetErrorDescParameter("DUPDATE", objErrHandle.GetErrorDesc("VAT"))
                End If


            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigGeneral", "UpdateVATCode", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strArray
        End Function
        Public Function DeleteVATCode(ByVal xmlDoc As String) As String()
            Dim strResult As String = ""
            Dim strArray As Array
            Dim strError As String
            Dim strRecordsDeleted As String = ""
            Dim strRecordsNotDeleted As String = ""
            Try
                strResult = objConfigWODO.DeleteVATCode(xmlDoc)
                strArray = strResult.Split(",")
                strError = strArray(0)
                strRecordsDeleted = CStr(strArray(2))
                strRecordsNotDeleted = CStr(strArray(1))

                If strError = "0" Then
                    If (strRecordsDeleted <> "0") Then
                        strArray(0) = "DEL"
                        strArray(1) = objErrHandle.GetErrorDescParameter("DEL", objErrHandle.GetErrorDesc("VAT"))
                    End If
                    If (strRecordsNotDeleted <> "0") Then
                        strArray(0) = "UNDEL"
                        strArray(1) = objErrHandle.GetErrorDescParameter("UNDEL", objErrHandle.GetErrorDesc("VAT"))
                    End If
                Else
                    strArray(0) = "UNDEL"
                    strArray(1) = objErrHandle.GetErrorDescParameter("UNDEL", objErrHandle.GetErrorDesc("VAT"))
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigGeneral", "DeleteVATCode", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strArray
        End Function

        Public Function SaveWorkOrderConfig(ByVal objCongfigWO As ConfigWorkOrderBO) As String()
            Dim strResult As String = ""
            Dim strRes(1) As String

            Try
                strResult = objConfigWODO.SaveWorkOrderConfig(objCongfigWO)

                If (strResult = "ALUSED") Then
                    strRes(0) = "ALUSED"
                    strRes(1) = objErrHandle.GetErrorDescParameter("INUSE")
                ElseIf (strResult = "ERRSER") Then
                    strRes(0) = "ERRSER"
                    strRes(1) = objErrHandle.GetErrorDescParameter("INUSE", objErrHandle.GetErrorDesc("MSG069"))
                ElseIf (strResult = "INST") Then
                    strRes(0) = "INST"
                    strRes(1) = objErrHandle.GetErrorDescParameter("INS", objErrHandle.GetErrorDesc("WO"))
                ElseIf (strResult = "UPDATE") Then
                    strRes(0) = "UPDATE"
                    strRes(1) = objErrHandle.GetErrorDescParameter("UPD", objErrHandle.GetErrorDesc("WO"))
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigGeneral", "SaveWorkOrderConfig", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strRes
        End Function

        Public Function SaveWOCopy(ByVal subId As String, ByVal deptId As String, ByVal copySubId As String, ByVal copyDeptId As String) As String
            Dim strResult As String = ""
            Try
                strResult = objConfigWODO.SaveWOCopy(subId, deptId, copySubId, copyDeptId)

                If (strResult <> "0") Then
                    strResult = objErrHandle.GetErrorDescParameter("COPY", objErrHandle.GetErrorDesc("WO"))
                Else
                    strResult = ""
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigGeneral", "SaveWOCopy", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strResult
        End Function


    End Class
End Namespace

