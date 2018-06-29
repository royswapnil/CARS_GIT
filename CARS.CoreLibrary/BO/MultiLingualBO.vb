Imports Microsoft.VisualBasic
Imports System.IO
Public Class MultiLingualBO
    'Private _multiDO As MultilingualDO = Nothing
    'Dim _langCheckListBO As New LangaugeCheckListDO
    Dim _ctrlTypeName As String
    Dim _loginBo As New LoginBO
    Dim _objErr As New MSGCOMMON.MsgErrorHndlr()
    Private strLangName As String
    Private _scrName As String = String.Empty
    Private _ctrlName As String = String.Empty
    Private _idLang As Integer

#Region "Properties"
    Public Property ScreenName() As String
        Get
            Return _scrName
        End Get
        Set(ByVal value As String)
            _scrName = value
        End Set
    End Property
    Public Property ControlName() As String
        Get
            Return _ctrlName
        End Get
        Set(ByVal value As String)
            _ctrlName = value
        End Set
    End Property
    Public Property LangName() As String
        Get
            Return strLangName
        End Get
        Set(ByVal Value As String)
            strLangName = Value
        End Set
    End Property
    Public Property IdLang() As Integer
        Get
            Return _idLang
        End Get
        Set(ByVal Value As Integer)
            _idLang = Value
        End Set
    End Property
#End Region
End Class
