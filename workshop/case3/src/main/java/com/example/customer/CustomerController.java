package com.example.customer;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class CustomerController {

    @RequestMapping(
            method = {RequestMethod.GET},
            value = {"/api/customer"},
            produces = {"application/json"}
    )
    public ResponseEntity<CustomerResponse> customer() throws Exception {
        return ResponseEntity.ok(new CustomerResponse("John Doe", "john@doe.com", "12345678"));
    }
}
