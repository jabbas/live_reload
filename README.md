live_reload
===========

Automagic webpage reloader/refresher

DEPENDENCIES
------------
1. [perl](http://www.perl.org/) - tested with 5.16.2
2. [Mojolicious](http://mojolicio.us/) - modern perl framework for the web
3. [AnyEvent](https://metacpan.org/pod/AnyEvent) (pulled by the previous one by default)

Your web browser need to support WebSockets!

HOWTO
-----

1. Start the app:
```
./livereload
```
2. Add following to webpage:
```html
<script src="http://localhost:3000/livereload"></script>
```
3. Send ```reload``` to port ```8888``` on machine you launched the app (eg.: ```echo reload | nc localhost 8888```)

4. Go to [http://localhost:3000/](http://localhost:3000/) for demo page

WHY YOU NEED IT?
----------------

You can use it in your favorite editor to reload the web page after saving the file (even automagically when editor supports adding custom actions after saving the file)

TODO
----
- moar docs!!!
- vim plugin
- configurable listening ports
- websocket connections pool
- queueing if not connected
- reloading specific urls only
- refreshing css without full page reload
- chrome/chromium plugin
- listen on unix socket
- cpanify and publish on CPAN
