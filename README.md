# rtl-download

The app looks for MPEG-4 videos (with `.mp4` file extension) on [RTL Télé Lëtzebuerg](http://www.rtl.lu/) web pages, downloads the files from the host server and lets you save the files locally. The app runs as streaming proxy out-of-the-box thanks to Sinatra's [streaming API](http://sinatrarb.com/contrib/streaming.html), which means you should not be visible to the host server.

## Usage

### Web frontend

The app comes with a simple web frontend powered by Ruby, Sinatra and Puma. You can start the app with `foreman start`, `ruby app.rb` or use the `Procfile` for cloud deployments.

<img src="https://github.com/schopenhauer/rtl-download/blob/master/screenshot.png" width="550">

### Command-line usage

Alternatively, you can hit the command line to use the app. By default, the app will download the high quality video (`480p`).

```
Usage: ruby dl.rb <URL> [options]
    -1, --low                        Low quality (144p)
    -2, --average                    Average quality (240p)
    -3, --high                       High quality (480p)
    -4, --highest                    Highest quality (720p)
    -l, --legacy                     Use legacy parser
    -h, --help                       Show help message
```

### Example

The shell version should produce something like this:

```
$ ruby dl.rb http://www.rtl.lu/letzebuerg/1285357.html

Parsing: http://www.rtl.lu/letzebuerg/1285357.html (quality: 480p)
Found: 5 videos
Downloading: https://replay.rtl.lu/2019/01/04/c20cdd30-1050-11e9-9eba-0242ac110008_REPLAY_480p.mp4
Saved: c20cdd30-1050-11e9-9eba-0242ac110008_REPLAY_480p.mp4
Downloading: https://replay.rtl.lu/2019/01/03/bbbcc914-0f87-11e9-b532-0242ac110008_REPLAY_480p.mp4
Saved: bbbcc914-0f87-11e9-b532-0242ac110008_REPLAY_480p.mp4
Downloading: https://replay.rtl.lu/2019/01/02/f5a8ceda-0ebe-11e9-a5d7-0242ac110008_REPLAY_480p.mp4
Saved: f5a8ceda-0ebe-11e9-a5d7-0242ac110008_REPLAY_480p.mp4
Downloading: https://replay.rtl.lu/2019/01/01/a967c248-0df5-11e9-8dff-0242ac110008_REPLAY_480p.mp4
Saved: a967c248-0df5-11e9-8dff-0242ac110008_REPLAY_480p.mp4
Downloading: https://replay.rtl.lu/2018/12/31/699e3814-0d2c-11e9-92c2-0242ac110008_REPLAY_480p.mp4
Saved: 699e3814-0d2c-11e9-92c2-0242ac110008_REPLAY_480p.mp4
```

## Credits

* [Ruby](https://www.ruby-lang.org/en/), [Sinatra](http://sinatrarb.com/) and [Puma](http://puma.io/)
* [Milligram](https://milligram.io/) CSS framework

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## License

The app is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
