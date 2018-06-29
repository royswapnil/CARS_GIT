Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports Microsoft.Practices.EnterpriseLibrary.Data.Sql
Imports System.Data.Common
Imports Newtonsoft.Json
Imports CARS.CoreLibrary.CARS
Public Class ItemsDO
    Shared commonUtil As New Utilities.CommonUtility
    Dim ConnectionString As String
    Dim objDB As Database
    Public Sub New()
        ConnectionString = System.Configuration.ConfigurationManager.AppSettings("MSGConstr")
        objDB = New SqlDatabase(ConnectionString)
    End Sub
    Public Function Fetch_Item_Details(ByVal objItem As ItemsBO) As DataSet
        Try
            Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_ITEM_FETCH")
                objDB.AddInParameter(objCMD, "@ID_ITEM_ID", DbType.String, objItem.ID_ITEM)
                objDB.AddInParameter(objCMD, "@ID_ITEM_MAKE", DbType.String, objItem.ID_MAKE)
                objDB.AddInParameter(objCMD, "@ID_ITEM_WH", DbType.String, objItem.ID_WH_ITEM)
                Return objDB.ExecuteDataSet(objCMD)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function LoadMakeCodes() As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_MAKE_FETCH")
                Return objDB.ExecuteDataSet(objcmd)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function
    Public Function LoadCategory(ByVal q As String) As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_CATEGORY_FETCH")
                objDB.AddInParameter(objcmd, "@ID_SUPPLIER", DbType.String, q)
                Return objDB.ExecuteDataSet(objcmd)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function LoadUnitItem() As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_ARTICLE_UNITMEAS")
                Return objDB.ExecuteDataSet(objcmd)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function SparePart_Search(ByVal sparePart As String) As DataSet
        Try
            Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_SPAREPART_SEARCH")
                objDB.AddInParameter(objCMD, "@ID_SEARCH", DbType.String, sparePart)
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
    Public Function Fetch_SparePart_Details(ByVal sparePartId As String) As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_SPAREPART_DETAILS")
                objDB.AddInParameter(objcmd, "@ID_SPARE", DbType.String, sparePartId)
                Return objDB.ExecuteDataSet(objcmd)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function Insert_SparePart(ByVal objItem As ItemsBO, ByVal login As String) As String
        Try
            Dim strStatus As String

            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_SPAREPART_INSERT")
                'objDB.AddInParameter(objcmd, "@IV_VEH_REG_NO", DbType.String, objCustBO.VehRegNo)
                'objDB.AddInParameter(objcmd, "@CUST_CREDIT_LIMIT", DbType.Decimal, objCustBO.CUST_CREDIT_LIMIT)

                'objDB.AddOutParameter(objcmd, "@OV_RETVALUE", DbType.String, 50)
                'objDB.AddOutParameter(objcmd, "@OI_ID_VEH_SEQ", DbType.String, 50)
                objDB.AddInParameter(objcmd, "@ID_ITEM", DbType.String, objItem.ID_ITEM)
                objDB.AddInParameter(objcmd, "@ITEM_DESC", DbType.String, objItem.ITEM_DESC)
                objDB.AddInParameter(objcmd, "@CREATED_BY", DbType.String, login)
                objDB.AddInParameter(objcmd, "@MODIFIED_BY", DbType.String, login)
                objDB.AddInParameter(objcmd, "@ID_MAKE", DbType.String, objItem.ID_MAKE)
                objDB.AddInParameter(objcmd, "@ID_WH_ITEM", DbType.String, objItem.ID_WH_ITEM)
                objDB.AddInParameter(objcmd, "@ID_SUPPLIER_ITEM", DbType.String, objItem.ID_SUPPLIER_ITEM)
                'objDB.AddInParameter(objcmd, "@ITEM_DISC_CODE", DbType.String, objItem.ITEM_DISC_CODE_BUY)
                If objItem.ITEM_DISC_CODE_BUY = "" Then
                    objDB.AddInParameter(objcmd, "@ITEM_DISC_CODE_BUY", DbType.String, "")
                Else
                    objDB.AddInParameter(objcmd, "@ITEM_DISC_CODE_BUY", DbType.String, objItem.ITEM_DISC_CODE_BUY)
                End If
                objDB.AddInParameter(objcmd, "@LOCATION", DbType.String, objItem.LOCATION)
                objDB.AddInParameter(objcmd, "@ALT_LOCATION", DbType.String, objItem.ALT_LOCATION)
                objDB.AddInParameter(objcmd, "@WEIGHT", DbType.String, objItem.WEIGHT)
                'objDB.AddInParameter(objcmd, "@ITEM_AVAIL_QTY", DbType.String, objItem.ITEM_AVAIL_QTY)
                If objItem.ITEM_AVAIL_QTY = "" Then
                    objDB.AddInParameter(objcmd, "@ITEM_AVAIL_QTY", DbType.String, 0.0)
                End If
                objDB.AddInParameter(objcmd, "@ANNOTATION", DbType.String, objItem.ANNOTATION)
                objDB.AddInParameter(objcmd, "@BASIC_PRICE", DbType.String, objItem.BASIC_PRICE)
                objDB.AddInParameter(objcmd, "@COST_PRICE1", DbType.String, objItem.COST_PRICE1)
                objDB.AddInParameter(objcmd, "@AVG_PRICE", DbType.String, objItem.AVG_PRICE)
                objDB.AddInParameter(objcmd, "@ITEM_PRICE", DbType.String, objItem.ITEM_PRICE)
                objDB.AddInParameter(objcmd, "@FLG_STOCKITEM", DbType.String, objItem.FLG_STOCKITEM)
                objDB.AddInParameter(objcmd, "@FLG_OBSOLETE_SPARE", DbType.String, objItem.FLG_OBSOLETE_SPARE)
                objDB.AddInParameter(objcmd, "@FLG_SAVE_TO_NONSTOCK", DbType.String, objItem.FLG_SAVE_TO_NONSTOCK)
                objDB.AddInParameter(objcmd, "@FLG_LABELS", DbType.String, objItem.FLG_LABELS)
                objDB.AddInParameter(objcmd, "@FLG_VAT_INCL", DbType.String, objItem.FLG_VAT_INCL)
                objDB.AddInParameter(objcmd, "@FLG_BLOCK_AUTO_ORD", DbType.String, objItem.FLG_BLOCK_AUTO_ORD)
                objDB.AddInParameter(objcmd, "@FLG_ALLOW_DISCOUNT", DbType.String, objItem.FLG_ALLOW_DISCOUNT)

                objDB.AddInParameter(objcmd, "@FLG_AUTO_ARRIVAL", DbType.String, objItem.FLG_AUTO_ARRIVAL)
                objDB.AddInParameter(objcmd, "@FLG_OBTAIN_SPARE", DbType.String, objItem.FLG_OBTAIN_SPARE)
                objDB.AddInParameter(objcmd, "@FLG_AUTOADJUST_PRICE", DbType.String, objItem.FLG_AUTOADJUST_PRICE)
                objDB.AddInParameter(objcmd, "@FLG_REPLACEMENT_PURCHASE", DbType.String, objItem.FLG_REPLACEMENT_PURCHASE)
                objDB.AddInParameter(objcmd, "@FLG_EFD", DbType.String, objItem.FLG_EFD)
                If objItem.DISCOUNT.ToString.Length > 0 Then
                    objDB.AddInParameter(objcmd, "@DISCOUNT", DbType.String, objItem.DISCOUNT)
                End If
                objDB.AddInParameter(objcmd, "@ID_UNIT_ITEM", DbType.String, objItem.ID_UNIT_ITEM)
                objDB.AddInParameter(objcmd, "@PACKAGE_QTY", DbType.String, objItem.PACKAGE_QTY)
                objDB.AddInParameter(objcmd, "@MIN_STOCK", DbType.String, objItem.MIN_STOCK)
                objDB.AddInParameter(objcmd, "@MAX_STOCK", DbType.String, objItem.MAX_STOCK)
                objDB.AddInParameter(objcmd, "@TEXT", DbType.String, objItem.TEXT)

                objDB.AddOutParameter(objcmd, "@RETVAL", DbType.String, 10)
                objDB.AddOutParameter(objcmd, "@RETSPARE", DbType.String, 15)
                Try
                    objDB.ExecuteNonQuery(objcmd)
                    'strStatus = "123"
                    strStatus = objDB.GetParameterValue(objcmd, "@RETVAL").ToString + ";" + objDB.GetParameterValue(objcmd, "@RETSPARE").ToString

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
    Public Function Fetch_VATCode() As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_VATCODE")
                Return objDB.ExecuteDataSet(objcmd)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function
    Public Function Fetch_EnvSparePart_Details(ByVal sparePartId As String, ByVal name As String, ByVal userId As String, ByVal idWh As String) As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_ENVSEARCHDETAILS")
                objDB.AddInParameter(objcmd, "@SPAREPART", DbType.String, sparePartId)
                objDB.AddInParameter(objcmd, "@NAME", DbType.String, name)
                objDB.AddInParameter(objcmd, "@IV_ID_LOGIN", DbType.String, userId)
                objDB.AddInParameter(objcmd, "@ID_WH", DbType.String, idWh)
                Return objDB.ExecuteDataSet(objcmd)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function
    Public Function Save_EnvFeeSettings(ByVal objItem As ItemsBO) As String
        Dim strStatus As String
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_SAVE_ENVFEESETTINGS")
                objDB.AddInParameter(objcmd, "@ID_ITEM", DbType.String, objItem.ID_ITEM)
                objDB.AddInParameter(objcmd, "@FLG_ENVFEE", DbType.String, Convert.ToBoolean(objItem.FLG_EFD))
                objDB.AddInParameter(objcmd, "@MIN_AMT", DbType.Decimal, objItem.MIN_AMT)
                objDB.AddInParameter(objcmd, "@MAX_AMT", DbType.Decimal, objItem.MAX_AMT)
                objDB.AddInParameter(objcmd, "@ADDED_FEE_PERCENTAGE", DbType.Decimal, objItem.ADDED_FEE_PERC)
                objDB.AddInParameter(objcmd, "@NAME", DbType.String, objItem.ENV_NAME)
                objDB.AddInParameter(objcmd, "@VAT_CODE", DbType.String, objItem.ENV_VATCODE)
                objDB.AddInParameter(objcmd, "@CREATED_BY", DbType.String, objItem.CREATED_BY)
                objDB.AddInParameter(objcmd, "@ID_MAKE", DbType.String, objItem.ENV_ID_MAKE)
                objDB.AddInParameter(objcmd, "@ID_WAREHOUSE", DbType.String, objItem.ENV_ID_WAREHOUSE)
                objDB.AddOutParameter(objcmd, "@FLG_RETURN", DbType.String, 10)
                Try
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@FLG_RETURN").ToString + "," + objDB.GetParameterValue(objcmd, "@FLG_RETURN").ToString
                Catch ex As Exception
                    Throw
                End Try
            End Using
            Return strStatus
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function Delete_EnvSparePart_Details(ByVal sparePartId As String, ByVal spMake As String, ByVal idWh As String) As String
        Dim strStatus As String
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_Del_EnvFeeDetails")
                objDB.AddInParameter(objcmd, "@SPNO", DbType.String, sparePartId)
                objDB.AddInParameter(objcmd, "@Make", DbType.String, spMake)
                objDB.AddInParameter(objcmd, "@WareHouseid", DbType.String, idWh)
                objDB.AddOutParameter(objcmd, "@FLG_RETURN", DbType.String, 10)
                objDB.ExecuteNonQuery(objcmd)
                strStatus = objDB.GetParameterValue(objcmd, "@FLG_RETURN").ToString + "," + objDB.GetParameterValue(objcmd, "@FLG_RETURN").ToString
            End Using
            Return strStatus
        Catch ex As Exception
            Throw ex
        End Try
    End Function
    Public Function LoadSupplier(ByVal supplier As String, ByVal login As String) As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_SPR_BO_SUPPLIER_FETCH")
                objDB.AddInParameter(objcmd, "@IV_CUST", DbType.String, supplier)
                objDB.AddInParameter(objcmd, "@IV_ID_LOGIN", DbType.String, login)
                Return objDB.ExecuteDataSet(objcmd)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function
    Public Function LoadDiscCodes(ByVal supplier As String) As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_SPR_DISCOUNTCODE_FETCH")
                objDB.AddInParameter(objcmd, "@ID_MAKE", DbType.String, IIf(supplier = "", Nothing, supplier))
                Return objDB.ExecuteDataSet(objcmd)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function
    Public Function LoadSparePartCategory() As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_SPR_SPAREPARTCATG_FETCH")
                objDB.AddInParameter(objcmd, "@IV_Lang", DbType.String, System.Configuration.ConfigurationManager.AppSettings("Language").ToString())
                Return objDB.ExecuteDataSet(objcmd)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function AddSpCatgDetails(ByVal objItem As ItemsBO) As String
        Dim strStatus As String
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_SPR_SPAREPARTCATG_INSERT")
                objDB.AddInParameter(objcmd, "@ID_DISCOUNTCODEBUY", DbType.Int32, objItem.ID_ITEM_DISC_CODE_BUYING)
                objDB.AddInParameter(objcmd, "@ID_DISCOUNTCODESELL", DbType.Int32, objItem.ID_ITEM_DISC_CODE_SELL)
                objDB.AddInParameter(objcmd, "@ID_SUPPLIER", DbType.Int32, objItem.ID_SUPPLIER_ITEM)
                objDB.AddInParameter(objcmd, "@ID_MAKE", DbType.String, objItem.ID_MAKE)
                objDB.AddInParameter(objcmd, "@CATEGORY", DbType.String, objItem.CATEGORY)
                objDB.AddInParameter(objcmd, "@DESCRIPTION", DbType.String, objItem.DESCRIPTION)
                objDB.AddInParameter(objcmd, "@INITIALCLASSCODE", DbType.String, objItem.INITIALCLASSCODE)
                objDB.AddInParameter(objcmd, "@VATCODE", DbType.String, objItem.ID_VAT_CODE)
                objDB.AddInParameter(objcmd, "@ACCOUNTCODE", DbType.String, objItem.ACCOUNT_CODE)
                objDB.AddInParameter(objcmd, "@FLG_ALLOWBO", DbType.Boolean, objItem.FLG_ALLOW_BCKORD)
                objDB.AddInParameter(objcmd, "@FLG_COUNTSTOCK", DbType.Boolean, objItem.FLG_CNT_STOCK)
                objDB.AddInParameter(objcmd, "@FLG_ALLOWCLASS", DbType.Boolean, objItem.FLG_ALLOW_CLASSIFICATION)
                objDB.AddInParameter(objcmd, "@CREATEDBY", DbType.String, objItem.CREATED_BY)
                objDB.AddOutParameter(objcmd, "@ISSUCCESS", DbType.Boolean, 10)
                objDB.AddOutParameter(objcmd, "@ERRMSG", DbType.String, 100)
                Try
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@ISSUCCESS").ToString + "," + objDB.GetParameterValue(objcmd, "@ERRMSG").ToString
                Catch ex As Exception
                    Throw
                End Try
            End Using
            Return strStatus
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function UpdSpCatgDetails(ByVal objItem As ItemsBO) As String
        Dim strStatus As String
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_SPR_SPAREPARTCATG_MODIFY")
                objDB.AddInParameter(objcmd, "@ID_DISCOUNTCODEBUY", DbType.Int32, objItem.ID_ITEM_DISC_CODE_BUYING)
                objDB.AddInParameter(objcmd, "@ID_DISCOUNTCODESELL", DbType.Int32, objItem.ID_ITEM_DISC_CODE_SELL)
                objDB.AddInParameter(objcmd, "@ID_SUPPLIER", DbType.Int32, objItem.ID_SUPPLIER_ITEM)
                objDB.AddInParameter(objcmd, "@ID_MAKE", DbType.String, objItem.ID_MAKE)
                objDB.AddInParameter(objcmd, "@CATEGORY", DbType.String, objItem.CATEGORY)
                objDB.AddInParameter(objcmd, "@DESCRIPTION", DbType.String, objItem.DESCRIPTION)
                objDB.AddInParameter(objcmd, "@INITIALCLASSCODE", DbType.String, objItem.INITIALCLASSCODE)
                objDB.AddInParameter(objcmd, "@VATCODE", DbType.String, objItem.ID_VAT_CODE)
                objDB.AddInParameter(objcmd, "@ACCOUNTCODE", DbType.String, objItem.ACCOUNT_CODE)
                objDB.AddInParameter(objcmd, "@FLG_ALLOWBO", DbType.Boolean, objItem.FLG_ALLOW_BCKORD)
                objDB.AddInParameter(objcmd, "@FLG_COUNTSTOCK", DbType.Boolean, objItem.FLG_CNT_STOCK)
                objDB.AddInParameter(objcmd, "@FLG_ALLOWCLASS", DbType.Boolean, objItem.FLG_ALLOW_CLASSIFICATION)
                objDB.AddInParameter(objcmd, "@MODIFIEDBY", DbType.String, objItem.CREATED_BY)
                objDB.AddOutParameter(objcmd, "@ISSUCCESS", DbType.Boolean, 10)
                objDB.AddOutParameter(objcmd, "@ERRMSG", DbType.String, 100)
                Try
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@ISSUCCESS").ToString + "," + objDB.GetParameterValue(objcmd, "@ERRMSG").ToString
                Catch ex As Exception
                    Throw
                End Try
            End Using
            Return strStatus
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function DeleteSpCatgDet(ByVal idItemCatg As String) As String
        Dim strStatus As String
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_SPR_SPAREPARTCATG_DELETE")
                objDB.AddInParameter(objcmd, "@ID_ITEM_CATG", DbType.String, idItemCatg)
                objDB.AddOutParameter(objcmd, "@ISSUCCESS", DbType.Boolean, 10)
                objDB.AddOutParameter(objcmd, "@ERRMSG", DbType.String, 100)
                objDB.ExecuteNonQuery(objcmd)
                strStatus = objDB.GetParameterValue(objcmd, "@ISSUCCESS").ToString + "," + objDB.GetParameterValue(objcmd, "@ERRMSG").ToString
            End Using
            Return strStatus
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function AddDiscCodeDetails(ByVal objItem As ItemsBO) As String
        Dim strStatus As String
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_SPR_DISCOUNTCODE_INSERT")
                objDB.AddInParameter(objcmd, "@ID_MAKE", DbType.String, objItem.SUPPLIER_NUMBER)
                objDB.AddInParameter(objcmd, "@DISCOUNTCODE", DbType.String, objItem.ITEM_DISC_CODE_BUYING)
                objDB.AddInParameter(objcmd, "@DESCRIPTION", DbType.String, objItem.DESCRIPTION)
                objDB.AddInParameter(objcmd, "@CREATED_BY", DbType.String, objItem.CREATED_BY)
                objDB.AddOutParameter(objcmd, "@ISSUCCESS", DbType.Boolean, 10)
                objDB.AddOutParameter(objcmd, "@ERRMSG", DbType.String, 200)
                Try
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@ISSUCCESS").ToString + "," + objDB.GetParameterValue(objcmd, "@ERRMSG").ToString
                Catch ex As Exception
                    Throw
                End Try
            End Using
            Return strStatus
        Catch ex As Exception
            Throw ex
        End Try
    End Function
    Public Function UpdDiscCodeDetails(ByVal objItem As ItemsBO) As String
        Dim strStatus As String
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_SPR_DISCOUNTCODE_MODIFY")
                objDB.AddInParameter(objcmd, "@ID_MAKE", DbType.String, objItem.SUPPLIER_NUMBER)
                objDB.AddInParameter(objcmd, "@DISCOUNTCODE", DbType.String, objItem.ITEM_DISC_CODE_BUYING)
                objDB.AddInParameter(objcmd, "@DESCRIPTION", DbType.String, objItem.DESCRIPTION)
                objDB.AddInParameter(objcmd, "@MODIFIED_BY", DbType.String, objItem.CREATED_BY)
                objDB.AddOutParameter(objcmd, "@ISSUCCESS", DbType.Boolean, 10)
                objDB.AddOutParameter(objcmd, "@ERRMSG", DbType.String, 200)
                Try
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@ISSUCCESS").ToString + "," + objDB.GetParameterValue(objcmd, "@ERRMSG").ToString
                Catch ex As Exception
                    Throw
                End Try
            End Using
            Return strStatus
        Catch ex As Exception
            Throw ex
        End Try
    End Function
    Public Function DeleteDiscCodeDetails(ByVal idItemCatg As String) As String
        Dim strStatus As String
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_SPR_DISCOUNTCODE_DELETE")
                objDB.AddInParameter(objcmd, "@ID_DISCOUNTCODE", DbType.String, idItemCatg)
                objDB.AddOutParameter(objcmd, "@ISSUCCESS", DbType.Boolean, 10)
                objDB.AddOutParameter(objcmd, "@ERRMSG", DbType.String, 200)
                objDB.ExecuteNonQuery(objcmd)
                strStatus = objDB.GetParameterValue(objcmd, "@ISSUCCESS").ToString + "," + objDB.GetParameterValue(objcmd, "@ERRMSG").ToString
            End Using
            Return strStatus
        Catch ex As Exception
            Throw ex
        End Try
    End Function
    Public Function SparePart_Popup(ByVal sparePart As String, ByVal mustHaveQuantity As String, ByVal isStockItem As String, ByVal isNotStockItem As String, ByVal loc As String, ByVal supp As String, ByVal nonStock As Boolean, ByVal accurateSearch As String) As DataSet
        Try
            If (nonStock) Then
                Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_SPAREPART_SEARCH_POPUP_NONSTOCK")
                    objDB.AddInParameter(objCMD, "@ID_SEARCH", DbType.String, sparePart)
                    objDB.AddInParameter(objCMD, "@SUPPLIER", DbType.String, supp)
                    Return objDB.ExecuteDataSet(objCMD)
                End Using
            Else
                Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_SPAREPART_SEARCH_POPUP")
                    objDB.AddInParameter(objCMD, "@ID_SEARCH", DbType.String, sparePart)
                    objDB.AddInParameter(objCMD, "@ID_MUSTHAVEQUANTITY", DbType.Boolean, mustHaveQuantity)
                    objDB.AddInParameter(objCMD, "@ID_ISSTOCKITEM", DbType.Boolean, isStockItem)
                    objDB.AddInParameter(objCMD, "@ID_ISNOTSTOCKITEM", DbType.Boolean, isNotStockItem)
                    objDB.AddInParameter(objCMD, "@LOCATION", DbType.String, loc)
                    objDB.AddInParameter(objCMD, "@SUPPLIER", DbType.String, supp)
                    objDB.AddInParameter(objCMD, "@ACCURATESEARCH", DbType.Boolean, accurateSearch)

                    Return objDB.ExecuteDataSet(objCMD)
                End Using
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Function

End Class