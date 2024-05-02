package examples.case3;

public class Greeter {
    private final String message;

    public Greeter(String message) {
        this.message = message;
    }

    public void greet() {
        System.out.println(message);
    }
}
