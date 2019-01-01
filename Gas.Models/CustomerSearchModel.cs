using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Gas.Models
{
    public class CustomerSearchModel
    {
        public string CustomerName { get; set; }
        public int ConsumerNumber { get; set; }
        public DateTime SubmitDate { get; set; }
        public string Aadhar { get; set; }
    }
}
