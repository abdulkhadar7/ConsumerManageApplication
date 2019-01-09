using Gas.Models;
using System.Collections.Generic;

namespace Gas.Service.Interface
{
    public interface ICustomerService
    {
        bool AddNewCustomer(AddCustomerModel customerModel);
        List<CustomerModel> GetCustomers(CustomerSearchModel searchModel);
        int GetConnectionAmount();
        ViewCustomerModel GetCustomerById(int customerId);
        bool UpdateCustomer(ViewCustomerModel input);
    }
}
