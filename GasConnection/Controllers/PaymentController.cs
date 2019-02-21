using Gas.Models;
using Gas.Service.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace GasConnection.Controllers
{
    public class PaymentController : Controller
    {
        private IPaymentService _paymentService = null;
        // GET: Payment
        public ActionResult Index()
        {
            return View();
        }

        [HttpPost]
        public ActionResult GetPaymentList(CustomerSearchModel input)
        {
            try
            {
                _paymentService = new PaymentService();
                var list = _paymentService.GetPaymentList(input);
                return PartialView("_GetPayments",list);
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        [HttpGet]
        public ActionResult GetPaymentDetailsById(int PaymentID)
        {
            try
            {
                _paymentService = new PaymentService();
                var data = _paymentService.GetPaymentDetailsById(PaymentID);
                return PartialView("_GetPaymentDetailsById",data);
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }
    }
}