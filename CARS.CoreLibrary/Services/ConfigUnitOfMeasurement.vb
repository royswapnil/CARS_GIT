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
Namespace CARS.Services.ConfigUOM
    Public Class ConfigUnitOfMeasurement
        Shared objUOMBO As New ConfigUnitOfMeasurementBO
        Shared objUOMDO As New ConfigUnitOfMeasurementDO
        Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
        Public Function LoadUOM() As List(Of ConfigUnitOfMeasurementBO)
            Dim dsLoadUOM As New DataSet
            Dim dtUOM As DataTable
            Dim uomDet As New List(Of ConfigUnitOfMeasurementBO)()
            Try
                dsLoadUOM = objUOMDO.Fetch_UOM()
                dtUOM = dsLoadUOM.Tables(0)
                For Each dtrow As DataRow In dtUOM.Rows
                    Dim det As New ConfigUnitOfMeasurementBO()
                    det.Id_UOM = dtrow("ID_UNIT").ToString()
                    det.Unit_Desc = dtrow("Unit_Desc").ToString()
                    det.Description = dtrow("Remarks").ToString()
                    uomDet.Add(det)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigUnitOfMeasurement", "LoadUOM", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return uomDet.ToList
        End Function
        Public Function AddUOMDetails(ByVal objUOMBO As ConfigUnitOfMeasurementBO) As String()
            Dim strResult As String = ""
            Dim strResVal As Array
            Try
                strResult = objUOMDO.AddUOMDetails(objUOMBO)
                strResVal = strResult.Split(",")
                Dim strValue = objUOMBO.Description.ToString
                If strResVal(0) = "True" Then
                    strResVal(0) = "INSERTED"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("ADD", "'" + objErrHandle.GetErrorDesc("MSG072") + "'")
                ElseIf strResVal(0) = "0" Then
                    strResVal(0) = "AEXISTS"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("MSG109")
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigUnitOfMeasurement", "AddUOMDetails", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strResVal
        End Function
        Public Function UpdUOMDetails(ByVal objUOMBO As ConfigUnitOfMeasurementBO) As String()
            Dim strResult As String = ""
            Dim strResVal As Array
            Try
                strResult = objUOMDO.UpdUOMDetails(objUOMBO)
                strResVal = strResult.Split(",")
                Dim strValue = objUOMBO.Description.ToString
                If strResVal(0) = "True" Then
                    strResVal(0) = "UPDATED"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("UPD", "'" + objErrHandle.GetErrorDesc("MSG072") + "'")
                ElseIf strResVal(0) = "0" Then
                    strResVal(0) = "AEXISTS"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("RECNUPDS", "'" + strValue + "'")
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigUnitOfMeasurement", "UpdUOMDetails", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strResVal
        End Function
        Public Function DeleteUOMDetails(ByVal idUOM As String) As String()
            Dim strResult As String = ""
            Dim strResVal As Array
            Try
                strResult = objUOMDO.DeleteUOMDetails(idUOM)
                strResVal = strResult.Split(",")

                If strResVal(0) = "True" Then
                    strResVal(0) = "DELETED"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("DDEL", "'" + objErrHandle.GetErrorDesc("MSG072") + "'")
                ElseIf (strResVal(0) = "Record already in use. Cannot be deleted") Then
                    strResVal(0) = "AEXISTS"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("MSG098")
                Else
                    strResVal(0) = "ERROR"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("MSG099")
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigUnitOfMeasurement", "DeleteUOMDetails", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strResVal
        End Function

    End Class
End Namespace

