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
Namespace CARS.Services.MechCompetency

    Public Class MechCompetency
        Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
        Shared objMechComptBO As New MechCompetencyBO
        Shared objMechComptDO As New CARS.MechCompetency.MechCompetencyDO
        Public Function FetchCompetencyLevel() As List(Of MechCompetencyBO)
            Dim details As New List(Of MechCompetencyBO)()
            Dim dsMechCompt As New DataSet
            Dim dtMechCompt As New DataTable
            Try
                dsMechCompt = objMechComptDO.Load_MechCompetencyDetails()
                HttpContext.Current.Session("MechCompetencyLevel") = dsMechCompt
                If dsMechCompt.Tables.Count > 0 Then
                    dtMechCompt = dsMechCompt.Tables(0)
                    For Each dtrow As DataRow In dtMechCompt.Rows
                        Dim mechCompt As New MechCompetencyBO()
                        mechCompt.IdCompt = dtrow("ID_COMPT").ToString()
                        mechCompt.Compt_Description = dtrow("COMPT_DESCRIPTION").ToString()
                        mechCompt.HiIdCompt = dtrow("HIDID_COMPT").ToString()
                        details.Add(mechCompt)
                    Next
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.MechCompetency", "FetchCompetencyLevel", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function SaveCompetencyLevel(ByVal xmlDoc As String) As String()
            Dim strResult As String = ""
            Dim strResVal As Array
            Dim strError As String
            Dim strSaved As String = ""
            Dim strCannotSaved As String = ""
            Try
                strResult = objMechComptDO.Add_MechCompetency(xmlDoc)
                strResVal = strResult.Split(",")
                strError = strResVal(0)
                strSaved = CStr(strResVal(1))
                strCannotSaved = CStr(strResVal(2))

                If strSaved <> "" Then
                    strResVal(0) = "SAVED"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("ADD", "'" + strSaved + "'")
                Else
                    strResVal(0) = "NSAVED"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("AEXISTS", "'" + strSaved + "'")
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.MechCompetency", "SaveMechCompetency", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strResVal
        End Function
        Public Function UpdateCompetencyLevel(ByVal xmlDoc As String) As String()
            Dim strResult As String = ""
            Dim strResVal As Array
            Dim strError As String
            Dim strSaved As String = ""
            Dim strCannotSaved As String = ""
            Try
                strResult = objMechComptDO.Update_MechCompetency(xmlDoc)
                strResVal = strResult.Split(",")
                strError = strResVal(0)
                strSaved = CStr(strResVal(1))
                strCannotSaved = CStr(strResVal(2))

                If strSaved <> "" Then
                    strResVal(0) = "UPDATED"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("UPD", "'" + strSaved + "'")
                Else
                    strResVal(0) = "NUPDATED"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("UUPDT", "'" + strCannotSaved + "'")
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.MechCompetency", "UpdateMechCompetency", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strResVal
        End Function

        Public Function DeleteCompetencyLevel(ByVal xmlDoc As String) As String()
            Dim strResult As String = ""
            Dim strArray As Array
            Dim strError As String
            Dim strRecordsDeleted As String = ""
            Dim strRecordsNotDeleted As String = ""
            Try
                strResult = objMechComptDO.Delete_MechCompetency(xmlDoc)
                strArray = strResult.Split(",")
                strError = strArray(0)
                strRecordsDeleted = CStr(strArray(1))
                strRecordsNotDeleted = CStr(strArray(2))

                If strRecordsDeleted <> "" Then
                    strArray(0) = "DEL"
                    strArray(1) = objErrHandle.GetErrorDescParameter("DEL", "'" + strRecordsDeleted + "'")
                End If

                If strRecordsNotDeleted <> "" Then
                    strArray(0) = "NDEL"
                    strArray(1) = objErrHandle.GetErrorDescParameter("DDN", "'" + strRecordsNotDeleted + "'")
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.MechCompetency", "DeleteMechCompetency", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strArray
        End Function

        Public Function FetchMechCompetency() As List(Of MechCompetencyBO)
            Dim details As New List(Of MechCompetencyBO)()
            Dim dsMechCompt As New DataSet
            Dim dtMechCompt As New DataTable
            Try
                dsMechCompt = objMechComptDO.Load_MechCompDetails()
                If dsMechCompt.Tables.Count > 0 Then
                    dtMechCompt = dsMechCompt.Tables(0)
                    HttpContext.Current.Session("MechCompPriceCode") = dsMechCompt
                    For Each dtrow As DataRow In dtMechCompt.Rows
                        Dim mechCompt As New MechCompetencyBO()
                        mechCompt.IdSeq = IIf(IsDBNull(dtrow("IdSeq").ToString()) = True, "", dtrow("IdSeq").ToString())
                        mechCompt.MechanicId = dtrow("MechanicId").ToString()
                        mechCompt.PriceCode = IIf(IsDBNull(dtrow("PriceCode").ToString()) = True, "", dtrow("PriceCode").ToString()) 'dtrow("PriceCode").ToString()
                        mechCompt.CompetencyCode = IIf(IsDBNull(dtrow("CompetencyCode").ToString()) = True, "", dtrow("CompetencyCode").ToString())
                        details.Add(mechCompt)
                    Next
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.MechCompetency", "FetchMechCompetency", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function

        Public Function FetchPCCompCode() As Collection
            Dim dsPriceCode As New DataSet
            Dim dtPriceCode As New DataTable
            Dim dtPriceCodeCompCodeColl As New Collection

            Dim dsCompCode As New DataSet
            Dim dtCompCode As New DataTable

            Try
                dsPriceCode = objMechComptDO.Load_MechCompPCDetails()
                HttpContext.Current.Session("PriceCode") = dsPriceCode

                If dsPriceCode.Tables.Count > 0 Then
                    If (dsPriceCode.Tables(0).Rows.Count > 0) Then
                        dtPriceCode = dsPriceCode.Tables(0)
                        Dim details As New List(Of MechCompetencyBO)()
                        For Each dtrow As DataRow In dtPriceCode.Rows
                            Dim priceCode As New MechCompetencyBO()
                            priceCode.IdConfig = dtrow("Id_Config").ToString()
                            priceCode.IdSettings = dtrow("Id_Settings").ToString()
                            priceCode.Description = IIf(IsDBNull(dtrow("Description")) = True, "", dtrow("Description"))
                            details.Add(priceCode)
                        Next
                        dtPriceCodeCompCodeColl.Add(details)
                    ElseIf (dsPriceCode.Tables(0).Rows.Count = 0) Then
                        dtPriceCode = dsPriceCode.Tables(0)
                        Dim details As New List(Of MechCompetencyBO)()
                        dtPriceCodeCompCodeColl.Add(details)
                    End If
                End If

                dsCompCode = objMechComptDO.Fetch_MechAllPriceCodeDetails()
                HttpContext.Current.Session("CompCode") = dsCompCode
                If dsCompCode.Tables.Count > 0 Then
                    If (dsCompCode.Tables(0).Rows.Count > 0) Then
                        dtCompCode = dsCompCode.Tables(0)
                        Dim details As New List(Of MechCompetencyBO)()
                        For Each dtrow As DataRow In dtCompCode.Rows
                            Dim compCode As New MechCompetencyBO()
                            compCode.IdCompt = dtrow("Id_Compt").ToString()
                            details.Add(compCode)
                        Next
                        dtPriceCodeCompCodeColl.Add(details)
                    ElseIf (dsCompCode.Tables(0).Rows.Count = 0) Then
                        dtCompCode = dsCompCode.Tables(0)
                        Dim details As New List(Of MechCompetencyBO)()
                        dtPriceCodeCompCodeColl.Add(details)
                    End If
                End If


            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.MechCompetency", "FetchPCCompCode", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return dtPriceCodeCompCodeColl
        End Function

        Public Function GetPCCompCostDetails(ByVal mechId As String) As Collection
            Dim detailsColl As New Collection
            Try
                Dim ds As New DataSet
                Dim dt As New DataTable
                Dim dv As New DataView

                ds = HttpContext.Current.Session("MechCompPriceCode")
                If (ds.Tables.Count > 0) Then

                    If (ds.Tables(0).Rows.Count > 0) Then
                        dt = ds.Tables(0)
                        dv = dt.DefaultView
                        dv.RowFilter = "MechanicId = '" + mechId + "'"
                    End If

                    dt = dv.ToTable

                    If (dt.Rows.Count > 0) Then
                        For Each dtrow As DataRow In dt.Rows
                            Dim mechCompt As New MechCompetencyBO()
                            mechCompt.IdSeq = IIf(IsDBNull(dtrow("IdSeq").ToString()) = True, "", dtrow("IdSeq").ToString())
                            mechCompt.MechanicId = dtrow("MechanicId").ToString()
                            mechCompt.PriceCode = IIf(IsDBNull(dtrow("PriceCode").ToString()) = True, "", dtrow("PriceCode").ToString()) 'dtrow("PriceCode").ToString()
                            mechCompt.CompetencyCode = IIf(IsDBNull(dtrow("CompetencyCode").ToString()) = True, "", dtrow("CompetencyCode").ToString())
                            detailsColl.Add(mechCompt)
                        Next
                    Else
                        dt = ds.Tables(0)
                        Dim details As New List(Of MechCompetencyBO)()
                        detailsColl.Add(details)
                    End If
                End If

                'Mech Cost
                Dim dsMechCost As New DataSet
                Dim dtMechCost As New DataTable

                dsMechCost = objMechComptDO.Fetch_MechCompPCCostDetails(mechId)
                HttpContext.Current.Session("MechCost") = dsMechCost
                If dsMechCost.Tables.Count > 0 Then
                    If (dsMechCost.Tables(0).Rows.Count > 0) Then
                        dtMechCost = dsMechCost.Tables(0)
                        Dim details As New List(Of MechCompetencyBO)()
                        For Each dtrow As DataRow In dtMechCost.Rows
                            Dim mechCost As New MechCompetencyBO()
                            mechCost.IdSeq = dtrow("Id_Seq").ToString()
                            mechCost.IdMech = dtrow("Id_Mec").ToString()
                            mechCost.CostTime = dtrow("Cost_Time").ToString()
                            mechCost.CostHour = dtrow("Cost_Hour").ToString()
                            mechCost.CostGarage = dtrow("Cost_Garage").ToString()
                            details.Add(mechCost)
                        Next
                        detailsColl.Add(details)
                    ElseIf (dsMechCost.Tables(0).Rows.Count = 0) Then
                        dtMechCost = dsMechCost.Tables(0)
                        Dim details As New List(Of MechCompetencyBO)()
                        detailsColl.Add(details)
                    End If
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.MechCompetency", "GetPCCompCostDetails", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return detailsColl
        End Function
        Public Function Add_MechCompMapping(ByVal xmlDoc As String) As String()
            Dim strResult As String = ""
            Dim strRes(1) As String
            Try
                strResult = objMechComptDO.Add_MechCompMapping(xmlDoc)

                If (strResult = "") Then
                    strRes(0) = "SAVED"
                    strRes(1) = objErrHandle.GetErrorDescParameter("SAVEMEC", "")
                Else
                    strRes(0) = "NSAVED"
                    strRes(1) = objErrHandle.GetErrorDescParameter("RDE", "")
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.MechCompetency", "Add_MechCompMapping", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strRes
        End Function

        Public Function Add_MechCost(ByVal xmlDoc As String) As String()
            Dim strResult As String = ""
            Dim strRes(1) As String
            Try
                strResult = objMechComptDO.Add_MechCompCost(xmlDoc)

                If (strResult = "") Then
                    strRes(0) = "SAVED"
                    strRes(1) = objErrHandle.GetErrorDescParameter("SAVEMEC", "")
                Else
                    strRes(0) = "NSAVED"
                    strRes(1) = objErrHandle.GetErrorDescParameter("RDE", "")
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.MechCompetency", "Add_MechCompMapping", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strRes
        End Function
        Public Function Delete_MechCost(ByVal xmlDoc As String) As String()
            Dim strResult As String = ""
            Dim strRes(1) As String
            Try
                strResult = objMechComptDO.Delete_MechCost(xmlDoc)

                If (strResult = "") Then
                    strRes(0) = "DEL"
                    strRes(1) = objErrHandle.GetErrorDescParameter("DEL", "")
                Else
                    strRes(0) = "NDEL"
                    strRes(1) = objErrHandle.GetErrorDescParameter("UNDEL", "")
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.MechCompetency", "Delete_MechCost", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strRes
        End Function
        Public Function GetMechCompetencyLevelDetails(ByVal mechCompLevelId As String) As Collection
            Dim detailsColl As New Collection
            Try
                Dim ds As New DataSet
                Dim dt As New DataTable
                Dim dv As New DataView

                ds = HttpContext.Current.Session("MechCompetencyLevel")
                If (ds.Tables.Count > 0) Then
                    If (ds.Tables(0).Rows.Count > 0) Then
                        dt = ds.Tables(0)
                        dv = dt.DefaultView
                        dv.RowFilter = "Id_Compt = '" + mechCompLevelId + "'"
                    End If

                    dt = dv.ToTable

                    If (dt.Rows.Count > 0) Then
                        For Each dtrow As DataRow In dt.Rows
                            Dim mechCompt As New MechCompetencyBO()
                            mechCompt.IdCompt = dtrow("ID_COMPT").ToString()
                            mechCompt.Compt_Description = dtrow("COMPT_DESCRIPTION").ToString()
                            mechCompt.HiIdCompt = dtrow("HIDID_COMPT").ToString()
                            detailsColl.Add(mechCompt)
                        Next
                    Else
                        dt = ds.Tables(0)
                        Dim details As New List(Of MechCompetencyBO)()
                        detailsColl.Add(details)
                    End If
                End If


            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.MechCompetency", "GetMechCompetencyLevelDetails", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return detailsColl
        End Function

    End Class
End Namespace

