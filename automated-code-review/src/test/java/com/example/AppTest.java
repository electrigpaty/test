package com.example;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertEquals;

public class AppTest {

    @Test
    public void testCalculateSum() {
        int expected = 15;
        int actual = App.calculateSum(5, 10);
        assertEquals(expected, actual);
    }
}
