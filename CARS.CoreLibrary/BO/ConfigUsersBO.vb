Public Class ConfigUsersBO
#Region "Variable"
    Private _id_login As String
    Private _user_id As String
    Private _first_name As String
    Private _last_name As String
    Private _id_role_user As String
    Private _password As String
    Private _confirm_password As String
    Private _id_subsidery_user As String
    Private _id_dept As String
    Private _address1 As String
    Private _address2 As String
    Private _id_lang As Integer
    Private _id_zip_users As String
    Private _country As String
    Private _city As String
    Private _state As String
    Private _id_email As String
    Private _phone As String
    Private _flg_mechanic As Boolean
    Private _flg_mech_isactive As Boolean
    Private _mecpc_id_settings As Integer
    Private _created_by As String
    Private _dt_created As String
    Private _modified_by As String
    Private _dt_modified As String
    Private _faxno As String
    Private _mobileno As String
    Private _flg_configzipcode As Boolean
    Private _flg_use_idletime As Boolean
    Private _common_mechanic_id As String
    Private _iscommon_mechanic As Boolean
    Private _social_security_num As String
    Private _workhrs_frm As String
    Private _workhrs_to As String
    Private _flg_workhrs As Boolean
    Private _flg_duser As Boolean
    Private _id_email_acct As Integer
    Private _setting_name As String
    Private _flg_pin_menu As Boolean

#End Region
#Region "Property"
    Public Property Userid() As String
        Get
            Return _user_id
        End Get
        Set(ByVal Value As String)
            _user_id = Value
        End Set
    End Property
    Public Property Address1() As String
        Get
            Return _address1
        End Get
        Set(ByVal Value As String)
            _address1 = Value
        End Set
    End Property
    Public Property FaxNo() As String
        Get
            Return _faxno
        End Get
        Set(ByVal Value As String)
            _faxno = Value
        End Set
    End Property
    Public Property Mobileno() As String
        Get
            Return _mobileno
        End Get
        Set(ByVal Value As String)
            _mobileno = Value
        End Set
    End Property
    Public Property Address2() As String
        Get
            Return _address2
        End Get
        Set(ByVal Value As String)
            _address2 = Value
        End Set
    End Property
    Public Property Confirm_Password() As String
        Get
            Return _confirm_password
        End Get
        Set(ByVal Value As String)
            _confirm_password = Value
        End Set
    End Property
    Public Property Created_By() As String
        Get
            Return _created_by
        End Get
        Set(ByVal Value As String)
            _created_by = Value
        End Set
    End Property
    Public Property Dt_Created() As String
        Get
            Return _dt_created
        End Get
        Set(ByVal Value As String)
            _dt_created = Value
        End Set
    End Property
    Public Property Dt_Modified() As String
        Get
            Return _dt_modified
        End Get
        Set(ByVal Value As String)
            _dt_modified = Value
        End Set
    End Property
    Public Property First_Name() As String
        Get
            Return _first_name
        End Get
        Set(ByVal Value As String)
            _first_name = Value
        End Set
    End Property
    Public Property Flg_Mechanic() As Boolean
        Get
            Return _flg_mechanic
        End Get
        Set(ByVal Value As Boolean)
            _flg_mechanic = Value
        End Set
    End Property
    Public Property Id_Dept() As String
        Get
            Return _id_dept
        End Get
        Set(ByVal Value As String)
            _id_dept = Value
        End Set
    End Property
    Public Property Id_Email() As String
        Get
            Return _id_email
        End Get
        Set(ByVal Value As String)
            _id_email = Value
        End Set
    End Property
    Public Property Id_Lang() As Integer
        Get
            Return _id_lang
        End Get
        Set(ByVal Value As Integer)
            _id_lang = Value
        End Set
    End Property
    Public Property Id_Login() As String
        Get
            Return _id_login
        End Get
        Set(ByVal Value As String)
            _id_login = Value
        End Set
    End Property
    Public Property Id_Role_User() As String
        Get
            Return _id_role_user
        End Get
        Set(ByVal Value As String)
            _id_role_user = Value
        End Set
    End Property
    Public Property Id_Subsidery_User() As String
        Get
            Return _id_subsidery_user
        End Get
        Set(ByVal Value As String)
            _id_subsidery_user = Value
        End Set
    End Property
    Public Property Id_Zip_Users() As String
        Get
            Return _id_zip_users
        End Get
        Set(ByVal Value As String)
            _id_zip_users = Value
        End Set
    End Property
    Public Property Id_Country() As String
        Get
            Return _country
        End Get
        Set(ByVal Value As String)
            _country = Value
        End Set
    End Property
    Public Property Id_City() As String
        Get
            Return _city
        End Get
        Set(ByVal Value As String)
            _city = Value
        End Set
    End Property
    Public Property Id_State() As String
        Get
            Return _state
        End Get
        Set(ByVal Value As String)
            _state = Value
        End Set
    End Property
    Public Property Last_Name() As String
        Get
            Return _last_name
        End Get
        Set(ByVal Value As String)
            _last_name = Value
        End Set
    End Property
    Public Property Mecpc_Id_Settings() As Integer
        Get
            Return _mecpc_id_settings
        End Get
        Set(ByVal Value As Integer)
            _mecpc_id_settings = Value
        End Set
    End Property
    Public Property Modified_By() As String
        Get
            Return _modified_by
        End Get
        Set(ByVal Value As String)
            _modified_by = Value
        End Set
    End Property
    Public Property Password() As String
        Get
            Return _password
        End Get
        Set(ByVal Value As String)
            _password = Value
        End Set
    End Property
    Public Property Phone() As String
        Get
            Return _phone
        End Get
        Set(ByVal Value As String)
            _phone = Value
        End Set
    End Property
    Public Property Flg_Mech_Isactive() As Boolean
        Get
            Return _flg_mech_isactive
        End Get
        Set(ByVal value As Boolean)
            _flg_mech_isactive = value
        End Set
    End Property
    Public Property Flg_ConfigZipCode() As Boolean
        Get
            Return _flg_configzipcode
        End Get
        Set(ByVal value As Boolean)
            _flg_configzipcode = value
        End Set
    End Property
    Public Property Flg_Use_Idletime() As Boolean
        Get
            Return _flg_use_idletime
        End Get
        Set(ByVal value As Boolean)
            _flg_use_idletime = value
        End Set
    End Property
    Public Property Common_Mechanic_Id() As String
        Get
            Return _common_mechanic_id
        End Get
        Set(ByVal value As String)
            _common_mechanic_id = value
        End Set
    End Property
    Public Property Iscommon_Mechanic() As Boolean
        Get
            Return _iscommon_mechanic
        End Get
        Set(ByVal value As Boolean)
            _iscommon_mechanic = value
        End Set
    End Property
    Public Property Social_Security_Num() As String
        Get
            Return _social_security_num
        End Get
        Set(ByVal value As String)
            _social_security_num = value
        End Set
    End Property
    Public Property Workhrs_Frm() As String
        Get
            Return _workhrs_frm
        End Get
        Set(ByVal value As String)
            _workhrs_frm = value
        End Set
    End Property
    Public Property Workhrs_To() As String
        Get
            Return _workhrs_to
        End Get
        Set(ByVal value As String)
            _workhrs_to = value
        End Set
    End Property
    Public Property Flg_Workhrs() As Boolean
        Get
            Return _flg_workhrs
        End Get
        Set(ByVal value As Boolean)
            _flg_workhrs = value
        End Set
    End Property
    Public Property Flg_Duser() As Boolean
        Get
            Return _flg_duser
        End Get
        Set(ByVal value As Boolean)
            _flg_duser = value
        End Set
    End Property
    Public Property Id_Email_Acct() As Integer
        Get
            Return _id_email_acct
        End Get
        Set(ByVal value As Integer)
            _id_email_acct = value
        End Set
    End Property
    Public Property Setting_Name() As String
        Get
            Return _setting_name
        End Get
        Set(ByVal value As String)
            _setting_name = value
        End Set
    End Property
    Public Property flg_pin_menu() As Boolean
        Get
            Return _flg_pin_menu
        End Get
        Set(ByVal value As Boolean)
            _flg_pin_menu = value
        End Set
    End Property
#End Region
End Class
Public Class pinSwitch
    Inherits ConfigUsersBO
    Private _fetch As Boolean

    Public Property fetch() As Boolean
        Get
            Return _fetch
        End Get
        Set(ByVal value As Boolean)
            _fetch = value
        End Set
    End Property
End Class