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
            try
            {
                _customerService = new CustomerService();
                bool status = _customerService.AddNewCustomer(CustomerInput);
                return RedirectToAction("GetCustomers", "Customer");
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }             

       
        [HttpGet]
        public ActionResult LoadAddNewCustomerView()
        {
            try
            {
                _customerService = new CustomerService();
                ViewBag.ConnectionAmount = _customerService.GetConnectionAmount();
                return View("LoadAddNewCustomer");
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        [HttpGet]
        public ActionResult GetCustomers()
        {
            return View();
        }

        [HttpPost]
        public ActionResult GetCustomerList(CustomerSearchModel searchmodel)
        {
            try
            {
                _customerService = new CustomerService();
                var list = _customerService.GetCustomers(searchmodel);
                return PartialView("_GetCustomers", list);
            }
            catch (Exception ex) 
            {

                throw ex;
            }
        }
        [HttpGet]
        public ActionResult GetCustomerById(int customerId)
        {

            try
            {
                _customerService = new CustomerService();
                ViewBag.ConnectionAmount = _customerService.GetConnectionAmount();
                var data = _customerService.GetCustomerById(customerId);
                return View("GetCustomerById", data);
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }
        [HttpPost]
        public ActionResult UpdateCustomer(ViewCustomerModel input)
        {
            try
            {
                _customerService = new CustomerService();
                bool success = _customerService.UpdateCustomer(input);
                if (success)
                    return Json(new { status = "Success", message = "Success" });
                else
                    return Json(new { status = "Failed", message = "Failed" });
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }
        
    }
}