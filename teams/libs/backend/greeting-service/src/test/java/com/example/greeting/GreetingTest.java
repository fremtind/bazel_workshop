package com.example.greeting;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

public class GreetingTest {
    @Test
    void greets() {
        GreetingService greetingService = new GreetingService();
        String greeting = greetingService.greet("World");
        Assertions.assertEquals("Hello, World!", greeting);
    }
}
