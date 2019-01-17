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

        public object GetPaymentList(CustomerSearchModel searchModel)
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

                    var data = _dbContext.Database.SqlQuery<object>("exec GetPaymentList @CustomerName,@ConsumerNumber,@SubmitDate,@Aadhar", para).ToList();
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
