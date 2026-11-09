package com.example;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class App {
    private static final Logger logger = LoggerFactory.getLogger(App.class);

    public static void main(String[] args) {
        logger.info("Application starting up");
        int numberA = 5;
        int numberB = 10;
        int result = calculateSum(numberA, numberB);
        logger.info("Calculated sum: {}", result);
    }

    public static int calculateSum(int a, int b) {
        return a + b;
    }
}
