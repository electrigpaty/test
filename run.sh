#!/usr/bin/env bash

set -e

check_prerequisites() {
    if ! command -v java >/dev/null 2>&1; then
        echo "Error: Java is not installed or not available in PATH."
        exit 1
    fi

    JAVA_VER=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | awk -F '.' '{print $1}')
    if [ "$JAVA_VER" -lt 17 ]; then
        echo "Error: Java 17 or higher is required. Found Java version $JAVA_VER."
        exit 1
    fi

    if ! command -v mvn >/dev/null 2>&1; then
        echo "Error: Maven (mvn) is not installed or not available in PATH."
        exit 1
    fi
}

cmd_legacy() {
    check_prerequisites
    echo "=== Building and running legacy project ==="
    mvn -f automated-code-review-legacy/pom.xml clean compile exec:java -Dexec.mainClass="com.example.App"
}

cmd_build() {
    check_prerequisites
    echo "=== Building, testing, and checking checkstyle for fixed project ==="
    mvn -f automated-code-review/pom.xml clean verify
}

cmd_run() {
    check_prerequisites
    echo "=== Running fixed project main application ==="
    mvn -f automated-code-review/pom.xml compile exec:java -Dexec.mainClass="com.example.App"
}

cmd_clean() {
    check_prerequisites
    echo "=== Cleaning build output for both projects ==="
    mvn -f automated-code-review-legacy/pom.xml clean
    mvn -f automated-code-review/pom.xml clean
}

cmd_break() {
    echo "=== Injecting Checkstyle formatting errors into fixed project ==="
    cat << 'EOF' > automated-code-review/src/main/java/com/example/App.java
package com.example;

import java.util.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class App {
  private static final Logger logger = LoggerFactory.getLogger(App.class);

  public static void main(String[] args) {
        logger.info("Application starting up");
        int numberA=5;
        int numberB=10;
        int result=calculateSum(numberA,numberB);
        logger.info("Calculated sum: {}", result);
  }

  public static int calculateSum(int a,int b){
    return a+b;
  }
}
EOF
    echo "Checkstyle errors injected successfully."
}

cmd_fix() {
    echo "=== Restoring fixed project to clean state ==="
    cat << 'EOF' > automated-code-review/src/main/java/com/example/App.java
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
EOF
    echo "Clean code restored successfully."
}

cmd_help() {
    echo "Usage: ./run.sh [command]"
    echo ""
    echo "Commands:"
    echo "  all       Run legacy project, fixed project verification, and fixed project app (default)"
    echo "  legacy    Build and run the legacy project"
    echo "  test      Build, run tests, and check code style in fixed project"
    echo "  build     Alias for test"
    echo "  run       Execute main application of fixed project"
    echo "  clean     Clean build output folders in both projects"
    echo "  break     Inject intentional Checkstyle violations into fixed project"
    echo "  fix       Restore clean, compliant code in fixed project"
    echo "  help      Display this help message"
}

cmd_all() {
    cmd_legacy
    cmd_build
    cmd_run
}

ACTION="${1:-all}"

case "$ACTION" in
    all)
        cmd_all
        ;;
    legacy)
        cmd_legacy
        ;;
    test|build)
        cmd_build
        ;;
    run)
        cmd_run
        ;;
    clean)
        cmd_clean
        ;;
    break)
        cmd_break
        ;;
    fix)
        cmd_fix
        ;;
    help|--help|-h)
        cmd_help
        ;;
    *)
        echo "Error: Unknown command '$ACTION'."
        cmd_help
        exit 1
        ;;
esac
