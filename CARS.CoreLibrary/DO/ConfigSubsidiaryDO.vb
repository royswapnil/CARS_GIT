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
Namespace CARS.Subsidiary
    Public Class ConfigSubsidiaryDO
        Dim ConnectionString As String
        Dim objDB As Database
        Dim strStatus As String
        Public Sub New()
            ConnectionString = System.Configuration.ConfigurationManager.AppSettings("MSGConstr")
            objDB = New SqlDatabase(ConnectionString)
        End Sub
        Public Function FetchAllSubsidiary(ByVal objConfigSubBO As ConfigSubsidiaryBO) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FetchAll_Subsidiary")
                    objDB.AddInParameter(objcmd, "@ID_USER", DbType.String, objConfigSubBO.UserID)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Fetch_Subsidiary(ByVal objConfigSubBO As ConfigSubsidiaryBO) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_CONFIG_SUBSIDIARY")
                    objDB.AddInParameter(objcmd, "@IV_ID_SUBSIDIARY", DbType.Int32, Convert.ToInt32(objConfigSubBO.SubsidiaryID))
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Update_Subsidiary(ByVal objConfigSubBO As ConfigSubsidiaryBO) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_Subsidary_Update")
                    objDB.AddInParameter(objcmd, "@iv_ID_Subsidery", DbType.Int32, objConfigSubBO.SubsidiaryID)
                    objDB.AddInParameter(objcmd, "@iv_SS_Name", DbType.String, objConfigSubBO.SubsidiaryName)
                    objDB.AddInParameter(objcmd, "@iv_SS_Mgr_Name", DbType.String, objConfigSubBO.SubsidiaryManager)
                    objDB.AddInParameter(objcmd, "@iv_SS_Address1", DbType.String, objConfigSubBO.AddressLine1)
                    objDB.AddInParameter(objcmd, "@iv_SS_Address2", DbType.String, objConfigSubBO.AddressLine2)
                    objDB.AddInParameter(objcmd, "@ii_SS_ID_Zipcode", DbType.String, objConfigSubBO.ZipCode)
                    objDB.AddInParameter(objcmd, "@iv_SS_Phone1", DbType.String, objConfigSubBO.Telephone)
                    objDB.AddInParameter(objcmd, "@iv_SS_Phone2", DbType.String, objConfigSubBO.Telephone)
                    objDB.AddInParameter(objcmd, "@iv_SS_Phone_Mobile", DbType.String, objConfigSubBO.Mobile)
                    objDB.AddInParameter(objcmd, "@iv_SS_Fax", DbType.String, objConfigSubBO.FaxNo)
                    objDB.AddInParameter(objcmd, "@iv_ID_EMAIL_SUBSID", DbType.String, objConfigSubBO.Email)
                    objDB.AddInParameter(objcmd, "@iv_SS_ORGANIZATIONNO", DbType.String, objConfigSubBO.Organization)
                    objDB.AddInParameter(objcmd, "@IV_DT_MODIFIED", DbType.String, Nothing)
                    objDB.AddInParameter(objcmd, "@iv_CREATED_BY", DbType.String, objConfigSubBO.UserID)
                    objDB.AddInParameter(objcmd, "@IV_IBAN", DbType.String, objConfigSubBO.IBAN)
                    objDB.AddInParameter(objcmd, "@IV_BANKACCOUNT", DbType.String, objConfigSubBO.BankAccnt)
                    objDB.AddInParameter(objcmd, "@IV_SWIFT", DbType.String, objConfigSubBO.Swift)
                    objDB.AddInParameter(objcmd, "@iv_TransferMethod", DbType.String, objConfigSubBO.TransferMethod)
                    objDB.AddInParameter(objcmd, "@iv_AccountCode", DbType.String, objConfigSubBO.AccntCode)
                    objDB.AddOutParameter(objcmd, "@ov_RetValue", DbType.String, 10)

                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@ov_RetValue").ToString
                End Using
                Return strStatus
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Add_Subsidiary(ByVal objConfigSubBO As ConfigSubsidiaryBO) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_Subsidary_Insert")
                    objDB.AddInParameter(objcmd, "@iv_ID_Subsidery", DbType.Int32, objConfigSubBO.SubsidiaryID)
                    objDB.AddInParameter(objcmd, "@iv_SS_Name", DbType.String, objConfigSubBO.SubsidiaryName)
                    objDB.AddInParameter(objcmd, "@iv_SS_Mgr_Name", DbType.String, objConfigSubBO.SubsidiaryManager)
                    objDB.AddInParameter(objcmd, "@iv_SS_Address1", DbType.String, objConfigSubBO.AddressLine1)
                    objDB.AddInParameter(objcmd, "@iv_SS_Address2", DbType.String, objConfigSubBO.AddressLine2)
                    objDB.AddInParameter(objcmd, "@ii_SS_ID_Zipcode", DbType.String, objConfigSubBO.ZipCode)
                    objDB.AddInParameter(objcmd, "@iv_SS_Phone1", DbType.String, objConfigSubBO.Telephone)
                    objDB.AddInParameter(objcmd, "@iv_SS_Phone2", DbType.String, objConfigSubBO.Telephone)
                    objDB.AddInParameter(objcmd, "@iv_SS_Phone_Mobile", DbType.String, objConfigSubBO.Mobile)
                    objDB.AddInParameter(objcmd, "@iv_SS_Fax", DbType.String, objConfigSubBO.FaxNo)
                    objDB.AddInParameter(objcmd, "@iv_ID_EMAIL_SUBSID", DbType.String, objConfigSubBO.Email)
                    objDB.AddInParameter(objcmd, "@iv_SS_ORGANIZATIONNO", DbType.String, objConfigSubBO.Organization)
                    objDB.AddInParameter(objcmd, "@iv_CREATED_BY", DbType.String, objConfigSubBO.UserID)
                    objDB.AddInParameter(objcmd, "@IV_IBAN", DbType.String, objConfigSubBO.IBAN)
                    objDB.AddInParameter(objcmd, "@IV_BANKACCOUNT", DbType.String, objConfigSubBO.BankAccnt)
                    objDB.AddInParameter(objcmd, "@IV_SWIFT", DbType.String, objConfigSubBO.Swift)
                    objDB.AddInParameter(objcmd, "@iv_TransferMethod", DbType.String, objConfigSubBO.TransferMethod)
                    objDB.AddInParameter(objcmd, "@iv_AccountCode", DbType.String, objConfigSubBO.AccntCode)
                    objDB.AddOutParameter(objcmd, "@ov_RetValue", DbType.String, 10)

                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@ov_RetValue").ToString
                End Using
                Return strStatus
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Delete_Subsidiary(ByVal objConfigSubBO As ConfigSubsidiaryBO) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_SUBSIDERY_DELETE")
                    objDB.AddInParameter(objcmd, "@IV_SubsideryId", DbType.String, objConfigSubBO.SubsidiaryID)
                    objDB.AddOutParameter(objcmd, "@OV_RetValue", DbType.String, 10)
                    objDB.AddOutParameter(objcmd, "@OV_CntDelete", DbType.String, 2000)
                    objDB.AddOutParameter(objcmd, "@OV_DeletedCfg", DbType.String, 2000)
                    objDB.ExecuteNonQuery(objcmd)
                    'strStatus = objDB.GetParameterValue(objcmd, "@ov_RetValue").ToString + "," + objDB.GetParameterValue(objcmd, "@OV_CntDelete").ToString + "," + objDB.GetParameterValue(objcmd, "@OV_DeletedCfg").ToString
                    strStatus = CStr(objDB.GetParameterValue(objcmd, "@OV_RetValue") + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@OV_DeletedCfg")), "", objDB.GetParameterValue(objcmd, "@OV_DeletedCfg"))) + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@OV_CntDelete")), "", objDB.GetParameterValue(objcmd, "@OV_CntDelete"))))
                End Using
                Return strStatus
            Catch ex As Exception
                Throw ex
            End Try
        End Function
    End Class
End Namespace
