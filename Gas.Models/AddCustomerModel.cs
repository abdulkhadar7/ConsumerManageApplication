using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Gas.Models
{
    public class AddCustomerModel
    {
        public CustomerModel customerModel { get; set; }
        public PaymentModel payModel { get; set; }
    }


    public class PaymentModel
    {
        public decimal? AdvanceAmount { get; set; }
        public decimal? Installment1 { get; set; }
        public decimal? Installment2 { get; set; }
        public decimal? Installment3 { get; set; }
    }
}
