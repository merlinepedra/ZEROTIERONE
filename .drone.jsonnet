
local targets = [
      // { "os": "linux", "name": "el9", "isas": [ "amd64" ], "events": ["push", "tag" ] },
      // { "os": "linux", "name": "el8", "isas": [ "amd64" ], "events": ["push", "tag" ] },
      // { "os": "linux", "name": "el7", "isas": [ "amd64" ], "events": ["push", "tag" ] },
      // { "os": "linux", "name": "fc37", "isas": [ "amd64" ], "events": ["push", "tag" ] },
      // { "os": "linux", "name": "fc36", "isas": [ "amd64" ], "events": ["push", "tag" ] },
      // { "os": "linux", "name": "fc35", "isas": [ "amd64" ], "events": ["push", "tag" ] },
      // { "os": "linux", "name": "amzn2", "isas": [ "amd64" ], "events": ["push", "tag" ] },
      // { "os": "linux", "name": "jammy", "isas": [ "amd64", "arm64", "armv7", "riscv64", "ppc64le", "s390x" ], "events": ["push", "tag" ] },
      // { "os": "linux", "name": "focal", "isas": [ "amd64" ], "events": ["push", "tag" ] },
      // { "os": "linux", "name": "bionic", "isas": [ "amd64" ], "events": ["push", "tag" ] },
      // { "os": "linux", "name": "xenial", "isas": [ "amd64" ], "events": ["push", "tag" ] },
      // { "os": "linux", "name": "trusty", "isas": [ "amd64" ], "events": ["push", "tag" ] },
      // { "os": "linux", "name": "bookworm", "isas": [ "amd64", "386", "mips64le" ], "events": ["push", "tag" ] },
      // { "os": "linux", "name": "bullseye", "isas": [ "amd64" ], "events": ["push", "tag" ] },
      // { "os": "linux", "name": "buster", "isas": [ "amd64" ], "events": ["push", "tag" ] },
      // { "os": "linux", "name": "stretch", "isas": [ "amd64" ], "events": ["push", "tag" ] },
      // { "os": "linux", "name": "jessie", "isas": [ "amd64" ], "events": ["push", "tag" ] },

      //
      // this is the cononical list, so don't futz with this while experimenting
      //

      { "os": "linux", "name": "el9", "isas": [ "amd64", "arm64", "ppc64le", "s390x" ], "events": ["push", "tag" ] },
      { "os": "linux", "name": "el8", "isas": [ "amd64", "arm64", "ppc64le", "s390x" ], "events": ["push", "tag" ] },
      { "os": "linux", "name": "el7", "isas": [ "amd64", "ppc64le"], "events": ["push", "tag" ] },
      { "os": "linux", "name": "amzn2", "isas": [ "amd64", "arm64" ], "events": ["push", "tag" ] },
      { "os": "linux", "name": "fc37", "isas": [ "amd64", "arm64", "ppc64le", "s390x" ], "events": ["push", "tag" ] },      
      { "os": "linux", "name": "fc36", "isas": [ "amd64", "arm64", "armv7", "ppc64le", "s390x" ], "events": ["push", "tag" ] },
      { "os": "linux", "name": "fc35", "isas": [ "amd64", "arm64", "armv7", "ppc64le", "s390x" ], "events": ["push", "tag" ] },
      // { "os": "linux", "name": "jammy", "isas": [ "amd64", "arm64", "armv7", "riscv64", "ppc64le", "s390x" ], "events": ["push", "tag" ] },
      // { "os": "linux", "name": "focal", "isas": [ "amd64", "arm64", "armv7", "riscv64", "ppc64le", "s390x" ], "events": ["push", "tag" ] },
      // { "os": "linux", "name": "bionic", "isas": [ "amd64", "arm64", "armv7", "386", "ppc64le", "s390x" ], "events": ["push", "tag" ] },
      // { "os": "linux", "name": "xenial", "isas": [ "amd64", "arm64", "armv7", "386", "ppc64le", "s390x" ], "events": ["push", "tag" ] },
      // { "os": "linux", "name": "trusty", "isas": [ "amd64", "arm64", "armv7", "386", "ppc64le" ], "events": ["push", "tag" ] },
      // { "os": "linux", "name": "bookworm", "isas": [ "amd64", "arm64", "armv7", "386", "mips64le", "ppc64le", "s390x" ], "events": ["push", "tag" ] },
      // { "os": "linux", "name": "bullseye", "isas": [ "amd64", "arm64", "armv7", "386", "mips64le", "ppc64le", "s390x" ], "events": ["push", "tag" ] },
      // { "os": "linux", "name": "buster", "isas": [ "amd64", "arm64", "armv7", "386", "mips64le", "ppc64le", "s390x" ], "events": ["push", "tag" ] },
      // { "os": "linux", "name": "stretch", "isas": [ "amd64", "arm64", "armv7", "386" ], "events": ["push", "tag" ] },
      // { "os": "linux", "name": "jessie", "isas": [ "amd64", "armv7", "386" ], "events": ["push", "tag" ] },
      // { "os": "windows", "name": "win2k19", "isas": [ "amd64" ], "events": ["push", "tag" ] }
];

local Build(platform, os, isa, events) = {
  "kind": "pipeline",
  "type": "docker",
  "pull": "always",
  "name": platform + " " + isa + " " + "build",
  "clone": { "depth": 1 },
  "steps": [
    {
      "name": "build",
      "image": "registry.sean.farm/honda-builder",
      "commands": [ "./ci/scripts/build.sh " + platform + " " + isa + " " + "100.0.0+${DRONE_COMMIT_SHA:0:8}" + " " + "${DRONE_BUILD_EVENT}" ]
    },
    {
      "name": "list",
      "image": "registry.sean.farm/honda-builder",
      "commands": [ "ls -laR *" ]
    },
    // {
    //   "name": "sign",
    //   "image": "registry.sean.farm/honda-builder",
    //   "environment": {
    //     "GPGKEY": { "from_secret": "gpgkey" },
    //     "GPGKEY_PASSWORD": { "from_secret": "gpgkey_password" },
    //     "GPGKEY_NAME": { "from_secret": "gpgkey_name" }
    //   },
    //   "commands": [
    //     "echo signing packages...",
    //   ]
    // },
    // {
    //   "name": "publish firehose",
    //   "image": "appleboy/drone-scp",
    //   "settings": {
    //     "host": "download.sean.farm",
    //     "user": "drone",
    //     "key": { "from_secret": "ssh_key" },
    //     "passphrase": { "from_secret": "ssh_key_password" },
    //     "target": [ "/dist/bytey-firehose"],
    //     "source": [ platform ],
    //   },
    //   "when": { event: [ "push" ] },
    // },
    // {
    //   "name": "publish download",
    //   "image": "appleboy/drone-scp",
    //   "settings": {
    //     "host": "download.sean.farm",
    //     "user": "drone",
    //     "key": { "from_secret": "ssh_key" },
    //     "passphrase": { "from_secret": "ssh_key_password" },
    //     "target": [ "/dist/bytey"],
    //     "source": [ platform ],
    //   },
    //   "when": { event: [ "tag" ] },
    // },
    // {
    //   "name": "dpkg-scanpackages",
    //   "image": "appleboy/drone-ssh",
    //   "settings": {
    //     "host": "download.sean.farm",
    //     "user": "drone",
    //     "key": { "from_secret": "ssh_key" },
    //     "passphrase": { "from_secret": "ssh_key_password" },
    //     "script": [ "dpkg-scanpackages --multiversion -h sha256 /dist/bytey-firehose/" + platform + " > /dist/bytey-firehose/" + platform + "/Packages" ]
    //   },
    //   "when": { event: [ "push" ] },
    // },
    // {
    //   "name": "artifactory",
    //   "image": "jmccann/drone-artifactory:3",
    //   "url": "https://artifactory.sean.farm",
    //   "repo_key": "bytey-firehose-rpm",
    //   "secrets": [ artifactory_username, artifactory_password ],
    //   "files": [ platform + "/*.deb" ]
    // }
  ],
  "image_pull_secrets": [ "dockerconfigjson" ],
  [ if isa == "arm64" || isa == "armv7" then "platform" ]: { os: os, arch: "arm64" },
  "trigger": { "event": events }
};

local Test(platform, os, isa, events) = {
  "kind": "pipeline",
  "type": "docker",
  "pull": "always",
  "name": platform + " " + isa + " " + "test",
  "clone": { "depth": 1 },
  "steps": [
    {
      "name": "test",
      "image": "registry.sean.farm/honda-builder",
      "commands": [ "./ci/scripts/test.sh " + platform + " " + isa + " " + "100.0.0+${DRONE_COMMIT_SHA:0:8}" ]
    }
  ],
  "image_pull_secrets": [ "dockerconfigjson" ],
  depends_on: [ platform + " " + isa + " " + "build" ],
  [ if isa == "arm64" || isa == "armv7" then "platform" ]: { os: os, arch: "arm64" },
  "trigger": { "event": events }
};

// puttin on the bits

std.flattenArrays([
  [
     Build(p.name, p.os, isa, p.events)
      for isa in p.isas
  ]
  // [
  //   Test(p.name, p.os, isa, p.events)
  //     for isa in p.isas
  // ]
  for p in targets
])
