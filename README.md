# NixJARs

This is a set of Nix expressions for building Java packages (JARs).  It already
includes several common Java libraries and can be easily extended with more.

To list available packages:

    nix-env -qaPf . | sort

TODO: document `buildJavaPackage`.  See `examples/basic-project.nix`.

TODO: document how to overlay an upgrade for one particular package.

## Motivation

I am sick of `NoClassDefFoundError`.

The packages here are guaranteed to meet a minimum level of compatibility since
they are compiled from source against each other.

## FAQ

**Why not build with Ant/Maven/Gradle?**
All of the projects here have some other build system, and all of those build
systems are ignored.  The major Java build systems are deeply incompatible with
the Nix way of doing things, since they insist on locating dependencies
themselves rather than having them provided by an external package manager.
See [Misadventures Recompiling the Java Ecosystem from Source](https://calvin.loncaric.us/articles/JavaCompilation.html)
for more information about why Maven, specifically, would be a nightmare to
support.

**Java 9 Modules?**
Yes, modules are supported.  However, at the moment the builder does not
modularize executables, which means there isn't actually any run-time
encapsulation protection.  TODO: switch from `CLASSPATH` to `--module-path` for
executables that support it.

**OSGi?**
No.  Most OSGi projects work just fine as normal JARs, which is the way this
set of packages prefers to use them.
