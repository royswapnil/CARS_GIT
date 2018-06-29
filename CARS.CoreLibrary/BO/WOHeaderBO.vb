Public Class WOHeaderBO
    Private _id_wo_no As String
    Private _dt_order As String
    Private _wo_type As String
    Private _wo_status As String
    Private _dt_delivery As String
    Private _wo_tm_deliv As String
    Private _dt_finish As String
    Private _id_pay_type_wo As Integer
    Private _id_pay_terms_wo As Integer
    Private _wo_annot As String
    Private _id_cust_wo As String
    Private _wo_cust_name As String
    Private _wo_cust_add1 As String
    Private _cust_perm_add2 As String
    Private _id_zipcode_wo As String
    Private _pstate As String
    Private _bstate As String
    Private _wo_cust_phone_off As String
    Private _wo_cust_phone_home As String
    Private _wo_cust_phone_mobile As String
    Private _id_veh_seq_wo As Integer
    Private _wo_veh_reg_no As String
    Private _wo_veh_ern_no As String
    Private _wo_veh_vin As String
    Private _wo_veh_mileage As Integer
    Private _wo_veh_hrs As Decimal
    Private _created_by As String
    Private _dt_created As String
    Private _modified_by As String
    Private _dt_modified As String
    Private _cust_id As String
    Private _veh_id As String
    Private _veh_make As String
    Private _cust_group As String
    Private _dt_order_from As String
    Private _dt_order_to As String
    Private _by_search As String
    Private _search_txt As String
    Private _customer_txt As String
    Private _vehicle_txt As String
    Private _order_txt As String
    Private _invoice_txt As String
    Private _id_wo_prefix As String
    Private _tpay_type As String
    Private _fpay_type As String
    Private _veh_type As String
    Private _regndate As String
    Private _veh_grpdesc As String
    Private _cust_contact_person As String
    Private _cust_credit_limit As Decimal
    Private _cust_fax As String
    Private _cust_email As String
    Private _cust_pricecode As String
    Private _cust_account_no As String
    Private _cust_discount_code As String
    Private _issuccess As Boolean
    Private _errormessage As String
    Private _sucessmessage As String
    Private _control_num As String
    Private _buspekcontrolno As String
    Private _buspekpreviousno As String
    Private _startrowindex As Integer
    Private _maximumrows As Integer
    Private _totalrows As Integer
    Private _sortcolumn As String
    Private _sortorder As String
    Private _vehupdateflag As Boolean
    Private _flg_configzipcode As Boolean
    Private _dept_accnt_num As String
    Private _dbs_filename As String
    Private _va_cost_price As Decimal
    Private _va_sell_price As Decimal
    Private _va_number As String
    Private _flg_upd_mileage As Boolean
    Private _int_note As String
    Private _toCustomer_Txt As String
    Private _wo_PKKDate As String
    Private _pageIndex As Integer
    Private _pageSize As Integer
    Private _wholeWONO As String
    Private _id_settings As String
    Private _description As String
    Private _cdate As String
    Private _id_cust_group_seq As Integer
    Private _cust_desc As String
    Private _bill_add1 As String
    Private _bill_add2 As String
    Private _veh_int_no As String
    Private _id_make As String
    Private _id_model As String
    Private _veh_det As String
    Private _pickNo As String
    Private _van_num As String
    Private _id_country As String
    Private _id_state As String
    Private _city As String
    Private _canzip As String
    Private _pay_type As String
    Private _pay_term As String
    Private _vat As String
    Private _id_pay_currency As String
    Private _flg_disp_int_note As String
    Private _dt_mileage_update As String
    Private _dt_hours_update As String
    Private _la_dept_account_no As String
    Private _cust_ssn_no As String
    Private _cust_driv_licno As String
    Private _flg_cust_inactive As Boolean
    Private _flg_cust_adv As Boolean
    Private _pzipcode As String
    Private _pcity As String
    Private _pcountry As String
    Private _bzipcode As String
    Private _bcity As String
    Private _bcountry As String
    Private _veh_mdl_year As String
    Private _dt_Veh_Regn As String
    Private _veh_driver As String
    Private _veh_mobile As String
    Private _veh_phone1 As String
    Private _veh_drv_emailid As String
    Private _veh_annot As String
    Private _dt_veh_mil_regn As String
    Private _dt_veh_hrs_regn As String
    Private _veh_flg_service_plan As Boolean
    Private _va_order As String
    Private _id_job As Integer
    Private _wo_job_txt As String
    Private _hpflag As String
    Private _debitor As String
    Private _job_amt As Decimal
    Private _job_exvat_amt As Decimal
    Private _job_status As String
    Private _mechanicname As String
    Private _totclockedtime As String
    Private _mechstatus As String
    Private _mechcode As String
    Private _modelDesc As String
    Private _lastInvDate As String
    Private _orderNo As String
    Private _jobs As String
    Private _vehOwnerName As String
    Private _vehDriver As String
    Private _dt_veh_last_regn As String
    Private _veh_srv_type As String
    Private _id_model_RP As String
    Private _veh_flg_addon As Boolean
    Private _id_addon_locdept As String
    Private _id_vat_code As String
    Private _VA_acc_code As String
    Private _pick As String
    Private _compStatus As String
    Private _clockIn As String
    Private _clockOut As String
    Private _defectId As String
    Private _status As String
    Private _isStatus As String
    Private _defectDesc As String
    Private _loginId As String
    Private _tmp_id_settings As String
    Private _cust_company_no As String
    Private _cust_company_description As String
    Private _flg_private_comp As Boolean
    Private _cust_last_name As String
    Private _cust_disc_general As String
    Private _cust_disc_labour As String
    Private _cust_disc_spares As String
    Private _ref_Wo_No As String

    Public Property Dbs_Filename() As String
        Get
            Return _dbs_filename
        End Get
        Set(ByVal value As String)
            _dbs_filename = value
        End Set
    End Property
    Public Property Cust_Contactperson() As String
        Get
            Return _cust_contact_person
        End Get
        Set(ByVal value As String)
            _cust_contact_person = value
        End Set
    End Property
    Public Property Cust_Credit_Limit() As Decimal
        Get
            Return _cust_credit_limit
        End Get
        Set(ByVal value As Decimal)
            _cust_credit_limit = value
        End Set
    End Property
    Public Property Cust_Fax() As String
        Get
            Return _cust_fax
        End Get
        Set(ByVal value As String)
            _cust_fax = value
        End Set
    End Property
    Public Property Cust_Email() As String
        Get
            Return _cust_email
        End Get
        Set(ByVal value As String)
            _cust_email = value
        End Set
    End Property
    Public Property Cust_Pricecode() As String
        Get
            Return _cust_pricecode
        End Get
        Set(ByVal value As String)
            _cust_pricecode = value
        End Set
    End Property
    Public Property Cust_Account_No() As String
        Get
            Return _cust_account_no
        End Get
        Set(ByVal value As String)
            _cust_account_no = value
        End Set
    End Property
    Public Property Cust_Discount_Code() As String
        Get
            Return _cust_discount_code
        End Get
        Set(ByVal value As String)
            _cust_discount_code = value
        End Set
    End Property
    Public Property IsSuccess() As Boolean
        Get
            Return _issuccess
        End Get
        Set(ByVal value As Boolean)
            _issuccess = value
        End Set
    End Property
    Public Property ErrorMessage() As String
        Get
            Return _errormessage
        End Get
        Set(ByVal value As String)
            _errormessage = value
        End Set
    End Property
    Public Property SuccessMessage() As String
        Get
            Return _sucessmessage
        End Get
        Set(ByVal value As String)
            _sucessmessage = value
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
    Public Property Cust_Perm_Add2() As String
        Get
            Return _cust_perm_add2
        End Get
        Set(ByVal Value As String)
            _cust_perm_add2 = Value
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
    Public Property Dt_Delivery() As String
        Get
            Return _dt_delivery
        End Get
        Set(ByVal Value As String)
            _dt_delivery = Value
        End Set
    End Property
    Public Property Dt_Finish() As String
        Get
            Return _dt_finish
        End Get
        Set(ByVal Value As String)
            _dt_finish = Value
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
    Public Property Dt_Order() As String
        Get
            Return _dt_order
        End Get
        Set(ByVal Value As String)
            _dt_order = Value
        End Set
    End Property
    Public Property Id_Cust_Wo() As String
        Get
            Return _id_cust_wo
        End Get
        Set(ByVal Value As String)
            _id_cust_wo = Value
        End Set
    End Property
    Public Property Id_Pay_Terms_WO() As Integer
        Get
            Return _id_pay_terms_wo
        End Get
        Set(ByVal Value As Integer)
            _id_pay_terms_wo = Value
        End Set
    End Property
    Public Property Id_Pay_Type_WO() As Integer
        Get
            Return _id_pay_type_wo
        End Get
        Set(ByVal Value As Integer)
            _id_pay_type_wo = Value
        End Set
    End Property
    Public Property Id_Veh_Seq_WO() As Integer
        Get
            Return _id_veh_seq_wo
        End Get
        Set(ByVal Value As Integer)
            _id_veh_seq_wo = Value
        End Set
    End Property
    Public Property Id_WO_NO() As String
        Get
            Return _id_wo_no
        End Get
        Set(ByVal Value As String)
            _id_wo_no = Value
        End Set
    End Property
    Public Property Id_Zipcode_WO() As String
        Get
            Return _id_zipcode_wo
        End Get
        Set(ByVal Value As String)
            _id_zipcode_wo = Value
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
    Public Property WO_Annot() As String
        Get
            Return _wo_annot
        End Get
        Set(ByVal Value As String)
            _wo_annot = Value
        End Set
    End Property
    Public Property WO_Cust_Add1() As String
        Get
            Return _wo_cust_add1
        End Get
        Set(ByVal Value As String)
            _wo_cust_add1 = Value
        End Set
    End Property
    Public Property WO_Cust_Name() As String
        Get
            Return _wo_cust_name
        End Get
        Set(ByVal Value As String)
            _wo_cust_name = Value
        End Set
    End Property
    Public Property WO_Cust_Phone_Home() As String
        Get
            Return _wo_cust_phone_home
        End Get
        Set(ByVal Value As String)
            _wo_cust_phone_home = Value
        End Set
    End Property
    Public Property WO_Cust_Phone_Mobile() As String
        Get
            Return _wo_cust_phone_mobile
        End Get
        Set(ByVal Value As String)
            _wo_cust_phone_mobile = Value
        End Set
    End Property
    Public Property PState() As String
        Get
            Return _pstate
        End Get
        Set(ByVal Value As String)
            _pstate = Value
        End Set
    End Property
    Public Property WO_Cust_Phone_Off() As String
        Get
            Return _wo_cust_phone_off
        End Get
        Set(ByVal Value As String)
            _wo_cust_phone_off = Value
        End Set
    End Property
    Public Property WO_Status() As String
        Get
            Return _wo_status
        End Get
        Set(ByVal Value As String)
            _wo_status = Value
        End Set
    End Property
    Public Property WO_Tm_Deliv() As String
        Get
            Return _wo_tm_deliv
        End Get
        Set(ByVal Value As String)
            _wo_tm_deliv = Value
        End Set
    End Property
    Public Property WO_Type() As String
        Get
            Return _wo_type
        End Get
        Set(ByVal Value As String)
            _wo_type = Value
        End Set
    End Property
    Public Property WO_Veh_Hrs() As Decimal
        Get
            Return _wo_veh_hrs
        End Get
        Set(ByVal Value As Decimal)
            _wo_veh_hrs = Value
        End Set
    End Property
    Public Property WO_Veh_ERN_NO() As String
        Get
            Return _wo_veh_ern_no
        End Get
        Set(ByVal Value As String)
            _wo_veh_ern_no = Value
        End Set
    End Property
    Public Property WO_Veh_Mileage() As Integer
        Get
            Return _wo_veh_mileage
        End Get
        Set(ByVal Value As Integer)
            _wo_veh_mileage = Value
        End Set
    End Property
    Public Property WO_Veh_Reg_NO() As String
        Get
            Return _wo_veh_reg_no
        End Get
        Set(ByVal Value As String)
            _wo_veh_reg_no = Value
        End Set
    End Property
    Public Property WO_Veh_Vin() As String
        Get
            Return _wo_veh_vin
        End Get
        Set(ByVal Value As String)
            _wo_veh_vin = Value
        End Set
    End Property
    Public Property Cust_ID() As String
        Get
            Return _cust_id
        End Get
        Set(ByVal Value As String)
            _cust_id = Value
        End Set
    End Property '
    Public Property Veh_ID() As String
        Get
            Return _veh_id
        End Get
        Set(ByVal Value As String)
            _veh_id = Value
        End Set
    End Property
    Public Property Veh_Make() As String
        Get
            Return _veh_make
        End Get
        Set(ByVal Value As String)
            _veh_make = Value
        End Set
    End Property
    Public Property Cust_Group() As String
        Get
            Return _cust_group
        End Get
        Set(ByVal Value As String)
            _cust_group = Value
        End Set
    End Property
    Public Property Dt_Order_From() As String
        Get
            Return _dt_order_from
        End Get
        Set(ByVal Value As String)
            _dt_order_from = Value
        End Set
    End Property
    Public Property Dt_Order_To() As String
        Get
            Return _dt_order_to
        End Get
        Set(ByVal Value As String)
            _dt_order_to = Value
        End Set
    End Property
    Public Property Search_Txt() As String
        Get
            Return _by_search
        End Get
        Set(ByVal Value As String)
            _by_search = Value
        End Set
    End Property
    Public Property By_Search() As String
        Get
            Return _search_txt
        End Get
        Set(ByVal Value As String)
            _search_txt = Value
        End Set
    End Property
    Public Property Customer_Txt() As String
        Get
            Return _customer_txt
        End Get
        Set(ByVal Value As String)
            _customer_txt = Value
        End Set
    End Property
    Public Property ToCustomer_Txt() As String
        Get
            Return _toCustomer_Txt
        End Get
        Set(ByVal Value As String)
            _toCustomer_Txt = Value
        End Set
    End Property
    Public Property Vehicle_Txt() As String
        Get
            Return _vehicle_txt
        End Get
        Set(ByVal Value As String)
            _vehicle_txt = Value
        End Set
    End Property
    Public Property Order_Txt() As String
        Get
            Return _order_txt
        End Get
        Set(ByVal Value As String)
            _order_txt = Value
        End Set
    End Property
    Public Property Invoice_Txt() As String
        Get
            Return _invoice_txt
        End Get
        Set(ByVal Value As String)
            _invoice_txt = Value
        End Set
    End Property
    Public Property Id_WO_Prefix() As String
        Get
            Return _id_wo_prefix
        End Get
        Set(ByVal Value As String)
            _id_wo_prefix = Value
        End Set
    End Property
    Public Property Fpay_Type() As String
        Get
            Return _fpay_type
        End Get
        Set(ByVal Value As String)
            _fpay_type = Value
        End Set
    End Property
    Public Property Tpay_Type() As String
        Get
            Return _tpay_type
        End Get
        Set(ByVal Value As String)
            _tpay_type = Value
        End Set
    End Property
    Public Property WO_PKKDate() As String
        Get
            Return _wo_PKKDate
        End Get
        Set(ByVal Value As String)
            _wo_PKKDate = Value
        End Set
    End Property
    Public Property Control_Num() As String
        Get
            Return _control_num
        End Get
        Set(ByVal Value As String)
            _control_num = Value
        End Set
    End Property
    Public Property Buspek_Control_No() As String
        Get
            Return _buspekcontrolno
        End Get
        Set(ByVal value As String)
            _buspekcontrolno = value
        End Set
    End Property
    Public Property Buspek_Previous_No() As String
        Get
            Return _buspekpreviousno
        End Get
        Set(ByVal value As String)
            _buspekpreviousno = value
        End Set
    End Property
    Public Property StartRowIndex() As Integer
        Get
            Return _startrowindex
        End Get
        Set(ByVal value As Integer)
            _startrowindex = value
        End Set
    End Property
    Public Property MaximumRows() As Integer
        Get
            Return _maximumrows
        End Get
        Set(ByVal value As Integer)
            _maximumrows = value
        End Set
    End Property
    Public Property TotalRows() As Integer
        Get
            Return _totalrows
        End Get
        Set(ByVal value As Integer)
            _totalrows = value
        End Set
    End Property
    Public Property SortColumn() As String
        Get
            Return _sortcolumn
        End Get
        Set(ByVal value As String)
            _sortcolumn = value
        End Set
    End Property
    Public Property SortOrder() As String
        Get
            Return _sortorder
        End Get
        Set(ByVal value As String)
            _sortorder = value
        End Set
    End Property 'End of Modification
    Public Property PageIndex() As Integer
        Get
            Return _pageIndex
        End Get
        Set(ByVal value As Integer)
            _pageIndex = value
        End Set
    End Property
    Public Property PageSize() As Integer
        Get
            Return _pageSize
        End Get
        Set(ByVal value As Integer)
            _pageSize = value
        End Set
    End Property
    Public Property WholeWONO() As String
        Get
            Return _wholeWONO
        End Get
        Set(ByVal value As String)
            _wholeWONO = value
        End Set
    End Property
    Public Property Veh_Update_flag() As Boolean
        Get
            Return _vehupdateflag
        End Get
        Set(ByVal value As Boolean)
            _vehupdateflag = value
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
    Public Property Dept_Accnt_Num() As String
        Get
            Return _dept_accnt_num
        End Get
        Set(ByVal value As String)
            _dept_accnt_num = value
        End Set
    End Property
    Public Property VA_Cost_Price() As Decimal
        Get
            Return _va_cost_price
        End Get
        Set(ByVal value As Decimal)
            _va_cost_price = value
        End Set
    End Property
    Public Property VA_Sell_Price() As Decimal
        Get
            Return _va_sell_price
        End Get
        Set(ByVal value As Decimal)
            _va_sell_price = value
        End Set
    End Property
    Public Property VA_Number() As String
        Get
            Return _va_number
        End Get
        Set(ByVal value As String)
            _va_number = value
        End Set
    End Property
    Public Property Flg_Upd_Mileage() As Boolean
        Get
            Return _flg_upd_mileage
        End Get
        Set(ByVal value As Boolean)
            _flg_upd_mileage = value
        End Set
    End Property
    Public Property Regn_Date() As String
        Get
            Return _regndate
        End Get
        Set(ByVal Value As String)
            _regndate = Value
        End Set
    End Property
    Public Property Veh_Type() As String
        Get
            Return _veh_type
        End Get
        Set(ByVal Value As String)
            _veh_type = Value
        End Set
    End Property
    Public Property Veh_Grpdesc() As String
        Get
            Return _veh_grpdesc
        End Get
        Set(ByVal Value As String)
            _veh_grpdesc = Value
        End Set
    End Property
    Public Property Int_Note() As String
        Get
            Return _int_note
        End Get
        Set(ByVal Value As String)
            _int_note = Value
        End Set
    End Property
    Public Property Id_Settings() As String
        Get
            Return _id_settings
        End Get
        Set(ByVal Value As String)
            _id_settings = Value
        End Set
    End Property
    Public Property Description() As String
        Get
            Return _description
        End Get
        Set(ByVal Value As String)
            _description = Value
        End Set
    End Property
    Public Property WOCdate() As String
        Get
            Return _cdate
        End Get
        Set(ByVal Value As String)
            _cdate = Value
        End Set
    End Property
    Public Property Id_Cust_Group_Seq() As Integer
        Get
            Return _id_cust_group_seq
        End Get
        Set(ByVal Value As Integer)
            _id_cust_group_seq = Value
        End Set
    End Property
    Public Property Cust_Description() As String
        Get
            Return _cust_desc
        End Get
        Set(ByVal Value As String)
            _cust_desc = Value
        End Set
    End Property
    Public Property Bill_Add1() As String
        Get
            Return _bill_add1
        End Get
        Set(ByVal Value As String)
            _bill_add1 = Value
        End Set
    End Property
    Public Property Bill_Add2() As String
        Get
            Return _bill_add2
        End Get
        Set(ByVal Value As String)
            _bill_add2 = Value
        End Set
    End Property
    Public Property Veh_Int_No() As String
        Get
            Return _veh_int_no
        End Get
        Set(ByVal Value As String)
            _veh_int_no = Value
        End Set
    End Property
    Public Property Id_Make() As String
        Get
            Return _id_make
        End Get
        Set(ByVal Value As String)
            _id_make = Value
        End Set
    End Property
    Public Property Id_Model() As String
        Get
            Return _id_model
        End Get
        Set(ByVal Value As String)
            _id_model = Value
        End Set
    End Property
    Public Property Model_Desc() As String
        Get
            Return _modelDesc
        End Get
        Set(ByVal Value As String)
            _modelDesc = Value
        End Set
    End Property
    Public Property Veh_Det() As String
        Get
            Return _veh_det
        End Get
        Set(ByVal Value As String)
            _veh_det = Value
        End Set
    End Property
    Public Property PickNo() As String
        Get
            Return _pickNo
        End Get
        Set(ByVal Value As String)
            _pickNo = Value
        End Set
    End Property
    Public Property Van_Num() As String
        Get
            Return _van_num
        End Get
        Set(ByVal Value As String)
            _van_num = Value
        End Set
    End Property
    Public Property Id_Country() As String
        Get
            Return _id_country
        End Get
        Set(ByVal Value As String)
            _id_country = Value
        End Set
    End Property
    Public Property Id_State() As String
        Get
            Return _id_state
        End Get
        Set(ByVal Value As String)
            _id_state = Value
        End Set
    End Property
    Public Property City() As String
        Get
            Return _city
        End Get
        Set(ByVal Value As String)
            _city = Value
        End Set
    End Property
    Public Property Canzip() As String
        Get
            Return _canzip
        End Get
        Set(ByVal Value As String)
            _canzip = Value
        End Set
    End Property
    Public Property Pay_Type() As String
        Get
            Return _pay_type
        End Get
        Set(ByVal Value As String)
            _pay_type = Value
        End Set
    End Property
    Public Property Pay_Term() As String
        Get
            Return _pay_term
        End Get
        Set(ByVal Value As String)
            _pay_term = Value
        End Set
    End Property
    Public Property VAT() As String
        Get
            Return _vat
        End Get
        Set(ByVal Value As String)
            _vat = Value
        End Set
    End Property
    Public Property Id_Pay_Currency() As String
        Get
            Return _id_pay_currency
        End Get
        Set(ByVal Value As String)
            _id_pay_currency = Value
        End Set
    End Property
    Public Property Flg_Disp_Int_Note() As String
        Get
            Return _flg_disp_int_note
        End Get
        Set(ByVal Value As String)
            _flg_disp_int_note = Value
        End Set
    End Property
    Public Property Dt_Mileage_Update() As String
        Get
            Return _dt_mileage_update
        End Get
        Set(ByVal Value As String)
            _dt_mileage_update = Value
        End Set
    End Property
    Public Property Dt_Hours_Update() As String
        Get
            Return _dt_hours_update
        End Get
        Set(ByVal Value As String)
            _dt_hours_update = Value
        End Set
    End Property
    Public Property La_Dept_Account_No() As String
        Get
            Return _la_dept_account_no
        End Get
        Set(ByVal Value As String)
            _la_dept_account_no = Value
        End Set
    End Property
    Public Property Cust_SSN_No() As String
        Get
            Return _cust_ssn_no
        End Get
        Set(ByVal Value As String)
            _cust_ssn_no = Value
        End Set
    End Property
    Public Property Cust_Driv_Licno() As String
        Get
            Return _cust_driv_licno
        End Get
        Set(ByVal Value As String)
            _cust_driv_licno = Value
        End Set
    End Property
    Public Property Flg_Cust_InActive() As Boolean
        Get
            Return _flg_cust_inactive
        End Get
        Set(ByVal value As Boolean)
            _flg_cust_inactive = value
        End Set
    End Property
    Public Property FLG_Cust_Adv() As Boolean
        Get
            Return _flg_cust_adv
        End Get
        Set(ByVal value As Boolean)
            _flg_cust_adv = value
        End Set
    End Property
    Public Property PZipcode() As String
        Get
            Return _pzipcode
        End Get
        Set(ByVal Value As String)
            _pzipcode = Value
        End Set
    End Property
    Public Property PCity() As String
        Get
            Return _pcity
        End Get
        Set(ByVal Value As String)
            _pcity = Value
        End Set
    End Property
    Public Property PCountry() As String
        Get
            Return _pcountry
        End Get
        Set(ByVal Value As String)
            _pcountry = Value
        End Set
    End Property
    Public Property BZipcode() As String
        Get
            Return _bzipcode
        End Get
        Set(ByVal Value As String)
            _bzipcode = Value
        End Set
    End Property
    Public Property BCity() As String
        Get
            Return _bcity
        End Get
        Set(ByVal Value As String)
            _bcity = Value
        End Set
    End Property
    Public Property BCountry() As String
        Get
            Return _bcountry
        End Get
        Set(ByVal Value As String)
            _bcountry = Value
        End Set
    End Property
    Public Property BState() As String
        Get
            Return _bstate
        End Get
        Set(ByVal Value As String)
            _bstate = Value
        End Set
    End Property
    Public Property Veh_Mdl_Year() As String
        Get
            Return _veh_mdl_year
        End Get
        Set(ByVal Value As String)
            _veh_mdl_year = Value
        End Set
    End Property
    Public Property Dt_Veh_Regn() As String
        Get
            Return _dt_Veh_Regn
        End Get
        Set(ByVal Value As String)
            _dt_Veh_Regn = Value
        End Set
    End Property
    Public Property Veh_Driver() As String
        Get
            Return _veh_driver
        End Get
        Set(ByVal Value As String)
            _veh_driver = Value
        End Set
    End Property
    Public Property Veh_Mobile() As String
        Get
            Return _veh_mobile
        End Get
        Set(ByVal Value As String)
            _veh_mobile = Value
        End Set
    End Property
    Public Property Veh_Phone1() As String
        Get
            Return _veh_phone1
        End Get
        Set(ByVal Value As String)
            _veh_phone1 = Value
        End Set
    End Property
    Public Property Veh_Drv_Emailid() As String
        Get
            Return _veh_drv_emailid
        End Get
        Set(ByVal Value As String)
            _veh_drv_emailid = Value
        End Set
    End Property
    Public Property Veh_Annot() As String
        Get
            Return _veh_annot
        End Get
        Set(ByVal Value As String)
            _veh_annot = Value
        End Set
    End Property
    Public Property Dt_Veh_Mil_Regn() As String
        Get
            Return _dt_veh_mil_regn
        End Get
        Set(ByVal Value As String)
            _dt_veh_mil_regn = Value
        End Set
    End Property
    Public Property Dt_Veh_Hrs_Regn() As String
        Get
            Return _dt_veh_hrs_regn
        End Get
        Set(ByVal Value As String)
            _dt_veh_hrs_regn = Value
        End Set
    End Property
    Public Property Veh_Flg_Service_Plan() As Boolean
        Get
            Return _veh_flg_service_plan
        End Get
        Set(ByVal Value As Boolean)
            _veh_flg_service_plan = Value
        End Set
    End Property
    Public Property VA_Order() As String
        Get
            Return _va_order
        End Get
        Set(ByVal Value As String)
            _va_order = Value
        End Set
    End Property
    Public Property Id_Job() As Integer
        Get
            Return _id_job
        End Get
        Set(ByVal Value As Integer)
            _id_job = Value
        End Set
    End Property
    Public Property WO_Job_Txt() As String
        Get
            Return _wo_job_txt
        End Get
        Set(ByVal Value As String)
            _wo_job_txt = Value
        End Set
    End Property
    Public Property HpFlag() As String
        Get
            Return _hpflag
        End Get
        Set(ByVal Value As String)
            _hpflag = Value
        End Set
    End Property
    Public Property Debitor() As String
        Get
            Return _debitor
        End Get
        Set(ByVal Value As String)
            _debitor = Value
        End Set
    End Property
    Public Property Job_Amt() As Decimal
        Get
            Return _job_amt
        End Get
        Set(ByVal Value As Decimal)
            _job_amt = Value
        End Set
    End Property
    Public Property Job_ExVat_Amt() As Decimal
        Get
            Return _job_exvat_amt
        End Get
        Set(ByVal Value As Decimal)
            _job_exvat_amt = Value
        End Set
    End Property
    Public Property Job_Status() As String
        Get
            Return _job_status
        End Get
        Set(ByVal Value As String)
            _job_status = Value
        End Set
    End Property
    Public Property MechanicName() As String
        Get
            Return _mechanicname
        End Get
        Set(ByVal Value As String)
            _mechanicname = Value
        End Set
    End Property
    Public Property TotClockedTime() As String
        Get
            Return _totclockedtime
        End Get
        Set(ByVal Value As String)
            _totclockedtime = Value
        End Set
    End Property
    Public Property MechStatus() As String
        Get
            Return _mechstatus
        End Get
        Set(ByVal Value As String)
            _mechstatus = Value
        End Set
    End Property
    Public Property MechCode() As String
        Get
            Return _mechcode
        End Get
        Set(ByVal Value As String)
            _mechcode = Value
        End Set
    End Property
    Public Property LastInvDate() As String
        Get
            Return _lastInvDate
        End Get
        Set(ByVal Value As String)
            _lastInvDate = Value
        End Set
    End Property
    Public Property OrderNo() As String
        Get
            Return _orderNo
        End Get
        Set(ByVal Value As String)
            _orderNo = Value
        End Set
    End Property
    Public Property Jobs() As String
        Get
            Return _jobs
        End Get
        Set(ByVal Value As String)
            _jobs = Value
        End Set
    End Property
    Public Property Veh_OwnerName() As String
        Get
            Return _vehOwnerName
        End Get
        Set(ByVal Value As String)
            _vehOwnerName = Value
        End Set
    End Property
    Public Property Dt_Veh_Last_Regn() As String
        Get
            Return _dt_veh_last_regn
        End Get
        Set(ByVal Value As String)
            _dt_veh_last_regn = Value
        End Set
    End Property
    Public Property Veh_Srv_Type() As String
        Get
            Return _veh_srv_type
        End Get
        Set(ByVal Value As String)
            _veh_srv_type = Value
        End Set
    End Property
    Public Property Id_Model_RP() As String
        Get
            Return _id_model_RP
        End Get
        Set(ByVal Value As String)
            _id_model_RP = Value
        End Set
    End Property
    Public Property Veh_Flg_AddOn() As Boolean
        Get
            Return _veh_flg_addon
        End Get
        Set(ByVal Value As Boolean)
            _veh_flg_addon = Value
        End Set
    End Property
    Public Property Id_AddOn_LocDept() As String
        Get
            Return _id_addon_locdept
        End Get
        Set(ByVal Value As String)
            _id_addon_locdept = Value
        End Set
    End Property
    Public Property Id_Vat_Code() As String
        Get
            Return _id_vat_code
        End Get
        Set(ByVal Value As String)
            _id_vat_code = Value
        End Set
    End Property
    Public Property VA_Acc_Code() As String
        Get
            Return _VA_acc_code
        End Get
        Set(ByVal Value As String)
            _VA_acc_code = Value
        End Set
    End Property
    Public Property Pick() As String
        Get
            Return _pick
        End Get
        Set(ByVal Value As String)
            _pick = Value
        End Set
    End Property
    Public Property CompStatus() As String
        Get
            Return _compStatus
        End Get
        Set(ByVal Value As String)
            _compStatus = Value
        End Set
    End Property
    Public Property ClockIn() As String
        Get
            Return _clockIn
        End Get
        Set(ByVal Value As String)
            _clockIn = Value
        End Set
    End Property
    Public Property ClockOut() As String
        Get
            Return _clockOut
        End Get
        Set(ByVal Value As String)
            _clockOut = Value
        End Set
    End Property
    Public Property DefectId() As String
        Get
            Return _defectId
        End Get
        Set(ByVal Value As String)
            _defectId = Value
        End Set
    End Property
    Public Property Status() As String
        Get
            Return _status
        End Get
        Set(ByVal Value As String)
            _status = Value
        End Set
    End Property
    Public Property IsStatus() As String
        Get
            Return _isStatus
        End Get
        Set(ByVal Value As String)
            _isStatus = Value
        End Set
    End Property
    Public Property DefectDesc() As String
        Get
            Return _defectDesc
        End Get
        Set(ByVal Value As String)
            _defectDesc = Value
        End Set
    End Property
    Public Property LoginId() As String
        Get
            Return _loginId
        End Get
        Set(ByVal Value As String)
            _loginId = Value
        End Set
    End Property
    Public Property Tmp_Id_Settings() As String
        Get
            Return _tmp_id_settings
        End Get
        Set(ByVal Value As String)
            _tmp_id_settings = Value
        End Set
    End Property
    Public Property Cust_Company_Description() As String
        Get
            Return _cust_company_description
        End Get
        Set(ByVal Value As String)
            _cust_company_description = Value
        End Set
    End Property
    Public Property Cust_Company_No() As String
        Get
            Return _cust_company_no
        End Get
        Set(ByVal Value As String)
            _cust_company_no = Value
        End Set
    End Property
    Public Property Flg_Private_Comp() As Boolean
        Get
            Return _flg_private_comp
        End Get
        Set(ByVal Value As Boolean)
            _flg_private_comp = Value
        End Set
    End Property
    Public Property Cust_Last_Name() As String
        Get
            Return _cust_last_name
        End Get
        Set(ByVal Value As String)
            _cust_last_name = Value
        End Set
    End Property
    Public Property Cust_Disc_General() As String
        Get
            Return _cust_disc_general
        End Get
        Set(ByVal Value As String)
            _cust_disc_general = Value
        End Set
    End Property
    Public Property Cust_Disc_Labour() As String
        Get
            Return _cust_disc_labour
        End Get
        Set(ByVal Value As String)
            _cust_disc_labour = Value
        End Set
    End Property
    Public Property Cust_Disc_Spares() As String
        Get
            Return _cust_disc_spares
        End Get
        Set(ByVal Value As String)
            _cust_disc_spares = Value
        End Set
    End Property
    Public Property Ref_Wo_No() As String
        Get
            Return _ref_Wo_No
        End Get
        Set(ByVal Value As String)
            _ref_Wo_No = Value
        End Set
    End Property
End Class
