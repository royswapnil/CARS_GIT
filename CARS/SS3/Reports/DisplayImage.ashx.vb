Imports System.Web
Imports System.Web.Services

Public Class DisplayImage
    Implements System.Web.IHttpHandler, IReadOnlySessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        'context.Response.ContentType = "text/plain"
        'context.Response.Write("Hello World!")
        Dim bImageData As Byte() = Nothing
        bImageData = context.Session.Item("RepImage")
        context.Response.ContentType = "image/gif"
        context.Response.BinaryWrite(bImageData)
        context.Response.End()
    End Sub

    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class