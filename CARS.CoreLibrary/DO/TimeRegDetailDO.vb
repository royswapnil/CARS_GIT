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
Namespace CARS.TimeRegDetail
    Public Class TimeRegDetailDO
        Dim ConnectionString As String
        Dim objDB As Database
        Dim strStatus As String
        Public Sub New()
            ConnectionString = System.Configuration.ConfigurationManager.AppSettings("MSGConstr")
            objDB = New SqlDatabase(ConnectionString)
        End Sub
        Public Function Add_TimeRegDet(ByVal mechId As String, ByVal ordNo As String, ByVal jobNo As String, ByVal dtClockin As String, ByVal timeClockin As String, ByVal clockIn As String, ByVal id_tr_seq As String, ByVal reas_code As String, ByVal comp_per As String, ByVal idWoLabSeq As String, ByVal unsoldTime As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_INSERT_TIMEREG_JOB_DETAIL")
                    objDB.AddInParameter(objcmd, "@TMP_ID_TR_SEQ", DbType.Int32, id_tr_seq)
                    objDB.AddInParameter(objcmd, "@IV_ID_WO_NO", DbType.String, ordNo)
                    objDB.AddInParameter(objcmd, "@II_ID_JOB", DbType.Int32, jobNo)
                    objDB.AddInParameter(objcmd, "@IV_CO_REAS_CODE", DbType.String, reas_code)
                    objDB.AddInParameter(objcmd, "@II_COMP_PER", DbType.Int32, comp_per)
                    objDB.AddInParameter(objcmd, "@IV_UNSOLD_TIME", DbType.String, unsoldTime)
                    objDB.AddInParameter(objcmd, "@IV_ID_MEC_TR", DbType.String, mechId)
                    objDB.AddInParameter(objcmd, "@IC_LOGOUT_FLG", DbType.String, clockIn)
                    objDB.AddInParameter(objcmd, "@II_SPLIT_SEQ", DbType.Int32, 0)
                    objDB.AddInParameter(objcmd, "@IV_CREATED_BY", DbType.String, HttpContext.Current.Session("UserID"))
                    objDB.AddInParameter(objcmd, "@CONFIRM_CLOCK_OUT", DbType.Boolean, 0)
                    objDB.AddInParameter(objcmd, "@ID_WO_LAB_SEQ", DbType.Int32, idWoLabSeq)
                    objDB.AddOutParameter(objcmd, "@OV_STATUS", DbType.String, 10)
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@OV_STATUS").ToString
                End Using
                Return strStatus
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Mechanic_Search(ByVal mechName As String) As DataSet
            Try
                Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_MECHANIC_SEARCH")
                    objDB.AddInParameter(objCMD, "@ID_SEARCH", DbType.String, mechName)
                    Return objDB.ExecuteDataSet(objCMD)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function JobDetGrid(ByVal WoNo As String) As DataSet
            Try
                Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_JOBDET")
                    objDB.AddInParameter(objCMD, "@WONO", DbType.String, WoNo)
                    Return objDB.ExecuteDataSet(objCMD)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function FetchDefUnsoldTime() As DataSet
            Try
                Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_DEFAULT_UNSOLDTIME")
                    objDB.AddInParameter(objCMD, "@DESC", DbType.String, "MØNSTRING")
                    Return objDB.ExecuteDataSet(objCMD)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function FetchTimeRegSettings() As DataSet
            Try
                Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_TR_CMBITEMS_FETCHALL")
                    Return objDB.ExecuteDataSet(objCMD)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function CheckMecExists(ByVal ordNo As String, ByVal jobNo As String, ByVal mechId As String, ByVal idWoLabSeq As String) As DataSet
            Try
                Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_CHECK_MECH_CLOCKIN_EXISTS")
                    objDB.AddInParameter(objCMD, "@ID_WO_NO", DbType.String, ordNo)
                    objDB.AddInParameter(objCMD, "@ID_JOB", DbType.Int32, jobNo)
                    objDB.AddInParameter(objCMD, "@MECH_CODE", DbType.String, mechId)
                    objDB.AddInParameter(objCMD, "@ID_LAB_SEQ", DbType.String, idWoLabSeq)
                    Return objDB.ExecuteDataSet(objCMD)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Fetch_Mechanic_Details(ByVal mechId As String) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_TR_MECHANIC_DETAILS")
                    objDB.AddInParameter(objcmd, "@IV_MECH_CODE", DbType.String, mechId)
                    objDB.AddInParameter(objcmd, "@IV_MECH_NAME", DbType.String, Nothing)
                    objDB.AddInParameter(objcmd, "@IV_FROM_DATE", DbType.String, Nothing)
                    objDB.AddInParameter(objcmd, "@IV_TO_DATE", DbType.String, Nothing)
                    objDB.AddInParameter(objcmd, "@IV_ID_WO_NO", DbType.String, Nothing)
                    objDB.AddInParameter(objcmd, "@IV_ID_JOB", DbType.Int32, 0)
                    objDB.AddInParameter(objcmd, "@IV_ID_MR", DbType.Int32, 0)
                    objDB.AddInParameter(objcmd, "@IV_ID_DEPT", DbType.Int32, HttpContext.Current.Session("UserDept"))

                    Return objDB.ExecuteDataSet(objcmd)

                End Using

            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Add_ManualTimeRegDet(ByVal mechId As String, ByVal ordNo As String, ByVal jobNo As String, ByVal dtClockin As String, ByVal timeClockin As String, ByVal dtClockout As String, ByVal timeClockout As String, ByVal idWoLabSeq As String, ByVal unsoldTime As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_TR_MANUAL_CLOCKIN")
                    objDB.AddInParameter(objcmd, "@iv_ID_WO_NO", DbType.String, IIf(ordNo = "", Nothing, ordNo))
                    objDB.AddInParameter(objcmd, "@iv_ID_JOB", DbType.Int32, jobNo)
                    objDB.AddInParameter(objcmd, "@IV_ID_MEC_TR", DbType.String, mechId)
                    objDB.AddInParameter(objcmd, "@iv_DAY_CLOCK_IN", DbType.String, dtClockin)
                    objDB.AddInParameter(objcmd, "@iv_HR_CLOCK_IN", DbType.String, timeClockin)
                    objDB.AddInParameter(objcmd, "@iv_DAY_CLOCK_OUT", DbType.String, dtClockout)
                    objDB.AddInParameter(objcmd, "@iv_HR_CLOCK_OUT", DbType.String, timeClockout)
                    objDB.AddInParameter(objcmd, "@iv_ID_UNSOLD_TIME", DbType.String, unsoldTime)
                    objDB.AddInParameter(objcmd, "@iv_STATUS", DbType.String, String.Empty)
                    objDB.AddInParameter(objcmd, "@iv_ID_SHIFT_NO", DbType.Int32, "0")
                    objDB.AddInParameter(objcmd, "@iv_ID_DAY_SEQ", DbType.Int32, "0")
                    objDB.AddInParameter(objcmd, "@iv_ID_LOG_SEQ", DbType.Int32, "0")
                    objDB.AddInParameter(objcmd, "@iv_CREATED_BY", DbType.String, HttpContext.Current.Session("UserID"))
                    objDB.AddInParameter(objcmd, "@ID_WOLAB_SEQ", DbType.Int32, IIf(idWoLabSeq = "", "0", idWoLabSeq))
                    objDB.AddOutParameter(objcmd, "@OV_RETURN", DbType.String, 10)
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@OV_RETURN").ToString
                End Using
                Return strStatus
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Fetch_InvTime(ByVal WoNo As String, ByVal IdWoLabSeq As String) As DataSet
            Try
                Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_INV_TIME")
                    objDB.AddInParameter(objCMD, "@WONO", DbType.String, WoNo)
                    objDB.AddInParameter(objCMD, "@ID_WOLAB_SEQ", DbType.Int32, IdWoLabSeq)
                    Return objDB.ExecuteDataSet(objCMD)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Fetch_clkTime(ByVal ClockIn As String, ByVal ClockOut As String) As DataSet
            Try
                Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_CLOCKTIME")
                    objDB.AddInParameter(objCMD, "@DT_CLOCK_IN", DbType.DateTime, ClockIn)
                    objDB.AddInParameter(objCMD, "@DT_CLOCK_OUT", DbType.DateTime, ClockOut)
                    objDB.AddInParameter(objCMD, "@ID_USER", DbType.String, HttpContext.Current.Session("UserID"))
                    Return objDB.ExecuteDataSet(objCMD)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function checkMechClkIn(ByVal id_tr_seq As String, ByVal mechId As String, ByVal ordNo As String, ByVal jobNo As String, ByVal dtClockin As String, ByVal timeClockin As String, ByVal dtClockout As String, ByVal timeClockout As String, ByVal idWoLabSeq As String, ByVal unsoldTime As String, ByVal status As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_TR_CTPMECH_CHECK")
                    objDB.AddInParameter(objcmd, "@IV_ID_TR_SEQ", DbType.String, id_tr_seq)
                    objDB.AddInParameter(objcmd, "@iv_ID_WO_NO", DbType.String, ordNo)
                    objDB.AddInParameter(objcmd, "@IV_ID_PREV_WONO", DbType.String, Nothing)
                    objDB.AddInParameter(objcmd, "@iv_ID_JOB", DbType.Int32, jobNo)
                    objDB.AddInParameter(objcmd, "@IV_ID_PREV_JOBNO", DbType.Int32, Nothing)
                    objDB.AddInParameter(objcmd, "@IV_ID_MEC_TR", DbType.String, mechId)
                    objDB.AddInParameter(objcmd, "@iv_DAY_CLOCK_IN", DbType.String, dtClockin)
                    objDB.AddInParameter(objcmd, "@iv_HR_CLOCK_IN", DbType.String, timeClockin)
                    objDB.AddInParameter(objcmd, "@iv_DAY_CLOCK_OUT", DbType.String, dtClockout)
                    objDB.AddInParameter(objcmd, "@iv_HR_CLOCK_OUT", DbType.String, timeClockout)
                    objDB.AddInParameter(objcmd, "@iv_ID_UNSOLD_TIME", DbType.String, unsoldTime)
                    objDB.AddInParameter(objcmd, "@iv_STATUS", DbType.String, String.Empty)
                    objDB.AddOutParameter(objcmd, "@OV_RETURN", DbType.String, 10)
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@OV_RETURN").ToString
                End Using
                Return strStatus
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function SearchMechanicDetails(ByVal mechId As String, ByVal mechName As String, ByVal fromDate As String, ByVal orderNo As String, ByVal jobNo As String, ByVal flgOrders As String, ByVal flgUnsold As String) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_TR_CTPMECH_FETCH")
                    objDB.AddInParameter(objcmd, "@IV_MECH_CODE", DbType.String, IIf(mechId = "", Nothing, mechId))
                    objDB.AddInParameter(objcmd, "@IV_MECH_NAME", DbType.String, IIf(mechName = "", Nothing, mechName))
                    objDB.AddInParameter(objcmd, "@IV_FROM_DATE", DbType.String, fromDate)
                    objDB.AddInParameter(objcmd, "@IV_TO_DATE", DbType.String, fromDate)
                    objDB.AddInParameter(objcmd, "@IV_ID_WO_NO", DbType.String, orderNo)
                    objDB.AddInParameter(objcmd, "@IV_ID_JOB", DbType.Int32, Convert.ToInt32(jobNo))
                    objDB.AddInParameter(objcmd, "@IV_ID_MR", DbType.Int32, 0)
                    objDB.AddInParameter(objcmd, "@IV_ID_DEPT", DbType.Int32, HttpContext.Current.Session("UserDept"))
                    objDB.AddInParameter(objcmd, "@IV_FLG_ORDERS", DbType.Boolean, flgOrders)
                    objDB.AddInParameter(objcmd, "@IV_FLG_UNSOLD", DbType.Boolean, flgUnsold)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function FetchJobs(ByVal WoNo As String) As DataSet
            Try
                Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_TR_FETCH_JOB")
                    objDB.AddInParameter(objCMD, "@iv_WO_NO", DbType.String, WoNo)
                    Return objDB.ExecuteDataSet(objCMD)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
    End Class
End Namespace