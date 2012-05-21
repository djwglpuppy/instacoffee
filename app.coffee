devport = 9100
express = require("express")
RedisStore = require('connect-redis')(express)


app = express.createServer(
    express.bodyParser(),
    express.cookieParser(),
    express.session({secret: "thisisnotthesecretyouarelookingfor",  store: new RedisStore})
)

app.configure ->
    @set('views', __dirname + '/views')
    @set('view engine', 'jade')

app.configure "development", ->
    @use(require('connect-assets')({
        src: __dirname + "/precompiled/"
        buildDir: __dirname + "/static/"
    }))
    @use(express.static(__dirname + '/static'))
    @use(this.router)
        

require("./routes")(app)

if app.settings.env is "development"
    app.listen(devport)
    console.log "Started on port #{devport} in Development Mode"
else
    app.listen(80)
    console.log "Started on port 80 in Production Mode"