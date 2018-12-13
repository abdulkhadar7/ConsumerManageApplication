using System;
using Gas.Data.DbLogic;
using Gas.Data;
using Gas.Models;
using System.Collections.Generic;

namespace Gas.Service.Interface
{
    public class CustomerService : ICustomerService
    {
        private CustomerEntity customerEntity = null;
        public bool AddNewCustomer(AddCustomerModel input)
        {
            customerEntity = new CustomerEntity();
           
            bool status = customerEntity.AddNewCustomer(input);
            return status;
        }

        public List<CustomerModel> GetCustomers()
        {
            try
            {
                customerEntity = new CustomerEntity();
                List<CustomerModel> list = customerEntity.GetCustomers();
                return list;
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }
    }
}
