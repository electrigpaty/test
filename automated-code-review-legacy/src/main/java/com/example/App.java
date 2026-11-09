package com.example;

import java.util.*;

public class App {
  public static void main(String[] args) {
        System.out.println("Legacy Application Started");
        int a=5;
        int b=10;
        int sum=add(a,b);
        System.out.println("Sum result: " + sum);
  }

  public static int add(int x,int y){
      return x+y;
  }
}
