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
Namespace CARS.RepPackCode
    Public Class RepPackCodeDO
        Dim ConnectionString As String
        Shared objCommonUtil As New CARS.Utilities.CommonUtility
        Dim objDB As Database
        Dim strStatus As String
        Public Sub New()
            ConnectionString = System.Configuration.ConfigurationManager.AppSettings("MSGConstr")
            objDB = New SqlDatabase(ConnectionString)
        End Sub
        Public Function Fetch_RPConfiguration() As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_RP_Settings_FetchAll")
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Fetch_RPkgCode() As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_RP_SETTINGS_FETCHALL_LANG")
                    objDB.AddInParameter(objcmd, "@LANG", DbType.String, System.Configuration.ConfigurationManager.AppSettings("Language").ToString())
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function

        Public Function UpdateConfigDetails(ByVal strXMLDocMas As String, ByVal strXMLDocRpCode As String, ByVal strXMLDocChkLst As String, ByVal strXMLDocSrpCode As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_RPSETTINGS_MODIFY")
                    objDB.AddInParameter(objcmd, "@IV_XMLDOC_MAS", DbType.String, strXMLDocMas)
                    objDB.AddInParameter(objcmd, "@IV_XMLDOC_RPCODE", DbType.String, strXMLDocRpCode)
                    objDB.AddInParameter(objcmd, "@IV_XMLDOC_CHKLST", DbType.String, strXMLDocChkLst)
                    objDB.AddInParameter(objcmd, "@IV_CREATEDBY", DbType.String, HttpContext.Current.Session("UserID"))
                    objDB.AddInParameter(objcmd, "@IV_XMLDOC_SRPCODE", DbType.String, strXMLDocSrpCode)
                    objDB.AddOutParameter(objcmd, "@OV_RETVALUE_MAS", DbType.String, 10)
                    objDB.AddOutParameter(objcmd, "@OV_RETVALUE_RPCODE", DbType.String, 10)
                    objDB.AddOutParameter(objcmd, "@OV_RETVALUE_CHKLST", DbType.String, 10)
                    objDB.AddOutParameter(objcmd, "@OV_CANNOTMODIFY_MAS", DbType.String, 500)
                    objDB.AddOutParameter(objcmd, "@OV_MODIFYEDCFG_MAS", DbType.String, 500)
                    objDB.AddOutParameter(objcmd, "@OV_CANNOTMODIFY_RPCODE", DbType.String, 500)
                    objDB.AddOutParameter(objcmd, "@OV_MODIFYEDCFG_RPCODE", DbType.String, 500)
                    objDB.AddOutParameter(objcmd, "@OV_CANNOTMODIFY_CHKLST", DbType.String, 500)
                    objDB.AddOutParameter(objcmd, "@OV_MODIFYEDCFG_CHKLST", DbType.String, 500)
                    objDB.AddOutParameter(objcmd, "@OV_RETVALUE_SRPCODE", DbType.String, 500)
                    objDB.AddOutParameter(objcmd, "@OV_CANNOTMODIFY_SRPCODE", DbType.String, 500)
                    objDB.AddOutParameter(objcmd, "@OV_MODIFYEDCFG_SRPCODE", DbType.String, 500)
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@OV_RETVALUE_MAS").ToString() + "," + objDB.GetParameterValue(objcmd, "@OV_RETVALUE_RPCODE").ToString() + "," + objDB.GetParameterValue(objcmd, "@OV_RETVALUE_CHKLST").ToString() + "," + objDB.GetParameterValue(objcmd, "@OV_CANNOTMODIFY_MAS").ToString() + "," + objDB.GetParameterValue(objcmd, "@OV_MODIFYEDCFG_MAS").ToString() + "," + objDB.GetParameterValue(objcmd, "@OV_CANNOTMODIFY_RPCODE").ToString() + "," + objDB.GetParameterValue(objcmd, "@OV_MODIFYEDCFG_RPCODE").ToString() + "," + objDB.GetParameterValue(objcmd, "@OV_CANNOTMODIFY_CHKLST").ToString() + "," + objDB.GetParameterValue(objcmd, "@OV_MODIFYEDCFG_CHKLST").ToString() + "," + objDB.GetParameterValue(objcmd, "@OV_RETVALUE_SRPCODE").ToString() + "," + objDB.GetParameterValue(objcmd, "@OV_CANNOTMODIFY_SRPCODE").ToString() + "," + objDB.GetParameterValue(objcmd, "@OV_MODIFYEDCFG_SRPCODE").ToString()

                    Return strStatus
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function InsertRepCode(ByVal strXML As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_RP_RepairCode_Insert")
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
        Public Function DeleteRepCode(ByVal strXML As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_RepairCode_DELETE")
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
        Public Function InsertSubRepCode(ByVal strXML As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_SUBREPCODE_INSERT")
                    objDB.AddInParameter(objcmd, "@IV_XMLDOC", DbType.String, strXML)
                    objDB.AddInParameter(objcmd, "@IV_CREATEDBY", DbType.String, HttpContext.Current.Session("UserID"))
                    objDB.AddOutParameter(objcmd, "@OV_RETVALUE", DbType.String, 10)
                    objDB.AddOutParameter(objcmd, "@OV_CANNOTINSERT", DbType.String, 2000)
                    objDB.AddOutParameter(objcmd, "@OV_INSERTEDCFG", DbType.String, 2000)
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = CStr(objDB.GetParameterValue(objcmd, "@OV_RETVALUE") + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@OV_CANNOTINSERT")), "", objDB.GetParameterValue(objcmd, "@OV_CANNOTINSERT"))) + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@OV_INSERTEDCFG")), "", objDB.GetParameterValue(objcmd, "@OV_INSERTEDCFG"))))
                    Return strStatus
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function DeleteSubRepCode(ByVal strXML As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_SUBREPCODE_DELETE")
                    objDB.AddInParameter(objcmd, "@IV_XMLDOC", DbType.String, strXML)
                    objDB.AddOutParameter(objcmd, "@OV_RETVALUE", DbType.String, 10)
                    objDB.AddOutParameter(objcmd, "@OV_CNTDELETE", DbType.String, 2000)
                    objDB.AddOutParameter(objcmd, "@OV_DELETEDCFG", DbType.String, 2000)
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = CStr(objDB.GetParameterValue(objcmd, "@OV_RETVALUE") + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@OV_DELETEDCFG")), "", objDB.GetParameterValue(objcmd, "@OV_DELETEDCFG"))) + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@OV_CNTDELETE")), "", objDB.GetParameterValue(objcmd, "@OV_CNTDELETE"))))
                    Return strStatus
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function InsertRepCodePkk(ByVal idRepCode As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_PKK_RepairCode_Insert")
                    objDB.AddInParameter(objcmd, "@iv_ID_REP_CODE", DbType.String, idRepCode)
                    objDB.AddInParameter(objcmd, "@CREATED_BY", DbType.String, HttpContext.Current.Session("UserID"))
                    objDB.AddOutParameter(objcmd, "@ov_RetValue", DbType.String, 10)
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = CStr(objDB.GetParameterValue(objcmd, "@ov_RetValue"))
                    Return strStatus
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function InsertCheckList(ByVal strXML As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_RP_CheckList_Insert")
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
        Public Function DeleteCheckList(ByVal strXML As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_CheckList_DELETE")
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

    End Class
End Namespace

