using Gas.Models;
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

        public bool UpdateCustomer(ViewCustomerModel input)
        {
            bool status = false;
            try
            {
                using (_dbContext = new GasEntity())
                {
                    Customer C = _dbContext.Customers.FirstOrDefault(s => s.CustomerID == input.customer.CustomerID);
                    C.Aadhar = input.customer.Aadhar;
                    C.City = input.customer.City;
                    C.ConsumerNo = input.customer.ConsumerNo;
                    C.DOB = input.customer.DOB;
                    C.FirstName = input.customer.FirstName;
                    C.LastName = input.customer.LastName;
                    C.MobileNumber = input.customer.MobileNumber;
                    C.ModifiedOn = DateTime.Now;
                    C.PostCode = input.customer.PostCode;
                    C.State = input.customer.State;
                    C.Street = input.customer.Street;
                    _dbContext.SaveChanges();

                    if(input.installmentModel.PaymentId>0)
                    {
                        SqlParameter[] parameter = new SqlParameter[]
                        {
                            new SqlParameter {ParameterName="@paymentId",Value=input.installmentModel.PaymentId },
                            new SqlParameter {ParameterName="@CustomerId",Value=input.customer.CustomerID },
                            new SqlParameter {ParameterName="@advAmount",Value=input.installmentModel.advance },
                            new SqlParameter {ParameterName="@insta1Amount",Value=input.installmentModel.Installment1 },
                            new SqlParameter {ParameterName="@insta2Amount",Value=input.installmentModel.Installment2},
                            new SqlParameter {ParameterName="@insta3Amount",Value=input.installmentModel.Installment3},
                            new SqlParameter {ParameterName="@advStatus",Value=input.installmentModel.advstatus},
                            new SqlParameter {ParameterName="@inst1Status",Value =input.installmentModel.insta1status},
                            new SqlParameter {ParameterName="@inst2Status",Value =input.installmentModel.insta2status},
                            new SqlParameter {ParameterName="@inst3Status",Value =input.installmentModel.insta3status},
                            new SqlParameter {ParameterName="@mode",Value="UPDATE" },
                            new SqlParameter {ParameterName="@IsUpdate",Value=input.installmentModel.isDateUpdate }
                            
                        };
                        int id = _dbContext.Database.SqlQuery<int>("exec UpdatePaymentInfo @paymentId,@CustomerId,@advAmount,"+
                            "@insta1Amount,@insta2Amount,@insta3Amount,@advStatus,@inst1Status,@inst2Status,@inst3Status,@mode,@IsUpdate", parameter).FirstOrDefault();
                        if (id > 0)
                            status = true;
                    }
                    else
                    {
                        SqlParameter[] parameter = new SqlParameter[]
                        {
                            new SqlParameter {ParameterName="@paymentId",Value=input.installmentModel.PaymentId },
                            new SqlParameter {ParameterName="@CustomerId",Value=input.customer.CustomerID },
                            new SqlParameter {ParameterName="@advAmount",Value=input.installmentModel.advance },
                            new SqlParameter {ParameterName="@insta1Amount",Value=input.installmentModel.Installment1 },
                            new SqlParameter {ParameterName="@insta2Amount",Value=input.installmentModel.Installment2},
                            new SqlParameter {ParameterName="@insta3Amount",Value=input.installmentModel.Installment3},
                            new SqlParameter {ParameterName="@advStatus",Value=input.installmentModel.advstatus},
                            new SqlParameter {ParameterName="@inst1Status",Value =input.installmentModel.insta1status},
                            new SqlParameter {ParameterName="@inst2Status",Value =input.installmentModel.insta2status},
                            new SqlParameter {ParameterName="@inst3Status",Value =input.installmentModel.insta3status},
                            new SqlParameter {ParameterName="@mode",Value="CREATE" },
                            new SqlParameter {ParameterName="@IsUpdate",Value=DBNull.Value }
                        };
                        int id = _dbContext.Database.SqlQuery<int>("exec UpdatePaymentInfo @paymentId,@CustomerId,@advAmount," +
                            "@insta1Amount,@insta2Amount,@insta3Amount,@advStatus,@inst1Status,@inst2Status,@inst3Status,@mode,@IsUpdate", parameter).FirstOrDefault();
                        if (id > 0)
                            status = true;
                    }
                }
                return status;
            }
            catch (Exception)
            {

                throw;
            }
        }

        public ViewCustomerModel GetCustomerById(int customerId)
        {
            try
            {
                using (_dbContext = new GasEntity())
                {
                    ViewCustomerModel retModel = new ViewCustomerModel();

                    var cust = _dbContext.Customers.FirstOrDefault(s => s.CustomerID == customerId);
                    retModel.customer = new CustomerModel
                    {
                        Aadhar=cust.Aadhar,
                        City=cust.City,
                        ConsumerNo=cust.ConsumerNo,
                        CreatedOn=cust.CreatedOn,
                        CustomerID=cust.CustomerID,
                        DOB=cust.DOB,
                        FirstName=cust.FirstName,
                        LastName=cust.LastName,
                        Gender=cust.Gender,
                        MobileNumber=cust.MobileNumber,
                        PostCode=cust.PostCode,
                        State=cust.State,
                        Street=cust.Street
                    };

                    var payment = _dbContext.Payments.FirstOrDefault(s => s.CustomerID == cust.CustomerID);
                    if (payment!=null)
                    {
                        InstalldetailModel model = new InstalldetailModel();
                        model.PaymentId = payment.PaymentID;
                        model.isDateUpdate = false;                      

                        
                        var paydetails = _dbContext.PaymentDetails.Where(s => s.PaymentID == payment.PaymentID).ToList();
                        foreach (var item in paydetails)
                        {
                            if(item.InstallmentNo==0)
                            {
                                model.advance = item.PaymentAmount;
                                model.advstatus = item.PaymentStatus;
                            }
                            else if(item.InstallmentNo==1)
                            {
                                model.Installment1 = item.PaymentAmount;
                                model.insta1status = item.PaymentStatus;
                            }
                            else if (item.InstallmentNo == 2)
                            {
                                model.Installment2 = item.PaymentAmount;
                                model.insta2status = item.PaymentStatus;
                            }
                            else if (item.InstallmentNo == 3)
                            {
                                model.Installment3 = item.PaymentAmount;
                                model.insta3status = item.PaymentStatus;
                            }
                        }

                        retModel.installmentModel = model;
                    }
                    else
                    {
                        InstalldetailModel model = new InstalldetailModel();
                        model.isDateUpdate = false;
                        model.advance = 0;
                        model.advstatus = false;
                        model.insta1status = false;
                        model.insta2status = false;
                        model.insta3status = false;
                        model.Installment1 = 0;
                        model.Installment2 = 0;
                        model.Installment3 = 0;
                        model.PaymentId = 0;
                        retModel.installmentModel = model;
                    }
                    
                    return retModel;
                }
            }
            catch (Exception ex )
            {

                throw ex;
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
                        new SqlParameter {ParameterName="@CustomerName",Value=string.IsNullOrEmpty(searchModel?.CustomerName)?(object)DBNull.Value:searchModel.CustomerName},
                        new SqlParameter {ParameterName="@ConsumerNumber",Value=searchModel?.ConsumerNumber>0?searchModel.ConsumerNumber:(object)DBNull.Value },
                        new SqlParameter {ParameterName="@SubmitDate",Value=searchModel?.SubmitDate==DateTime.MinValue?(object)DBNull.Value:searchModel.SubmitDate },
                        new SqlParameter {ParameterName="@Aadhar",Value=string.IsNullOrEmpty(searchModel?.Aadhar)?(object)DBNull.Value:searchModel.Aadhar }
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
