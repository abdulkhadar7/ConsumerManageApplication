using Gas.Models;
using Gas.Service.Interface;
using System.Web.Mvc;
using System;

namespace GasConnection.Controllers
{
    public class CustomerController : Controller
    {
        private ICustomerService _customerService;
       
        // GET: Customer
        public ActionResult Index()
        {
            return View();
        }

        [HttpPost]
        public ActionResult AddNewCustomer(AddCustomerModel CustomerInput)
        {
            _customerService = new CustomerService();
            bool status = _customerService.AddNewCustomer(CustomerInput);
            return RedirectToAction("GetCustomers", "Customer");
        }

        [HttpGet]
        public ActionResult GetCustomers()
        {
            try
            {
                _customerService = new CustomerService();
                var list = _customerService.GetCustomers();
                return View("GetCustomers", list);
            }
            catch (Exception ex)
            {

                throw;
            }
        }

        [HttpGet]
        public ActionResult LoadAddNewCustomer()
        {
            return PartialView("_LoadAddNewCustomer");
        }

        [HttpGet]
        public ActionResult LoadAddNewCustomerView()
        {
            return View("LoadAddNewCustomer");
        }
    }
}