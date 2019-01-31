using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Gas.Models;
using Gas.Data.DbLogic;

namespace Gas.Service.Interface
{
    public class PaymentService : IPaymentService
    {
        private  PaymentEntity paymentEntity = null;

        public List<PaymentDetailModel> GetPaymentDetailsById(int paymentID)
        {
            try
            {
                paymentEntity = new PaymentEntity();
                var list = paymentEntity.GetPaymentDetailsById(paymentID);
                return list;
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        public List<PaymentListingModel> GetPaymentList(CustomerSearchModel searchModel)
        {
            try
            {
                paymentEntity = new PaymentEntity();
                var list = paymentEntity.GetPaymentList(searchModel);
                return list;
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }


    }
}
