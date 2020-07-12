# NetworkBootstrap API

## Structure

The plugin adds `NetworkBootstrap` singleton to the project; the singleton
automatically read the project level settings (that can be overridden
through command line settings), and perform a server or client connection
on request.

The request can be performed explicitly using the provided API, or 
automatically by adding a custom node called `NetworkLink` to your scene.

`NetworkLink` can be found as a child of the basic `Node` entity, in the
node creation dialog.


## Top-level Options

This plugin adds the folloing elements in `ProjectSettings`:

* `application/network/applicaiton_type`: Can be `server` (0), `client` (1) or `both` (2).
* `application/network/host`: The host to connect to as a client.
* `application/network/port`: Networking port to listen to as a server, or to connect to as a client.
* `application/network/enable_cmd_line`: if true, command line options can override 
   project settings. 

The settings can be changed manually before each run to have an instance 
behaving as a client or a server. 

> __Tip__: You may want to open two Godot instances to run either the server
or the client, but be careful working only on one (suggests the server, for
convention). Also, you may want to set the debugger port in the `Editor/Setting`
menu, under `Network/Debug/Remote Port`, to debug server and client at the same time.

When working with two instances open, each time you restart your test application
from Godot, remember to change the options as you need, because saving the project
settings from any Godot editor will leak them into all the open instances. 

If you prefer, you can change the `editor/main_run_args`, and set up the
command line parameters as you need; however, this setting will be changed in all
instances too.

> __Tip__: Godot 4 is planned to have per-run command line options you can set on the fly.

### The "both" mode

In `both` mode, the plugin acts both as a client and a server. It opens a server connection,
so pure clients can connect to it, but whenever your application wants to check if its (also) 
a client, it will be told it is. However, this will not propagate server-side RPC calls
automatically; godot doesn't support intra-applicaiton loopback connections. Be sure to use
the `remotesync` keyword in place of `remote` for all the procedures that need to behave as
if the server was also a client.

> **NOTE**: in `both` mode, the host will always be overridden as `localhost`.

## Command Line Options

* `--nbs-type`: override the application type. Use the numbers as described in the 
  top-level option section.
* `--nbs-host`: The host where to connect to as a client.
* `--nbs-port`: The port where to connect to as a client, or to listen as a server.

## NetworkBootstrap API

The NetworkBootstrap autoload singleton offer the following methods and properties

### `get_connection_peer()`
Returns a connected network peer, that you can use directly or set in your scene tree 
for automated RPC:

```
    get_tree().network_peer = NetworkBootstrap.get_connection_peer()
```

### `is_server()`

True if this application is in _server_ or _both_ modes.

### `is_client()`

True if this application is in _client_ or _both_ modes.

### `is_server_client()`

True if this application is in _both_ mode.

### `application_type`

Property describing which kind of application is this. Can be:

    - `APPLICATION_TYPE_SERVER`=0
	- `APPLICATION_TYPE_CLIENT`=1
	- `APPLICATION_TYPE_BOTH`=2
    
You can set programmatically this property _before_ calling 
`get_connection_peer` for the first time. 

Command line parameters will override also programmatically set values;
you can disable command line parsing by setting the
`application/network/allow_cmd_line` project setting to _false_.

### `host`

The (string) host where you are connecting as a client.

You can set programmatically this property _before_ calling 
`get_connection_peer` for the first time. 

Command line parameters will override also programmatically set values;
you can disable command line parsing by setting the
`application/network/allow_cmd_line` project setting to _false_.

### `port`

The (numeric) port where you are connecting.

You can set programmatically this property _before_ calling 
`get_connection_peer` for the first time. 

Command line parameters will override also programmatically set values;
you can disable command line parsing by setting the
`application/network/allow_cmd_line` project setting to _false_.
