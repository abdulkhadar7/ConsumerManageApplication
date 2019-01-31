using Gas.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Gas.Service.Interface
{
    public interface IPaymentService
    {
        List<PaymentListingModel> GetPaymentList(CustomerSearchModel searchModel);
        List<PaymentDetailModel> GetPaymentDetailsById(int paymentID);
    }
}
