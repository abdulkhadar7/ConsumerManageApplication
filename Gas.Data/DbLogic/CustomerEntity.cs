﻿using Gas.Models;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Gas.Data.DbLogic
{
    public class CustomerEntity
    {
        private GasEntity _dbContext;

        public bool AddNewCustomer(AddCustomerModel input)
        {
            try
            {
                using (_dbContext = new GasEntity())
                {
                    Customer cust = new Customer();
                    cust.Aadhar = input.customerModel.Aadhar;
                    cust.City = input.customerModel.City;
                    cust.CreatedOn = input.customerModel.CreatedOn;
                    cust.Gender = input.customerModel.Gender;
                    cust.DOB = input.customerModel.DOB;
                    cust.FirstName = input.customerModel.FirstName;
                    cust.LastName = input.customerModel.LastName;
                    cust.MobileNumber = input.customerModel.MobileNumber;
                    cust.ModifiedOn = null;
                    cust.PostCode = input.customerModel.PostCode;
                    cust.State = input.customerModel.State;
                    cust.Street = input.customerModel.Street;
                    cust.ConsumerNo = input?.customerModel.ConsumerNo ?? 0;
                    _dbContext.Customers.Add(cust);
                    _dbContext.SaveChanges();

                    //this application is in git  remote

                    SqlParameter[] para = new SqlParameter[]
                    {
                        new SqlParameter {ParameterName="@customerId",Value=cust.CustomerID },
                        new SqlParameter {ParameterName="@advanceAmount",Value=input.payModel.AdvanceAmount },
                        new SqlParameter {ParameterName="@installment1",Value=input.payModel.Installment1 },
                        new SqlParameter {ParameterName="@installment2",Value=input.payModel.Installment2 },
                        new SqlParameter {ParameterName="@installment3",Value=input.payModel.Installment3 },
                    };
                    int paymentID = _dbContext.Database.SqlQuery<int>("exec AddPaymentInfo @customerId,@advanceAmount,@installment1,@installment2,@installment3", para).FirstOrDefault();

                    return true;
                }
            }
            catch(Exception ex)
            {
                return false;
            }
            
        }

        public List<CustomerModel> GetCustomers(CustomerSearchModel searchModel)
        {
            try
            {
                using (_dbContext = new GasEntity())
                {
                    SqlParameter[] para = new SqlParameter[]
                    {
                        new SqlParameter {ParameterName="@CustomerName",Value=DBNull.Value },
                        new SqlParameter {ParameterName="@ConsumerNumber",Value=DBNull.Value },
                        new SqlParameter {ParameterName="@SubmitDate",Value=DBNull.Value },
                        new SqlParameter {ParameterName="@Aadhar",Value=DBNull.Value }
                    };
                    List<CustomerModel> custList = _dbContext.Database.SqlQuery<CustomerModel>("exec GetCustomerList @CustomerName,@ConsumerNumber,@SubmitDate,@Aadhar", para).ToList();
                    return custList;
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        public int GetConnectionAmount()
        {
            try
            {
                using (_dbContext=new GasEntity() )
                {
                    var amount = Convert.ToInt32(_dbContext.SettingsMasters.Where(s => s.SettingsName == "TotalConnectionAmount" && s.IsActive == true).Select(s => s.SettingsValue).FirstOrDefault());
                    return amount;
                }
            }
            catch (Exception ex)
            {

                throw;
            }
        }
    }
}
