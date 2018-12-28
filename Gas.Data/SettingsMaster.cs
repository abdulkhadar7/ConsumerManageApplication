using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Gas.Data
{
    [Table("SettingsMaster")]
    public class SettingsMaster
    {
        [Key]
        public int SettingsId { get; set; }

        public string SettingsName { get; set; }

        public string SettingsValue { get; set; }

        public bool IsActive { get; set; }

    }
}
