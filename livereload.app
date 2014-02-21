#!/usr/bin/env perl

use EV;

use AnyEvent;
use AnyEvent::Log;

#$AnyEvent::Log::FILTER->level("debug");

use Mojolicious::Lite;

use AnyEvent::Socket;
use AnyEvent::Handle;

# TODO
# - websocket connections pool,
# - queueing if not connected,
# - moar docs,
# - reload specific urls,

get '/' => sub {
    my $self = shift;
    $self->stash('script_html', sprintf '<script src="%s"></script>', $self->url_for('/livereload')->to_abs );
    $self->render(format => 'html')
} => 'demo';
get '/livereload' => sub { $_[0]->render(format => 'js') };

my $queue;
websocket '/socket' => sub {
    my $self = shift;

    Mojo::IOLoop->stream($self->tx->connection)->timeout(300);

    $self->on(message => sub {
        AE::log notice => sprintf "Got line on ws: %s", $_[1];
    });

    $self->send(sprintf "Live reload connected to: %s", $self->url_for('current')->to_abs);

    $queue = sub { $self->send(@_) };
};

my %tcp_connections;
tcp_server undef, 8888 => sub {
    my ($fh, $host, $port) = @_;
    my $hdl; $hdl = AnyEvent::Handle->new(
        fh => $fh,
        on_eof => sub { shift->destroy() },
        on_read => sub {
            shift->push_read(line => sub {
                my ($hdl, $line) = @_;
                AE::log debug => sprintf "Got line: %s", $line;
                if ($queue) {
                    $queue->($line);
                    $hdl->push_write(sprintf "Sent '%s'\015\012", $line);
                }
                else {
                    my $msg = "WebSocket client not connected - ignoring";
                    AE::log notice => $msg;
                    $hdl->push_write($msg . "\015\012");
                }
            });
        },
    );

    $hdl->push_write(sprintf "Welcome %s:%s to websocket gateway\015\012", $host, $port);
    $tcp_connections{$hdl} = $hdl;
} => sub {
    my ($fh, $host, $port) = @_;
    AE::log info => "TCP listening on $host:$port.";
};

app->secrets(['Very secret passphrase']);
app->log->level('error');

app->start;

__DATA__
@@ livereload.js.ep
function LiveReload(url) {
    var ws = new WebSocket(url);
    ws.onmessage = function(event) {
        switch (event.data) {
            case 'reload':
                location.reload(true);
                break;
            default:
                console.log(event.data);
        };
    };

    ws.onclose = function () {
        setTimeout(function () { LiveReload(url) }, 1000);
    };
}

LiveReload('<%= url_for('/socket')->to_abs->scheme('ws') %>')

@@ demo.html.ep
% title 'Live reload demo page';
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title><%= title %></title>
    <script src="<%= url_for('/livereload')->to_abs %>"></script>
</head>
<body>

<h1>Live reload demo page</h1>
<div>Add following to your web page:</div>
<pre><%= $script_html %></pre>
</body>
</html>
