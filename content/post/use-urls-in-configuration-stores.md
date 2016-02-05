---
date: "2016-02-04T21:35:52Z"
draft: true
title: "Note 1: Use URLs in Configuration"

tags: [Development, Configuration, URLs]
categories: [Field Notes]

---

Why use configuration values like this:

{{< highlight sh >}}
    SRVC_SCHEME="http"
    SRVC_HOST="some.host"
    SRVC_PORT="6667"
{{< /highlight >}}


When you could just use something like this?

{{< highlight sh >}}
    SRVC_URL="http://some.host:6667"
{{< /highlight >}}

Way too often I've seen URLs in configuration stores split up into multiple configuration values, like in the former example. This is problematic in a number of ways:

**Application code needs to do more work** by stitching together these disparate values into a full URL. E.g.:

{{< highlight go >}}
    url := SRVC_SCHEME + "://" + SRVC_HOST + ":" + SRVC_PORT
{{< /highlight >}}

**There's more configuration to look after.** Which is obviously bad. Also, although these values can be grouped next to each other in a config file, it's easy when editing that file to split them apart accidentally, obfuscating their relationship.

**It's easy to mistakenly hardcode one component** meaning if that component (say the port) is updated later, your app won't receive that configuration. This is common where the port starts out as a default port, and later is changed to something else, or if the scheme is changed from http to https. How many times have you seen something like this?

{{< highlight go >}}
    url := "http://" + host + ":" + port
{{< /highlight >}}

## Full URLs are more expressive

By using a full URL as a configuration value, you eliminate all of the abovementioned problems, and you are future-proofing the consumers of that configuration. Now it becomes easy to start with something like:

{{< highlight shell >}}
    SRVC_URL="http://some.host" 
{{< /highlight >}}

And later, as the service behind that URL evolves, you can simply update the config, migrating to HTTPS, using an alternate port, even moving the base of the service further down the path from the root, e.g.:

{{< highlight shell >}}
    SRVC_URL="https://some.host:123/v2"
{{< /highlight >}}

All with far less risk of breaking the consumers of that config. Hooray!

Of course, there are [times when you need just the hostname][needhostname], or just the port. Fortunately, most modern programming languages have splendid URL parsing support, so these refined values are never far away.

[needhostname]: https://nodejs.org/api/http.html#http_server_listen_port_hostname_backlog_callback
