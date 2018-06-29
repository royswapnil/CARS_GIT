Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports Microsoft.Practices.EnterpriseLibrary.Data.Sql
Imports System.Data.Common
Imports Newtonsoft.Json
Imports CARS.CoreLibrary.CARS
Public Class SupplierDO
    Shared commonUtil As New Utilities.CommonUtility
    Dim ConnectionString As String
    Dim objDB As Database
    Public Sub New()
        ConnectionString = System.Configuration.ConfigurationManager.AppSettings("MSGConstr")
        objDB = New SqlDatabase(ConnectionString)
    End Sub
    Public Function Fetch_Supplier_Details(ByVal objSupplier As SupplierBO) As DataSet
        Try
            Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_SPR_FETCH_SUPPLIER_DETAILS")
                objDB.AddInParameter(objCMD, "@ID_SUPPLIER", DbType.String, objSupplier.ID_SUPPLIER)
                Return objDB.ExecuteDataSet(objCMD)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function Supplier_Search(ByVal supplier As String) As DataSet
        Try
            Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_SPR_FETCH_SUPPLIER_LIST")
                objDB.AddInParameter(objCMD, "@ID_SEARCH", DbType.String, supplier)
                Return objDB.ExecuteDataSet(objCMD)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function Insert_Supplier(ByVal objItem As SupplierBO, ByVal login As String) As String
        Try
            Dim strStatus As String

            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_SUPPLIER_INSERT")

                objDB.AddInParameter(objcmd, "@ID_SUPPLIER", DbType.String, objItem.ID_SUPPLIER)

                objDB.AddInParameter(objcmd, "@SUP_Name", DbType.String, objItem.SUP_Name)
                objDB.AddInParameter(objcmd, "@SUP_Contact_Name", DbType.String, objItem.SUP_Contact_Name)
                objDB.AddInParameter(objcmd, "@SUP_Address1", DbType.String, objItem.SUP_Address1)
                objDB.AddInParameter(objcmd, "@SUP_Address2", DbType.String, objItem.SUP_Address2)
                objDB.AddInParameter(objcmd, "@SUP_Zipcode", DbType.String, objItem.SUP_Zipcode)
                objDB.AddInParameter(objcmd, "@SUP_ID_Email", DbType.String, objItem.SUP_ID_Email)
                objDB.AddInParameter(objcmd, "@SUP_Phone_Off", DbType.String, objItem.SUP_Phone_Off)
                objDB.AddInParameter(objcmd, "@SUP_Phone_Res", DbType.String, objItem.SUP_Phone_Res)
                objDB.AddInParameter(objcmd, "@SUP_FAX", DbType.String, objItem.SUP_FAX)
                objDB.AddInParameter(objcmd, "@SUP_Phone_Mobile", DbType.String, objItem.SUP_Phone_Mobile)
                objDB.AddInParameter(objcmd, "@CREATED_BY", DbType.String, login)
                objDB.AddInParameter(objcmd, "@MODIFIED_BY", DbType.String, login)
                objDB.AddInParameter(objcmd, "@SUP_SSN", DbType.String, objItem.SUP_SSN)
                objDB.AddInParameter(objcmd, "@SUP_REGION", DbType.String, objItem.SUP_REGION)
                objDB.AddInParameter(objcmd, "@SUP_BILLAddress1", DbType.String, objItem.SUP_BILLAddress1)
                objDB.AddInParameter(objcmd, "@SUP_BILLAddress2", DbType.String, objItem.SUP_BILLAddress2)
                objDB.AddInParameter(objcmd, "@SUP_BILLZipcode", DbType.String, objItem.SUP_BILLZipcode)
                objDB.AddInParameter(objcmd, "@LEADTIME", DbType.String, objItem.LEADTIME)
                objDB.AddInParameter(objcmd, "@ORDER_FREQ", DbType.String, objItem.ORDER_FREQ)
                objDB.AddInParameter(objcmd, "@ID_ORDERTYPE", DbType.String, objItem.ID_ORDERTYPE)
                objDB.AddInParameter(objcmd, "@CLIENT_NO", DbType.String, objItem.CLIENT_NO)
                objDB.AddInParameter(objcmd, "@WARRANTY", DbType.String, objItem.WARRANTY)
                objDB.AddInParameter(objcmd, "@DESCRIPTION", DbType.String, objItem.DESCRIPTION)
                objDB.AddInParameter(objcmd, "@ORDERDAY_MON", DbType.String, objItem.ORDERDAY_MON)
                objDB.AddInParameter(objcmd, "@ORDERDAY_TUE", DbType.String, objItem.ORDERDAY_TUE)
                objDB.AddInParameter(objcmd, "@ORDERDAY_WED", DbType.String, objItem.ORDERDAY_WED)
                objDB.AddInParameter(objcmd, "@ORDERDAY_THU", DbType.String, objItem.ORDERDAY_THU)
                objDB.AddInParameter(objcmd, "@ORDERDAY_FRI", DbType.String, objItem.ORDERDAY_FRI)
                objDB.AddInParameter(objcmd, "@SUPP_CURRENTNO", DbType.String, objItem.SUPP_CURRENTNO)
                objDB.AddInParameter(objcmd, "@SUP_CITY", DbType.String, objItem.SUP_CITY)
                objDB.AddInParameter(objcmd, "@SUP_COUNTRY", DbType.String, objItem.SUP_COUNTRY)
                objDB.AddInParameter(objcmd, "@SUP_BILL_CITY", DbType.String, objItem.SUP_BILL_CITY)
                objDB.AddInParameter(objcmd, "@SUP_BILL_COUNTRY", DbType.String, objItem.SUP_BILL_COUNTRY)
                objDB.AddInParameter(objcmd, "@FLG_SAME_ADDRESS", DbType.String, objItem.FLG_SAME_ADDRESS)
                objDB.AddInParameter(objcmd, "@SUP_WEBPAGE", DbType.String, objItem.SUP_WEBPAGE)
                objDB.AddInParameter(objcmd, "@SUP_CURRENCY_CODE", DbType.String, objItem.CURRENCY_CODE)


                'If objItem.ITEM_DISC_CODE_BUY = "" Then
                'objDB.AddInParameter(objcmd, "@ITEM_DISC_CODE_BUY", DbType.String, "")
                'Else
                'objDB.AddInParameter(objcmd, "@ITEM_DISC_CODE_BUY", DbType.String, objItem.ITEM_DISC_CODE_BUY)
                'End If


                objDB.AddOutParameter(objcmd, "@RETVAL", DbType.String, 10)
                objDB.AddOutParameter(objcmd, "@RETSUP", DbType.String, 15)
                Try
                    objDB.ExecuteNonQuery(objcmd)
                    'strStatus = "123"
                    strStatus = objDB.GetParameterValue(objcmd, "@RETVAL").ToString + ";" + objDB.GetParameterValue(objcmd, "@RETSUP").ToString
                    'strStatus = "UPDFLG;1161640"
                Catch ex As Exception
                    Throw
                End Try
            End Using
            Return strStatus

        Catch ex As Exception
            Throw ex
        End Try

    End Function
    Public Function FetchItemsHistory(ByVal ID_ITEM As String, ID_MAKE As String, ID_WAREHOUSE As Integer) As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_ITEM_HISTORY")
                objDB.AddInParameter(objcmd, "@ID_ITEM ", DbType.String, ID_ITEM)
                objDB.AddInParameter(objcmd, "@ID_MAKE ", DbType.String, ID_MAKE)
                objDB.AddInParameter(objcmd, "@ID_WAREHOUSE ", DbType.Int32, ID_WAREHOUSE)
                'test
                Return objDB.ExecuteDataSet(objcmd)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetEditMake(ByVal makeId As String) As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_GET_MAS_EDITMAKE")
                objDB.AddInParameter(objcmd, "@ID_MAKE", DbType.String, makeId)
                Return objDB.ExecuteDataSet(objcmd)

            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function


    Public Function Currency_Search(ByVal currency As String) As DataSet
        Try
            Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_GET_CURRENCY_LIST")
                objDB.AddInParameter(objCMD, "@ID_SEARCH", DbType.String, currency)
                Return objDB.ExecuteDataSet(objCMD)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function Fetch_Currency_Details(ByVal objItem As SupplierBO) As DataSet
        Try
            Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_GET_CUSTOMER_CURRENCY")
                objDB.AddInParameter(objCMD, "@IV_CURRENCY_CODE", DbType.String, objItem.CURRENCY_CODE)

                Return objDB.ExecuteDataSet(objCMD)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function
End Class