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

Public Class frmSendSMS
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim mobno As String = CType("", String)
        Dim name As String = CType("", String)
        Dim email As String = CType("", String)
        If Not (Session.Item("MobileNo") Is Nothing) Then
            mobno = CType(Session.Item("MobileNo"), String)
        End If
        If Not (Session.Item("Name") Is Nothing) Then
            name = CType(Session.Item("Name"), String)
        End If
        If Not (Session.Item("Email") Is Nothing) Then
            email = CType(Session.Item("Email"), String)
        End If

        txtMobile.Text = mobno
        txtEmail.Text = email
        txtName.Text = name
        'lblSMSText.Text = "SMS Text til " + name

    End Sub

End Class