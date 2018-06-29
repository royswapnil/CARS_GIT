Imports System
Imports System.Data.SqlClient
Imports System.Data
Imports System.IO
Imports System.Resources
Imports System.Reflection
Imports CARS.CoreLibrary.CARS
Imports System.Web
Imports Encryption
Imports System.Configuration
Imports MSGCOMMON
Imports System.Web.Security

Namespace CARS.Services.ConfigLA
    Public Class ConfigLA
        Shared objConfigLABO As New ConfigLABO
        Shared objConfigLADO As New CARS.ConfigLADO.ConfigLADO
        Shared objCommonUtil As New CARS.Utilities.CommonUtility
        Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
        Public Function FetchAllConfiguration() As Collection
            Dim dsConfigLA As New DataSet
            Dim dtConfigLA As New DataTable
            Dim dtConfigLAColl As New Collection
            Try
                dsConfigLA = objConfigLADO.FetchConfiguration()
                HttpContext.Current.Session("LAConfiguration") = dsConfigLA
                If dsConfigLA.Tables.Count > 0 Then
                    If (dsConfigLA.Tables(0).Rows.Count > 0) Then
                        dtConfigLA = dsConfigLA.Tables(0)
                        Dim details As New List(Of ConfigLABO)()
                        For Each dtrow As DataRow In dtConfigLA.Rows
                            Dim configLADet As New ConfigLABO()
                            configLADet.Acc_Cfg_Seq = dtrow("Acc_Cfg_Seq").ToString()
                            configLADet.Flg_Grouping = dtrow("Flg_Grouping").ToString()
                            configLADet.Flg_ExportMode = dtrow("Flg_ExportMode").ToString()
                            configLADet.Flg_Export_AllowMulMonths = dtrow("Flg_Export_AllowMulMonths").ToString()
                            configLADet.Flg_Export_EachInvoice = dtrow("Flg_Export_EachInvoice").ToString()
                            configLADet.Path_Export_InvJournal = dtrow("Path_Export_InvJournal").ToString()
                            configLADet.Path_Export_CustInfo = dtrow("Path_Export_CustInfo").ToString()
                            configLADet.Path_Import_CustInfo = dtrow("Path_Import_CustInfo").ToString()
                            configLADet.Path_Import_CustBal = dtrow("Path_Import_CustBal").ToString()
                            configLADet.Flg_Export_InvJournal_SeqNos = dtrow("Flg_Export_InvJournal_SeqNos").ToString()
                            configLADet.Flg_Export_Cust_SeqNos = dtrow("Flg_Export_Cust_SeqNos").ToString()
                            configLADet.Customer_ID = dtrow("Customer_ID").ToString()
                            configLADet.Cust_Ord_No = dtrow("Cust_Ord_No").ToString()
                            configLADet.Cust_Reg_No = dtrow("Cust_Reg_No").ToString()
                            configLADet.Cust_Vin_No = dtrow("Cust_Vin_No").ToString()
                            configLADet.Cust_Vin_No_Len = dtrow("Cust_Vin_No_Len").ToString()
                            configLADet.Customer_Name = dtrow("Customer_Name").ToString()
                            configLADet.Cust_Fixed_Text = dtrow("Cust_Fixed_Text").ToString()
                            configLADet.Invoice_Journal_Temp = dtrow("Invoice_Journal_Template").ToString()
                            configLADet.CustInfo_Temp = dtrow("Customer_Info_Template").ToString()
                            configLADet.Flg_Export_UseInvoiceNum = dtrow("Flg_Exp_Sort").ToString()
                            configLADet.Flg_Export_UseCreditnote = dtrow("Flg_CR_Exp").ToString()
                            configLADet.Flg_Export_UseBlankSp = dtrow("Flg_BL_Spacs").ToString()
                            configLADet.Flg_Export_UseCombLines = dtrow("Flg_Comb_Lines").ToString()
                            configLADet.Flg_Export_UseAddDate = dtrow("Flg_Add_Date").ToString()
                            configLADet.Flg_Export_UseSplit = dtrow("Flg_Split_Sub").ToString()
                            configLADet.Flg_Export_RemCost = dtrow("Flg_Rem_Cost").ToString()
                            configLADet.Flg_Export_UseAddText = dtrow("Flg_Add_Text").ToString()
                            configLADet.Flg_Export_UseAdditionalText = dtrow("Flg_Additinal_Text").ToString()
                            configLADet.Export_AddText = IIf(IsDBNull(dtrow("Add_Text")) = True, "", dtrow("Add_Text").ToString())
                            configLADet.Export_AdditionalText = IIf(IsDBNull(dtrow("Additinal_Text")) = True, "", dtrow("Additinal_Text"))
                            configLADet.Export_CustomerText = IIf(IsDBNull(dtrow("Customer_Text")) = True, "", dtrow("Customer_Text"))
                            configLADet.Flg_Export_UseCustomerText = dtrow("Flg_Customer_Text").ToString()
                            configLADet.Flg_Export_VocherType = dtrow("Flg_Display_Vocher").ToString()
                            configLADet.Export_VocherType = dtrow("Vocher_Type").ToString()
                            configLADet.Flg_Display_AllInvNum = dtrow("Flg_Display_All_InvNum").ToString()
                            configLADet.FP_Acc_Code = dtrow("Fixed_Pr_Acc_Code").ToString()
                            configLADet.Flg_Export_Valid = dtrow("Flg_Exprt_Vald").ToString()
                            configLADet.ErrInvoicesName = dtrow("Err_Invoices_Name").ToString()
                            configLADet.Flg_Use_Bill_Addr_Exp = dtrow("Err_Invoices_Name").ToString()
                            configLADet.Created_By = dtrow("CREATED_BY").ToString()
                            configLADet.Modified_By = dtrow("Modified_By").ToString()

                            If (IsDBNull(dtrow("DT_CREATED").ToString())) Then
                                configLADet.Dt_Created = ""
                            Else
                                configLADet.Dt_Created = objCommonUtil.GetCurrentLanguageDate(dtrow("DT_CREATED").ToString())
                            End If

                            If (IsDBNull(dtrow("DT_MODIFIED").ToString())) Then
                                configLADet.Dt_Modified = ""
                            Else
                                configLADet.Dt_Modified = objCommonUtil.GetCurrentLanguageDate(dtrow("DT_MODIFIED").ToString())
                            End If

                            If (dsConfigLA.Tables(1).Rows.Count > 0) Then
                                configLADet.PrefixFileName_Export_InvJournal = dsConfigLA.Tables(1).Rows(0)("PrefixFileName_Export_InvJournal").ToString()
                                configLADet.SuffixFileName_Export_InvJournal = dsConfigLA.Tables(1).Rows(0)("SuffixFileName_Export_InvJournal").ToString()
                                configLADet.Exp_InvJournal_Series = dsConfigLA.Tables(1).Rows(0)("Exp_InvJournal_Series").ToString()
                            End If

                            If (dsConfigLA.Tables(2).Rows.Count > 0) Then
                                configLADet.PrefixFileName_Export_CustInfo = dsConfigLA.Tables(2).Rows(0)("PrefixFileName_Export_CustInfo").ToString()
                                configLADet.SuffixFileName_Export_CustInfo = dsConfigLA.Tables(2).Rows(0)("SuffixFileName_Export_CustInfo").ToString()
                                configLADet.Exp_Cust_Series = dsConfigLA.Tables(2).Rows(0)("Exp_Cust_Series").ToString()
                            End If

                            If (dsConfigLA.Tables(3).Rows.Count > 0) Then
                                configLADet.Error_Acc_Code = dsConfigLA.Tables(3).Rows(0)("Error_Acc_Code").ToString()
                            End If

                            If (dsConfigLA.Tables(4).Rows.Count > 0) Then
                                configLADet.Sch_Basis = dsConfigLA.Tables(4).Rows(0)("Sch_Basis").ToString()

                                If (configLADet.Sch_Basis.ToString() = "D") Then
                                    configLADet.Sch_TimeFormat = dsConfigLA.Tables(4).Rows(0)("Sch_TimeFormat").ToString()
                                    configLADet.Sch_Daily_Interval_mins = dsConfigLA.Tables(4).Rows(0)("Sch_Daily_Interval_mins").ToString()
                                    configLADet.Sch_Daily_STime = dsConfigLA.Tables(4).Rows(0)("Sch_Daily_STime").ToString()
                                    configLADet.Sch_Daily_ETime = dsConfigLA.Tables(4).Rows(0)("Sch_Daily_ETime").ToString()
                                ElseIf (configLADet.Sch_Basis.ToString() = "M") Then
                                    configLADet.Sch_Month_Day = dsConfigLA.Tables(4).Rows(0)("Sch_Month_Day").ToString()
                                    configLADet.Sch_Month_Time = dsConfigLA.Tables(4).Rows(0)("Sch_Month_Time").ToString()
                                ElseIf (configLADet.Sch_Basis.ToString() = "W") Then
                                    configLADet.Sch_Week_Day = dsConfigLA.Tables(4).Rows(0)("Sch_Week_Day").ToString()
                                    configLADet.Sch_Week_Time = dsConfigLA.Tables(4).Rows(0)("Sch_Week_Time").ToString()
                                End If
                            End If

                            details.Add(configLADet)
                        Next
                        dtConfigLAColl.Add(details)
                    ElseIf (dsConfigLA.Tables(0).Rows.Count = 0) Then
                        dtConfigLA = dsConfigLA.Tables(0)
                        Dim details As New List(Of ConfigLABO)()
                        dtConfigLAColl.Add(details)
                    End If

                    'Export Type File Names for Inv Journal
                    If (dsConfigLA.Tables(5).Rows.Count > 0) Then
                        dtConfigLA = dsConfigLA.Tables(5)
                        Dim details As New List(Of ConfigLABO)()
                        For Each dtrow As DataRow In dtConfigLA.Rows
                            Dim configLADet As New ConfigLABO()
                            configLADet.Template_Id = dtrow("Template_Id").ToString()
                            configLADet.Template_Name = dtrow("Template_Name").ToString()
                            details.Add(configLADet)
                        Next
                        dtConfigLAColl.Add(details)
                    ElseIf (dsConfigLA.Tables(5).Rows.Count = 0) Then
                        dtConfigLA = dsConfigLA.Tables(5)
                        Dim details As New List(Of ConfigLABO)()
                        dtConfigLAColl.Add(details)
                    End If

                    'Export Type File Names for Customer
                    If (dsConfigLA.Tables(6).Rows.Count > 0) Then
                        dtConfigLA = dsConfigLA.Tables(6)
                        Dim details As New List(Of ConfigLABO)()
                        For Each dtrow As DataRow In dtConfigLA.Rows
                            Dim configLADet As New ConfigLABO()
                            configLADet.Template_Id = dtrow("Template_Id").ToString()
                            configLADet.Template_Name = dtrow("Template_Name").ToString()
                            details.Add(configLADet)
                        Next
                        dtConfigLAColl.Add(details)
                    ElseIf (dsConfigLA.Tables(6).Rows.Count = 0) Then
                        dtConfigLA = dsConfigLA.Tables(6)
                        Dim details As New List(Of ConfigLABO)()
                        dtConfigLAColl.Add(details)
                    End If
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigLA", "FetchAllConfiguration", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return dtConfigLAColl
        End Function

        Public Function FetchCustInfoSettings() As List(Of ConfigLABO)
            Dim details As New List(Of ConfigLABO)()
            Dim dsCustInfo As New DataSet
            Dim dtCustInfo As New DataTable
            Try
                dsCustInfo = objConfigLADO.FetchCustInfoSettings()
                If dsCustInfo.Tables.Count > 0 Then
                    dtCustInfo = dsCustInfo.Tables(0)
                    For Each dtrow As DataRow In dtCustInfo.Rows
                        Dim custInfo As New ConfigLABO()
                        custInfo.Cust_Series = dtrow("Cust_Series").ToString()
                        custInfo.Cust_Desc = dtrow("CUST_DESC").ToString()
                        details.Add(custInfo)
                    Next
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigLA", "FetchCustInfoSettings", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function

        Public Function SaveConfiguration(ByVal objConfigLABO As ConfigLABO) As String()
            Dim strResult As String
            Dim strValue(1) As String
            Dim dsConfig As DataSet = HttpContext.Current.Session("LAConfiguration")
            Try
                If (dsConfig.Tables.Count > 0) Then
                    If (dsConfig.Tables(0).Rows.Count > 0) Then

                        'config
                        strResult = objConfigLADO.AddConfiguration(False, True, False, False, False, False, objConfigLABO)
                        If (strResult = "0") Then
                            strValue(0) = "0"
                            strValue(1) = objErrHandle.GetErrorDesc("INSR")
                        Else
                            strValue(0) = "1"
                            strValue(1) = objErrHandle.GetErrorDesc("ConfigStatus")
                        End If

                        'journ_exp_seq
                        strResult = objConfigLADO.AddConfiguration(False, False, True, False, False, False, objConfigLABO)
                        If (strResult = "0") Then
                            strValue(0) = "0"
                            strValue(1) = objErrHandle.GetErrorDesc("INSR")
                        Else
                            strValue(0) = "1"
                            strValue(1) = objErrHandle.GetErrorDesc("ConfigStatus")
                        End If

                        'cust_exp_seq
                        strResult = objConfigLADO.AddConfiguration(False, False, False, True, False, False, objConfigLABO)
                        If (strResult = "0") Then
                            strValue(0) = "0"
                            strValue(1) = objErrHandle.GetErrorDesc("INSR")
                        Else
                            strValue(0) = "1"
                            strValue(1) = objErrHandle.GetErrorDesc("ConfigStatus")
                        End If

                        'acc_code
                        strResult = objConfigLADO.AddConfiguration(False, False, False, False, True, False, objConfigLABO)
                        If (strResult = "0") Then
                            strValue(0) = "0"
                            strValue(1) = objErrHandle.GetErrorDesc("INSR")
                        Else
                            strValue(0) = "1"
                            strValue(1) = objErrHandle.GetErrorDesc("ConfigStatus")
                        End If

                        'schedule
                        strResult = objConfigLADO.AddConfiguration(False, False, False, False, False, True, objConfigLABO)
                        If (strResult = "0") Then
                            strValue(0) = "0"
                            strValue(1) = objErrHandle.GetErrorDesc("INSR")
                        Else
                            strValue(0) = "1"
                            strValue(1) = objErrHandle.GetErrorDesc("ConfigStatus")
                        End If
                    Else
                        'firstUpdate
                        strResult = objConfigLADO.AddConfiguration(True, False, False, False, False, False, objConfigLABO)
                        If (strResult = "0") Then
                            strValue(0) = "0"
                            strValue(1) = objErrHandle.GetErrorDesc("INSR")
                        Else
                            strValue(0) = "1"
                            strValue(1) = objErrHandle.GetErrorDesc("ConfigStatus")
                        End If
                    End If

                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigLA", "SaveConfiguration", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strValue
        End Function






    End Class

End Namespace

