package com.example.mixed

import org.assertj.core.api.Assertions.assertThat
import org.junit.jupiter.api.Test
import org.springframework.boot.test.context.SpringBootTest

@SpringBootTest
class ContextTest {

    @Test
    fun contextLoads() {
    }

    @Test
    fun hello() {
        assertThat(Util().hello).isEqualTo("Hello")
    }

}

