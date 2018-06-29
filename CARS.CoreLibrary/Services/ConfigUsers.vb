Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Imports System.Resources
Imports System.Reflection
Imports CARS.CoreLibrary.CARS
Imports System.Web
Imports Encryption
Imports System.Configuration
Imports System
Imports MSGCOMMON
Imports System.Web.Security
Namespace CARS.Services.ConfigUsers
    Public Class Users
        Shared objConfigUserBO As New ConfigUsersBO
        Shared objConfigUserDO As New CARS.ConfigUsers.ConfigUsersDO
        Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
        Shared objEncryption As New Encryption64
        Shared objCommonUtil As New CARS.Utilities.CommonUtility
        Shared objConfigDeptDO As New CARS.Department.ConfigDepartmentDO
        Public Function FetchAllUsers(objConfigUserBO) As List(Of ConfigUsersBO)
            Dim strPassword As String = ""
            Dim dsFetchAllUser As New DataSet
            Dim dtUserDetails As DataTable
            Dim details As New List(Of ConfigUsersBO)()
            Try
                dsFetchAllUser = objConfigUserDO.Fetch_Users(objConfigUserBO)
                If (dsFetchAllUser.Tables.Count > 0) Then
                    dtUserDetails = dsFetchAllUser.Tables(0)
                    HttpContext.Current.Session("dvUserDetails") = dtUserDetails.DefaultView

                    For Each dtrow As DataRow In dtUserDetails.Rows
                        Dim userDet As New ConfigUsersBO()
                        userDet.Id_Login = dtrow("ID_Login").ToString()
                        userDet.First_Name = dtrow("First_Name").ToString()
                        userDet.Last_Name = dtrow("Last_Name").ToString()
                        userDet.Id_Role_User = dtrow("Id_Role_User").ToString()
                        strPassword = IIf(IsDBNull(dtrow("Password").ToString()) = True, "", dtrow("Password").ToString())
                        strPassword = objEncryption.Decrypt(strPassword, ConfigurationManager.AppSettings.Get("encKey"))
                        userDet.Password = strPassword
                        userDet.Id_Subsidery_User = dtrow("Id_Subsidery_User").ToString()
                        userDet.Id_Dept = dtrow("Id_Dept_User").ToString()
                        userDet.Address1 = dtrow("Address1").ToString()
                        userDet.Address2 = dtrow("Address2").ToString()
                        userDet.Id_Lang = Convert.ToInt32(IIf(IsDBNull(dtrow("Id_Lang_User")), 0, dtrow("Id_Lang_User")))
                        userDet.Id_Zip_Users = dtrow("Id_Zip_User").ToString()
                        userDet.Id_Email = dtrow("Id_Email").ToString()
                        userDet.Phone = dtrow("Phone").ToString()
                        userDet.Userid = dtrow("Us_Userid").ToString()
                        userDet.Id_Email_Acct = Convert.ToInt32(IIf(IsDBNull(dtrow("Id_Email_Acct")), 0, dtrow("Id_Email_Acct")))
                        details.Add(userDet)
                    Next
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigUsers", "FetchAllUsers", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function FetchUser(oConfigUserBO) As List(Of ConfigUsersBO)
            Dim details As New List(Of ConfigUsersBO)()
            Dim strPassword As String = ""
            Try
                Dim dsFetchUser As New DataSet
                Dim dtUser As New DataTable
                dsFetchUser = objConfigUserDO.Fetch_User(oConfigUserBO)
                If dsFetchUser.Tables.Count > 0 Then
                    dtUser = dsFetchUser.Tables(0)
                End If

                For Each dtrow As DataRow In dtUser.Rows
                    Dim userDet As New ConfigUsersBO()
                    userDet.Id_Login = dtrow("ID_Login").ToString()
                    userDet.First_Name = dtrow("First_Name").ToString()
                    userDet.Last_Name = dtrow("Last_Name").ToString()
                    userDet.Id_Role_User = dtrow("Id_Role_User").ToString()
                    strPassword = IIf(IsDBNull(dtrow("Password").ToString()) = True, "", dtrow("Password").ToString())
                    strPassword = objEncryption.Decrypt(strPassword, ConfigurationManager.AppSettings.Get("encKey"))
                    userDet.Password = strPassword
                    userDet.Confirm_Password = strPassword
                    userDet.Id_Subsidery_User = IIf(IsDBNull(dtrow("Id_Subsidery_User").ToString()), "0", dtrow("Id_Subsidery_User").ToString())
                    userDet.Id_Dept = IIf(IsDBNull(dtrow("Id_Dept_User").ToString()), "0", dtrow("Id_Dept_User").ToString())
                    userDet.Address1 = dtrow("Address1").ToString()
                    userDet.Address2 = dtrow("Address2").ToString()
                    userDet.Id_Lang = Convert.ToInt32(IIf(IsDBNull(dtrow("Id_Lang_User")), 0, dtrow("Id_Lang_User")))
                    userDet.Id_Zip_Users = dtrow("Id_Zip_User").ToString()
                    userDet.Id_Email = dtrow("Id_Email").ToString()
                    userDet.Phone = dtrow("Phone").ToString()
                    userDet.Mobileno = dtrow("Mobileno").ToString()
                    userDet.FaxNo = dtrow("FaxNo").ToString()
                    userDet.Userid = dtrow("Us_Userid").ToString()
                    userDet.Flg_Mech_Isactive = Convert.ToBoolean(IIf(IsDBNull(dtrow("Flg_Mech_Inactive").ToString()), 0, dtrow("Flg_Mech_Inactive").ToString()))
                    userDet.Flg_Use_Idletime = Convert.ToBoolean(IIf(IsDBNull(dtrow("Flg_Use_Idletime").ToString()), 0, dtrow("Flg_Use_Idletime").ToString()))
                    userDet.Common_Mechanic_Id = dtrow("Common_Mechanic_Id").ToString()
                    userDet.Social_Security_Num = dtrow("Social_Security_Num").ToString()
                    userDet.Workhrs_Frm = dtrow("Workhours_From").ToString()
                    userDet.Workhrs_To = dtrow("Workhours_To").ToString()
                    userDet.Flg_Workhrs = Convert.ToBoolean(IIf(IsDBNull(dtrow("Flg_WorkHours").ToString()), 0, dtrow("Flg_WorkHours").ToString()))
                    userDet.Flg_Duser = Convert.ToBoolean(IIf(IsDBNull(dtrow("Flg_Duser").ToString()), 0, dtrow("Flg_Duser").ToString()))
                    userDet.Id_Email_Acct = Convert.ToInt32(IIf(IsDBNull(dtrow("Id_Email_Acct")), 0, dtrow("Id_Email_Acct")))
                    userDet.Id_Country = dtrow("Country").ToString()
                    userDet.Id_State = dtrow("State").ToString()
                    userDet.Id_City = dtrow("City").ToString()
                    userDet.Flg_Mechanic = dtrow("Flg_Mechanic").ToString()
                    userDet.Created_By = IIf(IsDBNull(dtrow("Created_By").ToString()) = True, "", dtrow("Created_By").ToString())
                    userDet.Modified_By = IIf(IsDBNull(dtrow("Modified_By").ToString()) = True, "", dtrow("Modified_By").ToString())

                    If (IsDBNull(dtrow("Dt_Created").ToString())) Then
                        userDet.Dt_Created = ""
                    Else
                        userDet.Dt_Created = objCommonUtil.GetCurrentLanguageDate(dtrow("Dt_Created").ToString())
                    End If
                    If (IsDBNull(dtrow("Dt_Modified").ToString())) Then
                        userDet.Dt_Modified = ""
                    Else
                        userDet.Dt_Modified = objCommonUtil.GetCurrentLanguageDate(dtrow("Dt_Modified").ToString())
                    End If
                    details.Add(userDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigUsers", "FetchUser", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function GetDepartment(objConfigDeptBO) As List(Of ConfigDepartmentBO)
            Dim deptDetails As New List(Of ConfigDepartmentBO)()
            Dim dsFetchDept As New DataSet
            Dim dtDept As New DataTable
            Dim dvDepart As DataView
            Try
                dsFetchDept = objConfigDeptDO.GetDepartments(objConfigDeptBO)
                If dsFetchDept.Tables.Count > 0 Then
                    If dsFetchDept.Tables(0).Rows.Count > 0 Then
                        'dtDept = dsFetchDept.Tables(0)
                        dvDepart = dsFetchDept.Tables(0).DefaultView
                        dvDepart.Sort = "Dpt_Name"
                        dtDept = dvDepart.ToTable
                        For Each dtrow As DataRow In dtDept.Rows
                            Dim deptDet As New ConfigDepartmentBO()
                            deptDet.DeptId = dtrow("ID_Dept").ToString()
                            deptDet.DeptName = dtrow("Dpt_Name").ToString()
                            deptDet.SubsideryId = dtrow("Id_Subsidery_Dept").ToString()
                            deptDetails.Add(deptDet)
                        Next
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigUsers", "GetDepartment", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return deptDetails.ToList
        End Function
        Public Function FetchEmailAcct(objConfigUserBO) As List(Of ConfigUsersBO)
            Dim details As New List(Of ConfigUsersBO)()
            Try
                Dim dsEmailAccnt As DataSet
                Dim dtEmailAccnt As DataTable
                Dim dvEmailAccnt As DataView
                dsEmailAccnt = objConfigUserDO.Fetch_EmailAcct(objConfigUserBO)
                If dsEmailAccnt.Tables.Count > 0 Then
                    If dsEmailAccnt.Tables(0).Rows.Count > 0 Then
                        'dtEmailAccnt = dsEmailAccnt.Tables(0)
                        dvEmailAccnt = dsEmailAccnt.Tables(0).DefaultView
                        dvEmailAccnt.Sort = "Setting_Name"
                        dtEmailAccnt = dvEmailAccnt.ToTable
                        For Each dtrow As DataRow In dtEmailAccnt.Rows
                            Dim emailAccntDet As New ConfigUsersBO()
                            emailAccntDet.Id_Email_Acct = dtrow("Id_Email_Acct").ToString()
                            emailAccntDet.Setting_Name = dtrow("Setting_Name").ToString()
                            details.Add(emailAccntDet)
                        Next
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigUsers", "FetchEmailAcct", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function SaveUserDetails(ByVal objConfigUserBO As ConfigUsersBO, ByVal mode As String) As String
            Dim strResult As String = ""
            Try
                If mode = "Add" Then
                    strResult = objConfigUserDO.Add_User(objConfigUserBO)
                Else
                    strResult = objConfigUserDO.Update_User(objConfigUserBO)
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigUsers", "SaveUserDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strResult
        End Function
        Public Function DeleteUserDetails(objConfigUserBO) As String()
            Dim strResult As String = ""
            Dim strArray As Array
            Dim strError As String
            Dim strRecordsDeleted As String = ""
            Dim strRecordsNotDeleted As String = ""
            Try
                strResult = objConfigUserDO.Delete_User(objConfigUserBO)
                strArray = strResult.Split(",")
                strError = strArray(0)
                strRecordsDeleted = CStr(strArray(1))
                strRecordsNotDeleted = CStr(strArray(2))

                If strRecordsDeleted <> "" Then
                    strArray(0) = "DEL"
                    strArray(1) = objErrHandle.GetErrorDescParameter("DDEL", strRecordsDeleted)
                End If

                If strRecordsNotDeleted <> "" Then
                    strArray(0) = "NDEL"
                    strArray(1) = objErrHandle.GetErrorDesc("UNDEL")
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigUsers", "DeleteUserDetails", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strArray
        End Function
        Public Function SwitchPin(ByVal pinVal As pinSwitch) As String
            Dim strResult As String = ""
            Dim login As String = HttpContext.Current.Session("UserID")
            Try
                strResult = objConfigUserDO.Switch_Pin(pinVal, login)
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.SwitchPin", "PinSwitch", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strResult
        End Function
    End Class
End Namespace

