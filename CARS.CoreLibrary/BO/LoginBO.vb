Public Class LoginBO
    Private strUserId As String
    Private strPassword As String
    Private strModuleName As String
    Private strModName As String
    Public Property UserId() As String
        Get
            Return strUserId
        End Get
        Set(ByVal Value As String)
            strUserId = Value
        End Set
    End Property
    Public Property Password() As String
        Get
            Return strPassword
        End Get
        Set(ByVal Value As String)
            strPassword = Value
        End Set
    End Property
    Public Property pMLModuleName() As String
        Get
            Return strModName
        End Get
        Set(ByVal Value As String)
            strModName = Value
        End Set
    End Property
    Private strLangName As String
    Public Property PMLLangName() As String
        Get
            Return strLangName
        End Get
        Set(ByVal Value As String)
            strLangName = Value
        End Set
    End Property
    Private strMenuType As String
    Public Property PMLMenuType() As String
        Get
            Return strMenuType
        End Get
        Set(ByVal Value As String)
            strMenuType = Value
        End Set
    End Property
    Public Function GetUserConPer(ByVal DT As DataTable, ByVal FileName As String) As UserAccessPermissionsBO
        Dim objuserper As New UserAccessPermissionsBO
        Dim dr() As DataRow
        Dim dr1 As DataRow
        Dim i As Integer = 0
        Try
            FileName = FileName.Replace("\", "/")
            dr = DT.Select("NAME_URL LIKE '" & FileName.Trim().ToUpper() & "'")

            If dr.Length <> 0 Then
                For i = 0 To dr.Length - 1
                    dr1 = dr(i)
                    If dr1(2).ToString().ToUpper() = "DISCOUNT" Then
                        objuserper.PF_DISCOUNT = Convert.ToBoolean(dr1(3).ToString())
                        Continue For
                    End If

                    If dr1(2).ToString().ToUpper() = "HOURLY PRICE" Then
                        objuserper.PF_HOURLYPRICE = Convert.ToBoolean(dr1(3).ToString())
                        Continue For
                    End If

                    If dr1(2).ToString().ToUpper() = "NEGATIVE QUANTITY" Then
                        objuserper.PF_NEGATIVEQUNATITY = Convert.ToBoolean(dr1(3).ToString())
                        Continue For
                    End If

                    If dr1(2).ToString().ToUpper() = "SPARE PART - COST PRICE" Then
                        objuserper.PF_SPCOSTPRICE = Convert.ToBoolean(dr1(3).ToString())
                        Continue For
                    End If

                    If dr1(2).ToString().ToUpper() = "SPARE PART - DISCOUNT" Then
                        objuserper.PF_SPDISCOUNT = Convert.ToBoolean(dr1(3).ToString())
                        Continue For
                    End If

                    If dr1(2).ToString().ToUpper() = "SPARE PART - PRICE" Then
                        objuserper.PF_SPPRICE = Convert.ToBoolean(dr1(3).ToString())
                        Continue For
                    End If
                    If dr1(2).ToString().ToUpper() = "PAYMENT DETAILS" Then
                        objuserper.PF_PAYDET = Convert.ToBoolean(dr1(3).ToString())
                        Continue For
                    End If
                Next
            End If
            Return objuserper
        Catch ex As Exception
        End Try
        Return objuserper
    End Function
End Class
Public Class LoginDetails
    Private Login_id As String
    Private Password As String
    Private m_updated As String
    Private m_notupdated As String

    Public Property PLogin_ID() As String
        Get
            Return Login_id
        End Get
        Set(ByVal value As String)
            Login_id = value
        End Set
    End Property
    Public Property PPassword() As String
        Get
            Return Password
        End Get
        Set(ByVal value As String)
            Password = value
        End Set
    End Property
    Public Property Updated() As String
        Get
            Return m_updated
        End Get
        Set(ByVal value As String)
            m_updated = value
        End Set
    End Property
    Public Property NotUpdated() As String
        Get
            Return m_notupdated
        End Get
        Set(ByVal value As String)
            m_notupdated = value
        End Set
    End Property
End Class
