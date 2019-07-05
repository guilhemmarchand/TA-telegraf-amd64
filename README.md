# Sample Splunk Technical Addon to run Telegraf as a Splunk application

## This is an example of a ready to use Splunk Technology Addon to run Telegraf published as a Splunk application


Telegraf deployment as Splunk application deployed by Splunk (TA)
-----------------------------------------------------------------

You can publish Telegraf through a Splunk application that you push to your clients using a Splunk deployment server.

This means that you can create a custom Technology Addon (TA) that contains both the Telegraf binary and the telegraf.conf configuraton files.

**This method has several advantages:**

- If you are a Splunk customer already, you may have the Splunk Universal Forwarder deployed on your servers, you will NOT need to deploy an additional collector independently from Splunk

- You get benefit from the Splunk centralisation and deploy massively Telegraf from Splunk

- You can maintain and upgrade Telegraf just as you do usually in Splunk, all from your Splunk Deployment Server. (DS)

**To achieve this, you need to:**

- Create a package in your Splunk Deployment Server, let's call it "TA-telegraf-linux-amd64", if you have more than this architecture to maintain, just reproduce the same steps for other processor architectures. (arm, etc)

```
    $SPLUNK_HOME/etc/deployment-server/TA-telegraf-linux-amd64
                                                        /bin
                                                        /local/telegraf.conf
                                                        /metadata/default.meta
```

- The "bin" directory hosts the Telegraf binary

- The "local" directory hosts the telegraf.conf configuration file

- The "metadata" directory is a standard directory that should contain a default.meta which in the context of the TA will contain:

*default.meta*

```
    # Application-level permissions
    []
    owner = admin
    access = read : [ * ], write : [ admin ]
    export = system
```

- Download the last Telegraf version for your processor architecture (here amd64), and extract its contain in the "bin" directory, you will get:

```

    bin/telegraf/etc
    bin/telegraf/usr
    bin/telegraf/var
```

- Telegraf provides an "init.sh" script that we will use to manage the state of the Telegraf process:

```
    bin/telegraf/usr/lib/telegraf/scripts/init.sh
```

*This addon used a copy of this script with minor modifications for our context*

**Finally, create a very simple local/inputs.conf configuration file:**

*local/inputs.conf*

```
    # start telegraf at Splunk start, and restart if Splunk is restarted. (which allows upgrading easily Telegraf binaries shipped with the TA package)
    [script://./bin/init.sh restart]
    disabled = false
    interval = -1
```

**Upgrades:**

To upgrade Telegraf binary to a new version, simply extract the new tgz release in the "bin" directory, and reload your Splunk Deployment server.

Splunk will automatically restart the Telegraf process after Splunk startup.

