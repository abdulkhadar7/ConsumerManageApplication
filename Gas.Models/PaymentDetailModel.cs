using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Gas.Models
{
    public class PaymentDetailModel
    {
        public int PaymentDetail_ID { get; set; }
        public int PaymentID { get; set; }
        public decimal? PaymentAmount { get; set; }       
        public DateTime? DueDate { get; set; }       
        public DateTime? PaidOn { get; set; }
        public bool? PaymentStatus { get; set; }
        public DateTime? CreatedOn { get; set; }
        public DateTime? ModifiedOn { get; set; }
        public int InstallmentNo { get; set; }
    }
}
