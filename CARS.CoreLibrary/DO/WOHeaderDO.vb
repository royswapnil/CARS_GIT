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
Namespace CARS.WOHeader
    Public Class WOHeaderDO
        Dim ConnectionString As String
        Dim objDB As Database
        Dim strStatus As String
        Public Sub New()
            ConnectionString = System.Configuration.ConfigurationManager.AppSettings("MSGConstr")
            objDB = New SqlDatabase(ConnectionString)
        End Sub
        Public Function Fetch_WO_Config() As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("usp_WO_HEADER_LOAD")
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Fetch_Alpha_Vehicle(ByVal vehicle As String) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_MAS_VEH_FILL")
                    objDB.AddInParameter(objcmd, "@IV_SEARCH", DbType.String, vehicle)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Add_WOHeader(ByVal objWOHeaderBO As WOHeaderBO) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("usp_WO_HEADER_INSERT")
                    objDB.AddInParameter(objcmd, "@iv_CREATED_BY", DbType.String, objWOHeaderBO.Created_By)
                    objDB.AddInParameter(objcmd, "@id_DT_DELIVERY", DbType.String, objWOHeaderBO.Dt_Delivery)
                    objDB.AddInParameter(objcmd, "@id_DT_FINISH", DbType.String, objWOHeaderBO.Dt_Finish)
                    objDB.AddInParameter(objcmd, "@id_DT_ORDER", DbType.String, objWOHeaderBO.Dt_Order)
                    objDB.AddInParameter(objcmd, "@iv_ID_CUST_WO", DbType.String, objWOHeaderBO.Id_Cust_Wo)
                    objDB.AddInParameter(objcmd, "@iv_CUST_GROUP_ID", DbType.String, objWOHeaderBO.Cust_Group)
                    objDB.AddInParameter(objcmd, "@iv_ID_PAY_TERMS_WO", DbType.String, objWOHeaderBO.Id_Pay_Terms_WO)
                    objDB.AddInParameter(objcmd, "@iv_ID_PAY_TYPE_WO", DbType.String, objWOHeaderBO.Id_Pay_Type_WO)
                    objDB.AddInParameter(objcmd, "@iv_ID_VEH_SEQ_WO", DbType.Int32, objWOHeaderBO.Id_Veh_Seq_WO)
                    objDB.AddInParameter(objcmd, "@iv_ID_WO_NO", DbType.String, objWOHeaderBO.Id_WO_NO)
                    objDB.AddInParameter(objcmd, "@ii_ID_ZIPCODE_WO", DbType.String, objWOHeaderBO.Id_Zipcode_WO)
                    objDB.AddInParameter(objcmd, "@iv_WO_ANNOT", DbType.String, objWOHeaderBO.WO_Annot)
                    objDB.AddInParameter(objcmd, "@iv_WO_CUST_NAME", DbType.String, objWOHeaderBO.WO_Cust_Name)
                    objDB.AddInParameter(objcmd, "@iv_WO_CUST_PERM_ADD1", DbType.String, objWOHeaderBO.WO_Cust_Add1)
                    objDB.AddInParameter(objcmd, "@iv_WO_CUST_PERM_ADD2", DbType.String, objWOHeaderBO.Cust_Perm_Add2)
                    objDB.AddInParameter(objcmd, "@iv_WO_CUST_PHONE_HOME", DbType.String, objWOHeaderBO.WO_Cust_Phone_Home)
                    objDB.AddInParameter(objcmd, "@iv_WO_CUST_PHONE_MOBILE", DbType.String, objWOHeaderBO.WO_Cust_Phone_Mobile)
                    objDB.AddInParameter(objcmd, "@iv_WO_CUST_PHONE_OFF", DbType.String, objWOHeaderBO.WO_Cust_Phone_Off)
                    objDB.AddInParameter(objcmd, "@iv_WO_STATUS", DbType.String, objWOHeaderBO.WO_Status)
                    objDB.AddInParameter(objcmd, "@iv_WO_TM_DELIV", DbType.String, objWOHeaderBO.WO_Tm_Deliv)
                    objDB.AddInParameter(objcmd, "@iv_WO_TYPE_WOH", DbType.String, objWOHeaderBO.WO_Type)
                    objDB.AddInParameter(objcmd, "@id_WO_VEH_HRS", DbType.Decimal, objWOHeaderBO.WO_Veh_Hrs)
                    objDB.AddInParameter(objcmd, "@id_WO_VEH_INTERN_NO", DbType.String, objWOHeaderBO.WO_Veh_ERN_NO)
                    objDB.AddInParameter(objcmd, "@id_WO_VEH_MILEAGE", DbType.Int32, objWOHeaderBO.WO_Veh_Mileage)
                    objDB.AddInParameter(objcmd, "@iv_WO_VEH_REG_NO", DbType.String, objWOHeaderBO.WO_Veh_Reg_NO)
                    objDB.AddInParameter(objcmd, "@iv_WO_VEH_VIN", DbType.String, objWOHeaderBO.WO_Veh_Vin)
                    objDB.AddInParameter(objcmd, "@ii_WO_VEH_Model", DbType.String, objWOHeaderBO.Id_Model)
                    objDB.AddInParameter(objcmd, "@iv_WO_VEH_Make", DbType.String, objWOHeaderBO.Veh_Make)
                    objDB.AddInParameter(objcmd, "@IV_CUSTPSTATE", DbType.String, objWOHeaderBO.PState)
                    objDB.AddInParameter(objcmd, "@IV_CUSTPCOUNTRY", DbType.String, objWOHeaderBO.PCountry)
                    objDB.AddOutParameter(objcmd, "@0V_RETVALUE", DbType.String, 10)
                    objDB.AddOutParameter(objcmd, "@0V_RETWONO", DbType.String, 60)
                    objDB.AddInParameter(objcmd, "@IV_PKKDate", DbType.String, objWOHeaderBO.WO_PKKDate)
                    objDB.AddInParameter(objcmd, "@BUS_PEK_PREVIOUS_NUM", DbType.String, objWOHeaderBO.Buspek_Previous_No)
                    objDB.AddInParameter(objcmd, "@BUS_PEK_CONTROL_NUM", DbType.String, objWOHeaderBO.Buspek_Control_No)
                    objDB.AddInParameter(objcmd, "@UPDATE_VEH_FLAG", DbType.Boolean, objWOHeaderBO.Veh_Update_flag)
                    objDB.AddInParameter(objcmd, "@FLG_CONFIGZIPCODE", DbType.Boolean, objWOHeaderBO.Flg_ConfigZipCode)
                    objDB.AddInParameter(objcmd, "@IV_DEPT_ACCNT_NUM", DbType.String, objWOHeaderBO.Dept_Accnt_Num)
                    objDB.AddInParameter(objcmd, "@VA_COST_PRICE", DbType.Decimal, objWOHeaderBO.VA_Cost_Price)
                    objDB.AddInParameter(objcmd, "@VA_SELL_PRICE", DbType.Decimal, objWOHeaderBO.VA_Sell_Price)
                    objDB.AddInParameter(objcmd, "@VA_NUMBER", DbType.String, objWOHeaderBO.VA_Number)
                    objDB.AddInParameter(objcmd, "@VEH_TYPE", DbType.String, objWOHeaderBO.Veh_Type)
                    objDB.AddInParameter(objcmd, "@VEH_GRP_DESC", DbType.String, objWOHeaderBO.Veh_Grpdesc)
                    objDB.AddInParameter(objcmd, "@FLG_UPD_MILEAGE", DbType.Boolean, objWOHeaderBO.Flg_Upd_Mileage)
                    objDB.AddInParameter(objcmd, "@IV_INT_NOTE", DbType.String, objWOHeaderBO.Int_Note)
                    objDB.AddInParameter(objcmd, "@REGN_DATE", DbType.String, objWOHeaderBO.Regn_Date)
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@0V_RETWONO").ToString + ";" + objDB.GetParameterValue(objcmd, "@0V_RETVALUE").ToString
                End Using
                Return strStatus
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Fetch_WOHeader(ByVal objWOHeaderBO As WOHeaderBO) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("usp_WO_HEADER_FETCH")
                    objDB.AddInParameter(objcmd, "@iv_ID_PR_NO", DbType.String, objWOHeaderBO.Id_WO_Prefix)
                    objDB.AddInParameter(objcmd, "@iv_ID_WO_NO", DbType.String, objWOHeaderBO.Id_WO_NO)
                    objDB.AddInParameter(objcmd, "@iv_UserID", DbType.String, objWOHeaderBO.Created_By)
                    objDB.AddInParameter(objcmd, "@IV_LANG", DbType.String, System.Configuration.ConfigurationManager.AppSettings("Language").ToString())
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Delete_WOHeader(ByVal objWOHeaderBO As WOHeaderBO) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("usp_WO_JOBS_DELETE")
                    objDB.AddInParameter(objcmd, "@iv_xmlDoc", DbType.String, objWOHeaderBO.Id_WO_NO)
                    objDB.AddOutParameter(objcmd, "@ov_RetValue", DbType.String, 10)
                    objDB.AddOutParameter(objcmd, "@ov_CntDelete", DbType.String, 2000)
                    objDB.AddOutParameter(objcmd, "@ov_DeletedCfg", DbType.String, 2000)
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = CStr(objDB.GetParameterValue(objcmd, "@ov_RetValue") + "," + Replace(CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@ov_DeletedCfg")), "", objDB.GetParameterValue(objcmd, "@ov_DeletedCfg"))), ",", "") + "," + Replace(CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@ov_CntDelete")), "", objDB.GetParameterValue(objcmd, "@ov_CntDelete"))), ",", ""))
                End Using
                Return strStatus
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Update_WOHeader(ByVal objWOHeaderBO As WOHeaderBO) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("usp_WO_HEADER_UPD")
                    objDB.AddInParameter(objcmd, "@iv_Modified_BY", DbType.String, objWOHeaderBO.Created_By)
                    objDB.AddInParameter(objcmd, "@id_DT_DELIVERY", DbType.String, objWOHeaderBO.Dt_Delivery)
                    objDB.AddInParameter(objcmd, "@id_DT_FINISH", DbType.String, objWOHeaderBO.Dt_Finish)
                    objDB.AddInParameter(objcmd, "@id_DT_ORDER", DbType.String, objWOHeaderBO.Dt_Order)
                    objDB.AddInParameter(objcmd, "@iv_ID_CUST_WO", DbType.String, objWOHeaderBO.Id_Cust_Wo)
                    objDB.AddInParameter(objcmd, "@iv_CUST_GROUP_ID", DbType.String, objWOHeaderBO.Cust_Group)
                    objDB.AddInParameter(objcmd, "@iv_ID_PAY_TERMS_WO", DbType.String, objWOHeaderBO.Id_Pay_Terms_WO)
                    objDB.AddInParameter(objcmd, "@iv_ID_PAY_TYPE_WO", DbType.String, objWOHeaderBO.Id_Pay_Type_WO)
                    objDB.AddInParameter(objcmd, "@iv_ID_VEH_SEQ_WO", DbType.Int32, objWOHeaderBO.Id_Veh_Seq_WO)
                    objDB.AddInParameter(objcmd, "@iv_ID_WO_NO", DbType.String, objWOHeaderBO.Id_WO_NO)
                    objDB.AddInParameter(objcmd, "@ii_ID_ZIPCODE_WO", DbType.String, objWOHeaderBO.Id_Zipcode_WO)
                    objDB.AddInParameter(objcmd, "@iv_WO_ANNOT", DbType.String, objWOHeaderBO.WO_Annot)
                    objDB.AddInParameter(objcmd, "@iv_WO_CUST_NAME", DbType.String, objWOHeaderBO.WO_Cust_Name)
                    objDB.AddInParameter(objcmd, "@iv_WO_CUST_PERM_ADD1", DbType.String, objWOHeaderBO.WO_Cust_Add1)
                    objDB.AddInParameter(objcmd, "@iv_WO_CUST_PERM_ADD2", DbType.String, objWOHeaderBO.Cust_Perm_Add2)
                    objDB.AddInParameter(objcmd, "@iv_WO_CUST_PHONE_HOME", DbType.String, objWOHeaderBO.WO_Cust_Phone_Home)
                    objDB.AddInParameter(objcmd, "@iv_WO_CUST_PHONE_MOBILE", DbType.String, objWOHeaderBO.WO_Cust_Phone_Mobile)
                    objDB.AddInParameter(objcmd, "@iv_WO_CUST_PHONE_OFF", DbType.String, objWOHeaderBO.WO_Cust_Phone_Off)
                    objDB.AddInParameter(objcmd, "@iv_WO_STATUS", DbType.String, objWOHeaderBO.WO_Status)
                    objDB.AddInParameter(objcmd, "@iv_WO_TM_DELIV", DbType.String, objWOHeaderBO.WO_Tm_Deliv)
                    objDB.AddInParameter(objcmd, "@iv_WO_TYPE_WOH", DbType.String, objWOHeaderBO.WO_Type)
                    objDB.AddInParameter(objcmd, "@id_WO_VEH_HRS", DbType.Decimal, objWOHeaderBO.WO_Veh_Hrs)
                    objDB.AddInParameter(objcmd, "@id_WO_VEH_INTERN_NO", DbType.String, objWOHeaderBO.WO_Veh_ERN_NO)
                    objDB.AddInParameter(objcmd, "@id_WO_VEH_MILEAGE", DbType.Int32, objWOHeaderBO.WO_Veh_Mileage)
                    objDB.AddInParameter(objcmd, "@iv_WO_VEH_REG_NO", DbType.String, objWOHeaderBO.WO_Veh_Reg_NO)
                    objDB.AddInParameter(objcmd, "@iv_WO_VEH_VIN", DbType.String, objWOHeaderBO.WO_Veh_Vin)
                    objDB.AddInParameter(objcmd, "@ii_WO_VEH_Model", DbType.String, objWOHeaderBO.Id_Model)
                    objDB.AddInParameter(objcmd, "@iv_WO_VEH_Make", DbType.String, objWOHeaderBO.Veh_Make)
                    objDB.AddInParameter(objcmd, "@IV_CUSTPSTATE", DbType.String, objWOHeaderBO.PState)
                    objDB.AddInParameter(objcmd, "@IV_CUSTPCOUNTRY", DbType.String, objWOHeaderBO.PCountry)
                    objDB.AddOutParameter(objcmd, "@0V_RETVALUE", DbType.String, 10)
                    objDB.AddInParameter(objcmd, "@iv_ID_WO_PREFIX", DbType.String, objWOHeaderBO.Id_WO_Prefix)
                    objDB.AddInParameter(objcmd, "@IV_PKKDate", DbType.String, objWOHeaderBO.WO_PKKDate)
                    objDB.AddInParameter(objcmd, "@BUS_PEK_PREVIOUS_NUM", DbType.String, objWOHeaderBO.Buspek_Previous_No)
                    objDB.AddInParameter(objcmd, "@BUS_PEK_CONTROL_NUM", DbType.String, objWOHeaderBO.Buspek_Control_No)
                    objDB.AddInParameter(objcmd, "@UPDATE_VEH_FLAG", DbType.Boolean, objWOHeaderBO.Veh_Update_flag)
                    objDB.AddInParameter(objcmd, "@FLG_CONFIGZIPCODE", DbType.Boolean, objWOHeaderBO.Flg_ConfigZipCode)
                    objDB.AddInParameter(objcmd, "@IV_DEPT_ACCNT_NUM", DbType.String, objWOHeaderBO.Dept_Accnt_Num)
                    objDB.AddInParameter(objcmd, "@VA_COST_PRICE", DbType.Decimal, objWOHeaderBO.VA_Cost_Price)
                    objDB.AddInParameter(objcmd, "@VA_SELL_PRICE", DbType.Decimal, objWOHeaderBO.VA_Sell_Price)
                    objDB.AddInParameter(objcmd, "@VA_NUMBER", DbType.String, objWOHeaderBO.VA_Number)
                    objDB.AddInParameter(objcmd, "@REGN_DATE", DbType.String, objWOHeaderBO.Regn_Date)
                    objDB.AddInParameter(objcmd, "@VEH_TYPE", DbType.String, objWOHeaderBO.Veh_Type)
                    objDB.AddInParameter(objcmd, "@VEH_GRP_DESC", DbType.String, objWOHeaderBO.Veh_Grpdesc)
                    objDB.AddInParameter(objcmd, "@FLG_UPD_MILEAGE", DbType.Boolean, objWOHeaderBO.Flg_Upd_Mileage)
                    objDB.AddInParameter(objcmd, "@IV_INT_NOTE", DbType.String, objWOHeaderBO.Int_Note)
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@0V_RETVALUE").ToString
                End Using
                Return strStatus
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Cust_Sel_Detail(ByVal objWOHeaderBO As WOHeaderBO) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("usp_WO_Sel_UsrDet")
                    objDB.AddInParameter(objcmd, "@IVCUSTID", DbType.String, objWOHeaderBO.Id_Cust_Wo)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Veh_Sel_Detail(ByVal objWOHeaderBO As WOHeaderBO) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("usp_WO_Sel_VehDet")
                    objDB.AddInParameter(objcmd, "@IVVEHID", DbType.String, objWOHeaderBO.Id_Veh_Seq_WO)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function FetchOrderHistory(ByVal objWOHeaderBO As WOHeaderBO) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_WO_HISTORYSEARCH")
                    objDB.AddInParameter(objcmd, "@IV_FROM_DATE", DbType.String, objWOHeaderBO.Dt_Order_From)
                    objDB.AddInParameter(objcmd, "@IV_TO_DATE", DbType.String, objWOHeaderBO.Dt_Order_To)
                    objDB.AddInParameter(objcmd, "@IV_SEARCH_TXT", DbType.String, objWOHeaderBO.Search_Txt)
                    objDB.AddInParameter(objcmd, "@IV_CUSTOMER_TXT", DbType.String, objWOHeaderBO.Customer_Txt)
                    objDB.AddInParameter(objcmd, "@IV_VEHICLE_TXT", DbType.String, objWOHeaderBO.Vehicle_Txt)
                    objDB.AddInParameter(objcmd, "@IV_ORDER_TXT", DbType.String, objWOHeaderBO.Order_Txt)
                    objDB.AddInParameter(objcmd, "@IV_INVOICE_TXT", DbType.String, objWOHeaderBO.Invoice_Txt)
                    objDB.AddInParameter(objcmd, "@IV_CREATED_BY", DbType.String, objWOHeaderBO.Created_By)
                    objDB.AddInParameter(objcmd, "@CONTROLNUM", DbType.String, objWOHeaderBO.Control_Num)
                    objDB.AddInParameter(objcmd, "@IV_TOCUSTOMER_TXT", DbType.String, objWOHeaderBO.ToCustomer_Txt)
                    objDB.AddInParameter(objcmd, "@SORTCOLUMN", DbType.String, objWOHeaderBO.SortColumn)
                    objDB.AddInParameter(objcmd, "@SORTORDER", DbType.String, objWOHeaderBO.SortOrder)
                    objDB.AddInParameter(objcmd, "@STARTROWINDEX", DbType.Int32, objWOHeaderBO.StartRowIndex)
                    objDB.AddInParameter(objcmd, "@MAXIMUMROWS", DbType.Int32, objWOHeaderBO.MaximumRows)
                    objDB.AddOutParameter(objcmd, "@TOTALROWS", DbType.Int32, 0)
                    objDB.AddInParameter(objcmd, "@IV_Lang", DbType.String, System.Configuration.ConfigurationManager.AppSettings("Language").ToString())
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Fetch_DefectNote(ByVal objWOHeaderBO As WOHeaderBO) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_WO_DEFECT_FETCH")
                    objDB.AddInParameter(objcmd, "@iv_ID_VEH_SEQ", DbType.String, objWOHeaderBO.Id_Veh_Seq_WO)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Check_JobNo(ByVal objWOHeaderBO As WOHeaderBO) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CHECK_JOBNO")
                    objDB.AddInParameter(objcmd, "@IV_ID_WO_NO", DbType.String, objWOHeaderBO.Id_WO_NO)
                    objDB.AddInParameter(objcmd, "@IV_ID_WO_PREFIX", DbType.String, objWOHeaderBO.Id_WO_Prefix)
                    objDB.AddInParameter(objcmd, "@ID_JOB", DbType.String, objWOHeaderBO.Id_Job)

                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Fetch_Defects() As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_DEFECTS_FETCH")
                    objDB.AddInParameter(objcmd, "@iv_Lang", DbType.String, System.Configuration.ConfigurationManager.AppSettings("Language").ToString())
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Add_Defects(ByVal objWOHeaderBO As WOHeaderBO) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_VEHICLE_DEFECT_INSERT")
                    objDB.AddInParameter(objcmd, "@II_VEH_SEQ", DbType.Int32, objWOHeaderBO.Id_Veh_Seq_WO)
                    objDB.AddInParameter(objcmd, "@IV_DEF_NOTE", DbType.String, objWOHeaderBO.DefectDesc)
                    objDB.AddInParameter(objcmd, "@IV_CREATED_BY", DbType.String, objWOHeaderBO.LoginId)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Print_WOJobCard(ByVal xmlWONo As String) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_RPT_WO_JOB_CARD")
                    objDB.AddInParameter(objcmd, "@IV_WO_NO", DbType.String, xmlWONo)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Print_WOJobCardDetail(ByVal xmlWONo As String) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_RPT_WO_JOB_CARD_REPORT")
                    objDB.AddInParameter(objcmd, "@IV_WO_NO", DbType.String, xmlWONo)
                    objDB.AddInParameter(objcmd, "@IV_LANGUAGE", DbType.String, System.Configuration.ConfigurationManager.AppSettings("Language").ToString())
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Fetch_Service_Call(ByVal objWOHeaderBO As WOHeaderBO) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("usp_WO_SER_CALL_FETCH")
                    objDB.AddInParameter(objcmd, "@IV_ID_VEH_SEQ", DbType.Int32, objWOHeaderBO.Id_Veh_Seq_WO)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function WO_JobPlanDt_Fetch(ByVal objWOHeaderBO As WOHeaderBO) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_WO_DT_PLANNED_RETRIEVE")
                    objDB.AddInParameter(objcmd, "@ID_WO_NO", DbType.String, objWOHeaderBO.Id_WO_NO)
                    objDB.AddInParameter(objcmd, "@ID_WO_PREFIX", DbType.String, objWOHeaderBO.Id_WO_Prefix)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Update_Customerdetails(ByVal objWOHeaderBO As WOHeaderBO) As String
            Try
                Dim isSuccess As String
                Dim errorMessage As String
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_WO_CUSTOMER_UDPATE")
                    objDB.AddInParameter(objcmd, "@IV_CUSTOMERID", DbType.String, objWOHeaderBO.Cust_ID)
                    objDB.AddInParameter(objcmd, "@IV_CONTACTPERSON", DbType.String, objWOHeaderBO.Cust_Contactperson)
                    objDB.AddInParameter(objcmd, "@IV_CREDITLIMIT", DbType.Decimal, objWOHeaderBO.Cust_Credit_Limit)
                    objDB.AddInParameter(objcmd, "@IV_HOMEPHONE", DbType.String, objWOHeaderBO.WO_Cust_Phone_Home)
                    objDB.AddInParameter(objcmd, "@IV_OFFICEPHONE", DbType.String, objWOHeaderBO.WO_Cust_Phone_Off)
                    objDB.AddInParameter(objcmd, "@IV_FAXNO", DbType.String, objWOHeaderBO.Cust_Fax)
                    objDB.AddInParameter(objcmd, "@IV_MOBILE", DbType.String, objWOHeaderBO.WO_Cust_Phone_Mobile)
                    objDB.AddInParameter(objcmd, "@IV_EMAIL", DbType.String, objWOHeaderBO.Cust_Email)
                    objDB.AddInParameter(objcmd, "@IV_PRICECODE", DbType.String, objWOHeaderBO.Cust_Pricecode)
                    objDB.AddInParameter(objcmd, "@IV_ACCOUNTNO", DbType.String, objWOHeaderBO.Cust_Account_No)
                    objDB.AddInParameter(objcmd, "@IV_DISCOUNTCODE", DbType.String, objWOHeaderBO.Cust_Discount_Code)
                    objDB.AddInParameter(objcmd, "@IV_MODIFIEDBY", DbType.String, objWOHeaderBO.Modified_By)
                    objDB.AddOutParameter(objcmd, "@ISSUCCESS", DbType.Boolean, False)
                    objDB.AddOutParameter(objcmd, "@ERRMSG", DbType.String, 200)
                    objDB.ExecuteDataSet(objcmd)
                    isSuccess = objDB.GetParameterValue(objcmd, "@ISSUCCESS").ToString
                    errorMessage = objDB.GetParameterValue(objcmd, "@ERRMSG").ToString
                    strStatus = isSuccess + ";" + errorMessage
                End Using
            Catch ex As Exception
                Throw ex
            End Try
            Return strStatus
        End Function
        Public Function GetNextPKK(ByVal objWOHeaderBO As WOHeaderBO) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_MAS_GET_PKK_DATE")
                    objDB.AddInParameter(objcmd, "@IV_REGN_NO", DbType.String, objWOHeaderBO.WO_Veh_Reg_NO)
                    Return objDB.ExecuteScalar(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function CountTPKKDate(ByVal objWOHeaderBO As WOHeaderBO) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_WO_COUNT_PKKDATE")
                    objDB.AddInParameter(objcmd, "@IV_VEH_REG_NO", DbType.String, objWOHeaderBO.WO_Veh_Reg_NO)
                    objDB.AddInParameter(objcmd, "@IV_CUSTID", DbType.String, objWOHeaderBO.Cust_ID)
                    objDB.AddInParameter(objcmd, "@IV__PKKDATE", DbType.String, objWOHeaderBO.WO_PKKDate)
                    Return objDB.ExecuteScalar(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function GetRegNoAndInterval(ByVal objWOHeaderBO As WOHeaderBO) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_WO_VEH_REGNO_INTERVAL")
                    objDB.AddInParameter(objcmd, "@IV_VEH_REG_NO", DbType.String, objWOHeaderBO.WO_Veh_Reg_NO)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Check_BUSPEKControlNo(ByVal objWOHeaderBO As WOHeaderBO) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_VEHICLE_CHECKBUSPEK")
                    objDB.AddInParameter(objcmd, "@ID_CUST_WO", DbType.String, objWOHeaderBO.Id_Cust_Wo)
                    objDB.AddInParameter(objcmd, "@WO_VEH_REG_NO", DbType.String, objWOHeaderBO.Cust_ID)
                    objDB.AddInParameter(objcmd, "@ID_WO_NO", DbType.String, objWOHeaderBO.Id_WO_NO)
                    objDB.AddInParameter(objcmd, "@ID_WO_PREFIX", DbType.String, objWOHeaderBO.Id_WO_Prefix)
                    objDB.AddOutParameter(objcmd, "@ERRMSG", DbType.String, objWOHeaderBO.ErrorMessage)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Veh_Model_group(ByVal objWOHeaderBO As WOHeaderBO) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_MAS_MODELGROUP_MAKE_MAP")
                    objDB.AddInParameter(objcmd, "@MakeCodeID", DbType.String, objWOHeaderBO.Id_Make)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Load_Model_Grp() As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_MAS_MODELGROUP")
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Fetch_NonInvoiced_Orders(ByVal objWOHeaderBO As WOHeaderBO) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_GET_NOT_INVOICED")
                    objDB.AddInParameter(objcmd, "@ID_CUST_WO", DbType.String, objWOHeaderBO.Id_Cust_Wo)
                    objDB.AddInParameter(objcmd, "@UserID", DbType.String, objWOHeaderBO.Created_By)
                    objDB.AddInParameter(objcmd, "@PageIndex", DbType.String, objWOHeaderBO.PageIndex)
                    objDB.AddInParameter(objcmd, "@PageSize", DbType.String, objWOHeaderBO.PageSize)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Update_VehicleDetails(ByVal objWOHeaderBO As WOHeaderBO) As String
            Try
           
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_MAS_Vehicle_Update")
                    objDB.AddInParameter(objcmd, "@IV_VEH_REG_NO", DbType.String, objWOHeaderBO.WO_Veh_Reg_NO)
                    objDB.AddInParameter(objcmd, "@IV_VEH_INTERN_NO", DbType.String, objWOHeaderBO.WO_Veh_ERN_NO)
                    objDB.AddInParameter(objcmd, "@IV_VEH_VIN", DbType.String, objWOHeaderBO.WO_Veh_Vin)
                    objDB.AddInParameter(objcmd, "@IV_ID_MAKE_VEH", DbType.String, objWOHeaderBO.Id_Make)
                    objDB.AddInParameter(objcmd, "@IV_ID_MODEL_VEH", DbType.String, objWOHeaderBO.Id_Model)
                    objDB.AddInParameter(objcmd, "@IV_VEH_TYPE", DbType.String, objWOHeaderBO.Veh_Type)
                    objDB.AddInParameter(objcmd, "@IV_VEH_ERGN_DT", DbType.String, objWOHeaderBO.Dt_Veh_Regn)
                    objDB.AddInParameter(objcmd, "@ID_VEH_MILEAGE", DbType.String, objWOHeaderBO.WO_Veh_Mileage)
                    objDB.AddInParameter(objcmd, "@IV_VEH_MIL_REGN_DT", DbType.String, objWOHeaderBO.Dt_Veh_Mil_Regn)
                    objDB.AddInParameter(objcmd, "@ID_VEH_HRS", DbType.String, objWOHeaderBO.WO_Veh_Hrs)
                    objDB.AddInParameter(objcmd, "@IV_VEH_HRS_ERGN_DT", DbType.String, objWOHeaderBO.Dt_Veh_Hrs_Regn)
                    objDB.AddInParameter(objcmd, "@II_VEH_MDL_YEAR", DbType.String, objWOHeaderBO.Veh_Mdl_Year)

                    objDB.AddInParameter(objcmd, "@IV_ID_MODEL_RP", DbType.String, objWOHeaderBO.Id_Model_RP)
                    objDB.AddInParameter(objcmd, "@II_ID_GROUP_VEH", DbType.String, objWOHeaderBO.Veh_Grpdesc)
                    objDB.AddInParameter(objcmd, "@IV_ID_CUSTOMER_VEH", DbType.String, objWOHeaderBO.Id_Cust_Wo)
                    objDB.AddInParameter(objcmd, "@IV_VEH_DRIVER", DbType.String, objWOHeaderBO.Veh_Driver)
                    objDB.AddInParameter(objcmd, "@IV_VEH_MOBILE", DbType.String, objWOHeaderBO.Veh_Mobile)
                    objDB.AddInParameter(objcmd, "@IV_VEH_PHONE1", DbType.String, objWOHeaderBO.Veh_Phone1)
                    objDB.AddInParameter(objcmd, "@IV_VEH_DRV_IDEMIAL", DbType.String, objWOHeaderBO.Veh_Drv_Emailid)
                    objDB.AddInParameter(objcmd, "@IB_VEH_FLG_SERVICE_PLAN", DbType.Boolean, objWOHeaderBO.Veh_Flg_Service_Plan)
                    objDB.AddInParameter(objcmd, "@IB_VEH_FLG_ADDON", DbType.Boolean, objWOHeaderBO.Veh_Flg_AddOn)
                    objDB.AddInParameter(objcmd, "@IV_ID_ADDON_LOCDEPT", DbType.String, objWOHeaderBO.Id_AddOn_LocDept)
                    objDB.AddInParameter(objcmd, "@IV_VEH_ANNOT", DbType.String, objWOHeaderBO.Veh_Annot)
                    objDB.AddInParameter(objcmd, "@II_ID_SER_TYP", DbType.String, objWOHeaderBO.Veh_Srv_Type)
                    objDB.AddInParameter(objcmd, "@IV_CREATED_BY", DbType.String, objWOHeaderBO.Created_By)
                    objDB.AddInParameter(objcmd, "@IV_ID_OWNER_VEH", DbType.String, objWOHeaderBO.Veh_OwnerName)
                    objDB.AddInParameter(objcmd, "@II_ID_VEH_SEQ", DbType.String, objWOHeaderBO.Id_Veh_Seq_WO)
                    objDB.AddInParameter(objcmd, "@ID_DT_MODIFIED", DbType.String, objWOHeaderBO.Dt_Modified)
                    objDB.AddInParameter(objcmd, "@ID_VAT_CODE", DbType.String, objWOHeaderBO.Id_Vat_Code)
                   
                    objDB.AddOutParameter(objcmd, "@OV_RETVALUE", DbType.String, 200)
                    objDB.AddOutParameter(objcmd, "@OI_ID_VEH_SEQ", DbType.Int32, 10)
                    objDB.AddInParameter(objcmd, "@COST_PRICE", DbType.Decimal, objWOHeaderBO.VA_Cost_Price)
                    objDB.AddInParameter(objcmd, "@SELL_PRICE", DbType.Decimal, objWOHeaderBO.VA_Sell_Price)
                    objDB.AddInParameter(objcmd, "@VA_ACC_CODE", DbType.String, objWOHeaderBO.VA_Acc_Code)
                    objDB.AddInParameter(objcmd, "@ID_WO_NO", DbType.String, objWOHeaderBO.Id_WO_NO)
                    objDB.AddInParameter(objcmd, "@ID_WO_PREFIX", DbType.String, objWOHeaderBO.Id_WO_Prefix)
                    objDB.AddInParameter(objcmd, "@ID_JOB", DbType.Int32, objWOHeaderBO.Id_Job)
                    objDB.AddInParameter(objcmd, "@IV_PICK", DbType.String, objWOHeaderBO.Pick)
                    objDB.AddInParameter(objcmd, "@IV_VAN_NUM", DbType.String, objWOHeaderBO.Van_Num)

                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@OV_RETVALUE").ToString + ";" + objDB.GetParameterValue(objcmd, "@OI_ID_VEH_SEQ").ToString
                End Using
            Catch ex As Exception
                Throw ex
            End Try
            Return strStatus
        End Function
        Public Function deb_details(ByVal objWOHeaderBO As WOHeaderBO) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_WO_CUSTCREDIT_NEW")
                    objDB.AddInParameter(objcmd, "@iv_CUST", DbType.String, objWOHeaderBO.Id_Cust_Wo)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function UpdateWOHeadPickingListPrevPrinted(ByVal idWONO As String, ByVal idWOPrefix As String)
            Dim count As Integer = 0
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_REP_WOHEAD_PICKINGLIST_UPD_PREVPRINTED")
                    objDB.AddInParameter(objcmd, "@ID_WO_NO", DbType.String, idWONO)
                    objDB.AddInParameter(objcmd, "@ID_WO_PREFIX", DbType.String, idWOPrefix)
                    count = objDB.ExecuteNonQuery(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
            Return count
        End Function
        Public Function Check_Veh_Exist(ByVal objWOHeaderBO As WOHeaderBO) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CHECK_VEHICLE")
                    objDB.AddInParameter(objcmd, "@VehNo", DbType.String, objWOHeaderBO.WO_Veh_Reg_NO)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Check_Cust_Exist(ByVal objWOHeaderBO As WOHeaderBO) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CHECK_CUSTOMER")
                    objDB.AddInParameter(objcmd, "@CustNo", DbType.String, objWOHeaderBO.Cust_ID)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
    End Class
End Namespace

