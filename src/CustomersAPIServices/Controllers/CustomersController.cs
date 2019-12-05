namespace CustomersAPIServices.Controllers
{
    
    using System.Collections.Generic;
    using Microsoft.AspNetCore.Mvc;
    
    [Route("api/[controller]")]
    public class CustomersController : Controller
    {        
        [HttpGet]
        public IEnumerable<string> Get()
        {
            return new string[] { "Jose Yapur", "Ivan Contreras", "Jorge Oblitas" };
        }

        [HttpGet("{id}")]
        public string Get(int id)
        {
            return $"Jose Yapur - {id}";
        }            
    }
}
