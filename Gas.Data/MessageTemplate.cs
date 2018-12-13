namespace Gas.Data
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("MessageTemplate")]
    public partial class MessageTemplate
    {
        [Key]
        public int TemplateID { get; set; }

        [Required]
        [StringLength(10)]
        public string TemplateCode { get; set; }

        [MaxLength(150)]
        public byte[] TemplateDesc { get; set; }

        [Required]
        public string ActualMesage { get; set; }

        public bool IsActive { get; set; }
    }
}
