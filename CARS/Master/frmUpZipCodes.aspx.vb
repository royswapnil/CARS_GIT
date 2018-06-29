Imports System.IO
Imports System.Text
Imports System.Net
Imports System.Web.Services
Imports CARS.CoreLibrary
Imports CARS.CoreLibrary.CARS.ZipCodes

Public Class frmUpZipCodes
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'Update_ZipCodes()
    End Sub
    <WebMethod()>
    Public Shared Function Update_ZipCodes()
        Dim url As String = "http://www.bring.no/radgivning/sende-noe/adressetjenester/postnummer/_attachment/615728?_ts=14fd0e1cc58?_download=true"
        Dim dsZipCodes As DataSet = New DataSet
        Dim dtZipCodes As New DataTable("zip_codes")
        Dim zipCodes As New List(Of ZipCodesBO)
        Dim client As WebClient = New WebClient()
        Dim sr As StreamReader = New StreamReader(client.OpenRead(url), System.Text.Encoding.Default)
        Dim srRte As String = sr.ReadToEnd
        Dim zipCodesArray = srRte.Split(ControlChars.CrLf)
        Dim doZipCodes As New ZipCodesDO

        dtZipCodes.Columns.Add("zip_code") 'postnummer
        dtZipCodes.Columns.Add("zip_city") 'poststed
        dtZipCodes.Columns.Add("county_municipality") 'fylke/ kommune (kommunekode)
        dtZipCodes.Columns.Add("municipality_name") 'Kommunenavn
        dtZipCodes.Columns.Add("category") 'Kategori

        For Each item As String In zipCodesArray
            Dim items As String() = item.Split(ControlChars.Tab)
            If items.Length = 5 Then
                Dim row As DataRow = dtZipCodes.NewRow()
                row(0) = items(0).Replace(vbCr, "").Replace(vbLf, "")
                row(1) = items(1)
                row(2) = items(2)
                row(3) = items(3)
                row(4) = items(4)
                dtZipCodes.Rows.Add(row)
            End If
        Next
        Dim retStr = doZipCodes.ImportZipCode(dtZipCodes)

        sr.Close()
        sr.Dispose()

        Return retStr.Split(",")
        dtZipCodes.Dispose()
    End Function

    Public Shared Function GetJson(ByVal dt As DataTable) As String

        Dim serializer As System.Web.Script.Serialization.JavaScriptSerializer = New System.Web.Script.Serialization.JavaScriptSerializer()
        Dim rows As New List(Of Dictionary(Of String, Object))
        Dim row As Dictionary(Of String, Object)

        For Each dr As DataRow In dt.Rows
            row = New Dictionary(Of String, Object)
            For Each col As DataColumn In dt.Columns
                row.Add(col.ColumnName, dr(col))
            Next
            rows.Add(row)
        Next
        Return serializer.Serialize(rows)
    End Function
End Class

