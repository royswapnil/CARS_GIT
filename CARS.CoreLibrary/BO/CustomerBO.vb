Public Class CustomerBO

    'For autocomplete function
    Private _id_cust As String
    Private _id_customer As String
    Private _cust_name As String
    Private _cust_gen_type As String
    Private _id_cust_group As String
    Private _cust_contact_person As String
    Private _id_cust_reg_cd As String
    Private _id_cust_pc_code As String
    Private _id_cust_disc_cd As String
    Private _cust_ssn_no As String
    Private _cust_driv_licno As String
    Private _cust_phone_off As String
    Private _cust_phone_home As String
    Private _cust_phone_mobile As String
    Private _cust_fax As String
    Private _cust_id_email As String
    Private _cust_remarks As String
    Private _cust_perm_add1 As String
    Private _cust_perm_add2 As String
    Private _id_cust_perm_zipcode As String
    Private _cust_bill_add1 As String
    Private _cust_bill_add2 As String
    Private _id_cust_bill_zipcode As String
    Private _cust_account_no As String
    Private _id_cust_pay_type As String
    Private _id_cust_currency As String
    Private _cust_credit_limit As String
    Private _cust_unutil_credit As String
    Private _id_cust_warn As String
    Private _id_cust_pay_term As String
    Private _flg_cust_inactive As String
    Private _flg_cust_adv As String
    Private _flg_cust_factoring As String
    Private _flg_cust_batchinv As String
    Private _flg_cust_nocredit As String
    Private _created_by As String
    Private _dt_created As String
    Private _modified_by As String
    Private _dt_modified As String
    Private _cust_balance As String
    Private _issameaddress As String
    Private _isexported As String
    Private _cust_hourlyprice As String
    Private _flg_costprice As String
    Private _costprice As String
    Private _cust_garagemat As String
    Private _cust_sub As String
    Private _cust_dep As String
    Private _flg_cust_ignoreinv As String
    Private _flg_inv_email As String
    Private _cust_inv_email As String
    Private _cust_first_name As String
    Private _cust_middle_name As String
    Private _cust_last_name As String
    Private _cust_county As String
    Private _cust_country As String
    Private _cust_visit_address As String
    Private _cust_mail_address As String
    Private _cust_phone_alt As String
    Private _cust_homepage As String
    Private _flg_einvoice As String
    Private _flg_ordconf_email As String
    Private _flg_no_sms As String
    Private _flg_no_marketing As String
    Private _flg_no_humaneorg As String
    Private _flg_no_phonesale As String
    Private _flg_private_comp As String
    Private _flg_no_email As String
    Private _cust_born As String
    Private _eniro_id As String
    Private _phone_type As String
    Private _id_cust_group_desc As String
    Private _cust_perm_city As String
    Private _cust_bill_city As String
    Private _flg_no_gm As String
    Private _flg_no_env_fee As String
    Private _flg_prospect As String
    Private _cust_notes As String
    Private _branch_code As String
    Private _branch_text As String
    Private _branch_note As String
    Private _branch_annot As String
    Private _category_code As String
    Private _category_text As String
    Private _category_annot As String
    Private _salesgroup_code As String
    Private _salesgroup_text As String
    Private _salesgroup_investment As String
    Private _salesgroup_vat As String
    Private _user_login As String
    Private _user_first_name As String
    Private _user_last_name As String
    Private _user_department As String
    Private _user_password As String
    Private _user_phone As String
    Private _payment_terms_code As String
    Private _payment_terms_text As String
    Private _payment_terms_days As String
    Private _card_type_code As String
    Private _card_type_text As String
    Private _card_type_custno As String
    Private _currency_type_code As String
    Private _currency_type_text As String
    Private _currency_type_rate As String
    Private _cust_disc_general As String
    Private _cust_disc_labour As String
    Private _cust_disc_spares As String
    Private _contact_type As Int32
    Private _contact_description As String
    Private _contact_standard As Boolean
    Private _id_settings As String
    Private _description As String
    Private _cust_company_no As String
    Private _cust_company_desc As String
    Private _id_cp As String

    Public Property BRANCH_CODE() As String
        Get
            Return _branch_code
        End Get
        Set(ByVal value As String)
            _branch_code = value
        End Set
    End Property

    Public Property BRANCH_TEXT() As String
        Get
            Return _branch_text
        End Get
        Set(ByVal value As String)
            _branch_text = value
        End Set
    End Property

    Public Property BRANCH_NOTE() As String
        Get
            Return _branch_note
        End Get
        Set(ByVal value As String)
            _branch_note = value
        End Set
    End Property

    Public Property BRANCH_ANNOT() As String
        Get
            Return _branch_annot
        End Get
        Set(ByVal value As String)
            _branch_annot = value
        End Set
    End Property

    Public Property CATEGORY_CODE() As String
        Get
            Return _category_code
        End Get
        Set(ByVal value As String)
            _category_code = value
        End Set
    End Property

    Public Property CATEGORY_TEXT() As String
        Get
            Return _category_text
        End Get
        Set(ByVal value As String)
            _category_text = value
        End Set
    End Property

    Public Property CATEGORY_ANNOT() As String
        Get
            Return _category_annot
        End Get
        Set(ByVal value As String)
            _category_annot = value
        End Set
    End Property

    Public Property SALESGROUP_CODE() As String
        Get
            Return _salesgroup_code
        End Get
        Set(ByVal value As String)
            _salesgroup_code = value
        End Set
    End Property
    Public Property SALESGROUP_TEXT() As String
        Get
            Return _salesgroup_text
        End Get
        Set(ByVal value As String)
            _salesgroup_text = value
        End Set
    End Property
    Public Property SALESGROUP_INVESTMENT() As String
        Get
            Return _salesgroup_investment
        End Get
        Set(ByVal value As String)
            _salesgroup_investment = value
        End Set
    End Property
    Public Property SALESGROUP_VAT() As String
        Get
            Return _salesgroup_vat
        End Get
        Set(ByVal value As String)
            _salesgroup_vat = value
        End Set
    End Property

    Public Property CUST_PERM_CITY() As String
        Get
            Return _cust_perm_city
        End Get
        Set(ByVal value As String)
            _cust_perm_city = value
        End Set
    End Property

    Public Property CUST_BILL_CITY() As String
        Get
            Return _cust_bill_city
        End Get
        Set(ByVal value As String)
            _cust_bill_city = value
        End Set
    End Property

    Public Property ID_CUST() As String
        Get
            Return _id_cust
        End Get
        Set(ByVal value As String)
            _id_cust = value
        End Set
    End Property
    Public Property ID_CUSTOMER() As String
        Get
            Return _id_customer
        End Get
        Set(ByVal value As String)
            _id_customer = value
        End Set
    End Property
    Public Property CUST_NAME() As String
        Get
            Return _cust_name
        End Get
        Set(ByVal value As String)
            _cust_name = value
        End Set
    End Property
    Public Property CUST_GEN_TYPE() As String
        Get
            Return _cust_gen_type
        End Get
        Set(ByVal value As String)
            _cust_gen_type = value
        End Set
    End Property
    Public Property ID_CUST_GROUP() As String
        Get
            Return _id_cust_group
        End Get
        Set(ByVal value As String)
            _id_cust_group = value
        End Set
    End Property
    Public Property CUST_CONTACT_PERSON() As String
        Get
            Return _cust_contact_person
        End Get
        Set(ByVal value As String)
            _cust_contact_person = value
        End Set
    End Property
    Public Property ID_CUST_REG_CD() As String
        Get
            Return _id_cust_reg_cd
        End Get
        Set(ByVal value As String)
            _id_cust_reg_cd = value
        End Set
    End Property
    Public Property ID_CUST_PC_CODE() As String
        Get
            Return _id_cust_pc_code
        End Get
        Set(ByVal value As String)
            _id_cust_pc_code = value
        End Set
    End Property
    Public Property ID_CUST_DISC_CD() As String
        Get
            Return _id_cust_disc_cd
        End Get
        Set(ByVal value As String)
            _id_cust_disc_cd = value
        End Set
    End Property
    Public Property CUST_SSN_NO() As String
        Get
            Return _cust_ssn_no
        End Get
        Set(ByVal value As String)
            _cust_ssn_no = value
        End Set
    End Property
    Public Property CUST_DRIV_LICNO() As String
        Get
            Return _cust_driv_licno
        End Get
        Set(ByVal value As String)
            _cust_driv_licno = value
        End Set
    End Property
    Public Property CUST_PHONE_OFF() As String
        Get
            Return _cust_phone_off
        End Get
        Set(ByVal value As String)
            _cust_phone_off = value
        End Set
    End Property
    Public Property CUST_PHONE_HOME() As String
        Get
            Return _cust_phone_home
        End Get
        Set(ByVal value As String)
            _cust_phone_home = value
        End Set
    End Property
    Public Property CUST_PHONE_MOBILE() As String
        Get
            Return _cust_phone_mobile
        End Get
        Set(ByVal value As String)
            _cust_phone_mobile = value
        End Set
    End Property
    Public Property CUST_FAX() As String
        Get
            Return _cust_fax
        End Get
        Set(ByVal value As String)
            _cust_fax = value
        End Set
    End Property
    Public Property CUST_ID_EMAIL() As String
        Get
            Return _cust_id_email
        End Get
        Set(ByVal value As String)
            _cust_id_email = value
        End Set
    End Property
    Public Property CUST_REMARKS() As String
        Get
            Return _cust_remarks
        End Get
        Set(ByVal value As String)
            _cust_remarks = value
        End Set
    End Property
    Public Property CUST_PERM_ADD1() As String
        Get
            Return _cust_perm_add1
        End Get
        Set(ByVal value As String)
            _cust_perm_add1 = value
        End Set
    End Property
    Public Property CUST_PERM_ADD2() As String
        Get
            Return _cust_perm_add2
        End Get
        Set(ByVal value As String)
            _cust_perm_add2 = value
        End Set
    End Property
    Public Property ID_CUST_PERM_ZIPCODE() As String
        Get
            Return _id_cust_perm_zipcode
        End Get
        Set(ByVal value As String)
            _id_cust_perm_zipcode = value
        End Set
    End Property
    Public Property CUST_BILL_ADD1() As String
        Get
            Return _cust_bill_add1
        End Get
        Set(ByVal value As String)
            _cust_bill_add1 = value
        End Set
    End Property
    Public Property CUST_BILL_ADD2() As String
        Get
            Return _cust_bill_add2
        End Get
        Set(ByVal value As String)
            _cust_bill_add2 = value
        End Set
    End Property
    Public Property ID_CUST_BILL_ZIPCODE() As String
        Get
            Return _id_cust_bill_zipcode
        End Get
        Set(ByVal value As String)
            _id_cust_bill_zipcode = value
        End Set
    End Property
    Public Property CUST_ACCOUNT_NO() As String
        Get
            Return _cust_account_no
        End Get
        Set(ByVal value As String)
            _cust_account_no = value
        End Set
    End Property
    Public Property ID_CUST_PAY_TYPE() As String
        Get
            Return _id_cust_pay_type
        End Get
        Set(ByVal value As String)
            _id_cust_pay_type = value
        End Set
    End Property
    Public Property ID_CUST_CURRENCY() As String
        Get
            Return _id_cust_currency
        End Get
        Set(ByVal value As String)
            _id_cust_currency = value
        End Set
    End Property
    Public Property CUST_CREDIT_LIMIT() As String
        Get
            Return _cust_credit_limit
        End Get
        Set(ByVal value As String)
            _cust_credit_limit = value
        End Set
    End Property
    Public Property CUST_UNUTIL_CREDIT() As String
        Get
            Return _cust_unutil_credit
        End Get
        Set(ByVal value As String)
            _cust_unutil_credit = value
        End Set
    End Property
    Public Property ID_CUST_WARN() As String
        Get
            Return _id_cust_warn
        End Get
        Set(ByVal value As String)
            _id_cust_warn = value
        End Set
    End Property
    Public Property ID_CUST_PAY_TERM() As String
        Get
            Return _id_cust_pay_term
        End Get
        Set(ByVal value As String)
            _id_cust_pay_term = value
        End Set
    End Property
    Public Property FLG_CUST_INACTIVE() As String
        Get
            Return _flg_cust_inactive
        End Get
        Set(ByVal value As String)
            _flg_cust_inactive = value
        End Set
    End Property
    Public Property FLG_CUST_ADV() As String
        Get
            Return _flg_cust_adv
        End Get
        Set(ByVal value As String)
            _flg_cust_adv = value
        End Set
    End Property
    Public Property FLG_CUST_FACTORING() As String
        Get
            Return _flg_cust_factoring
        End Get
        Set(ByVal value As String)
            _flg_cust_factoring = value
        End Set
    End Property
    Public Property FLG_CUST_BATCHINV() As String
        Get
            Return _flg_cust_batchinv
        End Get
        Set(ByVal value As String)
            _flg_cust_batchinv = value
        End Set
    End Property
    Public Property FLG_CUST_NOCREDIT() As String
        Get
            Return _flg_cust_nocredit
        End Get
        Set(ByVal value As String)
            _flg_cust_nocredit = value
        End Set
    End Property
    Public Property CREATED_BY() As String
        Get
            Return _created_by
        End Get
        Set(ByVal value As String)
            _created_by = value
        End Set
    End Property
    Public Property DT_CREATED() As String
        Get
            Return _dt_created
        End Get
        Set(ByVal value As String)
            _dt_created = value
        End Set
    End Property
    Public Property MODIFIED_BY() As String
        Get
            Return _modified_by
        End Get
        Set(ByVal value As String)
            _modified_by = value
        End Set
    End Property
    Public Property DT_MODIFIED() As String
        Get
            Return _dt_modified
        End Get
        Set(ByVal value As String)
            _dt_modified = value
        End Set
    End Property
    Public Property CUST_BALANCE() As String
        Get
            Return _cust_balance
        End Get
        Set(ByVal value As String)
            _cust_balance = value
        End Set
    End Property
    Public Property ISSAMEADDRESS() As String
        Get
            Return _issameaddress
        End Get
        Set(ByVal value As String)
            _issameaddress = value
        End Set
    End Property
    Public Property ISEXPORTED() As String
        Get
            Return _isexported
        End Get
        Set(ByVal value As String)
            _isexported = value
        End Set
    End Property
    Public Property CUST_HOURLYPRICE() As String
        Get
            Return _cust_hourlyprice
        End Get
        Set(ByVal value As String)
            _cust_hourlyprice = value
        End Set
    End Property
    Public Property FLG_COSTPRICE() As String
        Get
            Return _flg_costprice
        End Get
        Set(ByVal value As String)
            _flg_costprice = value
        End Set
    End Property
    Public Property COSTPRICE() As String
        Get
            Return _costprice
        End Get
        Set(ByVal value As String)
            _costprice = value
        End Set
    End Property
    Public Property CUST_GARAGEMAT() As String
        Get
            Return _cust_garagemat
        End Get
        Set(ByVal value As String)
            _cust_garagemat = value
        End Set
    End Property
    Public Property CUST_SUB() As String
        Get
            Return _cust_sub
        End Get
        Set(ByVal value As String)
            _cust_sub = value
        End Set
    End Property
    Public Property CUST_DEP() As String
        Get
            Return _cust_dep
        End Get
        Set(ByVal value As String)
            _cust_dep = value
        End Set
    End Property
    Public Property FLG_CUST_IGNOREINV() As String
        Get
            Return _flg_cust_ignoreinv
        End Get
        Set(ByVal value As String)
            _flg_cust_ignoreinv = value
        End Set
    End Property
    Public Property FLG_INV_EMAIL() As String
        Get
            Return _flg_inv_email
        End Get
        Set(ByVal value As String)
            _flg_inv_email = value
        End Set
    End Property
    Public Property CUST_INV_EMAIL() As String
        Get
            Return _cust_inv_email
        End Get
        Set(ByVal value As String)
            _cust_inv_email = value
        End Set
    End Property
    Public Property CUST_FIRST_NAME() As String
        Get
            Return _cust_first_name
        End Get
        Set(ByVal value As String)
            _cust_first_name = value
        End Set
    End Property
    Public Property CUST_MIDDLE_NAME() As String
        Get
            Return _cust_middle_name
        End Get
        Set(ByVal value As String)
            _cust_middle_name = value
        End Set
    End Property
    Public Property CUST_LAST_NAME() As String
        Get
            Return _cust_last_name
        End Get
        Set(ByVal value As String)
            _cust_last_name = value
        End Set
    End Property
    Public Property CUST_COUNTY() As String
        Get
            Return _cust_county
        End Get
        Set(ByVal value As String)
            _cust_county = value
        End Set
    End Property
    Public Property CUST_COUNTRY() As String
        Get
            Return _cust_country
        End Get
        Set(ByVal value As String)
            _cust_country = value
        End Set
    End Property
    Public Property CUST_VISIT_ADDRESS() As String
        Get
            Return _cust_visit_address
        End Get
        Set(ByVal value As String)
            _cust_visit_address = value
        End Set
    End Property
    Public Property CUST_MAIL_ADDRESS() As String
        Get
            Return _cust_mail_address
        End Get
        Set(ByVal value As String)
            _cust_mail_address = value
        End Set
    End Property
    Public Property CUST_PHONE_ALT() As String
        Get
            Return _cust_phone_alt
        End Get
        Set(ByVal value As String)
            _cust_phone_alt = value
        End Set
    End Property
    Public Property CUST_HOMEPAGE() As String
        Get
            Return _cust_homepage
        End Get
        Set(ByVal value As String)
            _cust_homepage = value
        End Set
    End Property
    Public Property FLG_EINVOICE() As String
        Get
            Return _flg_einvoice
        End Get
        Set(ByVal value As String)
            _flg_einvoice = value
        End Set
    End Property
    Public Property FLG_ORDCONF_EMAIL() As String
        Get
            Return _flg_ordconf_email
        End Get
        Set(ByVal value As String)
            _flg_ordconf_email = value
        End Set
    End Property
    Public Property FLG_NO_SMS() As String
        Get
            Return _flg_no_sms
        End Get
        Set(ByVal value As String)
            _flg_no_sms = value
        End Set
    End Property
    Public Property FLG_NO_MARKETING() As String
        Get
            Return _flg_no_marketing
        End Get
        Set(ByVal value As String)
            _flg_no_marketing = value
        End Set
    End Property
    Public Property FLG_NO_HUMANEORG() As String
        Get
            Return _flg_no_humaneorg
        End Get
        Set(ByVal value As String)
            _flg_no_humaneorg = value
        End Set
    End Property
    Public Property FLG_NO_PHONESALE() As String
        Get
            Return _flg_no_phonesale
        End Get
        Set(ByVal value As String)
            _flg_no_phonesale = value
        End Set
    End Property
    Public Property FLG_PRIVATE_COMP() As String
        Get
            Return _flg_private_comp
        End Get
        Set(ByVal value As String)
            _flg_private_comp = value
        End Set
    End Property
    Public Property FLG_NO_EMAIL() As String
        Get
            Return _flg_no_email
        End Get
        Set(ByVal value As String)
            _flg_no_email = value
        End Set
    End Property
    Public Property CUST_BORN() As String
        Get
            Return _cust_born
        End Get
        Set(ByVal value As String)
            _cust_born = value
        End Set
    End Property
    Public Property ENIRO_ID() As String
        Get
            Return _eniro_id
        End Get
        Set(ByVal value As String)
            _eniro_id = value
        End Set
    End Property
    Public Property PHONE_TYPE() As String
        Get
            Return _phone_type
        End Get
        Set(ByVal value As String)
            _phone_type = value
        End Set
    End Property

    Public Property ID_CUST_GROUP_DESC() As String
        Get
            Return _id_cust_group_desc
        End Get
        Set(ByVal value As String)
            _id_cust_group_desc = value
        End Set
    End Property

    Public Property FLG_NO_GM() As String
        Get
            Return _flg_no_gm
        End Get
        Set(ByVal value As String)
            _FLG_NO_GM = value
        End Set
    End Property
    Public Property FLG_NO_ENV_FEE() As String
        Get
            Return _flg_no_env_fee
        End Get
        Set(ByVal value As String)
            _flg_no_env_fee = value
        End Set
    End Property
    Public Property FLG_PROSPECT() As String
        Get
            Return _flg_prospect
        End Get
        Set(ByVal value As String)
            _flg_prospect = value
        End Set
    End Property
    Public Property CUST_NOTES() As String
        Get
            Return _cust_notes
        End Get
        Set(ByVal value As String)
            _cust_notes = value
        End Set
    End Property
    Public Property USER_LOGIN() As String
        Get
            Return _user_login
        End Get
        Set(ByVal value As String)
            _user_login = value
        End Set
    End Property
    Public Property USER_FIRST_NAME() As String
        Get
            Return _user_first_name
        End Get
        Set(ByVal value As String)
            _user_first_name = value
        End Set
    End Property
    Public Property USER_LAST_NAME() As String
        Get
            Return _user_last_name
        End Get
        Set(ByVal value As String)
            _user_last_name = value
        End Set
    End Property
    Public Property USER_DEPARTMENT() As String
        Get
            Return _user_department
        End Get
        Set(ByVal value As String)
            _user_department = value
        End Set
    End Property

    Public Property USER_PASSWORD() As String
        Get
            Return _user_password
        End Get
        Set(ByVal value As String)
            _user_password = value
        End Set
    End Property

    Public Property USER_PHONE() As String
        Get
            Return _user_phone
        End Get
        Set(ByVal value As String)
            _user_phone = value
        End Set
    End Property

    Public Property PAYMENT_TERMS_CODE() As String
        Get
            Return _payment_terms_code
        End Get
        Set(ByVal value As String)
            _payment_terms_code = value
        End Set
    End Property
    Public Property PAYMENT_TERMS_TEXT() As String
        Get
            Return _payment_terms_text
        End Get
        Set(ByVal value As String)
            _payment_terms_text = value
        End Set
    End Property
    Public Property PAYMENT_TERMS_DAYS() As String
        Get
            Return _payment_terms_days
        End Get
        Set(ByVal value As String)
            _payment_terms_days = value
        End Set
    End Property

    Public Property CARD_TYPE_CODE() As String
        Get
            Return _card_type_code
        End Get
        Set(ByVal value As String)
            _card_type_code = value
        End Set
    End Property
    Public Property CARD_TYPE_TEXT() As String
        Get
            Return _card_type_text
        End Get
        Set(ByVal value As String)
            _card_type_text = value
        End Set
    End Property
    Public Property CARD_TYPE_CUSTNO() As String
        Get
            Return _card_type_custno
        End Get
        Set(ByVal value As String)
            _card_type_custno = value
        End Set
    End Property

    Public Property CURRENCY_TYPE_CODE() As String
        Get
            Return _currency_type_code
        End Get
        Set(ByVal value As String)
            _currency_type_code = value
        End Set
    End Property
    Public Property CURRENCY_TYPE_TEXT() As String
        Get
            Return _currency_type_text
        End Get
        Set(ByVal value As String)
            _currency_type_text = value
        End Set
    End Property
    Public Property CURRENCY_TYPE_RATE() As String
        Get
            Return _currency_type_rate
        End Get
        Set(ByVal value As String)
            _currency_type_rate = value
        End Set
    End Property
    Public Property CUST_DISC_GENERAL() As String
        Get
            Return _cust_disc_general
        End Get
        Set(ByVal value As String)
            _cust_disc_general = value
        End Set
    End Property
    Public Property CUST_DISC_LABOUR() As String
        Get
            Return _cust_disc_labour
        End Get
        Set(ByVal value As String)
            _cust_disc_labour = value
        End Set
    End Property
    Public Property CUST_DISC_SPARES() As String
        Get
            Return _cust_disc_spares
        End Get
        Set(ByVal value As String)
            _cust_disc_spares = value
        End Set
    End Property

    Public Property CONTACT_TYPE() As Int32
        Get
            Return _contact_type
        End Get
        Set(ByVal value As Int32)
            _contact_type = value
        End Set
    End Property
    Public Property CONTACT_DESCRIPTION() As String
        Get
            Return _contact_description
        End Get
        Set(ByVal value As String)
            _contact_description = value
        End Set
    End Property
    Public Property CONTACT_STANDARD() As Boolean
        Get
            Return _contact_standard
        End Get
        Set(ByVal value As Boolean)
            _contact_standard = value
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

    Public Property CUST_COMPANY_NO() As String
        Get
            Return _cust_company_no
        End Get
        Set(ByVal Value As String)
            _cust_company_no = Value
        End Set
    End Property

    Public Property CUST_COMPANY_DESCRIPTION() As String
        Get
            Return _cust_company_desc
        End Get
        Set(ByVal Value As String)
            _cust_company_desc = Value
        End Set
    End Property
    Public Property ID_CP() As String
        Get
            Return _id_cp
        End Get
        Set(ByVal Value As String)
            _id_cp = Value
        End Set
    End Property

    'For Eniro fetch function
    Class Result
        Property listing As Listing
    End Class
    Class Listing
        Property table As String
        Property id As String
        Property idlinje As String
        Property duplicates As Duplicate()
    End Class
    Class Duplicate
        Property table As String
        Property id As String
        Property idlinje As String
        Property tlfnr As String
        Property etternavn As String
        Property fornavn As String
        Property veinavn As String
        Property husnr As String
        Property postnr As String
        Property virkkode As String
        Property apparattype As String
        Property telco As String
        Property kilde As String
        Property bkdata As String
        Property prioritet As String
        Property fodselsdato As String
        Property kommunenr As String
        Property poststed As String
        Property kommune As String
        Property fylke As String
        Property landsdel As String
        Property foretaksnr As String
    End Class
    Public Class InstitusjonellSektorkode
        Public Property kode As String
        Public Property beskrivelse As String
    End Class

    Public Class Naeringskode1
        Public Property kode As String
        Public Property beskrivelse As String
    End Class

    Public Class Postadresse
        Public Property adresse As String
        Public Property postnummer As String
        Public Property poststed As String
        Public Property kommunenummer As String
        Public Property kommune As String
        Public Property landkode As String
        Public Property land As String
    End Class

    Public Class Forretningsadresse
        Public Property adresse As String
        Public Property postnummer As String
        Public Property poststed As String
        Public Property kommunenummer As String
        Public Property kommune As String
        Public Property landkode As String
        Public Property land As String
    End Class

    Public Class Link
        Public Property rel As String
        Public Property href As String
    End Class

    Public Class Brregdata
        Public Property organisasjonsnummer As Integer
        Public Property navn As String
        Public Property registreringsdatoEnhetsregisteret As String
        Public Property organisasjonsform As String
        Public Property hjemmeside As String
        Public Property registrertIFrivillighetsregisteret As String
        Public Property registrertIMvaregisteret As String
        Public Property registrertIForetaksregisteret As String
        Public Property registrertIStiftelsesregisteret As String
        Public Property antallAnsatte As Integer
        Public Property institusjonellSektorkode As InstitusjonellSektorkode
        Public Property naeringskode1 As Naeringskode1
        Public Property postadresse As Postadresse
        Public Property forretningsadresse As Forretningsadresse
        Public Property konkurs As String
        Public Property underAvvikling As String
        Public Property underTvangsavviklingEllerTvangsopplosning As String
        Public Property overordnetEnhet As Integer
        Public Property links As Link()
    End Class
    Public Class ContactInformation
        Public Property id As Integer
        Public Property type As Integer
        Public Property description As String
        Public Property value As String
        Public Property standard As Boolean
    End Class

    Public Class ContactPerson
        Public Property ID_CP As String
        Public Property CP_CUSTOMER_ID As String
        Public Property CP_FIRST_NAME As String
        Public Property CP_MIDDLE_NAME As String
        Public Property CP_LAST_NAME As String
        Public Property CP_PERM_ADD As String
        Public Property CP_VISIT_ADD As String
        Public Property CP_ZIP_CODE As String
        Public Property CP_ZIP_CITY As String
        Public Property CP_EMAIL As String
        Public Property CP_PHONE_PRIVATE As String
        Public Property CP_PHONE_MOBILE As String
        Public Property CP_PHONE_FAX As String
        Public Property CP_PHONE_WORK As String
        Public Property CP_BIRTH_DATE As String
        Public Property CP_TITLE_CODE As String
        Public Property CP_FUNCTION_CODE As String
        Public Property CP_CONTACT As String
        Public Property CP_CAR_USER As String
        Public Property CP_EMAIL_REF As String
        Public Property CP_NOTES As String
        Public Property CUSTOMER_CONTACT_PERSON As String
    End Class
    Public Class ContactPersonTitle
        Public Property ID_CP_TITLE As String
        Public Property TITLE_CODE As String
        Public Property TITLE_DESCRIPTION As String
    End Class
    Public Class ContactPersonFunction
        Public Property ID_CP_FUNCTION As String
        Public Property FUNCTION_CODE As String
        Public Property FUNCTION_DESCRIPTION As String
    End Class
End Class
