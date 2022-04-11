#!/usr/bin/env bash

set -e

if [ -z "$GRAALVM_HOME" ]; then
    echo "Please set GRAALVM_HOME"
    exit 1
fi

if [[ ! -f "$CLOJURE_LSP_JAR" ]]
then
    make cli-jar
    CLOJURE_LSP_JAR=$(ls clojure-lsp-standalone.jar)
fi

CLOJURE_LSP_XMX=${CLOJURE_LSP_XMX:-"-J-Xmx8g"}

args=("-jar" "$CLOJURE_LSP_JAR"
      "clojure-lsp"
      "-H:+ReportExceptionStackTraces"
      "--verbose"
      "--no-fallback"
      "--native-image-info"
      "$CLOJURE_LSP_XMX")

CLOJURE_LSP_STATIC=${CLOJURE_LSP_STATIC:-}

if [ "$CLOJURE_LSP_STATIC" = "true" ]; then
    args+=("--static" "-H:+StaticExecutableWithDynamicLibC")
fi

"$GRAALVM_HOME/bin/native-image" "${args[@]}"
