+++
date = "2016-02-05T02:07:55Z"
draft = true
title = "Note 3: Log, Die, Trap, Cleanup: Writing safe, verbose shell scripts"

+++

I alwas like my shell scripts to talk to me to tell me what they're doing. I also like them to exit in an appropriate way when something goes wrong, and offer me an explanation as to what happened. Therefore I tend to start a lot of my scripts with a little ditty I call "Log, Die, Trap, Cleanup", which lets me achieve clean logging, simple exit-with-message syntax, basig signal handling, and removing all child process to protect against zombies.

TODO: Explain each one along with the code and rationale
TODO: I don't put these in their own files: why? Because I would get too used to them and start presuming they were builtins.


