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
Public Class ConfigVehicleDO
    Dim objDB As Database
    Dim ConnectionString As String
    Shared commonUtil As New Utilities.CommonUtility

    Public Sub New()
        ConnectionString = System.Configuration.ConfigurationManager.AppSettings("MSGConstr")
        objDB = New SqlDatabase(ConnectionString)
    End Sub
    Public Function Fetch_Config() As DataSet
        Try
            Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_VEHICLE_CONFIG")
                objDB.AddInParameter(objCMD, "@iv_ID_CONFIG", DbType.String, "VEH-GROUP")
                objDB.AddInParameter(objCMD, "@iv_ID_CONFIG2", DbType.String, "LOC")
                objDB.AddInParameter(objCMD, "@iv_ID_CONFIG3", DbType.String, "HP-MAKE-PC")
                objDB.AddInParameter(objCMD, "@iv_ID_CONFIG4", DbType.String, "HP-VHG-PC")
                Return objDB.ExecuteDataSet(objCMD)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function
    Public Function UpdateMakeMG(ByVal strXmlVehMake As String, ByVal strXmlVehModel As String, ByVal IdLogin As String) As String
        Dim strStatus As String = ""
        Try
            Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_VEHICLE_MODIFY")
                objDB.AddInParameter(objCMD, "@IV_XMLMAKE", DbType.String, strXmlVehMake)
                objDB.AddInParameter(objCMD, "@IV_XMLMODELGROUP", DbType.String, strXmlVehModel)
                objDB.AddInParameter(objCMD, "@IV_CREATEDBY", DbType.String, IdLogin)
                objDB.AddOutParameter(objCMD, "@OV_RETVALUE", DbType.String, 10)
                objDB.AddOutParameter(objCMD, "@OV_CANNOTMODIFY", DbType.String, 500)
                objDB.AddOutParameter(objCMD, "@OV_MODIFYEDCFG", DbType.String, 500)
                objDB.ExecuteNonQuery(objCMD)
                strStatus = objDB.GetParameterValue(objCMD, "@OV_RETVALUE").ToString + ";" + objDB.GetParameterValue(objCMD, "@OV_CANNOTMODIFY").ToString + ";" + objDB.GetParameterValue(objCMD, "@OV_MODIFYEDCFG").ToString
                Return strStatus
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function
    Public Function SaveMake(ByVal strXmlVehMake As String, ByVal IdLogin As String) As String
        Dim strStatus As String = ""
        Try
            Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_MAKE_INSERT")
                objDB.AddInParameter(objCMD, "@iv_xmlDoc", DbType.String, strXmlVehMake)
                objDB.AddInParameter(objCMD, "@IV_CREATEDBY", DbType.String, IdLogin)
                objDB.AddOutParameter(objCMD, "@ov_RetValue", DbType.String, 10)
                objDB.AddOutParameter(objCMD, "@ov_CannotInsert", DbType.String, 500)
                objDB.AddOutParameter(objCMD, "@ov_Insertedcfg", DbType.String, 500)
                objDB.ExecuteNonQuery(objCMD)
                strStatus = objDB.GetParameterValue(objCMD, "@ov_RetValue").ToString + ";" + objDB.GetParameterValue(objCMD, "@ov_CannotInsert").ToString + ";" + objDB.GetParameterValue(objCMD, "@ov_Insertedcfg").ToString
                Return strStatus
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function
    Public Function SaveModel(ByVal strXmlVehModel As String, ByVal IdLogin As String) As String
        Dim strStatus As String = ""
        Try
            Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_Model_INSERT")
                objDB.AddInParameter(objCMD, "@iv_xmlDoc", DbType.String, strXmlVehModel)
                objDB.AddInParameter(objCMD, "@IV_CREATEDBY", DbType.String, IdLogin)
                objDB.AddOutParameter(objCMD, "@ov_RetValue", DbType.String, 10)
                objDB.AddOutParameter(objCMD, "@ov_CannotInsert", DbType.String, 500)
                objDB.AddOutParameter(objCMD, "@ov_Insertedcfg", DbType.String, 500)
                objDB.ExecuteNonQuery(objCMD)
                strStatus = objDB.GetParameterValue(objCMD, "@ov_RetValue").ToString + ";" + objDB.GetParameterValue(objCMD, "@ov_CannotInsert").ToString + ";" + objDB.GetParameterValue(objCMD, "@ov_Insertedcfg").ToString
                Return strStatus
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function
    Public Function UpdatevehGrp(ByVal strXmlVehGrp As String, ByVal IdLogin As String) As String
        Dim strStatus As String = ""
        Try
            Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_VEHGRPRICECODE_MODIFY")
                objDB.AddInParameter(objCMD, "@IV_XMLDOC", DbType.String, strXmlVehGrp)
                objDB.AddInParameter(objCMD, "@IV_CREATEDBY", DbType.String, IdLogin)
                objDB.AddOutParameter(objCMD, "@OV_RETVALUE", DbType.String, 10)
                objDB.AddOutParameter(objCMD, "@OV_CANNOTMODIFY", DbType.String, 500)
                objDB.AddOutParameter(objCMD, "@OV_MODIFYEDCFG", DbType.String, 500)
                objDB.ExecuteNonQuery(objCMD)
                strStatus = objDB.GetParameterValue(objCMD, "@OV_RETVALUE").ToString + ";" + objDB.GetParameterValue(objCMD, "@OV_CANNOTMODIFY").ToString + ";" + objDB.GetParameterValue(objCMD, "@OV_MODIFYEDCFG").ToString
                Return strStatus
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function
    Public Function saveVehGrp(ByVal strXmlVehGrp As String, ByVal IdLogin As String) As String
        Dim strStatus As String = ""
        Try
            Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_VEHGRPRICECODE_INSERT")
                objDB.AddInParameter(objCMD, "@IV_XMLDOC", DbType.String, strXmlVehGrp)
                objDB.AddInParameter(objCMD, "@iv_CreatedBy", DbType.String, IdLogin)
                objDB.AddOutParameter(objCMD, "@ov_RetValue", DbType.String, 10)
                objDB.AddOutParameter(objCMD, "@ov_CannotInsert", DbType.String, 500)
                objDB.AddOutParameter(objCMD, "@ov_Insertedcfg", DbType.String, 500)
                objDB.ExecuteNonQuery(objCMD)
                strStatus = objDB.GetParameterValue(objCMD, "@ov_RetValue").ToString + ";" + objDB.GetParameterValue(objCMD, "@ov_CannotInsert").ToString + ";" + objDB.GetParameterValue(objCMD, "@ov_Insertedcfg").ToString
                Return strStatus
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function
    Public Function SaveLocation(ByVal strXMLSettingsUpdate As String, ByVal IdLogin As String) As String
        Dim strStatus As String = ""
        Try
            Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_SETTINGS_INSERT")
                objDB.AddInParameter(objCMD, "@iv_xmlDoc", DbType.String, strXMLSettingsUpdate)
                objDB.AddInParameter(objCMD, "@iv_CreatedBy", DbType.String, IdLogin)
                objDB.AddOutParameter(objCMD, "@ov_RetValue", DbType.String, 10)
                objDB.AddOutParameter(objCMD, "@ov_CannotInsert", DbType.String, 500)
                objDB.AddOutParameter(objCMD, "@ov_Insertedcfg", DbType.String, 500)
                objDB.ExecuteNonQuery(objCMD)
                strStatus = objDB.GetParameterValue(objCMD, "@ov_RetValue").ToString + ";" + objDB.GetParameterValue(objCMD, "@ov_CannotInsert").ToString + ";" + objDB.GetParameterValue(objCMD, "@ov_Insertedcfg").ToString
                Return strStatus
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function
    Public Function UodateLocation(ByVal strXMLSettingsUpdate As String, ByVal IdLogin As String) As String
        Dim strStatus As String = ""
        Try
            Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_SETTINGS_MODIFY")
                objDB.AddInParameter(objCMD, "@IV_XMLDOC", DbType.String, strXMLSettingsUpdate)
                objDB.AddInParameter(objCMD, "@IV_CREATEDBY", DbType.String, IdLogin)
                objDB.AddOutParameter(objCMD, "@OV_RETVALUE", DbType.String, 10)
                objDB.AddOutParameter(objCMD, "@OV_CANNOTMODIFY", DbType.String, 500)
                objDB.AddOutParameter(objCMD, "@OV_MODIFYEDCFG", DbType.String, 500)
                objDB.ExecuteNonQuery(objCMD)
                strStatus = objDB.GetParameterValue(objCMD, "@OV_RETVALUE").ToString + ";" + objDB.GetParameterValue(objCMD, "@OV_CANNOTMODIFY").ToString + ";" + objDB.GetParameterValue(objCMD, "@OV_MODIFYEDCFG").ToString
                Return strStatus
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function
    Public Function DeleteConfigMake(ByVal strXMLDelMake As String) As String
        Dim strStatus As String = ""
        Try
            Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_VEHCONFIG_MAKE_DELETE")
                objDB.AddInParameter(objCMD, "@iv_xmlDoc", DbType.String, strXMLDelMake)
                objDB.AddOutParameter(objCMD, "@ov_RetValue", DbType.String, 10)
                objDB.AddOutParameter(objCMD, "@ov_CntDelete", DbType.String, 500)
                objDB.AddOutParameter(objCMD, "@ov_DeletedCfg", DbType.String, 500)
                objDB.ExecuteNonQuery(objCMD)
                strStatus = objDB.GetParameterValue(objCMD, "@OV_RETVALUE").ToString + "," + objDB.GetParameterValue(objCMD, "@ov_DeletedCfg").ToString + "," + objDB.GetParameterValue(objCMD, "@ov_CntDelete").ToString
                Return strStatus
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function
    Public Function DeleteConfigModel(ByVal strXMLDelModel As String) As String
        Dim strStatus As String = ""
        Try
            Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_VEHCONFIG_MODEL_DELETE")
                objDB.AddInParameter(objCMD, "@iv_xmlDoc", DbType.String, strXMLDelModel)
                objDB.AddOutParameter(objCMD, "@ov_RetValue", DbType.String, 10)
                objDB.AddOutParameter(objCMD, "@ov_CntDelete", DbType.String, 500)
                objDB.AddOutParameter(objCMD, "@ov_DeletedCfg", DbType.String, 500)
                objDB.ExecuteNonQuery(objCMD)
                strStatus = objDB.GetParameterValue(objCMD, "@OV_RETVALUE").ToString + "," + objDB.GetParameterValue(objCMD, "@ov_DeletedCfg").ToString + "," + objDB.GetParameterValue(objCMD, "@ov_CntDelete").ToString
                Return strStatus
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function
    Public Function Fetch_VEHConfiguration(ByVal IdUser As String) As DataSet
        Try
            Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_MAS_SHIFT_FETCH")
                objDB.AddInParameter(objCMD, "@iv_ID_CONFIG", DbType.String, "")
                objDB.AddInParameter(objCMD, "@iv_ID_CONFIG2", DbType.String, "")
                objDB.AddInParameter(objCMD, "@iv_ID_CONFIG3", DbType.String, "VAT")
                objDB.AddInParameter(objCMD, "@iv_ID_CONFIG4", DbType.String, "")
                objDB.AddInParameter(objCMD, "@iv_ID_CONFIG5", DbType.String, "")
                objDB.AddInParameter(objCMD, "@iv_ID_USER", DbType.String, IdUser)
                Return objDB.ExecuteDataSet(objCMD)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function
End Class
