{lib, fetchFromGitHub, buildJavaPackage}:

let

osgi-version = "8.0.0.1";
osgi-license = lib.licenses.asl20;
osgi-src = fetchFromGitHub {
  owner = "osgi";
  repo = "osgi";
  rev = osgi-version;
  hash = "sha256-xVpWvoDQqWIBDbFxikNieMFogqsHgVRCunJPm695EWg=";
};

in

rec {

  annotation-versioning = buildJavaPackage {
    pname = "osgi-annotation-versioning";
    version = osgi-version;
    license = osgi-license;
    src = osgi-src;
    srcDir = "org.osgi.annotation.versioning/src";
  };

  annotation = buildJavaPackage {
    pname = "osgi-annotation";
    version = osgi-version;
    license = osgi-license;
    src = osgi-src;
    srcDir = "org.osgi.annotation.bundle/src";
    deps = [
      annotation-versioning
    ];
  };

  annotation-bundle = buildJavaPackage {
    pname = "osgi-annotation-bundle";
    version = osgi-version;
    license = osgi-license;
    src = osgi-src;
    srcDir = "org.osgi.annotation.bundle/src";
    deps = [
      annotation-versioning
    ];
  };

  dto = buildJavaPackage {
    pname = "osgi-dto";
    version = osgi-version;
    license = osgi-license;
    src = osgi-src;
    srcDir = "org.osgi.dto/src";
    deps = [
      annotation-versioning
    ];
  };

  resource = buildJavaPackage {
    pname = "osgi-resource";
    version = osgi-version;
    license = osgi-license;
    src = osgi-src;
    srcDir = "org.osgi.resource/src";
    deps = [
      annotation-versioning
      dto
    ];
  };

  core = buildJavaPackage {
    pname = "osgi-core";
    version = osgi-version;
    license = osgi-license;
    src = osgi-src;
    srcDir = "org.osgi.framework/src";
    deps = [
      annotation-versioning
      annotation
      dto
      resource
    ];
  };

  namespace-implementation = buildJavaPackage {
    pname = "osgi-namespace-implementation";
    version = osgi-version;
    license = osgi-license;
    src = osgi-src;
    srcDir = "org.osgi.namespace.implementation/src";
    deps = [
      annotation-versioning
      resource
    ];
  };

  namespace-service = buildJavaPackage {
    pname = "osgi-namespace-service";
    version = osgi-version;
    license = osgi-license;
    src = osgi-src;
    srcDir = "org.osgi.namespace.service/src";
    deps = [
      annotation-versioning
      resource
    ];
  };

  namespace-extender = buildJavaPackage {
    pname = "osgi-namespace-extender";
    version = osgi-version;
    license = osgi-license;
    src = osgi-src;
    srcDir = "org.osgi.namespace.extender/src";
    deps = [
      annotation-versioning
      resource
    ];
  };

  service-serviceloader = buildJavaPackage {
    pname = "osgi-service-serviceloader";
    version = osgi-version;
    license = osgi-license;
    src = osgi-src;
    srcDir = "org.osgi.service.serviceloader/src";
    deps = [
      annotation-versioning
      resource
    ];
  };

  framework = buildJavaPackage {
    pname = "osgi-framework";
    version = osgi-version;
    license = osgi-license;
    src = osgi-src;
    srcDir = "org.osgi.framework/src";
    deps = [
      annotation-versioning
      resource
      dto
    ];
  };

  service-prefs = buildJavaPackage {
    pname = "osgi-service-prefs";
    version = osgi-version;
    license = osgi-license;
    src = osgi-src;
    srcDir = "org.osgi.service.prefs/src";
    deps = [
      annotation-versioning
    ];
  };

  util-function = buildJavaPackage {
    pname = "osgi-util-function";
    version = osgi-version;
    license = osgi-license;
    src = osgi-src;
    srcDir = "org.osgi.util.function/src";
    deps = [
      annotation-versioning
    ];
  };

  util-promise = buildJavaPackage {
    pname = "osgi-util-promise";
    version = osgi-version;
    license = osgi-license;
    src = osgi-src;
    srcDir = "org.osgi.util.promise/src";
    deps = [
      annotation-versioning
      util-function
    ];
  };

  util-pushstream = buildJavaPackage {
    pname = "osgi-util-pushstream";
    version = osgi-version;
    license = osgi-license;
    src = osgi-src;
    srcDir = "org.osgi.util.pushstream/src";
    deps = [
      annotation-versioning
      util-function
      util-promise
    ];
  };

  util-tracker = buildJavaPackage {
    pname = "osgi-util-tracker";
    version = osgi-version;
    license = osgi-license;
    src = osgi-src;
    srcDir = "org.osgi.util.tracker/src";
    deps = [
      annotation-versioning
      framework
    ];
  };

  service-log = buildJavaPackage {
    pname = "osgi-service-log";
    version = osgi-version;
    license = osgi-license;
    src = osgi-src;
    srcDir = "org.osgi.service.log/src";
    deps = [
      annotation-versioning
      framework
      util-pushstream
    ];
  };

  service-resolver = buildJavaPackage {
    pname = "osgi-service-resolver";
    version = osgi-version;
    license = osgi-license;
    src = osgi-src;
    srcDir = "org.osgi.service.resolver/src";
    deps = [
      annotation-versioning
      resource
      framework
    ];
  };

  service-url = buildJavaPackage {
    pname = "osgi-service-url";
    version = osgi-version;
    license = osgi-license;
    src = osgi-src;
    srcDir = "org.osgi.service.url/src";
    deps = [
      annotation-versioning
    ];
  };

  service-packageadmin = buildJavaPackage {
    pname = "osgi-service-packageadmin";
    version = osgi-version;
    license = osgi-license;
    src = osgi-src;
    srcDir = "org.osgi.service.packageadmin/src";
    deps = [
      annotation-versioning
      framework
    ];
  };

  service-permissionadmin = buildJavaPackage {
    pname = "osgi-service-permissionadmin";
    version = osgi-version;
    license = osgi-license;
    src = osgi-src;
    srcDir = "org.osgi.service.permissionadmin/src";
    deps = [
      annotation-versioning
    ];
  };

  service-condition = buildJavaPackage {
    pname = "osgi-service-condition";
    version = osgi-version;
    license = osgi-license;
    src = osgi-src;
    srcDir = "org.osgi.service.condition/src";
    deps = [
      annotation-versioning
    ];
  };

  service-condpermadmin = buildJavaPackage {
    pname = "osgi-service-condpermadmin";
    version = osgi-version;
    license = osgi-license;
    src = osgi-src;
    srcDir = "org.osgi.service.condpermadmin/src";
    deps = [
      annotation-versioning
      framework
      service-permissionadmin
    ];
  };

  service-startlevel = buildJavaPackage {
    pname = "osgi-service-startlevel";
    version = osgi-version;
    license = osgi-license;
    src = osgi-src;
    srcDir = "org.osgi.service.startlevel/src";
    deps = [
      annotation-versioning
      framework
    ];
  };

  service-component = buildJavaPackage {
    pname = "osgi-service-component";
    version = osgi-version;
    license = osgi-license;
    src = osgi-src;
    srcDir = "org.osgi.service.component/src";
    deps = [
      annotation-versioning
      framework
      service-condition
      dto
      util-promise
      namespace-extender
      annotation-bundle
    ];
  };

  service-event = buildJavaPackage {
    pname = "osgi-service-event";
    version = osgi-version;
    license = osgi-license;
    src = osgi-src;
    srcDir = "org.osgi.service.event/src";
    deps = [
      annotation-versioning
      annotation-bundle
      namespace-implementation
      framework
      service-component
    ];
  };

}
