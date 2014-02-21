live_reload
===========

Automagic webpage reloader/refresher

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


WHY YOU NEED IT?
----------------

You can use it in your favorite editor to reload the web page after saving the file (even automagically when editor supports adding custom actions after saving the file)

TODO
----
- moar docs!!!
- configurable listening ports
- websocket connections pool
- queueing if not connected
- reloading specific urls only
- refreshing css without full page reload
- chrome/chromium plugin
- listen on unix socket
