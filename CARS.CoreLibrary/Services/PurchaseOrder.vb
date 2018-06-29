Imports System.Web

Namespace CARS.Services.PurchaseOrder

    Public Class PurchaseOrder
        Shared objPODO As New PurchaseOrderDO
        Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr

        Public Function FetchPurchaseOrders(ByVal POnum As String, ByVal supplier As String, ByVal fromDate As Integer, ByVal toDate As Integer, ByVal spareNumber As String, ByVal isDelivered As String, ByVal isConfirmedOrder As String, ByVal isUnconfirmedOrder As String, ByVal isExactPOnum As String, ByVal isExactSupp As String) As List(Of PurchaseOrderHeaderBO)
            Dim dsPurchaseOrder As New DataSet
            Dim dtPurchaseOrder As DataTable
            Dim purchaseOrderSearchResult As New List(Of PurchaseOrderHeaderBO)()

            Try
                dsPurchaseOrder = objPODO.FetchPurchaseOrders(POnum, supplier, fromDate, toDate, spareNumber, isDelivered, isConfirmedOrder, isUnconfirmedOrder, isExactPOnum, isExactSupp)

                If dsPurchaseOrder.Tables.Count > 0 Then
                    dtPurchaseOrder = dsPurchaseOrder.Tables(0)
                End If
                If supplier <> String.Empty Then
                    For Each dtrow As DataRow In dtPurchaseOrder.Rows
                        Dim po As New PurchaseOrderHeaderBO()

                        po.NUMBER = dtrow("NUMBER").ToString
                        po.ID_ORDERTYPE = dtrow("ID_ORDERTYPE").ToString
                        po.SUPP_CURRENTNO = dtrow("SUPP_CURRENTNO").ToString
                        po.SUPP_NAME = dtrow("SUPP_NAME").ToString

                        po.DT_EXPECTED_DELIVERY = convertDate(dtrow("DT_EXPECTED_DELIVERY").ToString)
                        po.DT_CREATED_SIMPLE = convertDate(dtrow("DT_CREATED_SIMPLE").ToString)
                        po.DELIVERY_METHOD = dtrow("DELIVERY_METHOD").ToString
                        po.STATUS = dtrow("STATUS").ToString

                        po.DELIVERED = dtrow("FINISHED").ToString
                        po.ANNOTATION = dtrow("ANNOTATION").ToString



                        purchaseOrderSearchResult.Add(po)
                    Next
                End If
            Catch ex As Exception
                Throw ex
            End Try
            Return purchaseOrderSearchResult
        End Function


        Public Function Fetch_PO_Items(ByVal POnum As String) As List(Of PurchaseOrderItemsBO)
            Dim dsPurchaseOrderItems As New DataSet
            Dim dtPurchaseOrderItems As DataTable
            Dim purchaseOrderSearchResult As New List(Of PurchaseOrderItemsBO)()

            Try
                dsPurchaseOrderItems = objPODO.Fetch_PO_Items(POnum)

                If dsPurchaseOrderItems.Tables.Count > 0 Then
                    dtPurchaseOrderItems = dsPurchaseOrderItems.Tables(0)
                End If

                For Each dtrow As DataRow In dtPurchaseOrderItems.Rows
                    Dim item As New PurchaseOrderItemsBO()

                    item.ID_ITEM = dtrow("ID_ITEM").ToString
                    item.ITEM_CATG_DESC = dtrow("ITEM_CATG_DESC").ToString
                    item.ORDERQTY = dtrow("ORDERQTY")
                    item.BUYCOST = (dtrow("BUYCOST"))

                    item.TOTALCOST = dtrow("TOTALCOST")


                    'item.DELIVERED = dtrow("FINISHED").ToString
                    'item.ANNOTATION = dtrow("ANNOTATION").ToString



                    purchaseOrderSearchResult.Add(item)
                Next

            Catch ex As Exception
                Throw ex
            End Try
            Return purchaseOrderSearchResult
        End Function






        Public Function convertDate(ByVal thedate As String) As String
            Dim theyear = thedate.Substring(0, 4)
            Dim themonth = thedate.Substring(4, 2)
            Dim theday = thedate.Substring(6, 2)
            Dim thefinaldate = theday + "-" + themonth + "-" + theyear
            Return thefinaldate
        End Function

        Public Function generate_PO_number(ByVal deptID As Integer, ByVal warehouseID As Integer) As String()

            Dim dsPOnumber As New DataSet
            Dim dtPOnumber As New DataTable
            Dim POnumber As String
            Dim POprefix As String
            Dim numbers(1) As String


            Try
                dsPOnumber = objPODO.generate_PO_number(deptID, warehouseID)
                POnumber = dsPOnumber.Tables(0).Rows(0).Item(2)
                POprefix = dsPOnumber.Tables(0).Rows(0).Item(1)
                numbers(0) = POprefix
                numbers(1) = POnumber
            Catch ex As Exception
                Dim theex = ex.GetType()


                Throw ex
            End Try
            Return numbers
        End Function

        Public Function SavePurchaseOrder(ByVal POheader As PurchaseOrderHeaderBO) As Integer

            Dim strResult As Integer

            Dim login As String = HttpContext.Current.Session("UserID")
            Try
                strResult = objPODO.SavePurchaseOrder(POheader, login)

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.Customer", "Insert_Customer", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strResult

        End Function



        Public Function Add_PO_Item(ByVal POitem As PurchaseOrderItemsBO) As Integer

            Dim strResult As Integer

            Dim login As String = HttpContext.Current.Session("UserID")
            Try
                strResult = objPODO.Add_PO_Item(POitem, login)

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.Customer", "Insert_Customer", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strResult

        End Function

        Public Function updatePOitem(ByVal ponumber As String, ByVal polineno As String, ByVal orderqty As String, ByVal buycost As String, ByVal totalcost As String) As Integer
            Dim res As Integer

            Dim login As String = HttpContext.Current.Session("UserID")
            Try
                res = objPODO.updatePOitem(ponumber, polineno, orderqty, buycost, totalcost, login)

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.Customer", "Insert_Customer", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return res

        End Function



        Public Function setPOtoSent(ByVal ponumber As String) As Integer
            Dim res As Integer

            Dim login As String = HttpContext.Current.Session("UserID")
            Try
                res = objPODO.setPOtoSent(ponumber, login)

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.Customer", "Insert_Customer", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return res

        End Function




    End Class

End Namespace