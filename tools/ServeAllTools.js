const http = require('http');
const fs = require('fs');
let port = 24012;
let addr = "http://localhost:" + port;

//create a server object:
http.createServer(function (req, res) {
    let pathFileOrFolder = __dirname + req.url.replace("%20", " ");
    fs.readFile(pathFileOrFolder, function (err, data) {
        if (err) {
            try {
                let dir = fs.readdirSync(pathFileOrFolder);
                let parentUrl = req.url.split("/", 2).filter(Boolean);
                parentUrl = parentUrl.length > 1 ? parentUrl[0] : "/";
                let toDisplay = `
                <h1>Index of ${pathFileOrFolder}</h1>
                <table>
                <tbody><tr><th valign="top"><img src="${addr}/Images/blank.gif" alt="[ICO]"></th><th><a href="?C=N;O=D">Name</a></th><th><a href="?C=M;O=A">Last modified</a></th><th><a href="?C=S;O=A">Size</a></th><th><a href="?C=D;O=A">Description</a></th></ tr>
                <tr><th colspan="5"><hr></th></tr>
                <tr><td valign="top"><img src="${addr}/Images/back.gif" alt="[PARENTDIR]"></td><td><a href="${parentUrl}">Parent Directory</a>       </td><td>&nbsp;</td><td align="right">  - </td><td>&nbsp;</td></tr>
            `;


                for (let item of dir) {

                    let pathItem = pathFileOrFolder + "/" + item;

                    let stat = fs.statSync(pathItem  );
                    if (stat.isDirectory()) {
                        toDisplay += `<tr><td valign="top"><img src="${addr}/Images/folder.gif" alt="[DIR]"></td><td><a href="${item}/">${item}/</a>              </td><td align="right">${stat.mtime.toUTCString()}  </td><td align="right">  - </td><td>&nbsp;</td></tr>`
                    } else {
                        // Add loading index html if exist
                        if (item === "index.html") {
                            res.setHeader('content-type', 'text/html');
                            res.writeHead(200);
                            res.end(fs.readFileSync(pathItem));
                            return;
                        } else {
                            toDisplay += `<tr><td valign="top"><img src="${addr}/Images/text.gif" alt="[FILE]"></td><td><a href="${item}">${item}</a>           </td><td align="right">${stat.mtime.toUTCString()}  </td><td align="right">  0 </td><td>&nbsp;</td></tr>`;
                        }
                    }
                }

                toDisplay += "</tbody></table><br/><address>Totally not a copy of Apache</address>";
                res.writeHead(200);
                res.end(toDisplay);
                return;
            } catch (ex) {
                res.writeHead(404);
                res.end("Original Error: " + err + "\n" +ex.toString());
            }
            
        }
        res.writeHead(200);
        res.end(data);
    });
}).listen(port); //the server object listens on port 8080

//var url = `http://localhost:${port}/`;
//var start = (process.platform === 'darwin' ? 'open' : process.platform === 'win32' ? 'start' : 'xdg-open');
//require('child_process').exec(start + ' ' + url);