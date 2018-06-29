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
Namespace CARS.Services.ConfigRole
    Public Class Role
        Dim objConfigRoleBO As New ConfigRoleBO
        Dim objConfigRoleDO As New CARS.Role.ConfigRoleDO
        Dim dsMenuData As New DataSet
        Dim relationData As DataRelation
        Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
        Public Function GetMenuData(objConfigRoleBO) As DataSet
            Try
                dsMenuData = objConfigRoleDO.GetMenuData(objConfigRoleBO)
                If dsMenuData.Tables.Count > 0 Then
                    dsMenuData.DataSetName = "Menus"
                    dsMenuData.Tables(0).TableName = "TBL_UTIL_MOD_DETAILS"
                    relationData = New DataRelation("ParentChild", dsMenuData.Tables("TBL_UTIL_MOD_DETAILS").Columns("MenuID"), dsMenuData.Tables("TBL_UTIL_MOD_DETAILS").Columns("ParentID"), True)
                    relationData.Nested = True
                    dsMenuData.Relations.Add(relationData)
                Else
                    dsMenuData = Nothing
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigRole", "GetMenuData", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return dsMenuData
        End Function
        Public Function Fetch_Role(objConfigRoleBO) As List(Of ConfigRoleBO)
            Dim dsFetchRole As New DataSet
            Dim dtRole As New DataTable
            Dim roleDetails As New List(Of ConfigRoleBO)()
            Dim dvRoles As DataView
            Try
                dsFetchRole = objConfigRoleDO.Fetch_Role(objConfigRoleBO)
                If dsFetchRole.Tables.Count > 0 Then
                    If dsFetchRole.Tables(0).Rows.Count > 0 Then
                        'dtRole = dsFetchRole.Tables(0)
                        dvRoles = dsFetchRole.Tables(0).DefaultView
                        dvRoles.Sort = "Nm_Role"
                        dtRole = dvRoles.ToTable
                    End If
                End If
                For Each dtrow As DataRow In dtRole.Rows
                    Dim role As New ConfigRoleBO()
                    role.Id_Role = dtrow("ID_ROLE").ToString()
                    role.IdScreen = dtrow("ID_SCR_START_ROLE").ToString()
                    role.Nm_Role = dtrow("Nm_Role").ToString()
                    role.Flg_Sysadmin = dtrow("Flg_Sysadmin").ToString()
                    role.Flg_Subsidadmin = dtrow("Flg_Subsidadmin").ToString()
                    role.Flg_Deptadmin = dtrow("Flg_Deptadmin").ToString()
                    roleDetails.Add(role)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigRole", "Fetch_Role", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return roleDetails.ToList
        End Function
        Public Function RoleAccess(objConfigRoleBO) As List(Of ConfigRoleBO)
            Dim dsRoleAcc As New DataSet
            Dim dtRoleAcc As New DataTable
            Dim roleDetails As New List(Of ConfigRoleBO)()
            Try
                dsRoleAcc = objConfigRoleDO.RoleAccess(objConfigRoleBO)
                HttpContext.Current.Session("dvRoleDet") = dsRoleAcc

                If dsRoleAcc.Tables.Count > 0 Then
                    If dsRoleAcc.Tables(0).Rows.Count > 0 Then
                        dtRoleAcc = dsRoleAcc.Tables(0)
                    End If
                End If
                For Each dtrow As DataRow In dtRoleAcc.Rows
                    Dim roleAcc As New ConfigRoleBO()
                    roleAcc.IdScreen = dtrow("ID_SCR_UTIL").ToString()
                    roleAcc.ScrnName = dtrow("NAME_SCR").ToString()
                    roleAcc.Flg_Acc_Read = dtrow("ACC_READ").ToString()
                    roleAcc.Flg_Acc_Write = dtrow("ACC_WRITE").ToString()
                    roleAcc.Flg_Acc_Create = dtrow("ACC_CREATE").ToString()
                    roleAcc.Flg_Acc_Print = dtrow("ACC_PRINT").ToString()
                    roleAcc.Flg_Acc_Delete = dtrow("ACC_DELETE").ToString()
                    roleDetails.Add(roleAcc)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigRole", "RoleAccess", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return roleDetails.ToList
        End Function
        Public Function ControlAccess(objConfigRoleBO) As List(Of ConfigRoleBO)
            Dim dsRoleAcc As New DataSet
            Dim dtRoleAcc As New DataTable
            Dim roleDetails As New List(Of ConfigRoleBO)()
            Try
                dsRoleAcc = objConfigRoleDO.RoleAccess(objConfigRoleBO)
                If dsRoleAcc.Tables.Count > 0 Then
                    If dsRoleAcc.Tables(2).Rows.Count > 0 Then
                        dtRoleAcc = dsRoleAcc.Tables(2)
                    End If
                End If
                For Each dtrow As DataRow In dtRoleAcc.Rows
                    Dim roleAcc As New ConfigRoleBO()
                    roleAcc.IdConUtil = dtrow("ID_CON_UTIL").ToString()
                    roleAcc.CtrlName = dtrow("NAME_CONTROL").ToString()
                    roleAcc.Flg_Acc = dtrow("HAS_ACCESS").ToString()
                    roleDetails.Add(roleAcc)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigRole", "ControlAccess", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return roleDetails.ToList
        End Function
        Public Function CheckBoxDetails(objConfigRoleBO) As List(Of ConfigRoleBO)
            Dim dsRoleAcc As New DataSet
            Dim dtRoleAcc As New DataTable
            Dim roleDetails As New List(Of ConfigRoleBO)()
            Try
                dsRoleAcc = objConfigRoleDO.RoleAccess(objConfigRoleBO)
                If dsRoleAcc.Tables.Count > 0 Then
                    If dsRoleAcc.Tables(1).Rows.Count > 0 Then
                        dtRoleAcc = dsRoleAcc.Tables(1)
                    End If
                End If
                For Each dtrow As DataRow In dtRoleAcc.Rows
                    Dim roleAcc As New ConfigRoleBO()
                    roleAcc.IdScreen = dtrow("ID_SCR").ToString()
                    roleAcc.ScrnName = dtrow("NAME_SCR").ToString()
                    roleDetails.Add(roleAcc)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigRole", "CheckBoxDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return roleDetails.ToList
        End Function
        Public Function FetchAllScreens(objConfigRoleBO) As List(Of ConfigRoleBO)
            Dim dsScreen As New DataSet
            Dim dtScreen As New DataTable
            Dim roleDetails As New List(Of ConfigRoleBO)()
            Try
                dsScreen = objConfigRoleDO.Scr_Name_Fetch(objConfigRoleBO)
                If dsScreen.Tables.Count > 0 Then
                    If dsScreen.Tables(0).Rows.Count > 0 Then
                        dtScreen = dsScreen.Tables(0)
                    End If
                End If
                For Each dtrow As DataRow In dtScreen.Rows
                    Dim roleAcc As New ConfigRoleBO()
                    roleAcc.IdScreen = dtrow("ID_SCR").ToString()
                    roleAcc.ScrnName = dtrow("NAME_SCR").ToString()
                    roleDetails.Add(roleAcc)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigRole", "FetchAllScreens", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return roleDetails.ToList
        End Function
        Public Function SaveRoleDetails(ByVal objConfigRoleBO As ConfigRoleBO, ByVal mode As String) As String
            Dim strResult As String = ""
            Try
                If mode = "Edit" Then
                    strResult = objConfigRoleDO.UpdateRole(objConfigRoleBO)
                Else
                    strResult = objConfigRoleDO.Add_Role(objConfigRoleBO)
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigRole", "FetchAllScreens", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strResult
        End Function
        Public Function FinalSaveRole(ByVal objConfigRoleBO As ConfigRoleBO) As String
            Dim strResult As String = ""
            Try
                strResult = objConfigRoleDO.SaveSerRole(objConfigRoleBO)
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigRole", "SaveRoleDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strResult
        End Function
        Public Function RemoveRole(ByVal objConfigRoleBO As ConfigRoleBO) As String()
            Dim strResult As String = ""
            Dim strArray As Array
            Dim strError As String
            Dim strRecordsDeleted As String = ""
            Dim strRecordsNotDeleted As String = ""
            Try
                strResult = objConfigRoleDO.Remove_Role(objConfigRoleBO)
                strArray = strResult.Split(",")
                strError = strArray(0)
                strRecordsDeleted = CStr(strArray(1))
                strRecordsNotDeleted = CStr(strArray(2))
                If strError = "DEL" Then
                    If strRecordsDeleted <> "" Then
                        strArray(0) = "DEL"
                        strArray(1) = objErrHandle.GetErrorDescParameter("DDEL", strRecordsDeleted)
                    End If
                    If strRecordsNotDeleted <> "" Then
                        strArray(0) = "NDEL"
                        strArray(1) = objErrHandle.GetErrorDesc("UNDEL")
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigRole", "RemoveRole", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strArray
        End Function
    End Class
End Namespace
