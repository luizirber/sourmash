workflow "release" {
  on = "push"
  resolves = [
    "ross/python-actions/twine@45ba52e43ce91d9a1e623071d7ec7c9076cc28ae",
    "build sdist",
    "Only on master",
  ]
}

action "Only on master" {
  uses = "actions/bin/filter@3c98a2679187369a2116d4f311568596d3725740"
  args = "branch master"
}

action "ross/python-actions/twine@45ba52e43ce91d9a1e623071d7ec7c9076cc28ae" {
  uses = "ross/python-actions/twine@45ba52e43ce91d9a1e623071d7ec7c9076cc28ae"
  env = {
    TWINE_REPOSITORY_URL = "https://test.pypi.org/legacy/"
  }
  secrets = ["TWINE_USERNAME", "TWINE_PASSWORD"]
  needs = ["build sdist"]
}

action "only on tag" {
  uses = "actions/bin/filter@3c98a2679187369a2116d4f311568596d3725740"
  runs = "tag"
}

action "build sdist" {
  uses = "ross/python-actions/setup-py/3.7@b01151c680e98ff9a426c700720bde8891394557"
  needs = ["only on tag"]
  args = "sdist"
}
