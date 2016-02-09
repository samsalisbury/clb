# Executable Contracts

## Preamble

Back in the bad the old days, we deployed one application per VM. Individual teams looked after their VMs and their apps running on them, and all was calm. Ish.

Back then, apps generally had a huge amount of overhead in terms of CPU, memory, and disk. They consumed each other by hard-coded URLs and DNS. Things moved slowly, and kind of worked OK. Ish.

When it came to logging, monitoring, and alerting, some teams took on the overhead of building infrastructure around this for their one small application. There were no where near as manny apps back then. Not all teams did, however, and so some applications were not well monitored.

Fast forward 3 years, and we have an explosion of applications, many of which are running in the ephemeral cloud that is Mesos. We have a centralised logging system, service discovery allowing these apps to talk to each other, Docker for packaging, Graphite and Grafana for stats monitoring, Sensu for alerting, and Pagerduty for waking us up in the middle of the night. Progress.

However, all this new technology presents a new set of problems, which can really be framed as amazing opportunities for reducing effort, and allowing us to improve productivity, agility, and system stability. The trouble is, many of the old assumptions we made about application development can prevent us from getting the best out of our new shiny platform.

## Why contracts

Over the years, and at present at OpenTable, we have had many good ideas about particular standards that would greatly improve our platform ("platform" in the broad sense of the word). Recently, these standards have fallen into the following categories:

- **Logging standards** (or the lack thereof) has been one of the biggest pain points for Operations over the past year or more. We can use contracts to test conformity to these up-front.
- **Conserved Headers** have the potential to give us amazing insight into the inner workings of our system, but they only work if everyone uses them.
- **Discovery announcements** need to behave in a very specific way, if we are to use the discovery system to its potential to eliminate downtime caused by the simple fact that you redeployed your app.
- **Startup and shutdown timing** is very important in ephemeral cloud based deployment media like Mesos. Operations require the freedom to tear down and replace nodes on a moment's notice. If an application refuses to exit when asked, or even if it takes a long time to start up on the node it was moved to, then problems ensue, and operations are sometimes forced to use a hammer to rip your application down, leading to avoidable downtime.
- **Startup in the absence of depended-on services** if your application does not start up, and keep running indefinitely, in the absence of its external dependencies, then it will be able to take part in cascading failures, where chains of dependent services all start and die rapidly in a pulsating mess that can cripple Mesos clusters, and lead to downtime.

All of these ideas are worthy of being implemented. The problem is that this can be difficult, especially if you're not sure of the exact specification, written as it is in plain english in the wiki, or in an email. Even if you understand the specification, if you really mean to conform to it, you need to write not only the feature, but also test to ensure you don't break it in future. That is a lot of work, especially when your project manager is baying for features! (I know you don't do that really, PMs :P)

Executable contracts are designed to solve two of these problems.

1. They are readable, and precise (or will be after a few more iterations). It is possible to write integration tests of the contract kind in any programming language. However, the scope of things we want to test using these contracts is much smaller than the scope of things a general purpose programming language can do. So, in order to imrove readability and understandability, these contracts are written in a declarative DSL which exposes only the necessary features.
2. The contract is the test. There is no need for each team, or the developers of each application, to implement separate tests for each application. Since we are using containers, we have a well-known interface against which to run these contracts, enabling the exact same code to be run against absolutely any container (e.g. a docker container).

## What they are not (and should never be)

Contracts should be viewed as aspirational goals, a set of gold standards for correct application behaviour. And in the main, they should be kept easily within reach to attain for any newly written project. However.

Contracts are not a club with which upper management should beat engineers. Contracts can be graded into:

- **The bare essentials** (i.e. contracts which nonconfirmity to will cause definite problems in prodution)
- **Correct behaviour** (i.e. contracts that specify all correct behaviours required for good living on Mesos.
- **Value added** (i.e. contracts which are optional, but which, if passed, open the door to extra platform features like automated deployments, automated monitoring, etc)

## Is there anything contracts can't do?

Yes. For example:

- Verify that an application behaves in the real world in the same way it does when invoked by a contract. Whilst every effort should go into making contracts difficult to fool, there will always be ways around this, enabling malicious or hapless engineers to pass a contract, whilst misbehaving when deployed IRL.
- Verify app-specific behaviour. Although the same DSL could be used to write other kinds of integration tests, possibly at application level. We should probably consider enabling this later.
-  

## Three big improvements

### Productivity
We have the potential to increase productivity in a number of ways:

- Spend less time setting up integration tests to verify that apps behave as expected when running on Mesos.
- Spend less time debugging apps which are failing due to unknown constraints when running on Mesos.
- TODO

### Agility
Operations will now have apps with a well-known interface, which they can more easily manipulate and monitor.

TODO: More on this

### System stability
Since certain behaviours of our applications will be known in the collective, we will be able to further tune our platform to improve stability. At the same time, some of the cntracts will be able to directly verify that things necessary for stability are implemented correctly.

TODO: More on this
