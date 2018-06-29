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
Namespace CARS.Services.CacheLocalization
    Public Class CacheLocalization
        Dim objCacheDO As New CARS.CacheLocalization.CacheLocalizationDO
        Dim ivLang As String
        Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
        Public Function GetCacheData() As DataTable
            Dim dsCache As New DataSet
            Dim dtCache As New DataTable
            Try
                ivLang = System.Configuration.ConfigurationManager.AppSettings("Language")
                dsCache = objCacheDO.GetCacheData(ivLang)
                If dsCache.Tables.Count > 0 Then
                    If dsCache.Tables(0).Rows.Count > 0 Then
                        dtCache = dsCache.Tables(0)
                    End If
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.CacheLocalization", "GetCacheData", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, "GetCacheData")
            End Try
            Return dtCache
        End Function

    End Class
End Namespace
