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
Imports Microsoft.VisualBasic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports Microsoft.Practices.EnterpriseLibrary.Data.Sql
Imports System.Data.Common
Imports System.Windows.Forms
Namespace CARS.Services.RepPackCode
    Public Class RepPackCode
        Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
        Shared objRPBO As New RepPackCodeBO
        Shared objRPDO As New CARS.RepPackCode.RepPackCodeDO
        Shared objCommonUtil As New Utilities.CommonUtility
        Shared objConfigSettingsDO As New CARS.ConfigSettings.ConfigSettingsDO
        Public Function FetchAllRepPkgConfig() As Collection
            Dim dsRPConfig As New DataSet
            Dim dtRPConfig As New DataTable
            Dim dtRPConfigColl As New Collection
            Try
                dsRPConfig = objRPDO.Fetch_RPkgCode()
                If dsRPConfig.Tables.Count > 0 Then

                    'Repair Package Category
                    If (dsRPConfig.Tables(0).Rows.Count > 0) Then
                        dtRPConfig = dsRPConfig.Tables(0)
                        Dim details As New List(Of RepPackCodeBO)()
                        For Each dtrow As DataRow In dtRPConfig.Rows
                            Dim rpCodeDet As New RepPackCodeBO()
                            rpCodeDet.IdRepairPkgCatg = dtrow("ID_SETTINGS").ToString()
                            rpCodeDet.IdConfig = dtrow("ID_CONFIG").ToString()
                            rpCodeDet.RepairPkgDesc = dtrow("DESCRIPTION").ToString()
                            details.Add(rpCodeDet)
                        Next
                        dtRPConfigColl.Add(details)
                    ElseIf (dsRPConfig.Tables(0).Rows.Count = 0) Then
                        dtRPConfig = dsRPConfig.Tables(0)
                        Dim details As New List(Of RepPackCodeBO)()
                        dtRPConfigColl.Add(details)
                    End If

                    'Repair Code
                    If (dsRPConfig.Tables(1).Rows.Count > 0) Then
                        dtRPConfig = dsRPConfig.Tables(1)
                        Dim details As New List(Of RepPackCodeBO)()
                        For Each dtrow As DataRow In dtRPConfig.Rows
                            Dim rpCodeDet As New RepPackCodeBO()
                            rpCodeDet.IdRepCode = dtrow("ID_REP_CODE").ToString()
                            rpCodeDet.RP_Repcode_Desc = dtrow("RP_REPCODE_DES").ToString()
                            rpCodeDet.IsDefault = dtrow("IsDefault").ToString()
                            rpCodeDet.IsDefaultValue = dtrow("Default_Value").ToString()
                            If (IIf(IsDBNull(dtrow("IsPkk").ToString()) = True, "", dtrow("IsPkk")) = "1") Then
                                rpCodeDet.IsPKK = dtrow("RP_REPCODE_DES").ToString()
                            Else
                                rpCodeDet.IsPKK = ""
                            End If

                            details.Add(rpCodeDet)
                        Next
                        dtRPConfigColl.Add(details)
                    ElseIf (dsRPConfig.Tables(1).Rows.Count = 0) Then
                        dtRPConfig = dsRPConfig.Tables(1)
                        Dim details As New List(Of RepPackCodeBO)()
                        dtRPConfigColl.Add(details)
                    End If

                    'Sub Repair Code
                    If (dsRPConfig.Tables(4).Rows.Count > 0) Then
                        dtRPConfig = dsRPConfig.Tables(4)
                        Dim details As New List(Of RepPackCodeBO)()
                        For Each dtrow As DataRow In dtRPConfig.Rows
                            Dim rpCodeDet As New RepPackCodeBO()
                            rpCodeDet.IdRepCode = dtrow("ID_REP_CODE").ToString()
                            rpCodeDet.RP_Repcode_Desc = dtrow("RP_REPCODE_DES").ToString()
                            rpCodeDet.IdSubRepCode = dtrow("ID_SUBREP_CODE").ToString()
                            rpCodeDet.Rp_SubRepCode_Desc = dtrow("RP_SubRepCode_Des").ToString()
                            details.Add(rpCodeDet)
                        Next
                        dtRPConfigColl.Add(details)
                    ElseIf (dsRPConfig.Tables(4).Rows.Count = 0) Then
                        dtRPConfig = dsRPConfig.Tables(4)
                        Dim details As New List(Of RepPackCodeBO)()
                        dtRPConfigColl.Add(details)
                    End If

                    'CheckList 
                    If (dsRPConfig.Tables(2).Rows.Count > 0) Then
                        dtRPConfig = dsRPConfig.Tables(2)
                        Dim details As New List(Of RepPackCodeBO)()
                        For Each dtrow As DataRow In dtRPConfig.Rows
                            Dim rpCodeDet As New RepPackCodeBO()
                            rpCodeDet.IdChkListCode = dtrow("ID_CL_CODE").ToString()
                            rpCodeDet.IdChkListDesc = dtrow("RP_CL_DES").ToString()
                            rpCodeDet.IdChkListCodeOld = dtrow("ID_CL_CODE_OLD").ToString()
                            details.Add(rpCodeDet)
                        Next
                        dtRPConfigColl.Add(details)
                    ElseIf (dsRPConfig.Tables(2).Rows.Count = 0) Then
                        dtRPConfig = dsRPConfig.Tables(2)
                        Dim details As New List(Of RepPackCodeBO)()
                        dtRPConfigColl.Add(details)
                    End If

                    'WorkCode 
                    If (dsRPConfig.Tables(3).Rows.Count > 0) Then
                        dtRPConfig = dsRPConfig.Tables(3)
                        Dim details As New List(Of RepPackCodeBO)()
                        For Each dtrow As DataRow In dtRPConfig.Rows
                            Dim rpCodeDet As New RepPackCodeBO()
                            rpCodeDet.IdWorkCode = dtrow("ID_SETTINGS").ToString()
                            rpCodeDet.IdConfig = dtrow("ID_CONFIG").ToString()
                            rpCodeDet.WorkCodeDesc = dtrow("DESCRIPTION").ToString()
                            rpCodeDet.IsDefaultValue = dtrow("DEFAULT_VALUE").ToString()
                            rpCodeDet.IsDefault = dtrow("wcIsDefault").ToString()
                            details.Add(rpCodeDet)
                        Next
                        dtRPConfigColl.Add(details)
                    ElseIf (dsRPConfig.Tables(3).Rows.Count = 0) Then
                        dtRPConfig = dsRPConfig.Tables(3)
                        Dim details As New List(Of RepPackCodeBO)()
                        dtRPConfigColl.Add(details)
                    End If

                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.RepPackCode", "FetchAllRepPkgConfig", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return dtRPConfigColl
        End Function

        Public Function UpdateConfigDetails(ByVal strXMLDocMas As String, ByVal strXMLDocRpCode As String, ByVal strXMLDocChkLst As String, ByVal strXMLDocSrpCode As String) As List(Of RepPackCodeBO)
            Dim details As New List(Of RepPackCodeBO)()
            Dim strResult As String
            Dim strResultArr As Array
            Dim strSaved As String = ""
            Dim strCannotSaved As String = ""

            Dim ov_retvalue_mas As String = ""
            Dim ov_retvalue_rpcode As String = ""
            Dim ov_retvalue_chklst As String = ""
            Dim ov_cannotmodify_mas As String = ""
            Dim ov_modifyedcfg_mas As String = ""
            Dim ov_cannotmodify_rpcode As String = ""
            Dim ov_modifyedcfg_rpcode As String = ""
            Dim ov_cannotmodify_chklst As String = ""
            Dim ov_modifyedcfg_chklst As String = ""
            Dim ov_retvalue_srpcode As String = ""
            Dim ov_cannotmodify_srpcode As String = ""
            Dim ov_modifyedcfg_srpcode As String = ""
            Try
                strResult = objRPDO.UpdateConfigDetails(strXMLDocMas, strXMLDocRpCode, strXMLDocChkLst, strXMLDocSrpCode)
                strResultArr = strResult.Split(",")
                If strResultArr.Length > 0 Then
                    ov_retvalue_mas = strResultArr(0).ToString()
                    ov_retvalue_rpcode = strResultArr(1).ToString()
                    ov_retvalue_chklst = strResultArr(2).ToString()
                    ov_cannotmodify_mas = strResultArr(3).ToString()
                    ov_modifyedcfg_mas = strResultArr(4).ToString()
                    ov_cannotmodify_rpcode = strResultArr(5).ToString()
                    ov_modifyedcfg_rpcode = strResultArr(6).ToString()
                    ov_cannotmodify_chklst = strResultArr(7).ToString()
                    ov_modifyedcfg_chklst = strResultArr(8).ToString()
                    ov_retvalue_srpcode = strResultArr(9).ToString()
                    ov_cannotmodify_srpcode = strResultArr(10).ToString()
                    ov_modifyedcfg_srpcode = strResultArr(11).ToString()


                    strSaved += "" + ov_modifyedcfg_mas.Replace(";", "';'").Replace("<", "&lt;").Replace(">", "&gt;") + ""
                    strCannotSaved += "" + ov_cannotmodify_mas.Replace(";", "';'").Replace("<", "&lt;").Replace(">", "&gt;") + ""

                    If ov_modifyedcfg_mas.Replace(";", "';'").Length > 0 Then strSaved = "'" + strSaved + "'"
                    If ov_cannotmodify_mas.Replace(";", "';'").Length > 0 Then strCannotSaved = "'" + strCannotSaved + "'"


                    If ov_modifyedcfg_rpcode.StartsWith(";") Then ov_modifyedcfg_rpcode = ov_modifyedcfg_rpcode.Substring(1)

                    strSaved += "" + ov_modifyedcfg_rpcode.Replace(";", "';'").Replace("<", "&lt;").Replace(">", "&gt;") + ""

                    If ov_cannotmodify_rpcode.StartsWith(";") Then ov_cannotmodify_rpcode = ov_cannotmodify_rpcode.Substring(1)

                    strCannotSaved += "" + ov_cannotmodify_rpcode.Replace(";", "';'").Replace("<", "&lt;").Replace(">", "&gt;")

                    If ov_modifyedcfg_rpcode.Replace(";", "';'").Length > 0 Then strSaved = "'" + strSaved + "'"
                    If ov_cannotmodify_rpcode.Replace(";", "';'").Length > 0 Then strCannotSaved = "'" + strCannotSaved + "'"


                    If ov_modifyedcfg_srpcode.StartsWith(";") Then ov_modifyedcfg_srpcode = ov_modifyedcfg_srpcode.Substring(1)
                    strSaved += "" + ov_modifyedcfg_srpcode.Replace(";", "';'").Replace("<", "&lt;").Replace(">", "&gt;") + ""

                    If ov_cannotmodify_srpcode.StartsWith(";") Then ov_cannotmodify_srpcode = ov_cannotmodify_srpcode.Substring(1)

                    strCannotSaved += "" + ov_cannotmodify_srpcode.Replace(";", "';'").Replace("<", "&lt;").Replace(">", "&gt;")

                    If ov_modifyedcfg_srpcode.Replace(";", "';'").Length > 0 Then strSaved = "'" + strSaved + "'"
                    If ov_cannotmodify_srpcode.Replace(";", "';'").Length > 0 Then strCannotSaved = "'" + strCannotSaved + "'"

                    If ov_modifyedcfg_chklst.StartsWith(";") Then ov_modifyedcfg_chklst = ov_modifyedcfg_chklst.Substring(1)

                    strSaved += "" + ov_modifyedcfg_chklst.Replace(";", "';'").Replace("<", "&lt;").Replace(">", "&gt;")

                    If ov_cannotmodify_chklst.StartsWith(";") Then ov_cannotmodify_chklst = ov_cannotmodify_chklst.Substring(1)
                    strCannotSaved += "" + ov_cannotmodify_chklst.Replace(";", "';'").Replace("<", "&lt;").Replace(">", "&gt;") + ""

                    If ov_modifyedcfg_chklst.Replace(";", "';'").Length > 0 Then strSaved = "'" + strSaved + "'"
                    If ov_cannotmodify_chklst.Replace(";", "';'").Length > 0 Then strCannotSaved = "'" + strCannotSaved + "'"

                    Dim rpCodeDet As New RepPackCodeBO()
                    rpCodeDet.RetVal_Saved = strSaved
                    rpCodeDet.RetVal_NotSaved = strCannotSaved
                    details.Add(rpCodeDet)

                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.RepPackCode", "UpdateConfigDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function AddConfigDetails(ByVal strXMLDocMas As String) As List(Of RepPackCodeBO)
            Dim details As New List(Of RepPackCodeBO)()
            Try
                Dim strResult As String = ""
                Dim strSaved As String = ""
                Dim strCannotSaved As String = ""
                Dim strResultArr As Array
                strResult = objConfigSettingsDO.InsertConfig(strXMLDocMas)
                strResultArr = strResult.Split(","c)

                If strResultArr.Length >= 3 Then

                    strSaved += "" + strResultArr(2).Replace(";", "';'").Replace("<", "&lt;").Replace(">", "&gt;") + ""
                    strCannotSaved += "" + strResultArr(1).Replace(";", "';'").Replace("<", "&lt;").Replace(">", "&gt;") + ""

                    Dim rpCodeDet As New RepPackCodeBO()
                    rpCodeDet.RetVal_Saved = strSaved
                    rpCodeDet.RetVal_NotSaved = strCannotSaved
                    details.Add(rpCodeDet)

                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.RepPackCode", "AddConfigDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function

        Public Function DeleteRepPkgCatg(ByVal repPkgxml As String) As String()
            Dim strResult As String = ""
            Dim strArray As Array
            Dim strError As String
            Dim strRecordsDeleted As String = ""
            Dim strRecordsNotDeleted As String = ""
            Try
                strResult = objConfigSettingsDO.DeleteConfig(repPkgxml)
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
                objErrHandle.WriteErrorLog(1, "Services.RepPackCode", "DeleteRepPkgCatg", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strArray
        End Function

        Public Function AddRepCode(ByVal strXMLDocMas As String) As List(Of RepPackCodeBO)
            Dim details As New List(Of RepPackCodeBO)()
            Try
                Dim strResult As String = ""
                Dim strSaved As String = ""
                Dim strCannotSaved As String = ""
                Dim strResultArr As Array
                strResult = objRPDO.InsertRepCode(strXMLDocMas)
                strResultArr = strResult.Split(","c)

                If strResultArr.Length >= 3 Then

                    strSaved += "" + strResultArr(2).Replace(";", "';'").Replace("<", "&lt;").Replace(">", "&gt;") + ""
                    strCannotSaved += "" + strResultArr(1).Replace(";", "';'").Replace("<", "&lt;").Replace(">", "&gt;") + ""

                    Dim rpCodeDet As New RepPackCodeBO()
                    rpCodeDet.RetVal_Saved = strSaved
                    rpCodeDet.RetVal_NotSaved = strCannotSaved
                    details.Add(rpCodeDet)

                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.RepPackCode", "AddRepCode", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function DeleteRepCode(ByVal repCodexml As String) As String()
            Dim strResult As String = ""
            Dim strArray As Array
            Dim strError As String
            Dim strRecordsDeleted As String = ""
            Dim strRecordsNotDeleted As String = ""
            Try
                strResult = objRPDO.DeleteRepCode(repCodexml)
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
                objErrHandle.WriteErrorLog(1, "Services.RepPackCode", "DeleteRepCode", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strArray
        End Function

        Public Function AddSubRepCode(ByVal strXMLDocMas As String) As List(Of RepPackCodeBO)
            Dim details As New List(Of RepPackCodeBO)()
            Try
                Dim strResult As String = ""
                Dim strSaved As String = ""
                Dim strCannotSaved As String = ""
                Dim strResultArr As Array
                strResult = objRPDO.InsertSubRepCode(strXMLDocMas)
                strResultArr = strResult.Split(","c)

                If strResultArr.Length >= 3 Then

                    strSaved += "" + strResultArr(2).Replace(";", "';'").Replace("<", "&lt;").Replace(">", "&gt;") + ""
                    strCannotSaved += "" + strResultArr(1).Replace(";", "';'").Replace("<", "&lt;").Replace(">", "&gt;") + ""

                    Dim rpCodeDet As New RepPackCodeBO()
                    rpCodeDet.RetVal_Saved = strSaved
                    rpCodeDet.RetVal_NotSaved = strCannotSaved
                    details.Add(rpCodeDet)

                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.RepPackCode", "AddSubRepCode", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function DeleteSubRepCode(ByVal subRepCodexml As String) As String()
            Dim strResult As String = ""
            Dim strArray As Array
            Dim strError As String
            Dim strRecordsDeleted As String = ""
            Dim strRecordsNotDeleted As String = ""
            Try
                strResult = objRPDO.DeleteSubRepCode(subRepCodexml)
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
                objErrHandle.WriteErrorLog(1, "Services.RepPackCode", "DeleteSubRepCode", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strArray
        End Function
        Public Function AddRepCodePkk(ByVal idRepCode As String) As List(Of RepPackCodeBO)
            Dim details As New List(Of RepPackCodeBO)()
            Try
                Dim strResult As String = ""
                Dim strSaved As String = ""
                Dim strCannotSaved As String = ""
                strResult = objRPDO.InsertRepCodePkk(idRepCode)
                If strResult <> "0" Then
                    strSaved = objErrHandle.GetErrorDescParameter("UPD")
                Else
                    strCannotSaved = ""
                End If
                Dim rpCodeDet As New RepPackCodeBO()
                rpCodeDet.RetVal_Saved = strSaved
                rpCodeDet.RetVal_NotSaved = strCannotSaved
                details.Add(rpCodeDet)

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.RepPackCode", "AddSubRepCode", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function AddCheckListCode(ByVal strXMLDocMas As String) As List(Of RepPackCodeBO)
            Dim details As New List(Of RepPackCodeBO)()
            Try
                Dim strResult As String = ""
                Dim strSaved As String = ""
                Dim strCannotSaved As String = ""
                Dim strResultArr As Array
                strResult = objRPDO.InsertCheckList(strXMLDocMas)
                strResultArr = strResult.Split(","c)

                If strResultArr.Length >= 3 Then

                    strSaved += "" + strResultArr(2).Replace(";", "';'").Replace("<", "&lt;").Replace(">", "&gt;") + ""
                    strCannotSaved += "" + strResultArr(1).Replace(";", "';'").Replace("<", "&lt;").Replace(">", "&gt;") + ""

                    Dim rpCodeDet As New RepPackCodeBO()
                    rpCodeDet.RetVal_Saved = strSaved
                    rpCodeDet.RetVal_NotSaved = strCannotSaved
                    details.Add(rpCodeDet)

                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.RepPackCode", "AddCheckListCode", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function DeleteCheckList(ByVal checkListxml As String) As String()
            Dim strResult As String = ""
            Dim strArray As Array
            Dim strError As String
            Dim strRecordsDeleted As String = ""
            Dim strRecordsNotDeleted As String = ""
            Try
                strResult = objRPDO.DeleteCheckList(checkListxml)
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
                objErrHandle.WriteErrorLog(1, "Services.RepPackCode", "DeleteCheckList", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strArray
        End Function
        Public Function DeleteWorkCode(ByVal workCodexml As String) As String()
            Dim strResult As String = ""
            Dim strArray As Array
            Dim strError As String
            Dim strRecordsDeleted As String = ""
            Dim strRecordsNotDeleted As String = ""
            Try
                strResult = objConfigSettingsDO.DeleteConfig(workCodexml)
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
                objErrHandle.WriteErrorLog(1, "Services.RepPackCode", "DeleteWorkCode", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strArray
        End Function
    End Class
End Namespace

