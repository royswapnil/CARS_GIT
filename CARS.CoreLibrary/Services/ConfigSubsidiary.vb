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
Namespace CARS.Services.ConfigSubsidiary
    Public Class Subsidiary
        Shared objConfigSubBO As New ConfigSubsidiaryBO
        Shared objConfigSubDO As New CARS.Subsidiary.ConfigSubsidiaryDO
        Shared objCommonUtil As New CARS.Utilities.CommonUtility
        Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
        Public Function GetSubsidiary(ByVal subID As String) As List(Of ConfigSubsidiaryBO)
            Dim details As New List(Of ConfigSubsidiaryBO)()
            Dim dsSubDetails As New DataSet
            Dim dtSubDetails As New DataTable
            Try
                objConfigSubBO.SubsidiaryID = subID
                dsSubDetails = objConfigSubDO.Fetch_Subsidiary(objConfigSubBO)
                If dsSubDetails.Tables.Count > 0 Then
                    dtSubDetails = dsSubDetails.Tables(0)
                    For Each dtrow As DataRow In dtSubDetails.Rows
                        Dim subDet As New ConfigSubsidiaryBO()
                        subDet.SubsidiaryID = dtrow("ID_Subsidery").ToString()
                        subDet.SubsidiaryName = dtrow("SS_Name").ToString()
                        subDet.SubsidiaryManager = dtrow("SS_Mgr_Name").ToString()
                        subDet.AddressLine1 = dtrow("SS_Address1").ToString()
                        subDet.AddressLine2 = dtrow("SS_Address2").ToString()
                        subDet.Telephone = dtrow("SS_Phone1").ToString()
                        subDet.Mobile = dtrow("SS_Phone_Mobile").ToString()
                        subDet.Email = dtrow("ID_EMAIL_SUBSID").ToString()
                        subDet.Organization = dtrow("SS_ORGANIZATIONNO").ToString()
                        subDet.FaxNo = dtrow("SS_Fax").ToString()
                        subDet.IBAN = dtrow("SS_IBAN").ToString()
                        subDet.Swift = dtrow("SS_SWIFT").ToString()
                        subDet.BankAccnt = dtrow("SS_BANKACCOUNT").ToString()
                        subDet.ZipCode = dtrow("ID_ZIPCODE").ToString()
                        subDet.Country = dtrow("COUNTRY").ToString()
                        subDet.State = dtrow("STATE").ToString()
                        subDet.City = dtrow("CITY").ToString()
                        subDet.TransferMethod = dtrow("TransferMethod").ToString()
                        subDet.AccntCode = dtrow("AccountCode").ToString()
                        subDet.UserID = dtrow("CREATED_BY").ToString()
                        If (IsDBNull(dtrow("DT_CREATED").ToString())) Then
                            subDet.CreatedDate = ""
                        Else
                            subDet.CreatedDate = objCommonUtil.GetCurrentLanguageDate(dtrow("DT_CREATED").ToString())
                        End If
                        subDet.ModifiedBy = dtrow("MODIFIED_BY").ToString()
                        If (IsDBNull(dtrow("DT_MODIFIED").ToString())) Then
                            subDet.ModifiedDate = ""
                        Else
                            subDet.ModifiedDate = objCommonUtil.GetCurrentLanguageDate(dtrow("DT_MODIFIED").ToString())
                        End If
                        details.Add(subDet)
                    Next
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigSubsidiary", "GetSubsidiary", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function SaveSubsidiary(ByVal objConfigSubBO As ConfigSubsidiaryBO, ByVal mode As String) As String
            Dim strResult As String = ""
            Try
                If mode = "Edit" Then
                    strResult = objConfigSubDO.Update_Subsidiary(objConfigSubBO)
                Else
                    strResult = objConfigSubDO.Add_Subsidiary(objConfigSubBO)
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigSubsidiary", "SaveSubsidiary", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strResult
        End Function
        Public Function DeleteSubsidiary(objConfigSubBO) As String()
            Dim strResult As String = ""
            Dim strArray As Array
            Dim strError As String
            Dim strRecordsDeleted As String = ""
            Dim strRecordsNotDeleted As String = ""
            Try
                strResult = objConfigSubDO.Delete_Subsidiary(objConfigSubBO)
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
                objErrHandle.WriteErrorLog(1, "Services.ConfigSubsidiary", "DeleteSubsidiary", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strArray
        End Function
    End Class
End Namespace
