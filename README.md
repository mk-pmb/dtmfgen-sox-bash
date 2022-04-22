
<!--#echo json="package.json" key="name" underline="=" -->
dtmfgen-sox-bash
================
<!--/#echo -->

<!--#echo json="package.json" key="description" -->
Bash script using SoX to generate DTMF tones.
<!--/#echo -->



Usage
-----

```bash
# Dial with default settings
./dtmfgen-sox-bash.sh dtmfgen-sox-bash 0191011

# Full volume and ludicrous speed
./dtmfgen-sox-bash.sh vol=1 dura=0.01 gap=0 0191011
```


Options
-------

* `vol=` Volume, as a fraction of full loudness.
* `dura=` Tone duration, in seconds.
* `gap=` Pause between tones, in seconds.



<!--#toc stop="scan" -->



Known issues
------------

* Needs more/better tests and docs.




&nbsp;


License
-------
<!--#echo json="package.json" key=".license" -->
ISC
<!--/#echo -->
