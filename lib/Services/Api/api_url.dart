const baseUrl = '';

class Urls {
  static const String apiUrl = baseUrl + 'api/';


  //All Get APIs
  static const String getClientByBarcodeApi = apiUrl + 'Bills/GetClientByBarcode';
  static const String getAllClientApi = apiUrl + 'Clients/GetAll';
  static const String getMonthBalanceApi = apiUrl + 'MonthBalance/GetAll';
  static const String getStatisticalApi = apiUrl + 'Statistics';
  static const String getPointsBillsApi = apiUrl + 'PointBills/GetAll/';
  static const String getItemsForSalesApi = apiUrl + 'Items/GetItemsForSales';
  static const String getMachineIdApi = apiUrl + 'PointBills/GetByID/';
  static const String getItemsTableApi = apiUrl + 'Items/GetAll';
  static const String getItemsUnitsApi = apiUrl + 'Items/GetUnits';
  static const String getItemsCategoriesApi = apiUrl + 'Items/GetCategories';
  static const String getOneItemsApi = apiUrl + 'Items';


  //All Post APIs
  static const String postClientsApi = apiUrl + 'Clients';
  static const String postItemsApi = apiUrl + 'Items';
  static const String postMonthBalanceApi = apiUrl + 'MonthBalance/Prepare';
  static const String postBreadBillApi = apiUrl + 'PointBills/PostBreadBill';
  static const String postPreciseBillApi = apiUrl + 'PointBills/PostPreciseBill';
  static const String postMoneyBillApi = apiUrl + 'PointBills/PostMoneyBill';
  static const String postItemBillApi = apiUrl + 'PointBills/PostItemBill';
  static const String postMonthBalancePrintApi = apiUrl + 'MonthBalance/Print/';


  //All Delete APIs
  static const String deleteClientsApi = apiUrl + 'Clients';
  static const String deleteItemApi = apiUrl + 'Items';



  //All Update APIs
  static const String updateClientsApi = apiUrl + 'Clients';
  static const String updateItemsApi = apiUrl + 'Items';

}
