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
Namespace CARS.MechCompetency
    Public Class MechCompetencyDO
        Dim ConnectionString As String
        Shared objCommonUtil As New CARS.Utilities.CommonUtility
        Dim objDB As Database
        Dim strStatus As String
        Public Sub New()
            ConnectionString = System.Configuration.ConfigurationManager.AppSettings("MSGConstr")
            objDB = New SqlDatabase(ConnectionString)
        End Sub
        Public Function Load_MechCompetencyDetails() As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("usp_Config_GetMechComptDetails")
                    objDB.AddOutParameter(objcmd, "@ov_Error_Code", DbType.String, 200)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Add_MechCompetency(ByVal xmlDoc As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_MEC_COMP_INSERT")
                    objDB.AddInParameter(objcmd, "@iv_XmlDoc", DbType.String, xmlDoc)
                    objDB.AddInParameter(objcmd, "@iv_CREATED_BY", DbType.String, HttpContext.Current.Session("UserID"))
                    objDB.AddOutParameter(objcmd, "@OV_CANNOTINSERT", DbType.String, 500)
                    objDB.AddOutParameter(objcmd, "@OV_INSERT", DbType.String, 500)
                    objDB.AddOutParameter(objcmd, "@ov_RetValue", DbType.String, 10)
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@ov_RetValue").ToString + "," + objDB.GetParameterValue(objcmd, "@OV_INSERT").ToString + "," + objDB.GetParameterValue(objcmd, "@OV_CANNOTINSERT").ToString
                End Using
            Catch ex As Exception
                Throw ex
            End Try
            Return strStatus
        End Function
        Public Function Update_MechCompetency(ByVal xmlDoc As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_MEC_COMP_UPDATE2")
                    objDB.AddInParameter(objcmd, "@iv_XmlDoc", DbType.String, xmlDoc)
                    objDB.AddInParameter(objcmd, "@iv_CREATED_BY", DbType.String, HttpContext.Current.Session("UserID"))
                    objDB.AddOutParameter(objcmd, "@OV_RETVALUE", DbType.String, 10)
                    objDB.AddOutParameter(objcmd, "@OV_CANNOTMODIFY", DbType.String, 2000)
                    objDB.AddOutParameter(objcmd, "@OV_MODIFYEDCFG", DbType.String, 2000)
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = CStr(objDB.GetParameterValue(objcmd, "@OV_RETVALUE") + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@OV_MODIFYEDCFG")), "", objDB.GetParameterValue(objcmd, "@OV_MODIFYEDCFG"))) + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@OV_CANNOTMODIFY")), "", objDB.GetParameterValue(objcmd, "@OV_CANNOTMODIFY"))))
                End Using
            Catch ex As Exception
                Throw ex
            End Try
            Return strStatus
        End Function
        Public Function Delete_MechCompetency(ByVal xmlDoc As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_MEC_COMP_DELETE")
                    objDB.AddInParameter(objcmd, "@iv_XmlDoc", DbType.String, xmlDoc)
                    objDB.AddOutParameter(objcmd, "@OV_CANNOTDELETE", DbType.String, 10)
                    objDB.AddOutParameter(objcmd, "@OV_DELETED", DbType.String, 2000)
                    objDB.AddOutParameter(objcmd, "@ov_RetValue", DbType.String, 2000)
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = CStr(objDB.GetParameterValue(objcmd, "@ov_RetValue") + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@OV_DELETED")), "", objDB.GetParameterValue(objcmd, "@OV_DELETED"))) + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@OV_CANNOTDELETE")), "", objDB.GetParameterValue(objcmd, "@OV_CANNOTDELETE"))))
                End Using
            Catch ex As Exception
                Throw ex
            End Try
            Return strStatus
        End Function
        Public Function Load_MechCompDetails() As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_MEC_COMP_PRICECODECOST")
                    objDB.AddInParameter(objcmd, "@ID_USER", DbType.String, HttpContext.Current.Session("UserID"))
                    objDB.AddOutParameter(objcmd, "@ov_Error_Code", DbType.String, 200)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Load_MechCompPCDetails() As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_MEC_COMP_PRICECODELIST")
                    objDB.AddOutParameter(objcmd, "@ov_Error_Code", DbType.String, 200)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Fetch_MechCompPCCostDetails(ByVal mechId As String) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_MEC_COMP_PRICECODECOST2")
                    objDB.AddInParameter(objcmd, "@iv_ID_MEC", DbType.String, mechId)
                    objDB.AddOutParameter(objcmd, "@ov_Error_Code", DbType.String, 200)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Add_MechCompCost(ByVal xmlDoc As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_MEC_COSTPERHOUR_INSERT")
                    objDB.AddInParameter(objcmd, "@iv_XmlDoc", DbType.String, xmlDoc)
                    objDB.AddInParameter(objcmd, "@iv_CREATED_BY", DbType.String, HttpContext.Current.Session("UserID"))
                    objDB.AddOutParameter(objcmd, "@ov_RetValue", DbType.String, 10)
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@ov_RetValue").ToString()
                End Using
            Catch ex As Exception
                Throw ex
            End Try
            Return strStatus
        End Function
        Public Function Add_MechCompMapping(ByVal xmlDoc As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_MEC_COMPT_MAP_INSERT")
                    objDB.AddInParameter(objcmd, "@iv_XmlDoc", DbType.String, xmlDoc)
                    objDB.AddInParameter(objcmd, "@iv_CREATED_BY", DbType.String, HttpContext.Current.Session("UserID"))
                    objDB.AddOutParameter(objcmd, "@ov_RetValue", DbType.String, 10)
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@ov_RetValue").ToString()
                End Using
            Catch ex As Exception
                Throw ex
            End Try
            Return strStatus
        End Function
        Public Function Fetch_MechAllPriceCodeDetails() As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_MEC_COMP_PRICECODECOST_ALLPRICECODE")
                    objDB.AddOutParameter(objcmd, "@ov_Error_Code", DbType.String, 200)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Delete_MechCost(ByVal xmlDoc As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_MEC_COSTPERHOUR_DELETE")
                    objDB.AddInParameter(objcmd, "@iv_XmlDoc", DbType.String, xmlDoc)
                    objDB.AddOutParameter(objcmd, "@ov_RetValue", DbType.String, 20)
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@ov_RetValue").ToString()
                End Using
            Catch ex As Exception
                Throw ex
            End Try
            Return strStatus
        End Function
    End Class
End Namespace

