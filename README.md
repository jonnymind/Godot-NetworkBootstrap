# Godot-NetworkBootstrap

Godot addon simplifying and automating the setup of server/client pairs.

## What is this?

High level networking is very simple in Godot, but setting up a client/server
pair is not so trivial. You need to set up project options and/or command line
parsers to decide which instance of your application is the server and which
are the clients, and the raw Godot interface doesn't help much with setting
run-specific parameters.

This Godot plugin adds:
* a _Project Setting_ section called Application/Network;
* an _autoload_ singleton called `NetworBootstrap` configuring hosts and 
  client peers automatically;
* a command line parser configuring the network options at start;
* a custom node called `NetworkLink` setting up the network scene.

## Usage

1. Download and copy the files under the `res://addons/` directory in your
project; you can optionally copy also the `example` subdirectory.
2. Open the `Project` panel and activate the `NetworkBootsrap` plugin.
3. Configure the new `Application/Network` project settings.
4. Add the `NetworkLink` node to your scene.
5. Use the multiplayer keywords as described in [Godot documentation](https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html).

See the README in the plugin directory for detailed instructions.

