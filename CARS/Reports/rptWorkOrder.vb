﻿'------------------------------------------------------------------------------
' <auto-generated>
'     This code was generated by a tool.
'     Runtime Version:4.0.30319.42000
'
'     Changes to this file may cause incorrect behavior and will be lost if
'     the code is regenerated.
' </auto-generated>
'------------------------------------------------------------------------------

Option Strict Off
Option Explicit On

Imports CrystalDecisions.CrystalReports.Engine
Imports CrystalDecisions.ReportSource
Imports CrystalDecisions.Shared
Imports System
Imports System.ComponentModel


Public Class rptWorkOrder
    Inherits ReportClass
    
    Public Sub New()
        MyBase.New
    End Sub
    
    Public Overrides Property ResourceName() As String
        Get
            Return "rptWorkOrder.rpt"
        End Get
        Set
            'Do nothing
        End Set
    End Property
    
    Public Overrides Property NewGenerator() As Boolean
        Get
            Return true
        End Get
        Set
            'Do nothing
        End Set
    End Property
    
    Public Overrides Property FullResourceName() As String
        Get
            Return "CARS.rptWorkOrder.rpt"
        End Get
        Set
            'Do nothing
        End Set
    End Property
    
    <Browsable(false),  _
     DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility.Hidden)>  _
    Public ReadOnly Property Section1() As CrystalDecisions.CrystalReports.Engine.Section
        Get
            Return Me.ReportDefinition.Sections(0)
        End Get
    End Property
    
    <Browsable(false),  _
     DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility.Hidden)>  _
    Public ReadOnly Property Section2() As CrystalDecisions.CrystalReports.Engine.Section
        Get
            Return Me.ReportDefinition.Sections(1)
        End Get
    End Property
    
    <Browsable(false),  _
     DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility.Hidden)>  _
    Public ReadOnly Property PageHeaderSection1() As CrystalDecisions.CrystalReports.Engine.Section
        Get
            Return Me.ReportDefinition.Sections(2)
        End Get
    End Property
    
    <Browsable(false),  _
     DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility.Hidden)>  _
    Public ReadOnly Property PageHeaderSection2() As CrystalDecisions.CrystalReports.Engine.Section
        Get
            Return Me.ReportDefinition.Sections(3)
        End Get
    End Property
    
    <Browsable(false),  _
     DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility.Hidden)>  _
    Public ReadOnly Property PageHeaderSection4() As CrystalDecisions.CrystalReports.Engine.Section
        Get
            Return Me.ReportDefinition.Sections(4)
        End Get
    End Property
    
    <Browsable(false),  _
     DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility.Hidden)>  _
    Public ReadOnly Property PageHeaderSection3() As CrystalDecisions.CrystalReports.Engine.Section
        Get
            Return Me.ReportDefinition.Sections(5)
        End Get
    End Property
    
    <Browsable(false),  _
     DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility.Hidden)>  _
    Public ReadOnly Property Section3() As CrystalDecisions.CrystalReports.Engine.Section
        Get
            Return Me.ReportDefinition.Sections(6)
        End Get
    End Property
    
    <Browsable(false),  _
     DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility.Hidden)>  _
    Public ReadOnly Property Section4() As CrystalDecisions.CrystalReports.Engine.Section
        Get
            Return Me.ReportDefinition.Sections(7)
        End Get
    End Property
    
    <Browsable(false),  _
     DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility.Hidden)>  _
    Public ReadOnly Property Section5() As CrystalDecisions.CrystalReports.Engine.Section
        Get
            Return Me.ReportDefinition.Sections(8)
        End Get
    End Property
    
    <Browsable(false),  _
     DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility.Hidden)>  _
    Public ReadOnly Property Parameter_TXT_MAKE() As CrystalDecisions.[Shared].IParameterField
        Get
            Return Me.DataDefinition.ParameterFields(0)
        End Get
    End Property
    
    <Browsable(false),  _
     DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility.Hidden)>  _
    Public ReadOnly Property Parameter_TXT_CATEGORY() As CrystalDecisions.[Shared].IParameterField
        Get
            Return Me.DataDefinition.ParameterFields(1)
        End Get
    End Property
    
    <Browsable(false),  _
     DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility.Hidden)>  _
    Public ReadOnly Property Parameter_TXT_SPARENO() As CrystalDecisions.[Shared].IParameterField
        Get
            Return Me.DataDefinition.ParameterFields(2)
        End Get
    End Property
    
    <Browsable(false),  _
     DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility.Hidden)>  _
    Public ReadOnly Property Parameter_TXT_DESC() As CrystalDecisions.[Shared].IParameterField
        Get
            Return Me.DataDefinition.ParameterFields(3)
        End Get
    End Property
    
    <Browsable(false),  _
     DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility.Hidden)>  _
    Public ReadOnly Property Parameter_TXT_ORDQTY() As CrystalDecisions.[Shared].IParameterField
        Get
            Return Me.DataDefinition.ParameterFields(4)
        End Get
    End Property
    
    <Browsable(false),  _
     DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility.Hidden)>  _
    Public ReadOnly Property Parameter_TXT_DELIVQTY() As CrystalDecisions.[Shared].IParameterField
        Get
            Return Me.DataDefinition.ParameterFields(5)
        End Get
    End Property
    
    <Browsable(false),  _
     DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility.Hidden)>  _
    Public ReadOnly Property Parameter_TXT_BACKORDQTY() As CrystalDecisions.[Shared].IParameterField
        Get
            Return Me.DataDefinition.ParameterFields(6)
        End Get
    End Property
    
    <Browsable(false),  _
     DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility.Hidden)>  _
    Public ReadOnly Property Parameter_TXT_SELLINGPRICE() As CrystalDecisions.[Shared].IParameterField
        Get
            Return Me.DataDefinition.ParameterFields(7)
        End Get
    End Property
    
    <Browsable(false),  _
     DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility.Hidden)>  _
    Public ReadOnly Property Parameter_TXT_COSTPRICE() As CrystalDecisions.[Shared].IParameterField
        Get
            Return Me.DataDefinition.ParameterFields(8)
        End Get
    End Property
    
    <Browsable(false),  _
     DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility.Hidden)>  _
    Public ReadOnly Property Parameter_TXT_DISCOUNT() As CrystalDecisions.[Shared].IParameterField
        Get
            Return Me.DataDefinition.ParameterFields(9)
        End Get
    End Property
    
    <Browsable(false),  _
     DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility.Hidden)>  _
    Public ReadOnly Property Parameter_TXT_VAT() As CrystalDecisions.[Shared].IParameterField
        Get
            Return Me.DataDefinition.ParameterFields(10)
        End Get
    End Property
    
    <Browsable(false),  _
     DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility.Hidden)>  _
    Public ReadOnly Property Parameter_TXT_AMOUNT() As CrystalDecisions.[Shared].IParameterField
        Get
            Return Me.DataDefinition.ParameterFields(11)
        End Get
    End Property
    
    <Browsable(false),  _
     DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility.Hidden)>  _
    Public ReadOnly Property Parameter_TXT_REMARKS() As CrystalDecisions.[Shared].IParameterField
        Get
            Return Me.DataDefinition.ParameterFields(12)
        End Get
    End Property
    
    <Browsable(false),  _
     DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility.Hidden)>  _
    Public ReadOnly Property Parameter_TXT_TEXTLINES() As CrystalDecisions.[Shared].IParameterField
        Get
            Return Me.DataDefinition.ParameterFields(13)
        End Get
    End Property
    
    <Browsable(false),  _
     DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility.Hidden)>  _
    Public ReadOnly Property Parameter_TXT_WOPREFIX_WONO() As CrystalDecisions.[Shared].IParameterField
        Get
            Return Me.DataDefinition.ParameterFields(14)
        End Get
    End Property
    
    <Browsable(false),  _
     DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility.Hidden)>  _
    Public ReadOnly Property Parameter_DateFormat() As CrystalDecisions.[Shared].IParameterField
        Get
            Return Me.DataDefinition.ParameterFields(15)
        End Get
    End Property
    
    <Browsable(false),  _
     DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility.Hidden)>  _
    Public ReadOnly Property Parameter_RPT_NO_OF_DIGITS() As CrystalDecisions.[Shared].IParameterField
        Get
            Return Me.DataDefinition.ParameterFields(16)
        End Get
    End Property
    
    <Browsable(false),  _
     DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility.Hidden)>  _
    Public ReadOnly Property Parameter_RPT_ML_THOU_SEP() As CrystalDecisions.[Shared].IParameterField
        Get
            Return Me.DataDefinition.ParameterFields(17)
        End Get
    End Property
    
    <Browsable(false),  _
     DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility.Hidden)>  _
    Public ReadOnly Property Parameter_RPT_ML_DEC_SEP() As CrystalDecisions.[Shared].IParameterField
        Get
            Return Me.DataDefinition.ParameterFields(18)
        End Get
    End Property
    
    <Browsable(false),  _
     DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility.Hidden)>  _
    Public ReadOnly Property Parameter_WorkOrderNo() As CrystalDecisions.[Shared].IParameterField
        Get
            Return Me.DataDefinition.ParameterFields(19)
        End Get
    End Property
    
    <Browsable(false),  _
     DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility.Hidden)>  _
    Public ReadOnly Property Parameter_TXT_HEADER() As CrystalDecisions.[Shared].IParameterField
        Get
            Return Me.DataDefinition.ParameterFields(20)
        End Get
    End Property
    
    <Browsable(false),  _
     DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility.Hidden)>  _
    Public ReadOnly Property Parameter_TXT_DATE() As CrystalDecisions.[Shared].IParameterField
        Get
            Return Me.DataDefinition.ParameterFields(21)
        End Get
    End Property
    
    <Browsable(false),  _
     DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility.Hidden)>  _
    Public ReadOnly Property Parameter_TXT_PAGE() As CrystalDecisions.[Shared].IParameterField
        Get
            Return Me.DataDefinition.ParameterFields(22)
        End Get
    End Property
    
    <Browsable(false),  _
     DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility.Hidden)>  _
    Public ReadOnly Property Parameter_TXT_OF() As CrystalDecisions.[Shared].IParameterField
        Get
            Return Me.DataDefinition.ParameterFields(23)
        End Get
    End Property
    
    <Browsable(false),  _
     DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility.Hidden)>  _
    Public ReadOnly Property Parameter_TXT_NUMBER() As CrystalDecisions.[Shared].IParameterField
        Get
            Return Me.DataDefinition.ParameterFields(24)
        End Get
    End Property
    
    <Browsable(false),  _
     DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility.Hidden)>  _
    Public ReadOnly Property Parameter_TXT_JOBNUMBER() As CrystalDecisions.[Shared].IParameterField
        Get
            Return Me.DataDefinition.ParameterFields(25)
        End Get
    End Property
    
    <Browsable(false),  _
     DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility.Hidden)>  _
    Public ReadOnly Property Parameter_JobNo() As CrystalDecisions.[Shared].IParameterField
        Get
            Return Me.DataDefinition.ParameterFields(26)
        End Get
    End Property
End Class

<System.Drawing.ToolboxBitmapAttribute(GetType(CrystalDecisions.[Shared].ExportOptions), "report.bmp")>  _
Public Class CachedrptWorkOrder
    Inherits Component
    Implements ICachedReport
    
    Public Sub New()
        MyBase.New
    End Sub
    
    <Browsable(false),  _
     DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility.Hidden)>  _
    Public Overridable Property IsCacheable() As Boolean Implements CrystalDecisions.ReportSource.ICachedReport.IsCacheable
        Get
            Return true
        End Get
        Set
            '
        End Set
    End Property
    
    <Browsable(false),  _
     DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility.Hidden)>  _
    Public Overridable Property ShareDBLogonInfo() As Boolean Implements CrystalDecisions.ReportSource.ICachedReport.ShareDBLogonInfo
        Get
            Return false
        End Get
        Set
            '
        End Set
    End Property
    
    <Browsable(false),  _
     DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility.Hidden)>  _
    Public Overridable Property CacheTimeOut() As System.TimeSpan Implements CrystalDecisions.ReportSource.ICachedReport.CacheTimeOut
        Get
            Return CachedReportConstants.DEFAULT_TIMEOUT
        End Get
        Set
            '
        End Set
    End Property
    
    Public Overridable Function CreateReport() As CrystalDecisions.CrystalReports.Engine.ReportDocument Implements CrystalDecisions.ReportSource.ICachedReport.CreateReport
        Dim rpt As rptWorkOrder = New rptWorkOrder()
        rpt.Site = Me.Site
        Return rpt
    End Function
    
    Public Overridable Function GetCustomizedCacheKey(ByVal request As RequestContext) As String Implements CrystalDecisions.ReportSource.ICachedReport.GetCustomizedCacheKey
        Dim key As [String] = Nothing
        '// The following is the code used to generate the default
        '// cache key for caching report jobs in the ASP.NET Cache.
        '// Feel free to modify this code to suit your needs.
        '// Returning key == null causes the default cache key to
        '// be generated.
        '
        'key = RequestContext.BuildCompleteCacheKey(
        '    request,
        '    null,       // sReportFilename
        '    this.GetType(),
        '    this.ShareDBLogonInfo );
        Return key
    End Function
End Class
