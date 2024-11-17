target "default" {
  context = "."
  dockerfile = "Dockerfile"
  tags = ["sffzh/aria2-ng:1.37.0", "sffzh/aria2-ng:latest", "sffzh/aria2-ng:1.37.0.001"]
  platforms = ["linux/amd64", "linux/386","linux/arm/v6"]
}