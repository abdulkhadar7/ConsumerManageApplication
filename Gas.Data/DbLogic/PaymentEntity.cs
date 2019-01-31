using Gas.Models;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Gas.Data.DbLogic
{
    public class PaymentEntity
    {
        private GasEntity _dbContext;

        public List<PaymentListingModel> GetPaymentList(CustomerSearchModel searchModel)
        {
            try
            {
                using (_dbContext = new GasEntity())
                {
                    SqlParameter[] para = new SqlParameter[]
                    {
                        new SqlParameter {ParameterName="@CustomerName",Value=string.IsNullOrEmpty(searchModel?.CustomerName)?(object)DBNull.Value:searchModel.CustomerName},
                        new SqlParameter {ParameterName="@ConsumerNumber",Value=searchModel?.ConsumerNumber>0?searchModel.ConsumerNumber:(object)DBNull.Value },
                        new SqlParameter {ParameterName="@SubmitDate",Value=searchModel?.SubmitDate==DateTime.MinValue?(object)DBNull.Value:searchModel.SubmitDate }
                       // new SqlParameter {ParameterName="@Aadhar",Value=string.IsNullOrEmpty(searchModel?.Aadhar)?(object)DBNull.Value:searchModel.Aadhar }
                    };

                    var data = _dbContext.Database.SqlQuery<PaymentListingModel>("exec GetPaymentList @CustomerName,@ConsumerNumber,@SubmitDate", para).ToList();
                    return data;
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        public List<PaymentDetailModel> GetPaymentDetailsById(int PaymentID)
        {
            try
            {
                using (_dbContext =new GasEntity())
                {
                    var data = (from pd in _dbContext.PaymentDetails
                                where pd.PaymentID == PaymentID
                                orderby pd.InstallmentNo ascending
                                select new PaymentDetailModel
                                {
                                    PaymentDetail_ID = pd.PaymentDetail_ID,
                                    DueDate = pd.DueDate,
                                    InstallmentNo = pd.InstallmentNo,
                                    PaidOn = pd.PaidOn,
                                    PaymentAmount = pd.PaymentAmount,
                                    PaymentStatus = pd.PaymentStatus
                                }).ToList();
                    return data;
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }
    }
}
