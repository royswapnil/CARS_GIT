Public Class LinkToAccountingBO
    Private _id_Login As String
    Private _id_DeptAcCode As String
    Private _id_CustGrpAcCode As String
    Private _id_FreeDuty As Boolean
    Private _id_SaleCode_Type As String
    Private _id_Project As String
    Private _id_Selling_GL_CrDb As Boolean
    Private _id_Selling_GL_AccNo As String
    Private _id_Selling_GL_DeptAccNo As String
    Private _id_Selling_GL_Dimension As String
    Private _id_Discount_GL_CrDb As Boolean
    Private _id_Discount_GL_AccNo As String
    Private _id_Discount_GL_DeptAccNo As String
    Private _id_Discount_GL_Dimension As String
    Private _id_Stock_GL_CrDb As Boolean
    Private _id_Stock_GL_AccNo As String
    Private _id_Stock_GL_DeptAccNo As String
    Private _id_Stock_GL_Dimension As String
    Private _id_Cost_GL_CrDb As Boolean
    Private _id_Cost_GL_AccNo As String
    Private _id_Cost_GL_DeptAccNo As String
    Private _id_Cost_GL_Dimension As String
    Private _id_SellCost_GL_CrDb As Boolean
    Private _id_SellCost_GL_AccNo As String
    Private _id_SellCost_GL_DeptAccNo As String
    Private _id_SellCost_GL_Dimension As String

    Private _id_Cust_AccNo_CrDb As Boolean
    Private _id_GenLedger As Boolean
    Private _id_Description As String
    Private _id_Created_By As String
    Private _cust_Credit_Limit As Double
    Private _id_Customer As String
    Private _id_Tran As String
    Private _strXML As String
    Private _id_DeptId As String
    Private _id_VatCode As String
    Private _id_AccCodeType As String
    Private _id_Selling_GL_Desc As String
    Private _id_Discount_GL_Desc As String
    Private _id_Stock_GL_Desc As String
    Private _id_Cost_GL_Desc As String
    Private _id_SellCost_GL_Desc As String
    Private _id_desc As String
    Private _id_SaleCode_desc As String
    Private _laSlNo As String
    Private _id_Selling_GL_Id As Integer
    Private _id_Discount_GL_Id As Integer
    Private _id_Stock_GL_Id As Integer
    Private _id_Cost_GL_Id As Integer
    Private _id_SellCost_GL_Id As Integer
    Private _transaction_No As String
    Private _idSub As String
    Private _subName As String
    ''Export
    Private _table_flag As String
    Private _export_flag As String
    Private _templateId As String
    Private _id_Inv_No As String
    Private _fromDate As String
    Private _toDate As String
    Private _invDept As String
    ''
    Private _id_matrix As String
    Private _accountcode As String
    Private _la_slno As String
    Private _la_description As String
    Private _acc_type As String
    Private _gen_ledger As String
    Private _gl_crdb As String
    Private _gl_accno As String
    Private _gl_deptaccno As String
    Private _gl_dimension As String
    Private _id_slno As String
    Private _laId As String
    Private _trans_no As String
    Private _inv_no As String
    Private _inv_date As String
    Private _cust_name As String
    Private _total As String
    Private _error As String
    Private _debit_account As String
    Private _credit_account As String
    Private _dt_created As String
    Private _db_gl_amount As String
    Private _cr_gl_amount As String
    Private _sellingGL As String
    Private _costGL As String
    Public Property Id_AccCodeType() As String
        Get
            Return _id_AccCodeType
        End Get
        Set(ByVal value As String)
            _id_AccCodeType = value
        End Set
    End Property
    Public Property Id_VatCode() As String
        Get
            Return _id_VatCode
        End Get
        Set(ByVal value As String)
            _id_VatCode = value
        End Set
    End Property
    Public Property Balance_XML() As String
        Get
            Return _strXML
        End Get
        Set(ByVal value As String)
            _strXML = value
        End Set
    End Property
    Public Property Id_Login() As String
        Get
            Return _id_Login
        End Get
        Set(ByVal Value As String)
            _id_Login = Value
        End Set
    End Property

    Public Property Id_DeptAcCode() As String
        Get
            Return _id_DeptAcCode
        End Get
        Set(ByVal Value As String)
            _id_DeptAcCode = Value
        End Set
    End Property

    Public Property Id_CustGrpAcCode() As String
        Get
            Return _id_CustGrpAcCode
        End Get
        Set(ByVal Value As String)
            _id_CustGrpAcCode = Value
        End Set
    End Property

    Public Property Id_FreeDuty() As Boolean
        Get
            Return _id_FreeDuty
        End Get
        Set(ByVal Value As Boolean)
            _id_FreeDuty = Value
        End Set
    End Property

    Public Property Id_SaleCode_Type() As String
        Get
            Return _id_SaleCode_Type
        End Get
        Set(ByVal Value As String)
            _id_SaleCode_Type = Value
        End Set
    End Property


    Public Property Id_Project() As String
        Get
            Return _id_Project
        End Get
        Set(ByVal Value As String)
            _id_Project = Value
        End Set
    End Property

    Public Property Id_Selling_GL_CrDb() As Boolean
        Get
            Return _id_Selling_GL_CrDb
        End Get
        Set(ByVal Value As Boolean)
            _id_Selling_GL_CrDb = Value
        End Set
    End Property

    Public Property Id_Selling_GL_AccNo() As String
        Get
            Return _id_Selling_GL_AccNo
        End Get
        Set(ByVal Value As String)
            _id_Selling_GL_AccNo = Value
        End Set
    End Property

    Public Property Id_Selling_GL_DeptAccNo() As String
        Get
            Return _id_Selling_GL_DeptAccNo
        End Get
        Set(ByVal Value As String)
            _id_Selling_GL_DeptAccNo = Value
        End Set
    End Property

    Public Property Id_Selling_GL_Dimension() As String
        Get
            Return _id_Selling_GL_Dimension
        End Get
        Set(ByVal Value As String)
            _id_Selling_GL_Dimension = Value
        End Set
    End Property

    Public Property Id_Discount_GL_CrDb() As Boolean
        Get
            Return _id_Discount_GL_CrDb
        End Get
        Set(ByVal Value As Boolean)
            _id_Discount_GL_CrDb = Value
        End Set
    End Property

    Public Property Id_Discount_GL_AccNo() As String
        Get
            Return _id_Discount_GL_AccNo
        End Get
        Set(ByVal Value As String)
            _id_Discount_GL_AccNo = Value
        End Set
    End Property

    Public Property Id_Discount_GL_DeptAccNo() As String
        Get
            Return _id_Discount_GL_DeptAccNo
        End Get
        Set(ByVal Value As String)
            _id_Discount_GL_DeptAccNo = Value
        End Set
    End Property

    Public Property Id_Discount_GL_Dimension() As String
        Get
            Return _id_Discount_GL_Dimension
        End Get
        Set(ByVal Value As String)
            _id_Discount_GL_Dimension = Value
        End Set
    End Property

    Public Property Id_Stock_GL_CrDb() As Boolean
        Get
            Return _id_Stock_GL_CrDb
        End Get
        Set(ByVal Value As Boolean)
            _id_Stock_GL_CrDb = Value
        End Set
    End Property

    Public Property Id_Stock_GL_AccNo() As String
        Get
            Return _id_Stock_GL_AccNo
        End Get
        Set(ByVal Value As String)
            _id_Stock_GL_AccNo = Value
        End Set
    End Property

    Public Property Id_Stock_GL_DeptAccNo() As String
        Get
            Return _id_Selling_GL_DeptAccNo
        End Get
        Set(ByVal Value As String)
            _id_Selling_GL_DeptAccNo = Value
        End Set
    End Property

    Public Property Id_Stock_GL_Dimension() As String
        Get
            Return _id_Stock_GL_Dimension
        End Get
        Set(ByVal Value As String)
            _id_Stock_GL_Dimension = Value
        End Set
    End Property

    Public Property Id_Cost_GL_CrDb() As Boolean
        Get
            Return _id_Cost_GL_CrDb
        End Get
        Set(ByVal Value As Boolean)
            _id_Cost_GL_CrDb = Value
        End Set
    End Property

    Public Property Id_Cost_GL_AccNo() As String
        Get
            Return _id_Cost_GL_AccNo
        End Get
        Set(ByVal Value As String)
            _id_Cost_GL_AccNo = Value
        End Set
    End Property

    Public Property Id_Cost_GL_DeptAccNo() As String
        Get
            Return _id_Cost_GL_DeptAccNo
        End Get
        Set(ByVal Value As String)
            _id_Cost_GL_DeptAccNo = Value
        End Set
    End Property

    Public Property Id_Cost_GL_Dimension() As String
        Get
            Return _id_Cost_GL_Dimension
        End Get
        Set(ByVal Value As String)
            _id_Cost_GL_Dimension = Value
        End Set
    End Property

    Public Property Id_Cust_AccNo_CrDb() As Boolean
        Get
            Return _id_Cust_AccNo_CrDb
        End Get
        Set(ByVal Value As Boolean)
            _id_Cust_AccNo_CrDb = Value
        End Set
    End Property

    Public Property Id_GenLedger() As Boolean
        Get
            Return _id_GenLedger
        End Get
        Set(ByVal Value As Boolean)
            _id_GenLedger = Value
        End Set
    End Property

    Public Property Id_Description() As String
        Get
            Return _id_Description
        End Get
        Set(ByVal Value As String)
            _id_Description = Value
        End Set
    End Property

    Public Property Id_Created_By() As String
        Get
            Return _id_Created_By
        End Get
        Set(ByVal Value As String)
            _id_Created_By = Value
        End Set
    End Property
    Public Property Id_CUSTOMER() As String
        Get
            Return _id_Customer
        End Get
        Set(ByVal Value As String)
            _id_Customer = Value
        End Set
    End Property
    Public Property Cust_Credit_Limit() As Double
        Get
            Return _cust_Credit_Limit
        End Get
        Set(ByVal Value As Double)
            _cust_Credit_Limit = Value
        End Set
    End Property
    Public Property Id_Tran() As String
        Get
            Return _id_Tran
        End Get
        Set(ByVal Value As String)
            _id_Tran = Value
        End Set
    End Property
    Public Property Id_DeptId() As Integer
        Get
            Return _id_DeptId
        End Get
        Set(ByVal Value As Integer)
            _id_DeptId = Value
        End Set
    End Property
    Public Property Id_Selling_GL_Desc() As String
        Get
            Return _id_Selling_GL_Desc
        End Get
        Set(ByVal Value As String)
            _id_Selling_GL_Desc = Value
        End Set
    End Property
    Public Property Id_Discount_GL_Desc() As String
        Get
            Return _id_Discount_GL_Desc
        End Get
        Set(ByVal Value As String)
            _id_Discount_GL_Desc = Value
        End Set
    End Property
    Public Property Id_Stock_GL_Desc() As String
        Get
            Return _id_Stock_GL_Desc
        End Get
        Set(ByVal Value As String)
            _id_Stock_GL_Desc = Value
        End Set
    End Property
    Public Property Id_Cost_GL_Desc() As String
        Get
            Return _id_Cost_GL_Desc
        End Get
        Set(ByVal Value As String)
            _id_Cost_GL_Desc = Value
        End Set
    End Property
    Public Property Id_SellCost_GL_Desc() As String
        Get
            Return _id_SellCost_GL_Desc
        End Get
        Set(ByVal Value As String)
            _id_SellCost_GL_Desc = Value
        End Set
    End Property
    Public Property Id_SaleCode_Desc() As String
        Get
            Return _id_SaleCode_desc
        End Get
        Set(ByVal Value As String)
            _id_SaleCode_desc = Value
        End Set
    End Property
    Public Property Id_SellCost_GL_CrDb() As Boolean
        Get
            Return _id_SellCost_GL_CrDb
        End Get
        Set(ByVal Value As Boolean)
            _id_SellCost_GL_CrDb = Value
        End Set
    End Property
    Public Property Id_SellCost_GL_AccNo() As String
        Get
            Return _id_SellCost_GL_AccNo
        End Get
        Set(ByVal Value As String)
            _id_SellCost_GL_AccNo = Value
        End Set
    End Property

    Public Property Id_SellCost_GL_DeptAccNo() As String
        Get
            Return _id_SellCost_GL_DeptAccNo
        End Get
        Set(ByVal Value As String)
            _id_SellCost_GL_DeptAccNo = Value
        End Set
    End Property

    Public Property Id_SellCost_GL_Dimension() As String
        Get
            Return _id_SellCost_GL_Dimension
        End Get
        Set(ByVal Value As String)
            _id_SellCost_GL_Dimension = Value
        End Set
    End Property
    Public Property LA_SlNo() As String
        Get
            Return _laSlNo
        End Get
        Set(ByVal Value As String)
            _laSlNo = Value
        End Set
    End Property
    Public Property Id_Selling_GL_Id() As Integer
        Get
            Return _id_Selling_GL_Id
        End Get
        Set(ByVal Value As Integer)
            _id_Selling_GL_Id = Value
        End Set
    End Property
    Public Property Id_Discount_GL_Id() As Integer
        Get
            Return _id_Discount_GL_Id
        End Get
        Set(ByVal Value As Integer)
            _id_Discount_GL_Id = Value
        End Set
    End Property
    Public Property Id_Cost_GL_Id() As Integer
        Get
            Return _id_Cost_GL_Id
        End Get
        Set(ByVal Value As Integer)
            _id_Cost_GL_Id = Value
        End Set
    End Property
    Public Property Id_Stock_GL_Id() As Integer
        Get
            Return _id_Stock_GL_Id
        End Get
        Set(ByVal Value As Integer)
            _id_Stock_GL_Id = Value
        End Set
    End Property
    Public Property Id_SellCost_GL_Id() As Integer
        Get
            Return _id_SellCost_GL_Id
        End Get
        Set(ByVal Value As Integer)
            _id_SellCost_GL_Id = Value
        End Set
    End Property
    Public Property Transction_No() As String
        Get
            Return _transaction_No
        End Get
        Set(ByVal value As String)
            _transaction_No = value
        End Set
    End Property
    Public Property Id_Slno() As String
        Get
            Return _id_slno
        End Get
        Set(ByVal Value As String)
            _id_slno = Value
        End Set
    End Property
    Public Property LA_Description() As String
        Get
            Return _la_description
        End Get
        Set(ByVal Value As String)
            _la_description = Value
        End Set
    End Property
    Public Property Acc_Type() As String
        Get
            Return _acc_type
        End Get
        Set(ByVal Value As String)
            _acc_type = Value
        End Set
    End Property
    Public Property Gen_Ledger() As String
        Get
            Return _gen_ledger
        End Get
        Set(ByVal Value As String)
            _gen_ledger = Value
        End Set
    End Property
    Public Property Gl_Crdb() As String
        Get
            Return _gl_crdb
        End Get
        Set(ByVal Value As String)
            _gl_crdb = Value
        End Set
    End Property
    Public Property Gl_Accno() As String
        Get
            Return _gl_accno
        End Get
        Set(ByVal Value As String)
            _gl_accno = Value
        End Set
    End Property
    Public Property Gl_DeptAccno() As String
        Get
            Return _gl_deptaccno
        End Get
        Set(ByVal Value As String)
            _gl_deptaccno = Value
        End Set
    End Property
    Public Property Gl_Dimension() As String
        Get
            Return _gl_dimension
        End Get
        Set(ByVal Value As String)
            _gl_dimension = Value
        End Set
    End Property
    Public Property Id_Sub() As String
        Get
            Return _idSub
        End Get
        Set(ByVal value As String)
            _idSub = value
        End Set
    End Property
    Public Property Sub_Name() As String
        Get
            Return _subName
        End Get
        Set(ByVal value As String)
            _subName = value
        End Set
    End Property
    Public Property Table_Flag() As String
        Get
            Return _table_flag
        End Get
        Set(ByVal value As String)
            _table_flag = value
        End Set
    End Property
    Public Property Export_Flag() As String
        Get
            Return _export_flag
        End Get
        Set(ByVal value As String)
            _export_flag = value
        End Set
    End Property
    Public Property TemplateId() As String
        Get
            Return _templateId
        End Get
        Set(ByVal value As String)
            _templateId = value
        End Set
    End Property
    Public Property Id_Inv_No() As String
        Get
            Return _id_Inv_No
        End Get
        Set(ByVal value As String)
            _id_Inv_No = value
        End Set
    End Property
    Public Property From_Date() As String
        Get
            Return _fromDate
        End Get
        Set(ByVal value As String)
            _fromDate = value
        End Set
    End Property
    Public Property To_Date() As String
        Get
            Return _toDate
        End Get
        Set(ByVal value As String)
            _toDate = value
        End Set
    End Property
    Public Property InvDept() As String
        Get
            Return _invDept
        End Get
        Set(ByVal value As String)
            _invDept = value
        End Set
    End Property
    Public Property Id_Matrix() As String
        Get
            Return _id_matrix
        End Get
        Set(ByVal Value As String)
            _id_matrix = Value
        End Set
    End Property
    Public Property InvDate() As String
        Get
            Return _inv_date
        End Get
        Set(ByVal Value As String)
            _inv_date = Value
        End Set
    End Property
    Public Property InvNo() As String
        Get
            Return _inv_no
        End Get
        Set(ByVal Value As String)
            _inv_no = Value
        End Set
    End Property
    Public Property TransactionNo() As String
        Get
            Return _trans_no
        End Get
        Set(ByVal Value As String)
            _trans_no = Value
        End Set
    End Property
    Public Property LAIdMatrix() As String
        Get
            Return _laId
        End Get
        Set(ByVal Value As String)
            _laId = Value
        End Set
    End Property
    Public Property AccountCode() As String
        Get
            Return _accountcode
        End Get
        Set(ByVal Value As String)
            _accountcode = Value
        End Set
    End Property
    Public Property CustName() As String
        Get
            Return _cust_name
        End Get
        Set(ByVal Value As String)
            _cust_name = Value
        End Set
    End Property
    Public Property Total() As String
        Get
            Return _total
        End Get
        Set(ByVal Value As String)
            _total = Value
        End Set
    End Property
    Public Property Err() As String
        Get
            Return _error
        End Get
        Set(ByVal Value As String)
            _error = Value
        End Set
    End Property
    Public Property Debit_Account() As String
        Get
            Return _debit_account
        End Get
        Set(ByVal Value As String)
            _debit_account = Value
        End Set
    End Property
    Public Property Credit_Account() As String
        Get
            Return _credit_account
        End Get
        Set(ByVal Value As String)
            _credit_account = Value
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
    Public Property Gl_Db_Amount() As String
        Get
            Return _db_gl_amount
        End Get
        Set(ByVal Value As String)
            _db_gl_amount = Value
        End Set
    End Property
    Public Property Gl_Cr_Amount() As String
        Get
            Return _cr_gl_amount
        End Get
        Set(ByVal Value As String)
            _cr_gl_amount = Value
        End Set
    End Property
    Public Property SellingGL() As String
        Get
            Return _sellingGL
        End Get
        Set(ByVal Value As String)
            _sellingGL = Value
        End Set
    End Property
    Public Property CostGL() As String
        Get
            Return _costGL
        End Get
        Set(ByVal Value As String)
            _costGL = Value
        End Set
    End Property

End Class
