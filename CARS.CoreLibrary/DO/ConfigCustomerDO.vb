Imports Microsoft.VisualBasic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports Microsoft.Practices.EnterpriseLibrary.Data.Sql
Imports System
Imports System.Configuration
Imports System.Data
Imports System.Data.Common
Imports System.Security.Cryptography
Imports System.IO
Imports CARS.CoreLibrary
Namespace CARS.ConfigCustomer
    Public Class ConfigCustomerDO
        Dim ConnectionString As String
        Dim objDB As Database
        Dim strStatus As String
        Dim commonUtil As Utilities.CommonUtility
        Public Sub New()
            ConnectionString = System.Configuration.ConfigurationManager.AppSettings("MSGConstr")
            objDB = New SqlDatabase(ConnectionString)
        End Sub
        Public Function Add_CustomerID(ByVal objConfigCustomerBO As ConfigCustomerBO) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_CUST_ID_INSERT")
                    objDB.AddInParameter(objcmd, "@II_START_NO", DbType.Int64, objConfigCustomerBO.Cust_Start)
                    objDB.AddInParameter(objcmd, "@II_END_NO", DbType.Int64, objConfigCustomerBO.Cust_End)
                    objDB.AddInParameter(objcmd, "@IV_CREATED_BY", DbType.String, objConfigCustomerBO.UserId)
                    objDB.AddOutParameter(objcmd, "@OV_STATUS", DbType.String, 10)
                    Try
                        objDB.ExecuteNonQuery(objcmd)
                        strStatus = objDB.GetParameterValue(objcmd, "@OV_STATUS").ToString
                    Catch ex As Exception
                        Throw
                    End Try
                End Using
                Return strStatus
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Fetch_CustomerConfiguration(ByVal UserId As String) As DataSet 'is same as Fetch_Customer
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_MAS_CUST_CONFIG_RETRIEVE")
                    objDB.AddInParameter(objcmd, "@ID_USER", DbType.String, UserId)
                    Try
                        Return objDB.ExecuteDataSet(objcmd)
                    Catch ex As Exception
                        Throw
                    End Try
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Insert_Config_CustGroup(ByVal Strxml As String, ByVal UserID As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_MAS_CUST_GROUP_INSERT")
                    objDB.AddInParameter(objcmd, "@iv_xmlDoc", DbType.String, Strxml)
                    objDB.AddInParameter(objcmd, "@iv_CreatedBy", DbType.String, UserID)
                    objDB.AddOutParameter(objcmd, "@ov_RetValue", DbType.String, 10)
                    objDB.AddOutParameter(objcmd, "@ov_CannotInsert", DbType.String, 500)
                    objDB.AddOutParameter(objcmd, "@ov_Insertedcfg", DbType.String, 500)
                    Try
                        objDB.ExecuteNonQuery(objcmd)
                        strStatus = CStr(objDB.GetParameterValue(objcmd, "@ov_RetValue") + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@ov_CannotInsert")), "", objDB.GetParameterValue(objcmd, "@ov_CannotInsert"))) + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@ov_Insertedcfg")), "", objDB.GetParameterValue(objcmd, "@ov_Insertedcfg"))))
                    Catch ex As Exception
                        Throw
                    End Try
                End Using
                Return strStatus
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Insert_Config_GaragePrice(ByVal Strxml As String, ByVal UserId As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_MAS_CUST_GARAGE_PRICE_ADD")
                    objDB.AddInParameter(objcmd, "@IV_XMLDOC", DbType.String, Strxml)
                    objDB.AddInParameter(objcmd, "@IV_CREATEDBY", DbType.String, UserId)
                    objDB.AddOutParameter(objcmd, "@OV_RETVALUE", DbType.String, 10)
                    objDB.AddOutParameter(objcmd, "@OV_CANNOTINSERT", DbType.String, 500)
                    objDB.AddOutParameter(objcmd, "@OV_INSERTEDCFG", DbType.String, 500)
                    Try
                        objDB.ExecuteNonQuery(objcmd)
                        strStatus = CStr(objDB.GetParameterValue(objcmd, "@ov_RetValue") + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@ov_CannotInsert")), "", objDB.GetParameterValue(objcmd, "@ov_CannotInsert"))) + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@ov_Insertedcfg")), "", objDB.GetParameterValue(objcmd, "@ov_Insertedcfg"))))
                    Catch ex As Exception
                        Throw
                    End Try
                End Using
                Return strStatus
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Insert_Config_PayTerm(ByVal Strxml As String, ByVal UserID As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_MAS_CUST_PAYTERMS_INSERT")
                    objDB.AddInParameter(objcmd, "@iv_xmlDoc", DbType.String, Strxml)
                    objDB.AddInParameter(objcmd, "@iv_CreatedBy", DbType.String, UserID)
                    objDB.AddOutParameter(objcmd, "@ov_RetValue", DbType.String, 10)
                    objDB.AddOutParameter(objcmd, "@ov_CannotInsert", DbType.String, 500)
                    objDB.AddOutParameter(objcmd, "@ov_Insertedcfg", DbType.String, 500)
                    Try
                        objDB.ExecuteNonQuery(objcmd)
                        strStatus = CStr(objDB.GetParameterValue(objcmd, "@ov_RetValue") + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@ov_CannotInsert")), "", objDB.GetParameterValue(objcmd, "@ov_CannotInsert"))) + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@ov_Insertedcfg")), "", objDB.GetParameterValue(objcmd, "@ov_Insertedcfg"))))

                    Catch ex As Exception
                        Throw
                    End Try
                End Using
                Return strStatus
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Delete_Config_CustGroup(ByVal Strxml As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_MAS_CUST_GROUP_DELETE")
                    objDB.AddInParameter(objcmd, "@iv_xmlDoc", DbType.String, Strxml)
                    objDB.AddOutParameter(objcmd, "@ov_RetValue", DbType.String, 10)
                    objDB.AddOutParameter(objcmd, "@ov_CntDelete", DbType.String, 500)
                    objDB.AddOutParameter(objcmd, "@ov_DeletedCfg", DbType.String, 500)
                    Try
                        objDB.ExecuteNonQuery(objcmd)
                        'strStatus = objDB.GetParameterValue(objcmd, "@ov_RetValue").ToString + "," + commonUtil.NullCheck(objDB.GetParameterValue(objcmd, "@ov_CntDelete").ToString) + "," + commonUtil.NullCheck(objDB.GetParameterValue(objcmd, "@ov_DeletedCfg").ToString)
                        strStatus = CStr(objDB.GetParameterValue(objcmd, "@ov_RetValue") + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@ov_DeletedCfg")), "", objDB.GetParameterValue(objcmd, "@ov_DeletedCfg"))) + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@ov_CntDelete")), "", objDB.GetParameterValue(objcmd, "@ov_CntDelete"))))

                    Catch ex As Exception
                        Throw
                    End Try
                End Using
                Return strStatus
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Delete_Config_PayTerm(ByVal Strxml As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_MAS_CUST_PAYTERMS_DELETE")
                    objDB.AddInParameter(objcmd, "@iv_xmlDoc", DbType.String, Strxml)
                    objDB.AddOutParameter(objcmd, "@ov_RetValue", DbType.String, 10)
                    objDB.AddOutParameter(objcmd, "@ov_CntDelete", DbType.String, 500)
                    objDB.AddOutParameter(objcmd, "@ov_DeletedCfg", DbType.String, 500)
                    Try
                        objDB.ExecuteNonQuery(objcmd)
                        strStatus = CStr(objDB.GetParameterValue(objcmd, "@ov_RetValue") + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@ov_DeletedCfg")), "", objDB.GetParameterValue(objcmd, "@ov_DeletedCfg"))) + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@ov_CntDelete")), "", objDB.GetParameterValue(objcmd, "@ov_CntDelete"))))
                    Catch ex As Exception
                        Throw
                    End Try
                End Using
                Return strStatus
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Delete_Config_GaragePrice(ByVal Strxml As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_MAS_CUST_GARAGE_PRICE_DELETE")
                    objDB.AddInParameter(objcmd, "@iv_xmlDoc", DbType.String, Strxml)
                    objDB.AddOutParameter(objcmd, "@ov_RetValue", DbType.String, 10)
                    objDB.AddOutParameter(objcmd, "@ov_CntDelete", DbType.String, 500)
                    objDB.AddOutParameter(objcmd, "@ov_DeletedCfg", DbType.String, 500)
                    Try
                        objDB.ExecuteNonQuery(objcmd)
                        'strStatus = objDB.GetParameterValue(objcmd, "@ov_RetValue").ToString + "," + commonUtil.NullCheck(objDB.GetParameterValue(objcmd, "@ov_CntDelete").ToString) + "," + commonUtil.NullCheck(objDB.GetParameterValue(objcmd, "@ov_DeletedCfg").ToString)
                        strStatus = CStr(objDB.GetParameterValue(objcmd, "@ov_RetValue") + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@ov_DeletedCfg")), "", objDB.GetParameterValue(objcmd, "@ov_DeletedCfg"))) + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@ov_CntDelete")), "", objDB.GetParameterValue(objcmd, "@ov_CntDelete"))))
                    Catch ex As Exception
                        Throw
                    End Try
                End Using
                Return strStatus
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function GetDefaultCurrency() As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_DEFAULT_CURRENCY_FETCH")
                    Try
                        Return objDB.ExecuteDataSet(objcmd)
                    Catch ex As Exception
                        Throw
                    End Try
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Fetch_Repair_Package() As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_REPAIR_PACKAGE_DETAILS")
                    Try
                        Return objDB.ExecuteDataSet(objcmd)
                    Catch ex As Exception
                        Throw
                    End Try
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Insert_CustRP(ByVal objConfigCustomerBO As ConfigCustomerBO) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_INSERT_REPAIR_PACKAGE_DETAILS")
                    objDB.AddInParameter(objcmd, "@ID_RP", DbType.Int64, objConfigCustomerBO.Id_Rp)
                    objDB.AddInParameter(objcmd, "@ID_CUSTOMER", DbType.Int64, objConfigCustomerBO.Id_Customer)
                    objDB.AddInParameter(objcmd, "@FLG_PRICE", DbType.Boolean, CBool(objConfigCustomerBO.Flg_Price))
                    objDB.AddInParameter(objcmd, "@PRICE", DbType.String, objConfigCustomerBO.Price)
                    objDB.AddInParameter(objcmd, "@USER_ID", DbType.String, objConfigCustomerBO.UserId)
                    objDB.AddOutParameter(objcmd, "@OV_RETVAL", DbType.String, 10)
                    Try
                        objDB.ExecuteNonQuery(objcmd)
                        strStatus = CStr(objDB.GetParameterValue(objcmd, "@OV_RETVAL"))

                    Catch ex As Exception
                        Throw
                    End Try
                End Using
                Return strStatus
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Update_CustRP(ByVal objConfigCustomerBO As ConfigCustomerBO) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_UPDATE_REPAIR_PACKAGE_DETAILS")
                    objDB.AddInParameter(objcmd, "@ID_RP", DbType.Int64, objConfigCustomerBO.Id_Rp)
                    objDB.AddInParameter(objcmd, "@ID_CUSTOMER", DbType.Int64, objConfigCustomerBO.Id_Customer)
                    objDB.AddInParameter(objcmd, "@FLG_PRICE", DbType.Boolean, CBool(objConfigCustomerBO.Flg_Price))
                    objDB.AddInParameter(objcmd, "@PRICE", DbType.String, objConfigCustomerBO.Price)
                    objDB.AddInParameter(objcmd, "@USER_ID", DbType.String, objConfigCustomerBO.UserId)
                    objDB.AddInParameter(objcmd, "@ID_MAP_SEQ", DbType.String, objConfigCustomerBO.Id_Map_Seq)
                    objDB.AddOutParameter(objcmd, "@OV_RETVAL", DbType.String, 10)
                    Try
                        objDB.ExecuteNonQuery(objcmd)
                        strStatus = CStr(objDB.GetParameterValue(objcmd, "@OV_RETVAL"))
                    Catch ex As Exception
                        Throw
                    End Try
                End Using
                Return strStatus
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Delete_CustRP(ByVal Strxml As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_DELETE_REPAIR_PACKAGE_DETAILS")
                    objDB.AddInParameter(objcmd, "@iv_xmlDoc", DbType.String, Strxml)
                    objDB.AddOutParameter(objcmd, "@OV_RETVALUE", DbType.String, 10)
                    Try
                        objDB.ExecuteNonQuery(objcmd)
                        strStatus = CStr(objDB.GetParameterValue(objcmd, "@ov_RetValue"))
                    Catch ex As Exception
                        Throw
                    End Try
                End Using
                Return strStatus
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Fetch_CustomerID() As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_CUST_ID")
                    Try
                        Return objDB.ExecuteDataSet(objcmd)
                    Catch ex As Exception
                        Throw
                    End Try
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Fetch_PayType() As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_PAYTYPE")
                    Try
                        Return objDB.ExecuteDataSet(objcmd)
                    Catch ex As Exception
                        Throw
                    End Try
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
    End Class
End Namespace

