namespace Gas.Data
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;
    [Table("PaymentDetails")]
    public partial class PaymentDetail
    {
        [Key]
        public int PaymentDetail_ID { get; set; }

        public int PaymentID { get; set; }

        public decimal? PaymentAmount { get; set; }

        [Column(TypeName = "date")]
        public DateTime? DueDate { get; set; }

        [Column(TypeName = "date")]
        public DateTime? PaidOn { get; set; }

        public bool? PaymentStatus { get; set; }

        public DateTime? CreatedOn { get; set; }

        public DateTime? ModifiedOn { get; set; }
        public int InstallmentNo { get; set; }
    }
}
