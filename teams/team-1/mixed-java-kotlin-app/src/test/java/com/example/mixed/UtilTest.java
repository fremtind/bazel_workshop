package com.example.mixed;

import org.junit.jupiter.api.Test;
import com.example.mixed.Util;

import static org.assertj.core.api.Assertions.assertThat;

public class UtilTest {
    @Test
    void testHello() {
        assertThat(new Util().getHello()).isEqualTo("Hello");
    }
}
