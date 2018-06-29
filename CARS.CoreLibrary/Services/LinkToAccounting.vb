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
Imports System.Globalization
Imports System.Xml
Imports System.Text
Imports System.Web.UI.Page
Namespace CARS.Services.LinkToAccounting
    Public Class LinkToAccounting
        Shared objCommonUtil As New CARS.Utilities.CommonUtility
        Shared objLADO As New CARS.LinkToAccountingDO.LinkToAccountingDO
        Shared objConfigDeptDO As New CARS.Department.ConfigDepartmentDO
        Shared objConfigDeptBO As New ConfigDepartmentBO
        Shared objLABO As New LinkToAccountingBO
        Shared objConfigLADO As New CARS.ConfigLADO.ConfigLADO
        Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
        Dim objDr() As DataRow
        Dim TemplateID As String
        Dim Char_Set As String
        Dim ExpMode As String
        Dim DataSeparator As String
        Dim dblValue As Decimal
        Dim boolVal As Boolean
        Dim StrReturn As String = ""
        Dim TableColumns As DataColumnCollection
        Dim TableRows As DataRowCollection
        Dim TableRowsgross As DataRowCollection
        Dim Config_Path As String
        Dim strFilename As String
        Dim ds_Config As New DataSet
        Dim Flg_DateCheck As String
        Dim Flg_Textcheck As String
        Dim Flg_AdditionalText As String
        Dim Flg_CustomerText As String
        Dim strErrlogMsg As String
        Dim dsfetchinvtransid As DataSet
        Dim lenghtp As Integer
        Dim lengthi As Integer
        Public Function Load_ConfigDetails() As Collection
            Dim dsLADetails As New DataSet
            Dim dtLADetails As New DataTable
            Dim dt As New Collection
            Try
                dsLADetails = objLADO.Fetch_AccountCodes()
                If dsLADetails.Tables(6).Rows.Count > 0 Then
                    dtLADetails = dsLADetails.Tables(6)
                    Dim details As New List(Of LinkToAccountingBO)()
                    For Each dtrow As DataRow In dtLADetails.Rows
                        Dim laDet As New LinkToAccountingBO()
                        laDet.Id_DeptId = dtrow("DPT_ID")
                        laDet.Id_DeptAcCode = dtrow("DPT_ACCCODE")
                        details.Add(laDet)
                    Next
                    dt.Add(details)
                End If

                If dsLADetails.Tables(1).Rows.Count > 0 Then
                    dtLADetails = dsLADetails.Tables(1)
                    Dim details As New List(Of LinkToAccountingBO)()
                    For Each dtrow As DataRow In dtLADetails.Rows
                        Dim laDet As New LinkToAccountingBO()
                        laDet.Id_CUSTOMER = dtrow("CUST_ID")
                        laDet.Id_CustGrpAcCode = dtrow("CUST_ACCCODE")
                        details.Add(laDet)
                    Next
                    dt.Add(details)
                End If

                If dsLADetails.Tables(5).Rows.Count > 0 Then
                    dtLADetails = dsLADetails.Tables(5)
                    Dim details As New List(Of LinkToAccountingBO)()
                    For Each dtrow As DataRow In dtLADetails.Rows
                        Dim laDet As New LinkToAccountingBO()
                        laDet.Id_VatCode = dtrow("VATSC")
                        details.Add(laDet)
                    Next
                    dt.Add(details)
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.LinkToAccounting", "Load_ConfigDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return dt
        End Function
        Public Function FetchLACodeList(ByVal deptCode As String, ByVal custGrpCode As String) As List(Of LinkToAccountingBO)
            Dim dsLACodeDet As New DataSet
            Dim dtLACodeDet As New DataTable
            Dim details As New List(Of LinkToAccountingBO)()
            Try
                dsLACodeDet = objLADO.Fetch_LACodeList(deptCode, custGrpCode)
                HttpContext.Current.Session("LACodeList") = dsLACodeDet
                If dsLACodeDet.Tables(0).Rows.Count > 0 Then
                    'Dim details As New List(Of LinkToAccountingBO)()
                    dtLACodeDet = dsLACodeDet.Tables(0)
                    For Each dtrow As DataRow In dtLACodeDet.Rows
                        Dim laDet As New LinkToAccountingBO()
                        laDet.Id_Matrix = dtrow("Id_Matrix")
                        laDet.Id_DeptAcCode = IIf(IsDBNull(dtrow("Dept_AcCode")) = True, "", dtrow("Dept_AcCode"))
                        laDet.Id_CustGrpAcCode = IIf(IsDBNull(dtrow("CustGrp_AcCode")) = True, "", dtrow("CustGrp_AcCode"))
                        laDet.Id_VatCode = IIf(IsDBNull(dtrow("VatCode")) = True, "", dtrow("VatCode"))
                        laDet.Id_SaleCode_Type = IIf(IsDBNull(dtrow("SaleCode_Type")) = True, "", dtrow("SaleCode_Type"))
                        laDet.AccountCode = IIf(IsDBNull(dtrow("AccCode")) = True, "", dtrow("AccCode"))
                        laDet.SellingGL = IIf(IsDBNull(dtrow("SELLINGGL")) = True, "", dtrow("SELLINGGL"))
                        laDet.CostGL = IIf(IsDBNull(dtrow("COSTGL")) = True, "", dtrow("COSTGL"))
                        laDet.Id_Description = IIf(IsDBNull(dtrow("Description")) = True, "", dtrow("Description"))
                        laDet.LAIdMatrix = dtrow("Id_Matrix")
                        details.Add(laDet)
                    Next
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.LinkToAccounting", "FetchLACodeList", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function

        Public Function FetchLAAccTypes(ByVal la_slno As String) As List(Of LinkToAccountingBO)
            Dim details As New List(Of LinkToAccountingBO)()
            Dim dsLACodeDet As New DataSet
            Dim dtLACodeDet As New DataTable
            Dim dvLACodeDet As New DataView
            Try
                dsLACodeDet = HttpContext.Current.Session("LACodeList")
                If dsLACodeDet.Tables.Count > 0 Then
                    'Spares Load
                    If dsLACodeDet.Tables(0).Rows.Count > 0 Then
                        dtLACodeDet = dsLACodeDet.Tables(1)
                        If Not la_slno Is Nothing Then
                            dvLACodeDet = dtLACodeDet.DefaultView
                            dvLACodeDet.RowFilter = "LA_SLNO = '" + la_slno + "'"
                            dtLACodeDet = dvLACodeDet.ToTable
                        End If

                        If dtLACodeDet.Rows.Count > 0 Then
                            ' Dim details As New List(Of LinkToAccountingBO)()
                            For Each dtrow As DataRow In dtLACodeDet.Rows
                                Dim laDet As New LinkToAccountingBO()
                                laDet.Id_Slno = dtrow("Id_Slno")
                                laDet.LA_SlNo = IIf(IsDBNull(dtrow("LA_SlNo")) = True, "", dtrow("LA_SlNo"))
                                laDet.LA_Description = IIf(IsDBNull(dtrow("LA_Description")) = True, "", dtrow("LA_Description"))
                                laDet.Acc_Type = IIf(IsDBNull(dtrow("Acc_Type")) = True, "", dtrow("Acc_Type"))
                                laDet.Gen_Ledger = IIf(IsDBNull(dtrow("GenLedger")) = True, "", dtrow("GenLedger"))
                                laDet.Gl_Crdb = IIf(IsDBNull(dtrow("Gl_Crdb")) = True, "", dtrow("Gl_Crdb"))
                                laDet.Gl_Accno = IIf(IsDBNull(dtrow("Gl_Accno")) = True, "", dtrow("Gl_Accno"))
                                laDet.Gl_DeptAccno = IIf(IsDBNull(dtrow("Gl_DeptAccno")) = True, "", dtrow("Gl_DeptAccno"))
                                laDet.Gl_Dimension = IIf(IsDBNull(dtrow("Gl_Dimension")) = True, "", dtrow("Gl_Dimension"))
                                details.Add(laDet)
                            Next

                        ElseIf (dsLACodeDet.Tables(1).Rows.Count = 0) Then
                            dtLACodeDet = dsLACodeDet.Tables(1)
                            Dim detailst As New LinkToAccountingBO()
                            details.Add(detailst)
                        End If

                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.LinkToAccounting", "FetchLAAccTypes", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function DeleteLACodeList(ByVal strXML As String) As String()
            Dim strResult As String = ""
            Dim strRes(1) As String
            Try
                strResult = objLADO.DeleteLACodeList(strXML)

                If (strResult = "0") Then
                    strRes(0) = "ERROR"
                    strRes(1) = objErrHandle.GetErrorDescParameter("MSG099")
                Else
                    strRes(0) = "SUCCESS"
                    strRes(1) = objErrHandle.GetErrorDescParameter("DDEL")
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.LinkToAccounting", "DeleteLACodeList", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strRes
        End Function
        Public Function Load_LATransactions() As List(Of LinkToAccountingBO)
            Dim dsLACodeDet As New DataSet
            Dim dtLACodeDet As New DataTable
            Dim details As New List(Of LinkToAccountingBO)()
            Try
                dsLACodeDet = objLADO.Fetch_Trans_ID()
                If dsLACodeDet.Tables(0).Rows.Count > 0 Then
                    'Dim details As New List(Of LinkToAccountingBO)()
                    dtLACodeDet = dsLACodeDet.Tables(0)
                    For Each dtrow As DataRow In dtLACodeDet.Rows
                        Dim laDet As New LinkToAccountingBO()
                        laDet.Id_Tran = dtrow("TransactionId")
                        laDet.TransactionNo = dtrow("TransactionNo")
                        details.Add(laDet)
                    Next
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.LinkToAccounting", "Load_LATransactions", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function Fetch_TransactionDetails(ByVal tranId As String) As Collection
            Dim dsLADetails As New DataSet
            Dim dtLADetails As New DataTable
            Dim dt As New Collection
            Try
                dsLADetails = objLADO.Fetch_InvoicesExported(tranId)
                HttpContext.Current.Session("InvExpDetails") = dsLADetails
                If dsLADetails.Tables(0).Rows.Count > 0 Then
                    dtLADetails = dsLADetails.Tables(0)
                    Dim details As New List(Of LinkToAccountingBO)()
                    For Each dtrow As DataRow In dtLADetails.Rows
                        Dim laDet As New LinkToAccountingBO()
                        laDet.InvNo = dtrow("InvNo")
                        laDet.InvDate = dtrow("InvDt")
                        laDet.CustName = dtrow("CustName")
                        laDet.Total = dtrow("Total")
                        laDet.Err = dtrow("Err")
                        laDet.Id_Tran = dtrow("Inv_TransactionId")
                        details.Add(laDet)
                    Next
                    dt.Add(details)
                End If

                If dsLADetails.Tables(1).Rows.Count > 0 Then
                    dtLADetails = dsLADetails.Tables(1)
                    Dim details As New List(Of LinkToAccountingBO)()
                    For Each dtrow As DataRow In dtLADetails.Rows
                        Dim laDet As New LinkToAccountingBO()
                        laDet.InvNo = dtrow("InvNo")
                        laDet.Acc_Type = dtrow("Acc_Type")
                        laDet.Gen_Ledger = dtrow("GenLedger")
                        laDet.Gl_Crdb = dtrow("Gl_Crdb")
                        laDet.Gl_Accno = IIf(IsDBNull(dtrow("Gl_Accno")) = True, "", dtrow("Gl_Accno"))
                        laDet.Gl_Dimension = IIf(IsDBNull(dtrow("Gl_Dimension")) = True, "", dtrow("Gl_Dimension"))
                        laDet.Gl_DeptAccno = IIf(IsDBNull(dtrow("Gl_DeptAccno")) = True, "", dtrow("Gl_DeptAccno"))
                        laDet.Debit_Account = IIf(IsDBNull(dtrow("Debit_Account")) = True, "", dtrow("Debit_Account"))
                        laDet.Credit_Account = IIf(IsDBNull(dtrow("Credit_Account")) = True, "", dtrow("Credit_Account"))
                        laDet.Dt_Created = objCommonUtil.GetCurrentLanguageDate(dtrow("DT_CREATED").ToString())
                        laDet.Id_VatCode = IIf(IsDBNull(dtrow("Vat_Code")) = True, "0", dtrow("Vat_Code"))
                        laDet.Gl_Db_Amount = IIf(IsDBNull(dtrow("DbGlAmount")) = True, "0", dtrow("DbGlAmount"))
                        laDet.Gl_Cr_Amount = IIf(IsDBNull(dtrow("CrGlAmount")) = True, "0", dtrow("CrGlAmount"))

                        details.Add(laDet)
                    Next
                    dt.Add(details)
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.LinkToAccounting", "Fetch_TransactionDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return dt
        End Function
        Public Function FetchInvDetails(ByVal invNo As String) As List(Of LinkToAccountingBO)
            Dim dsLACodeDet As New DataSet
            Dim dtLACodeDet As New DataTable
            Dim dvLACodeDet As New DataView
            Dim details As New List(Of LinkToAccountingBO)()
            Try
                dsLACodeDet = HttpContext.Current.Session("InvExpDetails")

                dsLACodeDet.Tables(1).DefaultView.RowFilter = "InvNo='" + invNo + "'"

                dvLACodeDet = dsLACodeDet.Tables(1).DefaultView
                dtLACodeDet = dvLACodeDet.ToTable

                If dsLACodeDet.Tables(1).Rows.Count > 0 Then
                    For Each dtrow As DataRow In dtLACodeDet.Rows
                        Dim laDet As New LinkToAccountingBO()
                        laDet.InvNo = dtrow("InvNo")
                        laDet.Acc_Type = IIf(IsDBNull(dtrow("Acc_Type")) = True, "", dtrow("Acc_Type"))
                        laDet.Gen_Ledger = dtrow("GenLedger")
                        laDet.Gl_Crdb = dtrow("Gl_Crdb")
                        laDet.Gl_Accno = IIf(IsDBNull(dtrow("Gl_Accno")) = True, "", dtrow("Gl_Accno"))
                        laDet.Gl_Dimension = IIf(IsDBNull(dtrow("Gl_Dimension")) = True, "", dtrow("Gl_Dimension"))
                        laDet.Gl_DeptAccno = IIf(IsDBNull(dtrow("Gl_DeptAccno")) = True, "", dtrow("Gl_DeptAccno"))
                        laDet.Debit_Account = IIf(IsDBNull(dtrow("Debit_Account")) = True, "", dtrow("Debit_Account"))
                        laDet.Credit_Account = IIf(IsDBNull(dtrow("Credit_Accout")) = True, "", dtrow("Credit_Accout"))
                        laDet.Dt_Created = objCommonUtil.GetCurrentLanguageDate(dtrow("DT_CREATED").ToString())
                        laDet.Id_VatCode = IIf(IsDBNull(dtrow("Vat_Code")) = True, "0", dtrow("Vat_Code"))
                        laDet.Gl_Db_Amount = IIf(IsDBNull(dtrow("DbGlAmount")) = True, "0", dtrow("DbGlAmount"))
                        laDet.Gl_Cr_Amount = IIf(IsDBNull(dtrow("CrGlAmount")) = True, "0", dtrow("CrGlAmount"))

                        details.Add(laDet)
                    Next
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.LinkToAccounting", "FetchInvDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function Load_AccCodeType() As Collection
            Dim dsLADetails As New DataSet
            Dim dtLADetails As New DataTable
            Dim dt As New Collection
            Try
                dsLADetails = objLADO.Fetch_AccountCodeTypes()
                'labour
                If dsLADetails.Tables(0).Rows.Count > 0 Then
                    dtLADetails = dsLADetails.Tables(0)
                    Dim details As New List(Of LinkToAccountingBO)()
                    For Each dtrow As DataRow In dtLADetails.Rows
                        Dim laDet As New LinkToAccountingBO()
                        laDet.Id_AccCodeType = dtrow("LABSC")
                        details.Add(laDet)
                    Next
                    dt.Add(details)
                End If
                'spares
                If dsLADetails.Tables(1).Rows.Count > 0 Then
                    dtLADetails = dsLADetails.Tables(1)
                    Dim details As New List(Of LinkToAccountingBO)()
                    For Each dtrow As DataRow In dtLADetails.Rows
                        Dim laDet As New LinkToAccountingBO()
                        laDet.Id_AccCodeType = dtrow("SPARESSC")
                        details.Add(laDet)
                    Next
                    dt.Add(details)
                End If
                'GARAGEMAT
                If dsLADetails.Tables(2).Rows.Count > 0 Then
                    dtLADetails = dsLADetails.Tables(2)
                    Dim details As New List(Of LinkToAccountingBO)()
                    For Each dtrow As DataRow In dtLADetails.Rows
                        Dim laDet As New LinkToAccountingBO()
                        laDet.Id_AccCodeType = dtrow("GARMATSC")
                        details.Add(laDet)
                    Next
                    dt.Add(details)
                End If
                'VAT
                If dsLADetails.Tables(3).Rows.Count > 0 Then
                    dtLADetails = dsLADetails.Tables(3)
                    Dim details As New List(Of LinkToAccountingBO)()
                    For Each dtrow As DataRow In dtLADetails.Rows
                        Dim laDet As New LinkToAccountingBO()
                        laDet.Id_AccCodeType = dtrow("VATSC")
                        details.Add(laDet)
                    Next
                    dt.Add(details)
                End If
                'Rounding
                If dsLADetails.Tables(4).Rows.Count > 0 Then
                    dtLADetails = dsLADetails.Tables(4)
                    Dim details As New List(Of LinkToAccountingBO)()
                    For Each dtrow As DataRow In dtLADetails.Rows
                        Dim laDet As New LinkToAccountingBO()
                        laDet.Id_AccCodeType = dtrow("RoundingAcc")
                        details.Add(laDet)
                    Next
                    dt.Add(details)
                End If
                'ownrisk
                If dsLADetails.Tables(5).Rows.Count > 0 Then
                    dtLADetails = dsLADetails.Tables(5)
                    Dim details As New List(Of LinkToAccountingBO)()
                    For Each dtrow As DataRow In dtLADetails.Rows
                        Dim laDet As New LinkToAccountingBO()
                        laDet.Id_AccCodeType = dtrow("ownrisk_Acctcode")
                        details.Add(laDet)
                    Next
                    dt.Add(details)
                End If
                'VA
                If dsLADetails.Tables(6).Rows.Count > 0 Then
                    dtLADetails = dsLADetails.Tables(6)
                    Dim details As New List(Of LinkToAccountingBO)()
                    For Each dtrow As DataRow In dtLADetails.Rows
                        Dim laDet As New LinkToAccountingBO()
                        laDet.Id_AccCodeType = dtrow("VA_Acctcode")
                        details.Add(laDet)
                    Next
                    dt.Add(details)
                End If
                'FP
                If dsLADetails.Tables(7).Rows.Count > 0 Then
                    dtLADetails = dsLADetails.Tables(7)
                    Dim details As New List(Of LinkToAccountingBO)()
                    For Each dtrow As DataRow In dtLADetails.Rows
                        Dim laDet As New LinkToAccountingBO()
                        laDet.Id_AccCodeType = dtrow("FP_Acctcode")
                        details.Add(laDet)
                    Next
                    dt.Add(details)
                End If
                'IF
                If dsLADetails.Tables(8).Rows.Count > 0 Then
                    dtLADetails = dsLADetails.Tables(8)
                    Dim details As New List(Of LinkToAccountingBO)()
                    For Each dtrow As DataRow In dtLADetails.Rows
                        Dim laDet As New LinkToAccountingBO()
                        laDet.Id_AccCodeType = dtrow("IF_Acctcode")
                        details.Add(laDet)
                    Next
                    dt.Add(details)
                End If



            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.LinkToAccounting", "Load_AccCodeType", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return dt
        End Function
        Public Function Matrix_Save(ByVal objConfigLABO As LinkToAccountingBO) As String
            Dim dsLADetails As New DataSet
            Dim dtLADetails As New DataTable
            Dim strStatus As String
            Try
                If objConfigLABO.LA_SlNo = "" Then
                    strStatus = objLADO.Matrix_Save(objConfigLABO)
                Else
                    strStatus = objLADO.Matrix_Update(objConfigLABO)
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.LinkToAccounting", "Load_AccCodeType", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strStatus
        End Function
        Public Function Fetch_Configuration(ByVal laSLNO As String) As Collection
            Dim dsLADetails As New DataSet
            Dim dtLADetails As New DataTable
            Dim dtConfig As New Collection
            Try
                dsLADetails = objLADO.Fetch_Configuration(laSLNO)
                If dsLADetails.Tables(0).Rows.Count > 0 Then
                    dtLADetails = dsLADetails.Tables(0)
                    Dim details As New List(Of LinkToAccountingBO)()
                    For Each dtrow As DataRow In dtLADetails.Rows
                        Dim laDet As New LinkToAccountingBO()
                        laDet.LA_SlNo = dtrow("id_slno")
                        laDet.Id_DeptId = dtrow("ID_Dept")
                        laDet.Id_DeptAcCode = dtrow("LA_DEPT_ACCCODE")
                        laDet.Id_CustGrpAcCode = dtrow("LA_CUST_ACCCODE")
                        laDet.Id_FreeDuty = dtrow("LA_Flg_DutyFree")
                        laDet.Id_SaleCode_Type = dtrow("LA_SaleDescription")
                        laDet.Id_SaleCode_Desc = dtrow("LA_SaleAccCode")
                        laDet.Id_Project = dtrow("Project")
                        laDet.Id_GenLedger = IIf(IsDBNull(dtrow("LA_Flg_LedGL")) = True, False, dtrow("LA_Flg_LedGL"))
                        laDet.Id_Description = dtrow("LA_Description")
                        laDet.Id_VatCode = dtrow("LA_VATCODE")
                        details.Add(laDet)
                    Next
                    dtConfig.Add(details)
                End If
                If dsLADetails.Tables(1).Rows.Count > 0 Then
                    dtLADetails = dsLADetails.Tables(1)
                    Dim details As New List(Of LinkToAccountingBO)()
                    For Each dtrow As DataRow In dtLADetails.Rows
                        Dim laDet As New LinkToAccountingBO()
                        laDet.LA_SlNo = dtrow("LA_SLNO")

                        If (dtrow("LA_DESCRIPTION") = "SEGL") Then
                            laDet.Id_Selling_GL_Desc = "SEGL"
                            laDet.Id_Selling_GL_CrDb = dtrow("LA_FLG_CRE_DEB")
                            laDet.Id_Selling_GL_AccNo = dtrow("LA_ACCOUNTNO")
                            laDet.Id_Selling_GL_DeptAccNo = dtrow("LA_DEPT_ACCOUNT_NO")
                            laDet.Id_Selling_GL_Dimension = dtrow("LA_DIMENSION")
                        End If

                        If (dtrow("LA_DESCRIPTION") = "DGL") Then
                            laDet.Id_Discount_GL_Desc = dtrow("LA_DESCRIPTION")
                            laDet.Id_Discount_GL_CrDb = dtrow("LA_FLG_CRE_DEB")
                            laDet.Id_Discount_GL_AccNo = dtrow("LA_ACCOUNTNO")
                            laDet.Id_Discount_GL_DeptAccNo = dtrow("LA_DEPT_ACCOUNT_NO")
                            laDet.Id_Discount_GL_Dimension = dtrow("LA_DIMENSION")
                        End If


                        If (dtrow("LA_DESCRIPTION") = "CGL") Then
                            laDet.Id_Cost_GL_Desc = dtrow("LA_DESCRIPTION")
                            laDet.Id_Cost_GL_CrDb = dtrow("LA_FLG_CRE_DEB")
                            laDet.Id_Cost_GL_AccNo = dtrow("LA_ACCOUNTNO")
                            laDet.Id_Cost_GL_DeptAccNo = dtrow("LA_DEPT_ACCOUNT_NO")
                            laDet.Id_Cost_GL_Dimension = dtrow("LA_DIMENSION")
                        End If


                        If (dtrow("LA_DESCRIPTION") = "STGL") Then
                            laDet.Id_Stock_GL_Desc = dtrow("LA_DESCRIPTION")
                            laDet.Id_Stock_GL_CrDb = dtrow("LA_FLG_CRE_DEB")
                            laDet.Id_Stock_GL_AccNo = dtrow("LA_ACCOUNTNO")
                            laDet.Id_Stock_GL_DeptAccNo = dtrow("LA_DEPT_ACCOUNT_NO")
                            laDet.Id_Stock_GL_Dimension = dtrow("LA_DIMENSION")
                        End If

                        If (dtrow("LA_DESCRIPTION") = "SCGL") Then
                            laDet.Id_SellCost_GL_Desc = dtrow("LA_DESCRIPTION")
                            laDet.Id_SellCost_GL_CrDb = dtrow("LA_FLG_CRE_DEB")
                            laDet.Id_SellCost_GL_AccNo = dtrow("LA_ACCOUNTNO")
                            laDet.Id_SellCost_GL_DeptAccNo = dtrow("LA_DEPT_ACCOUNT_NO")
                            laDet.Id_SellCost_GL_Dimension = dtrow("LA_DIMENSION")
                        End If
                        If (dtrow("LA_DESCRIPTION") = "") Then
                            laDet.Id_Cust_AccNo_CrDb = dtrow("LA_FLG_CRE_DEB")
                            laDet.Gl_DeptAccno = dtrow("LA_DEPT_ACCOUNT_NO")
                        End If


                        details.Add(laDet)
                    Next
                    dtConfig.Add(details)
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.LinkToAccounting", "Fetch_Configuration", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return dtConfig
        End Function
        Public Function FetchTranId() As List(Of LinkToAccountingBO)
            Dim dsTranId As DataSet
            Dim dtTranId As DataTable
            Dim details As New List(Of LinkToAccountingBO)()
            Try
                dsTranId = objLADO.Fetch_Trans_ID()
                dtTranId = dsTranId.Tables(0)
                For Each dtrow As DataRow In dtTranId.Rows
                    Dim tranIdDet As New LinkToAccountingBO()
                    tranIdDet.Id_Tran = dtrow("TRANSACTIONID").ToString()
                    tranIdDet.Transction_No = dtrow("TRANSACTIONNO").ToString()
                    details.Add(tranIdDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.LinkToAccounting", "FetchTranId", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function FetchSubs(ByVal loginName As String) As List(Of LinkToAccountingBO)
            Dim dsTranId As DataSet
            Dim dtTranId As DataTable
            Dim details As New List(Of LinkToAccountingBO)()
            Try
                dsTranId = objLADO.Fetch_Subsidiary(loginName)
                dtTranId = dsTranId.Tables(0)
                For Each dtrow As DataRow In dtTranId.Rows
                    Dim tranIdDet As New LinkToAccountingBO()
                    tranIdDet.Id_Sub = dtrow("SUBSIDERY_ID").ToString()
                    tranIdDet.Sub_Name = dtrow("SUBSIDERY_NAME").ToString()
                    details.Add(tranIdDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.LinkToAccounting", "FetchSubs", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function FetchDepartment(ByVal subId As String, ByVal loginId As String) As List(Of LinkToAccountingBO)
            Dim dsTranId As DataSet
            Dim dtTranId As DataTable
            Dim details As New List(Of LinkToAccountingBO)()

            Try
                objConfigDeptBO.SubsideryId = subId
                objConfigDeptBO.LoginId = loginId
                dsTranId = objConfigDeptDO.GetDepartments(objConfigDeptBO)
                dtTranId = dsTranId.Tables(0)
                For Each dtrow As DataRow In dtTranId.Rows
                    Dim tranIdDet As New LinkToAccountingBO()
                    tranIdDet.Id_DeptId = dtrow("ID_DEPT").ToString()
                    tranIdDet.Id_DeptAcCode = dtrow("DPT_NAME").ToString()
                    details.Add(tranIdDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.LinkToAccounting", "FetchDepartment", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function Export(ByVal strSelExport As String, ByVal strExpTranId As String, ByVal strInvJrn As String, ByVal strCustInfo As String, ByVal strIdSub As String, ByVal fromDate As String, ByVal toDate As String, ByVal strTranId As String, ByVal strRecreate As String, ByVal strRegenerate As String, ByVal lstDepArr As String) As String
            Dim ds As New DataSet
            Dim dsTemplate As New DataSet
            Dim transactionId As Integer = 0
            Dim strXMLStringDeptId As String = ""
            Dim strlstdep As String = ""
            Dim strCSV As String


            Config_Path = GetConfigPath_InvExport()
            strFilename = GetFileName_InvExport()
            dsTemplate = objLADO.GetTemplate_Config()
            ds_Config = objConfigLADO.FetchConfiguration()

            HttpContext.Current.Session("TransId") = 0
            HttpContext.Current.Session("CustomerExport") = "False"
            HttpContext.Current.Session("strReturn") = ""

            If strSelExport = "true" And strExpTranId = "false" And strInvJrn = "false" And strCustInfo = "true" Then
                Dim grouping As String
                grouping = GetGrouping_Export()
                Config_Path = GetConfigPath_Export()
                strFilename = GetFileName_Export()

                HttpContext.Current.Session("CustomerExport") = "True"

                objDr = dsTemplate.Tables(0).Select("FILE_NAME = 'CustomerExport.aspx'")

                If objDr.Length = 1 Then
                    TemplateID = objDr(0)("TEMPLATE_ID").ToString
                    Char_Set = objDr(0)("CHARACTER_SET").ToString
                    ExpMode = objDr(0)("FILE_MODE").ToString
                    DataSeparator = objDr(0)("DATA_SEPARATOR").ToString
                Else
                    TemplateID = 0
                    Char_Set = "nb-NO"
                    ExpMode = "DELIMITER"
                    DataSeparator = ";"
                End If
                If (Not String.IsNullOrEmpty(grouping) And grouping.Equals("C")) Then
                    objLABO.Table_Flag = "CUST1"
                    objLABO.TemplateId = TemplateID
                    ds = objLADO.FetchExportData(objLABO)
                Else
                    objLABO.Table_Flag = "CUST1"
                    objLABO.TemplateId = TemplateID
                    ds = objLADO.FetchExportData(objLABO)
                End If


                For Each Row As DataRow In ds.Tables(0).Rows
                    If ds.Tables(0).Columns.Contains("Credit limit") Then
                        HttpContext.Current.Session("credit") = GetCurrentLanguageFormat(Char_Set, Row("Credit limit"), False)

                        Row("Credit limit") = Decimal.Parse(Trim(Row("Credit limit").ToString), CultureInfo.CreateSpecificCulture("en-US"))

                        boolVal = Decimal.TryParse(Row("Credit limit").ToString, dblValue)

                        If Not boolVal Then
                            StrReturn = objErrHandle.GetErrorDescParameter("INVALIDEXPORT")
                            HttpContext.Current.Session("errlog") = objErrHandle.GetErrorDescParameter("INVALIDCRAMT")
                            Exit Function
                        End If

                        Row.BeginEdit()
                        Dim fldLen As Integer
                        fldLen = Row("Credit limit").ToString.Length
                        If ConfigurationManager.AppSettings("Language").ToUpper <> "ENGLISH" Or ExpMode = "FIXED" Then
                            Row("Credit limit") = HttpContext.Current.Session("credit")
                            HttpContext.Current.Session("credit") = Nothing
                        Else
                            Row("Credit limit") = Decimal.Parse(Trim(Row("Credit limit").ToString), CultureInfo.CreateSpecificCulture("en-US"))
                        End If

                        Row.EndEdit()
                    End If
                Next

                ds.Tables(0).AcceptChanges()
                HttpContext.Current.Session("dsCustomer") = ds

                TableColumns = ds.Tables(0).Columns
                TableRows = ds.Tables(0).Rows
                objDr = ds.Tables(1).Select("LANG_NAME = '" & ConfigurationManager.AppSettings("Language").ToUpper & "'")
                If ds.Tables(0).Rows.Count > 0 Then
                    strFilename = Createfile_Export(Config_Path, strFilename)
                    HttpContext.Current.Session("CustFileName") = strFilename
                    StrReturn = WriteInExportedFile(strFilename, TableColumns, TableRows, objDr, strSelExport, strExpTranId, strInvJrn, strCustInfo)

                    If (Not String.IsNullOrEmpty(grouping) And grouping.Equals("C")) Then
                        objLABO.Table_Flag = "CUST1"
                        objLABO.Export_Flag = "M"
                        objLADO.UpdateExportData(objLABO)
                    Else
                        objLABO.Table_Flag = "CUST1"
                        objLABO.Export_Flag = "M"
                        objLADO.UpdateExportData(objLABO)
                    End If
                    StrReturn = "Customer Export"
                    HttpContext.Current.Session("strReturn") = StrReturn
                Else
                    StrReturn = objErrHandle.GetErrorDescParameter("NOREC")
                    HttpContext.Current.Session("errlog") = StrReturn
                End If
            End If
            If strSelExport = "true" And strExpTranId = "false" And strInvJrn = "true" And strCustInfo = "false" Then
                objDr = dsTemplate.Tables(0).Select("FILE_NAME = 'InvoiceJournalExport.aspx'")
                If objDr.Length = 1 Then
                    TemplateID = objDr(0)("TEMPLATE_ID").ToString
                    Char_Set = objDr(0)("CHARACTER_SET").ToString
                    ExpMode = objDr(0)("FILE_MODE").ToString
                    DataSeparator = objDr(0)("DATA_SEPARATOR").ToString
                Else
                    TemplateID = 0
                    Char_Set = "nb-NO"
                    ExpMode = "DELIMITER"
                    DataSeparator = ";"
                End If

                objLABO.Id_Sub = strIdSub
                'Session("SubsideryID") = IIf(DrpSubcidiary.SelectedIndex < 1, Nothing, DrpSubcidiary.SelectedValue)
                objLABO.From_Date = fromDate
                objLABO.From_Date = objCommonUtil.GetDefaultDate_MMDDYYYY(objLABO.From_Date)
                objLABO.To_Date = toDate
                objLABO.To_Date = objCommonUtil.GetDefaultDate_MMDDYYYY(objLABO.To_Date)
                Dim strArray As Array
                strArray = lstDepArr.Split(",")

                For i As Integer = 0 To strArray.Length - 1
                    strlstdep = strlstdep + "," + strArray(i)
                    strXMLStringDeptId += "<INVNO ID_DEPT=""" + objCommonUtil.ConvertStr(strArray(i)) + """/>"
                Next
                strXMLStringDeptId = "<ROOT>" + strXMLStringDeptId + "</ROOT>"
                Dim strInv As String = String.Empty

                objLABO.InvDept = strXMLStringDeptId
                objLABO.TemplateId = TemplateID
                dsfetchinvtransid = objLADO.FetchInvJrnlRecreate(objLABO)
                If dsfetchinvtransid.Tables(0).Columns.Contains("Voucher number") Then
                    If dsfetchinvtransid.Tables(0).Rows.Count > 0 Then
                        lenghtp = dsfetchinvtransid.Tables(0).Rows(0)("Voucher number").ToString.Length
                    Else
                        StrReturn = objErrHandle.GetErrorDescParameter("NOREC")
                    End If
                End If
                If dsfetchinvtransid.Tables(0).Columns.Contains("Invoice number") Then
                    If dsfetchinvtransid.Tables(0).Rows.Count > 0 Then
                        lengthi = dsfetchinvtransid.Tables(0).Rows(0)("Invoice number").ToString.Length
                    Else
                        StrReturn = objErrHandle.GetErrorDescParameter("NOREC")
                    End If
                End If
                For Each Row As DataRow In dsfetchinvtransid.Tables(0).Rows

                    Dim invNumber As String
                    Dim iCount As Integer
                    If dsfetchinvtransid.Tables(0).Columns.Contains("Voucher number") Then
                        If dsfetchinvtransid.Tables(0).Columns.Contains("Invoice number") Then
                            If Row("Invoice number").ToString.Length > 0 Then
                                invNumber = Row("Invoice number").ToString.Trim
                                Row.BeginEdit()
                                If Row("Voucher number") = Row("Invoice number") Then
                                    Row("Voucher number") = invNumber
                                End If
                                Row("Invoice number") = invNumber
                                Row.EndEdit()
                                If IsDBNull(Row("Voucher number")) = False Then
                                    Dim vouNum As String
                                    vouNum = Row("Voucher number")
                                    If ExpMode = "FIXED" Then
                                        vouNum = invNumber.PadRight(lenghtp, " ")
                                    End If
                                    Row("Voucher number") = vouNum
                                Else
                                    Dim StrSpace As String = dsfetchinvtransid.Tables(5).Rows(0)("INVOICE_TRANSACTIONID").ToString()
                                    If ExpMode = "FIXED" Then
                                        HttpContext.Current.Session("StrBlnk") = StrSpace.PadRight(lenghtp, " ")
                                    Else
                                        HttpContext.Current.Session("StrBlnk") = Nothing
                                    End If
                                    Row("Voucher number") = HttpContext.Current.Session("StrBlnk")

                                End If
                                HttpContext.Current.Session("StrBlnk") = Nothing
                                If IsDBNull(Row("Invoice number")) = False Then
                                    Dim invNum As String
                                    invNum = invNumber
                                    If ExpMode = "FIXED" Then
                                        invNum = invNumber.PadRight(lengthi, " ")
                                    End If
                                    Row("Invoice number") = invNum
                                Else
                                    Dim StrSpace As String = ""
                                    If ExpMode = "FIXED" Then
                                        HttpContext.Current.Session("StrBlnk") = StrSpace.PadRight(lengthi, " ")
                                    Else
                                        HttpContext.Current.Session("StrBlnk") = Nothing
                                    End If
                                    Row("Invoice number") = HttpContext.Current.Session("StrBlnk")

                                End If
                                HttpContext.Current.Session("StrBlnk") = Nothing


                            Else
                                transactionId = dsfetchinvtransid.Tables(5).Rows(0)("INVOICE_TRANSACTIONID").ToString()
                            End If
                        Else
                            transactionId = dsfetchinvtransid.Tables(5).Rows(0)("INVOICE_TRANSACTIONID").ToString()
                        End If
                    Else
                        transactionId = dsfetchinvtransid.Tables(5).Rows(0)("INVOICE_TRANSACTIONID").ToString()
                    End If
                    transactionId = dsfetchinvtransid.Tables(5).Rows(0)("INVOICE_TRANSACTIONID").ToString()


                    If dsfetchinvtransid.Tables(0).Columns.Contains("Posting Date") Then
                        If Not IsDate(Row("Posting Date").ToString.Trim) Then
                            StrReturn = objErrHandle.GetErrorDescParameter("INVALIDEXPORT")
                            'lblError.Text = "<Font color=""RED"">" + StrReturn + "</Font>"
                            'lblError.Visible = True
                            HttpContext.Current.Session("errlog") = objErrHandle.GetErrorDescParameter("INVALIDPOSTDATE")
                            Exit Function
                        End If
                        Row.BeginEdit()
                        If ExpMode = "FIXED" Then
                            Row("Posting Date") = GetExportDate(Row("Posting Date").ToString)
                        Else
                            Row("Posting Date") = GetExportDate(Row("Posting Date").ToString).Trim
                        End If
                        Row.EndEdit()
                    End If

                    If dsfetchinvtransid.Tables(0).Columns.Contains("Voucher date") Then
                        If Row("Voucher date").ToString.Trim <> "" Then
                            If Not IsDate(Row("Voucher date").ToString.Trim) Then
                                StrReturn = objErrHandle.GetErrorDescParameter("INVALIDEXPORT")
                                'lblError.Text = "<Font color=""RED"">" + StrReturn + "</Font>"
                                'lblError.Visible = True
                                HttpContext.Current.Session("errlog") = objErrHandle.GetErrorDescParameter("INVALIDVOUDATE")
                                Exit Function
                            End If
                            Row.BeginEdit()
                            If ExpMode = "FIXED" Then
                                Row("Voucher date") = GetExportDate(Row("Voucher date").ToString)
                            Else
                                Row("Voucher date") = GetExportDate(Row("Voucher date").ToString).Trim
                            End If
                            Row.EndEdit()
                        End If
                    End If

                    If dsfetchinvtransid.Tables(0).Columns.Contains("Due date") Then
                        If Row("Due date").ToString.Trim <> "00.00.0000" And Row("Due date").ToString.Trim <> "" Then
                            If Not IsDate(Row("Due date").ToString.Trim) Then
                                StrReturn = objErrHandle.GetErrorDescParameter("INVALIDEXPORT")
                                'lblError.Text = "<Font color=""RED"">" + StrReturn + "</Font>"
                                'lblError.Visible = True
                                HttpContext.Current.Session("errlog") = objErrHandle.GetErrorDescParameter("INVALIDDUDATE")
                                Exit Function
                            End If
                            Row.BeginEdit()
                            If ExpMode = "FIXED" Then
                                Row("Due date") = GetExportDate(Row("Due date").ToString)
                            Else
                                Row("Due date") = GetExportDate(Row("Due date").ToString).Trim
                            End If
                            Row.EndEdit()
                        End If
                    End If

                    If dsfetchinvtransid.Tables(0).Columns.Contains("Amount") Then
                        Dim amount As String = Row("Amount")
                        amount = Decimal.Parse(Trim(amount.ToString), CultureInfo.CreateSpecificCulture("en-US"))
                        boolVal = Decimal.TryParse(amount.ToString.Trim, dblValue)
                        If Not boolVal Then
                            StrReturn = objErrHandle.GetErrorDescParameter("INVALIDEXPORT")
                            'lblError.Text = "<Font color=""RED"">" + StrReturn + "</Font>"
                            'lblError.Visible = True
                            HttpContext.Current.Session("errlog") = objErrHandle.GetErrorDescParameter("INVALIDINVAMT")
                            Exit Function
                        End If
                        If ExpMode = "FIXED" Then
                            Row("Amount") = GetCurrentLanguageFormat(Char_Set, Row("Amount").ToString, False)
                        Else
                            Row("Amount") = GetCurrentLanguageNoFormat(Char_Set, Row("Amount").ToString, False)
                        End If

                    End If

                    If dsfetchinvtransid.Tables(0).Columns.Contains("Invoice Amount 2") Then
                        Dim amount As String = Row("Invoice Amount 2")
                        amount = Decimal.Parse(Trim(amount.ToString), CultureInfo.CreateSpecificCulture("en-US"))
                        boolVal = Decimal.TryParse(amount.ToString.Trim, dblValue)
                        If Not boolVal Then
                            StrReturn = objErrHandle.GetErrorDescParameter("INVALIDEXPORT")
                            'lblError.Text = "<Font color=""RED"">" + StrReturn + "</Font>"
                            'lblError.Visible = True
                            HttpContext.Current.Session("errlog") = objErrHandle.GetErrorDescParameter("INVALIDINVAMT")
                            Exit Function
                        End If
                        If ExpMode = "FIXED" Then
                            Row("Invoice Amount 2") = GetCurrentLanguageFormat(Char_Set, Row("Invoice Amount 2").ToString, False)
                        Else
                            Row("Invoice Amount 2") = GetCurrentLanguageNoFormat(Char_Set, Row("Invoice Amount 2").ToString, False)
                        End If

                    End If
                Next
                dsfetchinvtransid.Tables(0).AcceptChanges()

                If dsfetchinvtransid.Tables(0).Rows.Count <> 0 Then
                    ds = objLADO.GetEachInvoice()
                    If ds.Tables(0).Rows.Count <> 0 Then

                        Dim TransactionXML As String = ""

                        'objLABO.PstrCompany = ""
                        Dim strCompany = ""
                        objLABO.Id_Tran = IIf(transactionId = 0, "", transactionId)
                        Dim dsReturnVal As New DataSet

                        TransactionXML += "<ROOT> <POSTJRNL " _
                                            + " IV_COMPANY=""" + strCompany + """ " _
                                            + " IV_TRANSID=""" + objLABO.Id_Tran + """ " _
                                            + " IV_LANG=""" + ConfigurationManager.AppSettings("Language").ToString + """ " _
                                            + "/> </ROOT>"
                        HttpContext.Current.Session("TransactionXML") = TransactionXML
                        dsReturnVal = objLADO.Fetch_Post_Journal_Report(TransactionXML)
                        If (dsReturnVal.Tables(0).Rows.Count <> 0) Then
                            StrReturn = "Success"
                            'Dim strScript As String = "var windowTransactionReportrpt = window.open('../SS3/Reports/ShowReports.aspx?ReportHeader=" + objCommonUtil.fnEncryptQString("TransactionReport") + "&Rpt=" + objCommonUtil.fnEncryptQString("TransactionReport") + "&scrid=" + rnd.Next().ToString() + "','Reports','menubar=no,location=no,status=no,scrollbars=yes,resizable=yes'); windowTransactionReportrpt.focus();"
                            'ClientScript.RegisterStartupScript(Me.GetType(), "Open", strScript, True)
                        End If

                        HttpContext.Current.Session("ds") = dsfetchinvtransid
                        HttpContext.Current.Session("Dataseperator") = DataSeparator
                        'Dim script As String = "<SCRIPT LANGUAGE='JavaScript'> "
                        'script += "Export()"
                        'script += "</SCRIPT>"
                        'ClientScript.RegisterClientScriptBlock(Me.GetType(), "ClientScript", script)
                        'strCSV = ExportCSV()

                        If dsfetchinvtransid.Tables.Count > 0 Then
                            If dsfetchinvtransid.Tables(6).Rows.Count > 0 Then
                                StrReturn = objErrHandle.GetErrorDesc("ERROR_INV") + ",ERR"
                                HttpContext.Current.Session("ErrorInvoices") = "True"
                                HttpContext.Current.Session("ErrorTransId") = IIf(transactionId = 0, "", transactionId)

                            Else
                                HttpContext.Current.Session("ErrorInvoices") = "False"
                            End If
                        Else
                            HttpContext.Current.Session("ErrorInvoices") = "False"
                        End If
                    Else
                        StrReturn = objErrHandle.GetErrorDescParameter("EXPCONFIG")
                        'lblError.Text = "<Font color=""red"">" + StrReturn + "</Font>"
                        HttpContext.Current.Session("errlog") = StrReturn
                    End If
                Else
                    StrReturn = objErrHandle.GetErrorDescParameter("NOREC")
                    'lblError.Text = StrReturn
                    'lblError.ForeColor = Drawing.Color.Red
                    HttpContext.Current.Session("errlog") = StrReturn
                End If
                '================== END =========================================
            End If
            If strSelExport = "false" And strExpTranId = "true" And strInvJrn = "true" And strCustInfo = "false" And strRecreate = "true" And strRegenerate = "false" Then
                dsTemplate = objLADO.Get_Recreate_Template_Config(strTranId)
                If dsTemplate.Tables(0).Rows.Count = 1 Then
                    Char_Set = dsTemplate.Tables(0).Rows(0)("CHARACTER_SET").ToString
                    DataSeparator = dsTemplate.Tables(0).Rows(0)("DATA_SEPARATOR").ToString
                    ExpMode = dsTemplate.Tables(1).Rows(0)("FILE_MODE").ToString
                Else
                    Char_Set = "nb-NO"
                    ExpMode = "DELIMITER"
                    DataSeparator = ";"
                End If

                objLABO.Id_Tran = strTranId
                HttpContext.Current.Session("TransId") = strTranId
                dsfetchinvtransid = objLADO.FetchInvJrnlRecreateTrnsId(objLABO)
                If dsfetchinvtransid.Tables(0).Columns.Contains("Voucher number") Then
                    lenghtp = dsfetchinvtransid.Tables(0).Rows(0)("Voucher number").ToString.Length
                End If
                If dsfetchinvtransid.Tables(0).Columns.Contains("Invoice number") Then
                    lengthi = dsfetchinvtransid.Tables(0).Rows(0)("Invoice number").ToString.Length
                End If

                For Each Row As DataRow In dsfetchinvtransid.Tables(0).Rows
                    Dim invNumber As String
                    Dim iCount As Integer
                    If dsfetchinvtransid.Tables(0).Columns.Contains("Voucher number") Then
                        If dsfetchinvtransid.Tables(0).Columns.Contains("Invoice number") Then
                            If Row("Invoice number").ToString.Length > 0 Then
                                invNumber = Row("Invoice number").ToString.Trim
                                Row.BeginEdit()
                                If Row("Voucher number") = Row("Invoice number") Then
                                    Row("Voucher number") = invNumber
                                End If
                                Row("Invoice number") = invNumber
                                Row.EndEdit()
                                If IsDBNull(Row("Voucher number")) = False Then
                                    Dim vouNum As String
                                    vouNum = Row("Voucher number")
                                    If ExpMode = "FIXED" Then
                                        vouNum = invNumber.PadRight(lenghtp, " ")
                                    End If
                                    Row("Voucher number") = vouNum
                                Else
                                    Dim StrSpace As String = HttpContext.Current.Session("TransId")
                                    If ExpMode = "FIXED" Then
                                        HttpContext.Current.Session("StrBlnk") = StrSpace.PadRight(lenghtp, " ")
                                    Else
                                        HttpContext.Current.Session("StrBlnk") = Nothing
                                    End If
                                    Row("Voucher number") = HttpContext.Current.Session("StrBlnk")
                                End If
                                HttpContext.Current.Session("StrBlnk") = Nothing
                                If IsDBNull(Row("Invoice number")) = False Then
                                    Dim invNum As String
                                    invNum = invNumber
                                    If ExpMode = "FIXED" Then
                                        invNum = invNumber.PadRight(lengthi, " ")
                                    End If
                                    Row("Invoice number") = invNum
                                Else
                                    Dim StrSpace As String = ""
                                    If ExpMode = "FIXED" Then
                                        HttpContext.Current.Session("StrBlnk") = StrSpace.PadRight(lengthi, " ")
                                    Else
                                        HttpContext.Current.Session("StrBlnk") = Nothing
                                    End If
                                    Row("Invoice number") = HttpContext.Current.Session("StrBlnk")
                                End If
                                HttpContext.Current.Session("StrBlnk") = Nothing
                            Else
                                transactionId = HttpContext.Current.Session("TransId")
                            End If
                        Else
                            transactionId = HttpContext.Current.Session("TransId")
                        End If
                    Else
                        transactionId = HttpContext.Current.Session("TransId")
                    End If
                    transactionId = HttpContext.Current.Session("TransId")
                    If dsfetchinvtransid.Tables(0).Columns.Contains("Posting Date") Then
                        If Not IsDate(Row("Posting Date").ToString.Trim) Then
                            StrReturn = objErrHandle.GetErrorDescParameter("INVALIDEXPORT")
                            'lblError.Text = "<Font color=""RED"">" + StrReturn + "</Font>"
                            'lblError.Visible = True
                            HttpContext.Current.Session("errlog") = objErrHandle.GetErrorDescParameter("INVALIDPOSTDATE")
                            Exit Function
                        End If
                        Row.BeginEdit()
                        If ExpMode = "FIXED" Then
                            Row("Posting Date") = GetExportDate(Row("Posting Date").ToString)
                        Else
                            Row("Posting Date") = GetExportDate(Row("Posting Date").ToString).Trim
                        End If
                        Row.EndEdit()
                    End If

                    If dsfetchinvtransid.Tables(0).Columns.Contains("Voucher date") Then
                        If Row("Voucher date").ToString.Trim <> "" Then
                            If Not IsDate(Row("Voucher date").ToString.Trim) Then
                                StrReturn = objErrHandle.GetErrorDescParameter("INVALIDEXPORT")
                                'lblError.Text = "<Font color=""RED"">" + StrReturn + "</Font>"
                                'lblError.Visible = True
                                HttpContext.Current.Session("errlog") = objErrHandle.GetErrorDescParameter("INVALIDVOUDATE")
                                Exit Function
                            End If
                            Row.BeginEdit()
                            If ExpMode = "FIXED" Then
                                Row("Voucher date") = GetExportDate(Row("Voucher date").ToString)
                            Else
                                Row("Voucher date") = GetExportDate(Row("Voucher date").ToString).Trim
                            End If
                            Row.EndEdit()
                        End If
                    End If

                    If dsfetchinvtransid.Tables(0).Columns.Contains("Due date") Then
                        If Row("Due date").ToString.Trim <> "00.00.0000" And Row("Due date").ToString.Trim <> "" Then
                            If Not IsDate(Row("Due date").ToString.Trim) Then
                                StrReturn = objErrHandle.GetErrorDescParameter("INVALIDEXPORT")
                                'lblError.Text = "<Font color=""RED"">" + StrReturn + "</Font>"
                                'lblError.Visible = True
                                HttpContext.Current.Session("errlog") = objErrHandle.GetErrorDescParameter("INVALIDDUDATE")
                                Exit Function
                            End If
                            Row.BeginEdit()
                            If ExpMode = "FIXED" Then
                                Row("Due date") = GetExportDate(Row("Due date").ToString)
                            Else
                                Row("Due date") = GetExportDate(Row("Due date").ToString).Trim
                            End If
                            Row.EndEdit()
                        End If
                    End If

                    If dsfetchinvtransid.Tables(0).Columns.Contains("Amount") Then
                        If Not IsDBNull(Row("Amount")) Then
                            Dim amount As String = Row("Amount")
                            amount = Decimal.Parse(Trim(amount.ToString), CultureInfo.CreateSpecificCulture("en-US"))
                            boolVal = Decimal.TryParse(amount.ToString.Trim, dblValue)
                            If Not boolVal Then
                                StrReturn = objErrHandle.GetErrorDescParameter("INVALIDEXPORT")
                                'lblError.Text = "<Font color=""RED"">" + StrReturn + "</Font>"
                                'lblError.Visible = True
                                HttpContext.Current.Session("errlog") = objErrHandle.GetErrorDescParameter("INVALIDINVAMT")
                                Exit Function
                            End If

                            Row.BeginEdit()
                            If ExpMode = "FIXED" Then
                                Row("Amount") = GetCurrentLanguageFormat(Char_Set, Row("Amount").ToString, False)
                            Else
                                Row("Amount") = GetCurrentLanguageNoFormat(Char_Set, Row("Amount").ToString, False)
                            End If

                            Row.EndEdit()
                        End If

                    End If
                    If dsfetchinvtransid.Tables(0).Columns.Contains("Invoice Amount 2") Then
                        Dim amount As String = Row("Invoice Amount 2")
                        amount = Decimal.Parse(Trim(amount.ToString), CultureInfo.CreateSpecificCulture("en-US"))
                        boolVal = Decimal.TryParse(amount.ToString.Trim, dblValue)
                        If Not boolVal Then
                            StrReturn = objErrHandle.GetErrorDescParameter("INVALIDEXPORT")
                            'lblError.Text = "<Font color=""RED"">" + StrReturn + "</Font>"
                            'lblError.Visible = True
                            HttpContext.Current.Session("errlog") = objErrHandle.GetErrorDescParameter("INVALIDINVAMT")
                            Exit Function
                        End If
                        If ExpMode = "FIXED" Then
                            Row("Invoice Amount 2") = GetCurrentLanguageFormat(Char_Set, Row("Invoice Amount 2").ToString, False)
                        Else
                            Row("Invoice Amount 2") = GetCurrentLanguageNoFormat(Char_Set, Row("Invoice Amount 2").ToString, False)
                        End If

                    End If
                Next
                dsfetchinvtransid.Tables(0).AcceptChanges()

                Dim TransactionXML As String = ""

                ' objLABO.PstrCompany = ""
                Dim strCompany = ""
                objLABO.Id_Tran = IIf(transactionId = 0, "", transactionId)
                Dim dsReturnVal As New DataSet

                TransactionXML += "<ROOT> <POSTJRNL " _
                                    + " IV_COMPANY=""" + strCompany + """ " _
                                    + " IV_TRANSID=""" + objLABO.Id_Tran + """ " _
                                    + " IV_LANG=""" + ConfigurationManager.AppSettings("Language").ToString + """ " _
                                    + "/> </ROOT>"
                HttpContext.Current.Session("TransactionXML") = TransactionXML
                dsReturnVal = objLADO.Fetch_Post_Journal_Report(TransactionXML)
                If (dsReturnVal.Tables(0).Rows.Count <> 0) Then
                    StrReturn = "Success"

                    ' Dim strScript As String = "var windowTransactionReportrpt = window.open('../SS3/Reports/ShowReports.aspx?ReportHeader=" + fnEncryptQString("TransactionReport") + "&Rpt=" + fnEncryptQString("TransactionReport") + "&scrid=" + rnd.Next().ToString() + "','Reports','menubar=no,location=no,status=no,scrollbars=yes,resizable=yes'); windowTransactionReportrpt.focus();"
                    'ClientScript.RegisterStartupScript(Me.GetType(), "Open", strScript, True)
                End If

                HttpContext.Current.Session("ds") = dsfetchinvtransid
                HttpContext.Current.Session("Dataseperator") = DataSeparator
                'Dim script As String = "<SCRIPT LANGUAGE='JavaScript'> "
                'script += "Export()"
                'script += "</SCRIPT>"
                '  ClientScript.RegisterClientScriptBlock(Me.GetType(), "ClientScript", script)
                'strCSV = ExportCSV()
            End If

            '''
            If strSelExport = "false" And strExpTranId = "true" And strInvJrn = "true" And strCustInfo = "false" And strRecreate = "false" And strRegenerate = "true" Then

                objDr = dsTemplate.Tables(0).Select("FILE_NAME = 'InvoiceJournalExport.aspx'")
                If objDr.Length = 1 Then
                    TemplateID = objDr(0)("TEMPLATE_ID").ToString
                    Char_Set = objDr(0)("CHARACTER_SET").ToString
                    ExpMode = objDr(0)("FILE_MODE").ToString
                    DataSeparator = objDr(0)("DATA_SEPARATOR").ToString
                Else
                    TemplateID = 0
                    Char_Set = "nb-NO"
                    ExpMode = "DELIMITER"
                    DataSeparator = ";"
                End If
                objLABO.Id_Tran = strTranId
                HttpContext.Current.Session("TransId") = strTranId
                objLABO.TemplateId = TemplateID
                dsfetchinvtransid = objLADO.FetchInvJrnlRegenerateTrnsId(objLABO)
                If dsfetchinvtransid.Tables(0).Columns.Contains("Voucher number") Then
                    lenghtp = dsfetchinvtransid.Tables(0).Rows(0)("Voucher number").ToString.Length
                End If
                If dsfetchinvtransid.Tables(0).Columns.Contains("Invoice number") Then
                    lengthi = dsfetchinvtransid.Tables(0).Rows(0)("Invoice number").ToString.Length
                End If

                For Each Row As DataRow In dsfetchinvtransid.Tables(0).Rows

                    Dim invNumber As String
                    Dim iCount As Integer
                    If dsfetchinvtransid.Tables(0).Columns.Contains("Voucher number") Then
                        If dsfetchinvtransid.Tables(0).Columns.Contains("Invoice number") Then
                            If Row("Invoice number").ToString.Length > 0 Then
                                invNumber = Row("Invoice number").ToString.Trim
                                'For iCount = 0 To invNumber.Length - 1
                                '    If Not IsNumeric(invNumber.Substring(iCount, 1)) Then
                                '        invNumber = Replace(invNumber, invNumber.Substring(iCount, 1), "|")
                                '    End If
                                'Next
                                'invNumber = Replace(invNumber, "|", "")

                                Row.BeginEdit()
                                If Row("Voucher number") = Row("Invoice number") Then
                                    Row("Voucher number") = invNumber
                                End If
                                Row("Invoice number") = invNumber
                                Row.EndEdit()
                                If IsDBNull(Row("Voucher number")) = False Then
                                    Dim vouNum As String
                                    vouNum = Row("Voucher number")
                                    If ExpMode = "FIXED" Then
                                        vouNum = invNumber.PadRight(lenghtp, " ")
                                    End If
                                    Row("Voucher number") = vouNum
                                Else
                                    Dim StrSpace As String = HttpContext.Current.Session("TransId")
                                    If ExpMode = "FIXED" Then
                                        HttpContext.Current.Session("StrBlnk") = StrSpace.PadRight(lenghtp, " ")
                                    Else
                                        HttpContext.Current.Session("StrBlnk") = Nothing
                                    End If
                                    Row("Voucher number") = HttpContext.Current.Session("StrBlnk")
                                End If
                                HttpContext.Current.Session("StrBlnk") = Nothing
                                If IsDBNull(Row("Invoice number")) = False Then
                                    Dim invNum As String
                                    invNum = invNumber
                                    If ExpMode = "FIXED" Then
                                        invNum = invNumber.PadRight(lengthi, " ")
                                    End If
                                    Row("Invoice number") = invNum
                                Else
                                    Dim StrSpace As String = ""
                                    If ExpMode = "FIXED" Then
                                        HttpContext.Current.Session("StrBlnk") = StrSpace.PadRight(lengthi, " ")
                                    Else
                                        HttpContext.Current.Session("StrBlnk") = Nothing
                                    End If
                                    Row("Invoice number") = HttpContext.Current.Session("StrBlnk")
                                End If
                                HttpContext.Current.Session("StrBlnk") = Nothing
                            Else
                                transactionId = HttpContext.Current.Session("TransId")
                            End If
                        Else
                            transactionId = HttpContext.Current.Session("TransId")
                        End If
                    Else
                        transactionId = HttpContext.Current.Session("TransId")
                    End If
                    transactionId = HttpContext.Current.Session("TransId")

                    If dsfetchinvtransid.Tables(0).Columns.Contains("Posting Date") Then
                        If Not IsDate(Row("Posting Date").ToString.Trim) Then
                            StrReturn = objErrHandle.GetErrorDescParameter("INVALIDEXPORT")
                            'lblError.Text = "<Font color=""RED"">" + StrReturn + "</Font>"
                            'lblError.Visible = True
                            HttpContext.Current.Session("errlog") = objErrHandle.GetErrorDescParameter("INVALIDPOSTDATE")
                            Exit Function
                        End If
                        Row.BeginEdit()
                        'Dim fmt As DateTimeFormatInfo = (New CultureInfo(Char_Set)).DateTimeFormat
                        If ExpMode = "FIXED" Then
                            Row("Posting Date") = GetExportDate(Row("Posting Date").ToString)
                        Else
                            Row("Posting Date") = GetExportDate(Row("Posting Date").ToString).Trim
                        End If
                        'Row("Posting Date") = GetExportDate(Row("Posting Date").ToString)
                        Row.EndEdit()
                    End If

                    If dsfetchinvtransid.Tables(0).Columns.Contains("Voucher date") Then
                        If Row("Voucher date").ToString.Trim <> "" Then
                            If Not IsDate(Row("Voucher date").ToString.Trim) Then
                                StrReturn = objErrHandle.GetErrorDescParameter("INVALIDEXPORT")
                                'lblError.Text = "<Font color=""RED"">" + StrReturn + "</Font>"
                                'lblError.Visible = True
                                HttpContext.Current.Session("errlog") = objErrHandle.GetErrorDescParameter("INVALIDVOUDATE")
                                Exit Function
                            End If
                            Row.BeginEdit()
                            'Dim fmt As DateTimeFormatInfo = (New CultureInfo(Char_Set)).DateTimeFormat
                            If ExpMode = "FIXED" Then
                                Row("Voucher date") = GetExportDate(Row("Voucher date").ToString)
                            Else
                                Row("Voucher date") = GetExportDate(Row("Voucher date").ToString).Trim
                            End If
                            'Row("Voucher date") = GetExportDate(Row("Voucher date").ToString)
                            Row.EndEdit()
                        End If
                    End If

                    If dsfetchinvtransid.Tables(0).Columns.Contains("Due date") Then
                        If Row("Due date").ToString.Trim <> "00.00.0000" And Row("Due date").ToString.Trim <> "" Then
                            If Not IsDate(Row("Due date").ToString.Trim) Then
                                StrReturn = objErrHandle.GetErrorDescParameter("INVALIDEXPORT")
                                'lblError.Text = "<Font color=""RED"">" + StrReturn + "</Font>"
                                'lblError.Visible = True
                                HttpContext.Current.Session("errlog") = objErrHandle.GetErrorDescParameter("INVALIDDUDATE")
                                Exit Function
                            End If
                            Row.BeginEdit()
                            'Dim fmt As DateTimeFormatInfo = (New CultureInfo(Char_Set)).DateTimeFormat
                            If ExpMode = "FIXED" Then
                                Row("Due date") = GetExportDate(Row("Due date").ToString)
                            Else
                                Row("Due date") = GetExportDate(Row("Due date").ToString).Trim
                            End If
                            'Row("Due date") = GetExportDate(Row("Due date").ToString)
                            Row.EndEdit()
                        End If
                    End If

                    If dsfetchinvtransid.Tables(0).Columns.Contains("Amount") Then
                        If ExpMode = "FIXED" Then
                            Row("Amount") = GetCurrentLanguageFormat(Char_Set, Row("Amount").ToString, False)
                        Else
                            Dim amount As String = Row("Amount")
                            amount = Decimal.Parse(Trim(amount.ToString), CultureInfo.CreateSpecificCulture("en-US"))
                            boolVal = Decimal.TryParse(amount.ToString.Trim, dblValue)
                            If Not boolVal Then
                                StrReturn = objErrHandle.GetErrorDescParameter("INVALIDEXPORT")
                                'lblError.Text = "<Font color=""RED"">" + StrReturn + "</Font>"
                                'lblError.Visible = True
                                HttpContext.Current.Session("errlog") = objErrHandle.GetErrorDescParameter("INVALIDINVAMT")
                                Exit Function
                            End If

                            Row.BeginEdit()

                            'Else
                            Row("Amount") = GetCurrentLanguageNoFormat(Char_Set, Row("Amount").ToString, False)
                        End If
                        Row.EndEdit()
                    End If
                    If dsfetchinvtransid.Tables(0).Columns.Contains("Invoice Amount 2") Then
                        Dim amount As String = Row("Invoice Amount 2")
                        amount = Decimal.Parse(Trim(amount.ToString), CultureInfo.CreateSpecificCulture("en-US"))
                        boolVal = Decimal.TryParse(amount.ToString.Trim, dblValue)
                        If Not boolVal Then
                            StrReturn = objErrHandle.GetErrorDescParameter("INVALIDEXPORT")
                            'lblError.Text = "<Font color=""RED"">" + StrReturn + "</Font>"
                            'lblError.Visible = True
                            HttpContext.Current.Session("errlog") = objErrHandle.GetErrorDescParameter("INVALIDINVAMT")
                            Exit Function
                        End If
                        If ExpMode = "FIXED" Then
                            Row("Invoice Amount 2") = GetCurrentLanguageFormat(Char_Set, Row("Invoice Amount 2").ToString, False)
                        Else
                            Row("Invoice Amount 2") = GetCurrentLanguageNoFormat(Char_Set, Row("Invoice Amount 2").ToString, False)
                        End If

                    End If
                Next
                dsfetchinvtransid.Tables(0).AcceptChanges()


                Dim TransactionXML As String = ""
                ' transactionId = 394
                Dim strCompany = ""
                objLABO.Id_Tran = IIf(transactionId = 0, "", transactionId)
                Dim dsReturnVal As New DataSet

                TransactionXML += "<ROOT> <POSTJRNL " _
                                    + " IV_COMPANY=""" + strCompany + """ " _
                                    + " IV_TRANSID=""" + objLABO.Id_Tran + """ " _
                                    + " IV_LANG=""" + ConfigurationManager.AppSettings("Language").ToString + """ " _
                                    + "/> </ROOT>"
                HttpContext.Current.Session("TransactionXML") = TransactionXML
                dsReturnVal = objLADO.Fetch_Post_Journal_Report(TransactionXML)
                If (dsReturnVal.Tables(0).Rows.Count <> 0) Then
                    StrReturn = "Success"
                    ' Dim strScript As String = "var windowTransactionReportrpt = window.open('../SS3/Reports/ShowReports.aspx?ReportHeader=" + fnEncryptQString("TransactionReport") + "&Rpt=" + fnEncryptQString("TransactionReport") + "&scrid=" + rnd.Next().ToString() + "','Reports','menubar=no,location=no,status=no,scrollbars=yes,resizable=yes'); windowTransactionReportrpt.focus();"
                    ' ClientScript.RegisterStartupScript(Me.GetType(), "Open", strScript, True)
                End If

                HttpContext.Current.Session("ds") = dsfetchinvtransid
                HttpContext.Current.Session("Dataseperator") = DataSeparator
                'Dim script As String = "<SCRIPT LANGUAGE='JavaScript'> "
                'script += "Export()"
                'script += "</SCRIPT>"
                ' ClientScript.RegisterClientScriptBlock(Me.GetType(), "ClientScript", script)
                'strCSV = ExportCSV()

            End If

          
            Return StrReturn
        End Function
        Public Function GetConfigPath_InvExport() As String
            Dim Ds As New DataSet
            Dim FilePath As String = String.Empty
            Try
                Ds = objLADO.GetFilePath_Export()
                If Ds.Tables(0).Rows.Count <> 0 Then
                    FilePath = Ds.Tables(0).Rows(0).Item("Path_Export_InvJournal").ToString

                    Dim tempPath As String = String.Empty

                    If FilePath = String.Empty Then
                        tempPath = HttpContext.Current.Server.MapPath("..\TempFile\")
                        FilePath = tempPath
                    End If

                Else

                    Dim tempPath As String = String.Empty

                    If FilePath = String.Empty Then
                        tempPath = HttpContext.Current.Server.MapPath("..\TempFile\")
                        FilePath = tempPath
                    End If

                End If
                Return FilePath

            Catch ex As Exception

                'Throw ex

            End Try
        End Function
        Public Function GetFileName_InvExport() As String
            Dim DS As New DataSet
            Dim FileName As String = ""
            Dim Cur_SeqNo As Integer
            Dim New_SeqNo As Integer

            Try
                DS = objLADO.GetFileName_InvExport()
                If DS.Tables(0).Rows.Count > 0 Then

                    If DS.Tables(0).Rows(0).Item("Exp_InvJournal_Series").ToString <> "" Then
                        If DS.Tables(0).Rows(0).Item("Exp_InvJournal_Cur_Series").ToString <> "" Then
                            Cur_SeqNo = CType(DS.Tables(0).Rows(0).Item("Exp_InvJournal_Cur_Series").ToString, Integer)
                            New_SeqNo = Cur_SeqNo
                        Else
                            Cur_SeqNo = 1
                            New_SeqNo = 1
                        End If

                        FileName = DS.Tables(0).Rows(0).Item("PrefixFileName_Export_InvJournal").ToString + "_" + CType(New_SeqNo, String) + "." + DS.Tables(0).Rows(0).Item("SuffixFileName_Export_InvJournal").ToString
                    Else
                        FileName = DS.Tables(0).Rows(0).Item("PrefixFileName_Export_InvJournal").ToString + "." + DS.Tables(0).Rows(0).Item("SuffixFileName_Export_InvJournal").ToString
                    End If
                End If
                Return FileName
            Catch ex As Exception
                'Throw ex
            End Try
        End Function
        Public Function GetGrouping_Export() As String
            Dim Ds As New DataSet
            Dim Grouping As String
            Try
                Ds = objLADO.GetGrouping_Export()
                If Ds.Tables(0).Rows.Count <> 0 Then
                    Grouping = Ds.Tables(0).Rows(0).Item("Flg_Grouping").ToString
                    Return Grouping

                End If
                Return ""
            Catch ex As Exception
                'Throw ex

            End Try
        End Function
        Public Function GetConfigPath_Export() As String
            Dim Ds As New DataSet
            Dim FilePath As String = String.Empty
            Try
                Ds = objLADO.GetFilePath_Export()
                If Ds.Tables(0).Rows.Count <> 0 Then
                    FilePath = Ds.Tables(0).Rows(0).Item("Path_Export_CustInfo").ToString
                    Dim tempPath As String = String.Empty
                    If FilePath = String.Empty Then
                        tempPath = HttpContext.Current.Server.MapPath("..\TempFile\")
                        FilePath = tempPath
                    End If
                Else
                    Dim tempPath As String = String.Empty
                    If FilePath = String.Empty Then
                        tempPath = HttpContext.Current.Server.MapPath("..\TempFile\")
                        FilePath = tempPath
                    End If
                End If
                Return FilePath

            Catch ex As Exception
                'Throw ex
            End Try
        End Function
        Public Function GetFileName_Export() As String
            Dim DS As New DataSet
            Dim FileName As String = ""
            Dim Cur_SeqNo As Integer
            Dim New_SeqNo As Integer

            Try
                DS = objLADO.GetFileName_Export()
                If DS.Tables(0).Rows.Count > 0 Then

                    If DS.Tables(0).Rows(0).Item("Exp_Cust_Series").ToString <> "" Then
                        If DS.Tables(0).Rows(0).Item("Exp_Cust_Cur_Series").ToString <> "" Then
                            Cur_SeqNo = CType(DS.Tables(0).Rows(0).Item("Exp_Cust_Cur_Series").ToString, Integer)
                            'New_SeqNo += 1
                            New_SeqNo = Cur_SeqNo + 1
                        Else
                            Cur_SeqNo = 1
                            New_SeqNo = 1
                        End If

                        FileName = DS.Tables(0).Rows(0).Item("PrefixFileName_Export_CustInfo").ToString + "_" + CType(New_SeqNo, String) + "." + DS.Tables(0).Rows(0).Item("SuffixFileName_Export_CustInfo").ToString
                    Else
                        FileName = DS.Tables(0).Rows(0).Item("PrefixFileName_Export_CustInfo").ToString + "." + DS.Tables(0).Rows(0).Item("SuffixFileName_Export_CustInfo").ToString
                    End If
                End If
                Return FileName
            Catch ex As Exception
                'Throw ex
            End Try
        End Function
        Public Function GetCurrentLanguageFormat(ByVal charSet As String, ByVal Num As String, ByVal isForward As Boolean) As String
            If Num.Length <> 0 Then
                Dim Totlen As Integer
                Totlen = Num.Length
                Dim MultiLangNumFormat As System.Globalization.NumberFormatInfo
                Dim NumberValue As Decimal
                If isForward Then
                    MultiLangNumFormat = New System.Globalization.CultureInfo("en-US").NumberFormat
                    NumberValue = Decimal.Parse(Num, New CultureInfo(charSet))
                Else
                    MultiLangNumFormat = New System.Globalization.CultureInfo(charSet).NumberFormat
                    NumberValue = Decimal.Parse(Num, New CultureInfo("en-US"))
                End If
                Try
                    Num = NumberValue.ToString("N", MultiLangNumFormat)
                    Dim Num1 As String
                    Num1 = CStr(Num)
                    Num1 = Num.PadRight(Totlen, " ")
                    Return Num1
                    'Return Num.Replace(MultiLangNumFormat.CurrencyGroupSeparator, String.Empty)
                Catch ex As Exception
                    Throw ex
                End Try
            Else
                Return String.Empty
            End If
        End Function
        Public Function Createfile_Export(ByVal Config_Path As String, ByVal strFilename As String) As String

            Try
                If Not (Directory.Exists(Config_Path)) Then
                    Directory.CreateDirectory(Config_Path)
                End If

                If Config_Path.EndsWith("\") Or Config_Path.EndsWith("/") Then
                    strFilename = Config_Path + strFilename
                Else
                    strFilename = Config_Path + "\" + strFilename
                End If

                Dim NewFile As FileStream = New FileStream(strFilename, FileMode.Create, FileAccess.ReadWrite)

                NewFile.Close()

            Catch ex As Exception
                'Throw ex
            Finally
            End Try
            Return strFilename
        End Function
        Public Function WriteInExportedFile(ByVal strPath As String, ByVal tableColumns As DataColumnCollection, ByVal tableRows As DataRowCollection, ByVal objDr() As DataRow, ByVal strSelExport As String, ByVal strExpTranId As String, ByVal strInvJrn As String, ByVal strCustInfo As String) As String
            Dim StrReturnExpFile As String = ""
            Dim File As System.IO.StreamWriter = New System.IO.StreamWriter(strPath)
            Dim RowsCreated As Integer = 0
            Dim SqlInsert As String = ""
            Dim DSEncCh As New DataSet
            Dim DsDate As New DataSet
            DsDate = objLADO.GetFilePath_Export()
            Flg_DateCheck = DsDate.Tables(0).Rows(0)("FLG_ADD_DATE").ToString
            Flg_Textcheck = DsDate.Tables(0).Rows(0)("FLG_ADD_TEXT").ToString
            Flg_AdditionalText = DsDate.Tables(0).Rows(0)("FLG_ADDITINAL_TEXT").ToString
            Flg_CustomerText = DsDate.Tables(0).Rows(0)("FLG_CUSTOMER_TEXT").ToString

            If Flg_Textcheck = "True" Then
                SqlInsert += DsDate.Tables(0).Rows(0)("ADD_TEXT").ToString & Environment.NewLine
            End If

            If Flg_DateCheck = "True" Then
                Dim CurrentDate As String = DateTime.Today.Date.ToString("yyyyMMdd")
                SqlInsert += """" + CurrentDate + """" & Environment.NewLine & Environment.NewLine
            End If

            If Flg_AdditionalText = "True" And HttpContext.Current.Session("CustomerExport") = "False" Then
                SqlInsert += DsDate.Tables(0).Rows(0)("ADDITINAL_TEXT").ToString & Environment.NewLine
            End If

            If Flg_CustomerText = "True" And HttpContext.Current.Session("CustomerExport") = "True" Then
                SqlInsert += DsDate.Tables(0).Rows(0)("CUSTOMER_TEXT").ToString & Environment.NewLine
            End If

            File.WriteLine(SqlInsert)
            Try

                If strSelExport = "True" And strExpTranId = "False" And strInvJrn = "False" And strCustInfo = "True" Then
                    Config_Path = GetConfigPath_Export()
                    strFilename = GetFileName_Export()
                Else
                    Config_Path = GetConfigPath_InvExport()
                    strFilename = GetFileName_InvExport()
                End If


                Dim suffixfile
                suffixfile = strFilename.Split(".")

                If Config_Path.EndsWith("/") Or Config_Path.EndsWith("\") Then
                    strFilename = Config_Path + strFilename
                Else
                    strFilename = Config_Path + "/" + strFilename
                End If


                Dim CtrColumn As Integer = 0
                Dim DC As DataColumn
                For Each DC In tableColumns

                Next

                Dim Row As DataRow
                For Each Row In tableRows
                    SqlInsert = ""
                    Dim sqlvalues As String = ""
                    Dim rowItems As Object() = Row.ItemArray
                    CtrColumn = 0
                    Dim Dcol As DataColumn
                    For Each Dcol In tableColumns
                        If CtrColumn < tableColumns.Count - 1 Then
                            Dim Str As String = ""
                            If ExpMode <> "FIXED" Then
                                DSEncCh = objLADO.GetEnclosingCharacter(Dcol.ColumnName, "CustomerExport.aspx", TemplateID)
                                Str = DSEncCh.Tables(0).Rows(0).Item("ENCLOSING CHARACTER").ToString + rowItems(CtrColumn).ToString + DSEncCh.Tables(0).Rows(0).Item("ENCLOSING CHARACTER").ToString + DataSeparator
                                If DSEncCh.Tables(0).Rows(0).Item("ENCLOSING CHARACTER").ToString = "" Then
                                    If HttpContext.Current.Session("BlankSp") = "True" Then
                                        If Str = DataSeparator Then
                                            Str = Str.Replace(DataSeparator, """ """ + DataSeparator)
                                        End If
                                    End If
                                End If
                            Else
                                If suffixfile(1).ToString = "CSV" Then

                                    Str = rowItems(CtrColumn).ToString + DataSeparator
                                ElseIf suffixfile(1).ToString = "TXT" Then

                                    Str = rowItems(CtrColumn).ToString + DataSeparator
                                End If
                            End If

                            sqlvalues += Str
                        Else
                            Dim Str As String = ""
                            If ExpMode <> "FIXED" Then
                                DSEncCh = objLADO.GetEnclosingCharacter(Dcol.ColumnName, "CustomerExport.aspx", TemplateID)
                                Str = DSEncCh.Tables(0).Rows(0).Item("ENCLOSING CHARACTER").ToString + rowItems(CtrColumn).ToString + DSEncCh.Tables(0).Rows(0).Item("ENCLOSING CHARACTER").ToString + DataSeparator
                                If DSEncCh.Tables(0).Rows(0).Item("ENCLOSING CHARACTER").ToString = "" Then
                                    If HttpContext.Current.Session("BlankSp") = "True" Then
                                        If Str = DataSeparator Then
                                            Str = Str.Replace(DataSeparator, """ """ + DataSeparator)
                                        End If
                                    End If
                                End If
                            Else
                                If suffixfile(1).ToString = "CSV" Then

                                    Str = rowItems(CtrColumn).ToString + DataSeparator
                                ElseIf suffixfile(1).ToString = "TXT" Then
                                    Str = rowItems(CtrColumn).ToString + DataSeparator
                                End If
                            End If

                            sqlvalues += Str
                        End If
                        CtrColumn = CtrColumn + 1

                    Next
                    SqlInsert = SqlInsert + sqlvalues
                    File.WriteLine(SqlInsert)
                    strErrlogMsg = strErrlogMsg + vbCrLf + SqlInsert
                    RowsCreated = RowsCreated + 1


                Next
                HttpContext.Current.Session("strErrlogMsg") = strErrlogMsg
                StrReturnExpFile = objErrHandle.GetErrorDescParameter("EXP")
                HttpContext.Current.Session("errlog") = StrReturnExpFile
                File.Close()
                Return StrReturnExpFile

            Catch ex As Exception
                'Throw ex
            Finally
                File.Close()

            End Try

        End Function
        Public Function GetExportDate(ByVal DateValue As String) As String
            Try
                If DateValue.Length <> 0 Then

                    Dim TotalLen As Integer
                    TotalLen = DateValue.Length
                    Dim strDateDisplay As DateTime
                    Dim fmt As DateTimeFormatInfo = (New CultureInfo(Char_Set)).DateTimeFormat
                    DateValue = DateTime.Parse(DateValue.ToString.Trim).ToString("d", fmt)
                    If ExpMode = "FIXED" Then
                        DateValue = DateValue.PadRight(TotalLen, " ")
                    End If

                End If
            Catch ex As Exception
            End Try
            Return DateValue
        End Function
        Public Function GetCurrentLanguageNoFormat(ByVal charSet As String, ByVal Num As String, ByVal isForward As Boolean) As String
            If Num.Length <> 0 Then
                Dim MultiLangNumFormat As System.Globalization.NumberFormatInfo
                Dim NumberValue As Decimal


                If isForward Then
                    MultiLangNumFormat = New System.Globalization.CultureInfo("en-US").NumberFormat
                    MultiLangNumFormat.NumberDecimalDigits = 5
                    NumberValue = Decimal.Parse(Num, New CultureInfo(charSet))
                Else
                    MultiLangNumFormat = New System.Globalization.CultureInfo(charSet).NumberFormat
                    MultiLangNumFormat.NumberDecimalDigits = 5
                    NumberValue = Decimal.Parse(Num, New CultureInfo("en-US"))
                End If
                Try
                    Num = NumberValue.ToString("N", MultiLangNumFormat)
                    Return Num.Replace(MultiLangNumFormat.CurrencyGroupSeparator, String.Empty)
                Catch ex As Exception
                    Throw ex
                End Try
            Else
                Return String.Empty
            End If
        End Function
        Public Function LoadErrInvoiceRpt() As String
            Dim sWOXML As String = String.Empty
            Dim errorInvoicesXML As String = String.Empty
            Dim dsReturnErrVal As New DataSet
            Dim strReturnErr As String = ""
            Dim strTransID As String = HttpContext.Current.Session("ErrorTransId").ToString

            errorInvoicesXML += "<ROOT> <ERRORINVOICES " _
                                + " IV_TRANSNOFROM=""" + strTransID + """ " _
                                + " IV_INVOICENUMBER=""" + String.Empty + """ " _
                                + " IV_TRANSDATEFROM=""" + String.Empty + """ " _
                                + " IV_TRANSDATETO=""" + String.Empty + """ " _
                                + " IV_LANG=""" + System.Configuration.ConfigurationManager.AppSettings("Language").ToString() + """ " _
                                + "/> </ROOT>"

            HttpContext.Current.Session("errorInvoicesXML") = errorInvoicesXML

            dsReturnErrVal = objLADO.Fetch_Error_Invoices_Report(errorInvoicesXML)
            If (dsReturnErrVal.Tables(0).Rows.Count <> 0) Then
                strReturnErr = "ERROR"
            End If
            Return strReturnErr
        End Function
    End Class
End Namespace
