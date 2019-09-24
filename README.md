# dialect [![CircleCI Linux/OSX](https://img.shields.io/circleci/project/github/zorael/dialect/master.svg?maxAge=3600&logo=circleci)](https://circleci.com/gh/zorael/dialect) [![Travis Linux/OSX and documentation](https://img.shields.io/travis/zorael/dialect/master.svg?maxAge=3600&logo=travis)](https://travis-ci.org/zorael/dialect) [![Windows](https://img.shields.io/appveyor/ci/zorael/dialect/master.svg?maxAge=3600&logo=appveyor)](https://ci.appveyor.com/project/zorael/dialect) [![GitHub commits since last release](https://img.shields.io/github/commits-since/zorael/dialect/v0.2.1.svg?maxAge=3600&logo=github)](https://github.com/zorael/dialect/compare/v0.2.1...master)

IRC parsing library with support for a wide variety of server daemons.

Note that while IRC is standardised, servers still come in [many flavours](https://upload.wikimedia.org/wikipedia/commons/thumb/d/d5/IRCd_software_implementations3.svg/1533px-IRCd_software_implementations3.svg.png), some of which [outright conflict](http://defs.ircdocs.horse/defs/numerics.html) with others. If something doesn't immediately work, generally it's because we simply haven't encountered that type of event before, and so no rules for how to parse it have yet been written.

Used in the [kameloso](https://github.com/zorael/kameloso) bot. However, while dialect unavoidably caters to its needs it is independent from it. Likely some remnants of code that violate separation of concern still exist, and they are to be considered bugs.

**Please report bugs. Unreported bugs can only be fixed by accident.**

# What it looks like

API documentation can be found [here](https://zorael.github.io/dialect).

```d
struct IRCEvent
{
    enum Type { ... }  // large enum of IRC event types

    Type type;
    string raw;
    IRCUser sender;
    string channel;
    IRCUser target;
    string content;
    string aux;
    string tags;
    uint num;
    int count;
    int altcount;
    long time;
    string errors;

    version(TwitchSupport)
    {
        string emotes;
        string id;
    }
}

struct IRCUser
{
    enum Class { ... }

    Class class_;
    string nickname;
    string ident;
    string address;
    string account;
    long updated;

    version(TwitchSupport)
    {
        string alias_;
        string badges;
        string colour;
    }
}

struct IRCChannel
{
    struct Mode { ... }

    string name;
    Mode[] modes
    string modechars;
    string topic;
    string[][char] mods;
    bool[string] users;
}

struct IRCServer
{
    enum Daemon { ... }
    enum CaseMapping { ... }  // types of case-sensitivity

    string address;
    ushort port;
    Daemon daemon;

    // More internals
}

struct IRCClient
{
    string nickname;
    string user;
    string ident;
    string realName;
    IRCServer server;

    // More internals
}

struct IRCParser
{
    IRCClient client;

    IRCEvent toIRCEvent(const string);  // <--
}
```

# How to use

> This assumes you have a program set up to read information from an IRC server. This is not a bot framework; for that you're better off with the full [kameloso](https://github.com/zorael/kameloso) and writing a plugin that suits your needs.

Instantiate an `IRCParser` with an `IRCClient` (via constructor), and configure its members. Read a string from the server and parse it with `IRCParser.toIRCEvent(string)`.

Parsing is `@safe` with `IRCParser.toIRCEvent(string)`. It's additionally `pure` with `.toIRCEvent(IRCParser, string)` instead, but then you opt out on some features, including postprocessing (Twitch support so far). It uses exceptions to signal errors during parsing, so it's not `nothrow`. Some parts of it create new strings, so it can't be `@nogc`.

```d
IRCParser parser;

string fromServer = ":zorael!~NaN@address.tld MODE #channel +v nickname";
IRCEvent event = parser.toIRCEvent(fromServer);

with (event)
{
    assert(type == IRCEvent.Type.MODE);
    assert(sender.nickname == "zorael");
    assert(sender.ident == "~NaN");
    assert(sender.address == "address.tld");
    assert(target.nickname == "nickname");
    assert(channel == "#channel");
    assert(aux = "+v");
}

string alsoFromServer = ":cherryh.freenode.net 435 oldnick newnick #d " ~
    ":Cannot change nickname while banned on channel";
IRCEvent event2 = parser.toIRCEvent(alsoFromServer);

with (event2)
{
    assert(type == IRCEvent.Type.ERR_BANONCHAN);
    assert(sender.address == "cherryh.freenode.net");
    assert(channel == "#d");
    assert(target.nickname == "oldnick");
    assert(content == "Cannot change nickname while banned on channel");
    assert(aux == "newnick");
    assert(num == 435);
}

string furtherFromServer = ":kameloso^!~ident@81-233-105-99-no80.tbcn.telia.com NICK :kameloso_";
IRCEvent event3 = parser.toIRCEvent(furtherFromServer);

with (event3)
{
    assert(type == IRCEvent.Type.NICK);
    assert(sender.nickname == "kameloso^");
    assert(sender.ident == "~ident");
    assert(sender.address == "81-233-105-99-no80.tbcn.telia.com");
    assert(target.nickname = "kameloso_");
}
```

See the [`/tests`](/tests) directory for more example parses.

# Roadmap

* remove final non-bot-agnostic remnants

# License

This project is licensed under the **MIT** license - see the [LICENSE](LICENSE) file for details.
