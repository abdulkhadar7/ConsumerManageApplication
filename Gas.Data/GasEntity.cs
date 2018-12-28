namespace Gas.Data
{
    using System;
    using System.Data.Entity;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Linq;

    public partial class GasEntity : DbContext
    {
        public GasEntity()
            : base("name=GasEntity")
        {
        }

        public virtual DbSet<Customer> Customers { get; set; }
        public virtual DbSet<MessageLog> MessageLogs { get; set; }
        public virtual DbSet<MessageTemplate> MessageTemplates { get; set; }
        public virtual DbSet<Payment> Payments { get; set; }
        public virtual DbSet<PaymentDetail> PaymentDetails { get; set; }
        public virtual DbSet<SettingsMaster> SettingsMasters { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Customer>()
                .Property(e => e.FirstName)
                .IsUnicode(false);

            modelBuilder.Entity<Customer>()
                .Property(e => e.LastName)
                .IsUnicode(false);

            modelBuilder.Entity<Customer>()
                .Property(e => e.Gender)
                .IsUnicode(false);

            modelBuilder.Entity<Customer>()
                .Property(e => e.Aadhar)
                .IsUnicode(false);

            modelBuilder.Entity<Customer>()
                .Property(e => e.Street)
                .IsUnicode(false);

            modelBuilder.Entity<Customer>()
                .Property(e => e.City)
                .IsUnicode(false);

            modelBuilder.Entity<Customer>()
                .Property(e => e.PostCode)
                .IsUnicode(false);

            modelBuilder.Entity<Customer>()
                .Property(e => e.State)
                .IsUnicode(false);

            modelBuilder.Entity<MessageLog>()
                .Property(e => e.ActualMessage)
                .IsUnicode(false);

            modelBuilder.Entity<MessageLog>()
                .Property(e => e.TemplateCode)
                .IsUnicode(false);

            modelBuilder.Entity<MessageTemplate>()
                .Property(e => e.TemplateCode)
                .IsUnicode(false);

            modelBuilder.Entity<MessageTemplate>()
                .Property(e => e.ActualMesage)
                .IsUnicode(false);
        }
    }
}
