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
Namespace CARS.Services.ConfigCustomer
    Public Class ConfigCustomer
        Shared objCommonUtil As New CARS.Utilities.CommonUtility
        Shared objConfigCustDO As New CARS.ConfigCustomer.ConfigCustomerDO
        Shared objConfigCustBO As New ConfigCustomerBO
        Shared objConfigWODO As New ConfigWorkOrder.ConfigWorkOrderDO
        Shared objConfigSettingsDO As New CARS.ConfigSettings.ConfigSettingsDO
        Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
        Dim objDB As Database
        Dim ConnectionString As String
        Public Function Fetch_ConfigDetails(ByVal UserId As String) As Collection
            Dim dsCustDetails As New DataSet
            Dim dtCustDetails As New DataTable
            Dim dt As New Collection
            dsCustDetails = objConfigCustDO.Fetch_CustomerConfiguration(UserId)
            If dsCustDetails.Tables(0).Rows.Count > 0 Then
                dtCustDetails = dsCustDetails.Tables(0)
                Dim details As New List(Of ConfigCustomerBO)()
                For Each dtrow As DataRow In dtCustDetails.Rows
                    Dim custDet As New ConfigCustomerBO()
                    custDet.Region = IIf(IsDBNull(dtrow("Description")) = True, "", dtrow("Description"))
                    custDet.Id_Settings = IIf(IsDBNull(dtrow("ID_SETTINGS")) = True, "", dtrow("ID_SETTINGS"))
                    details.Add(custDet)
                Next
                dt.Add(details)
            Else
                dtCustDetails = dsCustDetails.Tables(0)
                Dim details As New List(Of ConfigCustomerBO)()
                dt.Add(details)
            End If
            If dsCustDetails.Tables(1).Rows.Count > 0 Then
                dtCustDetails = dsCustDetails.Tables(1)
                Dim details As New List(Of ConfigCustomerBO)()
                For Each dtrow As DataRow In dtCustDetails.Rows
                    Dim custDet As New ConfigCustomerBO()
                    custDet.Id_Settings = IIf(IsDBNull(dtrow("ID_PT_SEQ")) = True, "", dtrow("ID_PT_SEQ"))
                    custDet.Pay_Type = IIf(IsDBNull(dtrow("PAY_CODE")) = True, "", dtrow("PAY_CODE"))
                    custDet.Id_Pay_Term = IIf(IsDBNull(dtrow("PAY_TERMS")) = True, "", dtrow("PAY_TERMS"))
                    custDet.Flg_Freemonth = IIf(IsDBNull(dtrow("FREEMONTH")) = True, "", dtrow("FREEMONTH"))
                    custDet.Pay_Description = IIf(IsDBNull(dtrow("PAY_DESC")) = True, "", dtrow("PAY_DESC"))
                    details.Add(custDet)
                Next
                dt.Add(details)
            Else
                dtCustDetails = dsCustDetails.Tables(1)
                Dim details As New List(Of ConfigCustomerBO)()
                dt.Add(details)
            End If
            If dsCustDetails.Tables(2).Rows.Count > 0 Then
                dtCustDetails = dsCustDetails.Tables(2)
                Dim details As New List(Of ConfigCustomerBO)()
                For Each dtrow As DataRow In dtCustDetails.Rows
                    Dim custDet As New ConfigCustomerBO()
                    custDet.Id_Settings = IIf(IsDBNull(dtrow("ID_SETTINGS")) = True, "", dtrow("ID_SETTINGS"))
                    custDet.Id_Cust_Group = IIf(IsDBNull(dtrow("CUST_GROUP")) = True, "", dtrow("CUST_GROUP"))
                    custDet.Cust_Pc = IIf(IsDBNull(dtrow("PRICE_CODE")) = True, "", dtrow("PRICE_CODE"))
                    custDet.Cust_AccCode = IIf(IsDBNull(dtrow("CUST_ACCCODE")) = True, "", dtrow("CUST_ACCCODE"))
                    custDet.Pay_Type = IIf(IsDBNull(dtrow("PAY_TYPE")) = True, "", dtrow("PAY_TYPE"))
                    custDet.Id_Pay_Term = IIf(IsDBNull(dtrow("PAY_TERM")) = True, "", dtrow("PAY_TERM"))
                    custDet.Vat_Code = IIf(IsDBNull(dtrow("VAT_CODE")) = True, "", dtrow("VAT_CODE"))
                    custDet.Discount_Code = IIf(IsDBNull(dtrow("DISC_CODE")) = True, "", dtrow("DISC_CODE"))
                    custDet.Cust_GrpDesc = IIf(IsDBNull(dtrow("DESCRIPTION")) = True, "", dtrow("DESCRIPTION"))
                    custDet.Currency = IIf(IsDBNull(dtrow("PAY_CURR")) = True, "", dtrow("PAY_CURR"))
                    custDet.UseIntCustomer = IIf(IsDBNull(dtrow("USE_INTCUST")) = True, "", dtrow("USE_INTCUST"))
                    details.Add(custDet)
                Next
                dt.Add(details)
            Else
                dtCustDetails = dsCustDetails.Tables(2)
                Dim details As New List(Of ConfigCustomerBO)()
                dt.Add(details)
            End If
            If dsCustDetails.Tables(3).Rows.Count > 0 Then
                dtCustDetails = dsCustDetails.Tables(3)
                Dim details As New List(Of ConfigCustomerBO)()
                For Each dtrow As DataRow In dtCustDetails.Rows
                    Dim custDet As New ConfigCustomerBO()
                    custDet.Id_Settings = IIf(IsDBNull(dtrow("ID_SETTINGS")) = True, "", dtrow("ID_SETTINGS"))
                    custDet.PriceCodeDesc = IIf(IsDBNull(dtrow("DESCRIPTION")) = True, "", dtrow("DESCRIPTION"))
                    details.Add(custDet)
                Next
                dt.Add(details)
            End If
            If dsCustDetails.Tables(4).Rows.Count > 0 Then
                dtCustDetails = dsCustDetails.Tables(4)
                Dim details As New List(Of ConfigCustomerBO)()
                For Each dtrow As DataRow In dtCustDetails.Rows
                    Dim custDet As New ConfigCustomerBO()
                    custDet.Id_Settings = IIf(IsDBNull(dtrow("ID_PT_SEQ")) = True, "", dtrow("ID_PT_SEQ"))
                    custDet.Pay_Description = IIf(IsDBNull(dtrow("PAY_DESC")) = True, "", dtrow("PAY_DESC"))
                    details.Add(custDet)
                Next
                dt.Add(details)
            End If
            If dsCustDetails.Tables(6).Rows.Count > 0 Then
                dtCustDetails = dsCustDetails.Tables(6)
                Dim details As New List(Of ConfigCustomerBO)()
                For Each dtrow As DataRow In dtCustDetails.Rows
                    Dim custDet As New ConfigCustomerBO()
                    custDet.Id_Settings = IIf(IsDBNull(dtrow("ID_SETTINGS")) = True, "", dtrow("ID_SETTINGS"))
                    custDet.Discount_Description = IIf(IsDBNull(dtrow("DESCRIPTION")) = True, "", dtrow("DESCRIPTION"))
                    details.Add(custDet)
                Next
                dt.Add(details)
            End If
            If dsCustDetails.Tables(5).Rows.Count > 0 Then
                dtCustDetails = dsCustDetails.Tables(5)
                Dim details As New List(Of ConfigCustomerBO)()
                For Each dtrow As DataRow In dtCustDetails.Rows
                    Dim custDet As New ConfigCustomerBO()
                    custDet.Id_Settings = IIf(IsDBNull(dtrow("ID_SETTINGS")) = True, "", dtrow("ID_SETTINGS"))
                    custDet.Vat_Description = IIf(IsDBNull(dtrow("DESCRIPTION")) = True, "", dtrow("DESCRIPTION"))
                    details.Add(custDet)
                Next
                dt.Add(details)
            End If
            If dsCustDetails.Tables(7).Rows.Count > 0 Then
                dtCustDetails = dsCustDetails.Tables(7)
                Dim details As New List(Of ConfigCustomerBO)()
                For Each dtrow As DataRow In dtCustDetails.Rows
                    Dim custDet As New ConfigCustomerBO()
                    custDet.Id_Settings = IIf(IsDBNull(dtrow("ID_SETTINGS")) = True, "", dtrow("ID_SETTINGS"))
                    custDet.Pay_Description = IIf(IsDBNull(dtrow("DESCRIPTION")) = True, "", dtrow("DESCRIPTION"))
                    details.Add(custDet)
                Next
                dt.Add(details)
            End If
            If dsCustDetails.Tables(8).Rows.Count > 0 Then
                dtCustDetails = dsCustDetails.Tables(8)
                Dim details As New List(Of ConfigCustomerBO)()
                For Each dtrow As DataRow In dtCustDetails.Rows
                    Dim custDet As New ConfigCustomerBO()
                    custDet.Id_Settings = IIf(IsDBNull(dtrow("ID_SETTINGS")) = True, "", dtrow("ID_SETTINGS"))
                    custDet.Warn_Text = IIf(IsDBNull(dtrow("DESCRIPTION")) = True, "", dtrow("DESCRIPTION"))
                    details.Add(custDet)
                Next
                dt.Add(details)
            Else
                dtCustDetails = dsCustDetails.Tables(8)
                Dim details As New List(Of ConfigCustomerBO)()
                dt.Add(details)
            End If
            If dsCustDetails.Tables(11).Rows.Count > 0 Then
                dtCustDetails = dsCustDetails.Tables(11)
                Dim details As New List(Of ConfigCustomerBO)()
                For Each dtrow As DataRow In dtCustDetails.Rows
                    Dim custDet As New ConfigCustomerBO()

                    custDet.Id_Settings = IIf(IsDBNull(dtrow("GM_PRICE_SEQ")) = True, "", dtrow("GM_PRICE_SEQ"))
                    custDet.DeptName = IIf(IsDBNull(dtrow("DPT_NAME")) = True, "", dtrow("DPT_NAME"))
                    custDet.IdDept = IIf(IsDBNull(dtrow("ID_DEPT")) = True, "", dtrow("ID_DEPT"))
                    custDet.Id_Cust_Group_Seq = IIf(IsDBNull(dtrow("Id_Cust_Grp_seq")) = True, "", dtrow("Id_Cust_Grp_seq"))
                    custDet.Id_Cust_Group = IIf(IsDBNull(dtrow("CUST_GROUP")) = True, "", dtrow("CUST_GROUP"))
                    custDet.Garg_Price_Per = IIf(IsDBNull(dtrow("GARAGE_PRICE_PER")) = True, "", dtrow("GARAGE_PRICE_PER"))
                    custDet.Description = IIf(IsDBNull(dtrow("GP_DESCRIPTION")) = True, "", dtrow("GP_DESCRIPTION"))
                    custDet.Vat_Description = IIf(IsDBNull(dtrow("VAT_DESC")) = True, "", dtrow("VAT_DESC"))
                    custDet.GP_AccCode = IIf(IsDBNull(dtrow("GP_ACCCODE")) = True, "", dtrow("GP_ACCCODE"))
                    details.Add(custDet)
                Next
                dt.Add(details)
            Else
                dtCustDetails = dsCustDetails.Tables(11)
                Dim details As New List(Of ConfigCustomerBO)()
                dt.Add(details)
            End If
            If dsCustDetails.Tables(12).Rows.Count > 0 Then
                dtCustDetails = dsCustDetails.Tables(12)
                Dim details As New List(Of ConfigCustomerBO)()
                For Each dtrow As DataRow In dtCustDetails.Rows
                    Dim custDet As New ConfigCustomerBO()
                    custDet.Id_Settings = IIf(IsDBNull(dtrow("ID_DEPT")) = True, "", dtrow("ID_DEPT"))
                    custDet.DeptName = IIf(IsDBNull(dtrow("DPT_NAME")) = True, "", dtrow("DPT_NAME"))
                    details.Add(custDet)
                Next
                dt.Add(details)
            End If

            If dsCustDetails.Tables(13).Rows.Count > 0 Then
                dtCustDetails = dsCustDetails.Tables(13)
                Dim details As New List(Of ConfigCustomerBO)()
                For Each dtrow As DataRow In dtCustDetails.Rows
                    Dim custDet As New ConfigCustomerBO()
                    custDet.Id_Settings = IIf(IsDBNull(dtrow("ID_CUST_GRP_SEQ")) = True, "", dtrow("ID_CUST_GRP_SEQ"))
                    custDet.Cust_GrpDesc = IIf(IsDBNull(dtrow("CUST_GROUP")) = True, "", dtrow("CUST_GROUP"))
                    details.Add(custDet)
                Next
                dt.Add(details)
            End If

            If dsCustDetails.Tables(15).Rows.Count > 0 Then
                dtCustDetails = dsCustDetails.Tables(15)
                Dim details As New List(Of ConfigCustomerBO)()
                For Each dtrow As DataRow In dtCustDetails.Rows
                    Dim custDet As New ConfigCustomerBO()
                    custDet.Id_Settings = IIf(IsDBNull(dtrow("ID_SETTINGS")) = True, "", dtrow("ID_SETTINGS"))
                    custDet.Description = IIf(IsDBNull(dtrow("DESCRIPTION")) = True, "", dtrow("DESCRIPTION"))
                    details.Add(custDet)
                Next
                dt.Add(details)
            End If

            If dsCustDetails.Tables(17).Rows.Count > 0 Then
                dtCustDetails = dsCustDetails.Tables(17)
                Dim details As New List(Of ConfigCustomerBO)()
                For Each dtrow As DataRow In dtCustDetails.Rows
                    Dim custDet As New ConfigCustomerBO()

                    custDet.Id_Rp_Code = IIf(IsDBNull(dtrow("ID_RP_CODE")) = True, "", dtrow("ID_RP_CODE"))
                    custDet.Cust_Name = IIf(IsDBNull(dtrow("CUST_NAME")) = True, "", dtrow("CUST_NAME"))
                    custDet.Flg_Price = IIf(IsDBNull(dtrow("FLG_PRICE")) = True, "", dtrow("FLG_PRICE"))
                    custDet.Price = IIf(IsDBNull(dtrow("PRICE")) = True, "", dtrow("PRICE"))
                    custDet.Id_Map_Seq = IIf(IsDBNull(dtrow("ID_MAP_SEQ")) = True, "", dtrow("ID_MAP_SEQ"))
                    custDet.Id_Rp = IIf(IsDBNull(dtrow("ID_RP")) = True, "", dtrow("ID_RP"))
                    custDet.Id_Customer = IIf(IsDBNull(dtrow("ID_CUSTOMER")) = True, "", dtrow("ID_CUSTOMER"))
                    details.Add(custDet)
                Next
                dt.Add(details)
            Else
                dtCustDetails = dsCustDetails.Tables(17)
                Dim details As New List(Of ConfigCustomerBO)()
                dt.Add(details)
            End If

            If dsCustDetails.Tables(10).Rows.Count > 0 Then
                dtCustDetails = dsCustDetails.Tables(10)
                Dim details As New List(Of ConfigCustomerBO)()
                For Each dtrow As DataRow In dtCustDetails.Rows
                    Dim custDet As New ConfigCustomerBO()
                    custDet.Cust_Start = IIf(IsDBNull(dtrow("CUST_START_NO")) = True, "", dtrow("CUST_START_NO"))
                    custDet.Cust_End = IIf(IsDBNull(dtrow("CUST_END_NO")) = True, "", dtrow("CUST_END_NO"))

                    details.Add(custDet)
                Next
                dt.Add(details)
            End If

            If dsCustDetails.Tables(9).Rows.Count > 0 Then
                dtCustDetails = dsCustDetails.Tables(9)
                Dim details As New List(Of ConfigCustomerBO)()
                For Each dtrow As DataRow In dtCustDetails.Rows
                    Dim custDet As New ConfigCustomerBO()
                    custDet.Id_Customer = IIf(IsDBNull(dtrow("RECENT_CUSTID")) = True, "", dtrow("RECENT_CUSTID"))
                    details.Add(custDet)
                Next
                dt.Add(details)
            End If

            Return dt
        End Function
        Public Function SaveCustRegConfig(ByVal strXMLSettingsInsert As String, ByVal IdLogin As String) As List(Of ConfigCustomerBO)
            Dim dsCustDetails As New DataSet
            Dim dtCustDetails As New DataTable
            Dim details As New List(Of ConfigCustomerBO)()
            Dim strArray As Array
            Dim strResult As String = ""
            strResult = objConfigSettingsDO.InsertConfig(strXMLSettingsInsert)
            strArray = strResult.Split(",")
            Dim custDet As New ConfigCustomerBO()
            If strArray.Length > 0 Then
                custDet.RetVal_Saved = strArray(2)
                custDet.RetVal_NotSaved = strArray(1)
                details.Add(custDet)
            End If
            Return details.ToList
        End Function
        Public Function SaveCustPayConfig(ByVal strXMLSettingsInsert As String, ByVal IdLogin As String) As List(Of ConfigCustomerBO)
            Dim dsCustDetails As New DataSet
            Dim dtCustDetails As New DataTable
            Dim details As New List(Of ConfigCustomerBO)()
            Dim strArray As Array
            Dim strResult As String = ""
            strResult = objConfigCustDO.Insert_Config_PayTerm(strXMLSettingsInsert, IdLogin)
            strArray = strResult.Split(",")
            Dim custDet As New ConfigCustomerBO()
            If strArray.Length > 0 Then
                custDet.RetVal_Saved = strArray(2)
                custDet.RetVal_NotSaved = strArray(1)
                details.Add(custDet)
            End If
            Return details.ToList
        End Function
        Public Function SaveCustGrpConfig(ByVal strXMLSettingsInsert As String, ByVal IdLogin As String) As List(Of ConfigCustomerBO)
            Dim dsCustDetails As New DataSet
            Dim dtCustDetails As New DataTable
            Dim details As New List(Of ConfigCustomerBO)()
            Dim strArray As Array
            Dim strResult As String = ""
            strResult = objConfigCustDO.Insert_Config_CustGroup(strXMLSettingsInsert, IdLogin)
            strArray = strResult.Split(",")
            Dim custDet As New ConfigCustomerBO()
            If strArray.Length > 0 Then
                custDet.RetVal_Saved = strArray(2)
                custDet.RetVal_NotSaved = strArray(1)
                details.Add(custDet)
            End If
            Return details.ToList
        End Function
        Public Function SaveWarningConfig(ByVal strXMLSettingsInsert As String, ByVal IdLogin As String) As List(Of ConfigCustomerBO)
            Dim dsCustDetails As New DataSet
            Dim dtCustDetails As New DataTable
            Dim details As New List(Of ConfigCustomerBO)()
            Dim strArray As Array
            Dim strResult As String = ""
            strResult = objConfigSettingsDO.InsertConfig(strXMLSettingsInsert)
            strArray = strResult.Split(",")
            Dim custDet As New ConfigCustomerBO()
            If strArray.Length > 0 Then
                custDet.RetVal_Saved = strArray(2)
                custDet.RetVal_NotSaved = strArray(1)
                details.Add(custDet)
            End If
            Return details.ToList
        End Function
        Public Function SaveGMPrice(ByVal strXMLSettingsInsert As String, ByVal IdLogin As String) As List(Of ConfigCustomerBO)
            Dim dsCustDetails As New DataSet
            Dim dtCustDetails As New DataTable
            Dim details As New List(Of ConfigCustomerBO)()
            Dim strArray As Array
            Dim strResult As String = ""
            strResult = objConfigCustDO.Insert_Config_GaragePrice(strXMLSettingsInsert, IdLogin)
            strArray = strResult.Split(",")
            Dim custDet As New ConfigCustomerBO()
            If strArray.Length > 0 Then
                custDet.RetVal_Saved = strArray(2)
                custDet.RetVal_NotSaved = strArray(1)
                details.Add(custDet)
            End If
            Return details.ToList
        End Function
        Public Function InsertCustRP(ByVal objCustConfigBO As ConfigCustomerBO) As String
            Dim dsCustDetails As New DataSet
            Dim dtCustDetails As New DataTable
            Dim details As New List(Of ConfigCustomerBO)()
            Dim strResult As String = ""
            Try
                strResult = objConfigCustDO.Insert_CustRP(objCustConfigBO)

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigCustomer", "InsertCustRP", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strResult
        End Function
        Public Function AddCustomerID(ByVal objCustConfigBO As ConfigCustomerBO) As List(Of ConfigCustomerBO)
            Dim dsCustDetails As New DataSet
            Dim dtCustDetails As New DataTable
            Dim details As New List(Of ConfigCustomerBO)()
            Dim strResult As String = ""

            Try
                Dim CustDet As New ConfigCustomerBO()
                If objCustConfigBO.Cust_Start = "" Then
                    CustDet.ErrMsg = objErrHandle.GetErrorDesc("MSG175")
                    CustDet.SuccMsg = ""
                End If
                If objCustConfigBO.Cust_End = "" Then
                    CustDet.ErrMsg = objErrHandle.GetErrorDesc("MSG176")
                    CustDet.SuccMsg = ""
                End If
                strResult = objConfigCustDO.Add_CustomerID(objCustConfigBO)
                If strResult = "F" Then
                    CustDet.ErrMsg = ""
                    CustDet.SuccMsg = objErrHandle.GetErrorDescParameter("AEXISTS", objErrHandle.GetErrorDesc("CS"))
                ElseIf strResult = "T" Then
                    CustDet.ErrMsg = ""
                    CustDet.SuccMsg = objErrHandle.GetErrorDesc("CIDSUCC")
                End If
                details.Add(CustDet)
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigCustomer", "AddCustomerID", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function UpdateCustRP(ByVal objCustConfigBO As ConfigCustomerBO) As String
            Dim dsCustDetails As New DataSet
            Dim dtCustDetails As New DataTable
            Dim details As New List(Of ConfigCustomerBO)()
            Dim strResult As String = ""
            Try
                strResult = objConfigCustDO.Update_CustRP(objCustConfigBO)

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigCustomer", "UpdateCustRP", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strResult
        End Function
        Public Function UpdateCustRegConfig(ByVal strXmlUpd As String, ByVal strXmlUpdPay As String, ByVal strXmlUpdGrp As String, ByVal strxmlUpdGM As String, ByVal IdLogin As String) As List(Of ConfigCustomerBO)
            Dim dsCustDetails As New DataSet
            Dim dtCustDetails As New DataTable
            Dim details As New List(Of ConfigCustomerBO)()
            Dim strArray As Array
            Dim strResult As String = ""
            strResult = objConfigSettingsDO.UpdateConfigPayGrp(strXmlUpd, strXmlUpdPay, strXmlUpdGrp, strxmlUpdGM, IdLogin)
            strArray = strResult.Split(",")
            Dim custDet As New ConfigCustomerBO()
            If strArray.Length > 0 Then
                custDet.RetVal_Saved = strArray(2)
                custDet.RetVal_NotSaved = strArray(1)
                details.Add(custDet)
            End If
            Return details.ToList
        End Function
        Public Function UpdateCustPayConfig(ByVal strXmlUpd As String, ByVal strXmlUpdPay As String, ByVal strXmlUpdGrp As String, ByVal strxmlUpdGM As String, ByVal IdLogin As String) As List(Of ConfigCustomerBO)
            Dim dsCustDetails As New DataSet
            Dim dtCustDetails As New DataTable
            Dim details As New List(Of ConfigCustomerBO)()
            Dim strArray As Array
            Dim strResult As String = ""
            strResult = objConfigSettingsDO.UpdateConfigPayGrp(strXmlUpd, strXmlUpdPay, strXmlUpdGrp, strxmlUpdGM, IdLogin)
            strArray = strResult.Split(",")
            Dim custDet As New ConfigCustomerBO()
            If strArray.Length > 0 Then
                custDet.RetVal_Saved = strArray(2)
                custDet.RetVal_NotSaved = strArray(1)
                details.Add(custDet)
            End If
            Return details.ToList
        End Function
        Public Function DeleteConfig(ByVal strxml As String) As String()
            Dim strResult As String = ""
            Dim strArray As Array
            Dim strError As String
            Dim strRecordsDeleted As String = ""
            Dim strRecordsNotDeleted As String = ""
            Try
                strResult = objConfigSettingsDO.DeleteConfig(strxml)
                strArray = strResult.Split(",")
                strError = strArray(0)
                strRecordsDeleted = CStr(strArray(1))
                strRecordsNotDeleted = CStr(strArray(2))

                If strRecordsDeleted <> "" Then
                    strArray(0) = "DEL"
                    strArray(1) = objErrHandle.GetErrorDescParameter("DDEL", strRecordsDeleted)
                End If

                If strRecordsNotDeleted <> "" Then
                    strArray(0) = "NDEL"
                    strArray(1) = objErrHandle.GetErrorDesc("UNDEL")
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigCustomer", "DeleteConfigMake", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strArray
        End Function
        Public Function DeleteCusGConfig(ByVal strxml As String) As String()
            Dim strResult As String = ""
            Dim strArray As Array
            Dim strError As String
            Dim strRecordsDeleted As String = ""
            Dim strRecordsNotDeleted As String = ""
            Try
                strResult = objConfigCustDO.Delete_Config_CustGroup(strxml)
                strArray = strResult.Split(",")
                strError = strArray(0)
                strRecordsDeleted = CStr(strArray(1))
                strRecordsNotDeleted = CStr(strArray(2))

                If strRecordsDeleted <> "" Then
                    strArray(0) = "DEL"
                    strArray(1) = objErrHandle.GetErrorDescParameter("DDEL", strRecordsDeleted)
                End If

                If strRecordsNotDeleted <> "" Then
                    strArray(0) = "NDEL"
                    strArray(1) = objErrHandle.GetErrorDesc("UNDEL")
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigCustomer", "DeleteConfigMake", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strArray
        End Function
        Public Function DeleteGMPrice(ByVal strxml As String) As String()
            Dim strResult As String = ""
            Dim strArray As Array
            Dim strError As String
            Dim strRecordsDeleted As String = ""
            Dim strRecordsNotDeleted As String = ""
            Try
                strResult = objConfigCustDO.Delete_Config_GaragePrice(strxml)
                strArray = strResult.Split(",")
                strError = strArray(0)
                strRecordsDeleted = CStr(strArray(1))
                strRecordsNotDeleted = CStr(strArray(2))

                If strRecordsDeleted <> "" Then
                    strArray(0) = "DEL"
                    strArray(1) = objErrHandle.GetErrorDescParameter("DDEL", strRecordsDeleted)
                End If

                If strRecordsNotDeleted <> "" Then
                    strArray(0) = "NDEL"
                    strArray(1) = objErrHandle.GetErrorDesc("UNDEL")
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigCustomer", "DeleteConfigMake", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strArray
        End Function
        Public Function DeletePTConfig(ByVal strxml As String) As String()
            Dim strResult As String = ""
            Dim strArray As Array
            Dim strError As String
            Dim strRecordsDeleted As String = ""
            Dim strRecordsNotDeleted As String = ""
            Try
                strResult = objConfigCustDO.Delete_Config_PayTerm(strxml)
                strArray = strResult.Split(",")
                strError = strArray(0)
                strRecordsDeleted = CStr(strArray(1))
                strRecordsNotDeleted = CStr(strArray(2))

                If strRecordsDeleted <> "" Then
                    strArray(0) = "DEL"
                    strArray(1) = objErrHandle.GetErrorDescParameter("DDEL", strRecordsDeleted)
                End If

                If strRecordsNotDeleted <> "" Then
                    strArray(0) = "NDEL"
                    strArray(1) = objErrHandle.GetErrorDesc("UNDEL")
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigCustomer", "DeletePTConfig", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strArray
        End Function
        Public Function DeleteCustRP(ByVal strxml As String) As String
            Dim strResult As String = ""
            Dim strRecordsDeleted As String = ""
            Dim strRecordsNotDeleted As String = ""
            Try
                strResult = objConfigCustDO.Delete_CustRP(strxml)
                If strResult = "DEL" Then
                    strResult = objErrHandle.GetErrorDescParameter("DDEL", "")
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigCustomer", "DeleteConfigMake", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strResult
        End Function
        Public Function GetDefaultCurrency() As List(Of ConfigCustomerBO)
            Dim dsCustDetails As New DataSet
            Dim dtCustDetails As New DataTable
            Dim details As New List(Of ConfigCustomerBO)()
            dsCustDetails = objConfigCustDO.GetDefaultCurrency()
            If dsCustDetails.Tables(0).Rows.Count > 0 Then
                dtCustDetails = dsCustDetails.Tables(0)
                For Each dtrow As DataRow In dtCustDetails.Rows
                    Dim custDet As New ConfigCustomerBO()
                    custDet.Currency = IIf(IsDBNull(dtrow("DESCRIPTION")) = True, "", dtrow("DESCRIPTION"))
                    details.Add(custDet)
                Next
            End If
            Return details.ToList
        End Function
        Public Function LoadRP() As List(Of ConfigCustomerBO)
            Dim dsCustDetails As New DataSet
            Dim dtCustDetails As New DataTable
            Dim details As New List(Of ConfigCustomerBO)()
            dsCustDetails = objConfigCustDO.Fetch_Repair_Package()
            If dsCustDetails.Tables(0).Rows.Count > 0 Then
                dtCustDetails = dsCustDetails.Tables(0)
                For Each dtrow As DataRow In dtCustDetails.Rows
                    Dim custDet As New ConfigCustomerBO()
                    custDet.Id_Rp = IIf(IsDBNull(dtrow("ID_RPKG_SEQ")) = True, "", dtrow("ID_RPKG_SEQ"))
                    custDet.Id_Rp_Code = IIf(IsDBNull(dtrow("ID_RP_CODE")) = True, "", dtrow("ID_RP_CODE"))
                    details.Add(custDet)
                Next
            End If
            Return details.ToList
        End Function
    End Class
End Namespace