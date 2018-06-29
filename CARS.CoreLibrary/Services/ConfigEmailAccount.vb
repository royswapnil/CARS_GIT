Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports System.Configuration
Imports System.IO
Imports System.Drawing
Imports System.Web.Script.Serialization.JavaScriptSerializer
Imports System.Object
Imports System.MarshalByRefObject
Imports System.Net.WebRequest
Imports System.Net.HttpWebRequest
Imports System.Net.HttpWebResponse
Imports System.Net
Imports System.Web
Imports System.Web.UI.HtmlControls
Imports System.Web.UI.WebControls.WebParts
Imports Newtonsoft.Json
Imports Newtonsoft.Json.Linq
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports Microsoft.Practices.EnterpriseLibrary.Data.Sql
Namespace CARS.Services.ConfigEmailAccount
    Public Class ConfigEmailAccount
       Shared objCommonUtil As New CARS.Utilities.CommonUtility
        Shared objConfigEmailAccntDO As New CARS.ConfigEmailAccount.ConfigEmailAccountDO
        Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
        Public Function LoadEmailAccount() As List(Of ConfigEmailAccountBO)
            Dim details As New List(Of ConfigEmailAccountBO)()
            Try
                Dim dsConfigEmailAccount As New DataSet
                Dim dtConfigEmailAccount As New DataTable

                dsConfigEmailAccount = objConfigEmailAccntDO.Fetch_EmailAccountConfig(HttpContext.Current.Session("UserID").ToString)
                HttpContext.Current.Session("ConfigEmailAccount") = dsConfigEmailAccount
                If dsConfigEmailAccount.Tables(0).Rows.Count > 0 Then
                    dtConfigEmailAccount = dsConfigEmailAccount.Tables(0)
                    For Each dtrow As DataRow In dtConfigEmailAccount.Rows
                        Dim configemailAccount As New ConfigEmailAccountBO()
                        configemailAccount.Id_Email_Accnt = IIf(IsDBNull(dtrow("Id_Email_Acct")) = True, "", dtrow("Id_Email_Acct"))
                        configemailAccount.Subsidiary = IIf(IsDBNull(dtrow("Subsidiary")) = True, "", dtrow("Subsidiary"))
                        configemailAccount.Setting_Name = IIf(IsDBNull(dtrow("Setting_Name")) = True, "", dtrow("Setting_Name"))
                        configemailAccount.Email = IIf(IsDBNull(dtrow("Email")) = True, "", dtrow("Email"))
                        configemailAccount.Smtp = IIf(IsDBNull(dtrow("Smtp")) = True, "", dtrow("Smtp"))
                        configemailAccount.Port = IIf(IsDBNull(dtrow("Port")) = True, "", dtrow("Port"))
                        configemailAccount.Username = IIf(IsDBNull(dtrow("Username")) = True, "", dtrow("Username"))
                        configemailAccount.Password = IIf(IsDBNull(dtrow("Password")) = True, "", dtrow("Password"))
                        configemailAccount.Id_Subsidiary = IIf(IsDBNull(dtrow("Id_Subsidiary")) = True, "", dtrow("Id_Subsidiary"))
                        configemailAccount.Cryptation = IIf(IsDBNull(dtrow("Cryptation")) = True, "", dtrow("Cryptation"))
                        details.Add(configemailAccount)
                    Next
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigEmailAccount", "LoadEmailAccount", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function GetEmailAcctConfig(ByVal idEmailAcct As String) As Collection
            Dim detailsColl As New Collection
            Try
                Dim ds As New DataSet
                Dim dt As New DataTable
                Dim dv As New DataView

                ds = HttpContext.Current.Session("ConfigEmailAccount")
                If (ds.Tables.Count > 0) Then
                    If (ds.Tables(0).Rows.Count > 0) Then
                        dt = ds.Tables(0)
                        dv = dt.DefaultView
                        dv.RowFilter = "Id_Email_Acct = '" + idEmailAcct + "'"
                    End If

                    dt = dv.ToTable

                    If (dt.Rows.Count > 0) Then
                        For Each dtrow As DataRow In dt.Rows
                            Dim configemailAccount As New ConfigEmailAccountBO()
                            configemailAccount.Id_Email_Accnt = IIf(IsDBNull(dtrow("Id_Email_Acct")) = True, "", dtrow("Id_Email_Acct"))
                            configemailAccount.Subsidiary = IIf(IsDBNull(dtrow("Subsidiary")) = True, "", dtrow("Subsidiary"))
                            configemailAccount.Setting_Name = IIf(IsDBNull(dtrow("Setting_Name")) = True, "", dtrow("Setting_Name"))
                            configemailAccount.Email = IIf(IsDBNull(dtrow("Email")) = True, "", dtrow("Email"))
                            configemailAccount.Smtp = IIf(IsDBNull(dtrow("Smtp")) = True, "", dtrow("Smtp"))
                            configemailAccount.Port = IIf(IsDBNull(dtrow("Port")) = True, "", dtrow("Port"))
                            configemailAccount.Username = IIf(IsDBNull(dtrow("Username")) = True, "", dtrow("Username"))
                            configemailAccount.Password = IIf(IsDBNull(dtrow("Password")) = True, "", dtrow("Password"))
                            configemailAccount.Id_Subsidiary = IIf(IsDBNull(dtrow("Id_Subsidiary")) = True, "", dtrow("Id_Subsidiary"))
                            configemailAccount.Cryptation = IIf(IsDBNull(dtrow("Cryptation")) = True, "", dtrow("Cryptation"))
                            detailsColl.Add(configemailAccount)
                        Next
                    Else
                        dt = ds.Tables(0)
                        Dim details As New List(Of ConfigEmailTemplateBO)()
                        detailsColl.Add(details)
                    End If
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigEmailAccount", "GetEmailAcctConfig", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return detailsColl
        End Function
        Public Function SaveEmailAcct(ByVal objConfigEmailAcctBO As ConfigEmailAccountBO) As String()
            Dim strResult As String = ""
            Dim strResVal As Array
            Try
                strResult = objConfigEmailAccntDO.Save_EmailAccountConfig(objConfigEmailAcctBO, HttpContext.Current.Session("UserID"))
                strResVal = strResult.Split(",")
                Dim strValue = objConfigEmailAcctBO.Setting_Name.ToString
                If strResVal(0) = "SUCCESS" Then
                    strResVal(0) = "SUCCESS"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("ADD", "'" + strValue + "'")
                ElseIf strResVal(0) = "UPDATED" Then
                    strResVal(0) = "UPDATED"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("UPD", "'" + strValue + "'")
                ElseIf strResVal(0) = "AEXISTS" Then
                    strResVal(0) = "AEXISTS"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("AEXISTS")
                Else
                    strResVal(0) = "ERROR"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("MTDERROR")
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigEmailAccount", "SaveEmailAcct", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strResVal
        End Function
        Public Function DeleteEmailAcct(ByVal xmlDoc As String) As String()
            Dim strResult As String = ""
            Dim strResVal As Array
            Try
                strResult = objConfigEmailAccntDO.Delete_EmailAccount(xmlDoc)
                strResVal = strResult.Split(",")
                Dim strValue = objErrHandle.GetErrorDesc("MTEMPLATE").ToString
                If strResVal(0) = "DELETED" Then
                    strResVal(0) = "DELETED"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("DDEL", "'" + strValue + "'")
                ElseIf strResVal(0) = "EA_EXISTS" Then
                    strResVal(0) = "EA_EXISTS"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("EA_EXISTS")
                Else
                    strResVal(0) = "ERROR"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("UNDEL")
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigEmailAccount", "DeleteEmailAcct", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strResVal
        End Function




    End Class

End Namespace
