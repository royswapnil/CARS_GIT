Imports System.Data
Imports Encryption
Imports MSGCOMMON
Imports System.Web.Services
Imports CARS.CoreLibrary.CARS
Imports CARS.CoreLibrary
Imports System.Web.UI
Imports System.Xml
Public Class frmWOHead
    Inherits System.Web.UI.Page
    Dim screenName As String
    Dim blWOsearch As Boolean = False
    Shared objWOHeaderBO As New CARS.CoreLibrary.WOHeaderBO
    Shared objWOHeaderServ As New CARS.CoreLibrary.CARS.Services.WOHeader.WOHeader
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared details As New List(Of WOHeaderBO)()
    Shared loginName As String
    Shared objServCustomer As New Services.Customer.CustomerDetails
    Shared objServVehicle As New Services.Vehicle.VehicleDetails
    Shared dtCaption As DataTable
    Shared objCommonUtil As New Utilities.CommonUtility
    Dim objuserper As New UserAccessPermissionsBO

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Session.Item("id") = Nothing
        Session("Mode") = Nothing
        If Session("UserID") Is Nothing Or Session("UserPageperDT") Is Nothing Then
            Response.Redirect("~/frmLogin.aspx")
        Else
            loginName = CType(Session("UserID"), String)

        End If
        screenName = IO.Path.GetFileName(Me.Request.PhysicalPath)
        Session("screenName") = screenName
        If Not Request.QueryString("Src") Is Nothing Then
            hdnScrName.Value = Request.QueryString("Src")
        End If
        If lbl_h_ordno.Text.ToString <> "Label" And lbl_h_prefix.Text.ToString <> "Label" Then
            Session("WONO") = lbl_h_ordno.Text
            Session("WOPR") = lbl_h_prefix.Text
        End If


        Dim ordDate As String
        ordDate = Date.Now.ToString 'objCommonUtil.GetCurrentLanguageDate(dsReturnVal.regFoerstegNorge)
        RTlblOrderDate.Text = objCommonUtil.GetCurrentLanguageDate(ordDate)
        If IsPostBack = False Then
            fnRolebasedAuth()
            Session("PrevPayterm") = String.Empty
            Session("PrevPayType") = String.Empty
            If (Request.QueryString("Src") = "DayPlanEdit") Then
                Session("WONO") = Request.QueryString("Wonumber")
                Session("WOPR") = Request.QueryString("WOPrefix")
                Session("ChkWONO") = Session("WONO")  'need to check if these sessions used fot other functionalities
                Session("ChkWOPR") = Session("WOPR")  'need to check if these sessions used fot other functionalities
            Else
                If fnDecryptQString("Wonumber") <> String.Empty Then
                    Session("WONO") = fnDecryptQString("Wonumber")
                    Session("WOPR") = fnDecryptQString("WOPrefix")
                    Session("ChkWONO") = Session("WONO") 'need to check if these sessions used fot other functionalities
                    Session("ChkWOPR") = Session("WOPR")  'need to check if these sessions used fot other functionalities
                ElseIf fnDecryptQString("Flag") = String.Empty Then
                    Session("WONO") = String.Empty
                    Session("WOPR") = String.Empty
                    Session("ChkWONO") = Session("WONO")  'need to check if these sessions used fot other functionalities
                    Session("ChkWOPR") = Session("WOPR") 'need to check if these sessions used fot other functionalities
                End If

            End If
            dtCaption = DirectCast(Cache("Caption"), System.Data.DataTable)
            hdnSelect.Value = dtCaption.Select("TAG='select'")(0)(1)
        End If
    End Sub
    Private Function fnDecryptQString(ByVal strEncrypted As String) As String
        'Encryption
        Dim objEncryption As New Encryption64
        If Request.QueryString(strEncrypted) Is Nothing Or Request.QueryString(strEncrypted) = "" Then Return Nothing
        Return objEncryption.Decrypt(Request.QueryString(strEncrypted).ToString.Replace(" ", "+"), ConfigurationManager.AppSettings.Get("encKey"))
    End Function
    <WebMethod()> _
    Public Shared Function LoadOrdTypes() As WOHeaderBO()
        Try
            details = objWOHeaderServ.Fetch_WOH_OrderTypes()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWoHead", "LoadOrdTypes", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function LoadPayTypes() As WOHeaderBO()
        Try
            details = objWOHeaderServ.Fetch_WOH_PayTypes()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWoHead", "LoadPayTypes", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function LoadPayTerms() As WOHeaderBO()
        Try
            details = objWOHeaderServ.Fetch_WOH_Pay_Terms()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWoHead", "LoadPayTerms", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function LoadOrdStatus(ByVal OrderType As String) As WOHeaderBO()
        Dim ScreenName As String
        Try
            ScreenName = "frmWOHead.aspx" 'HttpContext.Current.Session("screenName")
            details = objWOHeaderServ.Fetch_WOH_OrderStatus(OrderType, screenName)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWoHead", "LoadOrdStatus", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function FillOrdStatus(ByVal ordType As String) As WOHeaderBO()
        Dim ScreenName As String
        Try
            ScreenName = "frmWOHead.aspx" 'HttpContext.Current.Session("screenName")
            details = objWOHeaderServ.FetchWOStatus(ordType, ScreenName)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWoHead", "LoadOrdStatus", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function LoadCustGroup() As WOHeaderBO()
        Try
            details = objWOHeaderServ.Fetch_WOH_Cust_Group()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWoHead", "LoadCustGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function LoadVehMake() As WOHeaderBO()
        Try
            details = objWOHeaderServ.Fetch_WOH_Veh_Make()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWoHead", "LoadVehMake", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function LoadModel() As WOHeaderBO()
        Try
            details = objWOHeaderServ.LoadModel()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWoHead", "LoadVehMake", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function LoadVehModel(ByVal IdMake As String) As WOHeaderBO()
        Try
            objWOHeaderBO.Id_Make = IdMake
            details = objWOHeaderServ.Fetch_Veh_Model(objWOHeaderBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWoHead", "LoadVehModel", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function LoadAllModel() As WOHeaderBO()
        Try

            details = objWOHeaderServ.Load_All_Model()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWoHead", "LoadVehModel", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function LoadCustDet(ByVal IdCustomer As String) As WOHeaderBO()
        Try
            objWOHeaderBO.Id_Cust_Wo = IdCustomer
            HttpContext.Current.Session("IdCustomer") = IdCustomer
            details = objWOHeaderServ.Fetch_WOH_Cust_Details(objWOHeaderBO.Id_Cust_Wo)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWoHead", "LoadCustDet", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function LoadVehDrpdwn(ByVal IdCustomer As String) As WOHeaderBO()
        Try
            objWOHeaderBO.Id_Cust_Wo = IdCustomer
            details = objWOHeaderServ.Fetch_Veh_Det(IdCustomer)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWoHead", "LoadVehDrpdwn", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function LoadVehDet(ByVal VehicleId As String) As WOHeaderBO()
        Try
            objWOHeaderBO.Id_Veh_Seq_WO = VehicleId
            details = objWOHeaderServ.Fetch_WOH_Vehicle(VehicleId)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWoHead", "LoadVehDet", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function FetchWODetails(ByVal WoNo As String, ByVal WoPr As String) As WOHeaderBO()
        Try
            objWOHeaderBO.Id_WO_NO = WoNo
            objWOHeaderBO.Id_WO_Prefix = WoPr
            details = objWOHeaderServ.Fetch_WOH_WoNodetails(objWOHeaderBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWoHead", "FetchWODetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function GetCustomer(ByVal custName As String) As List(Of String)

        Dim retCustomer As New List(Of String)()
        Dim dsCustomer As New DataSet
        Dim dtCustomer As New DataTable
        Try
            If (custName.Length >= 3) Then
                HttpContext.Current.Session("IdCustomer") = custName
                retCustomer = objServCustomer.GetCustomer(custName)
            End If
        Catch exth As System.Threading.ThreadAbortException
            Throw exth
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWoHead", "GetCustomer", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return retCustomer
    End Function
    <WebMethod()> _
    Public Shared Function GetVehicle(ByVal vehicleRegNo As String) As List(Of String)
        Dim retVehicle As New List(Of String)()
        Dim dsVehicle As New DataSet
        Dim dtVehicle As New DataTable
        Try
            retVehicle = objServVehicle.GetVehicle(vehicleRegNo)

        Catch exth As System.Threading.ThreadAbortException
            Throw exth
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "VehicleDO", "getVehicle", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, "pv45")
        End Try
        Return retVehicle
    End Function
    <WebMethod()> _
    Public Shared Function SaveOrderDetails(ByVal custID As String, ByVal Id_Wo_No As String, ByVal ordDt As String, ByVal woType As String, ByVal woStatus As String, ByVal Wo_Tm_Deliv As String, ByVal delivDate As String, ByVal finishDate As String, ByVal payType As String, ByVal payTerms As String, ByVal custPermAddr1 As String, ByVal custPermAddr2 As String, _
                                            ByVal zipCode As String, ByVal custOffPh As String, ByVal custHmPh As String, ByVal idVehSeq As String, ByVal vehRegNo As String, ByVal annotation As String, ByVal custName As String, ByVal custMob As String, ByVal vehInterNo As String, ByVal vehVin As String, ByVal updVehFlag As String, ByVal vehMileage As String, _
                                            ByVal vehHrs As String, ByVal country As String, ByVal state As String, ByVal vehMake As String, ByVal vehModel As String, ByVal custGrp As String, ByVal vehGrpDesc As String, ByVal VACostPrice As String, ByVal VASellPrice As String, ByVal VANum As String, ByVal IntNote As String, ByVal DeptAccNum As String) As WOHeaderBO()
        Try
            Dim VACostPr, VASellPr As String
            'VACostPr = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(VACostPrice = "", "", VACostPrice))
            'VASellPr = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(VASellPrice = "", "", VASellPrice))
            VACostPr = 0
            VASellPr = 0
            If vehInterNo = "0" Then
                vehInterNo = ""
            End If
            If vehVin = "0" Then
                vehVin = ""
            End If
            objWOHeaderBO.Id_Cust_Wo = custID
            HttpContext.Current.Session("IdCustomer") = custID
            objWOHeaderBO.Id_WO_NO = Id_Wo_No
            objWOHeaderBO.Dt_Order = ordDt
            objWOHeaderBO.Dt_Order = objCommonUtil.GetDefaultDate_MMDDYYYY(ordDt)
            objWOHeaderBO.WO_Type = woType
            HttpContext.Current.Session("WO_Type") = woType
            objWOHeaderBO.WO_Status = woStatus
            objWOHeaderBO.WO_Tm_Deliv = Wo_Tm_Deliv
            Dim deliveryDate As String = objCommonUtil.GetCurrentLanguageDate(delivDate)
            Dim fDate As String = objCommonUtil.GetCurrentLanguageDate(finishDate)
            objWOHeaderBO.Dt_Delivery = objCommonUtil.GetDefaultDate_MMDDYYYY(deliveryDate)
            objWOHeaderBO.Dt_Finish = objCommonUtil.GetDefaultDate_MMDDYYYY(fDate)
            objWOHeaderBO.Created_By = HttpContext.Current.Session("UserID")
            objWOHeaderBO.Id_Pay_Type_WO = payType
            objWOHeaderBO.Id_Pay_Terms_WO = payTerms
            objWOHeaderBO.WO_Cust_Add1 = custPermAddr1
            objWOHeaderBO.Cust_Perm_Add2 = custPermAddr2
            objWOHeaderBO.Id_Zipcode_WO = zipCode
            objWOHeaderBO.WO_Cust_Phone_Off = custOffPh
            objWOHeaderBO.WO_Cust_Phone_Home = custHmPh
            objWOHeaderBO.WO_Cust_Phone_Mobile = custMob
            objWOHeaderBO.Id_Veh_Seq_WO = IIf(idVehSeq = "", "0", idVehSeq)
            objWOHeaderBO.WO_Veh_Reg_NO = IIf(vehRegNo = "", "%", vehRegNo)
            objWOHeaderBO.WO_Annot = annotation
            objWOHeaderBO.WO_Cust_Name = custName
            objWOHeaderBO.WO_Veh_ERN_NO = IIf(vehInterNo = "", "%", vehInterNo)
            objWOHeaderBO.WO_Veh_Vin = IIf(vehVin = "", "%", vehVin)
            objWOHeaderBO.Veh_Update_flag = updVehFlag
            objWOHeaderBO.WO_Veh_Mileage = IIf(vehMileage = "", "0", vehMileage)
            objWOHeaderBO.WO_Veh_Hrs = IIf(vehHrs = "", "0", vehHrs)
            objWOHeaderBO.PCountry = country
            objWOHeaderBO.PState = state
            objWOHeaderBO.Veh_Make = vehMake
            objWOHeaderBO.Id_Model = vehModel
            objWOHeaderBO.Cust_Group = custGrp
            objWOHeaderBO.Veh_Grpdesc = vehGrpDesc
            objWOHeaderBO.Dept_Accnt_Num = DeptAccNum
            objWOHeaderBO.VA_Cost_Price = Convert.ToDecimal(VACostPr)
            objWOHeaderBO.VA_Sell_Price = Convert.ToDecimal(VASellPr)
            objWOHeaderBO.Van_Num = VANum
            objWOHeaderBO.Int_Note = IntNote
            objWOHeaderBO.Regn_Date = ""
            objWOHeaderBO.WO_Annot = annotation

            details = objWOHeaderServ.AddWOHeader(objWOHeaderBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWoHead", "SaveRoleDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function UpdateOrderDetails(ByVal custID As String, ByVal Id_Wo_No As String, ByVal ordDt As String, ByVal woType As String, ByVal woStatus As String, ByVal Wo_Tm_Deliv As String, ByVal delivDate As String, ByVal finishDate As String, ByVal payType As String, ByVal payTerms As String, ByVal custPermAddr1 As String, ByVal custPermAddr2 As String, _
                                            ByVal zipCode As String, ByVal custOffPh As String, ByVal custHmPh As String, ByVal idVehSeq As String, ByVal vehRegNo As String, ByVal annotation As String, ByVal custName As String, ByVal custMob As String, ByVal vehInterNo As String, ByVal vehVin As String, ByVal updVehFlag As String, ByVal vehMileage As String, _
                                            ByVal vehHrs As String, ByVal country As String, ByVal state As String, ByVal vehMake As String, ByVal vehModel As String, ByVal custGrp As String, ByVal vehGrpDesc As String, ByVal VACostPrice As String, ByVal VASellPrice As String, ByVal VANum As String, ByVal IntNote As String, ByVal DeptAccNum As String) As WOHeaderBO()

        Try
            Dim VACostPr, VASellPr, Id_Wo_Pr As String
            Id_Wo_No = HttpContext.Current.Session("WONO")
            Id_Wo_Pr = HttpContext.Current.Session("WOPR")
            ''VACostPr = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(VACostPrice = "", "", VACostPrice))
            ''VASellPr = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(VASellPrice = "", "", VASellPrice))
            VACostPr = 0
            VASellPr = 0
            If vehInterNo = "0" Then
                vehInterNo = ""
            End If
            If vehVin = "0" Then
                vehVin = ""
            End If
            objWOHeaderBO.Id_Cust_Wo = custID
            HttpContext.Current.Session("IdCustomer") = custID
            objWOHeaderBO.Id_WO_NO = Id_Wo_No
            objWOHeaderBO.Dt_Order = ordDt
            objWOHeaderBO.Dt_Order = objCommonUtil.GetDefaultDate_MMDDYYYY(ordDt)
            objWOHeaderBO.WO_Type = woType
            HttpContext.Current.Session("WO_Type") = woType
            objWOHeaderBO.WO_Status = woStatus
            objWOHeaderBO.WO_Tm_Deliv = Wo_Tm_Deliv
            Dim deliveryDate As String = objCommonUtil.GetCurrentLanguageDate(delivDate)
            Dim fDate As String = objCommonUtil.GetCurrentLanguageDate(finishDate)
            objWOHeaderBO.Dt_Delivery = objCommonUtil.GetDefaultDate_MMDDYYYY(deliveryDate)
            objWOHeaderBO.Dt_Finish = objCommonUtil.GetDefaultDate_MMDDYYYY(fDate)
            objWOHeaderBO.Created_By = HttpContext.Current.Session("UserID")
            objWOHeaderBO.Id_Pay_Type_WO = payType
            objWOHeaderBO.Id_Pay_Terms_WO = payTerms
            objWOHeaderBO.WO_Cust_Add1 = custPermAddr1
            objWOHeaderBO.Cust_Perm_Add2 = custPermAddr2
            objWOHeaderBO.Id_Zipcode_WO = zipCode
            objWOHeaderBO.WO_Cust_Phone_Off = custOffPh
            objWOHeaderBO.WO_Cust_Phone_Home = custHmPh
            objWOHeaderBO.WO_Cust_Phone_Mobile = custMob
            objWOHeaderBO.Id_Veh_Seq_WO = IIf(idVehSeq = "", "0", idVehSeq)
            objWOHeaderBO.WO_Veh_Reg_NO = IIf(vehRegNo = "", "%", vehRegNo)
            objWOHeaderBO.WO_Annot = annotation
            objWOHeaderBO.WO_Cust_Name = custName
            objWOHeaderBO.WO_Veh_ERN_NO = IIf(vehInterNo = "", "%", vehInterNo)
            objWOHeaderBO.WO_Veh_Vin = IIf(vehVin = "", "%", vehVin)
            objWOHeaderBO.Veh_Update_flag = updVehFlag
            objWOHeaderBO.WO_Veh_Mileage = IIf(vehMileage = "", "0", vehMileage)
            objWOHeaderBO.WO_Veh_Hrs = IIf(vehHrs = "", "0", vehHrs)
            objWOHeaderBO.PCountry = country
            objWOHeaderBO.PState = state
            objWOHeaderBO.Id_WO_Prefix = Id_Wo_Pr
            objWOHeaderBO.Veh_Make = vehMake
            objWOHeaderBO.Id_Model = vehModel
            objWOHeaderBO.Cust_Group = custGrp
            objWOHeaderBO.Veh_Grpdesc = vehGrpDesc
            objWOHeaderBO.Dept_Accnt_Num = DeptAccNum
            objWOHeaderBO.VA_Cost_Price = Convert.ToDecimal(VACostPr)
            objWOHeaderBO.VA_Sell_Price = Convert.ToDecimal(VASellPr)
            objWOHeaderBO.Van_Num = VANum
            objWOHeaderBO.Int_Note = IntNote
            objWOHeaderBO.Regn_Date = ""
            objWOHeaderBO.WO_Annot = annotation
            details = objWOHeaderServ.UpdateWOHeader(objWOHeaderBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWoHead", "UpdateOrderDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    Private Sub btnPickingList_ServerClick(sender As Object, e As EventArgs) Handles btnPickingList.ServerClick
        Try
            Dim rnd As New Random
            Dim orderType As String = "ORDER"
            'HttpContext.Current.Session("WONO") = 56820
            'HttpContext.Current.Session("WOPR") = "V23"
            HttpContext.Current.Session("WOHeadPickingList") = Nothing

            Dim strScript As String = "var windowPickingRpt =window.open('../Reports/frmShowReports.aspx?ReportHeader=" + fnEncryptQString("WOHEADPICKINGLIST") + "&Rpt=" + fnEncryptQString("WOHEADPICKINGLIST") + "&OrderType=" + fnEncryptQString(orderType) + "&scrid=" + rnd.Next().ToString() + "','Reports','menubar=no,location=no,status=no,scrollbars=yes,resizable=yes');windowPickingRpt.focus();"
            ClientScript.RegisterStartupScript(Me.GetType(), "Open", strScript, True)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWoHead", "btnPickingList_ServerClick", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub
    Private Sub btnReport_ServerClick(sender As Object, e As EventArgs) Handles btnReport.ServerClick
        Try
            Dim rnd As New Random
            If Not HttpContext.Current.Session("WONO") Is Nothing Then
                Dim strJobCardSettings As String = "1"
                Dim sWOXML As String = String.Empty
                If Not IsDBNull(Session("WONO")) And Not IsDBNull(Session("WOPR")) Then
                    sWOXML = "<ROOT><WONOPREFIX  ID_WO_PREFIX='" + objCommonUtil.ConvertStr(HttpContext.Current.Session("WOPR").ToString()) + "'  ID_WO_NO='" + objCommonUtil.ConvertStr(HttpContext.Current.Session("WONO").ToString()) + "'/><ID_INV_NO ID_INV_NO='" + objCommonUtil.ConvertStr(HttpContext.Current.Session("WOPR").ToString()) + objCommonUtil.ConvertStr(HttpContext.Current.Session("WONO").ToString()) + "' FLG_INVORCN='FALSE' /></ROOT>"
                End If
                If Not String.IsNullOrEmpty(sWOXML) Then
                    Session("xmlInvNos") = sWOXML
                    Session("RptType") = "WOJobCard"
                    Dim strScript As String = "var win=window.open('../Reports/frmShowReports.aspx?ReportHeader=" + fnEncryptQString("WOJobCard") + "&InvoiceType=" + fnEncryptQString("WOJobCard") + "&Rpt=" + fnEncryptQString("INVOICEPRINT") + "&scrid=" + objCommonUtil.ConvertStr(Session("WOPR").ToString()) + objCommonUtil.ConvertStr(Session("WONO").ToString()) + "&JobCardSett=" + strJobCardSettings.ToString.Trim + "','Reports','menubar=no,location=no,status=no,scrollbars=yes,resizable=yes');win.focus();"
                    ClientScript.RegisterStartupScript(Me.GetType(), "Open", strScript, True)
                End If
            End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWoHead", "btnReport_ServerClick", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub
    Private Sub btnProposal_ServerClick(sender As Object, e As EventArgs) Handles btnProposal.ServerClick
        Try
            Dim rnd As New Random
            If Not HttpContext.Current.Session("WONO") Is Nothing Then
                Dim sWOXML As String = String.Empty
                If Not IsDBNull(Session("WONO")) And Not IsDBNull(Session("WOPR")) Then
                    sWOXML = "<ROOT><WONOPREFIX  ID_WO_PREFIX='" + objCommonUtil.ConvertStr(HttpContext.Current.Session("WOPR").ToString()) + "'  ID_WO_NO='" + objCommonUtil.ConvertStr(HttpContext.Current.Session("WONO").ToString()) + "'/><ID_INV_NO ID_INV_NO='" + objCommonUtil.ConvertStr(HttpContext.Current.Session("WOPR").ToString()) + objCommonUtil.ConvertStr(HttpContext.Current.Session("WONO").ToString()) + "' FLG_INVORCN='FALSE' /></ROOT>"
                End If
                If Not String.IsNullOrEmpty(sWOXML) Then
                    Session("xmlInvNos") = sWOXML
                    Session("RptType") = "Proposal"
                    Dim strScript As String = "var win=window.open('../Reports/frmShowReports.aspx?ReportHeader=" + fnEncryptQString("Proposal") + "&InvoiceType=" + fnEncryptQString("Proposal") + "&Rpt=" + fnEncryptQString("INVOICEPRINT") + "&scrid=" + rnd.Next().ToString() + "','Reports','menubar=no,location=no,status=no,scrollbars=yes,resizable=yes');win.focus();"
                    ClientScript.RegisterStartupScript(Me.GetType(), "Open", strScript, True)
                End If
            End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWoHead", "btnProposal_ServerClick", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub
    Private Sub btnConfirmation_ServerClick(sender As Object, e As EventArgs) Handles btnConfirmation.ServerClick
        Try
            Dim rnd As New Random
            If Not HttpContext.Current.Session("WONO") Is Nothing Then
                Dim sWOXML As String = String.Empty
                If Not IsDBNull(Session("WONO")) And Not IsDBNull(Session("WOPR")) Then
                    sWOXML = "<ROOT><WONOPREFIX  ID_WO_PREFIX='" + objCommonUtil.ConvertStr(HttpContext.Current.Session("WOPR").ToString()) + "'  ID_WO_NO='" + objCommonUtil.ConvertStr(HttpContext.Current.Session("WONO").ToString()) + "'/><ID_INV_NO ID_INV_NO='" + objCommonUtil.ConvertStr(HttpContext.Current.Session("WOPR").ToString()) + objCommonUtil.ConvertStr(HttpContext.Current.Session("WONO").ToString()) + "' FLG_INVORCN='FALSE' /></ROOT>"
                End If
                If Not String.IsNullOrEmpty(sWOXML) Then
                    Session("xmlInvNos") = sWOXML
                    Session("RptType") = "OrderConfirmation"
                    ' Dim strScript As String = "var win=window.open('../Reports/frmShowReports.aspx?ReportHeader=" + fnEncryptQString("Proposal") + "&InvoiceType=" + fnEncryptQString("Proposal") + "&Rpt=" + fnEncryptQString("INVOICEPRINT") + "&scrid=" + rnd.Next().ToString() + "','Reports','menubar=no,location=no,status=no,scrollbars=yes,resizable=yes');win.focus();"
                    Dim strScript As String = "var win=window.open('../Reports/frmShowReports.aspx?ReportHeader=" + fnEncryptQString("Order Confirmation") + "&InvoiceType=" + fnEncryptQString("OrderConfirmation") + "&Rpt=" + fnEncryptQString("INVOICEPRINT") + "&scrid=" + rnd.Next().ToString() + "','Reports','menubar=no,location=no,status=no,scrollbars=yes,resizable=yes');win.focus();"
                    ClientScript.RegisterStartupScript(Me.GetType(), "Open", strScript, True)
                End If
            End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWoHead", "btnConfirmation_ServerClick", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub
    Private Function fnEncryptQString(ByVal strEncrypted As String) As String
        'Encryption
        Dim objEncryption As New Encryption64
        If strEncrypted Is Nothing Then Return ""
        Return objEncryption.Encrypt(strEncrypted, ConfigurationManager.AppSettings.Get("encKey"))
    End Function
    <WebMethod()> _
    Public Shared Function Fetch_WOHeader(ByVal idWONO As String, ByVal idWOPrefix As String, ByVal userId As String) As WOHeaderBO()
        Try
            objWOHeaderBO.Id_WO_NO = idWONO
            objWOHeaderBO.Id_WO_Prefix = idWOPrefix
            objWOHeaderBO.Created_By = loginName
            details = objWOHeaderServ.Fetch_WOH_OrderJobs(objWOHeaderBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWoHead", "Fetch_WOHeader", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function CreditLimit_Customer(ByVal idCust As String) As String
        Dim strVal As String
        Try
            objWOHeaderBO.Id_Cust_Wo = idCust
            strVal = objWOHeaderServ.CreditLimit_Customer(objWOHeaderBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWoHead", "Fetch_WOHeader", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strVal
    End Function
    <WebMethod()> _
    Public Shared Function Fetch_MechGrid(ByVal idWONO As String, ByVal idWOPrefix As String, ByVal userId As String) As WOHeaderBO()
        Try
            objWOHeaderBO.Id_WO_NO = idWONO
            objWOHeaderBO.Id_WO_Prefix = idWOPrefix
            objWOHeaderBO.Created_By = userId
            details = objWOHeaderServ.Fetch_WOH_MechGrid(objWOHeaderBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWoHead", "Fetch_MechGrid", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function DeleteJob(ByVal jobIdXmls As String) As String()
        Dim strResult As String()
        Try
            objWOHeaderBO.Id_WO_NO = jobIdXmls.ToString()
            strResult = objWOHeaderServ.Delete_Job(objWOHeaderBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWoHead", "DeleteDepartment", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
    <WebMethod()> _
    Public Shared Function LoadNonInvoiceOrderDet(ByVal idCust As String, ByVal idUser As String) As WOHeaderBO()
        Try
            objWOHeaderBO.Id_Cust_Wo = idCust
            objWOHeaderBO.Created_By = idUser
            objWOHeaderBO.PageIndex = 1
            objWOHeaderBO.PageSize = System.Configuration.ConfigurationManager.AppSettings("PageSize").ToString()
            details = objWOHeaderServ.Fetch_NonInvoiced_Orders(objWOHeaderBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWoHead", "LoadNonInvoiceOrderDet", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function FillPaymentDet(ByVal IdCustGrp As String) As WOHeaderBO()
        Try
            objWOHeaderBO.Id_Cust_Group_Seq = IdCustGrp
            details = objWOHeaderServ.Fetch_WOH_Payment_Details(objWOHeaderBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWoHead", "FillPaymentDet", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()>
    Public Shared Function ValidateVehicle(ByVal IdVehicle As String) As String
        Dim strVal As String
        Try
            objWOHeaderBO.WO_Veh_Reg_NO = IdVehicle
            strVal = objWOHeaderServ.Vehicle_Check(objWOHeaderBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWoHead", "FillPaymentDet", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strVal
    End Function
    <WebMethod()>
    Public Shared Function ValidateCustomer(ByVal IdCustomer As String) As String
        Dim strVal As String
        Try
            objWOHeaderBO.Cust_ID = IdCustomer
            strVal = objWOHeaderServ.Customer_Check(objWOHeaderBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWoHead", "FillPaymentDet", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strVal
    End Function
    <WebMethod()> _
    Public Shared Function Fetch_DefectNote(ByVal idVeh As String) As String
        Dim strVal As String
        Try
            objWOHeaderBO.Id_Veh_Seq_WO = idVeh
            strVal = objWOHeaderServ.Fetch_DefectNote(objWOHeaderBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWoHead", "FillPaymentDet", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strVal
    End Function
    <WebMethod()> _
    Public Shared Function checkJobNo(ByVal WoNo As String, ByVal WoPr As String, ByVal IdJob As String) As String
        Dim strVal As String
        Try
            objWOHeaderBO.Id_WO_NO = WoNo
            objWOHeaderBO.Id_WO_Prefix = WoPr
            objWOHeaderBO.Id_Job = IdJob
            HttpContext.Current.Session("IdJob") = IdJob
            strVal = objWOHeaderServ.checkJobNo(objWOHeaderBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWoHead", "checkJobNo", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strVal
    End Function
    <WebMethod()> _
    Public Shared Function GetZipCodes(ByVal zipCode As String) As List(Of String)
        Dim retZipCodes As New List(Of String)()
        Try
            retZipCodes = objCommonUtil.getZipCodes(zipCode, loginName)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWoHead", "GetZipCodes", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return retZipCodes
    End Function
    Public Sub fnRolebasedAuth()
        Try
            Dim ds As New DataTable
            Dim str As String
            Dim objLoginBo As New LoginBO
            ds = Session("UserPageperDT")
            If Not ds Is Nothing Then
                str = Request.Url.AbsolutePath
                'str = str.Substring((Application("AppPath")).ToString().Length)
                str = "/Transactions/frmWOHead.aspx?TabId=2"
                objuserper = objCommonUtil.GetUserScrPer(ds, str)
                If objuserper.PF_ACC_VIEW = True Then
                    btnDeleteJob.Disabled = Convert.ToBoolean(IIf(btnDeleteJob.Disabled = False, IIf(objuserper.PF_ACC_DELETE = True, False, True), True))
                    btnSaveOrder.Disabled = Convert.ToBoolean(IIf(btnSaveOrder.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnUpdate.Disabled = Convert.ToBoolean(IIf(btnUpdate.Disabled = False, IIf(objuserper.PF_ACC_EDIT = True, False, True), True))
                    btnAddJob.Disabled = Convert.ToBoolean(IIf(btnAddJob.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnReport.Disabled = Convert.ToBoolean(IIf(btnReport.Disabled = False, IIf(objuserper.PF_ACC_PRINT = True, False, True), True))
                    btnPickingList.Disabled = Convert.ToBoolean(IIf(btnPickingList.Disabled = False, IIf(objuserper.PF_ACC_PRINT = True, False, True), True))
                    btnConfirmation.Disabled = Convert.ToBoolean(IIf(btnConfirmation.Disabled = False, IIf(objuserper.PF_ACC_PRINT = True, False, True), True))
                    btnProposal.Disabled = Convert.ToBoolean(IIf(btnProposal.Disabled = False, IIf(objuserper.PF_ACC_PRINT = True, False, True), True))
                End If
            End If
        Catch exth As System.Threading.ThreadAbortException
            Throw exth
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWOHead", "fnRolebasedAuth", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, Session("UserId"))
            'Throw ex
        End Try
    End Sub
End Class