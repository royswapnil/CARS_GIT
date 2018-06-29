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
Namespace CARS.ConfigPlanningDO
    Public Class ConfigPlanningDO

        Dim ConnectionString As String
        Dim objDB As Database
        Dim strStatus As String
        Public Sub New()
            ConnectionString = System.Configuration.ConfigurationManager.AppSettings("MSGConstr")
            objDB = New SqlDatabase(ConnectionString)
        End Sub
        Public Function FetchAllStations(ByVal deptId As String) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_STATIONDETAILS_FETCH")
                    objDB.AddInParameter(objcmd, "@ID_DEP", DbType.Int16, Convert.ToInt16(deptId))
                    objDB.AddOutParameter(objcmd, "@ov_RetValue", DbType.String, 10)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function FetchAllStationTypes() As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_PLAN_STATIONTYPE_FETCH")
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function FetchAllDepartment() As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_PLAN_MEC_DEPTS_FETCH")
                    objDB.AddInParameter(objcmd, "@ID_USER", DbType.String, HttpContext.Current.Session("UserID"))
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Add_NewStation(ByVal objConfigStatBO As ConfigPlanningBO) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_StationAndStype_INSERT")
                    objDB.AddInParameter(objcmd, "@IV_NAMESTATION", DbType.String, objConfigStatBO.Station_Name)
                    objDB.AddInParameter(objcmd, "@IV_STYPEID", DbType.Int16, objConfigStatBO.Id_StationType)
                    objDB.AddInParameter(objcmd, "@IV_DEPT", DbType.Int16, objConfigStatBO.Id_Dept)
                    objDB.AddInParameter(objcmd, "@IV_CREATEDBY", DbType.String, HttpContext.Current.Session("UserID"))
                    objDB.AddOutParameter(objcmd, "@OV_RESULT", DbType.Int16, 10)

                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@OV_RESULT").ToString
                End Using
                Return strStatus
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Update_NewStation(ByVal objConfigStatBO As ConfigPlanningBO) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_NewStation_UPDATE")
                    objDB.AddInParameter(objcmd, "@IV_NAMESTATION", DbType.String, objConfigStatBO.Station_Name)
                    objDB.AddInParameter(objcmd, "@IV_STATIONID", DbType.Int16, objConfigStatBO.Id_Station)
                    objDB.AddInParameter(objcmd, "@IV_STYPEID", DbType.Int16, objConfigStatBO.Id_StationType)
                    objDB.AddInParameter(objcmd, "@IV_DEPT", DbType.Int16, objConfigStatBO.Id_Dept)
                    objDB.AddInParameter(objcmd, "@IV_MODIFIEDBY", DbType.String, HttpContext.Current.Session("UserID"))
                    objDB.AddOutParameter(objcmd, "@OV_RESULT", DbType.Int16, 10)

                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@OV_RESULT").ToString
                End Using
                Return strStatus
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Fetch_StationDepMapList() As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_PLAN_DepStationsAndType_FETCH")
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Delete_Station(ByVal xmlDoc As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_NEWSTATION_DELETE")
                    objDB.AddInParameter(objcmd, "@IV_XMLDOC", DbType.String, xmlDoc)
                    objDB.AddOutParameter(objcmd, "@OV_CNTDELETE", DbType.String, 500)
                    objDB.AddOutParameter(objcmd, "@OV_DELETEDCFG", DbType.String, 500)
                    objDB.AddOutParameter(objcmd, "@OV_RETVALUE", DbType.String, 10)
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = CStr(objDB.GetParameterValue(objcmd, "@OV_RETVALUE") + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@OV_DELETEDCFG")), "", objDB.GetParameterValue(objcmd, "@OV_DELETEDCFG"))) + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@OV_CNTDELETE")), "", objDB.GetParameterValue(objcmd, "@OV_CNTDELETE"))))
                End Using
            Catch ex As Exception
                Throw ex
            End Try
            Return strStatus
        End Function



    End Class
End Namespace

