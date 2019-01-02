using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Gas.Models
{
    public class ViewCustomerModel
    {
        public CustomerModel customer { get; set; }
        public PaymentModel payment { get; set; }
        public PaymentDetailModel paymentDetail { get; set; }
    }


}
