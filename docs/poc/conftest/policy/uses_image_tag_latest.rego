# @title: Image tag ":latest" used
# @description: It is best to avoid using the ":latest' image tag when deploying containers in production. Doing so makes it hard to track which version of the image is running, and hard to roll back the version.
# @recommended_actions: Use a specific container image tag that is not "latest".
# @severity: Low
# @id: KSV013
# @links: 

package main

import data.lib.kubernetes

default checkUsingLatestTag = false

# getTaggedContainers returns the names of all containers which
# have tagged images.
getTaggedContainers[container] {
    allContainers := kubernetes.containers[_]
    [x, y] := split(allContainers.image, ":")
    y != "latest"
    container := allContainers.name
}

# getUntaggedContainers returns the names of all containers which
# have untagged images or images with the latest tag.
getUntaggedContainers[container] {
    container := kubernetes.containers[_].name
    not getTaggedContainers[container]
}

# checkUsingLatestTag is true if there is a container whose image tag
# is untagged or uses the latest tag.
checkUsingLatestTag {
  count(getUntaggedContainers) > 0
}

# NOTE: Refactored for the POC from deny[msg] to violation[{"msg": msg, "title": title}]
violation[{"msg": msg, "title": "Image tag \":latest\" used", "container": container}] {
  checkUsingLatestTag

  container := getUntaggedContainers[_]

  msg := kubernetes.format(
    sprintf(
      "container %s of %s %s in %s namespace should specify image tag",
      [getUntaggedContainers[_], lower(kubernetes.kind), kubernetes.name, kubernetes.namespace]
    )
  )
}
