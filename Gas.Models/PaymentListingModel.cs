using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Gas.Models
{
    public class PaymentListingModel
    {
        public string CustomerName { get; set; }
        public int PaymentID { get; set; }
        public decimal Advance { get; set; }
        public decimal InstallmentAmount { get; set; }
        public decimal TotalPaid { get; set; }
        public decimal TotalPending { get; set; }
        public decimal TotalAmount { get; set; }
        public DateTime ModifiedOn { get; set; }
    }
}
