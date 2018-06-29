Public Class ConfigRoleBO
#Region "Variable"
    Private _id_role As String
    Private _nm_role As String
    Private _id_subsidery_role As Integer
    Private _id_dept_role As Integer
    Private _id_scr_start_role As Integer
    Private _created_by As String
    Private _dt_created As DateTime
    Private _modified_by As String
    Private _dt_modified As DateTime
    Private _flg_sysadmin As Boolean
    Private _flg_deptadmin As Boolean
    Private _flg_subsidadmin As Boolean
    Private _id_scr As Integer
    Private _id_scr_util As Integer
    Private _flg_acc As Boolean = False
    Private _flg_acc_read As Boolean = False
    Private _flg_acc_write As Boolean = False
    Private _flg_acc_create As Boolean = False
    Private _flg_acc_print As Boolean = False
    Private _flg_acc_delete As Boolean = False
    Private _strscrrole As String
    Private _strdelrole As String
    Private _userid As String
    Private _id_language As String
    Private _scrnName As String
    Private _ctrlName As String
    Private _id_con_util As Integer
#End Region

#Region "Property"
    Public Property LanguageId() As String
        Get
            Return _id_language
        End Get
        Set(ByVal Value As String)
            _id_language = Value
        End Set
    End Property
    Public Property User() As String
        Get
            Return _userid
        End Get
        Set(ByVal Value As String)
            _userid = Value
        End Set
    End Property
    Public Property StrDelRole() As String
        Get
            Return _strdelrole
        End Get
        Set(ByVal Value As String)
            _strdelrole = Value
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
    Public Property Dt_Created() As DateTime
        Get
            Return _dt_created
        End Get
        Set(ByVal Value As DateTime)
            _dt_created = Value
        End Set
    End Property
    Public Property Dt_Modified() As DateTime
        Get
            Return _dt_modified
        End Get
        Set(ByVal value As DateTime)
            _dt_modified = value
        End Set
    End Property
    Public Property Id_Dept_Role() As Integer
        Get
            Return _id_dept_role
        End Get
        Set(ByVal value As Integer)
            _id_dept_role = value
        End Set
    End Property
    Public Property Id_Role() As String
        Get
            Return _id_role
        End Get
        Set(ByVal value As String)
            _id_role = value
        End Set
    End Property
    Public Property Id_Scr_Start_Role() As Integer
        Get
            Return _id_scr_start_role
        End Get
        Set(ByVal value As Integer)
            _id_scr_start_role = value
        End Set
    End Property
    Public Property Id_Subsidery_Role() As Integer
        Get
            Return _id_subsidery_role
        End Get
        Set(ByVal value As Integer)
            _id_subsidery_role = value
        End Set
    End Property
    Public Property Modified_By() As String
        Get
            Return _modified_by
        End Get
        Set(ByVal value As String)
            _modified_by = value
        End Set
    End Property
    Public Property Nm_Role() As String
        Get
            Return _nm_role
        End Get
        Set(ByVal value As String)
            _nm_role = value
        End Set
    End Property
    Public Property Flg_Sysadmin() As Boolean
        Get
            Return _flg_sysadmin
        End Get
        Set(ByVal value As Boolean)
            _flg_sysadmin = value
        End Set
    End Property
    Public Property Flg_Subsidadmin() As Boolean
        Get
            Return _flg_subsidadmin
        End Get
        Set(ByVal value As Boolean)
            _flg_subsidadmin = value
        End Set
    End Property
    Public Property Flg_Deptadmin() As Boolean
        Get
            Return _flg_deptadmin
        End Get
        Set(ByVal value As Boolean)
            _flg_deptadmin = value
        End Set
    End Property
    Public Property Flg_Acc() As Boolean
        Get
            Return _flg_acc
        End Get
        Set(ByVal value As Boolean)
            _flg_acc = value
        End Set
    End Property
    Public Property Flg_Acc_Read() As Boolean
        Get
            Return _flg_acc_read
        End Get
        Set(ByVal value As Boolean)
            _flg_acc_read = value
        End Set
    End Property
    Public Property Flg_Acc_Delete() As Boolean
        Get
            Return _flg_acc_delete
        End Get
        Set(ByVal value As Boolean)
            _flg_acc_delete = value
        End Set
    End Property
    Public Property Flg_Acc_Write() As Boolean
        Get
            Return _flg_acc_write
        End Get
        Set(ByVal value As Boolean)
            _flg_acc_write = value
        End Set
    End Property
    Public Property Flg_Acc_Create() As Boolean
        Get
            Return _flg_acc_create
        End Get
        Set(ByVal value As Boolean)
            _flg_acc_create = value
        End Set
    End Property
    Public Property Flg_Acc_Print() As Boolean
        Get
            Return _flg_acc_print
        End Get
        Set(ByVal value As Boolean)
            _flg_acc_print = value
        End Set
    End Property
    Public Property IdScreen() As Integer
        Get
            Return _id_scr
        End Get
        Set(ByVal value As Integer)
            _id_scr = value
        End Set
    End Property
    Public Property Scrlroleupdate() As String
        Get
            Return _strscrrole
        End Get
        Set(ByVal value As String)
            _strscrrole = value
        End Set
    End Property
    Public Property ScrnName() As String
        Get
            Return _scrnName
        End Get
        Set(ByVal Value As String)
            _scrnName = Value
        End Set
    End Property
    Public Property CtrlName() As String
        Get
            Return _ctrlName
        End Get
        Set(ByVal Value As String)
            _ctrlName = Value
        End Set
    End Property
    Public Property IdConUtil() As Integer
        Get
            Return _id_con_util
        End Get
        Set(ByVal value As Integer)
            _id_con_util = value
        End Set
    End Property
#End Region
End Class
