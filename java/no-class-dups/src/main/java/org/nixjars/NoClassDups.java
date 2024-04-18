package org.nixjars;

import java.util.Map;
import java.util.Set;
import java.util.LinkedHashSet;
import java.util.regex.Pattern;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.net.URL;
import java.net.MalformedURLException;

import io.github.classgraph.ClassGraph;
import io.github.classgraph.Resource;
import io.github.classgraph.ResourceList;

public class NoClassDups {

    public static void main(String[] args) throws MalformedURLException {

        // This code is based on a sample from Luke Hutchison (author of ClassGraph):
        // https://stackoverflow.com/a/52639079

        Set<URL> urls = new LinkedHashSet<>();

        for (String a : args) {
            for (String part : a.split(Pattern.quote(File.pathSeparator))) {
                urls.add(Paths.get(part).toUri().toURL());
            }
        }

        boolean dups = false;

        for (Map.Entry<String, ResourceList> dup :
                new ClassGraph()
                    .enableAllInfo()
                    .overrideClasspath(urls)
                    .scan()
                    .getAllResources()
                    .classFilesOnly()
                    .findDuplicatePaths()) {
            String duplicatedItem = dup.getKey();
            if (!duplicatedItem.equals("module-info.class")) {
                dups = true;
                System.out.println(duplicatedItem);
                for (Resource res : dup.getValue()) {
                    System.out.println(" -> " + res.getURI()); // Resource URI, showing classpath element
                }
            }
        }

        if (dups) {
            System.exit(1);
        }

    }

}
