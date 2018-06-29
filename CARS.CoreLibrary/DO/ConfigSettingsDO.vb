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
Imports System.Web
Namespace CARS.ConfigSettings
    Public Class ConfigSettingsDO
        Dim ConnectionString As String
        Shared objCommonUtil As New CARS.Utilities.CommonUtility
        Dim objDB As Database
        Dim strStatus As String
        Public Sub New()
            ConnectionString = System.Configuration.ConfigurationManager.AppSettings("MSGConstr")
            objDB = New SqlDatabase(ConnectionString)
        End Sub

        Public Function InsertConfig(ByVal strXML As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_SETTINGS_INSERT")
                    objDB.AddInParameter(objcmd, "@iv_xmlDoc", DbType.String, strXML)
                    objDB.AddInParameter(objcmd, "@iv_CreatedBy", DbType.String, HttpContext.Current.Session("UserID"))
                    objDB.AddOutParameter(objcmd, "@ov_RetValue", DbType.String, 10)
                    objDB.AddOutParameter(objcmd, "@ov_CannotInsert", DbType.String, 2000)
                    objDB.AddOutParameter(objcmd, "@ov_Insertedcfg", DbType.String, 2000)
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = CStr(objDB.GetParameterValue(objcmd, "@ov_RetValue") + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@ov_CannotInsert")), "", objDB.GetParameterValue(objcmd, "@ov_CannotInsert"))) + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@ov_Insertedcfg")), "", objDB.GetParameterValue(objcmd, "@ov_Insertedcfg"))))
                    Return strStatus
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function

        Public Function UpdateConfig(ByVal strXML As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_SETTINGS_MODIFY")
                    objDB.AddInParameter(objcmd, "@IV_XMLDOC", DbType.String, strXML)
                    objDB.AddInParameter(objcmd, "@IV_CREATEDBY", DbType.String, HttpContext.Current.Session("UserID"))
                    objDB.AddOutParameter(objcmd, "@OV_RETVALUE", DbType.String, 10)
                    objDB.AddOutParameter(objcmd, "@OV_CANNOTMODIFY", DbType.String, 2000)
                    objDB.AddOutParameter(objcmd, "@OV_MODIFYEDCFG", DbType.String, 2000)
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = CStr(objDB.GetParameterValue(objcmd, "@OV_RETVALUE") + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@OV_CANNOTMODIFY")), "", objDB.GetParameterValue(objcmd, "@OV_CANNOTMODIFY"))) + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@OV_MODIFYEDCFG")), "", objDB.GetParameterValue(objcmd, "@OV_MODIFYEDCFG"))))
                    Return strStatus
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function

        Public Function UpdateConfigDetails(ByVal strXML As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_DETAILS_MODIFY")
                    objDB.AddInParameter(objcmd, "@IV_XMLDOC", DbType.String, strXML)
                    objDB.AddInParameter(objcmd, "@IV_CREATEDBY", DbType.String, HttpContext.Current.Session("UserID"))
                    objDB.AddOutParameter(objcmd, "@OV_RETVALUE", DbType.String, 10)
                    objDB.AddOutParameter(objcmd, "@OV_CANNOTMODIFY", DbType.String, 2000)
                    objDB.AddOutParameter(objcmd, "@OV_MODIFYEDCFG", DbType.String, 2000)
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = CStr(objDB.GetParameterValue(objcmd, "@OV_RETVALUE") + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@OV_CANNOTMODIFY")), "", objDB.GetParameterValue(objcmd, "@OV_CANNOTMODIFY"))) + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@OV_MODIFYEDCFG")), "", objDB.GetParameterValue(objcmd, "@OV_MODIFYEDCFG"))))
                    Return strStatus
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function DeleteConfig(ByVal strXML As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_SETTINGS_DELETE")
                    objDB.AddInParameter(objcmd, "@iv_xmlDoc", DbType.String, strXML)
                    objDB.AddOutParameter(objcmd, "@ov_RetValue", DbType.String, 10)
                    objDB.AddOutParameter(objcmd, "@ov_CntDelete", DbType.String, 2000)
                    objDB.AddOutParameter(objcmd, "@ov_DeletedCfg", DbType.String, 2000)
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = CStr(objDB.GetParameterValue(objcmd, "@ov_RetValue") + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@ov_DeletedCfg")), "", objDB.GetParameterValue(objcmd, "@ov_DeletedCfg"))) + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@ov_CntDelete")), "", objDB.GetParameterValue(objcmd, "@ov_CntDelete"))))
                    Return strStatus
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Fetch_TRConfiguration(ByVal idUser As String, ByVal idConfig As String, ByVal idConfig2 As String, ByVal idConfig3 As String, ByVal idConfig4 As String, ByVal idConfig5 As String) As DataSet
            Try
                Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_MAS_SHIFT_FETCH")
                    objDB.AddInParameter(objCMD, "@iv_ID_CONFIG", DbType.String, idConfig)
                    objDB.AddInParameter(objCMD, "@iv_ID_CONFIG2", DbType.String, idConfig2)
                    objDB.AddInParameter(objCMD, "@iv_ID_CONFIG3", DbType.String, idConfig3)
                    objDB.AddInParameter(objCMD, "@iv_ID_CONFIG4", DbType.String, idConfig4)
                    objDB.AddInParameter(objCMD, "@iv_ID_CONFIG5", DbType.String, idConfig5)
                    objDB.AddInParameter(objCMD, "@iv_ID_USER", DbType.String, IdUser)
                    Return objDB.ExecuteDataSet(objCMD)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function

        Public Function Fetch_HPConfiguration() As DataSet
            Try
                Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_HPSettings_FetchAll")
                    Return objDB.ExecuteDataSet(objCMD)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function DeleteHPConfig(ByVal strXML As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_HPSETTINGS_DELETE")
                    objDB.AddInParameter(objcmd, "@iv_xmlDoc", DbType.String, strXML)
                    objDB.AddOutParameter(objcmd, "@ov_RetValue", DbType.String, 10)
                    objDB.AddOutParameter(objcmd, "@ov_CntDelete", DbType.String, 2000)
                    objDB.AddOutParameter(objcmd, "@ov_DeletedCfg", DbType.String, 2000)
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = CStr(objDB.GetParameterValue(objcmd, "@ov_RetValue") + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@ov_DeletedCfg")), "", objDB.GetParameterValue(objcmd, "@ov_DeletedCfg"))) + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@ov_CntDelete")), "", objDB.GetParameterValue(objcmd, "@ov_CntDelete"))))
                    Return strStatus
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function UpdateConfigPayGrp(ByVal strXmlUpd As String, ByVal strXmlUpdPay As String, ByVal strXmlUpdGrp As String, ByVal strxmlUpdGM As String, ByVal IdLogin As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_SETTINGS_PAY_MODIFY")
                    objDB.AddInParameter(objcmd, "@IV_XMLDOC", DbType.String, strXmlUpd)
                    objDB.AddInParameter(objcmd, "@IV_XMLDOC1", DbType.String, strXmlUpdPay)
                    objDB.AddInParameter(objcmd, "@IV_XMLDOC2", DbType.String, strXmlUpdGrp)
                    objDB.AddInParameter(objcmd, "@IV_XMLDOC3", DbType.String, strxmlUpdGM)
                    objDB.AddInParameter(objcmd, "@IV_CREATEDBY", DbType.String, IdLogin)
                    objDB.AddOutParameter(objcmd, "@OV_RETVALUE", DbType.String, 10)
                    objDB.AddOutParameter(objcmd, "@OV_CANNOTMODIFY", DbType.String, 2000)
                    objDB.AddOutParameter(objcmd, "@OV_MODIFYEDCFG", DbType.String, 2000)
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = CStr(objDB.GetParameterValue(objcmd, "@OV_RETVALUE") + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@OV_CANNOTMODIFY")), "", objDB.GetParameterValue(objcmd, "@OV_CANNOTMODIFY"))) + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@OV_MODIFYEDCFG")), "", objDB.GetParameterValue(objcmd, "@OV_MODIFYEDCFG"))))
                    Return strStatus
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function SaveGenSettings(ByVal idConfig As String, ByVal desc As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_MINIMUMSPLITSSETTING_INSERT")
                    objDB.AddInParameter(objcmd, "@iv_ID_CONFIG", DbType.String, idConfig)
                    objDB.AddInParameter(objcmd, "@iv_DESCRIPTION", DbType.String, desc)
                    objDB.AddInParameter(objcmd, "@iv_CREATED_BY", DbType.String, HttpContext.Current.Session("UserID"))
                    objDB.AddOutParameter(objcmd, "@ov_RetValue", DbType.String, 2000)
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = CStr(objDB.GetParameterValue(objcmd, "@ov_RetValue"))
                    Return strStatus
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Fetch_StationType() As DataSet
            Try
                Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_STATIONTYPE_FETCH")
                    Return objDB.ExecuteDataSet(objCMD)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function AddStationType(ByVal strXML As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_STATIONTYPE_INSERT")
                    objDB.AddInParameter(objcmd, "@iv_xmlDoc", DbType.String, strXML)
                    objDB.AddInParameter(objcmd, "@iv_CreatedBy", DbType.String, HttpContext.Current.Session("UserID"))
                    objDB.AddOutParameter(objcmd, "@ov_RetValue", DbType.String, 10)
                    objDB.AddOutParameter(objcmd, "@ov_CannotInsert", DbType.String, 2000)
                    objDB.AddOutParameter(objcmd, "@ov_Insertedcfg", DbType.String, 2000)
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = CStr(objDB.GetParameterValue(objcmd, "@ov_RetValue") + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@ov_CannotInsert")), "", objDB.GetParameterValue(objcmd, "@ov_CannotInsert"))) + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@ov_Insertedcfg")), "", objDB.GetParameterValue(objcmd, "@ov_Insertedcfg"))))
                    Return strStatus
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function

        Public Function UpdateStationType(ByVal strXML As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_STATIONTYPE_MODIFY")
                    objDB.AddInParameter(objcmd, "@IV_XMLDOC", DbType.String, strXML)
                    objDB.AddInParameter(objcmd, "@IV_CREATEDBY", DbType.String, HttpContext.Current.Session("UserID"))
                    objDB.AddOutParameter(objcmd, "@OV_RETVALUE", DbType.String, 10)
                    objDB.AddOutParameter(objcmd, "@OV_CANNOTMODIFY", DbType.String, 2000)
                    objDB.AddOutParameter(objcmd, "@OV_MODIFYEDCFG", DbType.String, 2000)
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = CStr(objDB.GetParameterValue(objcmd, "@OV_RETVALUE") + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@OV_CANNOTMODIFY")), "", objDB.GetParameterValue(objcmd, "@OV_CANNOTMODIFY"))) + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@OV_MODIFYEDCFG")), "", objDB.GetParameterValue(objcmd, "@OV_MODIFYEDCFG"))))
                    Return strStatus
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function DeleteStationType(ByVal strXML As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_STATIONTYPE_DELETE")
                    objDB.AddInParameter(objcmd, "@iv_xmlDoc", DbType.String, strXML)
                    objDB.AddOutParameter(objcmd, "@ov_RetValue", DbType.String, 10)
                    objDB.AddOutParameter(objcmd, "@ov_CntDelete", DbType.String, 2000)
                    objDB.AddOutParameter(objcmd, "@ov_DeletedCfg", DbType.String, 2000)
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = CStr(objDB.GetParameterValue(objcmd, "@ov_RetValue") + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@ov_DeletedCfg")), "", objDB.GetParameterValue(objcmd, "@ov_DeletedCfg"))) + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@ov_CntDelete")), "", objDB.GetParameterValue(objcmd, "@ov_CntDelete"))))
                    Return strStatus
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function SaveSMSSetting(ByVal idConfig As String, ByVal desc As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_TimeSetting_Insert")
                    objDB.AddInParameter(objcmd, "@iv_ID_CONFIG", DbType.String, idConfig)
                    objDB.AddInParameter(objcmd, "@iv_DESCRIPTION", DbType.String, desc)
                    objDB.AddInParameter(objcmd, "@iv_CREATED_BY", DbType.String, HttpContext.Current.Session("UserID"))
                    objDB.AddOutParameter(objcmd, "@ov_RetValue", DbType.String, 2000)
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = CStr(objDB.GetParameterValue(objcmd, "@ov_RetValue"))
                    Return strStatus
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function AddDeptMessage(ByVal strXML As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_INSERT_DEPTMESSAGES")
                    objDB.AddInParameter(objcmd, "@IV_XMLDOC", DbType.String, strXML)
                    objDB.AddOutParameter(objcmd, "@OV_RETVALUE", DbType.String, 2000)
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = CStr(objDB.GetParameterValue(objcmd, "@OV_RETVALUE"))
                    Return strStatus
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function UpdateDeptMessage(ByVal strXML As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_UPDATE_DEPTMESSAGES")
                    objDB.AddInParameter(objcmd, "@IV_XMLDOC", DbType.String, strXML)
                    objDB.AddOutParameter(objcmd, "@OV_RETVALUE", DbType.String, 2000)
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = CStr(objDB.GetParameterValue(objcmd, "@OV_RETVALUE"))
                    Return strStatus
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function DeleteDeptMessage(ByVal strXML As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_DELETE_DEPTMESSAGES")
                    objDB.AddInParameter(objcmd, "@IV_XMLDOC", DbType.String, strXML)
                    objDB.AddOutParameter(objcmd, "@OV_RETVALUE", DbType.String, 2000)
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = CStr(objDB.GetParameterValue(objcmd, "@OV_RETVALUE"))
                    Return strStatus
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function

        Public Function Fetch_AllDepartment() As DataSet
            Try
                Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_FETCHALL_DEPARTMENT")
                    objDB.AddInParameter(objCMD, "@ID_USER", DbType.String, HttpContext.Current.Session("UserID"))
                    Return objDB.ExecuteDataSet(objCMD)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Fetch_PayType(ByVal idConfig As String) As DataSet
            Try
                Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_SETTINGS_PAY_FETCH")
                    objDB.AddInParameter(objCMD, "@ID_CONFIG", DbType.String, idConfig)
                    Return objDB.ExecuteDataSet(objCMD)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Fetch_VATCodes() As DataSet
            Try
                Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_VAT_FETCH")
                    Return objDB.ExecuteDataSet(objCMD)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function AddPaymentType(ByVal strXML As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_SETTINGS_PAY_INSERT")
                    objDB.AddInParameter(objcmd, "@iv_xmlDoc", DbType.String, strXML)
                    objDB.AddInParameter(objcmd, "@iv_CreatedBy", DbType.String, HttpContext.Current.Session("UserID"))
                    objDB.AddOutParameter(objcmd, "@ov_RetValue", DbType.String, 10)
                    objDB.AddOutParameter(objcmd, "@ov_CannotInsert", DbType.String, 2000)
                    objDB.AddOutParameter(objcmd, "@ov_Insertedcfg", DbType.String, 2000)
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = CStr(objDB.GetParameterValue(objcmd, "@ov_RetValue") + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@ov_Insertedcfg")), "", objDB.GetParameterValue(objcmd, "@ov_Insertedcfg"))) + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@ov_CannotInsert")), "", objDB.GetParameterValue(objcmd, "@ov_CannotInsert"))))
                    Return strStatus
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function UpdatePaymentType(ByVal strXML As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_PAY_UPDATE")
                    objDB.AddInParameter(objcmd, "@iv_xmlDoc", DbType.String, strXML)
                    objDB.AddInParameter(objcmd, "@iv_CreatedBy", DbType.String, HttpContext.Current.Session("UserID"))
                    objDB.AddOutParameter(objcmd, "@ov_RetValue", DbType.String, 10)
                    objDB.AddOutParameter(objcmd, "@OV_RCOUNT", DbType.String, 2000)
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = CStr(objDB.GetParameterValue(objcmd, "@ov_RetValue") + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@OV_RCOUNT")), "", objDB.GetParameterValue(objcmd, "@OV_RCOUNT"))))
                    Return strStatus
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function


    End Class

End Namespace

