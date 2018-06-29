Imports Microsoft.VisualBasic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports Microsoft.Practices.EnterpriseLibrary.Data.Sql
Imports System
Imports System.Configuration
Imports System.Data
Imports System.Data.Common
Imports System.Data.SqlClient
Imports System.Web
Namespace CARS.ZipCodes
    Public Class ZipCodesDO
        Dim objDB As Database
        Dim ConnectionString As String
        Public Sub New()
            ConnectionString = System.Configuration.ConfigurationManager.AppSettings("MSGConstr")
            objDB = New SqlDatabase(ConnectionString)
        End Sub
        Public Function Fetch_ZipCodes(ByVal objZipCodes As ZipCodesBO) As DataSet
            Try
                Dim dsZipcodes As New DataSet
                Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_CONFIG_ZIPCODES")
                    objDB.AddInParameter(objCMD, "@IV_ZIPCODE", DbType.String, objZipCodes.ZipCode)
                    objDB.AddInParameter(objCMD, "@IV_ID_LOGIN", DbType.String, objZipCodes.UserId)
                    dsZipcodes = objDB.ExecuteDataSet(objCMD)
                End Using
                Return dsZipcodes
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Add_ZipCode(ByVal objZipCodes As ZipCodesBO) As String
            Dim strStatus As String
            Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_ZipCode_INSERT")
                objDB.AddInParameter(objCMD, "@IV_ZIPCODE", DbType.String, objZipCodes.ZipCode)
                objDB.AddInParameter(objCMD, "@iv_DescCountry", DbType.String, objZipCodes.Country)
                objDB.AddInParameter(objCMD, "@iv_DescState", DbType.String, objZipCodes.State)
                objDB.AddInParameter(objCMD, "@iv_City", DbType.String, objZipCodes.City)
                objDB.AddInParameter(objCMD, "@iv_UserId", DbType.String, HttpContext.Current.Session("UserID"))
                objDB.AddOutParameter(objCMD, "@ov_RetValue", DbType.String, 10)
                objDB.AddOutParameter(objCMD, "@ov_ZipId", DbType.String, 10)
                objDB.ExecuteNonQuery(objCMD)
                strStatus = objDB.GetParameterValue(objCMD, "@ov_RetValue").ToString()
            End Using
            Return strStatus
        End Function
        Public Function Fetch_AllZipCode() As DataSet
            Try
                Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_ZIPCODE_FETCHALL")
                    objDB.AddOutParameter(objCMD, "@ov_RetValue", DbType.String, 10)
                    Return objDB.ExecuteDataSet(objCMD)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Update_ZipCode(ByVal objZipCodes As ZipCodesBO) As String
            Dim strStatus As String
            Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_ZIPCODE_UPDATE")
                objDB.AddInParameter(objCMD, "@IV_ZIPCODE", DbType.String, objZipCodes.ZipCode)
                objDB.AddInParameter(objCMD, "@iv_DescCountry", DbType.String, objZipCodes.Country)
                objDB.AddInParameter(objCMD, "@iv_DescState", DbType.String, objZipCodes.State)
                objDB.AddInParameter(objCMD, "@iv_City", DbType.String, objZipCodes.City)
                objDB.AddInParameter(objCMD, "@iv_UserId", DbType.String, HttpContext.Current.Session("UserID"))
                objDB.AddOutParameter(objCMD, "@ov_RetValue", DbType.String, 10)
                objDB.AddInParameter(objCMD, "@iv_ZipId", DbType.String, objZipCodes.IdZip)
                objDB.ExecuteNonQuery(objCMD)
                strStatus = objDB.GetParameterValue(objCMD, "@ov_RetValue").ToString()
            End Using
            Return strStatus
        End Function
        Public Function DeleteZipCode(ByVal strXML As String) As String
            Dim strStatus As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_ZipCode_DELETE")
                    objDB.AddInParameter(objcmd, "@iv_BusEventID", DbType.String, strXML)
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

        Public Function ImportZipCode(ByVal dtZipCodes As DataTable)
            Dim dtSource As New DataTable
            dtSource = dtZipCodes
            Using cn As New SqlConnection(ConnectionString)
                cn.Open()
                Using copy As New SqlBulkCopy(cn)
                    copy.ColumnMappings.Add("zip_code", "zip_code")
                    copy.ColumnMappings.Add("zip_city", "zip_city")
                    copy.ColumnMappings.Add("county_municipality", "county_municipality")
                    copy.ColumnMappings.Add("municipality_name", "municipality_name")
                    copy.ColumnMappings.Add("category", "category")
                    copy.DestinationTableName = "dbo.TBL_TMP_ZIPCODE"
                    AddHandler copy.SqlRowsCopied, AddressOf OnSqlRowsCopied
                    copy.DestinationTableName =
                        "dbo.TBL_TMP_ZIPCODE"
                    copy.NotifyAfter = 50
                    Try
                        copy.WriteToServer(dtSource)
                    Catch ex As Exception
                        Console.WriteLine(ex.Message)
                    End Try
                End Using
                cn.Close()
            End Using
            Dim strStatus As String = ""
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_IMPORT_ZIPCODES")
                    objDB.AddOutParameter(objcmd, "@CNT", DbType.String, 50)
                    objDB.AddOutParameter(objcmd, "@INS", DbType.String, 50)
                    objDB.AddOutParameter(objcmd, "@UPD", DbType.String, 50)
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@CNT").ToString() + "," + objDB.GetParameterValue(objcmd, "@INS").ToString() + "," + objDB.GetParameterValue(objcmd, "@UPD").ToString()

                End Using
            Catch ex As Exception
                Throw ex
            End Try
            Return strStatus
        End Function
        Private Sub OnSqlRowsCopied(ByVal sender As Object,
        ByVal args As SqlRowsCopiedEventArgs)
            Console.WriteLine(args.RowsCopied)
        End Sub
    End Class
End Namespace
