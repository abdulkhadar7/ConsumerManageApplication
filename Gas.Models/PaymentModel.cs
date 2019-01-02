using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Gas.Models
{
    public class PaymentModel
    {
        public int PaymentID { get; set; }
        public int CustomerID { get; set; }
        public decimal? AdvanceAmount { get; set; }
        public decimal? InstallmentAmount { get; set; }

        public decimal? TotalPaid { get; set; }
        public decimal? Installment1 { get; set; }
        public decimal? Installment2 { get; set; }
        public decimal? Installment3 { get; set; }

        public decimal? TotalPending { get; set; }

        public DateTime? CreatedOn { get; set; }

        public DateTime? ModifiedOn { get; set; }
    }
   
}
