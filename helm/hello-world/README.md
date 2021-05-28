# Hello World

This is my first self made chart.

# Usage

```bash
$ helm install hello-world ./hello-world --create-namespace lab
```

# Update image version

```bash
$ helm upgrade -i --set image.tag=2.0 hello-world ./hello-world -n lab
```