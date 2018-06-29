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
Namespace CARS.ConfigWarehouse
    Public Class ConfigWarehouseDO
        Dim ConnectionString As String
        Dim objDB As Database
        Dim strStatus As String
        Public Sub New()
            ConnectionString = System.Configuration.ConfigurationManager.AppSettings("MSGConstr")
            objDB = New SqlDatabase(ConnectionString)
        End Sub
        Public Function GetWarehouseDetails(ByVal loginName As String) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_SPR_CONFIG_WAREHOUSE_FETCH")
                    objDB.AddInParameter(objcmd, "@ID_USER", DbType.String, loginName)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function GetSubsideryName() As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_SPR_WH_SUBSIDERY_FETCH")
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function InsertWarehouse(ByVal objConfigWHBO As ConfigWarehouseBO) As String
            Dim dsInsertWarehouse As DataSet
            Dim strStatus As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_SPR_WAREHOUSE_INSERT")
                    objDB.AddInParameter(objcmd, "@IV_WHNAME", DbType.String, objConfigWHBO.WarehouseName)
                    objDB.AddInParameter(objcmd, "@IV_WHMGRNAME", DbType.String, objConfigWHBO.WarehouseManagerName)
                    objDB.AddInParameter(objcmd, "@IV_WHLOC", DbType.String, objConfigWHBO.WarehouseLocation)
                    objDB.AddInParameter(objcmd, "@IV_WHPHONE", DbType.String, objConfigWHBO.WarehousePhone)
                    objDB.AddInParameter(objcmd, "@IV_WHMOBILE", DbType.String, objConfigWHBO.WarehousePhoneMobile)
                    objDB.AddInParameter(objcmd, "@IV_WHIDZIPCODE", DbType.String, objConfigWHBO.WarehouseZipcode)
                    objDB.AddInParameter(objcmd, "@IV_WHADDRESS1", DbType.String, objConfigWHBO.WarehouseAddress1)
                    objDB.AddInParameter(objcmd, "@IV_WHADDRESS2", DbType.String, objConfigWHBO.WarehouseAddress2)
                    objDB.AddInParameter(objcmd, "@IV_IDSUBSIDERY", DbType.String, objConfigWHBO.WarehouseIDSubsidery)
                    objDB.AddInParameter(objcmd, "@IV_CREATEDBY", DbType.String, objConfigWHBO.WarehouseCreatedBy)
                    objDB.AddInParameter(objcmd, "@IV_WHCOUNTRY", DbType.String, objConfigWHBO.WarehouseCountry)
                    objDB.AddInParameter(objcmd, "@IV_WHSTATE", DbType.String, objConfigWHBO.WarehouseState)
                    objDB.AddInParameter(objcmd, "@IV_WHCITY", DbType.String, objConfigWHBO.WarehouseCity)
                    objDB.AddInParameter(objcmd, "@FLG_CONFIGZIPCODE", DbType.Boolean, objConfigWHBO.Flg_ConfigZipCode)
                    objDB.AddOutParameter(objcmd, "@ISSUCCESS", DbType.Boolean, 20)
                    objDB.AddOutParameter(objcmd, "@ERRMSG", DbType.String, 200)
                    dsInsertWarehouse = objDB.ExecuteDataSet(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@ISSUCCESS").ToString + ";" + objDB.GetParameterValue(objcmd, "@ERRMSG").ToString
                End Using
                Return strStatus
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function UpdateWarehouse(ByVal objConfigWHBO As ConfigWarehouseBO) As String
            Dim dsInsertWarehouse As DataSet
            Dim strStatus As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_SPR_WAREHOUSE_UPDATE")
                    objDB.AddInParameter(objcmd, "@IV_WHNAME", DbType.String, objConfigWHBO.WarehouseName)
                    objDB.AddInParameter(objcmd, "@IV_WHMGRNAME", DbType.String, objConfigWHBO.WarehouseManagerName)
                    objDB.AddInParameter(objcmd, "@IV_WHLOC", DbType.String, objConfigWHBO.WarehouseLocation)
                    objDB.AddInParameter(objcmd, "@IV_WHPHONE", DbType.String, objConfigWHBO.WarehousePhone)
                    objDB.AddInParameter(objcmd, "@IV_WHMOBILE", DbType.String, objConfigWHBO.WarehousePhoneMobile)
                    objDB.AddInParameter(objcmd, "@IV_WHIDZIPCODE", DbType.String, objConfigWHBO.WarehouseZipcode)
                    objDB.AddInParameter(objcmd, "@IV_WHADDRESS1", DbType.String, objConfigWHBO.WarehouseAddress1)
                    objDB.AddInParameter(objcmd, "@IV_WHADDRESS2", DbType.String, objConfigWHBO.WarehouseAddress2)
                    objDB.AddInParameter(objcmd, "@IV_IDSUBSIDERY", DbType.String, objConfigWHBO.WarehouseIDSubsidery)
                    objDB.AddInParameter(objcmd, "@IV_MODIFIEDBY", DbType.String, objConfigWHBO.WarehouseModifiedBy)
                    objDB.AddInParameter(objcmd, "@IV_WHID", DbType.Int32, objConfigWHBO.WarehouseID)
                    objDB.AddInParameter(objcmd, "@IV_WHCOUNTRY", DbType.String, objConfigWHBO.WarehouseCountry)
                    objDB.AddInParameter(objcmd, "@IV_WHSTATE", DbType.String, objConfigWHBO.WarehouseState)
                    objDB.AddInParameter(objcmd, "@IV_WHCITY", DbType.String, objConfigWHBO.WarehouseCity)
                    objDB.AddInParameter(objcmd, "@FLG_CONFIGZIPCODE", DbType.Boolean, objConfigWHBO.Flg_ConfigZipCode)
                    objDB.AddOutParameter(objcmd, "@ISSUCCESS", DbType.Boolean, 20)
                    objDB.AddOutParameter(objcmd, "@ERRMSG", DbType.String, 200)
                    dsInsertWarehouse = objDB.ExecuteDataSet(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@ISSUCCESS").ToString + ";" + objDB.GetParameterValue(objcmd, "@ERRMSG").ToString
                End Using
                Return strStatus
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function DeleteWarehouse(ByVal warehouseID As String) As String
            Dim dsInsertWarehouse As DataSet
            Dim strStatus As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_SPR_WAREHOUSE_DELETE")
                    objDB.AddInParameter(objcmd, "@IV_IDWH", DbType.Int32, warehouseID)
                    objDB.AddOutParameter(objcmd, "@ISSUCCESS", DbType.Boolean, 20)
                    objDB.AddOutParameter(objcmd, "@ERRMSG", DbType.String, 200)
                    objDB.AddOutParameter(objcmd, "@OV_WHNAME", DbType.String, 50)
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@ISSUCCESS").ToString + ";" + objDB.GetParameterValue(objcmd, "@ERRMSG").ToString + ";" + objDB.GetParameterValue(objcmd, "@OV_WHNAME").ToString
                End Using
                Return strStatus
            Catch ex As Exception
                Throw ex
            End Try
        End Function
    End Class
End Namespace
