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

Namespace CARS.Services.Supplier
    Public Class SupplierDetail
        Shared objSupplierBO As New SupplierBO
        Shared objSupplierDO As New SupplierDO
        Shared objVehicleDO As New VehicleDO
        Shared objVehicleBO As New VehicleBO
        Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
        Public Function Fetch_Supplier_Detail(supplierDetail As SupplierBO)
            Dim dsSupDetail As New DataSet
            Dim dtSupDetail As New DataTable
            Dim dtSupAdvanced As New DataTable
            Dim retSupplier As New List(Of SupplierBO)()
            Dim supDetails As New SupplierBO
            Try
                dsSupDetail = objSupplierDO.Fetch_Supplier_Details(supplierDetail)
                If dsSupDetail.Tables.Count > 0 Then
                    dtSupDetail = dsSupDetail.Tables(0)

                End If
                For Each dtrow As DataRow In dtSupDetail.Rows
                    supDetails.ID_SUPPLIER = dtrow("ID_SUPPLIER").ToString()
                    supDetails.SUP_Name = dtrow("SUP_Name").ToString()
                    supDetails.SUP_Contact_Name = dtrow("SUP_Contact_Name").ToString()
                    supDetails.SUP_Address1 = dtrow("SUP_Address1").ToString()
                    'supDetails.SUP_Address2 = dtrow("SUP_Address2").ToString()
                    supDetails.SUP_Zipcode = dtrow("SUP_Zipcode").ToString()
                    supDetails.SUP_ID_Email = dtrow("SUP_ID_Email").ToString()
                    supDetails.SUP_Phone_Off = dtrow("SUP_Phone_Off").ToString()
                    'supDetails.SUP_Phone_Mobile = dtrow("SUP_Phone_Mobile").ToString()
                    'supDetails.SUP_Phone_Res = dtrow("SUP_Phone_Res").ToString()
                    'supDetails.SUP_FAX = dtrow("SUP_FAX").ToString()
                    supDetails.CREATED_BY = dtrow("CREATED_BY").ToString()
                    supDetails.DT_CREATED = dtrow("DT_CREATED").ToString()
                    'supDetails.MODIFIED_BY = dtrow("MODIFIED_BY").ToString()
                    'supDetails.DT_MODIFIED = dtrow("DT_MODIFIED").ToString()
                    'supDetails.SUP_SSN = dtrow("SUP_SSN").ToString()
                    'supDetails.SUP_REGION = dtrow("SUP_REGION").ToString()
                    supDetails.SUP_BILLAddress1 = dtrow("SUP_BILLAddress1").ToString()
                    'supDetails.SUP_BILLaddress2 = dtrow("SUP_BILLAddress2").ToString()
                    supDetails.SUP_BILLZipcode = dtrow("SUP_BILLZipcode").ToString()
                    'supDetails.LEADTIME = dtrow("LEADTIME").ToString()
                    'supDetails.ORDER_FREQ = dtrow("ORDER_FREQ").ToString()
                    'supDetails.ID_ORDERTYPE = dtrow("ID_ORDERTYPE").ToString()
                    'supDetails.CLIENT_NO = dtrow("CLIENT_NO").ToString()
                    'supDetails.WARRANTY = dtrow("WARRANTY").ToString()
                    'supDetails.DESCRIPTION = dtrow("DESCRIPTION").ToString()
                    'supDetails.ORDERDAY_MON = dtrow("ORDERDAY_MON").ToString()
                    'supDetails.ORDERDAY_TUE = dtrow("ORDERDAY_TUE").ToString()
                    'supDetails.ORDERDAY_WED = dtrow("ORDERDAY_WED").ToString()
                    'supDetails.ORDERDAY_THU = dtrow("ORDERDAY_THU").ToString()
                    'supDetails.ORDERDAY_FRI = dtrow("ORDERDAY_FRI").ToString()
                    supDetails.SUPP_CURRENTNO = dtrow("SUPP_CURRENTNO").ToString()
                    supDetails.SUP_CITY = dtrow("SUP_CITY").ToString()
                    supDetails.SUP_COUNTRY = dtrow("SUP_COUNTRY").ToString()
                    supDetails.SUP_BILL_CITY = dtrow("SUP_BILL_CITY").ToString()
                    supDetails.SUP_BILL_COUNTRY = dtrow("SUP_BILL_COUNTRY").ToString()
                    supDetails.FLG_SAME_ADDRESS = dtrow("FLG_SAME_ADDRESS").ToString()
                    supDetails.SUP_WEBPAGE = dtrow("SUP_WEBPAGE").ToString()
                    supDetails.CURRENCY_CODE = dtrow("SUP_CURRENCY_CODE").ToString()


                    'itemDetails.FLG_STOCKITEM = IIf(IsDBNull(dtrow("FLG_STOCKITEM")), False, dtrow("FLG_STOCKITEM").ToString())


                    retSupplier.Add(supDetails)
                Next

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOHeader", "Fetch_Customer_Contact_Person", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return retSupplier
        End Function

        'Autocomplete function for spare part search
        Public Function Supplier_Search(ByVal q As String) As List(Of SupplierBO)
            Dim dsSupplier As New DataSet
            Dim dtSupplier As DataTable
            Dim supplierSearchResult As New List(Of SupplierBO)()
            Try
                dsSupplier = objSupplierDO.Supplier_Search(q)

                If dsSupplier.Tables.Count > 0 Then
                    dtSupplier = dsSupplier.Tables(0)
                End If
                If q <> String.Empty Then
                    For Each dtrow As DataRow In dtSupplier.Rows
                        Dim csr As New SupplierBO()
                        csr.ID_SUPPLIER = dtrow("ID_SUPPLIER").ToString
                        csr.SUP_Name = dtrow("SUP_Name").ToString
                        csr.SUPP_CURRENTNO = dtrow("SUPP_CURRENTNO").ToString
                        csr.SUP_CITY = dtrow("SUP_CITY").ToString



                        supplierSearchResult.Add(csr)
                    Next
                End If
            Catch ex As Exception
                Throw ex
            End Try
            Return supplierSearchResult
        End Function

        Public Function Insert_Supplier(ByVal supID As SupplierBO) As String()
            Dim strResult As String = ""
            Dim strArray As Array
            Dim login As String = HttpContext.Current.Session("UserID")
            Try
                strResult = objSupplierDO.Insert_Supplier(supID, login)
                strArray = strResult.Split(";")
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.Customer", "Insert_Customer", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strArray
        End Function

        'Autocomplete function for spare part search
        Public Function Currency_Search(ByVal q As String) As List(Of SupplierBO)
            Dim dsCurrency As New DataSet
            Dim dtCurrency As DataTable
            Dim currencySearchResult As New List(Of SupplierBO)()
            Try
                dsCurrency = objSupplierDO.Currency_Search(q)

                If dsCurrency.Tables.Count > 0 Then
                    dtCurrency = dsCurrency.Tables(0)
                End If
                If q <> String.Empty Then
                    For Each dtrow As DataRow In dtCurrency.Rows
                        Dim csr As New SupplierBO()
                        csr.ID_CURRENCY = dtrow("ID_CURRENCY").ToString
                        csr.CURRENCY_CODE = dtrow("CURRENCY_CODE").ToString
                        csr.CURRENCY_DESCRIPTION = dtrow("CURRENCY_DESCRIPTION").ToString
                        csr.CURRENCY_RATE = dtrow("CURRENCY_RATE").ToString



                        currencySearchResult.Add(csr)
                    Next
                End If
            Catch ex As Exception
                Throw ex
            End Try
            Return currencySearchResult
        End Function

        Public Function Fetch_Currency_Detail(currencyDetail As SupplierBO)

            Dim dsCurrDetail As New DataSet
            Dim dtCurrDetail As New DataTable

            Dim currDetails As New SupplierBO
            Try
                dsCurrDetail = objSupplierDO.Fetch_Currency_Details(currencyDetail)
                If dsCurrDetail.Tables.Count > 0 Then
                    dtCurrDetail = dsCurrDetail.Tables(0)
                End If
                For Each dtrow As DataRow In dtCurrDetail.Rows

                    currDetails.CURRENCY_CODE = dtrow("CURRENCY_CODE").ToString()
                    currDetails.CURRENCY_DESCRIPTION = dtrow("CURRENCY_DESCRIPTION").ToString()
                    currDetails.CURRENCY_RATE = dtrow("CURRENCY_RATE").ToString()
                    currDetails.CURRENCY_UNIT = dtrow("CURRENCY_UNIT").ToString()


                    'itemDetails.FLG_STOCKITEM = IIf(IsDBNull(dtrow("FLG_STOCKITEM")), False, dtrow("FLG_STOCKITEM").ToString())

                Next

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.WOHeader", "Fetch_Customer_Contact_Person", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return currDetails
        End Function

    End Class
End Namespace