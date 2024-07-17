package com.example.mixed

import com.example.greeting.GreetingService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController

@RestController
class Controller {
    @Autowired
    private val greetingService: GreetingService? = null

    @GetMapping("/greet")
    fun greet(): String {
        return greetingService!!.greet("Mixed")
    }
}
