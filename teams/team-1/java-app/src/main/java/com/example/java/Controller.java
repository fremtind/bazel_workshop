package com.example.java;

import com.example.greeting.GreetingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class Controller {

        @Autowired
        private GreetingService greetingService;

        @GetMapping("/greet")
        public String greet() {
            return greetingService.greet("Java");
        }
}
