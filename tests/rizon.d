import lu.conv : Enum;
import dialect;
import std.conv : to;

unittest
{
    IRCParser parser;
    parser.client.nickname = "kameloso^^";  // Because we removed the default value

    {
        immutable event = parser.toIRCEvent("AUTHENTICATE +");
        with (event)
        {
            assert((type == IRCEvent.Type.SASL_AUTHENTICATE), Enum!(IRCEvent.Type).toString(type));
            assert((content == "+"), content);
        }
    }

    {
        immutable event = parser.toIRCEvent(":irc.ircii.net 004 kameloso^^ irc.ircii.net plexus-4(hybrid-8.1.20) CDGNRSUWagilopqrswxyz BCIMNORSabcehiklmnopqstvz Iabehkloqv");
        with (event)
        {
            assert((type == IRCEvent.Type.RPL_MYINFO), Enum!(IRCEvent.Type).toString(type));
            assert((sender.address == "irc.ircii.net"), sender.address);
            assert((content == "CDGNRSUWagilopqrswxyz BCIMNORSabcehiklmnopqstvz Iabehkloqv"), content);
            assert((aux == "plexus-4(hybrid-8.1.20)"), aux);
            assert((num == 4), num.to!string);
        }
    }

    /*
    server.daemon = IRCServer.Daemon.hybrid;
    server.daemonstring = "plexus-4(hybrid-8.1.20)";
    */

    with (parser)
    {
        assert((server.daemon == IRCServer.Daemon.hybrid), Enum!(IRCServer.Daemon).toString(server.daemon));
        assert((server.daemonstring == "plexus-4(hybrid-8.1.20)"), server.daemonstring);
    }

    {
    immutable event = parser.toIRCEvent(":irc.ircii.net 005 kameloso^^ CALLERID CASEMAPPING=rfc1459 DEAF=D KICKLEN=180 MODES=4 PREFIX=(qaohv)~&@%+ STATUSMSG=~&@%+ EXCEPTS=e INVEX=I NICKLEN=30 NETWORK=Rizon MAXLIST=beI:250 MAXTARGETS=4 :are supported by this server");
        with (event)
        {
            assert((type == IRCEvent.Type.RPL_ISUPPORT), Enum!(IRCEvent.Type).toString(type));
            assert((sender.address == "irc.ircii.net"), sender.address);
            assert((content == "CALLERID CASEMAPPING=rfc1459 DEAF=D KICKLEN=180 MODES=4 PREFIX=(qaohv)~&@%+ STATUSMSG=~&@%+ EXCEPTS=e INVEX=I NICKLEN=30 NETWORK=Rizon MAXLIST=beI:250 MAXTARGETS=4"), content);
            assert((num == 5), num.to!string);
        }
    }

    /*
    server.daemon = IRCServer.Daemon.rizon;
    server.network = "Rizon";
    server.maxNickLength = 30;
    server.prefixes = "qaohv";
    server.caseMapping = IRCServer.CaseMapping.rfc1459;
    server.exceptsChar = 'e';
    server.invexChar = 'I';
    */

    with (parser)
    {
        assert((server.daemon == IRCServer.Daemon.rizon), Enum!(IRCServer.Daemon).toString(server.daemon));
        assert((server.network == "Rizon"), server.network);
        assert((server.maxNickLength == 30), server.maxNickLength.to!string);
        assert((server.prefixes == "qaohv"), server.prefixes);
        assert((server.caseMapping == IRCServer.CaseMapping.rfc1459), Enum!(IRCServer.CaseMapping).toString(server.caseMapping));
        assert((server.exceptsChar == 'e'), server.exceptsChar.to!string);
        assert((server.invexChar == 'I'), server.invexChar.to!string);
    }

    {
        immutable event = parser.toIRCEvent(":irc.ircii.net 005 kameloso^^ CHANTYPES=# CHANLIMIT=#:250 CHANNELLEN=50 TOPICLEN=390 CHANMODES=beI,k,l,BCMNORScimnpstz NAMESX UHNAMES AWAYLEN=180 ELIST=CMNTU SAFELIST KNOCK WATCH=60 :are supported by this server");
        with (event)
        {
            assert((type == IRCEvent.Type.RPL_ISUPPORT), Enum!(IRCEvent.Type).toString(type));
            assert((sender.address == "irc.ircii.net"), sender.address);
            assert((content == "CHANTYPES=# CHANLIMIT=#:250 CHANNELLEN=50 TOPICLEN=390 CHANMODES=beI,k,l,BCMNORScimnpstz NAMESX UHNAMES AWAYLEN=180 ELIST=CMNTU SAFELIST KNOCK WATCH=60"), content);
            assert((num == 5), num.to!string);
        }
    }

    /*
    server.maxChannelLength = 50;
    server.aModes = "beI";
    server.cModes = "l";
    server.dModes = "BCMNORScimnpstz";
    */

    with (parser)
    {
        assert((server.maxChannelLength == 50), server.maxChannelLength.to!string);
        assert((server.aModes == "beI"), server.aModes);
        assert((server.cModes == "l"), server.cModes);
        assert((server.dModes == "BCMNORScimnpstz"), server.dModes);
    }

    {
        immutable event = parser.toIRCEvent(":irc.rizon.no 352 kameloso^^ * ~NaN C2802314.E23AD7D8.E9841504.IP * kameloso^^ H :0  kameloso!");
        with (IRCEvent.Type)
        with (event)
        {
            assert((type == RPL_WHOREPLY), Enum!(IRCEvent.Type).toString(type));
            assert((sender.address == "irc.rizon.no"), sender.address);
            assert((target.nickname == "kameloso^^"), target.nickname);
            assert((target.ident == "~NaN"), target.ident);
            assert((target.address == "C2802314.E23AD7D8.E9841504.IP"), target.address);
            assert((content == "kameloso!"), content);
            assert((num == 352), num.to!string);
        }
    }
    {
        immutable event = parser.toIRCEvent(":irc.uworld.se 265 kameloso^^ :Current local users: 14552  Max: 19744");
        with (IRCEvent.Type)
        with (event)
        {
            assert((type == RPL_LOCALUSERS), Enum!(IRCEvent.Type).toString(type));
            assert((sender.address == "irc.uworld.se"), sender.address);
            assert((content == "Current local users: 14552  Max: 19744"), content);
            assert((num == 265), num.to!string);
        }
    }
    {
        immutable event = parser.toIRCEvent(":irc.uworld.se 266 kameloso^^ :Current global users: 14552  Max: 19744");
        with (IRCEvent.Type)
        with (event)
        {
            assert((type == RPL_GLOBALUSERS), Enum!(IRCEvent.Type).toString(type));
            assert((sender.address == "irc.uworld.se"), sender.address);
            assert((content == "Current global users: 14552  Max: 19744"), content);
            assert((num == 266), num.to!string);
        }
    }
    {
        immutable event = parser.toIRCEvent(":irc.rizon.no 265 kameloso^^ :Current local users: 16115  Max: 17360");
        with (IRCEvent.Type)
        with (event)
        {
            assert((type == RPL_LOCALUSERS), Enum!(IRCEvent.Type).toString(type));
            assert((sender.address == "irc.rizon.no"), sender.address);
            assert((content == "Current local users: 16115  Max: 17360"), content);
            assert((num == 265), num.to!string);
        }
    }
    {
        immutable event = parser.toIRCEvent(":irc.x2x.cc 307 kameloso^^ py-ctcp :has identified for this nick");
        with (IRCEvent.Type)
        with (event)
        {
            assert((type == RPL_WHOISREGNICK), Enum!(IRCEvent.Type).toString(type));
            assert((sender.address == "irc.x2x.cc"), sender.address);
            assert((target.nickname == "py-ctcp"), target.nickname);
            assert((content == "py-ctcp"), content);
            assert((num == 307), num.to!string);
        }
    }
    {
        immutable event = parser.toIRCEvent(":irc.uworld.se 513 kameloso :To connect type /QUOTE PONG 3705964477");
        with (IRCEvent.Type)
        with (event)
        {
            assert((type == ERR_NEEDPONG), Enum!(IRCEvent.Type).toString(type));
            assert((sender.address == "irc.uworld.se"), sender.address);
            assert((content == "PONG 3705964477"), content);
            assert((num == 513), num.to!string);
        }
    }
    {
        immutable event = parser.toIRCEvent(":irc.rizon.no 524 kameloso^^ 502 :Help not found");
        with (IRCEvent.Type)
        with (event)
        {
            assert((type == ERR_HELPNOTFOUND), Enum!(IRCEvent.Type).toString(type));
            assert((sender.address == "irc.rizon.no"), sender.address);
            assert((content == "Help not found"), content);
            assert((aux == "502"), aux);
            assert((num == 524), num.to!string);
        }
    }
    {
        immutable event = parser.toIRCEvent(":irc.rizon.no 472 kameloso^^ X :is unknown mode char to me");
        with (IRCEvent.Type)
        with (event)
        {
            assert((type == ERR_UNKNOWNMODE), Enum!(IRCEvent.Type).toString(type));
            assert((sender.address == "irc.rizon.no"), sender.address);
            assert((content == "is unknown mode char to me"), content);
            assert((aux == "X"), aux);
            assert((num == 472), num.to!string);
        }
    }
    {
        immutable event = parser.toIRCEvent(":irc.uworld.se 314 kameloso^^ kameloso ~NaN C2802314.E23AD7D8.E9841504.IP * : kameloso!");
        with (event)
        {
            assert((type == IRCEvent.Type.RPL_WHOWASUSER), Enum!(IRCEvent.Type).toString(type));
            assert((sender.address == "irc.uworld.se"), sender.address);
            assert((target.nickname == "kameloso"), target.nickname);
            assert((target.realName == "kameloso!"), target.realName);
            assert((target.ident == "~NaN"), target.ident);
            assert((target.address == "C2802314.E23AD7D8.E9841504.IP"), target.address);
            assert((content == "kameloso!"), content);
            assert((aux == "C2802314.E23AD7D8.E9841504.IP"), aux);
            assert((num == 314), num.to!string);
        }
    }
    {
        immutable event = parser.toIRCEvent(":irc.rizon.no 351 kameloso^^ plexus-4(hybrid-8.1.20)(20170821_0-607). irc.rizon.no :TS6ow");
        with (IRCEvent.Type)
        with (event)
        {
            assert((type == RPL_VERSION), Enum!(IRCEvent.Type).toString(type));
            assert((sender.address == "irc.rizon.no"), sender.address);
            assert((content == "plexus-4(hybrid-8.1.20)(20170821_0-607). irc.rizon.no"), content);
            assert((aux == "TS6ow"), aux);
            assert((num == 351), num.to!string);
        }
    }
    {
        immutable event = parser.toIRCEvent(":irc.rizon.no 315 kameloso^^ * :End of /WHO list.");
        with (event)
        {
            assert((type == IRCEvent.Type.RPL_ENDOFWHO), Enum!(IRCEvent.Type).toString(type));
            assert((sender.address == "irc.rizon.no"), sender.address);
            assert((content == "End of /WHO list."), content);
            assert((num == 315), num.to!string);
        }
    }
}

unittest
{
    IRCParser parser;

    with (parser)
    {
        client.nickname = "kameloso";
        client.user = "kameloso";
        client.ident = "NaN";
        client.realName = "kameloso IRC bot";
        server.address = "irc.rizon.net";
        server.port = 6667;
        server.daemon = IRCServer.Daemon.rizon;
        server.network = "Rizon";
        server.daemonstring = "rizon";
        server.aModes = "eIbq";
        server.bModes = "k";
        server.cModes = "flj";
        server.dModes = "CFLMPQScgimnprstz";
        server.prefixchars = ['v':'+', 'o':'@'];
        server.prefixes = "ov";
    }

    parser.typenums = typenumsOf(parser.server.daemon);

    {
        immutable event = parser.toIRCEvent(":NickServ!service@rizon.net NOTICE kameloso^ :Password incorrect.");
        with (event)
        {
            assert((type == IRCEvent.Type.AUTH_FAILURE), Enum!(IRCEvent.Type).toString(type));
            assert((sender.nickname == "NickServ"), sender.nickname);
            assert((sender.ident == "service"), sender.ident);
            assert((sender.address == "rizon.net"), sender.address);
            assert((content == "Password incorrect."), content);
        }
    }
    {
        immutable event = parser.toIRCEvent(":NickServ!service@rizon.net NOTICE kameloso^ :Password accepted - you are now recognized.");
        with (event)
        {
            assert((type == IRCEvent.Type.AUTH_SUCCESS), Enum!(IRCEvent.Type).toString(type));
            assert((sender.nickname == "NickServ"), sender.nickname);
            assert((sender.ident == "service"), sender.ident);
            assert((sender.address == "rizon.net"), sender.address);
            assert((content == "Password accepted - you are now recognized."), content);
        }
    }
    {
        immutable event = parser.toIRCEvent(":irc.rizon.club 338 kameloso^ kameloso^ :is actually ~kameloso@194.117.188.126 [194.117.188.126]");
        with (event)
        {
            assert((type == IRCEvent.Type.RPL_WHOISACTUALLY), Enum!(IRCEvent.Type).toString(type));
            assert((sender.address == "irc.rizon.club"), sender.address);
            assert((target.nickname == "kameloso^"), target.nickname);
            assert((target.address == "194.117.188.126"), target.address);
            assert((aux == "~kameloso@194.117.188.126"), aux);
            assert((num == 338), num.to!string);
        }
    }
}
