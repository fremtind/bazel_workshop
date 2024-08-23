package com.example.products;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class ProductController {

    @RequestMapping(
            method = {RequestMethod.GET},
            value = {"/api/products"},
            produces = {"application/json"}
    )
    public ResponseEntity<List<ProductResponse>> customer() throws Exception {
        return ResponseEntity.ok(List.of(new ProductResponse("1", "cheese")));
    }
}
