Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports System.Configuration
Imports System.IO
Imports System.Net
Imports System.Web
Imports System.Web.UI.HtmlControls
Imports System.Web.UI.WebControls.WebParts
Imports Newtonsoft.Json
Imports Newtonsoft.Json.Linq
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports Microsoft.Practices.EnterpriseLibrary.Data.Sql
Namespace CARS.Services.ConfigEmailTemplate
    Public Class ConfigEmailTemplate
        Shared objCommonUtil As New CARS.Utilities.CommonUtility
        Shared objConfigEmailTempDO As New CARS.ConfigEmailTemplate.ConfigEmailTemplateDO
        Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
        Public Function LoadEmailTemplate() As List(Of ConfigEmailTemplateBO)
            Dim details As New List(Of ConfigEmailTemplateBO)()
            Try
                Dim dsConfigEmailTemp As New DataSet
                Dim dtConfigEmailTemp As New DataTable

                dsConfigEmailTemp = objConfigEmailTempDO.Fetch_EmailTemplateConfig()
                HttpContext.Current.Session("ConfigEmailTemplate") = dsConfigEmailTemp
                If dsConfigEmailTemp.Tables(0).Rows.Count > 0 Then
                    dtConfigEmailTemp = dsConfigEmailTemp.Tables(0)
                    For Each dtrow As DataRow In dtConfigEmailTemp.Rows
                        Dim configemailtemp As New ConfigEmailTemplateBO()
                        configemailtemp.Id_Template = IIf(IsDBNull(dtrow("Id_Template")) = True, "", dtrow("Id_Template"))
                        configemailtemp.Template_Code = IIf(IsDBNull(dtrow("Template_Code")) = True, "", dtrow("Template_Code"))
                        configemailtemp.Subject = IIf(IsDBNull(dtrow("Subject")) = True, "", dtrow("Subject"))
                        configemailtemp.Short_Message = IIf(IsDBNull(dtrow("ShortMessage")) = True, "", dtrow("ShortMessage"))
                        configemailtemp.Message = IIf(IsDBNull(dtrow("Message")) = True, "", dtrow("Message"))
                        details.Add(configemailtemp)
                    Next
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigEmailTemplate", "LoadEmailTemplate", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function GetEmailTemplateConfig(ByVal idTemplate As String) As Collection
            Dim detailsColl As New Collection
            Try
                Dim ds As New DataSet
                Dim dt As New DataTable
                Dim dv As New DataView

                ds = HttpContext.Current.Session("ConfigEmailTemplate")
                If (ds.Tables.Count > 0) Then
                    If (ds.Tables(0).Rows.Count > 0) Then
                        dt = ds.Tables(0)
                        dv = dt.DefaultView
                        dv.RowFilter = "Id_Template = '" + idTemplate + "'"
                    End If

                    dt = dv.ToTable

                    If (dt.Rows.Count > 0) Then
                        For Each dtrow As DataRow In dt.Rows
                            Dim configemailtemp As New ConfigEmailTemplateBO()
                            configemailtemp.Id_Template = IIf(IsDBNull(dtrow("Id_Template")) = True, "", dtrow("Id_Template"))
                            configemailtemp.Template_Code = IIf(IsDBNull(dtrow("Template_Code")) = True, "", dtrow("Template_Code"))
                            configemailtemp.Subject = IIf(IsDBNull(dtrow("Subject")) = True, "", dtrow("Subject"))
                            configemailtemp.Short_Message = IIf(IsDBNull(dtrow("ShortMessage")) = True, "", dtrow("ShortMessage"))
                            configemailtemp.Message = IIf(IsDBNull(dtrow("Message")) = True, "", dtrow("Message"))
                            detailsColl.Add(configemailtemp)
                        Next
                    Else
                        dt = ds.Tables(0)
                        Dim details As New List(Of ConfigEmailTemplateBO)()
                        detailsColl.Add(details)
                    End If
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigEmailTemplate", "GetEmailTemplateConfig", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return detailsColl
        End Function
        Public Function AddEmailTemplate(ByVal objConfigEmailTempBO As ConfigEmailTemplateBO) As String()
            Dim strResult As String = ""
            Dim strResVal As Array
            Try
                strResult = objConfigEmailTempDO.Add_EmailTemplate(objConfigEmailTempBO, HttpContext.Current.Session("UserID"))
                strResVal = strResult.Split(",")
                Dim strValue = objErrHandle.GetErrorDesc("MTEMPLATE").ToString
                If strResVal(0) = "INSERTED" Then
                    strResVal(0) = "INSERTED"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("ADD", "'" + strValue + "'")
                ElseIf strResVal(0) = "EXISTS" Then
                    strResVal(0) = "EXISTS"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("MTEXISTS")
                ElseIf strResVal(0) = "ERROR" Then
                    strResVal(0) = "ERROR"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("MTSERROR")
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigEmailTemplate", "AddEmailTemplate", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strResVal
        End Function
        Public Function UpdateEmailTemplate(ByVal objConfigEmailTempBO As ConfigEmailTemplateBO) As String()
            Dim strResult As String = ""
            Dim strResVal As Array
            Try
                strResult = objConfigEmailTempDO.Update_EmailTemplate(objConfigEmailTempBO, HttpContext.Current.Session("UserID"))
                strResVal = strResult.Split(",")
                Dim strValue = objErrHandle.GetErrorDesc("MTEMPLATE").ToString
                If strResVal(0) = "UPDATED" Then
                    strResVal(0) = "UPDATED"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("ADD", "'" + strValue + "'")
                ElseIf strResVal(0) = "EXISTS" Then
                    strResVal(0) = "EXISTS"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("MTEXISTS")
                ElseIf strResVal(0) = "ERROR" Then
                    strResVal(0) = "ERROR"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("MTSERROR")
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigEmailTemplate", "UpdateEmailTemplate", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strResVal
        End Function
        Public Function DeleteEmailTemplate(ByVal xmlDoc As String) As String()
            Dim strResult As String = ""
            Dim strResVal As Array
            Try
                strResult = objConfigEmailTempDO.Delete_EmailTemplate(xmlDoc)
                strResVal = strResult.Split(",")
                Dim strValue = objErrHandle.GetErrorDesc("MTEMPLATE").ToString
                If strResVal(0) = "DELETED" Then
                    strResVal(0) = "DELETED"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("DDEL", "'" + strValue + "'")
                Else
                    strResVal(0) = "ERROR"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("MTDERROR")
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigEmailTemplate", "DeleteEmailTemplate", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strResVal
        End Function
        Public Function LoadInvEmailTemplate() As List(Of ConfigEmailTemplateBO)
            Dim details As New List(Of ConfigEmailTemplateBO)()
            Try
                Dim dsInvEmailTemp As New DataSet
                Dim dtInvEmailTemp As New DataTable

                dsInvEmailTemp = objConfigEmailTempDO.Fetch_InvEmailTemplateConfig()
                HttpContext.Current.Session("InvEmailTemplateConfig") = dsInvEmailTemp
                If dsInvEmailTemp.Tables(0).Rows.Count > 0 Then
                    dtInvEmailTemp = dsInvEmailTemp.Tables(0)
                    For Each dtrow As DataRow In dtInvEmailTemp.Rows
                        Dim configemailtemp As New ConfigEmailTemplateBO()
                        configemailtemp.Id_Template = IIf(IsDBNull(dtrow("Id_Template")) = True, "", dtrow("Id_Template"))
                        configemailtemp.Template_Code = IIf(IsDBNull(dtrow("Template_Code")) = True, "", dtrow("Template_Code"))
                        configemailtemp.Subject = IIf(IsDBNull(dtrow("Subject")) = True, "", dtrow("Subject"))
                        configemailtemp.Short_Message = IIf(IsDBNull(dtrow("ShortMessage")) = True, "", dtrow("ShortMessage"))
                        configemailtemp.Message = IIf(IsDBNull(dtrow("Message")) = True, "", dtrow("Message"))
                        configemailtemp.Flg_Default = IIf(IsDBNull(dtrow("Default_Value")) = True, "0", dtrow("Default_Value"))
                        details.Add(configemailtemp)
                    Next
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigEmailTemplate", "LoadInvEmailTemplate", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function LoadInvEmailSchedule() As List(Of ConfigEmailTemplateBO)
            Dim details As New List(Of ConfigEmailTemplateBO)()
            Try
                Dim dsInvEmailSch As New DataSet
                Dim dtInvEmailSch As New DataTable

                dsInvEmailSch = objConfigEmailTempDO.Fetch_InvEmailSchedule()
                'HttpContext.Current.Session("InvEmailTemplateConfig") = dsInvEmailSch
                If dsInvEmailSch.Tables(0).Rows.Count > 0 Then
                    dtInvEmailSch = dsInvEmailSch.Tables(0)
                    For Each dtrow As DataRow In dtInvEmailSch.Rows
                        Dim configemailtemp As New ConfigEmailTemplateBO()
                        configemailtemp.Start_Time = IIf(IsDBNull(dtrow("Start_Time")) = True, "", dtrow("Start_Time"))
                        configemailtemp.Use_Mon = IIf(IsDBNull(dtrow("Wk_Mon")) = True, "", dtrow("Wk_Mon"))
                        configemailtemp.Use_Tue = IIf(IsDBNull(dtrow("Wk_Tue")) = True, "", dtrow("Wk_Tue"))
                        configemailtemp.Use_Wed = IIf(IsDBNull(dtrow("Wk_Wed")) = True, "", dtrow("Wk_Wed"))
                        configemailtemp.Use_Thur = IIf(IsDBNull(dtrow("Wk_Thur")) = True, "", dtrow("Wk_Thur"))
                        configemailtemp.Use_Fri = IIf(IsDBNull(dtrow("Wk_Fri")) = True, "", dtrow("Wk_Fri"))
                        configemailtemp.Use_Sat = IIf(IsDBNull(dtrow("Wk_Sat")) = True, "", dtrow("Wk_Sat"))
                        configemailtemp.Use_Sun = IIf(IsDBNull(dtrow("Wk_Sun")) = True, "", dtrow("Wk_Sun"))
                        details.Add(configemailtemp)
                    Next
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigEmailTemplate", "LoadInvEmailSchedule", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function AddInvEmailTemplate(ByVal objConfigEmailTempBO As ConfigEmailTemplateBO) As String()
            Dim strResult As String = ""
            Dim strResVal As Array
            Try
                strResult = objConfigEmailTempDO.Add_InvEmailTemplate(objConfigEmailTempBO, HttpContext.Current.Session("UserID"))
                strResVal = strResult.Split(",")
                Dim strValue = objErrHandle.GetErrorDesc("MTEMPLATE").ToString
                If strResVal(0) = "INSERTED" Then
                    strResVal(0) = "INSERTED"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("ADD", "'" + strValue + "'")
                ElseIf strResVal(0) = "EXISTS" Then
                    strResVal(0) = "EXISTS"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("MTEXISTS")
                ElseIf strResVal(0) = "ERROR" Then
                    strResVal(0) = "ERROR"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("MTSERROR")
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigEmailTemplate", "AddInvEmailTemplate", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strResVal
        End Function
        Public Function UpdateInvEmailTemplate(ByVal objConfigEmailTempBO As ConfigEmailTemplateBO) As String()
            Dim strResult As String = ""
            Dim strResVal As Array
            Try
                strResult = objConfigEmailTempDO.Update_InvEmailTemplate(objConfigEmailTempBO, HttpContext.Current.Session("UserID"))
                strResVal = strResult.Split(",")
                Dim strValue = objErrHandle.GetErrorDesc("MTEMPLATE").ToString
                If strResVal(0) = "UPDATED" Then
                    strResVal(0) = "UPDATED"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("DUPDATE", "'" + strValue + "'")
                ElseIf strResVal(0) = "EXISTS" Then
                    strResVal(0) = "EXISTS"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("MTEXISTS")
                ElseIf strResVal(0) = "ERROR" Then
                    strResVal(0) = "ERROR"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("MTSERROR")
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigEmailTemplate", "UpdateInvEmailTemplate", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strResVal
        End Function
        Public Function SaveInvEmailSchedule(ByVal objConfigEmailTempBO As ConfigEmailTemplateBO) As String()
            Dim strResult As String = ""
            Dim strResVal As Array
            Try
                strResult = objConfigEmailTempDO.Save_InvEmailSchedule(objConfigEmailTempBO, HttpContext.Current.Session("UserID"))
                strResVal = strResult.Split(",")
                Dim strValue = objErrHandle.GetErrorDesc("IESCH").ToString
                If strResVal(0) = "INSERTED" Then
                    strResVal(0) = "INSERTED"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("ADD", "'" + strValue + "'")
                ElseIf strResVal(0) = "ERROR" Then
                    strResVal(0) = "ERROR"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("MTSERROR")
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigEmailTemplate", "SaveInvEmailSchedule", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strResVal
        End Function
        Public Function DeleteInvEmailTemplate(ByVal xmlDoc As String) As String()
            Dim strResult As String = ""
            Dim strResVal As Array
            Try
                strResult = objConfigEmailTempDO.Delete_InvEmailTemplate(xmlDoc)
                strResVal = strResult.Split(",")
                Dim strValue = objErrHandle.GetErrorDesc("MTEMPLATE").ToString
                If strResVal(0) = "DELETED" Then
                    strResVal(0) = "DELETED"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("DDEL", "'" + strValue + "'")
                Else
                    strResVal(0) = "ERROR"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("MTDERROR")
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigEmailTemplate", "DeleteInvEmailTemplate", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strResVal
        End Function

        Public Function GetInvEmailTemplateConfig(ByVal idTemplate As String) As Collection
            Dim detailsColl As New Collection
            Try
                Dim ds As New DataSet
                Dim dt As New DataTable
                Dim dv As New DataView

                ds = HttpContext.Current.Session("InvEmailTemplateConfig")
                If (ds.Tables.Count > 0) Then
                    If (ds.Tables(0).Rows.Count > 0) Then
                        dt = ds.Tables(0)
                        dv = dt.DefaultView
                        dv.RowFilter = "Id_Template = '" + idTemplate + "'"
                    End If

                    dt = dv.ToTable

                    If (dt.Rows.Count > 0) Then
                        For Each dtrow As DataRow In dt.Rows
                            Dim configemailtemp As New ConfigEmailTemplateBO()
                            configemailtemp.Id_Template = IIf(IsDBNull(dtrow("Id_Template")) = True, "", dtrow("Id_Template"))
                            configemailtemp.Template_Code = IIf(IsDBNull(dtrow("Template_Code")) = True, "", dtrow("Template_Code"))
                            configemailtemp.Subject = IIf(IsDBNull(dtrow("Subject")) = True, "", dtrow("Subject"))
                            configemailtemp.Short_Message = IIf(IsDBNull(dtrow("ShortMessage")) = True, "", dtrow("ShortMessage"))
                            configemailtemp.Message = IIf(IsDBNull(dtrow("Message")) = True, "", dtrow("Message"))
                            configemailtemp.Flg_Default = IIf(IsDBNull(dtrow("Default_Value")) = True, "0", dtrow("Default_Value"))
                            detailsColl.Add(configemailtemp)
                        Next
                    Else
                        dt = ds.Tables(0)
                        Dim details As New List(Of ConfigEmailTemplateBO)()
                        detailsColl.Add(details)
                    End If
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigEmailTemplate", "GetInvEmailTemplateConfig", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return detailsColl
        End Function


    End Class
End Namespace

