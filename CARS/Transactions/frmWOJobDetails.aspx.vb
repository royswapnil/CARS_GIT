Imports System.Web.Services
Imports CARS.CoreLibrary
Imports CARS.CoreLibrary.CARS
Imports System.Web.Security
Imports System.Web.UI
Imports Encryption
Imports System.Math
Imports Newtonsoft.Json
Imports System.Reflection
Public Class frmWOJobDetails
    Inherits System.Web.UI.Page
    Shared commonUtil As New Utilities.CommonUtility
    Shared loginName As String
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared dtCaption As DataTable
    Shared details As New List(Of WOJobDetailBO)()
    Shared objWOJServ As New Services.WOJobDetails.WOJobDetails
    Shared objWOJDetailsBO As New CARS.CoreLibrary.WOJobDetailBO
    Shared objServCustomer As New Services.Customer.CustomerDetails
    Shared objWOJobDetailsDO As New CARS.CoreLibrary.CARS.WOJobDetailDO.WOJobDetailDO
    Shared objWOHeaderBO As New CARS.CoreLibrary.WOHeaderBO
    Shared objWOHeaderDO As New CARS.CoreLibrary.CARS.WOHeader.WOHeaderDO
    Dim objuserper As New UserAccessPermissionsBO
    Shared objConfigUserBO As New CARS.CoreLibrary.ConfigUsersBO
    Shared objConfigUserDO As New ConfigUsers.ConfigUsersDO
    Shared objUserService As New CARS.CoreLibrary.CARS.Services.ConfigUsers.Users
    Shared detailUser As New List(Of ConfigUsersBO)()
    Shared objInvDetDO As New CARS.CoreLibrary.CARS.InvDetailDO.InvDetailDO
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Session("Decimal_Seperator") = ConfigurationManager.AppSettings.Get("ReportDecimalSeperator").ToString()
        If Session("UserID") Is Nothing Or Session("UserPageperDT") Is Nothing Then
            Response.Redirect("~/frmLogin.aspx")
        Else
            loginName = CType(Session("UserID"), String)
        End If
        Dim ordDate As String
        ordDate = Date.Now.ToString 'objCommonUtil.GetCurrentLanguageDate(dsReturnVal.regFoerstegNorge)
        RTlblOrderDate.Text = commonUtil.GetCurrentLanguageDate(ordDate)
        'hdnPageSize.Value = System.Configuration.ConfigurationManager.AppSettings("PageSize")
        'If Not IsPostBack Then
        Dim idWoNo As String = Request.QueryString("Wonumber")
        Dim idWoPr As String = Request.QueryString("WOPrefix")
        'If hdnInvoiceType.Value = "InvoiceBasis" Then
        '    ConstructInvBasisXml(idWoNo, idWoPr)
        'ElseIf hdnInvoiceType.Value = "Invoice" Then
        '    ConstructInvoiceXml(idWoNo, idWoPr)
        'End If
        dtCaption = DirectCast(Cache("Caption"), System.Data.DataTable)
        hdnSelect.Value = dtCaption.Select("TAG='select'")(0)(1)
        'Session("RptType") = "INVOICEBASIS"
        'Session("InvListXML") = "<ROOT><INV_GENERATE  ID_WO_PREFIX='V22' ID_WO_NO='54875'  ID_WODET_SEQ='154144'  ID_JOB_DEB='18013'  FLG_BATCH='False' /></ROOT>"
        'Session("xmlInvNos") = Session("InvListXML")
        'End If
    End Sub
    Shared Sub ConstructInvBasisXml(ByVal idWoNo As String, ByVal idWoPr As String)
        Dim dsWOJobs As New DataSet 'No of Jobs
        Dim dtWOJobs As New DataTable 'No of Jobs
        Dim dsWODetails As New DataSet  'Job Number and totals
        Dim dtWODetails As New DataTable 'Job Number and totals
        Dim strJobNo As String
        Dim InvoiceListXML As String = ""
        objWOHeaderBO.Id_WO_NO = idWoNo
        objWOHeaderBO.Id_WO_Prefix = idWoPr
        objWOHeaderBO.Created_By = loginName
        dsWOJobs = objWOHeaderDO.Fetch_WOHeader(objWOHeaderBO)
        If (dsWOJobs.Tables.Count > 0) Then
            dtWOJobs = dsWOJobs.Tables(3)

            If (dtWOJobs.Rows.Count > 0) Then
                For Each dtwojobsrow As DataRow In dtWOJobs.Rows
                    Dim details As New List(Of WOJobDetailBO)()
                    strJobNo = dtwojobsrow("Id_Job").ToString()
                    objWOJDetailsBO.Id_Job = strJobNo
                    objWOJDetailsBO.Id_WO_NO = idWoNo
                    objWOJDetailsBO.Id_WO_Prefix = idWoPr
                    dsWODetails = objWOJobDetailsDO.WorkDetails(objWOJDetailsBO)
                    If dsWODetails.Tables.Count > 0 Then
                        dtWODetails = dsWODetails.Tables(0)
                        For Each dtwodetrow As DataRow In dtWODetails.Rows
                            InvoiceListXML += "<INV_GENERATE " _
                            + " ID_WO_PREFIX=""" + commonUtil.ConvertStr(idWoPr) + """ " _
                            + " ID_WO_NO=""" + commonUtil.ConvertStr(idWoNo) + """ " _
                            + " ID_WODET_SEQ=""" + commonUtil.ConvertStr(dtwodetrow("ID_WODET_SEQ")) + """ " _
                            + " ID_JOB_DEB=""" + commonUtil.ConvertStr(dtwodetrow("ID_JOB_DEB")) + """ " _
                            + " FLG_BATCH=""" + commonUtil.ConvertStr(dtwodetrow("FLG_CUST_BATCHINV")) + """ " _
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


    End Sub
    Shared Sub ConstructInvoiceXml(ByVal idWoNo As String, ByVal idWoPr As String)
        Dim dsWOJobs As New DataSet 'No of Jobs
        Dim dtWOJobs As New DataTable 'No of Jobs
        Dim dsWODetails As New DataSet  'Job Number and totals
        Dim dtWODetails As New DataTable 'Job Number and totals
        Dim strJobNo As String
        Dim InvoiceListXML As String = ""
        Dim strRetVal As String = ""
        Dim strInvLstXml As String = ""
        objWOHeaderBO.Id_WO_NO = idWoNo
        objWOHeaderBO.Id_WO_Prefix = idWoPr
        objWOHeaderBO.Created_By = loginName
        dsWOJobs = objWOHeaderDO.Fetch_WOHeader(objWOHeaderBO)
        If (dsWOJobs.Tables.Count > 0) Then
            dtWOJobs = dsWOJobs.Tables(3)

            If (dtWOJobs.Rows.Count > 0) Then
                For Each dtwojobsrow As DataRow In dtWOJobs.Rows
                    Dim details As New List(Of WOJobDetailBO)()
                    strJobNo = dtwojobsrow("Id_Job").ToString()
                    objWOJDetailsBO.Id_Job = strJobNo
                    objWOJDetailsBO.Id_WO_NO = idWoNo
                    objWOJDetailsBO.Id_WO_Prefix = idWoPr
                    dsWODetails = objWOJobDetailsDO.WorkDetails(objWOJDetailsBO)
                    If dsWODetails.Tables.Count > 0 Then
                        dtWODetails = dsWODetails.Tables(0)
                        For Each dtwodetrow As DataRow In dtWODetails.Rows
                            InvoiceListXML += "<INV_GENERATE " _
                            + " ID_WO_PREFIX=""" + commonUtil.ConvertStr(idWoPr) + """ " _
                            + " ID_WO_NO=""" + commonUtil.ConvertStr(idWoNo) + """ " _
                            + " ID_WODET_SEQ=""" + commonUtil.ConvertStr(dtwodetrow("ID_WODET_SEQ")) + """ " _
                            + " ID_JOB_DEB=""" + commonUtil.ConvertStr(dtwodetrow("ID_JOB_DEB")) + """ " _
                            + " FLG_BATCH=""" + commonUtil.ConvertStr(dtwodetrow("FLG_CUST_BATCHINV")) + """ " _
                            + " IV_DATE =""" + "" + """ " _
                         + "/>"
                        Next
                    End If
                Next
            End If
        End If

        InvoiceListXML = "<ROOT>" + InvoiceListXML + "</ROOT>"
        strRetVal = objInvDetDO.Generate_Invoices_Intermediate(InvoiceListXML, loginName, strInvLstXml)
        strInvLstXml = strInvLstXml.Replace("INVNO", "ID_INV_NO")
        HttpContext.Current.Session("xmlInvNos") = strInvLstXml
        HttpContext.Current.Session("RptType") = "INVOICE"


    End Sub

    <WebMethod()> _
    Public Shared Function FetchJoBNo(ByVal idWONO As String, ByVal idWOPrefix As String, ByVal userId As String) As String
        Dim strJobNo As String

        Try
            objWOJDetailsBO.Id_WO_NO = idWONO
            objWOJDetailsBO.Id_WO_Prefix = idWOPrefix
            objWOJDetailsBO.Created_By = userId

            strJobNo = objWOJServ.FetchJobNo(objWOJDetailsBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWOJobDetails", "FetchJoBNo", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strJobNo
    End Function
    <WebMethod()> _
    Public Shared Function BindGrid(ByVal idWONO As String, ByVal idWOPrefix As String, ByVal userId As String) As WOJobDetailBO()
        Try
            objWOJDetailsBO.Id_WO_NO = idWONO
            objWOJDetailsBO.Id_WO_Prefix = idWOPrefix
            objWOJDetailsBO.Created_By = userId
            details = objWOJServ.BindGrid(objWOJDetailsBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWOJobDetails", "LoadPriceCode", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function GetSpares(ByVal spName As String, ByVal idCustomer As String, ByVal vehId As String) As WOJobDetailBO()
        Dim details As New List(Of WOJobDetailBO)()
        Try
            If (spName.Length >= 3) Then
                objWOJDetailsBO.Id_Item = spName
                objWOJDetailsBO.Id_Customer = idCustomer
                objWOJDetailsBO.WO_Id_Veh = vehId
                objWOJDetailsBO.Created_By = loginName
                details = objWOJServ.Fetch_Spares(objWOJDetailsBO)
            End If
        Catch exth As System.Threading.ThreadAbortException
            Throw exth
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWOJobDetails", "GetSpares", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function GetSparesList(ByVal spName As String, ByVal idCustomer As String, ByVal vehId As String, ByVal make As String, ByVal supplier As String, ByVal location As String, ByVal FlgstockItem As String, ByVal FlgStockItemStatus As String, ByVal FlgNonStockItemStatus As String) As WOJobDetailBO()
        Dim details As New List(Of WOJobDetailBO)()
        Try
            If (spName.Length >= 3) Then
                objWOJDetailsBO.Id_Item = spName
                objWOJDetailsBO.Id_Customer = idCustomer
                objWOJDetailsBO.WO_Id_Veh = vehId
                objWOJDetailsBO.Sp_Make = make
                objWOJDetailsBO.SP_SupplierID = supplier
                objWOJDetailsBO.Sp_Location = location
                objWOJDetailsBO.Sp_FlgStockItem = FlgstockItem
                objWOJDetailsBO.SP_FlgStockItemStatus = FlgStockItemStatus
                objWOJDetailsBO.SP_FlgNonStockItemStatus = FlgNonStockItemStatus
                objWOJDetailsBO.Created_By = loginName
                details = objWOJServ.Fetch_SparesList(objWOJDetailsBO)
            End If
        Catch exth As System.Threading.ThreadAbortException
            Throw exth
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWOJobDetails", "GetSpares", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function AddSpareLine(ByVal idWONO As String, ByVal idWOPrefix As String) As WOJobDetailBO()
        Try
            details = objWOJServ.AddSpareLine(idWONO, idWOPrefix)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWOJobDetails", "AddSpareLine", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function LoadHourlyPrice(ByVal idCust As String, ByVal userid As String, ByVal idMakeRP As String, ByVal idRPPCD_Hp As String, ByVal jobPCD_Hp As String, ByVal vehGrp As String, ByVal jobId As String, ByVal chkChrgStdTime As String, ByVal hpmode As String) As WOJobDetailBO()
        Try
            objWOJDetailsBO.Id_Customer = idCust 'HttpContext.Current.Session("IdCustomer")
            objWOJDetailsBO.Created_By = userid
            objWOJDetailsBO.Id_Make_Rp = IIf(idMakeRP = "", HttpContext.Current.Session("ID_MAKE_HP"), idMakeRP)
            objWOJDetailsBO.Id_RpPcd_Hp = IIf(idRPPCD_Hp = "", Nothing, idRPPCD_Hp)
            objWOJDetailsBO.Id_Jobpcd_WO = IIf(jobPCD_Hp = "", Nothing, jobPCD_Hp)
            objWOJDetailsBO.Veh_Grp = HttpContext.Current.Session("VehGroup")
            details = objWOJServ.FetchHourlyPrice(objWOJDetailsBO, hpmode)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWOJobDetails", "LoadHourlyPrice", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function LoadConfig(ByVal idWONO As String, ByVal idWOPrefix As String, ByVal userId As String, ByVal idMakeRP As String, ByVal idModelRP As String, ByVal idJob As String) As Collection
        Dim dtConfig As New Collection
        Try

            objWOJDetailsBO.Id_WO_NO = idWONO
            objWOJDetailsBO.Id_WO_Prefix = idWOPrefix
            objWOJDetailsBO.Created_By = userId
            objWOJDetailsBO.Id_Make_Rp = idMakeRP
            objWOJDetailsBO.Id_Model_Rp = idModelRP
            objWOJDetailsBO.Id_Job = idJob

            dtConfig = objWOJServ.Load_ConfigDetails(objWOJDetailsBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWOJobDetails", "LoadConfig", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return dtConfig
    End Function
    <WebMethod()> _
    Public Shared Function LoadGMHPVat(ByVal idCust As String, ByVal idVehSeq As String, ByVal idItem As String, ByVal idMake As String) As WOJobDetailBO()
        Try
            objWOJDetailsBO.Id_Customer = idCust
            objWOJDetailsBO.WO_Id_Veh = idVehSeq
            objWOJDetailsBO.Id_Gm_Vat = HttpContext.Current.Session("ID_GMVAT")
            objWOJDetailsBO.Id_Hp_Vat = HttpContext.Current.Session("ID_HPVAT")
            objWOJDetailsBO.Id_Item = idItem
            objWOJDetailsBO.Id_Make = idMake
            details = objWOJServ.LoadGMHPVat(objWOJDetailsBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWOJobDetails", "LoadHourlyPrice", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function GetSpareById(ByVal spName As String, ByVal idCustomer As String, ByVal vehId As String) As WOJobDetailBO()
        Dim details As New List(Of WOJobDetailBO)()
        Try
            'If (spName.Length >= 3) Then
            objWOJDetailsBO.Id_Item = spName
            objWOJDetailsBO.Id_Customer = idCustomer '"16525" 'HttpContext.Current.Session("IdCustomer") ' custId
            objWOJDetailsBO.WO_Id_Veh = vehId '"7508" 'HttpContext.Current.Session("Veh_Seq_No") 'vehId
            objWOJDetailsBO.Created_By = loginName
            details = objWOJServ.Get_Spare(objWOJDetailsBO)
            'End If
        Catch exth As System.Threading.ThreadAbortException
            Throw exth
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWOJobDetails", "GetSpares", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function LoadRepairCode() As WOJobDetailBO()
        Try
            details = objWOJServ.Load_RepairCode()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWOJobDetails", "LoadRepairCode", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function LoadWorkCode() As WOJobDetailBO()
        Try
            details = objWOJServ.Load_WorkCode()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWOJobDetails", "LoadWorkCode", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function SaveJobDet(ByVal jobIdXmls As String, ByVal spareXmls As String, ByVal discXmls As String, ByVal mechXmls As String, ByVal idWODetSeq As String, ByVal idWONO As String, ByVal idWOPrefix As String,
        ByVal idRpgCatgWO As String, ByVal idRpgCodeWO As String, ByVal idRepCodeWO As String, ByVal idWorkCodeWO As String, ByVal woFixedPrice As String, ByVal idJobPcdWO As String, ByVal woPlannedTime As String,
        ByVal woHourleyPrice As String, ByVal woClkTime As String, ByVal woChrgTime As String, ByVal flgChrgStdTime As String, ByVal woStdTime As String, ByVal statReq As String, ByVal woJobTxt As String,
        ByVal woOwnRiskAmt As String, ByVal woTotLabAmt As String, ByVal woTotSpareAmt As String, ByVal woTotGmAmt As String, ByVal woTotVatAmt As String, ByVal woTotDiscAmt As String, ByVal jobStatus As String,
        ByVal woOwnPayVat As String, ByVal idDefectNoteSeq As String, ByVal totalamt As String, ByVal idMechComp As String, ByVal woOwnRiskCust As String, ByVal woOwnCrCust As String,
        ByVal idSerCallNo As String, ByVal woGmPer As String, ByVal woGmVatPer As String, ByVal woLbrVatPer As String, ByVal woInclVat As String, ByVal woDiscount As String, ByVal subrepCodeWO As String,
        ByVal ownriskvat As String, ByVal flgSprsts As String, ByVal salesman As String, ByVal flgVatFree As String, ByVal costPrice As String, ByVal finalTotal As String, ByVal finalVat As String, ByVal finalDiscount As String,
        ByVal woChrgTimeFp As String, ByVal woTotLabAmtFp As String, ByVal woTotSpareAmtFp As String, ByVal woTotGmAmtFp As String, ByVal woTotVatAmtFp As String, ByVal woTotDiscAmtFp As String,
        ByVal woIntNote As String, ByVal idJob As String, ByVal flgawaitingSp As String, ByVal mode As String, ByVal idMech As String, ByVal woOwnRiskDesc As String, ByVal woOwnRiskSlNo As String) As String()
        Dim strResult As String()
        Dim WO_Own_Risk_Amt, WO_Tot_Lab_Amt, WO_Tot_Spare_Amt, WO_Tot_Gm_Amt, WO_Tot_Vat_Amt, WO_Tot_Disc_Amt As String
        Try

            WO_Own_Risk_Amt = commonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(woOwnRiskAmt = "", 0D, woOwnRiskAmt))
            WO_Tot_Lab_Amt = commonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(woTotLabAmt = "", 0D, woTotLabAmt))
            WO_Tot_Spare_Amt = commonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(woTotSpareAmt = "", 0D, woTotSpareAmt))
            WO_Tot_Gm_Amt = commonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(woTotGmAmt = "", 0D, woTotGmAmt))
            WO_Tot_Vat_Amt = commonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(woTotVatAmt = "", 0D, woTotVatAmt))

            WO_Tot_Disc_Amt = commonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(woTotDiscAmt = "", 0D, woTotDiscAmt))

            objWOJDetailsBO.Id_Wodet_Seq = idWODetSeq
            objWOJDetailsBO.Id_WO_NO = idWONO 'pass as parameter
            objWOJDetailsBO.Id_WO_Prefix = idWOPrefix 'pass as parameter
            objWOJDetailsBO.Id_Rpg_Catg_WO = Nothing
            objWOJDetailsBO.Id_Rpg_Code_WO = Nothing
            objWOJDetailsBO.Id_Rep_Code_WO = IIf(idRepCodeWO = "", 1, idRepCodeWO)
            objWOJDetailsBO.Id_Work_Code_WO = idWorkCodeWO
            objWOJDetailsBO.WO_Fixed_Price = IIf(woFixedPrice = "", 0, woFixedPrice)
            objWOJDetailsBO.Id_Jobpcd_WO = idJobPcdWO
            objWOJDetailsBO.WO_Planned_Time = "0"
            objWOJDetailsBO.WO_Hourley_Price = woHourleyPrice
            objWOJDetailsBO.WO_Clk_Time = woClkTime
            objWOJDetailsBO.WO_Chrg_Time = woChrgTime
            objWOJDetailsBO.Flg_Chrg_Std_Time = flgChrgStdTime
            objWOJDetailsBO.WO_Std_Time = woStdTime
            objWOJDetailsBO.Flg_Stat_Req = IIf(statReq = "", 0, statReq)
            objWOJDetailsBO.WO_Job_Txt = "" 'pass as parameter
            objWOJDetailsBO.WO_Own_Risk_Amt = Convert.ToDecimal(WO_Own_Risk_Amt)
            objWOJDetailsBO.WO_Tot_Lab_Amt = Convert.ToDecimal(WO_Tot_Lab_Amt)
            objWOJDetailsBO.WO_Tot_Spare_Amt = Convert.ToDecimal(WO_Tot_Spare_Amt)
            objWOJDetailsBO.WO_Tot_Gm_Amt = Convert.ToDecimal(WO_Tot_Gm_Amt)
            objWOJDetailsBO.WO_Tot_Vat_Amt = Convert.ToDecimal(WO_Tot_Vat_Amt)
            objWOJDetailsBO.WO_Tot_Disc_Amt = Convert.ToDecimal(WO_Tot_Disc_Amt)
            objWOJDetailsBO.Job_Status = jobStatus
            objWOJDetailsBO.Created_By = loginName
            objWOJDetailsBO.Dt_Created = Now
            objWOJDetailsBO.WO_Own_Pay_Vat = woOwnPayVat
            'objWOJobDetailsBO.Dis_Doc
            objWOJDetailsBO.Id_Def_Seq = idDefectNoteSeq
            objWOJDetailsBO.Tot_Amount = IIf(totalamt = "", 0, totalamt)
            'objWOJDetailsBO.Mechanic_Doc
            objWOJDetailsBO.Mech_Compt_Description = idMechComp
            objWOJDetailsBO.WO_Own_Risk_Cust = woOwnRiskCust
            objWOJDetailsBO.WO_Own_Cr_Cust = woOwnCrCust
            objWOJDetailsBO.Id_Ser_Call = idSerCallNo
            objWOJDetailsBO.WO_Gm_Per = woGmPer
            objWOJDetailsBO.WO_Gm_Vatper = woGmVatPer
            objWOJDetailsBO.WO_Lbr_Vatper = woLbrVatPer
            objWOJDetailsBO.Bus_Pek_Control_Num = ""
            objWOJDetailsBO.WO_PKKDate = Nothing
            objWOJDetailsBO.WO_Incl_Vat = woInclVat
            If (woDiscount = "undefined") Then
                objWOJDetailsBO.WO_Discount = 0
            Else
                objWOJDetailsBO.WO_Discount = IIf(woDiscount = "", 0, woDiscount)
            End If
            objWOJDetailsBO.Id_Subrep_Code_WO = IIf(subrepCodeWO = "", 0, subrepCodeWO)
            objWOJDetailsBO.WO_Ownriskvat = IIf(ownriskvat = "", 0, ownriskvat)
            objWOJDetailsBO.Flg_Sprsts = flgawaitingSp
            objWOJDetailsBO.Salesman = "" 'VA Orders
            objWOJDetailsBO.Flg_Vat_Free = "0" 'VA Orders
            objWOJDetailsBO.Cost_Price = costPrice
            objWOJDetailsBO.Final_Total = IIf(finalTotal = "", 0, finalTotal)
            objWOJDetailsBO.Final_Vat = IIf(finalVat = "", 0, finalVat)
            objWOJDetailsBO.Final_Discount = finalDiscount
            objWOJDetailsBO.Id_Job = idJob
            objWOJDetailsBO.WO_Chrg_Time_Fp = woChrgTimeFp
            objWOJDetailsBO.WO_Tot_Lab_Amt_Fp = IIf(woTotLabAmtFp = "", 0, woTotLabAmtFp)
            objWOJDetailsBO.WO_Tot_Spare_Amt_Fp = IIf(woTotSpareAmtFp = "", 0, woTotSpareAmtFp)
            objWOJDetailsBO.WO_Tot_Gm_Amt_Fp = IIf(woTotGmAmtFp = "", 0, woTotGmAmtFp)
            objWOJDetailsBO.WO_Tot_Vat_Amt_Fp = IIf(woTotVatAmtFp = "", 0, woTotVatAmtFp)
            objWOJDetailsBO.WO_Tot_Disc_Amt_Fp = IIf(woTotDiscAmtFp = "", 0, woTotDiscAmtFp)
            objWOJDetailsBO.WO_Int_Note = woIntNote
            objWOJDetailsBO.Id_Job_Deb = woOwnRiskCust 'pass customer
            objWOJDetailsBO.Job_Doc = IIf(spareXmls = "", Nothing, spareXmls)
            objWOJDetailsBO.WO_Doc = IIf(jobIdXmls = "", Nothing, jobIdXmls)
            objWOJDetailsBO.Dis_Doc = IIf(discXmls = "", Nothing, discXmls)
            objWOJDetailsBO.Mechanic_Doc = IIf(mechXmls = "", Nothing, mechXmls)
            objWOJDetailsBO.IdMech = IIf(idMech = "undefined", "", idMech)
            objWOJDetailsBO.WO_Own_Risk_Desc = woOwnRiskDesc
            objWOJDetailsBO.WO_Own_Risk_SlNo = woOwnRiskSlNo
            strResult = objWOJServ.Save_GridJobDetails(objWOJDetailsBO, mode)
            'ConstructInvBasisXml(idWONO, idWOPrefix)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWOJobDetails", "saveJobDet", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
    <WebMethod()> _
    Public Shared Function Get_vat_Dis(ByVal idItem As String, ByVal idJobDeb As String, ByVal idVeh As String, ByVal idMake As String, ByVal idWh As String) As String
        Dim discSeq As String
        Try
            objWOJDetailsBO.Created_By = loginName
            objWOJDetailsBO.Id_Job_Deb = idJobDeb
            objWOJDetailsBO.Id_Item_Job = idItem
            objWOJDetailsBO.WO_Id_Veh = idVeh
            objWOJDetailsBO.Id_Make = idMake
            objWOJDetailsBO.Id_Wh_Item = idWh

            discSeq = objWOJobDetailsDO.Get_vat_Dis(objWOJDetailsBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWOJobDetails", "Get_vat_Dis", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return discSeq
    End Function
    <WebMethod()> _
    Public Shared Function Fetch_Sp_Make(ByVal q As String) As WOJobDetailBO()
        Dim makeDetails As New List(Of WOJobDetailBO)()
        Try
            makeDetails = objWOJServ.FetchSpareMake(q)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWOJobDetails", "Fetch_Sp_Make", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return makeDetails.ToList.ToArray
    End Function
    <WebMethod()> _
    Public Shared Function Fetch_Sp_Supplier(ByVal q As String) As WOJobDetailBO()
        Dim makeDetails As New List(Of WOJobDetailBO)()
        Try
            makeDetails = objWOJServ.FetchSpareSupplier(q)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWOJobDetails", "Fetch_Sp_Make", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return makeDetails.ToList.ToArray
    End Function
    <WebMethod()> _
    Public Shared Function Fetch_Sp_Location(ByVal q As String) As WOJobDetailBO()
        Dim makeDetails As New List(Of WOJobDetailBO)()
        Try
            makeDetails = objWOJServ.FetchSpareLocation(q)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWOJobDetails", "Fetch_Sp_Make", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return makeDetails.ToList.ToArray
    End Function
    <WebMethod()> _
    Public Shared Function Load_WorkOrderDetails(ByVal idWONO As String, ByVal idWOPrefix As String) As WOJobDetailBO()
        Try
            objWOJDetailsBO.Id_WO_NO = idWONO
            objWOJDetailsBO.Id_WO_Prefix = idWOPrefix
            objWOJDetailsBO.Created_By = loginName
            details = objWOJServ.LoadWorkOrderDetails(objWOJDetailsBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWOJobDetails", "Load_WorkOrderDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function DeleteSaveJobDet(ByVal jobIdXmls As String, ByVal spareXmls As String, ByVal discXmls As String, ByVal mechXmls As String, ByVal idWODetSeq As String, ByVal idWONO As String, ByVal idWOPrefix As String,
        ByVal idRpgCatgWO As String, ByVal idRpgCodeWO As String, ByVal idRepCodeWO As String, ByVal idWorkCodeWO As String, ByVal woFixedPrice As String, ByVal idJobPcdWO As String, ByVal woPlannedTime As String,
        ByVal woHourleyPrice As String, ByVal woClkTime As String, ByVal woChrgTime As String, ByVal flgChrgStdTime As String, ByVal woStdTime As String, ByVal statReq As String, ByVal woJobTxt As String,
        ByVal woOwnRiskAmt As String, ByVal woTotLabAmt As String, ByVal woTotSpareAmt As String, ByVal woTotGmAmt As String, ByVal woTotVatAmt As String, ByVal woTotDiscAmt As String, ByVal jobStatus As String,
        ByVal woOwnPayVat As String, ByVal idDefectNoteSeq As String, ByVal totalamt As String, ByVal idMechComp As String, ByVal woOwnRiskCust As String, ByVal woOwnCrCust As String,
        ByVal idSerCallNo As String, ByVal woGmPer As String, ByVal woGmVatPer As String, ByVal woLbrVatPer As String, ByVal woInclVat As String, ByVal woDiscount As String, ByVal subrepCodeWO As String,
        ByVal ownriskvat As String, ByVal flgSprsts As String, ByVal salesman As String, ByVal flgVatFree As String, ByVal costPrice As String, ByVal finalTotal As String, ByVal finalVat As String, ByVal finalDiscount As String,
        ByVal woChrgTimeFp As String, ByVal woTotLabAmtFp As String, ByVal woTotSpareAmtFp As String, ByVal woTotGmAmtFp As String, ByVal woTotVatAmtFp As String, ByVal woTotDiscAmtFp As String,
        ByVal woIntNote As String, ByVal idJob As String, ByVal flgawaitingSp As String, ByVal mode As String, ByVal idMech As String, ByVal woOwnRiskDesc As String, ByVal woOwnRiskSlNo As String) As String()
        Dim strResult As String()
        Dim WO_Own_Risk_Amt, WO_Tot_Lab_Amt, WO_Tot_Spare_Amt, WO_Tot_Gm_Amt, WO_Tot_Vat_Amt, WO_Tot_Disc_Amt As String
        Try

            WO_Own_Risk_Amt = commonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(woOwnRiskAmt = "", 0D, woOwnRiskAmt))
            WO_Tot_Lab_Amt = commonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(woTotLabAmt = "", 0D, woTotLabAmt))
            WO_Tot_Spare_Amt = commonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(woTotSpareAmt = "", 0D, woTotSpareAmt))
            WO_Tot_Gm_Amt = commonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(woTotGmAmt = "", 0D, woTotGmAmt))
            WO_Tot_Vat_Amt = commonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(woTotVatAmt = "", 0D, woTotVatAmt))
            WO_Tot_Disc_Amt = commonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(woTotDiscAmt = "", 0D, woTotDiscAmt))

            objWOJDetailsBO.Id_Wodet_Seq = idWODetSeq
            objWOJDetailsBO.Id_WO_NO = idWONO 'pass as parameter
            objWOJDetailsBO.Id_WO_Prefix = idWOPrefix 'pass as parameter
            objWOJDetailsBO.Id_Rpg_Catg_WO = Nothing
            objWOJDetailsBO.Id_Rpg_Code_WO = Nothing
            objWOJDetailsBO.Id_Rep_Code_WO = IIf(idRepCodeWO = "", 1, idRepCodeWO)
            objWOJDetailsBO.Id_Work_Code_WO = idWorkCodeWO
            objWOJDetailsBO.WO_Fixed_Price = IIf(woFixedPrice = "", 0, woFixedPrice)
            objWOJDetailsBO.Id_Jobpcd_WO = idJobPcdWO
            objWOJDetailsBO.WO_Planned_Time = "0"
            objWOJDetailsBO.WO_Hourley_Price = woHourleyPrice
            objWOJDetailsBO.WO_Clk_Time = woClkTime
            objWOJDetailsBO.WO_Chrg_Time = woChrgTime
            objWOJDetailsBO.Flg_Chrg_Std_Time = flgChrgStdTime
            objWOJDetailsBO.WO_Std_Time = woStdTime
            objWOJDetailsBO.Flg_Stat_Req = IIf(statReq = "", 0, statReq)
            objWOJDetailsBO.WO_Job_Txt = "" 'pass as parameter
            objWOJDetailsBO.WO_Own_Risk_Amt = Convert.ToDecimal(WO_Own_Risk_Amt)
            objWOJDetailsBO.WO_Tot_Lab_Amt = Convert.ToDecimal(WO_Tot_Lab_Amt)
            objWOJDetailsBO.WO_Tot_Spare_Amt = Convert.ToDecimal(WO_Tot_Spare_Amt)
            objWOJDetailsBO.WO_Tot_Gm_Amt = Convert.ToDecimal(WO_Tot_Gm_Amt)
            objWOJDetailsBO.WO_Tot_Vat_Amt = Convert.ToDecimal(WO_Tot_Vat_Amt)
            objWOJDetailsBO.WO_Tot_Disc_Amt = Convert.ToDecimal(WO_Tot_Disc_Amt)
            objWOJDetailsBO.Job_Status = jobStatus
            objWOJDetailsBO.Created_By = loginName
            objWOJDetailsBO.Dt_Created = Now
            objWOJDetailsBO.WO_Own_Pay_Vat = woOwnPayVat
            'objWOJobDetailsBO.Dis_Doc
            objWOJDetailsBO.Id_Def_Seq = idDefectNoteSeq
            objWOJDetailsBO.Tot_Amount = IIf(totalamt = "", 0, totalamt)
            'objWOJDetailsBO.Mechanic_Doc
            objWOJDetailsBO.Mech_Compt_Description = idMechComp
            objWOJDetailsBO.WO_Own_Risk_Cust = woOwnRiskCust
            objWOJDetailsBO.WO_Own_Cr_Cust = woOwnCrCust
            objWOJDetailsBO.Id_Ser_Call = idSerCallNo
            objWOJDetailsBO.WO_Gm_Per = woGmPer
            objWOJDetailsBO.WO_Gm_Vatper = woGmVatPer
            objWOJDetailsBO.WO_Lbr_Vatper = woLbrVatPer
            objWOJDetailsBO.Bus_Pek_Control_Num = ""
            objWOJDetailsBO.WO_PKKDate = Nothing
            objWOJDetailsBO.WO_Incl_Vat = woInclVat
            If (woDiscount = "undefined") Then
                objWOJDetailsBO.WO_Discount = 0
            Else
                objWOJDetailsBO.WO_Discount = IIf(woDiscount = "", 0, woDiscount)
            End If
            objWOJDetailsBO.Id_Subrep_Code_WO = IIf(subrepCodeWO = "", 0, subrepCodeWO)
            objWOJDetailsBO.WO_Ownriskvat = IIf(ownriskvat = "", 0, ownriskvat)
            objWOJDetailsBO.Flg_Sprsts = flgawaitingSp
            objWOJDetailsBO.Salesman = "" 'VA Orders
            objWOJDetailsBO.Flg_Vat_Free = "0" 'VA Orders
            objWOJDetailsBO.Cost_Price = costPrice
            objWOJDetailsBO.Final_Total = IIf(finalTotal = "", 0, finalTotal)
            objWOJDetailsBO.Final_Vat = IIf(finalVat = "", 0, finalVat)
            objWOJDetailsBO.Final_Discount = finalDiscount
            objWOJDetailsBO.Id_Job = idJob
            objWOJDetailsBO.WO_Chrg_Time_Fp = woChrgTimeFp
            objWOJDetailsBO.WO_Tot_Lab_Amt_Fp = IIf(woTotLabAmtFp = "", 0, woTotLabAmtFp)
            objWOJDetailsBO.WO_Tot_Spare_Amt_Fp = IIf(woTotSpareAmtFp = "", 0, woTotSpareAmtFp)
            objWOJDetailsBO.WO_Tot_Gm_Amt_Fp = IIf(woTotGmAmtFp = "", 0, woTotGmAmtFp)
            objWOJDetailsBO.WO_Tot_Vat_Amt_Fp = IIf(woTotVatAmtFp = "", 0, woTotVatAmtFp)
            objWOJDetailsBO.WO_Tot_Disc_Amt_Fp = IIf(woTotDiscAmtFp = "", 0, woTotDiscAmtFp)
            objWOJDetailsBO.WO_Int_Note = woIntNote
            objWOJDetailsBO.Id_Job_Deb = woOwnRiskCust 'pass customer
            objWOJDetailsBO.Job_Doc = spareXmls
            objWOJDetailsBO.WO_Doc = jobIdXmls
            objWOJDetailsBO.Dis_Doc = discXmls
            objWOJDetailsBO.Mechanic_Doc = IIf(mechXmls = "", Nothing, mechXmls)
            objWOJDetailsBO.IdMech = IIf(idMech = "undefined", "", idMech)
            objWOJDetailsBO.WO_Own_Risk_Desc = woOwnRiskDesc
            objWOJDetailsBO.WO_Own_Risk_SlNo = woOwnRiskSlNo
            strResult = objWOJServ.Delete_Save_JobDetails(objWOJDetailsBO, mode)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWOJobDetails", "DeleteSaveJobDet", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
    <WebMethod()> _
    Public Shared Function SaveSparesSett(ByVal makeIdXml As String, ByVal suppIdXmls As String, ByVal locXmls As String, ByVal FlgstockItem As String, ByVal FlgStockItemStatus As String, ByVal FlgNonStockItemStatus As String) As String
        Dim strResult As String
        Try
            objWOJDetailsBO.Id_Make = makeIdXml
            objWOJDetailsBO.Sp_Location = locXmls
            objWOJDetailsBO.SP_SupplierName = suppIdXmls
            objWOJDetailsBO.SP_FlgStockItemStatus = FlgStockItemStatus
            objWOJDetailsBO.SP_FlgNonStockItemStatus = FlgNonStockItemStatus
            objWOJDetailsBO.Sp_FlgStockItem = FlgstockItem
            objWOJDetailsBO.Created_By = loginName
            strResult = objWOJServ.SaveSpareSett(objWOJDetailsBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWOJobDetails", "SaveSparesSett", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
    <WebMethod()> _
    Public Shared Function DeleteTextline(ByVal idWoItemSeq As String, ByVal idWONO As String, ByVal idWOPrefix As String) As String
        Dim strResult As String

        Try
            objWOJDetailsBO.Id_WO_NO = idWONO
            objWOJDetailsBO.Id_WO_Prefix = idWOPrefix
            objWOJDetailsBO.Id_WOItem_Seq = idWoItemSeq

            strResult = objWOJServ.DeleteTextLine(objWOJDetailsBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWOJobDetails", "FetchJoBNo", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
    <WebMethod()> _
    Public Shared Function DeleteJobDebitor(ByVal jobIdXmls As String) As String()
        Dim strResult As String()
        Try
            objWOJDetailsBO.Id_WO_NO = jobIdXmls.ToString()
            strResult = objWOJServ.Delete_Job_Debitor(objWOJDetailsBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWOJobDetails", "DeleteJobDebitor", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
    <WebMethod()> _
    Public Shared Function FetchDelJobDet(ByVal idWoNo As String, ByVal idWoPr As String) As WOJobDetailBO()
        Try
            objWOJDetailsBO.Id_WO_NO = idWoNo
            objWOJDetailsBO.Id_WO_Prefix = idWoPr
            details = objWOJServ.FetchDeleteJob(objWOJDetailsBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWOJobDetails", "LoadHourlyPrice", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function Invoice(ByVal idWoNo As String, ByVal idWoPr As String) As String()
        Dim strRetVal As String()
        Try

            objWOJDetailsBO.Id_WO_NO = idWoNo
            objWOJDetailsBO.Id_WO_Prefix = idWoPr
            'details = objWOJServ.FetchDeleteJob(objWOJDetailsBO)
            strRetVal = objWOJServ.InvoiceProcess(idWoNo, idWoPr)

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWOJobDetails", "Invoice", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strRetVal
    End Function

    <WebMethod()> _
    Public Shared Function InvoiceBasis(ByVal idWoNo As String, ByVal idWoPr As String) As String
        Dim strRetVal As String = ""
        Try
            objWOJDetailsBO.Id_WO_NO = idWoNo
            objWOJDetailsBO.Id_WO_Prefix = idWoPr
            'details = objWOJServ.FetchDeleteJob(objWOJDetailsBO)
            strRetVal = objWOJServ.InvoiceBasisProcess(idWoNo, idWoPr)

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWOJobDetails", "InvoiceBasis", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strRetVal
    End Function
    <WebMethod()> _
    Public Shared Function LoadJobCard() As String
        Dim reportRequest As String = ""
        Dim rnd As New Random()
        Try
            Dim WONO As String = HttpContext.Current.Session("WONO")
            Dim WOPREFIX As String = HttpContext.Current.Session("WOPR")

            HttpContext.Current.Session("xmlInvNos") = "<ROOT><WONOPREFIX  ID_WO_PREFIX='" + commonUtil.ConvertStr(HttpContext.Current.Session("WOPR").ToString()) + "'  ID_WO_NO='" + commonUtil.ConvertStr(HttpContext.Current.Session("WONO").ToString()) + "'/></ROOT>"
            HttpContext.Current.Session("RptType") = "WOJobCard"
            reportRequest = "../Reports/frmShowReports.aspx?ReportHeader=" + commonUtil.fnEncryptQString("WOJobCard") + "&InvoiceType=" + commonUtil.fnEncryptQString("WOJobCard") + "&Rpt=" + commonUtil.fnEncryptQString("INVOICEPRINT") + "&scrid=" + rnd.Next().ToString()

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWOJobDetails", "LoadReport", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return reportRequest
    End Function

    <WebMethod()> _
    Public Shared Function LoadReport(ByVal reportType As String) As String
        Dim strVal As String = "True"
        Dim orderType As String = ""
        Dim reportRequest As String = ""
        Dim rnd As New Random()
        'Dim default_pickd As Double = 0
        Dim ds As New DataSet
        Dim dt As New DataTable
        Try
            Dim WONO As String = HttpContext.Current.Session("WONO")
            Dim WOPREFIX As String = HttpContext.Current.Session("WOPR")
            objWOHeaderBO.Id_WO_NO = WONO
            objWOHeaderBO.Id_WO_Prefix = WOPREFIX
            objWOHeaderBO.Created_By = HttpContext.Current.Session("USERID")
            Dim woHeader As DataSet = objWOHeaderDO.Fetch_WOHeader(objWOHeaderBO)
            If woHeader.Tables(0).Rows.Count > 0 Then
                orderType = woHeader.Tables(0).Rows(0)("WOH_TYPE")
                If (orderType = "CRSL") Then
                    orderType = "ORDER"
                End If
            End If

            Select Case reportType
                Case "PICKINGLIST"
                    reportRequest = "../Reports/frmShowReports.aspx?ReportHeader=" + commonUtil.fnEncryptQString("PICKINGLIST") + "&Rpt=" + commonUtil.fnEncryptQString("PICKINGLIST") + "&OrderType=" + commonUtil.fnEncryptQString(orderType) + "&scrid=" + rnd.Next().ToString()
                Case "DELIVERYNOTE"
                    reportRequest = "../Reports/frmShowReports.aspx?ReportHeader=" + commonUtil.fnEncryptQString("DELIVERYNOTE") + "&Rpt=" + commonUtil.fnEncryptQString("DELIVERYNOTE") + "&OrderType=" + commonUtil.fnEncryptQString(orderType) + "&scrid=" + rnd.Next().ToString()
                Case "WorkOrderSpares"
                    reportRequest = "../Reports/frmShowReports.aspx?ReportHeader=" + commonUtil.fnEncryptQString("WorkOrderSpares") + "&Rpt=" + commonUtil.fnEncryptQString("WorkOrderSpares") + "&scrid=" + rnd.Next().ToString()
                Case "JOBCARD"
                    HttpContext.Current.Session("xmlInvNos") = "<ROOT><WONOPREFIX  ID_WO_PREFIX='" + commonUtil.ConvertStr(HttpContext.Current.Session("WOPR").ToString()) + "'  ID_WO_NO='" + commonUtil.ConvertStr(HttpContext.Current.Session("WONO").ToString()) + "'/></ROOT>"
                    HttpContext.Current.Session("RptType") = "WOJobCard"
                    reportRequest = "../Reports/frmShowReports.aspx?ReportHeader=" + commonUtil.fnEncryptQString("WOJobCard") + "&InvoiceType=" + commonUtil.fnEncryptQString("WOJobCard") + "&Rpt=" + commonUtil.fnEncryptQString("INVOICEPRINT") + "&scrid=" + rnd.Next().ToString()
            End Select

            If (reportType = "DELIVERYNOTE") Then
                details = objWOJServ.LoadReport(reportType, reportRequest)
            End If

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWOJobDetails", "LoadReport", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return reportRequest
    End Function
    <WebMethod()> _
    Public Shared Function UpdVehicle(ByVal vehicleId As String, ByVal customerId As String) As String
        Dim strRetVal As String = ""
        Try
            strRetVal = objWOJServ.UpdateVehOwner(vehicleId, customerId)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWOJobDetails", "InvoiceBasis", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strRetVal
    End Function
    <WebMethod()> _
    Public Shared Function EHF(ByVal idWoNo As String, ByVal idWoPr As String) As String
        Dim strRetVal As String = ""
        Try
            strRetVal = objWOJServ.GenerateXML(idWoNo, idWoPr)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWOJobDetails", "GenerateXML", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strRetVal
    End Function
End Class