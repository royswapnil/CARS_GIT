Imports System.Web.Services
Imports CARS.CoreLibrary
Imports CARS.CoreLibrary.CARS
Imports System.Web.Security
Imports System.Web.UI
Imports Encryption
Imports System.Math
Imports Newtonsoft.Json
Imports System.Reflection
Public Class frmCfCustomer
    Inherits System.Web.UI.Page
    Shared commonUtil As New Utilities.CommonUtility
    Shared loginName As String
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared dtCaption As DataTable
    Shared objCustSrv As New Services.ConfigCustomer.ConfigCustomer
    Shared details As New List(Of ConfigCustomerBO)()
    Shared objCommonUtil As New Utilities.CommonUtility
    Shared objCustConfigBO As New CARS.CoreLibrary.ConfigCustomerBO
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim strscreenName As String
        If Session("UserID") Is Nothing Or Session("UserPageperDT") Is Nothing Then
            Response.Redirect("~/frmLogin.aspx")
        Else
            loginName = CType(Session("UserID"), String)
        End If
        hdnPageSize.Value = System.Configuration.ConfigurationManager.AppSettings("PageSize")
        If Not IsPostBack Then
            dtCaption = DirectCast(Cache("Caption"), System.Data.DataTable)
            hdnSelect.Value = dtCaption.Select("TAG='select'")(0)(1)
            strscreenName = IO.Path.GetFileName(Me.Request.PhysicalPath)
        End If
        strscreenName = IO.Path.GetFileName(Me.Request.PhysicalPath)
    End Sub
    <WebMethod()> _
    Public Shared Function Fetch_Config() As Collection
        Dim dtConfig As New Collection
        Try
            Dim userId = loginName
            dtConfig = objCustSrv.Fetch_ConfigDetails(userId)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfCustomer", "Fetch_Config", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return dtConfig
    End Function
    <WebMethod()> _
    Public Shared Function SaveRegionConfig(ByVal IdSett As String, ByVal desc As String, ByVal mode As String) As ConfigCustomerBO()
        Try

            Dim IdLogin As String = loginName
            If mode = "Edit" Then
                Dim strxmlUpd As String = ""
                Dim strxmlUpdPay As String = ""
                Dim strxmlUpdGrp As String = ""
                Dim strxmlUpdGM As String = ""
                strxmlUpd = "<MODIFY ID_CONFIG=""REG"" ID_SETTINGS=""" + IdSett + """ DESCRIPTION=""" + desc + """  />"
                strxmlUpd = "<ROOT>" + strxmlUpd + "</ROOT>"
                strxmlUpdPay = "<ROOT></ROOT>"
                strxmlUpdGrp = "<ROOT></ROOT>"
                strxmlUpdGM = "<ROOT></ROOT>"
                details = objCustSrv.UpdateCustRegConfig(strxmlUpd, strxmlUpdPay, strxmlUpdGrp, strxmlUpdGM, IdLogin)
            Else
                Dim strXMLSettingsInsert = ""
                strXMLSettingsInsert = "<insert  ID_CONFIG=""REG"" DESCRIPTION=""" + desc + """   />"
                strXMLSettingsInsert = "<root>" + strXMLSettingsInsert + "</root>"
                details = objCustSrv.SaveCustRegConfig(strXMLSettingsInsert, IdLogin)
            End If

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfCustomer", "SaveRegionConfig", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function SavePayConfig(ByVal IdSett As String, ByVal payCode As String, ByVal payTerms As String, ByVal payDesc As String, ByVal freemonth As String, ByVal mode As String) As ConfigCustomerBO()
        Try
           

            Dim IdLogin As String = loginName
            If mode = "Edit" Then
                Dim strxmlUpd As String = ""
                Dim strxmlUpdPay As String = ""
                Dim strxmlUpdGrp As String = ""
                Dim strxmlUpdGM As String = ""
                strxmlUpdPay = "<MODIFY ID_SETTINGS=""" + IdSett + """ PAY_CODE=""" + payCode + """ TERMS=""" + payTerms + """ FREEMONTH=""" + freemonth + """ DESCRIPTION=""" + payDesc + """  />"
                strxmlUpdPay = "<ROOT>" + strxmlUpdPay + "</ROOT>"
                strxmlUpd = "<ROOT></ROOT>"
                strxmlUpdGrp = "<ROOT></ROOT>"
                strxmlUpdGM = "<ROOT></ROOT>"
                details = objCustSrv.UpdateCustPayConfig(strxmlUpd, strxmlUpdPay, strxmlUpdGrp, strxmlUpdGM, IdLogin)
            Else
                Dim strXMLSettingsInsert = ""
                strXMLSettingsInsert = "<INSERT  PAY_CODE=""" + payCode + """ TERMS=""" + payTerms + """ FREEMONTH=""true"" DESCRIPTION=""" + payDesc + """   />"
                strXMLSettingsInsert = "<ROOT>" + strXMLSettingsInsert + "</ROOT>"
                details = objCustSrv.SaveCustPayConfig(strXMLSettingsInsert, IdLogin)
            End If

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfCustomer", "SaveRegionConfig", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function SaveCustGrpConfig(ByVal IdSett As String, ByVal idCustGrp As String, ByVal idPrCode As String, ByVal payTypeDesc As String, _
    ByVal payTerms As String, ByVal vatCode As String, ByVal discCode As String, ByVal custAccCode As String, ByVal desc As String, ByVal useIntCust As String, ByVal curr As String, ByVal mode As String) As ConfigCustomerBO()
        Try

            Dim IdLogin As String = loginName
            If idPrCode = "0" Then
                idPrCode = ""
            End If
            If payTypeDesc = "0" Then
                payTypeDesc = ""
            End If
            If payTerms = "0" Then
                payTerms = ""
            End If
            If vatCode = "0" Then
                vatCode = ""
            End If
            If discCode = "0" Then
                discCode = ""
            End If
            If curr = "0" Then
                curr = ""
            End If
            If mode = "Edit" Then
                Dim strxmlUpd As String = ""
                Dim strxmlUpdPay As String = ""
                Dim strxmlUpdGrp As String = ""
                Dim strxmlUpdGM As String = ""
                strxmlUpdGrp = "<MODIFY  ID_SETTINGS=""" + IdSett + """ CUSG_DESCRIPTION=""" + idCustGrp + """ ID_PRICE_CD=""" + idPrCode + """  PAYTYPE_DESC=""" + payTypeDesc + """ ID_PAY_TERM=""" + payTerms + """ VAT_CD=""" + vatCode + """ DISC_CD=""" + discCode + """ Cust_AccCode=""" + custAccCode + """ DESCRIPTION=""" + desc + """ PAY_CURR=""" + curr + """ USE_INTCUST=""" + useIntCust + """   />"
                strxmlUpdGrp = "<ROOT>" + strxmlUpdGrp + "</ROOT>"
                strxmlUpd = "<ROOT></ROOT>"
                strxmlUpdPay = "<ROOT></ROOT>"
                strxmlUpdGM = "<ROOT></ROOT>"
                details = objCustSrv.UpdateCustPayConfig(strxmlUpd, strxmlUpdPay, strxmlUpdGrp, strxmlUpdGM, IdLogin)
            Else
                Dim strXMLSettingsInsert = ""
                strXMLSettingsInsert = "<INSERT  CUSG_DESCRIPTION=""" + idCustGrp + """ ID_PRICE_CD=""" + idPrCode + """  PAYTYPE_DESC=""" + payTypeDesc + """ ID_PAY_TERM=""" + payTerms + """ VAT_CD=""" + vatCode + """ DISC_CD=""" + discCode + """ Cust_AccCode=""" + custAccCode + """ DESCRIPTION=""" + desc + """ PAY_CURR=""" + curr + """ USE_INTCUST=""" + useIntCust + """   />"
                strXMLSettingsInsert = "<ROOT>" + strXMLSettingsInsert + "</ROOT>"
                details = objCustSrv.SaveCustGrpConfig(strXMLSettingsInsert, IdLogin)
            End If

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfCustomer", "SaveRegionConfig", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function SaveWarningConfig(ByVal IdSett As String, ByVal warnText As String, ByVal mode As String) As ConfigCustomerBO()
        Try

            Dim IdLogin As String = loginName
            If mode = "Edit" Then
                Dim strxmlUpd As String = ""
                Dim strxmlUpdPay As String = ""
                Dim strxmlUpdGrp As String = ""
                Dim strxmlUpdGM As String = ""
                strxmlUpd = "<MODIFY ID_CONFIG=""CU-WARN"" ID_SETTINGS=""" + IdSett + """ DESCRIPTION=""" + warnText + """  />"
                strxmlUpd = "<ROOT>" + strxmlUpd + "</ROOT>"
                strxmlUpdPay = "<ROOT></ROOT>"
                strxmlUpdGrp = "<ROOT></ROOT>"
                strxmlUpdGM = "<ROOT></ROOT>"
                details = objCustSrv.UpdateCustRegConfig(strxmlUpd, strxmlUpdPay, strxmlUpdGrp, strxmlUpdGM, IdLogin)
            Else
                Dim strXMLSettingsInsert = ""
                strXMLSettingsInsert = "<insert  ID_CONFIG=""CU-WARN"" DESCRIPTION=""" + warnText + """   />"
                strXMLSettingsInsert = "<root>" + strXMLSettingsInsert + "</root>"
                details = objCustSrv.SaveWarningConfig(strXMLSettingsInsert, IdLogin)
            End If

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfCustomer", "SaveRegionConfig", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function SaveGMPrice(ByVal IdSett As String, ByVal idDept As String, ByVal idCustGrpSeq As String, ByVal GMPercent As String, _
    ByVal GMDesc As String, ByVal vatCode As String, ByVal accCode As String, ByVal mode As String) As ConfigCustomerBO()
        Try
            Dim GMPricePer As String = ""
            GMPricePer = objCommonUtil.ConvertStr(objCommonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), objCommonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), GMPercent)))
            Dim IdLogin As String = loginName
            If mode = "Edit" Then
                Dim strxmlUpd As String = ""
                Dim strxmlUpdPay As String = ""
                Dim strxmlUpdGrp As String = ""
                Dim strxmlUpdGM As String = ""
                strxmlUpdGM = "<MODIFY GM_PRICE_SEQ=""" + IdSett + """ ID_DEPT=""" + idDept + """ ID_CUST_GRP_SEQ=""" + idCustGrpSeq + """  GARAGE_PRICE_PER=""" + GMPricePer + """ GP_DESCRIPTION=""" + GMDesc + """  ID_VAT=""" + vatCode + """ GP_ACCCODE=""" + accCode + """ />"""""
                strxmlUpdGM = "<ROOT>" + strxmlUpdGM + "</ROOT>"
                strxmlUpdPay = "<ROOT></ROOT>"
                strxmlUpdGrp = "<ROOT></ROOT>"
                strxmlUpd = "<ROOT></ROOT>"
                details = objCustSrv.UpdateCustRegConfig(strxmlUpd, strxmlUpdPay, strxmlUpdGrp, strxmlUpdGM, IdLogin)
            Else
                Dim strXMLSettingsInsert = ""
                strXMLSettingsInsert = "<INSERT  ID_DEPT=""" + idDept + """ ID_CUST_GRP_SEQ=""" + idCustGrpSeq + """  GARAGE_PRICE_PER=""" + GMPricePer + """ GP_DESCRIPTION=""" + GMDesc + """  ID_VAT=""" + vatCode + """ GP_ACCCODE=""" + accCode + """ />"""
                strXMLSettingsInsert = "<ROOT>" + strXMLSettingsInsert + "</ROOT>"
                details = objCustSrv.SaveGMPrice(strXMLSettingsInsert, IdLogin)
            End If

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfCustomer", "SaveGMPrice", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function SaveCustRP(ByVal IdSett As String, ByVal idRP As String, ByVal idCust As String, ByVal FlgPrice As String, _
     ByVal Price As String, ByVal mode As String) As String
        Dim strResult As String = ""
        Try
            objCustConfigBO.Id_Rp = idRP
            objCustConfigBO.Id_Customer = idCust
            objCustConfigBO.Flg_Price = FlgPrice
            objCustConfigBO.Price = Price
            objCustConfigBO.UserId = loginName
            objCustConfigBO.Id_Map_Seq = IdSett
            If mode = "Edit" Then
                strResult = objCustSrv.UpdateCustRP(objCustConfigBO)
            Else
                strResult = objCustSrv.InsertCustRP(objCustConfigBO)
            End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfCustomer", "SaveCustRP", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
    <WebMethod()> _
    Public Shared Function SaveID(ByVal startNo As String, ByVal endNo As String) As ConfigCustomerBO()
        Dim strResult As String = ""
        Try
            objCustConfigBO.Cust_Start = startNo
            objCustConfigBO.Cust_End = endNo
            objCustConfigBO.UserId = loginName
            details = objCustSrv.AddCustomerID(objCustConfigBO)

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfCustomer", "SaveCustRP", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function DeleteCustRP(ByVal custRPIdxml As String) As String
        Dim strResult As String
        Try
            strResult = objCustSrv.DeleteCustRP(custRPIdxml)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfCustomer", "DeleteRegionConfig", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
    <WebMethod()> _
    Public Shared Function DeleteRegionConfig(ByVal regionIdxml As String) As String()
        Dim strResult As String()
        Try
            strResult = objCustSrv.DeleteConfig(regionIdxml)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfCustomer", "DeleteRegionConfig", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
    <WebMethod()> _
    Public Shared Function DeletePTConfig(ByVal payTermXml As String) As String()
        Dim strResult As String()
        Try
            strResult = objCustSrv.DeletePTConfig(payTermXml)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfCustomer", "DeleteRegionConfig", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
    <WebMethod()> _
    Public Shared Function DeleteWarnConfig(ByVal warnIdxml As String) As String()
        Dim strResult As String()
        Try
            strResult = objCustSrv.DeleteConfig(warnIdxml)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfCustomer", "DeleteWarnConfig", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
    <WebMethod()> _
    Public Shared Function DeleteCusGConfig(ByVal custGIdxml As String) As String()
        Dim strResult As String()
        Try
            strResult = objCustSrv.DeleteCusGConfig(custGIdxml)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfCustomer", "DeleteCusGConfig", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
    <WebMethod()> _
    Public Shared Function DeleteGMPrice(ByVal GMPricexml As String) As String()
        Dim strResult As String()
        Try
            strResult = objCustSrv.DeleteGMPrice(GMPricexml)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfCustomer", "DeleteGMPrice", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
    <WebMethod()> _
    Public Shared Function LoadCurrency() As ConfigCustomerBO()
        Try
            details = objCustSrv.GetDefaultCurrency()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfCustomer", "LoadCurrency", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function LoadRpkg() As ConfigCustomerBO()
        Try
            details = objCustSrv.LoadRP()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfCustomer", "LoadRpkg", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
End Class