Imports System.Web.SessionState
Imports System.Data.Sql
Imports System.Data.SqlClient
Imports System.Runtime.Caching
Imports System.Data
Imports System.IO
Imports System.Web.Caching.Cache
Imports System.Web.Security
Imports System.Web.UI

Public Class Global_asax
    Inherits System.Web.HttpApplication
    Dim oErrHandle As New MSGCOMMON.MsgErrorHndlr
    Dim objCacheService As New CARS.CoreLibrary.CARS.Services.CacheLocalization.CacheLocalization
    Sub Application_Start(ByVal sender As Object, ByVal e As EventArgs)
        ' Fires when the application is started
        Dim dtCache As DataTable
        dtCache = objCacheService.GetCacheData()
        HttpRuntime.Cache.Insert("Caption", dtCache)
    End Sub

    Sub Session_Start(ByVal sender As Object, ByVal e As EventArgs)
        ' Fires when the session is started
    End Sub

    Sub Application_BeginRequest(ByVal sender As Object, ByVal e As EventArgs)
        ' Fires at the beginning of each request
    End Sub

    Sub Application_AuthenticateRequest(ByVal sender As Object, ByVal e As EventArgs)
        ' Fires upon attempting to authenticate the use
    End Sub

    Sub Application_Error(ByVal sender As Object, ByVal e As EventArgs)
        ' Fires when an error occurs
        Try
            Dim objErr As Exception = Server.GetLastError().GetBaseException()

            oErrHandle.WriteErrorLog(1, IO.Path.GetFileName(Me.Request.PhysicalPath), "Application_Error", objErr.Message.ToString(), objErr.GetBaseException.StackTrace.ToString.Trim, "admin")
        Catch ex As Exception
            oErrHandle.WriteErrorLog(1, "Global.asax", "Application_Error", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, "admin")
        End Try
    End Sub

    Sub Session_End(ByVal sender As Object, ByVal e As EventArgs)
        ' Fires when the session ends
    End Sub

    Sub Application_End(ByVal sender As Object, ByVal e As EventArgs)
        ' Fires when the application ends
        Try
            Dim runtime As HttpRuntime = DirectCast(GetType(System.Web.HttpRuntime).InvokeMember("_theRuntime", Reflection.BindingFlags.NonPublic Or Reflection.BindingFlags.[Static] Or Reflection.BindingFlags.GetField, Nothing, Nothing, Nothing), HttpRuntime)
            If runtime Is Nothing Then
                Return
            End If
            Dim shutDownMessage As String = DirectCast(runtime.[GetType]().InvokeMember("_shutDownMessage", Reflection.BindingFlags.NonPublic Or Reflection.BindingFlags.Instance Or Reflection.BindingFlags.GetField, Nothing, runtime, Nothing), String)

            Dim shutDownStack As String = DirectCast(runtime.[GetType]().InvokeMember("_shutDownStack", Reflection.BindingFlags.NonPublic Or Reflection.BindingFlags.Instance Or Reflection.BindingFlags.GetField, Nothing, runtime, Nothing), String)

            'Dim objErr As Exception = Server.GetLastError().GetBaseException()

            oErrHandle.WriteErrorLog(1, "Global.asax", "Application_End", shutDownMessage, "Error", "admin")
        Catch ex As Exception
            oErrHandle.WriteErrorLog(1, "Global.asax", "Application_End", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, "admin")
        End Try
    End Sub

End Class