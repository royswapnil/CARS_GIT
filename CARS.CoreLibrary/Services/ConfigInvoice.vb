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
Namespace CARS.Services.ConfigInvoice
    Public Class ConfigInvoice
        Shared objCommonUtil As New CARS.Utilities.CommonUtility
        Shared objConfigInvDO As New CARS.ConfigInvoice.ConfigInvoiceDO
        Shared objConfigInvBO As New ConfigInvoiceBO
        Shared objConfigSettingsDO As New CARS.ConfigSettings.ConfigSettingsDO
        Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
        Dim objDB As Database
        Dim ConnectionString As String
        Public Function FetchPayType() As List(Of ConfigInvoiceBO)
            Dim dsInvDetails As New DataSet
            Dim dtInvDetails As New DataTable
            Dim details As New List(Of ConfigInvoiceBO)()
            dsInvDetails = objConfigInvDO.Fetch_PayTypes(objConfigInvBO)
            HttpContext.Current.Session("chk") = dsInvDetails.Tables(1)
            If dsInvDetails.Tables(1).Rows.Count > 0 Then
                dtInvDetails = dsInvDetails.Tables(1)
                For Each dtrow As DataRow In dtInvDetails.Rows
                    Dim invDet As New ConfigInvoiceBO()
                    invDet.Inv_Prefix = IIf(IsDBNull(dtrow("INV_PREFIX")) = True, "", dtrow("INV_PREFIX"))
                    invDet.Inv_PaySeries = IIf(IsDBNull(dtrow("ID_PAYSERIES")) = True, "", dtrow("ID_PAYSERIES"))
                    details.Add(invDet)
                Next
            End If
            Return details.ToList
        End Function
        Public Function FetchPayTypeForGrid() As List(Of ConfigInvoiceBO)
            Dim dsInvDetails As New DataSet
            Dim dtInvDetails As New DataTable
            Dim details As New List(Of ConfigInvoiceBO)()
            dsInvDetails = objConfigInvDO.Fetch_PayTypes(objConfigInvBO)
            If dsInvDetails.Tables(0).Rows.Count > 0 Then
                dtInvDetails = dsInvDetails.Tables(0)
                For Each dtrow As DataRow In dtInvDetails.Rows
                    Dim invDet As New ConfigInvoiceBO()
                    invDet.Id_Settings = IIf(IsDBNull(dtrow("ID_SETTINGS")) = True, "", dtrow("ID_SETTINGS"))
                    invDet.Description = IIf(IsDBNull(dtrow("DESCRIPTION")) = True, "", dtrow("DESCRIPTION"))
                    details.Add(invDet)
                Next
            End If
            Return details.ToList
        End Function
        Public Function LoadInvoiceSett(ByVal subId As String, ByVal deptId As String) As List(Of ConfigInvoiceBO)
            Dim dsInvDetails As New DataSet
            Dim dtInvDetails As New DataTable
            Dim details As New List(Of ConfigInvoiceBO)()
            objConfigInvBO.IdSubsidery = subId
            objConfigInvBO.IdDept = deptId
            dsInvDetails = objConfigInvDO.LoadInvSettings(objConfigInvBO)
            If dsInvDetails.Tables(0).Rows.Count > 0 Then
                dtInvDetails = dsInvDetails.Tables(0)
                For Each dtrow As DataRow In dtInvDetails.Rows
                    Dim invDet As New ConfigInvoiceBO()
                    invDet.InvTimeRnd = dtrow("INV_TIM_RND")
                    invDet.InvTimeRndPer = dtrow("INV_TIM_RND_PER")
                    invDet.InvRndDec = dtrow("INV_RND_DECIMAL")
                    invDet.InvPrRndValPer = dtrow("INV_PRICE_RND_VAL_PER")
                    invDet.ExtVatCode = dtrow("EXT_VAT_CODE")
                    invDet.AccountCode = dtrow("ACCOUNT_CODE")
                    invDet.InvTimeRndUnit = dtrow("INV_TIM_RND_UNIT")
                    invDet.InvTimeRndFn = dtrow("INV_TIM_RND_FN")
                    invDet.InvPriceRndFn = dtrow("INV_PRICE_RND_FN")
                    invDet.KidCustOrd = dtrow("KID_CUST_ORD")
                    invDet.KidInvOrd = dtrow("KID_INV_ORD")
                    invDet.KidWoOrd = dtrow("KID_WO_ORD")
                    invDet.KidFixedOrd = dtrow("KID_FIXED_ORD")
                    invDet.KidCustNod = dtrow("KID_CUST_NOD")
                    invDet.KidInvNod = dtrow("KID_INV_NOD")
                    invDet.KidWoNod = dtrow("KID_WO_NOD")
                    invDet.KidFixedNumber = dtrow("KID_FIXED_NUMBER")
                    invDet.KidFixedNod = dtrow("KID_FIXED_NOD")
                    invDet.FlgKidMod10 = dtrow("FLG_KID_MOD10")
                    'invDet.FlgInvFees = dtrow("FLG_INV_FEES")
                    'invDet.InvFeesAmt = dtrow("INV_FEES_AMT")
                    'invDet.InvFeesAccCode = dtrow("INV_FEES_ACC_CODE")
                    If dsInvDetails.Tables(1).Rows.Count > 0 Then
                        invDet.FlgInvFees = dsInvDetails.Tables(1).Rows(0)("FLG_INV_FEES")
                        invDet.InvFeesAmt = dsInvDetails.Tables(1).Rows(0)("INV_FEES_AMT")
                        invDet.InvFeesAccCode = dsInvDetails.Tables(1).Rows(0)("INV_FEES_ACC_CODE")
                    End If


                    details.Add(invDet)
                Next
            End If
            Return details.ToList
        End Function
        Public Function LoadInvNumGrid(ByVal subId As String, ByVal deptId As String) As List(Of ConfigInvoiceBO)
            Dim dsInvDetails As New DataSet
            Dim dtInvDetails As New DataTable
            Dim details As New List(Of ConfigInvoiceBO)()
            objConfigInvBO.IdSubsidery = subId
            objConfigInvBO.IdDept = deptId
            dsInvDetails = objConfigInvDO.LoadInvSeries(objConfigInvBO)
            If dsInvDetails.Tables(0).Rows.Count > 0 Then
                dtInvDetails = dsInvDetails.Tables(0)
                For Each dtrow As DataRow In dtInvDetails.Rows
                    Dim invDet As New ConfigInvoiceBO()
                    invDet.IdNumSeries = dtrow("ID_NUMSERIES")
                    invDet.Id_Settings = dtrow("ID_SETTINGS")
                    invDet.Description = dtrow("DESCRIPTION")
                    invDet.Inv_Prefix = dtrow("INV_PREFIX")
                    invDet.InvNoSeries = dtrow("INV_INVNOSERIES")
                    invDet.CreNoSeries = dtrow("INV_CRENOSEREIES")
                    invDet.Cre_Prefix = dtrow("CRE_PREFIX")
                    details.Add(invDet)
                Next
            End If
            Return details.ToList
        End Function
        Public Function LoadInvNumSeries(ByVal subId As String, ByVal deptId As String) As List(Of ConfigInvoiceBO)
            Dim dsInvDetails As New DataSet
            Dim dtInvDetails As New DataTable
            Dim details As New List(Of ConfigInvoiceBO)()
            objConfigInvBO.IdSubsidery = subId
            objConfigInvBO.IdDept = deptId
            dsInvDetails = objConfigInvDO.LoadPayType(objConfigInvBO)
            If dsInvDetails.Tables(1).Rows.Count > 0 Then
                dtInvDetails = dsInvDetails.Tables(1)
                For Each dtrow As DataRow In dtInvDetails.Rows
                    Dim invDet As New ConfigInvoiceBO()
                    invDet.Inv_Prefix = dtrow("INV_PREFIX")
                    invDet.InvNoSeries = dtrow("ID_PAYSERIES")
                    invDet.CreNoSeries = dtrow("ID_PAYSERIES")
                    invDet.Cre_Prefix = dtrow("INV_PREFIX")
                    details.Add(invDet)
                Next
            End If
            Return details.ToList
        End Function
        Public Function UpdateConfig(ByVal objInvConfigBO As ConfigInvoiceBO) As String
            Dim strResult As String = ""
            Dim strRes As String = ""
            strResult = objConfigInvDO.Update_Config(objInvConfigBO)
            If strResult = "0" Then
                strRes = objErrHandle.GetErrorDescParameter("SAVE", objErrHandle.GetErrorDesc("INV"))
            End If
            Return strRes
        End Function
        Public Function InsertConfig(ByVal objInvConfigBO As ConfigInvoiceBO) As String
            Dim strResult As String = ""
            Dim strRes As String = ""
            strResult = objConfigInvDO.Insert_Config(objInvConfigBO)
            If strResult = "SAVED" Then
                strRes = objErrHandle.GetErrorDescParameter("SAVE", objErrHandle.GetErrorDesc("INV"))
            End If
            Return strRes
        End Function
        Public Function Save_PType(ByVal objInvConfigBO As ConfigInvoiceBO) As String
            Dim strResult As String = ""
            strResult = objConfigInvDO.SavePayType(objInvConfigBO)
            Return strResult
        End Function
        Public Function Update_PType(ByVal objInvConfigBO As ConfigInvoiceBO) As String
            Dim strResult As String = ""
            strResult = objConfigInvDO.UpdatePayType(objInvConfigBO)
            Return strResult
        End Function
    End Class
End Namespace
