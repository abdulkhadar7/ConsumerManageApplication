namespace Gas.Data
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("MessageLog")]
    public partial class MessageLog
    {
        public int MessageLogId { get; set; }

        public int CustomerID { get; set; }

        [Required]
        public string ActualMessage { get; set; }

        public DateTime CreatedDate { get; set; }

        [StringLength(10)]
        public string TemplateCode { get; set; }
    }
}
