addToClasspath() {
  for f in "$1"/lib/java/*.jar; do
    addToSearchPath CLASSPATH "$f"
  done
}
addEnvHooks "$hostOffset" addToClasspath
