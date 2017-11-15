# IVR to CLI

## Setup

Installing dependencies:

```
bundle install
```

Next, copy the `.env.sample` file to `.env` and fill in the necessary values there.

Start up [ngrok](https://ngrok.com/) with

```
ngrok http 5000
```

and then copy the HTTP URL there into your .env to open the tunnel.

To start the app:

```
$ foreman start
```

Open <http://localhost:5000> and check it out!

In the web UI, you can use the call command with `call +12223334444` replacing the phone number with the IVR you want to call, and then it should start a call to that IVR and populate text.

Copyright Dave Guarino 2017, MIT License

