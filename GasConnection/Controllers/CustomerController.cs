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

            //no data

            bool status = _customerService.AddNewCustomer(CustomerInput);
            return RedirectToAction("GetCustomers", "Customer");
        }             

       

        [HttpGet]
        public ActionResult LoadAddNewCustomerView()
        {
            _customerService = new CustomerService();
            ViewBag.ConnectionAmount = _customerService.GetConnectionAmount();
            return View("LoadAddNewCustomer");
        }

        [HttpGet]
        public ActionResult GetCustomers()
        {
            return View();
        }

        [HttpPost]
        public ActionResult GetCustomerList(CustomerSearchModel searchmodel)
        {
            _customerService = new CustomerService();
            var list = _customerService.GetCustomers(searchmodel);
            return PartialView("_GetCustomers", list);
        }

        public ActionResult GetCustomerById(int customerId)
        {
            _customerService = new CustomerService();
            var data = _customerService.GetCustomerById(customerId);
            return View();
        }
        
    }
}