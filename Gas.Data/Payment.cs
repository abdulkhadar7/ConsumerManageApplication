namespace Gas.Data
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("Payment")]
    public partial class Payment
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
