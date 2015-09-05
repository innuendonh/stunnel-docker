# stunnel-docker
Stunnel in a container. Builds on existing stunnel container with more setting options.

The base image allows configuring your stunnel by mounting configuration files in `/etc/stunnel/stunnel.d`.
Since it "happens" you do not work on the same host you have to run your container,
it may be useful to have configuration set in environment variables.

This container allows writing a `stunnel.conf` file and a `psk` file through a couple of settings in environment variables. There are other solutions that allow specifying a service configuration through single environment variables. This container allows specifying the content of entire configuration files, which is more flexible, allowing, e.g., to tunnel many services at once in a single container.

## Settings

Here follows the list of environment variables that can be set for this container.

* `SERVICE_CONF_FILE`: (optional) the path of the configuration file of the service/s you want to tunnel; default value is `/etc/stunnel/stunnel.d/service.conf`;
* `PSK_FILE`: (optional) the path of a PSK file you may want to use to configure your stunnel; default value is `/etc/stunnel/psk.txt`;
* `SERVICE_CONF_TEXT`: the entire content of `SERVICE_CONF_FILE`;
* `SERVICE_CONF_GZBASE64`: the entire content of `SERVICE_CONF_FILE`, gzipped and encoded in base64;
* `PSK_TEXT`: the entire content of `PSK_FILE`;
* `PSK_GZBASE64`: the entire content of `PSK_FILE`, gzipped and encoded in base64;

The precedence of the variables is:

* if the `_TEXT` variable is set, it is used;
* otherwise, if the `_GZBASE64` variable is set, it is used;
* otherwise, no file is written and startup goes on (maybe you mounted the config file as a volume...)

### A note on `_GZBASE64` variables

This is a bit of a hack,
to allow storing files of any encoding and whitespaces or newline in environment variables, which is sometimes troublesome.

To create a variable like that out of a `config_file.conf` you can do:

```bash
$(cat config_file.conf | gzip | base64)
```

### A note on `_TEXT` variables

Specifying configuration in its original form is obviously more readable than encoding it.
In Docker Compose, you can use this syntax to express a `MULTILINE` environment variable:

```yaml
environment:
  MULTILINE: |
    first line
    second line
    third line
  SINGLELINE: lone line
```
