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
        public List<PaymentDetailModel> paymentDetail { get; set; }
        public InstalldetailModel installmentModel { get; set; }
    }

    public class InstalldetailModel
    {
        public int PaymentId { get; set; }
        public decimal? advance { get; set; }
        public decimal? Installment1 { get; set; }        
        public decimal? Installment2 { get; set; }
        public decimal? Installment3 { get; set; }
        public bool? insta1status { get; set; }
        public bool? insta2status { get; set; }
        public bool? insta3status { get; set; }
        public bool? advstatus { get; set; }
    }

}
