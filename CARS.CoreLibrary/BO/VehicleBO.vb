Public Class VehicleBO
    Private _vehRegNo As String
    Private _vehVin As String
    Private _regDateNorway As String
    Private _id_Make As String
    Private _make_Name As String
    Private _modelName As String
    Private _vehType As String
    Private _approvalNo As String
    Private _vehGrp As String
    Private _color As String
    Private _fuelType As String
    Private _deRegDate As String
    Private _engEff As Integer
    Private _pisDsplcment As String
    Private _width As Integer
    Private _length As Integer
    Private _stdTFront As String
    Private _minLiFront As String
    Private _minFront As String
    Private _stdRimFront As String
    Private _minInpressFront As String
    Private _maxTireFront As String
    Private _minLiBack As String
    Private _minBack As String
    Private _stdRimBack As String
    Private _minInpressBack As String
    Private _maxTireBack As String
    Private _totalWt As String
    Private _netWt As String
    Private _alPrFrnt As String
    Private _alPrBack As String
    Private _stdTyBck As String
    Private _status As String
    Private _mxWtTBar As String
    Private _lenTBar As String
    Private _maxRfLd As String
    Private _engNum As String
    Private _nxtPKKDate As String
    Private _lastPkkAppDate As String
    Private _seatVeh As String
    Private _certText As String
    Private _co2Emmsn As String
    Private _euVariant As String
    Private _euVersion As String
    Private _gearBxDesc As String
    Private _chassiDesc As String
    Private _traWdBrks As String
    Private _traWdOutBrks As String
    Private _axlNums As String
    Private _axlNumsTraction As String
    Private _noiseVeh As String
    Private _rounds As String
    Private _euMainNum As String
    Private _euNorm As String
    Private _idtyAnnot As String
    Private _wheelsWthTrac As String
    Private _makePartFilter As String
    Private _makeCode As String
    Private _makeCodeNo As String
    Private _vehicleType As String

    Private _vehStatus As String
    Private _annotation As String
    Private _regDate As String
    Private _regDateNo As String
    Private _lastRegDate As String
    Private _mileage As Integer
    Private _mileageRegDt As String
    Private _vehicleHrs As Decimal
    Private _vehicleHrsDt As String
    Private _createdBy As String
    Private _pickNo As String
    Private _vanNo As String
    Private _modelType As String
    Private _regYear As Integer
    Private _category As String
    Private _machine_W_Hrs As Boolean
    Private _warranty_code As String
    Private _proj_No As String
    Private _last_Contact_Date As String
    Private _practical_load As String

    'Private _max_roof_load As String

    Private _earlier_regno_1 As String
    Private _earlier_regno_2 As String
    Private _earlier_regno_3 As String
    Private _earlier_regno_4 As String
    Private _note As String
    Private _refNo As String
    Private _modelYear As Integer
    Private _type As String
    Private _id_customer_veh As String
    Private _veh_flg_service_plan As String
    Private _annot As String
    Private _cost_price As String
    Private _sell_price As String

    'For the vehicle autocomplete function
    Private _id_search As String
    Private _regno As String
    Private _intno As String
    Private _chassi As String
    Private _make As String
    Private _model As String
    Private _customer As String
    Private _idSettings As String
    Private _description As String
    Private _id_model As String

    'Fetch and update vehicle
    Private _id_veh_seq As String
    Private _id_make_veh As String
    Private _id_model_veh As String
    Private _id_group_veh As String
    Private _new_used As String
    Private _veh_status As String
    'For warranty code box
    Private _warrantyCode As String
    Private _warrantyDesc As String
    Private _customerName As String

    'Tech tab
    Private _ricambiNo As String
    Private _fuelCode As String
    Private _fuelCard As String
    Private _wareHouse As String
    Private _keyNo As String
    Private _doorKeyNo As String
    Private _controlForm As String
    Private _interiorCode As String
    Private _purchaseNo As String
    Private _addonGroup As String
    Private _date_Expected_In As String
    Private _tires As String
    Private _service_Category As String
    Private _no_Approval_No As String
    Private _eu_Approval_No As String
    Private _productNo As String
    Private _elCode As String
    Private _taken_In_Date As String
    Private _taken_In_Mileage As Integer
    Private _delivery_Date As String
    Private _delivery_Mileage As Integer
    Private _service_Date As String
    Private _service_Mileage As Integer
    Private _call_In_Date As String
    Private _call_In_Mileage As Integer
    Private _cleaned_Date As String
    Private _techDocNo As String
    Private _used_Imported As Boolean
    Private _pressure_Mech_Brakes As Boolean
    Private _towbar As Boolean
    Private _service_Book As Boolean
    Private _last_PKK_Invoiced As String
    Private _call_In_Service As Boolean
    Private _call_In_Month_Service As Integer
    Private _call_In_Mileage_Service As Integer
    Private _do_Not_Call_PKK As Boolean
    Private _deviations_PKK As String
    Private _yearly_Mileage As Integer
    Private _radio_Code As String
    Private _start_Immobilizer As String
    Private _qty_Keys As Integer
    Private _keyTagNo As String
    Private _vatCode As String
    Private _vatDesc As String

    'Economy tab private values
    Private _salesPriceNet As String
    Private _salesSale As String
    Private _salesEquipment As String
    Private _regCosts As String
    Private _discount As String
    Private _netSalesPrice As String
    Private _fixCost As String
    Private _assistSales As String
    Private _costAfterSales As String
    Private _contributionsToday As String
    Private _salesPriceGross As String
    Private _regFee As String
    Private _vat As String
    Private _totAmount As String
    Private _wreckingAmount As String
    Private _yearlyFee As String
    Private _insurance As String
    Private _costPriceNet As String
    Private _insuranceBonus As String
    Private _costSales As String
    Private _costBeforeSale As String
    Private _salesProvision As String
    Private _commitDay As String
    Private _addedInterests As String
    Private _costEquipment As String
    Private _totalCost As String
    Private _creditNoteNo As String
    Private _creditNoteDate As String
    Private _invoiceNo As String
    Private _invoiceDate As String
    Private _rebuyDate As String
    Private _rebuyPrice As String
    Private _costPerKm As String
    Private _turnover As String
    Private _progress As String

    'Trailer TAB fields
    Private _axle1 As String
    Private _axle2 As String
    Private _axle3 As String
    Private _axle4 As String
    Private _axle5 As String
    Private _axle6 As String
    Private _axle7 As String
    Private _axle8 As String
    Private _trailerDesc As String

    'Certificate tab fields
    Private _tireDimFront As String
    Private _tireDimBack As String
    Private _minSpeedFront As String
    Private _minSpeedBack As String
    Private _maxTrackFront As String
    Private _maxTrackBack As String
    Private _axlePressureFront As String
    Private _axlePressureBack As String
    Private _qtyAxles As String
    Private _operativeAxles As String
    Private _driveWheel As String
    Private _maxRoofLoad As String
    Private _trailerWithBrakes As String
    Private _trailerWeight As String
    Private _maxLoadTowbar As String
    Private _lengthToTowbar As String
    Private _totalTrailerWeight As String
    Private _seats As String
    Private _validFrom As String
    Private _euronorm As String
    Private _co2Emission As String
    Private _makeParticleFilter As String
    Private _chassiText As String
    Private _identity As String
    Private _certificate As String
    Private _certificateAnnotation As String

    Private _statusCode As String
    Private _statusDesc As String
    Private _refno_Code As String
    Private _refno_Description As String
    Private _refno_Prefix As String
    Private _refno_Count As Integer

    Public Property VehRegNo() As String
        Get
            Return _vehRegNo
        End Get
        Set(ByVal value As String)
            _vehRegNo = value
        End Set
    End Property
    Public Property VehVin() As String
        Get
            Return _vehVin
        End Get
        Set(ByVal value As String)
            _vehVin = value
        End Set
    End Property
    Public Property Annotation() As String
        Get
            Return _annotation
        End Get
        Set(ByVal Value As String)
            _annotation = Value
        End Set
    End Property
    Public Property RegDateNorway() As String
        Get
            Return _regDateNorway
        End Get
        Set(ByVal value As String)
            _regDateNorway = value
        End Set
    End Property
    Public Property ApprovalNo() As String
        Get
            Return _approvalNo
        End Get
        Set(ByVal value As String)
            _approvalNo = value
        End Set
    End Property
    Public Property VehGrp() As String
        Get
            Return _vehGrp
        End Get
        Set(ByVal value As String)
            _vehGrp = value
        End Set
    End Property
    Public Property Color() As String
        Get
            Return _color
        End Get
        Set(ByVal value As String)
            _color = value
        End Set
    End Property
    Public Property FuelType() As String
        Get
            Return _fuelType
        End Get
        Set(ByVal value As String)
            _fuelType = value
        End Set
    End Property
    Public Property DeRegDate() As String
        Get
            Return _deRegDate
        End Get
        Set(ByVal value As String)
            _deRegDate = value
        End Set
    End Property
    Public Property EngineEff() As Integer
        Get
            Return _engEff
        End Get
        Set(ByVal value As Integer)
            _engEff = value
        End Set
    End Property
    Public Property PisDisplacement() As String
        Get
            Return _pisDsplcment
        End Get
        Set(ByVal value As String)
            _pisDsplcment = value
        End Set
    End Property
    Public Property Width() As Integer
        Get
            Return _width
        End Get
        Set(ByVal value As Integer)
            _width = value
        End Set
    End Property
    Public Property Length() As Integer
        Get
            Return _length
        End Get
        Set(ByVal value As Integer)
            _length = value
        End Set
    End Property
    Public Property StdTyreFront() As String
        Get
            Return _stdTFront
        End Get
        Set(ByVal value As String)
            _stdTFront = value
        End Set
    End Property
    Public Property MinLi_Front() As String
        Get
            Return _minLiFront
        End Get
        Set(ByVal value As String)
            _minLiFront = value
        End Set
    End Property
    Public Property Min_Front() As String
        Get
            Return _minFront
        End Get
        Set(ByVal value As String)
            _minFront = value
        End Set
    End Property
    Public Property Std_Rim_Front() As String
        Get
            Return _stdRimFront
        End Get
        Set(ByVal value As String)
            _stdRimFront = value
        End Set
    End Property
    Public Property Min_Inpress_Front() As String
        Get
            Return _minInpressFront
        End Get
        Set(ByVal value As String)
            _minInpressFront = value
        End Set
    End Property
    Public Property Max_Tyre_Width_Frnt() As String
        Get
            Return _maxTireFront
        End Get
        Set(ByVal value As String)
            _maxTireFront = value
        End Set
    End Property
    Public Property MinLi_Back() As String
        Get
            Return _minLiBack
        End Get
        Set(ByVal value As String)
            _minLiBack = value
        End Set
    End Property
    Public Property Min_Back() As String
        Get
            Return _minBack
        End Get
        Set(ByVal value As String)
            _minBack = value
        End Set
    End Property
    Public Property Min_Inpress_Back() As String
        Get
            Return _minInpressBack
        End Get
        Set(ByVal value As String)
            _minInpressBack = value
        End Set
    End Property
    Public Property Std_Rim_Back() As String
        Get
            Return _stdRimBack
        End Get
        Set(ByVal value As String)
            _stdRimBack = value
        End Set
    End Property

    Public Property Max_Tyre_Width_Bk() As String
        Get
            Return _maxTireBack
        End Get
        Set(ByVal value As String)
            _maxTireBack = value
        End Set
    End Property
    Public Property TotalWeight() As String
        Get
            Return _totalWt
        End Get
        Set(ByVal value As String)
            _totalWt = value
        End Set
    End Property
    Public Property NetWeight() As String
        Get
            Return _netWt
        End Get
        Set(ByVal value As String)
            _netWt = value
        End Set
    End Property
    Public Property AxlePrFront() As String
        Get
            Return _alPrFrnt
        End Get
        Set(ByVal value As String)
            _alPrFrnt = value
        End Set
    End Property
    Public Property AxlePrBack() As String
        Get
            Return _alPrBack
        End Get
        Set(ByVal value As String)
            _alPrBack = value
        End Set
    End Property
    Public Property StdTyreBack() As String
        Get
            Return _stdTyBck
        End Get
        Set(ByVal value As String)
            _stdTyBck = value
        End Set
    End Property
    Public Property Status() As String
        Get
            Return _status
        End Get
        Set(ByVal value As String)
            _status = value
        End Set
    End Property
    Public Property Max_Wt_TBar() As String
        Get
            Return _mxWtTBar
        End Get
        Set(ByVal value As String)
            _mxWtTBar = value
        End Set
    End Property
    Public Property Len_TBar() As String
        Get
            Return _lenTBar
        End Get
        Set(ByVal value As String)
            _lenTBar = value
        End Set
    End Property
    Public Property Max_Rf_Load() As String
        Get
            Return _maxRfLd
        End Get
        Set(ByVal value As String)
            _maxRfLd = value
        End Set
    End Property
    Public Property EngineNum() As String
        Get
            Return _engNum
        End Get
        Set(ByVal value As String)
            _engNum = value
        End Set
    End Property
    Public Property NxtPKK_Date() As String
        Get
            Return _nxtPKKDate
        End Get
        Set(ByVal value As String)
            _nxtPKKDate = value
        End Set
    End Property
    Public Property LastPKK_AppDate() As String
        Get
            Return _lastPkkAppDate
        End Get
        Set(ByVal value As String)
            _lastPkkAppDate = value
        End Set
    End Property
    Public Property Veh_Seat() As String
        Get
            Return _seatVeh
        End Get
        Set(ByVal value As String)
            _seatVeh = value
        End Set
    End Property
    Public Property Cert_Text() As String
        Get
            Return _certText
        End Get
        Set(ByVal value As String)
            _certText = value
        End Set
    End Property
    Public Property CO2_Emission() As String
        Get
            Return _co2Emmsn
        End Get
        Set(ByVal value As String)
            _co2Emmsn = value
        End Set
    End Property
    Public Property EU_Variant() As String
        Get
            Return _euVariant
        End Get
        Set(ByVal value As String)
            _euVariant = value
        End Set
    End Property
    Public Property EU_Version() As String
        Get
            Return _euVersion
        End Get
        Set(ByVal value As String)
            _euVersion = value
        End Set
    End Property
    Public Property GearBox_Desc() As String
        Get
            Return _gearBxDesc
        End Get
        Set(ByVal value As String)
            _gearBxDesc = value
        End Set
    End Property
    Public Property Chassi_Desc() As String
        Get
            Return _chassiDesc
        End Get
        Set(ByVal value As String)
            _chassiDesc = value
        End Set
    End Property
    Public Property TrailerWth_Brks() As String
        Get
            Return _traWdBrks
        End Get
        Set(ByVal value As String)
            _traWdBrks = value
        End Set
    End Property
    Public Property TrailerWthout_Brks() As String
        Get
            Return _traWdOutBrks
        End Get
        Set(ByVal value As String)
            _traWdOutBrks = value
        End Set
    End Property
    Public Property Axles_Number() As String
        Get
            Return _axlNums
        End Get
        Set(ByVal value As String)
            _axlNums = value
        End Set
    End Property
    Public Property Axles_Number_Traction() As String
        Get
            Return _axlNumsTraction
        End Get
        Set(ByVal value As String)
            _axlNumsTraction = value
        End Set
    End Property
    Public Property Noise_On_Veh() As String
        Get
            Return _noiseVeh
        End Get
        Set(ByVal value As String)
            _noiseVeh = value
        End Set
    End Property
    Public Property Rounds() As String
        Get
            Return _rounds
        End Get
        Set(ByVal value As String)
            _rounds = value
        End Set
    End Property
    Public Property EU_Main_Num() As String
        Get
            Return _euMainNum
        End Get
        Set(ByVal value As String)
            _euMainNum = value
        End Set
    End Property
    Public Property EU_Norm() As String
        Get
            Return _euNorm
        End Get
        Set(ByVal value As String)
            _euNorm = value
        End Set
    End Property
    Public Property Identity_Annot() As String
        Get
            Return _idtyAnnot
        End Get
        Set(ByVal value As String)
            _idtyAnnot = value
        End Set
    End Property
    Public Property Wheels_Traction() As String
        Get
            Return _wheelsWthTrac
        End Get
        Set(ByVal value As String)
            _wheelsWthTrac = value
        End Set
    End Property
    Public Property Make_Part_Filter() As String
        Get
            Return _makePartFilter
        End Get
        Set(ByVal value As String)
            _makePartFilter = value
        End Set
    End Property
    Public Property MakeCode() As String
        Get
            Return _makeCode
        End Get
        Set(ByVal value As String)
            _makeCode = value
        End Set
    End Property
    Public Property MakeCodeNo() As String
        Get
            Return _makeCodeNo
        End Get
        Set(ByVal value As String)
            _makeCodeNo = value
        End Set
    End Property
    Public Property VehicleType() As String
        Get
            Return _vehicleType
        End Get
        Set(ByVal value As String)
            _vehicleType = value
        End Set
    End Property
    Public Property IdMake() As String
        Get
            Return _id_Make
        End Get
        Set(ByVal value As String)
            _id_make = value
        End Set
    End Property
    Public Property MakeName() As String
        Get
            Return _make_name
        End Get
        Set(ByVal value As String)
            _make_name = value
        End Set
    End Property
    'For the vehicle autocomplete function
    Public Property Id_Search() As String
        Get
            Return _id_search
        End Get
        Set(ByVal value As String)
            _id_search = value
        End Set
    End Property
    Public Property IntNo() As String
        Get
            Return _intno
        End Get
        Set(ByVal value As String)
            _intno = value
        End Set
    End Property
    Public Property Chassi() As String
        Get
            Return _chassi
        End Get
        Set(ByVal value As String)
            _chassi = value
        End Set
    End Property
    Public Property Make() As String
        Get
            Return _make
        End Get
        Set(ByVal value As String)
            _make = value
        End Set
    End Property
    Public Property Model() As String
        Get
            Return _model
        End Get
        Set(ByVal value As String)
            _model = value
        End Set
    End Property

    Public Property Customer() As String
        Get
            Return _customer
        End Get
        Set(ByVal value As String)
            _customer = value
        End Set
    End Property

    Public Property VehType() As String
        Get
            Return _vehType
        End Get
        Set(ByVal Value As String)
            _vehType = Value
        End Set
    End Property
    Public Property VehStatus() As String
        Get
            Return _vehStatus
        End Get
        Set(ByVal Value As String)
            _vehStatus = Value
        End Set
    End Property
    Public Property RegDate() As String
        Get
            Return _regDate
        End Get
        Set(ByVal Value As String)
            _regDate = Value
        End Set
    End Property
    Public Property RegDateNo() As String
        Get
            Return _regDateNo
        End Get
        Set(ByVal Value As String)
            _regDateNo = Value
        End Set
    End Property
    Public Property LastRegDate() As String
        Get
            Return _lastRegDate
        End Get
        Set(ByVal Value As String)
            _lastRegDate = Value
        End Set
    End Property
    Public Property Mileage() As Integer
        Get
            Return _mileage
        End Get
        Set(ByVal Value As Integer)
            _mileage = Value
        End Set
    End Property
    Public Property MileageRegDate() As String
        Get
            Return _mileageRegDt
        End Get
        Set(ByVal Value As String)
            _mileageRegDt = Value
        End Set
    End Property
    Public Property VehicleHrs() As Decimal
        Get
            Return _vehicleHrs
        End Get
        Set(ByVal Value As Decimal)
            _vehicleHrs = Value
        End Set
    End Property
    Public Property VehicleHrsDate() As String
        Get
            Return _vehicleHrsDt
        End Get
        Set(ByVal Value As String)
            _vehicleHrsDt = Value
        End Set
    End Property
    Public Property CreatedBy() As String
        Get
            Return _createdBy
        End Get
        Set(ByVal Value As String)
            _createdBy = Value
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
    Public Property VanNo() As String
        Get
            Return _vanNo
        End Get
        Set(ByVal Value As String)
            _vanNo = Value
        End Set
    End Property
    Public Property ModelType() As String
        Get
            Return _modelType
        End Get
        Set(ByVal Value As String)
            _modelType = Value
        End Set
    End Property
    Public Property RegYear() As Integer
        Get
            Return _regYear
        End Get
        Set(ByVal Value As Integer)
            _regYear = Value
        End Set
    End Property
    Public Property Category() As String
        Get
            Return _category
        End Get
        Set(ByVal Value As String)
            _category = Value
        End Set
    End Property
    Public Property Machine_W_Hrs() As Boolean
        Get
            Return _machine_W_Hrs
        End Get
        Set(ByVal Value As Boolean)
            _machine_W_Hrs = Value
        End Set
    End Property
    Public Property Warranty_Code() As String
        Get
            Return _warranty_code
        End Get
        Set(ByVal Value As String)
            _warranty_code = Value
        End Set
    End Property
    Public Property Project_No() As String
        Get
            Return _proj_No
        End Get
        Set(ByVal Value As String)
            _proj_No = Value
        End Set
    End Property
    Public Property Last_Contact_Date() As String
        Get
            Return _last_Contact_Date
        End Get
        Set(ByVal Value As String)
            _last_Contact_Date = Value
        End Set
    End Property
    Public Property Practical_Load() As String
        Get
            Return _practical_load
        End Get
        Set(ByVal Value As String)
            _practical_load = Value
        End Set
    End Property
    Public Property Earlier_Regno_1() As String
        Get
            Return _earlier_regno_1
        End Get
        Set(ByVal Value As String)
            _earlier_regno_1 = Value
        End Set
    End Property
    Public Property Earlier_Regno_2() As String
        Get
            Return _earlier_regno_2
        End Get
        Set(ByVal Value As String)
            _earlier_regno_2 = Value
        End Set
    End Property
    Public Property Earlier_Regno_3() As String
        Get
            Return _earlier_regno_3
        End Get
        Set(ByVal Value As String)
            _earlier_regno_3 = Value
        End Set
    End Property
    Public Property Earlier_Regno_4() As String
        Get
            Return _earlier_regno_4
        End Get
        Set(ByVal Value As String)
            _earlier_regno_4 = Value
        End Set
    End Property
    Public Property Note() As String
        Get
            Return _note
        End Get
        Set(ByVal Value As String)
            _note = Value
        End Set
    End Property
    Public Property RefNo() As String
        Get
            Return _refNo
        End Get
        Set(ByVal Value As String)
            _refNo = Value
        End Set
    End Property
    Public Property ModelYear() As Integer
        Get
            Return _modelYear
        End Get
        Set(ByVal Value As Integer)
            _modelYear = Value
        End Set
    End Property
    Public Property Type() As String
        Get
            Return _type
        End Get
        Set(ByVal Value As String)
            _type = Value
        End Set
    End Property
    Public Property Id_Veh_Seq() As String
        Get
            Return _id_veh_seq
        End Get
        Set(ByVal Value As String)
            _id_veh_seq = Value
        End Set
    End Property
    Public Property Id_Make_Veh() As String
        Get
            Return _id_make_veh
        End Get
        Set(ByVal Value As String)
            _id_make_veh = Value
        End Set
    End Property
    Public Property Id_Model_Veh() As String
        Get
            Return _id_model_veh
        End Get
        Set(ByVal Value As String)
            _id_model_veh = Value
        End Set
    End Property
    Public Property Id_Group_Veh() As String
        Get
            Return _id_group_veh
        End Get
        Set(ByVal Value As String)
            _id_group_veh = Value
        End Set
    End Property
    Public Property New_Used() As String
        Get
            Return _new_used
        End Get
        Set(ByVal Value As String)
            _new_used = Value
        End Set
    End Property
    Public Property Veh_Status() As String
        Get
            Return _veh_status
        End Get
        Set(ByVal Value As String)
            _veh_status = Value
        End Set
    End Property
    Public Property WarrantyCodes() As String
        Get
            Return _warrantyCode
        End Get
        Set(ByVal Value As String)
            _warrantyCode = Value
        End Set
    End Property
    Public Property WarrantyDesc() As String
        Get
            Return _warrantyDesc
        End Get
        Set(ByVal Value As String)
            _warrantyDesc = Value
        End Set
    End Property

    Public Property CustomerName() As String
        Get
            Return _customerName
        End Get
        Set(ByVal Value As String)
            _customerName = Value
        End Set
    End Property

    Public Property Id_Customer_Veh() As String
        Get
            Return _id_customer_veh
        End Get
        Set(ByVal Value As String)
            _id_customer_veh = Value
        End Set
    End Property

    Public Property Veh_Flg_Service_Plan() As String
        Get
            Return _veh_flg_service_plan
        End Get
        Set(ByVal Value As String)
            _veh_flg_service_plan = Value
        End Set
    End Property

    Public Property Annot() As String
        Get
            Return _annot
        End Get
        Set(ByVal Value As String)
            _annot = Value
        End Set
    End Property

    Public Property Cost_Price() As String
        Get
            Return _cost_price
        End Get
        Set(ByVal Value As String)
            _cost_price = Value
        End Set
    End Property

    Public Property Sell_Price() As String
        Get
            Return _sell_price
        End Get
        Set(ByVal Value As String)
            _sell_price = Value
        End Set
    End Property

    'tab Technical
    Public Property RicambiNo() As String
        Get
            Return _ricambiNo
        End Get
        Set(ByVal Value As String)
            _ricambiNo = Value
        End Set
    End Property
    Public Property FuelCode() As String
        Get
            Return _fuelCode
        End Get
        Set(ByVal Value As String)
            _fuelCode = Value
        End Set
    End Property
    Public Property FuelCard() As String
        Get
            Return _fuelCard
        End Get
        Set(ByVal Value As String)
            _fuelCard = Value
        End Set
    End Property
    Public Property WareHouse() As String
        Get
            Return _wareHouse
        End Get
        Set(ByVal Value As String)
            _wareHouse = Value
        End Set
    End Property
    Public Property KeyNo() As String
        Get
            Return _keyNo
        End Get
        Set(ByVal Value As String)
            _keyNo = Value
        End Set
    End Property
    Public Property DoorKeyNo() As String
        Get
            Return _doorKeyNo
        End Get
        Set(ByVal Value As String)
            _doorKeyNo = Value
        End Set
    End Property
    Public Property ControlForm() As String
        Get
            Return _controlForm
        End Get
        Set(ByVal Value As String)
            _controlForm = Value
        End Set
    End Property
    Public Property InteriorCode() As String
        Get
            Return _interiorCode
        End Get
        Set(ByVal Value As String)
            _interiorCode = Value
        End Set
    End Property
    Public Property PurchaseNo() As String
        Get
            Return _purchaseNo
        End Get
        Set(ByVal Value As String)
            _purchaseNo = Value
        End Set
    End Property
    Public Property AddonGroup() As String
        Get
            Return _addonGroup
        End Get
        Set(ByVal Value As String)
            _addonGroup = Value
        End Set
    End Property
    Public Property Date_Expected_In() As String
        Get
            Return _date_Expected_In
        End Get
        Set(ByVal Value As String)
            _date_Expected_In = Value
        End Set
    End Property
    Public Property Tires() As String
        Get
            Return _tires
        End Get
        Set(ByVal Value As String)
            _tires = Value
        End Set
    End Property
    Public Property Service_Category() As String
        Get
            Return _service_Category
        End Get
        Set(ByVal Value As String)
            _service_Category = Value
        End Set
    End Property
    Public Property No_Approval_No() As String
        Get
            Return _no_Approval_No
        End Get
        Set(ByVal Value As String)
            _no_Approval_No = Value
        End Set
    End Property
    Public Property Eu_Approval_No() As String
        Get
            Return _eu_Approval_No
        End Get
        Set(ByVal Value As String)
            _eu_Approval_No = Value
        End Set
    End Property
    Public Property ProductNo() As String
        Get
            Return _productNo
        End Get
        Set(ByVal Value As String)
            _productNo = Value
        End Set
    End Property
    Public Property ElCode() As String
        Get
            Return _elCode
        End Get
        Set(ByVal Value As String)
            _elCode = Value
        End Set
    End Property
    Public Property Taken_In_Date() As String
        Get
            Return _taken_In_Date
        End Get
        Set(ByVal Value As String)
            _taken_In_Date = Value
        End Set
    End Property
    Public Property Taken_In_Mileage() As Integer
        Get
            Return _taken_In_Mileage
        End Get
        Set(ByVal Value As Integer)
            _taken_In_Mileage = Value
        End Set
    End Property
    Public Property Delivery_Date() As String
        Get
            Return _delivery_Date
        End Get
        Set(ByVal Value As String)
            _delivery_Date = Value
        End Set
    End Property
    Public Property Delivery_Mileage() As Integer
        Get
            Return _delivery_Mileage
        End Get
        Set(ByVal Value As Integer)
            _delivery_Mileage = Value
        End Set
    End Property
    Public Property Service_Date() As String
        Get
            Return _service_Date
        End Get
        Set(ByVal Value As String)
            _service_Date = Value
        End Set
    End Property
    Public Property Service_Mileage() As Integer
        Get
            Return _service_Mileage
        End Get
        Set(ByVal Value As Integer)
            _service_Mileage = Value
        End Set
    End Property
    Public Property Call_In_Date() As String
        Get
            Return _call_In_Date
        End Get
        Set(ByVal Value As String)
            _call_In_Date = Value
        End Set
    End Property
    Public Property Call_In_Mileage() As Integer
        Get
            Return _call_In_Mileage
        End Get
        Set(ByVal Value As Integer)
            _call_In_Mileage = Value
        End Set
    End Property
    Public Property Cleaned_Date() As String
        Get
            Return _cleaned_Date
        End Get
        Set(ByVal Value As String)
            _cleaned_Date = Value
        End Set
    End Property
    Public Property TechDocNo() As String
        Get
            Return _techDocNo
        End Get
        Set(ByVal Value As String)
            _techDocNo = Value
        End Set
    End Property
    Public Property Used_Imported() As Boolean
        Get
            Return _used_Imported
        End Get
        Set(ByVal Value As Boolean)
            _used_Imported = Value
        End Set
    End Property
    Public Property Pressure_Mech_Brakes() As Boolean
        Get
            Return _pressure_Mech_Brakes
        End Get
        Set(ByVal Value As Boolean)
            _pressure_Mech_Brakes = Value
        End Set
    End Property
    Public Property Towbar() As Boolean
        Get
            Return _towbar
        End Get
        Set(ByVal Value As Boolean)
            _towbar = Value
        End Set
    End Property
    Public Property Service_Book() As Boolean
        Get
            Return _service_Book
        End Get
        Set(ByVal Value As Boolean)
            _service_Book = Value
        End Set
    End Property
    Public Property Last_PKK_Invoiced() As String
        Get
            Return _last_PKK_Invoiced
        End Get
        Set(ByVal Value As String)
            _last_PKK_Invoiced = Value
        End Set
    End Property
    Public Property Call_In_Service() As Boolean
        Get
            Return _call_In_Service
        End Get
        Set(ByVal Value As Boolean)
            _call_In_Service = Value
        End Set
    End Property
    Public Property Call_In_Month_Service() As Integer
        Get
            Return _call_In_Month_Service
        End Get
        Set(ByVal Value As Integer)
            _call_In_Month_Service = Value
        End Set
    End Property
    Public Property Call_In_Mileage_Service() As Integer
        Get
            Return _call_In_Mileage_Service
        End Get
        Set(ByVal Value As Integer)
            _call_In_Mileage_Service = Value
        End Set
    End Property
    Public Property Do_Not_Call_PKK() As Boolean
        Get
            Return _do_Not_Call_PKK
        End Get
        Set(ByVal Value As Boolean)
            _do_Not_Call_PKK = Value
        End Set
    End Property
    Public Property Deviations_PKK() As String
        Get
            Return _deviations_PKK
        End Get
        Set(ByVal Value As String)
            _deviations_PKK = Value
        End Set
    End Property
    Public Property Yearly_Mileage() As Integer
        Get
            Return _yearly_Mileage
        End Get
        Set(ByVal Value As Integer)
            _yearly_Mileage = Value
        End Set
    End Property
    Public Property Radio_Code() As String
        Get
            Return _radio_Code
        End Get
        Set(ByVal Value As String)
            _radio_Code = Value
        End Set
    End Property
    Public Property Start_Immobilizer() As String
        Get
            Return _start_Immobilizer
        End Get
        Set(ByVal Value As String)
            _start_Immobilizer = Value
        End Set
    End Property
    Public Property Qty_Keys() As Integer
        Get
            Return _qty_Keys
        End Get
        Set(ByVal Value As Integer)
            _qty_Keys = Value
        End Set
    End Property
    Public Property KeyTagNo() As String
        Get
            Return _keyTagNo
        End Get
        Set(ByVal Value As String)
            _keyTagNo = Value
        End Set
    End Property



    'tab economy properties
    Public Property SalesPriceNet() As Decimal
        Get
            Return _salesPriceNet
        End Get
        Set(ByVal Value As Decimal)
            _salesPriceNet = Value
        End Set
    End Property
    Public Property SalesSale() As Decimal
        Get
            Return _salesSale
        End Get
        Set(ByVal Value As Decimal)
            _salesSale = Value
        End Set
    End Property
    Public Property SalesEquipment() As Decimal
        Get
            Return _salesEquipment
        End Get
        Set(ByVal Value As Decimal)
            _salesEquipment = Value
        End Set
    End Property
    Public Property RegCosts() As Decimal
        Get
            Return _regCosts
        End Get
        Set(ByVal Value As Decimal)
            _regCosts = Value
        End Set
    End Property
    Public Property Discount() As Int32
        Get
            Return _discount
        End Get
        Set(ByVal Value As Int32)
            _discount = Value
        End Set
    End Property
    Public Property NetSalesPrice() As Decimal
        Get
            Return _netSalesPrice
        End Get
        Set(ByVal Value As Decimal)
            _netSalesPrice = Value
        End Set
    End Property
    Public Property FixCost() As Decimal
        Get
            Return _fixCost
        End Get
        Set(ByVal Value As Decimal)
            _fixCost = Value
        End Set
    End Property
    Public Property AssistSales() As Decimal
        Get
            Return _assistSales
        End Get
        Set(ByVal Value As Decimal)
            _assistSales = Value
        End Set
    End Property
    Public Property CostAfterSales() As Decimal
        Get
            Return _costAfterSales
        End Get
        Set(ByVal Value As Decimal)
            _costAfterSales = Value
        End Set
    End Property
    Public Property ContributionsToday() As Decimal
        Get
            Return _contributionsToday
        End Get
        Set(ByVal Value As Decimal)
            _contributionsToday = Value
        End Set
    End Property
    Public Property SalesPriceGross() As Decimal
        Get
            Return _salesPriceGross
        End Get
        Set(ByVal Value As Decimal)
            _salesPriceGross = Value
        End Set
    End Property
    Public Property RegFee() As Decimal
        Get
            Return _regFee
        End Get
        Set(ByVal Value As Decimal)
            _regFee = Value
        End Set
    End Property
    Public Property Vat() As Decimal
        Get
            Return _vat
        End Get
        Set(ByVal Value As Decimal)
            _vat = Value
        End Set
    End Property
    Public Property TotAmount() As Decimal
        Get
            Return _totAmount
        End Get
        Set(ByVal Value As Decimal)
            _totAmount = Value
        End Set
    End Property
    Public Property WreckingAmount() As Decimal
        Get
            Return _wreckingAmount
        End Get
        Set(ByVal Value As Decimal)
            _wreckingAmount = Value
        End Set
    End Property
    Public Property YearlyFee() As Decimal
        Get
            Return _yearlyFee
        End Get
        Set(ByVal Value As Decimal)
            _yearlyFee = Value
        End Set
    End Property
    Public Property Insurance() As Decimal
        Get
            Return _insurance
        End Get
        Set(ByVal Value As Decimal)
            _insurance = Value
        End Set
    End Property
    Public Property CostPriceNet() As Decimal
        Get
            Return _costPriceNet
        End Get
        Set(ByVal Value As Decimal)
            _costPriceNet = Value
        End Set
    End Property
    Public Property InsuranceBonus() As Int32
        Get
            Return _insuranceBonus
        End Get
        Set(ByVal Value As Int32)
            _insuranceBonus = Value
        End Set
    End Property
    Public Property CostSales() As Decimal
        Get
            Return _costSales
        End Get
        Set(ByVal Value As Decimal)
            _costSales = Value
        End Set
    End Property
    Public Property CostBeforeSale() As Decimal
        Get
            Return _costBeforeSale
        End Get
        Set(ByVal Value As Decimal)
            _costBeforeSale = Value
        End Set
    End Property
    Public Property SalesProvision() As Decimal
        Get
            Return _salesProvision
        End Get
        Set(ByVal Value As Decimal)
            _salesProvision = Value
        End Set
    End Property
    Public Property CommitDay() As Int32
        Get
            Return _commitDay
        End Get
        Set(ByVal Value As Int32)
            _commitDay = Value
        End Set
    End Property
    Public Property AddedInterests() As Decimal
        Get
            Return _addedInterests
        End Get
        Set(ByVal Value As Decimal)
            _addedInterests = Value
        End Set
    End Property
    Public Property CostEquipment() As Decimal
        Get
            Return _costEquipment
        End Get
        Set(ByVal Value As Decimal)
            _costEquipment = Value
        End Set
    End Property
    Public Property TotalCost() As Decimal
        Get
            Return _totalCost
        End Get
        Set(ByVal Value As Decimal)
            _totalCost = Value
        End Set
    End Property

    Public Property CreditNoteNo() As String
        Get
            Return _creditNoteNo
        End Get
        Set(ByVal Value As String)
            _creditNoteNo = Value
        End Set
    End Property
    Public Property CreditNoteDate() As String
        Get
            Return _creditNoteDate
        End Get
        Set(ByVal Value As String)
            _creditNoteDate = Value
        End Set
    End Property
    Public Property InvoiceNo() As String
        Get
            Return _invoiceNo
        End Get
        Set(ByVal Value As String)
            _invoiceNo = Value
        End Set
    End Property
    Public Property InvoiceDate() As String
        Get
            Return _invoiceDate
        End Get
        Set(ByVal Value As String)
            _invoiceDate = Value
        End Set
    End Property
    Public Property RebuyDate() As String
        Get
            Return _rebuyDate
        End Get
        Set(ByVal Value As String)
            _rebuyDate = Value
        End Set
    End Property
    Public Property RebuyPrice() As Decimal
        Get
            Return _rebuyPrice
        End Get
        Set(ByVal Value As Decimal)
            _rebuyPrice = Value
        End Set
    End Property
    Public Property CostPerKm() As Decimal
        Get
            Return _costPerKm
        End Get
        Set(ByVal Value As Decimal)
            _costPerKm = Value
        End Set
    End Property
    Public Property Turnover() As Decimal
        Get
            Return _turnover
        End Get
        Set(ByVal Value As Decimal)
            _turnover = Value
        End Set
    End Property
    Public Property Progress() As Decimal
        Get
            Return _progress
        End Get
        Set(ByVal Value As Decimal)
            _progress = Value
        End Set
    End Property

    Public Property Axle1() As String
        Get
            Return _axle1
        End Get
        Set(ByVal Value As String)
            _axle1 = Value
        End Set
    End Property
    Public Property Axle2() As String
        Get
            Return _axle2
        End Get
        Set(ByVal Value As String)
            _axle2 = Value
        End Set
    End Property
    Public Property Axle3() As String
        Get
            Return _axle3
        End Get
        Set(ByVal Value As String)
            _axle3 = Value
        End Set
    End Property
    Public Property Axle4() As String
        Get
            Return _axle4
        End Get
        Set(ByVal Value As String)
            _axle4 = Value
        End Set
    End Property
    Public Property Axle5() As String
        Get
            Return _axle5
        End Get
        Set(ByVal Value As String)
            _axle5 = Value
        End Set
    End Property
    Public Property Axle6() As String
        Get
            Return _axle6
        End Get
        Set(ByVal Value As String)
            _axle6 = Value
        End Set
    End Property
    Public Property Axle7() As String
        Get
            Return _axle7
        End Get
        Set(ByVal Value As String)
            _axle7 = Value
        End Set
    End Property
    Public Property Axle8() As String
        Get
            Return _axle8
        End Get
        Set(ByVal Value As String)
            _axle8 = Value
        End Set
    End Property
    Public Property TrailerDesc() As String
        Get
            Return _trailerDesc
        End Get
        Set(ByVal Value As String)
            _trailerDesc = Value
        End Set
    End Property

    'certificate tab fields as proprty
    
    Public Property LengthToTowbar() As String
        Get
            Return _lengthToTowbar
        End Get
        Set(ByVal Value As String)
            _lengthToTowbar = Value
        End Set
    End Property
    Public Property TotalTrailerWeight() As String
        Get
            Return _totalTrailerWeight
        End Get
        Set(ByVal Value As String)
            _totalTrailerWeight = Value
        End Set
    End Property
    Public Property Seats() As String
        Get
            Return _seats
        End Get
        Set(ByVal Value As String)
            _seats = Value
        End Set
    End Property
    Public Property ValidFrom() As String
        Get
            Return _validFrom
        End Get
        Set(ByVal Value As String)
            _validFrom = Value
        End Set
    End Property
   
    Public Property StatusCode() As String
        Get
            Return _statusCode
        End Get
        Set(ByVal Value As String)
            _statusCode = Value
        End Set
    End Property
    Public Property StatusDesc() As String
        Get
            Return _statusDesc
        End Get
        Set(ByVal Value As String)
            _statusDesc = Value
        End Set
    End Property
    Public Property RefnoCode() As String
        Get
            Return _refno_Code
        End Get
        Set(ByVal Value As String)
            _refno_Code = Value
        End Set
    End Property
    Public Property RefnoDescription() As String
        Get
            Return _refno_Description
        End Get
        Set(ByVal Value As String)
            _refno_Description = Value
        End Set
    End Property

    Public Property RefnoPrefix() As String
        Get
            Return _refno_Prefix
        End Get
        Set(ByVal Value As String)
            _refno_Prefix = Value
        End Set
    End Property
    Public Property RefnoCount() As String
        Get
            Return _refno_Count
        End Get
        Set(ByVal Value As String)
            _refno_Count = Value
        End Set
    End Property
    Public Property Id_Settings() As String
        Get
            Return _idSettings
        End Get
        Set(ByVal value As String)
            _idSettings = value
        End Set
    End Property
    Public Property Description() As String
        Get
            Return _description
        End Get
        Set(ByVal value As String)
            _description = value
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
            Return _model
        End Get
        Set(ByVal Value As String)
            _model = Value
        End Set
    End Property

    Public Property vatDesc() As String
        Get
            Return _vatDesc
        End Get
        Set(ByVal Value As String)
            _vatDesc = Value
        End Set
    End Property

    Public Property vatCode() As String
        Get
            Return _vatCode
        End Get
        Set(ByVal Value As String)
            _vatCode = Value
        End Set
    End Property

End Class





