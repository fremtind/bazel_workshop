package examples.case4;

import examples.case3.Greeter;
import org.junit.jupiter.api.Test;

import java.io.ByteArrayOutputStream;
import java.io.PrintStream;

import static org.assertj.core.api.Assertions.assertThat;

public class GreeterTest {

    @Test
    void testGreet() {
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        System.setOut(new PrintStream(byteArrayOutputStream));
        Greeter greeter = new Greeter("Hello, World!");
        greeter.greet();
        assertThat(byteArrayOutputStream.toString()).isEqualTo("Hello, World!\n");
    }
}
