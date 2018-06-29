Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports Microsoft.Practices.EnterpriseLibrary.Data.Sql
Imports System
Imports System.Configuration
Imports System.Data.Common
Imports Newtonsoft.Json
Imports Newtonsoft.Json.Linq
Imports System.IO
Imports CARS.CoreLibrary.CARS
Imports CARS.CoreLibrary
Imports System.Web.UI
Imports CARS.CoreLibrary.CARS.Services
Imports System.Reflection
Imports MSGCOMMON
Imports Encryption

Public Class CustomerDO
    Dim objDB As Database
    Dim ConnectionString As String
    Shared commonUtil As New Utilities.CommonUtility

    Public Sub New()
        ConnectionString = System.Configuration.ConfigurationManager.AppSettings("MSGConstr")
        objDB = New SqlDatabase(ConnectionString)
    End Sub

    Public Function Customer_Search(ByVal custName As String, ByVal isPrivate As String, ByVal isCompany As String) As DataSet
        Try
            Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_CUSTOMER_SEARCH")
                objDB.AddInParameter(objCMD, "@ID_SEARCH", DbType.String, custName)
                objDB.AddInParameter(objCMD, "@ISPRIVATE", DbType.Boolean, isPrivate)
                objDB.AddInParameter(objCMD, "@ISCOMPANY", DbType.Boolean, isCompany)
                Return objDB.ExecuteDataSet(objCMD)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function Fetch_Customer_Details(ByVal customerId As String) As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_CUSTOMER_DETAILS")
                objDB.AddInParameter(objcmd, "@ID_CUST", DbType.String, customerId)
                Return objDB.ExecuteDataSet(objcmd)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function Insert_Customer(ByVal objCustBO As CustomerBO, ByVal login As String) As String
        Try
            Dim strStatus As String

            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CUSTOMER_INSERT")
                'objDB.AddInParameter(objcmd, "@IV_VEH_REG_NO", DbType.String, objCustBO.VehRegNo)
                'objDB.AddInParameter(objcmd, "@CUST_CREDIT_LIMIT", DbType.Decimal, objCustBO.CUST_CREDIT_LIMIT)

                'objDB.AddOutParameter(objcmd, "@OV_RETVALUE", DbType.String, 50)
                'objDB.AddOutParameter(objcmd, "@OI_ID_VEH_SEQ", DbType.String, 50)
                objDB.AddInParameter(objcmd, "@ID_CUSTOMER", DbType.String, objCustBO.ID_CUSTOMER)
                objDB.AddInParameter(objcmd, "@CUST_NAME", DbType.String, objCustBO.CUST_NAME)
                objDB.AddInParameter(objcmd, "@CREATED_BY", DbType.String, login)
                objDB.AddInParameter(objcmd, "@MODIFIED_BY", DbType.String, login)
                objDB.AddInParameter(objcmd, "@CUST_LAST_NAME", DbType.String, objCustBO.CUST_LAST_NAME)
                objDB.AddInParameter(objcmd, "@CUST_MIDDLE_NAME", DbType.String, objCustBO.CUST_MIDDLE_NAME)
                objDB.AddInParameter(objcmd, "@CUST_FIRST_NAME", DbType.String, objCustBO.CUST_FIRST_NAME)
                objDB.AddInParameter(objcmd, "@CUST_PERM_ADD1", DbType.String, objCustBO.CUST_PERM_ADD1)
                'objDB.AddInParameter(objcmd, "@CUST_PERM_ADD2", DbType.String, objCustBO.CUST_PERM_ADD2)
                objDB.AddInParameter(objcmd, "@CUST_PERM_ADD2", DbType.String, "")
                objDB.AddInParameter(objcmd, "@CUST_BILL_ADD1", DbType.String, objCustBO.CUST_BILL_ADD1)
                'objDB.AddInParameter(objcmd, "@CUST_BILL_ADD2", DbType.String, objCustBO.CUST_BILL_ADD2)
                If objCustBO.ID_CP.Length > 0 Then objDB.AddInParameter(objcmd, "@ID_CP", DbType.String, objCustBO.ID_CP)
                objDB.AddInParameter(objcmd, "@CUST_BILL_ADD2", DbType.String, "")
                objDB.AddInParameter(objcmd, "@ID_CUST_PERM_ZIPCODE", DbType.String, objCustBO.ID_CUST_PERM_ZIPCODE)
                objDB.AddInParameter(objcmd, "@ID_CUST_BILL_ZIPCODE", DbType.String, objCustBO.ID_CUST_BILL_ZIPCODE)
                objDB.AddInParameter(objcmd, "@FLG_CUST_IGNOREINV", DbType.String, objCustBO.FLG_CUST_IGNOREINV)
                objDB.AddInParameter(objcmd, "@FLG_CUST_FACTORING", DbType.String, objCustBO.FLG_CUST_FACTORING)
                objDB.AddInParameter(objcmd, "@FLG_CUST_BATCHINV", DbType.String, objCustBO.FLG_CUST_BATCHINV)
                objDB.AddInParameter(objcmd, "@FLG_NO_GM", DbType.String, objCustBO.FLG_NO_GM)
                objDB.AddInParameter(objcmd, "@FLG_CUST_INACTIVE", DbType.String, objCustBO.FLG_CUST_INACTIVE)
                objDB.AddInParameter(objcmd, "@FLG_NO_ENV_FEE", DbType.String, objCustBO.FLG_NO_ENV_FEE)
                objDB.AddInParameter(objcmd, "@FLG_PROSPECT", DbType.String, objCustBO.FLG_PROSPECT)
                objDB.AddInParameter(objcmd, "@CUST_SSN_NO", DbType.String, objCustBO.CUST_SSN_NO)
                objDB.AddInParameter(objcmd, "@CUST_NOTES", DbType.String, objCustBO.CUST_NOTES)

                objDB.AddInParameter(objcmd, "@ISSAMEADDRESS", DbType.String, objCustBO.ISSAMEADDRESS)
                objDB.AddInParameter(objcmd, "@FLG_PRIVATE_COMP", DbType.String, objCustBO.FLG_PRIVATE_COMP)
                objDB.AddInParameter(objcmd, "@FLG_EINVOICE", DbType.String, objCustBO.FLG_EINVOICE)
                objDB.AddInParameter(objcmd, "@FLG_INV_EMAIL", DbType.String, objCustBO.FLG_INV_EMAIL)
                objDB.AddInParameter(objcmd, "@FLG_ORDCONF_EMAIL", DbType.String, objCustBO.FLG_ORDCONF_EMAIL)
                objDB.AddInParameter(objcmd, "@FLG_NO_SMS", DbType.String, objCustBO.FLG_NO_SMS)
                objDB.AddInParameter(objcmd, "@FLG_NO_EMAIL", DbType.String, objCustBO.FLG_NO_EMAIL)
                objDB.AddInParameter(objcmd, "@FLG_NO_MARKETING", DbType.String, objCustBO.FLG_NO_MARKETING)
                objDB.AddInParameter(objcmd, "@FLG_NO_HUMANEORG", DbType.String, objCustBO.FLG_NO_HUMANEORG)
                objDB.AddInParameter(objcmd, "@FLG_NO_PHONESALE", DbType.String, objCustBO.FLG_NO_PHONESALE)
                If objCustBO.CUST_DISC_GENERAL = "" Then
                    objCustBO.CUST_DISC_GENERAL = 0
                End If
                objDB.AddInParameter(objcmd, "@CUST_DISC_GENERAL", DbType.Int32, objCustBO.CUST_DISC_GENERAL)
                If objCustBO.CUST_DISC_LABOUR = "" Then
                    objCustBO.CUST_DISC_LABOUR = 0
                End If
                objDB.AddInParameter(objcmd, "@CUST_DISC_LABOUR", DbType.Int32, objCustBO.CUST_DISC_LABOUR)
                If objCustBO.CUST_DISC_SPARES = "" Then
                    objCustBO.CUST_DISC_SPARES = 0
                End If
                objDB.AddInParameter(objcmd, "@CUST_DISC_SPARES", DbType.Int32, objCustBO.CUST_DISC_SPARES)
                objDB.AddInParameter(objcmd, "@CUST_ENIRO_ID", DbType.String, objCustBO.ENIRO_ID)
                If objCustBO.CUST_BORN <> "01.01.0001" Then
                    objDB.AddInParameter(objcmd, "@DT_CUST_BORN", DbType.String, commonUtil.GetDefaultDate_MMDDYYYY(objCustBO.CUST_BORN))
                End If
                objDB.AddInParameter(objcmd, "@ID_CUST_GROUP", DbType.Int32, objCustBO.ID_CUST_GROUP)
                objDB.AddInParameter(objcmd, "@ID_CUST_PAY_TERM", DbType.Int32, objCustBO.ID_CUST_PAY_TERM)
                objDB.AddInParameter(objcmd, "@ID_CUST_PAY_TYPE", DbType.Int32, objCustBO.ID_CUST_PAY_TYPE)
                objDB.AddInParameter(objcmd, "@ID_CUST_REG_CD", DbType.String, "62")
                objDB.AddInParameter(objcmd, "@ID_CUST_PC_CODE", DbType.String, "113")
                objDB.AddInParameter(objcmd, "@ID_CUST_DISC_CD", DbType.String, "135")
                objDB.AddInParameter(objcmd, "@CUST_PHONE_OFF", DbType.String, "")
                objDB.AddInParameter(objcmd, "@CUST_PHONE_HOME", DbType.String, "")
                objDB.AddInParameter(objcmd, "@CUST_PHONE_MOBILE", DbType.String, "")
                objDB.AddInParameter(objcmd, "@CUST_FAX", DbType.String, "999")
                objDB.AddInParameter(objcmd, "@CUST_REMARKS", DbType.String, "")
                objDB.AddInParameter(objcmd, "@CUST_ACCOUNT_NO", DbType.String, objCustBO.ID_CUSTOMER)
                objDB.AddInParameter(objcmd, "@ID_CUST_CURRENCY", DbType.String, "1")
                objDB.AddInParameter(objcmd, "@CUST_CREDIT_LIMIT", DbType.String, "0.00")
                objDB.AddInParameter(objcmd, "@CUST_COMPANY_NO", DbType.String, objCustBO.CUST_COMPANY_NO)
                objDB.AddInParameter(objcmd, "@CUST_COMPANY_DESCRIPTION", DbType.String, objCustBO.CUST_COMPANY_DESCRIPTION)
                objDB.AddOutParameter(objcmd, "@RETVAL", DbType.String, 10)
                objDB.AddOutParameter(objcmd, "@RETCUST", DbType.String, 15)
                Try
                    objDB.ExecuteNonQuery(objcmd)
                    'strStatus = "123"
                    strStatus = objDB.GetParameterValue(objcmd, "@RETVAL").ToString + ";" + objDB.GetParameterValue(objcmd, "@RETCUST").ToString

                Catch ex As Exception
                    Throw
                End Try
            End Using
            Return strStatus

        Catch ex As Exception
            Throw ex
        End Try

    End Function

    Public Function FetchCustomerGroup() As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_MAS_CUST_GROUP_RETRIEVE")
                Return objDB.ExecuteDataSet(objcmd)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function Company_List(ByVal q As String) As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_CUSTOMER_COMPANY_LIST")
                objDB.AddInParameter(objcmd, "@ID_CUST", DbType.String, q)
                Return objDB.ExecuteDataSet(objcmd)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function FetchSalesman() As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_USER_SALESMAN")
                Return objDB.ExecuteDataSet(objcmd)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetSalesman(ByVal loginId As String) As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_GET_USER_SALESMAN")
                objDB.AddInParameter(objcmd, "@IV_USER", DbType.String, loginId)
                Return objDB.ExecuteDataSet(objcmd)

            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function FetchBranch() As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_LOAD_CUSTOMER_BRANCH")
                Return objDB.ExecuteDataSet(objcmd)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetBranch(ByVal branchId As String) As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_GET_CUSTOMER_BRANCH")
                objDB.AddInParameter(objcmd, "@IV_BRANCHCODE", DbType.String, branchId)
                Return objDB.ExecuteDataSet(objcmd)

            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function FetchCategory() As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_LOAD_CUSTOMER_CATEGORY")
                Return objDB.ExecuteDataSet(objcmd)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetCategory(ByVal categoryId As String) As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_GET_CUSTOMER_CATEGORY")
                objDB.AddInParameter(objcmd, "@IV_CATEGORYCODE", DbType.String, categoryId)
                Return objDB.ExecuteDataSet(objcmd)

            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function FetchSalesGroup() As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_LOAD_CUSTOMER_SALESGROUP")
                Return objDB.ExecuteDataSet(objcmd)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetSalesGroup(ByVal salesgroupId As String) As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_GET_CUSTOMER_SALESGROUP")
                objDB.AddInParameter(objcmd, "@IV_SALESGROUPCODE", DbType.String, salesgroupId)
                Return objDB.ExecuteDataSet(objcmd)

            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function FetchPaymentTerms() As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_LOAD_CUSTOMER_PAYMENT_TERMS")
                Return objDB.ExecuteDataSet(objcmd)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetPaymentTerms(ByVal paymentTermsId As String) As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_GET_CUSTOMER_PAYMENT_TERMS")
                objDB.AddInParameter(objcmd, "@IV_PAYMENT_TERMS_CODE", DbType.String, paymentTermsId)
                Return objDB.ExecuteDataSet(objcmd)

            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function
    Public Function FetchCardType() As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_LOAD_CUSTOMER_CARD_TYPE")
                Return objDB.ExecuteDataSet(objcmd)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetCardType(ByVal cardTypeId As String) As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_GET_CUSTOMER_CARD_TYPE")
                objDB.AddInParameter(objcmd, "@IV_CARD_CODE", DbType.String, cardTypeId)
                Return objDB.ExecuteDataSet(objcmd)

            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function FetchCurrencyType() As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_LOAD_CUSTOMER_CURRENCY")
                Return objDB.ExecuteDataSet(objcmd)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetCurrencyType(ByVal currencyId As String) As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_GET_CUSTOMER_CURRENCY")
                objDB.AddInParameter(objcmd, "@IV_CURRENCY_CODE", DbType.String, currencyId)
                Return objDB.ExecuteDataSet(objcmd)

            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function Add_Branch(ByVal objCustBO As CustomerBO) As String
        Try
            Dim strStatus As String
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_INSERT_MAS_CUSTOMER_BRANCH")
                objDB.AddInParameter(objcmd, "@IV_BRANCH_CODE", DbType.String, objCustBO.BRANCH_CODE)
                objDB.AddInParameter(objcmd, "@IV_BRANCH_TEXT", DbType.String, objCustBO.BRANCH_TEXT)
                objDB.AddInParameter(objcmd, "@IV_BRANCH_NOTE", DbType.String, objCustBO.BRANCH_NOTE)
                objDB.AddInParameter(objcmd, "@IV_BRANCH_ANNOT", DbType.String, objCustBO.BRANCH_ANNOT)

                objDB.AddOutParameter(objcmd, "@OV_RETVALUE", DbType.String, 50)
                objDB.AddOutParameter(objcmd, "@OI_ID_VEH_SEQ", DbType.String, 50)
                Try
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@OV_RETVALUE").ToString
                Catch ex As Exception
                    Throw
                End Try
            End Using
            Return strStatus

        Catch ex As Exception
            Throw ex
        End Try

    End Function
    Public Function Delete_Branch(ByVal branchId As String) As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_DELETE_CUSTOMER_BRANCH")
                objDB.AddInParameter(objcmd, "@IV_BRANCHCODE", DbType.String, branchId)
                Return objDB.ExecuteDataSet(objcmd)

            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function Add_Category(ByVal objCustBO As CustomerBO) As String
        Try
            Dim strStatus As String
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_INSERT_MAS_CUSTOMER_CATEGORY")
                objDB.AddInParameter(objcmd, "@IV_CATEGORY_CODE", DbType.String, objCustBO.CATEGORY_CODE)
                objDB.AddInParameter(objcmd, "@IV_CATEGORY_TEXT", DbType.String, objCustBO.CATEGORY_TEXT)
                objDB.AddInParameter(objcmd, "@IV_CATEGORY_ANNOT", DbType.String, objCustBO.CATEGORY_ANNOT)

                objDB.AddOutParameter(objcmd, "@OV_RETVALUE", DbType.String, 50)
                objDB.AddOutParameter(objcmd, "@OI_ID_VEH_SEQ", DbType.String, 50)
                Try
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@OV_RETVALUE").ToString
                Catch ex As Exception
                    Throw
                End Try
            End Using
            Return strStatus

        Catch ex As Exception
            Throw ex
        End Try

    End Function

    Public Function Delete_Category(ByVal categoryId As String) As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_DELETE_CUSTOMER_CATEGORY")
                objDB.AddInParameter(objcmd, "@IV_CATEGORYCODE", DbType.String, categoryId)
                Return objDB.ExecuteDataSet(objcmd)

            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function Add_SalesGroup(ByVal objCustBO As CustomerBO) As String
        Try
            Dim strStatus As String
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_INSERT_MAS_CUSTOMER_SALESGROUP")
                objDB.AddInParameter(objcmd, "@IV_SALESGROUP_CODE", DbType.String, objCustBO.SALESGROUP_CODE)
                objDB.AddInParameter(objcmd, "@IV_SALESGROUP_TEXT", DbType.String, objCustBO.SALESGROUP_TEXT)
                objDB.AddInParameter(objcmd, "@IV_SALESGROUP_INV", DbType.String, objCustBO.SALESGROUP_INVESTMENT)
                objDB.AddInParameter(objcmd, "@IV_SALESGROUP_VAT", DbType.String, objCustBO.SALESGROUP_VAT)

                objDB.AddOutParameter(objcmd, "@OV_RETVALUE", DbType.String, 50)
                objDB.AddOutParameter(objcmd, "@OI_ID_VEH_SEQ", DbType.String, 50)
                Try
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@OV_RETVALUE").ToString
                Catch ex As Exception
                    Throw
                End Try
            End Using
            Return strStatus

        Catch ex As Exception
            Throw ex
        End Try

    End Function

    Public Function Delete_SalesGroup(ByVal salesgroupId As String) As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_DELETE_CUSTOMER_SALESGROUP")
                objDB.AddInParameter(objcmd, "@IV_SALESGROUPCODE", DbType.String, salesgroupId)
                Return objDB.ExecuteDataSet(objcmd)

            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function Add_PaymentTerms(ByVal objCustBO As CustomerBO) As String
        Try
            Dim strStatus As String
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_INSERT_MAS_CUSTOMER_PAYMENT_TERMS")
                objDB.AddInParameter(objcmd, "@IV_PAYTERMS_CODE", DbType.String, objCustBO.PAYMENT_TERMS_CODE)
                objDB.AddInParameter(objcmd, "@IV_PAYTERMS_TEXT", DbType.String, objCustBO.PAYMENT_TERMS_TEXT)
                objDB.AddInParameter(objcmd, "@IV_PAYTERMS_DAYS", DbType.Int32, objCustBO.PAYMENT_TERMS_DAYS)

                objDB.AddOutParameter(objcmd, "@OV_RETVALUE", DbType.String, 50)
                objDB.AddOutParameter(objcmd, "@OI_ID_VEH_SEQ", DbType.String, 50)
                Try
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@OV_RETVALUE").ToString
                Catch ex As Exception
                    Throw
                End Try
            End Using
            Return strStatus

        Catch ex As Exception
            Throw ex
        End Try

    End Function

    Public Function Delete_PaymentTerms(ByVal paymenttermsId As String) As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_DELETE_CUSTOMER_PAYMENT_TERMS")
                objDB.AddInParameter(objcmd, "@IV_PAYMENTTERMSCODE", DbType.String, paymenttermsId)
                Return objDB.ExecuteDataSet(objcmd)

            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function Add_CardType(ByVal objCustBO As CustomerBO) As String
        Try
            Dim strStatus As String
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_INSERT_MAS_CUSTOMER_CARD_TYPE")
                objDB.AddInParameter(objcmd, "@IV_CARDTYPE_CODE", DbType.String, objCustBO.CARD_TYPE_CODE)
                objDB.AddInParameter(objcmd, "@IV_CARDTYPE_TEXT", DbType.String, objCustBO.CARD_TYPE_TEXT)
                objDB.AddInParameter(objcmd, "@IV_CARDTYPE_CUSTNO", DbType.String, objCustBO.CARD_TYPE_CUSTNO)

                objDB.AddOutParameter(objcmd, "@OV_RETVALUE", DbType.String, 50)
                objDB.AddOutParameter(objcmd, "@OI_ID_VEH_SEQ", DbType.String, 50)
                Try
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@OV_RETVALUE").ToString
                Catch ex As Exception
                    Throw
                End Try
            End Using
            Return strStatus

        Catch ex As Exception
            Throw ex
        End Try

    End Function

    Public Function Delete_CardType(ByVal cardtypeId As String) As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_DELETE_CUSTOMER_CARD_TYPE")
                objDB.AddInParameter(objcmd, "@IV_CARDTYPECODE", DbType.String, cardtypeId)
                Return objDB.ExecuteDataSet(objcmd)

            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function Add_CurrencyType(ByVal objCustBO As CustomerBO) As String
        Try
            Dim strStatus As String
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_INSERT_MAS_CUSTOMER_CURRENCY_TYPE")
                objDB.AddInParameter(objcmd, "@IV_CURRENCY_CODE", DbType.String, objCustBO.CURRENCY_TYPE_CODE)
                objDB.AddInParameter(objcmd, "@IV_CURRENCY_TEXT", DbType.String, objCustBO.CURRENCY_TYPE_TEXT)
                objDB.AddInParameter(objcmd, "@IV_CURRENCY_RATE", DbType.Decimal, objCustBO.CURRENCY_TYPE_RATE)

                objDB.AddOutParameter(objcmd, "@OV_RETVALUE", DbType.String, 50)
                objDB.AddOutParameter(objcmd, "@OI_ID_VEH_SEQ", DbType.String, 50)
                Try
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@OV_RETVALUE").ToString
                Catch ex As Exception
                    Throw
                End Try
            End Using
            Return strStatus

        Catch ex As Exception
            Throw ex
        End Try

    End Function

    Public Function Delete_Currency(ByVal currencyId As String) As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_DELETE_CUSTOMER_CURRENCY")
                objDB.AddInParameter(objcmd, "@IV_CURRENCYCODE", DbType.String, currencyId)
                Return objDB.ExecuteDataSet(objcmd)

            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function LoadCustomerTemplate() As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_CUSTOMER_TEMPLATE")
                Return objDB.ExecuteDataSet(objcmd)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function FetchCustomerTemplate(ByVal tempId As String) As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_CUSTOMER_TEMPLATE_DATA")
                objDB.AddInParameter(objcmd, "@ID_CUST", DbType.String, tempId)
                Return objDB.ExecuteDataSet(objcmd)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function InsertCustomerTemplate(ByVal objCustBO As CustomerBO, ByVal login As String) As String
        Try
            Dim strStatus As String

            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CUSTOMER_TEMPLATE_INSERT")
                'objDB.AddInParameter(objcmd, "@IV_VEH_REG_NO", DbType.String, objCustBO.VehRegNo)
                'objDB.AddInParameter(objcmd, "@CUST_CREDIT_LIMIT", DbType.Decimal, objCustBO.CUST_CREDIT_LIMIT)

                'objDB.AddOutParameter(objcmd, "@OV_RETVALUE", DbType.String, 50)
                'objDB.AddOutParameter(objcmd, "@OI_ID_VEH_SEQ", DbType.String, 50)
                objDB.AddInParameter(objcmd, "@ID_CUSTOMER", DbType.String, "01")
                objDB.AddInParameter(objcmd, "@CUST_NAME", DbType.String, "Kundemal")
                objDB.AddInParameter(objcmd, "@CREATED_BY", DbType.String, login)
                objDB.AddInParameter(objcmd, "@MODIFIED_BY", DbType.String, login)
                objDB.AddInParameter(objcmd, "@CUST_LAST_NAME", DbType.String, objCustBO.CUST_LAST_NAME)
                objDB.AddInParameter(objcmd, "@CUST_MIDDLE_NAME", DbType.String, objCustBO.CUST_MIDDLE_NAME)
                objDB.AddInParameter(objcmd, "@CUST_FIRST_NAME", DbType.String, objCustBO.CUST_FIRST_NAME)
                objDB.AddInParameter(objcmd, "@CUST_PERM_ADD1", DbType.String, objCustBO.CUST_PERM_ADD1)
                'objDB.AddInParameter(objcmd, "@CUST_PERM_ADD2", DbType.String, objCustBO.CUST_PERM_ADD2)
                objDB.AddInParameter(objcmd, "@CUST_PERM_ADD2", DbType.String, "")
                objDB.AddInParameter(objcmd, "@CUST_BILL_ADD1", DbType.String, objCustBO.CUST_BILL_ADD1)
                'objDB.AddInParameter(objcmd, "@CUST_BILL_ADD2", DbType.String, objCustBO.CUST_BILL_ADD2)
                objDB.AddInParameter(objcmd, "@CUST_BILL_ADD2", DbType.String, "")
                objDB.AddInParameter(objcmd, "@ID_CUST_PERM_ZIPCODE", DbType.String, objCustBO.ID_CUST_PERM_ZIPCODE)
                objDB.AddInParameter(objcmd, "@ID_CUST_BILL_ZIPCODE", DbType.String, objCustBO.ID_CUST_BILL_ZIPCODE)
                objDB.AddInParameter(objcmd, "@FLG_CUST_IGNOREINV", DbType.String, objCustBO.FLG_CUST_IGNOREINV)
                objDB.AddInParameter(objcmd, "@FLG_CUST_FACTORING", DbType.String, objCustBO.FLG_CUST_FACTORING)
                objDB.AddInParameter(objcmd, "@FLG_CUST_BATCHINV", DbType.String, objCustBO.FLG_CUST_BATCHINV)
                objDB.AddInParameter(objcmd, "@FLG_NO_GM", DbType.String, objCustBO.FLG_NO_GM)
                objDB.AddInParameter(objcmd, "@FLG_CUST_INACTIVE", DbType.String, objCustBO.FLG_CUST_INACTIVE)
                objDB.AddInParameter(objcmd, "@FLG_NO_ENV_FEE", DbType.String, objCustBO.FLG_NO_ENV_FEE)
                objDB.AddInParameter(objcmd, "@FLG_PROSPECT", DbType.String, objCustBO.FLG_PROSPECT)
                objDB.AddInParameter(objcmd, "@CUST_SSN_NO", DbType.String, objCustBO.CUST_SSN_NO)
                objDB.AddInParameter(objcmd, "@CUST_NOTES", DbType.String, objCustBO.CUST_NOTES)

                objDB.AddInParameter(objcmd, "@ISSAMEADDRESS", DbType.String, objCustBO.ISSAMEADDRESS)
                objDB.AddInParameter(objcmd, "@FLG_PRIVATE_COMP", DbType.String, objCustBO.FLG_PRIVATE_COMP)
                objDB.AddInParameter(objcmd, "@FLG_EINVOICE", DbType.String, objCustBO.FLG_EINVOICE)
                objDB.AddInParameter(objcmd, "@FLG_INV_EMAIL", DbType.String, objCustBO.FLG_INV_EMAIL)
                objDB.AddInParameter(objcmd, "@FLG_ORDCONF_EMAIL", DbType.String, objCustBO.FLG_ORDCONF_EMAIL)
                objDB.AddInParameter(objcmd, "@FLG_NO_SMS", DbType.String, objCustBO.FLG_NO_SMS)
                objDB.AddInParameter(objcmd, "@FLG_NO_EMAIL", DbType.String, objCustBO.FLG_NO_EMAIL)
                objDB.AddInParameter(objcmd, "@FLG_NO_MARKETING", DbType.String, objCustBO.FLG_NO_MARKETING)
                objDB.AddInParameter(objcmd, "@FLG_NO_HUMANEORG", DbType.String, objCustBO.FLG_NO_HUMANEORG)
                objDB.AddInParameter(objcmd, "@FLG_NO_PHONESALE", DbType.String, objCustBO.FLG_NO_PHONESALE)
                If objCustBO.CUST_DISC_GENERAL = "" Then
                    objCustBO.CUST_DISC_GENERAL = 0
                End If
                objDB.AddInParameter(objcmd, "@CUST_DISC_GENERAL", DbType.Int32, objCustBO.CUST_DISC_GENERAL)
                If objCustBO.CUST_DISC_LABOUR = "" Then
                    objCustBO.CUST_DISC_LABOUR = 0
                End If
                objDB.AddInParameter(objcmd, "@CUST_DISC_LABOUR", DbType.Int32, objCustBO.CUST_DISC_LABOUR)
                If objCustBO.CUST_DISC_SPARES = "" Then
                    objCustBO.CUST_DISC_SPARES = 0
                End If
                objDB.AddInParameter(objcmd, "@CUST_DISC_SPARES", DbType.Int32, objCustBO.CUST_DISC_SPARES)
                objDB.AddInParameter(objcmd, "@CUST_ENIRO_ID", DbType.String, objCustBO.ENIRO_ID)
                If objCustBO.CUST_BORN <> "01.01.0001" Then
                    objDB.AddInParameter(objcmd, "@DT_CUST_BORN", DbType.String, commonUtil.GetDefaultDate_MMDDYYYY(objCustBO.CUST_BORN))
                End If
                objDB.AddInParameter(objcmd, "@ID_CUST_GROUP", DbType.Int32, objCustBO.ID_CUST_GROUP)
                objDB.AddInParameter(objcmd, "@ID_CUST_PAY_TERM", DbType.Int32, objCustBO.ID_CUST_PAY_TERM)
                objDB.AddInParameter(objcmd, "@ID_CUST_PAY_TYPE", DbType.Int32, objCustBO.ID_CUST_PAY_TYPE)
                objDB.AddInParameter(objcmd, "@ID_CUST_REG_CD", DbType.String, "62")
                objDB.AddInParameter(objcmd, "@ID_CUST_PC_CODE", DbType.String, "113")
                objDB.AddInParameter(objcmd, "@ID_CUST_DISC_CD", DbType.String, "135")
                objDB.AddInParameter(objcmd, "@CUST_PHONE_OFF", DbType.String, "")
                objDB.AddInParameter(objcmd, "@CUST_PHONE_HOME", DbType.String, "")
                objDB.AddInParameter(objcmd, "@CUST_PHONE_MOBILE", DbType.String, "")
                objDB.AddInParameter(objcmd, "@CUST_FAX", DbType.String, "999")
                objDB.AddInParameter(objcmd, "@CUST_REMARKS", DbType.String, "")
                objDB.AddInParameter(objcmd, "@CUST_ACCOUNT_NO", DbType.String, objCustBO.ID_CUSTOMER)
                objDB.AddInParameter(objcmd, "@ID_CUST_CURRENCY", DbType.String, "1")
                objDB.AddInParameter(objcmd, "@CUST_CREDIT_LIMIT", DbType.String, "0.00")
                objDB.AddInParameter(objcmd, "@CUST_COMPANY_NO", DbType.String, objCustBO.CUST_COMPANY_NO)
                objDB.AddInParameter(objcmd, "@CUST_COMPANY_DESCRIPTION", DbType.String, objCustBO.CUST_COMPANY_DESCRIPTION)
                objDB.AddOutParameter(objcmd, "@RETVAL", DbType.String, 10)
                objDB.AddOutParameter(objcmd, "@RETCUST", DbType.String, 15)
                Try
                    objDB.ExecuteNonQuery(objcmd)
                    'strStatus = "123"
                    strStatus = objDB.GetParameterValue(objcmd, "@RETVAL").ToString + ";" + objDB.GetParameterValue(objcmd, "@RETCUST").ToString

                Catch ex As Exception
                    Throw
                End Try
            End Using
            Return strStatus

        Catch ex As Exception
            Throw ex
        End Try

    End Function

    Public Function FetchContactType() As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_CONTACT_TYPE")
                Return objDB.ExecuteDataSet(objcmd)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function
    Public Function FetchContact(ByVal custId As String) As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CUSTOMER_CONTACT_FETCH")
                objDB.AddInParameter(objcmd, "@ID_CUSTOMER", DbType.Int32, custId)
                Return objDB.ExecuteDataSet(objcmd)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function Add_CustomerContact(ByVal objCustBO As CustomerBO, ByVal seq As String)
        Try
            Dim strStatus As String
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CUSTOMER_CONTACT_INSERT")
                objDB.AddInParameter(objcmd, "@SEQ", DbType.Int32, Convert.ToInt32(IIf(seq = "", 0, seq)))
                objDB.AddInParameter(objcmd, "@CONT_CUSTID", DbType.Int32, Convert.ToInt32(objCustBO.ID_CUSTOMER))
                objDB.AddInParameter(objcmd, "@CONT_TYPE", DbType.Int32, objCustBO.CONTACT_TYPE)
                objDB.AddInParameter(objcmd, "@CONT_VALUE", DbType.String, objCustBO.CONTACT_DESCRIPTION)
                objDB.AddInParameter(objcmd, "@CONT_STANDARD", DbType.Boolean, objCustBO.CONTACT_STANDARD)
                objDB.AddInParameter(objcmd, "@CONT_USER", DbType.String, objCustBO.USER_LOGIN)

                objDB.AddOutParameter(objcmd, "@RETVAL", DbType.String, 50)
                'objDB.AddOutParameter(objcmd, "@RETSEQ", DbType.String, 50)
                Try
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@RETVAL").ToString
                Catch ex As Exception
                    Throw
                End Try
            End Using
            Return strStatus

        Catch ex As Exception
            Throw ex
        End Try

    End Function

    Public Function Add_CustomerContactPerson(ByVal objContactPerson As CustomerBO.ContactPerson, ByVal userlogin As String)
        Try
            Dim strStatus As String
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CUSTOMER_CONTACT_PERSON_INSERT")
                If objContactPerson.ID_CP.ToString.Length > 0 Then
                    objDB.AddInParameter(objcmd, "@ID_CP", DbType.String, Convert.ToString(objContactPerson.ID_CP))
                End If

                Dim test As String = objContactPerson.ID_CP.ToString.Length
                objDB.AddInParameter(objcmd, "@CP_CUSTOMER_ID", DbType.String, Convert.ToString(objContactPerson.CP_CUSTOMER_ID))
                objDB.AddInParameter(objcmd, "@CP_FIRST_NAME", DbType.String, Convert.ToString(objContactPerson.CP_FIRST_NAME))
                objDB.AddInParameter(objcmd, "@CP_MIDDLE_NAME", DbType.String, Convert.ToString(objContactPerson.CP_MIDDLE_NAME))
                objDB.AddInParameter(objcmd, "@CP_LAST_NAME", DbType.String, Convert.ToString(objContactPerson.CP_LAST_NAME))
                objDB.AddInParameter(objcmd, "@CP_PERM_ADD", DbType.String, Convert.ToString(objContactPerson.CP_PERM_ADD))
                objDB.AddInParameter(objcmd, "@CP_VISIT_ADD", DbType.String, Convert.ToString(objContactPerson.CP_VISIT_ADD))
                objDB.AddInParameter(objcmd, "@CP_ZIP_CODE", DbType.String, Convert.ToString(objContactPerson.CP_ZIP_CODE))
                objDB.AddInParameter(objcmd, "@CP_ZIP_CITY", DbType.String, Convert.ToString(objContactPerson.CP_ZIP_CITY))
                objDB.AddInParameter(objcmd, "@CP_EMAIL", DbType.String, Convert.ToString(objContactPerson.CP_EMAIL))
                If objContactPerson.CP_PHONE_PRIVATE.ToString.Length > 0 Then
                    objDB.AddInParameter(objcmd, "@CP_PHONE_PRIVATE", DbType.String, Convert.ToString(objContactPerson.CP_PHONE_PRIVATE))
                End If
                If objContactPerson.CP_PHONE_MOBILE.ToString.Length > 0 Then
                    objDB.AddInParameter(objcmd, "@CP_PHONE_MOBILE", DbType.String, Convert.ToString(objContactPerson.CP_PHONE_MOBILE))
                End If
                If objContactPerson.CP_PHONE_FAX.ToString.Length > 0 Then
                    objDB.AddInParameter(objcmd, "@CP_PHONE_FAX", DbType.String, Convert.ToString(objContactPerson.CP_PHONE_FAX))
                End If
                If objContactPerson.CP_PHONE_WORK.ToString.Length > 0 Then
                    objDB.AddInParameter(objcmd, "@CP_PHONE_WORK", DbType.String, Convert.ToString(objContactPerson.CP_PHONE_WORK))
                End If
                If objContactPerson.CP_BIRTH_DATE.ToString.Length > 0 Then
                    objDB.AddInParameter(objcmd, "@CP_BIRTH_DATE", DbType.String, Convert.ToString(objContactPerson.CP_BIRTH_DATE))
                End If
                If objContactPerson.CP_TITLE_CODE.ToString.Length > 0 Then
                    objDB.AddInParameter(objcmd, "@CP_TITLE_CODE", DbType.String, Convert.ToString(objContactPerson.CP_TITLE_CODE))
                End If
                If objContactPerson.CP_FUNCTION_CODE.ToString.Length > 0 Then
                    objDB.AddInParameter(objcmd, "@CP_FUNCTION_CODE", DbType.String, Convert.ToString(objContactPerson.CP_FUNCTION_CODE))
                End If
                objDB.AddInParameter(objcmd, "@CP_CONTACT", DbType.String, Convert.ToString(objContactPerson.CP_CONTACT))
                objDB.AddInParameter(objcmd, "@CP_CAR_USER", DbType.String, Convert.ToString(objContactPerson.CP_CAR_USER))
                objDB.AddInParameter(objcmd, "@CP_EMAIL_REF", DbType.String, Convert.ToString(objContactPerson.CP_EMAIL_REF))
                objDB.AddInParameter(objcmd, "@CP_NOTES", DbType.String, Convert.ToString(objContactPerson.CP_NOTES))
                objDB.AddInParameter(objcmd, "@CONT_USER", DbType.String, Convert.ToString(userlogin))
                objDB.AddOutParameter(objcmd, "@RETVAL", DbType.String, 10)
                Try
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@RETVAL").ToString
                Catch ex As Exception
                    Throw ex
                End Try
            End Using
            Return strStatus
        Catch ex As Exception
            Throw ex
        End Try
    End Function
    Public Function Fetch_CustomerContactPerson(ByVal ID_CP As String, ByVal CP_CUSTOMER_ID As String) As DataSet
        Try
            Dim dsContactPerson As New DataSet
            Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_CUSTOMER_CONTACT_PERSON_FETCH")
                If ID_CP.Length > 0 Then objDB.AddInParameter(objCMD, "@ID_CP", DbType.String, ID_CP)
                If CP_CUSTOMER_ID.Length > 0 Then objDB.AddInParameter(objCMD, "@CP_CUSTOMER_ID", DbType.String, CP_CUSTOMER_ID)
                Return objDB.ExecuteDataSet(objCMD)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function
    Public Function Fetch_CCP_Title(ByVal q As String) As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CUSTOMER_CONTACT_PERSON_TITLE_FETCH")
                objDB.AddInParameter(objcmd, "@q", DbType.String, q)
                Return objDB.ExecuteDataSet(objcmd)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function
    Public Function Fetch_CCP_Function(ByVal q As String) As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CUSTOMER_CONTACT_PERSON_FUNCTION_FETCH")
                If q.Length > 0 Then objDB.AddInParameter(objcmd, "@q", DbType.String, q)
                Return objDB.ExecuteDataSet(objcmd)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function CCP_Function_Insert(ByVal code As String, ByVal description As String, ByVal user As String) As String
        Dim returnValue As String
        Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CUSTOMER_CONTACT_PERSON_FUNCTION_INSERT")
            objDB.AddInParameter(objcmd, "@code", DbType.String, code)
            objDB.AddInParameter(objcmd, "@description", DbType.String, description)
            objDB.AddInParameter(objcmd, "@user", DbType.String, user)
            objDB.AddOutParameter(objcmd, "@id", DbType.String, 10)
            objDB.AddOutParameter(objcmd, "@retval", DbType.String, 10)
            Try
                objDB.ExecuteNonQuery(objcmd)
                returnValue = objDB.GetParameterValue(objcmd, "@retval").ToString + ";" + objDB.GetParameterValue(objcmd, "@id").ToString
                Return returnValue
            Catch ex As Exception
                Throw ex
            End Try
        End Using
    End Function

    Public Function CCP_Title_Insert(ByVal code As String, ByVal description As String, ByVal user As String) As String
        Dim returnValue As String
        Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CUSTOMER_CONTACT_PERSON_TITLE_INSERT")
            objDB.AddInParameter(objcmd, "@code", DbType.String, code)
            objDB.AddInParameter(objcmd, "@description", DbType.String, description)
            objDB.AddInParameter(objcmd, "@user", DbType.String, user)
            objDB.AddOutParameter(objcmd, "@id", DbType.String, 10)
            objDB.AddOutParameter(objcmd, "@retval", DbType.String, 10)
            Try
                objDB.ExecuteNonQuery(objcmd)
                returnValue = objDB.GetParameterValue(objcmd, "@retval").ToString + ";" + objDB.GetParameterValue(objcmd, "@id").ToString
                Return returnValue
            Catch ex As Exception
                Throw ex
            End Try
        End Using
    End Function
    Public Function GetCustomer(ByVal custName As String) As DataSet
        Try
            Dim dsCustomer As New DataSet
            Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_CUSTOMER_SEARCH")
                objDB.AddInParameter(objCMD, "@ID_SEARCH", DbType.String, custName)
                dsCustomer = objDB.ExecuteDataSet(objCMD)
            End Using
            Return dsCustomer
        Catch ex As Exception
            Throw ex
        End Try
    End Function
    Public Function Delete_CustomerContactPerson(ByVal CustomerSeq As String)
        Try
            Dim strStatus As String
            Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_CUSTOMER_CONTACT_PERSON_DELETE")
                objDB.AddInParameter(objCMD, "@SEQ", DbType.String, CustomerSeq)
                objDB.AddOutParameter(objCMD, "@RETVAL", DbType.String, 50)
                Try
                    objDB.ExecuteNonQuery(objCMD)
                    strStatus = objDB.GetParameterValue(objCMD, "@RETVAL").ToString
                Catch ex As Exception
                    Throw
                End Try
            End Using
            Return strStatus
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function Delete_Contact(ByVal CustomerSeq As String)
        Try
            Dim strStatus As String
            Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_CUSTOMER_CONTACT_DELETE")
                objDB.AddInParameter(objCMD, "@SEQ", DbType.String, CustomerSeq)
                objDB.AddOutParameter(objCMD, "@RETVAL", DbType.String, 50)
                Try
                    objDB.ExecuteNonQuery(objCMD)
                    strStatus = objDB.GetParameterValue(objCMD, "@RETVAL").ToString
                Catch ex As Exception
                    Throw
                End Try
            End Using
            Return strStatus
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function Standard_Contact(ByVal CustomerSeq As String)
        Try
            Dim strStatus As String
            Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_CUSTOMER_CONTACT_STANDARD")
                objDB.AddInParameter(objCMD, "@SEQ", DbType.String, CustomerSeq)
                objDB.AddOutParameter(objCMD, "@RETVAL", DbType.String, 50)
                Try
                    objDB.ExecuteNonQuery(objCMD)
                    strStatus = objDB.GetParameterValue(objCMD, "@RETVAL").ToString
                Catch ex As Exception
                    Throw
                End Try
            End Using
            Return strStatus
        Catch ex As Exception
            Throw ex
        End Try
    End Function
    Public Function Fetch_Cust_Config() As DataSet
        Try
            Dim dsCustomer As New DataSet
            Using objCMD As DbCommand = objDB.GetStoredProcCommand("usp_MAS_CUST_CONFIG_LOAD")
                dsCustomer = objDB.ExecuteDataSet(objCMD)
            End Using
            Return dsCustomer
        Catch ex As Exception

            Throw ex
        End Try
    End Function
    Public Function Fetch_Customer(ByVal custId As String) As DataSet
        Try
            Dim dsCustomer As New DataSet
            Using objCMD As DbCommand = objDB.GetStoredProcCommand("usp_MAS_CUSTOMER_ALPHA_SEARCH_ALL")
                objDB.AddInParameter(objCMD, "@IV_CUSTINFOTXT", DbType.String, custId)
                dsCustomer = objDB.ExecuteDataSet(objCMD)
            End Using
            Return dsCustomer
        Catch ex As Exception

            Throw ex
        End Try
    End Function

End Class
