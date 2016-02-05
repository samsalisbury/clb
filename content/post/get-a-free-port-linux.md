+++
date = "2016-02-05T01:09:54Z"
draft = true
title = "Note 2: Get a Free TCP Port on Linux using only Bash"

+++

Have you ever needed to grab a free TCP port on Linux to pass on to some hungry process that needs it?

Usually, needing to get a free port up-front yourself is a mistake, as even if a port is not being used at the time you check, by the time you want to bind to it, some other process may have taken it. Linux allows you to specify port 0 when you open a socket, which signals to the OS that you want any free port. How this works internally is a mystery to me at the moment, but as far as I know, it's the only bombproof way to get a guaranteed free port, if any are available.

However, I will insist that there are times when being able to ask the OS to name a currently-free port is incredibly useful. My use-case is in writing executable contracts which can test any given Docker image against a set of contracts defining acceptable behaviour when deployed on Mesos. Now, Mesos itself is able to provide free ports to tasks running there, so it must be possible using C++ and hitting stdlib, but what if you want to do this on arbitrary Linux boxes where you're running the tests? What if you need to construct a fleet of applications all talking to each other over certain ports, to simulate some particular scenario. What if you want to SSH to a box you've never used and ask it for a free port in order to achieve this?

Here's a little shell script I call `freeport` that does just that (although with a race condition[^1])

{{< highlight sh >}}
    #/bin/sh
    { nc -l 0 & } && PID=$!
    PORT=$(lsof -p $PID | grep TCP | cut -d ':' -f2 | cut -d ' ' -f1) 
    kill -15 $PID >/dev/null && echo $PORT
{{< /highlight >}}

The way this code works is:

1. Bind to a free OS-provided port using `nc` (netcat) listening on port zero: `nc -l 0`
2. Use `lsof` and some hairy slicing and dicing to find what TCP port `nc` glommed on to.
3. Kill `nc` to free up the port it was using.
4. Print the port to stdout using echo, so it can be passed to something else.

So, we've bound to a port, then given it up, and now we're supposed to bind to it again. Seems reasonable-ish, but there's always a chance another process may bind to that port between us running the script and using the port for our own purpoeses. However, there is a common implementation detail of many (all?) Linux distros, where the port given out by requesting port 0 is not re-given-out by that 'port 0' mechanism for as long as possible. That is, ports which are freed up and returned to the pool return in a big long queue, the most-recently-freed at the back of the queue. This means that at least for processes requesting port 0, it will usually be quite a long time until that port is up for grabs again.

Of course, as it's free, your process, or anyone elses, can simply bind to it no questions asked.

In practice, as long as there are no connection leaks on a machine, you should have plenty of time to bind to ports you find using freeport. I have been using this technique for a long time, without any test failures being attributed to it.

[^1]: Race condition
