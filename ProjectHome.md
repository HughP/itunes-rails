# iTunesRails 0.8.1 #

This open source project provides a web interface to the iTunes application running on the same machine. iTunesRails allows people sharing a work space and local computer network to control a common iTunes instance and shared music collection. It can also be used for events and parties. The mission of iTunesRails is to help make music-playing in common spaces more social and collaborative.

While the computer running iTunesRails must be running Mac OS X 10.5, anyone on the local network can queue songs on iTunesRails as long as they have a computer with a web browser.

This project was cooked up by Daniel Choi and Mackenzie Cowell to use in Betahouse, a coworking space for web developers in Cambridge, Massachusetts. Colin Nederkoorn subsequently joined the project to help design the user interface and feature set.

![http://itunes-rails.googlecode.com/files/screenshot-rel-0.5d.png](http://itunes-rails.googlecode.com/files/screenshot-rel-0.5d.png)

![http://itunes-rails.googlecode.com/files/screenshot-rel-0.5d-safari.png](http://itunes-rails.googlecode.com/files/screenshot-rel-0.5d-safari.png)

## Requirements ##

OS X Leopard (10.5) is required because iTunesRails uses the Cocoa Scripting Bridge and the Leopard version of RubyCocoa. The project was also built using the Ruby on Rails framework, which comes preinstalled with Leopard.

## How To Download and Run ##

To download the program, open a Terminal and cd to any directory where you want to keep the itunes-rails program. Then type this command to retrieve the code:

```
svn checkout http://itunes-rails.googlecode.com/svn/trunk/ itunes-rails
```

Once the code is checked out from the code repository, type

```
cd itunes-rails
```

and then

```
mongrel_rails start
```

This should start itunes-rails. Open a web browser to the URL

```
http://localhost:3000 
```

You should see the itunes-rails web interface.

To let other people on your local network access the same interface, make sure you turn on Web Sharing in the Sharing System Preferences panel. People should be able to hit itunes-rails using your computer's website address as indicated by the Sharing Preferences panel, with ":3000" appended to it.

iTunesRails is still evolving. To get the latest features and bugfixes, cd into your itunes-rails directory and type

```
svn up
```

This should update the code. Then stop the mongrel\_rails process (with Control-C) if you haven't already and restart it with "mongrel\_rails start".

To let other people easily drop in audio files and have them automatically added to the iTunes library running behind iTunesRails, you can set up a shared folder with the appropriate Automator folder actions. A more detailed guide on this is forthcoming.

Feel free to report any problems or feature suggestions via the Issues tab above.

Enjoy music, enjoy life.

## Planned Features and Improvements ##

  * integration with LastFM user accounts
  * packaging the whole application as a standard Apple OS X app (but still with the web interface), so that it's easy for non-programmers to download, install, launch, and update
  * make the application automatically attempt to fetch missing album artwork over the web if it's not currently available in the local iTunes library


## Release Notes ##

### Version 0.0 (March 25, 2008) ###
Mackenzie Cowell and Dan Choi come up with the idea for this project. Mac volunteers to turn his spare Mac Mini into a betahouse iTunes music server. Dan starts studying the Cocoa Scripting Bridge and gets ready to code the project.

### Version 0.1 (April 2, 2008) ###
The maiden release. We have some ideas about future features, e.g. Ajax, but suggestions are appreciated.

### Version 0.2 (April 3, 2008) ###
Added album cover art, plus Ajax interaction to minimize unnecessary page refreshes.

### Version 0.3 (April 3, 2008) ###
Stability improvements. Added artist list left sidebar for easier navigation.

### Version 0.4 (April 5, 2008) ###
Added the ability to batch-add tracks to the queue. Miscellaneous bugfixes and CSS improvements. Now using JQuery in addition to the Prototype javascript library.

### Version 0.5 (April 5, 2008) ###
Added automatic periodical updating of the currently playing song. Minor layout improvements.

### Version 0.6 (April 8, 2008) ###
Added the ability reorder upcoming tracks in the queue. Re-implemented batch queuing to use (slightly) more efficient makeObjectsPerformSelector:withObject method.

### Version 0.7 (April 8, 2008) ###
Major improvements in reliability of pause/play, skip, and previous track.

### Version 0.8 (April 11, 2008) ###
Much faster batch queueing of tracks.

### Version 0.8.1 (April 12, 2008) ###
Faster sorting of tracks by column.
