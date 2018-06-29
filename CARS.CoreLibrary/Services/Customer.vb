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

Namespace CARS.Services.Customer
    Public Class CustomerDetails
        Shared objCommonUtil As New CARS.Utilities.CommonUtility
        Shared objCustDO As New CustomerDO
        Shared objCustBO As New CustomerBO
        Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
        'Dim objCustBO As New CustomerBO
        Dim objDB As Database
        Dim ConnectionString As String

        Public Sub New()
            ConnectionString = System.Configuration.ConfigurationManager.AppSettings("MSGConstr")
            objDB = New SqlDatabase(ConnectionString)
        End Sub

        'Autocomplete function
        Public Function CustomerSearch(ByVal q As String, ByVal isPrivate As String, ByVal isCompany As String) As List(Of CustomerBO)
            Dim dsCustomer As New DataSet
            Dim dtCustomer As DataTable
            Dim customerSearchResult As New List(Of CustomerBO)()
            Try
                dsCustomer = objCustDO.Customer_Search(q, isPrivate, isCompany)

                If dsCustomer.Tables.Count > 0 Then
                    dtCustomer = dsCustomer.Tables(0)
                End If
                If q <> String.Empty Then
                    For Each dtrow As DataRow In dtCustomer.Rows
                        Dim csr As New CustomerBO()
                        csr.ID_CUSTOMER = dtrow("ID_CUSTOMER").ToString
                        csr.CUST_NAME = dtrow("CUST_NAME").ToString
                        csr.CUST_FIRST_NAME = dtrow("CUST_FIRST_NAME").ToString
                        csr.CUST_MIDDLE_NAME = dtrow("CUST_MIDDLE_NAME").ToString
                        csr.CUST_LAST_NAME = dtrow("CUST_LAST_NAME").ToString
                        csr.CUST_VISIT_ADDRESS = dtrow("CUST_VISIT_ADDRESS").ToString
                        csr.CUST_PHONE_HOME = dtrow("CUST_PHONE_HOME").ToString
                        csr.CUST_PHONE_OFF = dtrow("CUST_PHONE_OFF").ToString
                        csr.CUST_PHONE_MOBILE = dtrow("CUST_PHONE_MOBILE").ToString
                        csr.CUST_PERM_ADD1 = dtrow("CUST_PERM_ADD1").ToString
                        csr.ID_CUST_PERM_ZIPCODE = dtrow("ID_CUST_PERM_ZIPCODE").ToString
                        csr.CUST_PERM_CITY = dtrow("ZIP_CITY").ToString
                        customerSearchResult.Add(csr)
                    Next
                End If
            Catch ex As Exception
                Throw ex
            End Try
            Return customerSearchResult
        End Function

        'Enirofunction
        Public Function GetCustomerData(ByVal customer As String) As String
            Try
                Dim contactLink As String = ""
                Dim custDetails As String = ""
                Dim url As String = "http://live.intouch.no/tk/search.php?qry=" + customer + "&from=1&to=27&format=json&charset=UTF-8&username=cars&password=tkb28"
                Dim request As Net.HttpWebRequest = DirectCast(Net.WebRequest.Create(url), Net.HttpWebRequest)
                Dim response As Net.HttpWebResponse = DirectCast(request.GetResponse(), Net.HttpWebResponse)
                Dim reader As StreamReader = New StreamReader(response.GetResponseStream())
                Dim json As String = reader.ReadToEnd
                Dim o As JObject = JObject.Parse(json)
                Dim i As Integer = 1
                Dim results = o("result")


                For Each resultProperty In results.Value(Of JObject)()
                    'Only get properties like "1" inside the root "result" property
                    If Not Integer.TryParse(resultProperty.Key, Nothing) Then Continue For
                    'Approach 2: Deserialize the listing into a .Net object
                    Dim serializer As JsonSerializer = New JsonSerializer()
                    Dim resultObject As CustomerBO.Result = JsonConvert.DeserializeObject(Of CustomerBO.Result)(resultProperty.Value.ToString())

                    For Each duplicateObject In resultObject.listing.duplicates
                        Dim tlf As String = ""
                        Dim firstName As String = ""
                        Dim middleName As String = ""

                        If Not String.IsNullOrWhiteSpace(duplicateObject.fornavn) AndAlso duplicateObject.fornavn.Contains(" ") Then
                            Dim name As String() = duplicateObject.fornavn.Split(" ")
                            firstName = name(0)
                            middleName = name(1)
                        Else
                            firstName = duplicateObject.fornavn
                        End If

                        If firstName <> "" Or duplicateObject.etternavn <> "" Then
                            contactLink = "<a href='#" + i.ToString + "'class='customerEniro' ' data-contact-Firstname='" + firstName + "' data-contact-Middlename='" + middleName + "' data-contact-Lastname='" + duplicateObject.etternavn + "' data-contact-phone='" + duplicateObject.tlfnr + "'data-contact-born='" + Convert.ToDateTime(duplicateObject.fodselsdato).ToString("dd.MM.yyyy") + "' data-contact-address='" + duplicateObject.veinavn + " " + duplicateObject.husnr + "'data-contact-addresszip='" + duplicateObject.postnr + "'data-contact-addressplace='" + duplicateObject.poststed + "'data-contact-eniro='" + duplicateObject.idlinje + "'data-contact-orgno='" + duplicateObject.foretaksnr + "'data-contact-apparat='" + duplicateObject.apparattype + "' > "
                            contactLink += i.ToString + " - " + duplicateObject.fornavn + " " + duplicateObject.etternavn + " - " + duplicateObject.tlfnr + " - " + duplicateObject.veinavn + " " + duplicateObject.husnr + " - " + duplicateObject.postnr + " " + duplicateObject.poststed
                            contactLink += "</a>" + vbNewLine
                            custDetails += contactLink
                            i += 1
                        End If
                    Next
                Next
                Return custDetails
            Catch ex As Exception
                Throw ex
            End Try
        End Function

        Public Function FetchCustomerDetails(ByVal custId As String) As List(Of CustomerBO)
            Dim dsCustomer As New DataSet
            Dim dtCustomer As DataTable
            Dim retCustomer As New List(Of CustomerBO)()
            Try
                dsCustomer = objCustDO.Fetch_Customer_Details(custId)

                If dsCustomer.Tables.Count > 0 Then
                    dtCustomer = dsCustomer.Tables(0)
                End If
                If custId <> String.Empty Then
                    For Each dtrow As DataRow In dtCustomer.Rows
                        Dim custDet As New CustomerBO()
                        custDet.ID_CUSTOMER = dtrow("ID_CUSTOMER").ToString()
                        custDet.CUST_NAME = dtrow("CUST_NAME").ToString()
                        custDet.CUST_GEN_TYPE = dtrow("CUST_GEN_TYPE").ToString()
                        custDet.ID_CUST_GROUP = dtrow("ID_CUST_GROUP").ToString()
                        custDet.CUST_CONTACT_PERSON = dtrow("CUST_CONTACT_PERSON").ToString()
                        custDet.ID_CUST_REG_CD = dtrow("ID_CUST_REG_CD").ToString()
                        custDet.ID_CUST_PC_CODE = dtrow("ID_CUST_PC_CODE").ToString()
                        custDet.ID_CUST_DISC_CD = dtrow("ID_CUST_DISC_CD").ToString()
                        custDet.CUST_SSN_NO = dtrow("CUST_SSN_NO").ToString()
                        custDet.CUST_DRIV_LICNO = dtrow("CUST_DRIV_LICNO").ToString()
                        custDet.CUST_PHONE_OFF = dtrow("CUST_PHONE_OFF").ToString()
                        custDet.CUST_PHONE_HOME = dtrow("CUST_PHONE_HOME").ToString()
                        custDet.CUST_PHONE_MOBILE = dtrow("CUST_PHONE_MOBILE").ToString()
                        custDet.CUST_FAX = dtrow("CUST_FAX").ToString()
                        custDet.CUST_ID_EMAIL = dtrow("CUST_ID_EMAIL").ToString()
                        custDet.CUST_REMARKS = dtrow("CUST_REMARKS").ToString()
                        custDet.CUST_PERM_ADD1 = dtrow("CUST_PERM_ADD1").ToString()
                        custDet.CUST_PERM_ADD2 = dtrow("CUST_PERM_ADD2").ToString()
                        custDet.ID_CUST_PERM_ZIPCODE = dtrow("ID_CUST_PERM_ZIPCODE").ToString()
                        custDet.CUST_PERM_CITY = dtrow("CUST_PERM_CITY").ToString()
                        custDet.CUST_BILL_ADD1 = dtrow("CUST_BILL_ADD1").ToString()
                        custDet.CUST_BILL_ADD2 = dtrow("CUST_BILL_ADD2").ToString()
                        custDet.ID_CUST_BILL_ZIPCODE = dtrow("ID_CUST_BILL_ZIPCODE").ToString()
                        custDet.CUST_BILL_CITY = dtrow("CUST_BILL_CITY").ToString()
                        custDet.CUST_ACCOUNT_NO = dtrow("CUST_ACCOUNT_NO").ToString()
                        custDet.ID_CUST_PAY_TYPE = dtrow("ID_CUST_PAY_TYPE").ToString()
                        custDet.ID_CUST_CURRENCY = dtrow("ID_CUST_CURRENCY").ToString()
                        custDet.CUST_CREDIT_LIMIT = dtrow("CUST_CREDIT_LIMIT").ToString()
                        custDet.CUST_UNUTIL_CREDIT = dtrow("CUST_UNUTIL_CREDIT").ToString()
                        custDet.ID_CUST_WARN = dtrow("ID_CUST_WARN").ToString()
                        custDet.ID_CUST_PAY_TERM = dtrow("ID_CUST_PAY_TERM").ToString()
                        custDet.FLG_CUST_INACTIVE = IIf(IsDBNull(dtrow("FLG_CUST_INACTIVE")), False, dtrow("FLG_CUST_INACTIVE").ToString())
                        custDet.FLG_CUST_ADV = IIf(IsDBNull(dtrow("FLG_CUST_ADV")), False, dtrow("FLG_CUST_ADV").ToString())
                        custDet.FLG_CUST_FACTORING = IIf(IsDBNull(dtrow("FLG_CUST_FACTORING")), False, dtrow("FLG_CUST_FACTORING").ToString())
                        custDet.FLG_CUST_BATCHINV = IIf(IsDBNull(dtrow("FLG_CUST_BATCHINV")), False, dtrow("FLG_CUST_BATCHINV").ToString())
                        custDet.FLG_CUST_NOCREDIT = IIf(IsDBNull(dtrow("FLG_CUST_NOCREDIT")), False, dtrow("FLG_CUST_NOCREDIT").ToString())
                        custDet.CREATED_BY = dtrow("CREATED_BY").ToString()
                        custDet.DT_CREATED = dtrow("DT_CREATED").ToString()
                        If (dtrow("DT_CREATED").ToString() = "") Then
                            custDet.DT_CREATED = ""
                        Else
                            custDet.DT_CREATED = objCommonUtil.GetCurrentLanguageDate(dtrow("DT_CREATED").ToString())
                        End If
                        custDet.MODIFIED_BY = dtrow("MODIFIED_BY").ToString()
                        custDet.DT_MODIFIED = dtrow("DT_MODIFIED").ToString()
                        If (dtrow("DT_MODIFIED").ToString() = "") Then
                            custDet.DT_MODIFIED = ""
                        Else
                            custDet.DT_MODIFIED = objCommonUtil.GetCurrentLanguageDate(dtrow("DT_MODIFIED").ToString())
                        End If
                        custDet.CUST_BALANCE = dtrow("CUST_BALANCE").ToString()
                        custDet.ISSAMEADDRESS = IIf(IsDBNull(dtrow("ISSAMEADDRESS")), False, dtrow("ISSAMEADDRESS").ToString())
                        custDet.ISEXPORTED = IIf(IsDBNull(dtrow("ISEXPORTED")), False, dtrow("ISEXPORTED").ToString())
                        custDet.CUST_HOURLYPRICE = dtrow("CUST_HOURLYPRICE").ToString()
                        custDet.FLG_COSTPRICE = IIf(IsDBNull(dtrow("FLG_COSTPRICE")), False, dtrow("FLG_COSTPRICE").ToString())
                        custDet.COSTPRICE = dtrow("COSTPRICE").ToString()
                        custDet.CUST_GARAGEMAT = dtrow("CUST_GARAGEMAT").ToString()
                        custDet.CUST_SUB = dtrow("CUST_SUB").ToString()
                        custDet.CUST_DEP = dtrow("CUST_DEP").ToString()
                        custDet.FLG_CUST_IGNOREINV = IIf(IsDBNull(dtrow("FLG_CUST_IGNOREINV")), False, dtrow("FLG_CUST_IGNOREINV").ToString())
                        custDet.FLG_INV_EMAIL = IIf(IsDBNull(dtrow("FLG_INV_EMAIL")), False, dtrow("FLG_INV_EMAIL").ToString())
                        custDet.CUST_INV_EMAIL = dtrow("CUST_INV_EMAIL").ToString()
                        custDet.CUST_FIRST_NAME = dtrow("CUST_FIRST_NAME").ToString()
                        custDet.CUST_MIDDLE_NAME = dtrow("CUST_MIDDLE_NAME").ToString()
                        custDet.CUST_LAST_NAME = dtrow("CUST_LAST_NAME").ToString()
                        custDet.CUST_COUNTRY = dtrow("CUST_COUNTRY").ToString() 'kjhkjh
                        custDet.CUST_VISIT_ADDRESS = dtrow("CUST_VISIT_ADDRESS").ToString() 'FEIL
                        custDet.CUST_MAIL_ADDRESS = dtrow("CUST_MAIL_ADDRESS").ToString()
                        custDet.CUST_PHONE_ALT = dtrow("CUST_PHONE_ALT").ToString()
                        custDet.CUST_HOMEPAGE = dtrow("CUST_HOMEPAGE").ToString()
                        custDet.FLG_EINVOICE = IIf(IsDBNull(dtrow("FLG_EINVOICE")), False, dtrow("FLG_EINVOICE").ToString())
                        custDet.FLG_ORDCONF_EMAIL = IIf(IsDBNull(dtrow("FLG_ORDCONF_EMAIL")), False, dtrow("FLG_ORDCONF_EMAIL").ToString())
                        custDet.FLG_NO_SMS = IIf(IsDBNull(dtrow("FLG_NO_SMS")), False, dtrow("FLG_NO_SMS").ToString())
                        'custDet.FLG_NO_SMS = IIf(IsDBNull(dtrow("FLG_NO_SMS")), False, True)
                        custDet.FLG_NO_MARKETING = IIf(IsDBNull(dtrow("FLG_NO_MARKETING")), False, dtrow("FLG_NO_MARKETING").ToString())
                        custDet.FLG_NO_HUMANEORG = IIf(IsDBNull(dtrow("FLG_NO_HUMANEORG")), False, dtrow("FLG_NO_HUMANEORG").ToString())
                        custDet.FLG_NO_PHONESALE = IIf(IsDBNull(dtrow("FLG_NO_PHONESALE")), False, dtrow("FLG_NO_PHONESALE").ToString())
                        custDet.FLG_PRIVATE_COMP = IIf(IsDBNull(dtrow("FLG_PRIVATE_COMP")), False, dtrow("FLG_PRIVATE_COMP").ToString())
                        custDet.FLG_NO_GM = IIf(IsDBNull(dtrow("FLG_NO_GM")), False, dtrow("FLG_NO_GM").ToString())
                        custDet.FLG_NO_ENV_FEE = IIf(IsDBNull(dtrow("FLG_NO_ENV_FEE")), False, dtrow("FLG_NO_ENV_FEE").ToString())
                        custDet.FLG_NO_EMAIL = IIf(IsDBNull(dtrow("FLG_NO_EMAIL")), False, dtrow("FLG_NO_EMAIL").ToString())
                        custDet.FLG_PROSPECT = IIf(IsDBNull(dtrow("FLG_PROSPECT")), False, dtrow("FLG_PROSPECT").ToString())
                        custDet.CUST_NOTES = IIf(IsDBNull(dtrow("CUST_NOTES")), False, dtrow("CUST_NOTES").ToString())

                        custDet.CUST_DISC_GENERAL = dtrow("CUST_DISC_GENERAL").ToString()
                        custDet.CUST_DISC_LABOUR = dtrow("CUST_DISC_LABOUR").ToString()
                        custDet.CUST_DISC_SPARES = dtrow("CUST_DISC_SPARES").ToString()
                        custDet.ENIRO_ID = dtrow("CUST_ENIRO_ID").ToString()
                        custDet.CUST_BORN = dtrow("DT_CUST_BORN").ToString()
                        custDet.CUST_COMPANY_NO = dtrow("CUST_COMPANY_NO").ToString()
                        custDet.CUST_COMPANY_DESCRIPTION = dtrow("CUST_COMPANY_DESCRIPTION").ToString()
                        If custDet.CUST_BORN <> "" Then
                            custDet.CUST_BORN = objCommonUtil.GetCurrentLanguageDate(custDet.CUST_BORN)
                        End If
                        custDet.ID_CP = dtrow("ID_CP").ToString()



                        retCustomer.Add(custDet)
                    Next
                End If
            Catch ex As Exception
                Throw ex
            End Try
            Return retCustomer
        End Function

        Public Function Insert_Customer(ByVal custID As CustomerBO) As String()
            Dim strResult As String = ""
            Dim strArray As Array
            Dim login As String = HttpContext.Current.Session("UserID")
            Try
                strResult = objCustDO.Insert_Customer(custID, login)
                strArray = strResult.Split(";")
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.Customer", "Insert_Customer", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strArray
        End Function

        Public Function CCP_Function_Insert(ByVal code, ByVal description)
            Dim strResult As String = ""
            Dim strArray As Array
            Dim user As String = HttpContext.Current.Session("UserID")
            Try
                strResult = objCustDO.CCP_Function_Insert(code, description, user)
                strArray = strResult.Split(";")
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.Customer", "CCP_Function_Insert", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strArray
        End Function

        Public Function CCP_Title_Insert(ByVal code, ByVal description)
            Dim strResult As String = ""
            Dim strArray As Array
            Dim user As String = HttpContext.Current.Session("UserID")
            Try
                strResult = objCustDO.CCP_Title_Insert(code, description, user)
                strArray = strResult.Split(";")
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.Customer", "CCP_Title_Insert", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strArray
        End Function

        'Enirofunction
        Public Function GetEniroData(ByVal search As String) As List(Of CustomerBO)
            'Dim dsCustomer As New DataSet
            'Dim dtCustomer As DataTable
            Dim dtContact As New DataTable
            dtContact.Columns.Add("ID")
            dtContact.Columns.Add("PHONE_TYPE")
            dtContact.Columns.Add("CUST_PH_MOBILE")
            dtContact.Columns.Add("CUST_PH_OFF")
            Dim rUser As DataRow
            Dim objEniroDetails As New List(Of CustomerBO)()
            Dim IdArr As Array
            Dim Id As String

            Try
                Dim contactLink As String = ""
                Dim custDetails As String = ""
                Dim url As String = "http://live.intouch.no/tk/search.php?qry=" + search + "&from=1&to=27&format=json&charset=UTF-8&username=cars&password=tkb28"
                Dim request As Net.HttpWebRequest = DirectCast(Net.WebRequest.Create(url), Net.HttpWebRequest)
                Dim response As Net.HttpWebResponse = DirectCast(request.GetResponse(), Net.HttpWebResponse)
                Dim reader As StreamReader = New StreamReader(response.GetResponseStream())
                Dim json As String = reader.ReadToEnd
                Dim o As JObject = JObject.Parse(json)
                Dim i As Integer = 1
                Dim results = o("result")


                For Each resultProperty In results.Value(Of JObject)()
                    'Only get properties like "1" inside the root "result" property
                    If Not Integer.TryParse(resultProperty.Key, Nothing) Then Continue For
                    'Approach 2: Deserialize the listing into a .Net object
                    Dim serializer As JsonSerializer = New JsonSerializer()
                    Dim resultObject As CustomerBO.Result = JsonConvert.DeserializeObject(Of CustomerBO.Result)(resultProperty.Value.ToString())

                    Dim CustDet As New CustomerBO()
                    For Each duplicateObject In resultObject.listing.duplicates
                        Dim tlf As String = ""
                        Dim firstName As String = ""
                        Dim middleName As String = ""

                        If Not String.IsNullOrWhiteSpace(duplicateObject.fornavn) AndAlso duplicateObject.fornavn.Contains(" ") Then
                            Dim name = duplicateObject.fornavn
                            firstName = name.Substring(0, name.IndexOf(" "))
                            middleName = name.Substring(name.IndexOf(" ") + 1)
                        Else
                            firstName = duplicateObject.fornavn
                        End If

                        If Not duplicateObject.apparattype Is Nothing Then
                            rUser = dtContact.NewRow()
                            IdArr = duplicateObject.id.ToString.Split(":")
                            Id = IdArr(0)
                            rUser("ID") = Id
                            rUser("PHONE_TYPE") = duplicateObject.apparattype
                            If duplicateObject.apparattype = "M" Then
                                rUser("CUST_PH_MOBILE") = duplicateObject.tlfnr
                                rUser("CUST_PH_OFF") = ""
                            ElseIf duplicateObject.apparattype = "T" Then
                                rUser("CUST_PH_MOBILE") = ""
                                rUser("CUST_PH_OFF") = duplicateObject.tlfnr
                            Else
                                rUser("CUST_PH_MOBILE") = ""
                                rUser("CUST_PH_OFF") = duplicateObject.tlfnr
                            End If
                            dtContact.Rows.Add(rUser)
                        End If

                        If (firstName <> "" Or duplicateObject.etternavn <> "") Then
                            CustDet.CUST_SSN_NO = duplicateObject.foretaksnr
                            CustDet.CUST_PHONE_MOBILE = duplicateObject.tlfnr
                            CustDet.CUST_PERM_ADD1 = duplicateObject.veinavn + " " + duplicateObject.husnr
                            CustDet.CUST_PERM_ADD2 = duplicateObject.poststed
                            CustDet.ID_CUST_PERM_ZIPCODE = duplicateObject.postnr
                            CustDet.CUST_FIRST_NAME = IIf(firstName Is Nothing = True, "", firstName)
                            CustDet.CUST_MIDDLE_NAME = middleName
                            CustDet.CUST_LAST_NAME = duplicateObject.etternavn
                            CustDet.CUST_BORN = Convert.ToDateTime(duplicateObject.fodselsdato).ToString("dd.MM.yyyy")
                            CustDet.ENIRO_ID = duplicateObject.idlinje
                            CustDet.PHONE_TYPE = duplicateObject.apparattype
                            CustDet.CUST_COUNTY = duplicateObject.fylke
                            CustDet.ID_CUST = Id

                        End If
                    Next
                    objEniroDetails.Add(CustDet)
                Next
                HttpContext.Current.Session("CustContact") = dtContact
                Return objEniroDetails
            Catch ex As Exception
                Throw ex
            End Try

        End Function

        'Brreg function
        Public Function getBrregData(ByVal search As String) As List(Of CustomerBO.Brregdata)
            'Dim dsCustomer As New DataSet
            'Dim dtCustomer As DataTable
            Dim objBrregDetails As New List(Of CustomerBO.Brregdata)()
            Dim custBregDetails As New CustomerBO.Brregdata()

            Try
                Dim url As String = "http://data.brreg.no/enhetsregisteret/enhet/" + search + ".json" '986870504
                Dim request As HttpWebRequest = DirectCast(WebRequest.Create(url), HttpWebRequest)
                request.Method = "GET"
                request.ContentType = "application/json; charset=utf-8"
                request.ReadWriteTimeout = 30000

                Using httpResponse = request.GetResponse()
                    Using stream = httpResponse.GetResponseStream()
                        Dim jsonSerializer = New System.Runtime.Serialization.Json.DataContractJsonSerializer(GetType(CustomerBO.Brregdata))
                        Dim obj As CustomerBO.Brregdata = DirectCast(jsonSerializer.ReadObject(stream), CustomerBO.Brregdata)
                        custBregDetails.organisasjonsnummer = obj.organisasjonsnummer
                        custBregDetails.navn = obj.navn
                        custBregDetails.konkurs = obj.konkurs
                        custBregDetails.antallAnsatte = obj.antallAnsatte
                        objBrregDetails.Add(custBregDetails)
                    End Using
                End Using



                'Dim jsResponse = LoadJson(Of CustomerBO.Brregdata)(url)
                'custBregDetails.CUST_SSN_NO = jsResponse.organisasjonsnummer
                'custBregDetails.CUST_NAME = jsResponse.navn
                'objBrregDetails.Add(custBregDetails)

            Catch ex As Exception
                Throw ex
            End Try
            Return objBrregDetails
        End Function

        Public Function LoadEniroDetails(ByVal enorId As String) As List(Of CustomerBO)
            Dim dtCust As New DataTable
            Dim dtCustDetails As New DataTable
            Dim dvCustomer As DataView
            Dim details As New List(Of CustomerBO)()
            Try

                dtCust = HttpContext.Current.Session("CustomerDet")
                dvCustomer = dtCust.DefaultView
                dvCustomer.RowFilter = ("Eniro_Id  Like '" & enorId & "'")
                dtCustDetails = dvCustomer.ToTable
                For Each dtrow As DataRow In dtCustDetails.Rows
                    Dim custDet As New CustomerBO()
                    custDet.ENIRO_ID = dtrow("ENIRO_ID").ToString()
                    custDet.CUST_FIRST_NAME = IIf(dtrow("CUST_FIRST_NAME").ToString() = "", "", dtrow("CUST_FIRST_NAME").ToString())
                    custDet.CUST_LAST_NAME = dtrow("CUST_LAST_NAME").ToString()
                    custDet.CUST_MIDDLE_NAME = dtrow("CUST_MIDDLE_NAME").ToString()
                    custDet.CUST_PERM_ADD1 = dtrow("CUST_PERM_ADD1").ToString()
                    custDet.CUST_BORN = dtrow("CUST_BORN").ToString()
                    custDet.CUST_SSN_NO = dtrow("CUST_SSN_NO").ToString()
                    custDet.ID_CUST_PERM_ZIPCODE = dtrow("ID_CUST_PERM_ZIPCODE").ToString()
                    custDet.CUST_PERM_ADD2 = dtrow("CUST_PERM_ADD2").ToString()
                    custDet.CUST_PHONE_MOBILE = dtrow("CUST_PHONE_MOBILE").ToString()
                    custDet.PHONE_TYPE = dtrow("PHONE_TYPE").ToString()
                    custDet.ID_CUST = dtrow("ID_CUST").ToString()
                    details.Add(custDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.Vehicle", "Add_Vehicle", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details
        End Function
        Public Function BindContact(ByVal Id As String) As List(Of String)
            Dim dtCust As New DataTable
            Dim dtCustDetails As New DataTable
            Dim dvCustomer As DataView
            Dim retDet As New List(Of String)()
            Try
                dtCust = HttpContext.Current.Session("CustContact")
                dvCustomer = dtCust.DefaultView
                dvCustomer.RowFilter = ("ID  Like '" & Id & "'")
                dtCustDetails = dvCustomer.ToTable
                For Each dtrow As DataRow In dtCustDetails.Rows
                    retDet.Add(String.Format("{0}-{1}-{2}", dtrow("PHONE_TYPE"), dtrow("CUST_PH_MOBILE"), dtrow("CUST_PH_OFF")))
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.Vehicle", "Add_Vehicle", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return retDet
        End Function

        Public Function FetchCustomerGroup() As List(Of CustomerBO)
            Dim dsFetchCustomerGroup As New DataSet
            Dim dtCustomerGroup As DataTable
            Dim customerGroup As New List(Of CustomerBO)()
            Try
                dsFetchCustomerGroup = objCustDO.FetchCustomerGroup()
                dtCustomerGroup = dsFetchCustomerGroup.Tables(0)
                'HttpContext.Current.Session("dvSubsidiaryList") = dtSubDetails.DefaultView
                For Each dtrow As DataRow In dtCustomerGroup.Rows
                    Dim custGroupDet As New CustomerBO()
                    custGroupDet.ID_CUST_GROUP = dtrow("CUST_GROUP").ToString()
                    custGroupDet.ID_CUST_GROUP_DESC = dtrow("DESCRIPTION").ToString()
                    customerGroup.Add(custGroupDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Customer.vb", "FetchCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return customerGroup.ToList
        End Function

        Public Function Company_List(ByVal q As String) As List(Of CustomerBO)
            Dim dsCompanyList As New DataSet
            Dim dtCompanyList As DataTable
            Dim vehicleSearchResult As New List(Of CustomerBO)()
            Try
                dsCompanyList = objCustDO.Company_List(q)

                If dsCompanyList.Tables.Count > 0 Then
                    dtCompanyList = dsCompanyList.Tables(0)
                End If
                If q <> String.Empty Then
                    For Each dtrow As DataRow In dtCompanyList.Rows
                        Dim vsr As New CustomerBO()
                        vsr.ID_CUSTOMER = dtrow("ID_CUSTOMER").ToString
                        vsr.CUST_FIRST_NAME = dtrow("CUST_FIRST_NAME").ToString
                        vsr.CUST_MIDDLE_NAME = dtrow("CUST_MIDDLE_NAME").ToString
                        vsr.CUST_LAST_NAME = dtrow("CUST_LAST_NAME").ToString
                        vehicleSearchResult.Add(vsr)
                    Next
                End If
            Catch ex As Exception
                Throw ex
            End Try
            Return vehicleSearchResult
        End Function


        Public Function FetchSalesman() As List(Of CustomerBO)
            Dim dsFetchSalesman As New DataSet
            Dim dtSalesman As DataTable
            Dim Salesman As New List(Of CustomerBO)()
            Try
                dsFetchSalesman = objCustDO.FetchSalesman()
                dtSalesman = dsFetchSalesman.Tables(0)
                'HttpContext.Current.Session("dvSubsidiaryList") = dtSubDetails.DefaultView
                For Each dtrow As DataRow In dtSalesman.Rows
                    Dim salesmanDet As New CustomerBO()
                    salesmanDet.USER_LOGIN = dtrow("ID_LOGIN").ToString()
                    salesmanDet.USER_FIRST_NAME = dtrow("FIRST_NAME").ToString()
                    salesmanDet.USER_LAST_NAME = dtrow("LAST_NAME").ToString()
                    salesmanDet.USER_PASSWORD = dtrow("ID_DEPT_USER").ToString()
                    salesmanDet.USER_DEPARTMENT = dtrow("DeptName").ToString()
                    salesmanDet.USER_PHONE = dtrow("MOBILENO").ToString()
                    Salesman.Add(salesmanDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Customer.vb", "FetchCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return Salesman.ToList
        End Function

        Public Function GetSalesman(ByVal loginId As String) As List(Of CustomerBO)
            Dim dsGetSalesman As New DataSet
            Dim dtGetSalesman As DataTable
            Dim Salesman As New List(Of CustomerBO)()
            Try
                dsGetSalesman = objCustDO.GetSalesman(loginId)
                dtGetSalesman = dsGetSalesman.Tables(0)
                'HttpContext.Current.Session("dvSubsidiaryList") = dtSubDetails.DefaultView
                For Each dtrow As DataRow In dtGetSalesman.Rows
                    Dim getSalesmanDet As New CustomerBO()
                    getSalesmanDet.USER_LOGIN = dtrow("ID_LOGIN").ToString()
                    getSalesmanDet.USER_FIRST_NAME = dtrow("FIRST_NAME").ToString()
                    getSalesmanDet.USER_LAST_NAME = dtrow("LAST_NAME").ToString()
                    getSalesmanDet.USER_PASSWORD = dtrow("ID_DEPT_USER").ToString()
                    getSalesmanDet.USER_DEPARTMENT = dtrow("DeptName").ToString()
                    getSalesmanDet.USER_PHONE = dtrow("MOBILENO").ToString()
                    Salesman.Add(getSalesmanDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Customer.vb", "FetchCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return Salesman.ToList
        End Function

        Public Function FetchBranch() As List(Of CustomerBO)
            Dim dsFetchBranch As New DataSet
            Dim dtBranch As DataTable
            Dim Branch As New List(Of CustomerBO)()
            Try
                dsFetchBranch = objCustDO.FetchBranch()
                dtBranch = dsFetchBranch.Tables(0)
                'HttpContext.Current.Session("dvSubsidiaryList") = dtSubDetails.DefaultView
                For Each dtrow As DataRow In dtBranch.Rows
                    Dim branchDet As New CustomerBO()
                    branchDet.BRANCH_CODE = dtrow("CUSTOMER_BRANCH_CODE").ToString()
                    branchDet.BRANCH_TEXT = dtrow("CUSTOMR_BRANCH_DESCRIPTION").ToString()
                    Branch.Add(branchDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Customer.vb", "FetchCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return Branch.ToList
        End Function

        Public Function GetBranch(ByVal branchId As String) As List(Of CustomerBO)
            Dim dsGetBranch As New DataSet
            Dim dtGetBranch As DataTable
            Dim Branch As New List(Of CustomerBO)()
            Try
                dsGetBranch = objCustDO.GetBranch(branchId)
                dtGetBranch = dsGetBranch.Tables(0)
                'HttpContext.Current.Session("dvSubsidiaryList") = dtSubDetails.DefaultView
                For Each dtrow As DataRow In dtGetBranch.Rows
                    Dim getBranchDet As New CustomerBO()
                    getBranchDet.BRANCH_CODE = dtrow("CUSTOMER_BRANCH_CODE").ToString()
                    getBranchDet.BRANCH_TEXT = dtrow("CUSTOMR_BRANCH_DESCRIPTION").ToString()
                    getBranchDet.BRANCH_NOTE = dtrow("CUSTOMER_BRANCH_NOTE").ToString()
                    getBranchDet.BRANCH_ANNOT = dtrow("CUSTOMER_BRANCH_ANNOTATION").ToString()
                    Branch.Add(getBranchDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Customer.vb", "FetchCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return Branch.ToList
        End Function

        Public Function FetchCategory() As List(Of CustomerBO)
            Dim dsFetchCategory As New DataSet
            Dim dtCategory As DataTable
            Dim Category As New List(Of CustomerBO)()
            Try
                dsFetchCategory = objCustDO.FetchCategory()
                dtCategory = dsFetchCategory.Tables(0)
                'HttpContext.Current.Session("dvSubsidiaryList") = dtSubDetails.DefaultView
                For Each dtrow As DataRow In dtCategory.Rows
                    Dim categoryDet As New CustomerBO()
                    categoryDet.CATEGORY_CODE = dtrow("CUSTOMER_CATG_CODE").ToString()
                    categoryDet.CATEGORY_TEXT = dtrow("CUSTOMER_CATG_DESCRIPTION").ToString()
                    Category.Add(categoryDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Customer.vb", "FetchCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return Category.ToList
        End Function

        Public Function GetCategory(ByVal categoryId As String) As List(Of CustomerBO)
            Dim dsGetCategory As New DataSet
            Dim dtGetCategory As DataTable
            Dim Category As New List(Of CustomerBO)()
            Try
                dsGetCategory = objCustDO.GetCategory(categoryId)
                dtGetCategory = dsGetCategory.Tables(0)
                'HttpContext.Current.Session("dvSubsidiaryList") = dtSubDetails.DefaultView
                For Each dtrow As DataRow In dtGetCategory.Rows
                    Dim getCategoryDet As New CustomerBO()
                    getCategoryDet.CATEGORY_CODE = dtrow("CUSTOMER_CATG_CODE").ToString()
                    getCategoryDet.CATEGORY_TEXT = dtrow("CUSTOMER_CATG_DESCRIPTION").ToString()
                    getCategoryDet.CATEGORY_ANNOT = dtrow("CUSTOMER_CATG_ANNOTATION").ToString()
                    Category.Add(getCategoryDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Customer.vb", "FetchCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return Category.ToList
        End Function

        Public Function FetchSalesGroup() As List(Of CustomerBO)
            Dim dsFetchSalesGroup As New DataSet
            Dim dtSalesGroup As DataTable
            Dim SalesGroup As New List(Of CustomerBO)()
            Try
                dsFetchSalesGroup = objCustDO.FetchSalesGroup()
                dtSalesGroup = dsFetchSalesGroup.Tables(0)
                'HttpContext.Current.Session("dvSubsidiaryList") = dtSubDetails.DefaultView
                For Each dtrow As DataRow In dtSalesGroup.Rows
                    Dim salesgroupDet As New CustomerBO()
                    salesgroupDet.SALESGROUP_CODE = dtrow("CUSTOMER_SALESGROUP_CODE").ToString()
                    salesgroupDet.SALESGROUP_TEXT = dtrow("CUSTOMER_SALESGROUP_DESCRIPTION").ToString()
                    SalesGroup.Add(salesgroupDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Customer.vb", "FetchCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return SalesGroup.ToList
        End Function

        Public Function GetSalesGroup(ByVal salesgroupId As String) As List(Of CustomerBO)
            Dim dsGetSalesGroup As New DataSet
            Dim dtGetSalesGroup As DataTable
            Dim SalesGroup As New List(Of CustomerBO)()
            Try
                dsGetSalesGroup = objCustDO.GetSalesGroup(salesgroupId)
                dtGetSalesGroup = dsGetSalesGroup.Tables(0)
                'HttpContext.Current.Session("dvSubsidiaryList") = dtSubDetails.DefaultView
                For Each dtrow As DataRow In dtGetSalesGroup.Rows
                    Dim getSalesGroupDet As New CustomerBO()
                    getSalesGroupDet.SALESGROUP_CODE = dtrow("CUSTOMER_SALESGROUP_CODE").ToString()
                    getSalesGroupDet.SALESGROUP_TEXT = dtrow("CUSTOMER_SALESGROUP_DESCRIPTION").ToString()
                    getSalesGroupDet.SALESGROUP_INVESTMENT = dtrow("CUSTOMER_SALESGROUP_INVESTMENT").ToString()
                    getSalesGroupDet.SALESGROUP_VAT = dtrow("CUSTOMER_SALESGROUP_VAT").ToString()
                    SalesGroup.Add(getSalesGroupDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Customer.vb", "FetchCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return SalesGroup.ToList
        End Function

        Public Function FetchPaymentTerms() As List(Of CustomerBO)
            Dim dsFetchPaymentTerms As New DataSet
            Dim dtPaymentTerms As DataTable
            Dim PaymentTerms As New List(Of CustomerBO)()
            Try
                dsFetchPaymentTerms = objCustDO.FetchPaymentTerms()
                dtPaymentTerms = dsFetchPaymentTerms.Tables(0)
                'HttpContext.Current.Session("dvSubsidiaryList") = dtSubDetails.DefaultView
                For Each dtrow As DataRow In dtPaymentTerms.Rows
                    Dim paymentTermsDet As New CustomerBO()
                    paymentTermsDet.PAYMENT_TERMS_CODE = dtrow("PAY_CODE").ToString()
                    paymentTermsDet.PAYMENT_TERMS_TEXT = dtrow("DESCRIPTION").ToString()
                    paymentTermsDet.PAYMENT_TERMS_DAYS = dtrow("TERMS").ToString()
                    PaymentTerms.Add(paymentTermsDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Customer.vb", "FetchCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return PaymentTerms.ToList
        End Function

        Public Function GetPaymentTerms(ByVal paymentTermsId As String) As List(Of CustomerBO)
            Dim dsGetPaymentTerms As New DataSet
            Dim dtGetPaymentTerms As DataTable
            Dim PaymentTerms As New List(Of CustomerBO)()
            Try
                dsGetPaymentTerms = objCustDO.GetPaymentTerms(paymentTermsId)
                dtGetPaymentTerms = dsGetPaymentTerms.Tables(0)
                'HttpContext.Current.Session("dvSubsidiaryList") = dtSubDetails.DefaultView
                For Each dtrow As DataRow In dtGetPaymentTerms.Rows
                    Dim getPaymentTermsDet As New CustomerBO()
                    getPaymentTermsDet.PAYMENT_TERMS_CODE = dtrow("PAY_CODE").ToString()
                    getPaymentTermsDet.PAYMENT_TERMS_TEXT = dtrow("DESCRIPTION").ToString()
                    getPaymentTermsDet.PAYMENT_TERMS_DAYS = dtrow("TERMS").ToString()
                    PaymentTerms.Add(getPaymentTermsDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Customer.vb", "FetchCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return PaymentTerms.ToList
        End Function

        Public Function FetchCardType() As List(Of CustomerBO)
            Dim dsFetchCardType As New DataSet
            Dim dtCardType As DataTable
            Dim CardType As New List(Of CustomerBO)()
            Try
                dsFetchCardType = objCustDO.FetchCardType()
                dtCardType = dsFetchCardType.Tables(0)
                'HttpContext.Current.Session("dvSubsidiaryList") = dtSubDetails.DefaultView
                For Each dtrow As DataRow In dtCardType.Rows
                    Dim cardTypeDet As New CustomerBO()
                    cardTypeDet.CARD_TYPE_CODE = dtrow("CUSTOMER_CARD_CODE").ToString()
                    cardTypeDet.CARD_TYPE_TEXT = dtrow("CUSTOMER_CARD_DESCRIPTION").ToString()
                    cardTypeDet.CARD_TYPE_CUSTNO = dtrow("CUSTOMER_CARD_CUST_NO").ToString()
                    CardType.Add(cardTypeDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Customer.vb", "FetchCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return CardType.ToList
        End Function

        Public Function GetCardType(ByVal cardTypeId As String) As List(Of CustomerBO)
            Dim dsGetCardType As New DataSet
            Dim dtGetCardType As DataTable
            Dim CardType As New List(Of CustomerBO)()
            Try
                dsGetCardType = objCustDO.GetCardType(cardTypeId)
                dtGetCardType = dsGetCardType.Tables(0)
                'HttpContext.Current.Session("dvSubsidiaryList") = dtSubDetails.DefaultView
                For Each dtrow As DataRow In dtGetCardType.Rows
                    Dim getCardTypeDet As New CustomerBO()
                    getCardTypeDet.CARD_TYPE_CODE = dtrow("CUSTOMER_CARD_CODE").ToString()
                    getCardTypeDet.CARD_TYPE_TEXT = dtrow("CUSTOMER_CARD_DESCRIPTION").ToString()
                    getCardTypeDet.CARD_TYPE_CUSTNO = dtrow("CUSTOMER_CARD_CUST_NO").ToString()
                    CardType.Add(getCardTypeDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Customer.vb", "FetchCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return CardType.ToList
        End Function

        Public Function FetchCurrencyType() As List(Of CustomerBO)
            Dim dsFetchCurrencyType As New DataSet
            Dim dtCurrencyType As DataTable
            Dim CurrencyType As New List(Of CustomerBO)()
            Try
                dsFetchCurrencyType = objCustDO.FetchCurrencyType()
                dtCurrencyType = dsFetchCurrencyType.Tables(0)
                'HttpContext.Current.Session("dvSubsidiaryList") = dtSubDetails.DefaultView
                For Each dtrow As DataRow In dtCurrencyType.Rows
                    Dim currencyTypeDet As New CustomerBO()
                    currencyTypeDet.CURRENCY_TYPE_CODE = dtrow("CURRENCY_CODE").ToString()
                    currencyTypeDet.CURRENCY_TYPE_TEXT = dtrow("CURRENCY_DESCRIPTION").ToString()
                    currencyTypeDet.CURRENCY_TYPE_RATE = dtrow("CURRENCY_RATE").ToString()
                    CurrencyType.Add(currencyTypeDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Customer.vb", "FetchCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return CurrencyType.ToList
        End Function

        Public Function GetCurrencyType(ByVal currencyId As String) As List(Of CustomerBO)
            Dim dsGetCurrencyType As New DataSet
            Dim dtGetCurrencyType As DataTable
            Dim CurrencyType As New List(Of CustomerBO)()
            Try
                dsGetCurrencyType = objCustDO.GetCurrencyType(currencyId)
                dtGetCurrencyType = dsGetCurrencyType.Tables(0)
                'HttpContext.Current.Session("dvSubsidiaryList") = dtSubDetails.DefaultView
                For Each dtrow As DataRow In dtGetCurrencyType.Rows
                    Dim getCurrencyTypeDet As New CustomerBO()
                    getCurrencyTypeDet.CURRENCY_TYPE_CODE = dtrow("CURRENCY_CODE").ToString()
                    getCurrencyTypeDet.CURRENCY_TYPE_TEXT = dtrow("CURRENCY_DESCRIPTION").ToString()
                    getCurrencyTypeDet.CURRENCY_TYPE_RATE = dtrow("CURRENCY_RATE").ToString()
                    CurrencyType.Add(getCurrencyTypeDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Customer.vb", "FetchCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return CurrencyType.ToList
        End Function

        Public Function Add_Branch(ByVal objCustBO As CustomerBO) As String
            Dim strResult As String = ""
            Try
                strResult = objCustDO.Add_Branch(objCustBO)
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.Vehicle", "Add_Vehicle", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strResult
        End Function
        Public Function DeleteBranch(ByVal branchId As String) As List(Of CustomerBO)
            Dim dsGetBranch As New DataSet

            Dim Branch As New List(Of CustomerBO)()
            Try
                objCustDO.Delete_Branch(branchId)

                'HttpContext.Current.Session("dvSubsidiaryList") = dtSubDetails.DefaultView

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Customer.vb", "FetchCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return Branch.ToList
        End Function

        Public Function Add_Category(ByVal objCustBO As CustomerBO) As String
            Dim strResult As String = ""
            Try
                strResult = objCustDO.Add_Category(objCustBO)
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.Vehicle", "Add_Vehicle", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strResult
        End Function

        Public Function DeleteCategory(ByVal categoryId As String) As List(Of CustomerBO)
            Dim dsGetBranch As New DataSet

            Dim Branch As New List(Of CustomerBO)()
            Try
                objCustDO.Delete_Category(categoryId)

                'HttpContext.Current.Session("dvSubsidiaryList") = dtSubDetails.DefaultView

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Customer.vb", "FetchCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return Branch.ToList
        End Function

        Public Function Add_SalesGroup(ByVal objCustBO As CustomerBO) As String
            Dim strResult As String = ""
            Try
                strResult = objCustDO.Add_SalesGroup(objCustBO)
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.Vehicle", "Add_Vehicle", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strResult
        End Function

        Public Function DeleteSalesGroup(ByVal salesgroupId As String) As List(Of CustomerBO)
            Dim dsGetSalesGroup As New DataSet

            Dim SalesGroup As New List(Of CustomerBO)()
            Try
                objCustDO.Delete_SalesGroup(salesgroupId)

                'HttpContext.Current.Session("dvSubsidiaryList") = dtSubDetails.DefaultView

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Customer.vb", "FetchCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return SalesGroup.ToList
        End Function

        Public Function Add_PaymentTerms(ByVal objCustBO As CustomerBO) As String
            Dim strResult As String = ""
            Try
                strResult = objCustDO.Add_PaymentTerms(objCustBO)
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.Vehicle", "Add_Vehicle", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strResult
        End Function

        Public Function DeletePaymentTerms(ByVal paymenttermsId As String) As List(Of CustomerBO)
            Dim dsGetSalesGroup As New DataSet

            Dim PaymentTerms As New List(Of CustomerBO)()
            Try
                objCustDO.Delete_PaymentTerms(paymenttermsId)

                'HttpContext.Current.Session("dvSubsidiaryList") = dtSubDetails.DefaultView

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Customer.vb", "FetchCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return PaymentTerms.ToList
        End Function

        Public Function Add_CardType(ByVal objCustBO As CustomerBO) As String
            Dim strResult As String = ""
            Try
                strResult = objCustDO.Add_CardType(objCustBO)
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.Vehicle", "Add_Vehicle", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strResult
        End Function

        Public Function DeleteCardType(ByVal cardtypeId As String) As List(Of CustomerBO)
            Dim dsGetCardType As New DataSet

            Dim CardType As New List(Of CustomerBO)()
            Try
                objCustDO.Delete_CardType(cardtypeId)

                'HttpContext.Current.Session("dvSubsidiaryList") = dtSubDetails.DefaultView

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Customer.vb", "FetchCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return CardType.ToList
        End Function

        Public Function Add_CurrencyType(ByVal objCustBO As CustomerBO) As String
            Dim strResult As String = ""
            Try
                strResult = objCustDO.Add_CurrencyType(objCustBO)
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.Vehicle", "Add_Vehicle", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strResult
        End Function

        Public Function DeleteCurrency(ByVal currencyId As String) As List(Of CustomerBO)
            Dim dsGetCurrency As New DataSet

            Dim Currency As New List(Of CustomerBO)()
            Try
                objCustDO.Delete_Currency(currencyId)

                'HttpContext.Current.Session("dvSubsidiaryList") = dtSubDetails.DefaultView

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Customer.vb", "FetchCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return Currency.ToList
        End Function

        Public Function LoadCustomerTemplate() As List(Of CustomerBO)
            Dim dsLoadCustomerTemplate As New DataSet
            Dim dtLoadCustomerTemplate As DataTable
            Dim ContactType As New List(Of CustomerBO)()
            Try
                dsLoadCustomerTemplate = objCustDO.LoadCustomerTemplate()
                dtLoadCustomerTemplate = dsLoadCustomerTemplate.Tables(0)
                'HttpContext.Current.Session("dvSubsidiaryList") = dtSubDetails.DefaultView
                For Each dtrow As DataRow In dtLoadCustomerTemplate.Rows
                    Dim contactTypeDet As New CustomerBO()
                    contactTypeDet.ID_CUSTOMER = dtrow("ID_CUSTOMER").ToString()
                    contactTypeDet.CUST_NAME = dtrow("CUST_NAME").ToString()
                    ContactType.Add(contactTypeDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Vehicle.vb", "FetchWarranty", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return ContactType.ToList
        End Function

        Public Function FetchCustomerTemplate(ByVal tempId As String) As List(Of CustomerBO)
            Dim dsCustomer As New DataSet
            Dim dtCustomer As DataTable
            Dim retCustomer As New List(Of CustomerBO)()
            Try
                dsCustomer = objCustDO.FetchCustomerTemplate(tempId)

                If dsCustomer.Tables.Count > 0 Then
                    dtCustomer = dsCustomer.Tables(0)
                End If
                If tempId <> String.Empty Then
                    For Each dtrow As DataRow In dtCustomer.Rows
                        Dim custDet As New CustomerBO()
                        custDet.ID_CUSTOMER = dtrow("ID_CUSTOMER").ToString()
                        custDet.CUST_NAME = dtrow("CUST_NAME").ToString()
                        custDet.CUST_GEN_TYPE = dtrow("CUST_GEN_TYPE").ToString()
                        custDet.ID_CUST_GROUP = dtrow("ID_CUST_GROUP").ToString()
                        custDet.CUST_CONTACT_PERSON = dtrow("CUST_CONTACT_PERSON").ToString()
                        custDet.ID_CUST_REG_CD = dtrow("ID_CUST_REG_CD").ToString()
                        custDet.ID_CUST_PC_CODE = dtrow("ID_CUST_PC_CODE").ToString()
                        custDet.ID_CUST_DISC_CD = dtrow("ID_CUST_DISC_CD").ToString()
                        custDet.CUST_SSN_NO = dtrow("CUST_SSN_NO").ToString()
                        custDet.CUST_DRIV_LICNO = dtrow("CUST_DRIV_LICNO").ToString()
                        custDet.CUST_PHONE_OFF = dtrow("CUST_PHONE_OFF").ToString()
                        custDet.CUST_PHONE_HOME = dtrow("CUST_PHONE_HOME").ToString()
                        custDet.CUST_PHONE_MOBILE = dtrow("CUST_PHONE_MOBILE").ToString()
                        custDet.CUST_FAX = dtrow("CUST_FAX").ToString()
                        custDet.CUST_ID_EMAIL = dtrow("CUST_ID_EMAIL").ToString()
                        custDet.CUST_REMARKS = dtrow("CUST_REMARKS").ToString()
                        custDet.CUST_PERM_ADD1 = dtrow("CUST_PERM_ADD1").ToString()
                        custDet.CUST_PERM_ADD2 = dtrow("CUST_PERM_ADD2").ToString()
                        custDet.ID_CUST_PERM_ZIPCODE = dtrow("ID_CUST_PERM_ZIPCODE").ToString()
                        custDet.CUST_PERM_CITY = dtrow("CUST_PERM_CITY").ToString()
                        custDet.CUST_BILL_ADD1 = dtrow("CUST_BILL_ADD1").ToString()
                        custDet.CUST_BILL_ADD2 = dtrow("CUST_BILL_ADD2").ToString()
                        custDet.ID_CUST_BILL_ZIPCODE = dtrow("ID_CUST_BILL_ZIPCODE").ToString()
                        custDet.CUST_BILL_CITY = dtrow("CUST_BILL_CITY").ToString()
                        custDet.CUST_ACCOUNT_NO = dtrow("CUST_ACCOUNT_NO").ToString()
                        custDet.ID_CUST_PAY_TYPE = dtrow("ID_CUST_PAY_TYPE").ToString()
                        custDet.ID_CUST_CURRENCY = dtrow("ID_CUST_CURRENCY").ToString()
                        custDet.CUST_CREDIT_LIMIT = dtrow("CUST_CREDIT_LIMIT").ToString()
                        custDet.CUST_UNUTIL_CREDIT = dtrow("CUST_UNUTIL_CREDIT").ToString()
                        custDet.ID_CUST_WARN = dtrow("ID_CUST_WARN").ToString()
                        custDet.ID_CUST_PAY_TERM = dtrow("ID_CUST_PAY_TERM").ToString()
                        custDet.FLG_CUST_INACTIVE = IIf(IsDBNull(dtrow("FLG_CUST_INACTIVE")), False, dtrow("FLG_CUST_INACTIVE").ToString())
                        custDet.FLG_CUST_ADV = IIf(IsDBNull(dtrow("FLG_CUST_ADV")), False, dtrow("FLG_CUST_ADV").ToString())
                        custDet.FLG_CUST_FACTORING = IIf(IsDBNull(dtrow("FLG_CUST_FACTORING")), False, dtrow("FLG_CUST_FACTORING").ToString())
                        custDet.FLG_CUST_BATCHINV = IIf(IsDBNull(dtrow("FLG_CUST_BATCHINV")), False, dtrow("FLG_CUST_BATCHINV").ToString())
                        custDet.FLG_CUST_NOCREDIT = IIf(IsDBNull(dtrow("FLG_CUST_NOCREDIT")), False, dtrow("FLG_CUST_NOCREDIT").ToString())
                        custDet.CREATED_BY = dtrow("CREATED_BY").ToString()
                        custDet.DT_CREATED = dtrow("DT_CREATED").ToString()
                        If (dtrow("DT_CREATED").ToString() = "") Then
                            custDet.DT_CREATED = ""
                        Else
                            custDet.DT_CREATED = objCommonUtil.GetCurrentLanguageDate(dtrow("DT_CREATED").ToString())
                        End If
                        custDet.MODIFIED_BY = dtrow("MODIFIED_BY").ToString()
                        custDet.DT_MODIFIED = dtrow("DT_MODIFIED").ToString()
                        If (dtrow("DT_MODIFIED").ToString() = "") Then
                            custDet.DT_MODIFIED = ""
                        Else
                            custDet.DT_MODIFIED = objCommonUtil.GetCurrentLanguageDate(dtrow("DT_MODIFIED").ToString())
                        End If
                        custDet.CUST_BALANCE = dtrow("CUST_BALANCE").ToString()
                        custDet.ISSAMEADDRESS = IIf(IsDBNull(dtrow("ISSAMEADDRESS")), False, dtrow("ISSAMEADDRESS").ToString())
                        custDet.ISEXPORTED = IIf(IsDBNull(dtrow("ISEXPORTED")), False, dtrow("ISEXPORTED").ToString())
                        custDet.CUST_HOURLYPRICE = dtrow("CUST_HOURLYPRICE").ToString()
                        custDet.FLG_COSTPRICE = IIf(IsDBNull(dtrow("FLG_COSTPRICE")), False, dtrow("FLG_COSTPRICE").ToString())
                        custDet.COSTPRICE = dtrow("COSTPRICE").ToString()
                        custDet.CUST_GARAGEMAT = dtrow("CUST_GARAGEMAT").ToString()
                        custDet.CUST_SUB = dtrow("CUST_SUB").ToString()
                        custDet.CUST_DEP = dtrow("CUST_DEP").ToString()
                        custDet.FLG_CUST_IGNOREINV = IIf(IsDBNull(dtrow("FLG_CUST_IGNOREINV")), False, dtrow("FLG_CUST_IGNOREINV").ToString())
                        custDet.FLG_INV_EMAIL = IIf(IsDBNull(dtrow("FLG_INV_EMAIL")), False, dtrow("FLG_INV_EMAIL").ToString())
                        custDet.CUST_INV_EMAIL = dtrow("CUST_INV_EMAIL").ToString()
                        custDet.CUST_FIRST_NAME = dtrow("CUST_FIRST_NAME").ToString()
                        custDet.CUST_MIDDLE_NAME = dtrow("CUST_MIDDLE_NAME").ToString()
                        custDet.CUST_LAST_NAME = dtrow("CUST_LAST_NAME").ToString()
                        custDet.CUST_COUNTRY = dtrow("CUST_COUNTRY").ToString() 'kjhkjh
                        custDet.CUST_VISIT_ADDRESS = dtrow("CUST_VISIT_ADDRESS").ToString() 'FEIL
                        custDet.CUST_MAIL_ADDRESS = dtrow("CUST_MAIL_ADDRESS").ToString()
                        custDet.CUST_PHONE_ALT = dtrow("CUST_PHONE_ALT").ToString()
                        custDet.CUST_HOMEPAGE = dtrow("CUST_HOMEPAGE").ToString()
                        custDet.FLG_EINVOICE = IIf(IsDBNull(dtrow("FLG_EINVOICE")), False, dtrow("FLG_EINVOICE").ToString())
                        custDet.FLG_ORDCONF_EMAIL = IIf(IsDBNull(dtrow("FLG_ORDCONF_EMAIL")), False, dtrow("FLG_ORDCONF_EMAIL").ToString())
                        custDet.FLG_NO_SMS = IIf(IsDBNull(dtrow("FLG_NO_SMS")), False, dtrow("FLG_NO_SMS").ToString())
                        'custDet.FLG_NO_SMS = IIf(IsDBNull(dtrow("FLG_NO_SMS")), False, True)
                        custDet.FLG_NO_MARKETING = IIf(IsDBNull(dtrow("FLG_NO_MARKETING")), False, dtrow("FLG_NO_MARKETING").ToString())
                        custDet.FLG_NO_HUMANEORG = IIf(IsDBNull(dtrow("FLG_NO_HUMANEORG")), False, dtrow("FLG_NO_HUMANEORG").ToString())
                        custDet.FLG_NO_PHONESALE = IIf(IsDBNull(dtrow("FLG_NO_PHONESALE")), False, dtrow("FLG_NO_PHONESALE").ToString())
                        custDet.FLG_PRIVATE_COMP = IIf(IsDBNull(dtrow("FLG_PRIVATE_COMP")), False, dtrow("FLG_PRIVATE_COMP").ToString())
                        custDet.FLG_NO_GM = IIf(IsDBNull(dtrow("FLG_NO_GM")), False, dtrow("FLG_NO_GM").ToString())
                        custDet.FLG_NO_ENV_FEE = IIf(IsDBNull(dtrow("FLG_NO_ENV_FEE")), False, dtrow("FLG_NO_ENV_FEE").ToString())
                        custDet.FLG_NO_EMAIL = IIf(IsDBNull(dtrow("FLG_NO_EMAIL")), False, dtrow("FLG_NO_EMAIL").ToString())
                        custDet.FLG_PROSPECT = IIf(IsDBNull(dtrow("FLG_PROSPECT")), False, dtrow("FLG_PROSPECT").ToString())
                        custDet.CUST_NOTES = IIf(IsDBNull(dtrow("CUST_NOTES")), False, dtrow("CUST_NOTES").ToString())

                        custDet.CUST_DISC_GENERAL = dtrow("CUST_DISC_GENERAL").ToString()
                        custDet.CUST_DISC_LABOUR = dtrow("CUST_DISC_LABOUR").ToString()
                        custDet.CUST_DISC_SPARES = dtrow("CUST_DISC_SPARES").ToString()
                        custDet.ENIRO_ID = dtrow("CUST_ENIRO_ID").ToString()
                        custDet.CUST_BORN = dtrow("DT_CUST_BORN").ToString()
                        custDet.CUST_COMPANY_NO = dtrow("CUST_COMPANY_NO").ToString()
                        custDet.CUST_COMPANY_DESCRIPTION = dtrow("CUST_COMPANY_DESCRIPTION").ToString()
                        If custDet.CUST_BORN <> "" Then
                            custDet.CUST_BORN = objCommonUtil.GetCurrentLanguageDate(custDet.CUST_BORN)
                        End If



                        retCustomer.Add(custDet)
                    Next
                End If
            Catch ex As Exception
                Throw ex
            End Try
            Return retCustomer
        End Function

        Public Function InsertCustomerTemplate(ByVal custID As CustomerBO) As String()
            Dim strResult As String = ""
            Dim strArray As Array
            Dim login As String = HttpContext.Current.Session("UserID")
            Try
                strResult = objCustDO.InsertCustomerTemplate(custID, login)
                strArray = strResult.Split(";")
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.Vehicle", "Add_Vehicle", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strArray
        End Function

        Public Function FetchContactType() As List(Of CustomerBO)
            Dim dsFetchContactType As New DataSet
            Dim dtFetchContactType As DataTable
            Dim ContactType As New List(Of CustomerBO)()
            Try
                dsFetchContactType = objCustDO.FetchContactType()
                dtFetchContactType = dsFetchContactType.Tables(0)
                'HttpContext.Current.Session("dvSubsidiaryList") = dtSubDetails.DefaultView
                For Each dtrow As DataRow In dtFetchContactType.Rows
                    Dim contactTypeDet As New CustomerBO()
                    contactTypeDet.CONTACT_TYPE = dtrow("CONTACT_CODE_TYPE").ToString()
                    contactTypeDet.CONTACT_DESCRIPTION = dtrow("CONTACT_CODE_DESCRIPTION").ToString()
                    ContactType.Add(contactTypeDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Vehicle.vb", "FetchWarranty", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return ContactType.ToList
        End Function

        Public Function Add_CustomerContact(ByVal objCustBO As CustomerBO, ByVal seq As String)
            Dim strResult As String = ""
            Try
                strResult = objCustDO.Add_CustomerContact(objCustBO, seq).ToString()
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.Customer", "Add_CustomerContact", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strResult
        End Function

        Public Function Add_CustomerContactPerson(ByVal objCustBO As CustomerBO.ContactPerson)
            Dim strResult As String = ""
            Try
                strResult = objCustDO.Add_CustomerContactPerson(objCustBO, HttpContext.Current.Session("UserID"))
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.Customer", "Add_CustomerContact", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strResult
        End Function
        Public Function Fetch_CustomerContactPerson(ByVal ID_CP As String, ByVal CP_CUSTOMER_ID As String)
            Dim ContactPerson As New List(Of CustomerBO.ContactPerson)()
            Dim dsCpDetails As New DataSet
            Dim dtCpDetails As New DataTable
            Dim objCustBO As New CustomerBO.ContactPerson

            Try
                dsCpDetails = objCustDO.Fetch_CustomerContactPerson(ID_CP, CP_CUSTOMER_ID)
                If dsCpDetails.Tables.Count > 0 Then
                    If dsCpDetails.Tables(0).Rows.Count > 0 Then
                        dtCpDetails = dsCpDetails.Tables(0)
                        For Each dtrow As DataRow In dtCpDetails.Rows
                            Dim cpDetails As New CustomerBO.ContactPerson()
                            cpDetails.ID_CP = dtrow("ID_CP").ToString()
                            cpDetails.CP_CUSTOMER_ID = dtrow("CP_CUSTOMER_ID").ToString()
                            cpDetails.CP_FIRST_NAME = dtrow("CP_FIRST_NAME").ToString()
                            cpDetails.CP_MIDDLE_NAME = dtrow("CP_MIDDLE_NAME").ToString()
                            cpDetails.CP_LAST_NAME = dtrow("CP_LAST_NAME").ToString()
                            cpDetails.CP_PERM_ADD = dtrow("CP_PERM_ADD").ToString()
                            cpDetails.CP_VISIT_ADD = dtrow("CP_VISIT_ADD").ToString()
                            cpDetails.CP_ZIP_CODE = dtrow("CP_ZIP_CODE").ToString()
                            cpDetails.CP_ZIP_CITY = dtrow("CP_ZIP_CITY").ToString()
                            cpDetails.CP_EMAIL = dtrow("CP_EMAIL").ToString()
                            cpDetails.CP_PHONE_PRIVATE = dtrow("CP_PHONE_PRIVATE").ToString()
                            cpDetails.CP_PHONE_MOBILE = dtrow("CP_PHONE_MOBILE").ToString()
                            cpDetails.CP_PHONE_FAX = dtrow("CP_PHONE_FAX").ToString()
                            cpDetails.CP_PHONE_WORK = dtrow("CP_PHONE_WORK").ToString()
                            cpDetails.CP_BIRTH_DATE = dtrow("CP_BIRTH_DATE").ToString()
                            cpDetails.CP_TITLE_CODE = dtrow("CP_TITLE_CODE").ToString()
                            cpDetails.CP_FUNCTION_CODE = dtrow("CP_FUNCTION_CODE").ToString()
                            cpDetails.CP_CONTACT = dtrow("CP_CONTACT").ToString()
                            cpDetails.CP_CAR_USER = dtrow("CP_CAR_USER").ToString()
                            cpDetails.CP_EMAIL_REF = dtrow("CP_EMAIL_REF").ToString()
                            cpDetails.CP_NOTES = dtrow("CP_NOTES").ToString()
                            cpDetails.CUSTOMER_CONTACT_PERSON = dtrow("CUSTOMER_CONTACT_PERSON").ToString()
                            ContactPerson.Add(cpDetails)

                        Next
                    End If

                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOHeader", "Fetch_Customer_Contact_Person", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return ContactPerson
        End Function

        Public Function Delete_CustomerContactPerson(ByVal ID_CP As String)
            Dim strResult As String = ""
            Try
                strResult = objCustDO.Delete_CustomerContactPerson(ID_CP).ToString()
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.Customer", "Delete_CustomerContactPerson", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strResult
        End Function
        Public Function Fetch_CCP_Title(ByVal q As String) As List(Of CustomerBO.ContactPersonTitle)
            Dim dsCCPTitle As New DataSet
            Dim dtCCPTitle As DataTable
            Dim CCPTitle As New List(Of CustomerBO.ContactPersonTitle)()
            Try
                dsCCPTitle = objCustDO.Fetch_CCP_Title(q)
                dtCCPTitle = dsCCPTitle.Tables(0)
                For Each dtrow As DataRow In dtCCPTitle.Rows
                    Dim CCPTitleDet As New CustomerBO.ContactPersonTitle()
                    CCPTitleDet.ID_CP_TITLE = dtrow("ID_CP_TITLE").ToString()
                    CCPTitleDet.TITLE_CODE = dtrow("TITLE_CODE").ToString()
                    CCPTitleDet.TITLE_DESCRIPTION = dtrow("TITLE_DESCRIPTION").ToString()
                    CCPTitle.Add(CCPTitleDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Customer.vb", "Fetch_CCP_Title", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return CCPTitle
        End Function

        Public Function Fetch_CCP_Function(ByVal q As String) As List(Of CustomerBO.ContactPersonFunction)
            Dim dsCCPFunction As New DataSet
            Dim dtCCPFunction As DataTable
            Dim CCPFunction As New List(Of CustomerBO.ContactPersonFunction)()
            Try
                dsCCPFunction = objCustDO.Fetch_CCP_Function(q)
                dtCCPFunction = dsCCPFunction.Tables(0)
                For Each dtrow As DataRow In dtCCPFunction.Rows
                    Dim CCPFunctionDet As New CustomerBO.ContactPersonFunction()
                    CCPFunctionDet.ID_CP_FUNCTION = dtrow("ID_CP_FUNCTION").ToString()
                    CCPFunctionDet.FUNCTION_CODE = dtrow("FUNCTION_CODE").ToString()
                    CCPFunctionDet.FUNCTION_DESCRIPTION = dtrow("FUNCTION_DESCRIPTION").ToString()
                    CCPFunction.Add(CCPFunctionDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Customer.vb", "Fetch_CCP_Title", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return CCPFunction
        End Function

        Public Function Delete_Contact(ByVal CustomerSeq As String)
            Dim strResult As String = ""
            Try
                strResult = objCustDO.Delete_Contact(CustomerSeq).ToString()
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.Customer", "Delete_Contact", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strResult
        End Function

        Public Function Standard_Contact(ByVal CustomerSeq As String)
            Dim strResult As String = ""
            Try
                strResult = objCustDO.Standard_Contact(CustomerSeq).ToString()
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.Customer", "Standard_Contact", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strResult
        End Function

        Public Function getCustomerContact(ByVal customerID As String) As List(Of CustomerBO)
            Dim dsGetCustomerContact As New DataSet
            Dim dtGetCustomerContact As DataTable
            Dim contactDetails As New List(Of CustomerBO)()
            Try
                dsGetCustomerContact = objCustDO.GetCurrencyType(customerID)
                dtGetCustomerContact = dsGetCustomerContact.Tables(0)
                'HttpContext.Current.Session("dvSubsidiaryList") = dtSubDetails.DefaultView
                For Each dtrow As DataRow In dtGetCustomerContact.Rows
                    Dim getCustomerContactDetails As New CustomerBO()
                    getCustomerContactDetails.CONTACT_TYPE = dtrow("CONTACT_CODE_TYPE").ToString()
                    getCustomerContactDetails.CONTACT_DESCRIPTION = dtrow("CONTACT_CODE_DESCRIPTION").ToString()
                    contactDetails.Add(getCustomerContactDetails)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Customer.vb", "GetCustomerContact", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return contactDetails.ToList
        End Function

        Public Function FetchContact(ByVal custId As String) As List(Of CustomerBO.ContactInformation)
            Dim dsFetchContact As New DataSet
            Dim dtFetchContact As DataTable
            Dim ContactDetInf As New List(Of CustomerBO.ContactInformation)()
            Try
                dsFetchContact = objCustDO.FetchContact(custId)
                dtFetchContact = dsFetchContact.Tables(0)
                'HttpContext.Current.Session("dvSubsidiaryList") = dtSubDetails.DefaultView
                For Each dtrow As DataRow In dtFetchContact.Rows
                    Dim contactDet As New CustomerBO.ContactInformation()
                    contactDet.id = dtrow("CONTACT_SEQ").ToString()
                    contactDet.type = dtrow("CONTACT_TYPE").ToString()
                    contactDet.description = dtrow("CONTACT_CODE_DESCRIPTION").ToString()
                    contactDet.value = dtrow("CONTACT_VALUE").ToString()
                    contactDet.standard = dtrow("CONTACT_STANDARD").ToString()
                    ContactDetInf.Add(contactDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Vehicle.vb", "FetchWarranty", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return ContactDetInf.ToList
        End Function
        Public Function GetCustomer(ByVal custName As String) As List(Of String)
            Dim dsCustomer As New DataSet
            Dim dtCustomer As DataTable
            Dim retCustomer As New List(Of String)()
            Try
                dsCustomer = objCustDO.GetCustomer(custName)

                If dsCustomer.Tables.Count > 0 Then
                    If dsCustomer.Tables(0).Rows.Count > 0 Then
                        dtCustomer = dsCustomer.Tables(0)
                    End If
                End If
                If custName <> String.Empty Then
                    For Each dtrow As DataRow In dtCustomer.Rows
                        retCustomer.Add(String.Format("{0}", dtrow("CUST_NAME")))
                    Next
                End If
            Catch ex As Exception
                Throw ex
            End Try
            Return retCustomer
        End Function
        Public Function Fetch_Cust_PriceCode_Details() As List(Of CustomerBO)
            Dim details As New List(Of CustomerBO)()
            Dim dsCustDetails As New DataSet
            Dim dtCustDetails As New DataTable
            Dim objCustBO As New CustomerBO

            Try
                dsCustDetails = objCustDO.Fetch_Cust_Config()
                If dsCustDetails.Tables.Count > 0 Then
                    If dsCustDetails.Tables(3).Rows.Count > 0 Then
                        dtCustDetails = dsCustDetails.Tables(3)
                        For Each dtrow As DataRow In dtCustDetails.Rows
                            Dim custDet As New CustomerBO()
                            custDet.Id_Settings = dtrow("ID_SETTINGS").ToString()
                            custDet.Description = dtrow("DESCRIPTION").ToString()
                            details.Add(custDet)
                        Next
                    End If

                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOHeader", "Fetch_WOH_Cust_Details", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function Fetch_Cust_DiscCode_Details() As List(Of CustomerBO)
            Dim details As New List(Of CustomerBO)()
            Dim dsCustDetails As New DataSet
            Dim dtCustDetails As New DataTable
            Dim objCustBO As New CustomerBO

            Try
                dsCustDetails = objCustDO.Fetch_Cust_Config()
                If dsCustDetails.Tables.Count > 0 Then
                    If dsCustDetails.Tables(5).Rows.Count > 0 Then
                        dtCustDetails = dsCustDetails.Tables(5)
                        For Each dtrow As DataRow In dtCustDetails.Rows
                            Dim custDet As New CustomerBO()
                            custDet.Id_Settings = dtrow("ID_SETTINGS").ToString()
                            custDet.Description = dtrow("DESCRIPTION").ToString()
                            details.Add(custDet)
                        Next
                    End If

                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOHeader", "Fetch_WOH_Cust_Details", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
    End Class

End Namespace

