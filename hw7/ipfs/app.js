const express = require('express')
const all = require('it-all')
const path = require('path')
const IPFS = require('ipfs');
const app = express()
const port = 3000

async function initGlobalIPFS() {
    global.IPFS = await IPFS.create()
};

initGlobalIPFS()

app.use( '/' , express.static(path.join(__dirname , 'public')))

app.use(express.urlencoded({
    extended: true,
    limit: '10mb'
}));

app.use(express.json({limit: '10mb'}))

app.get('/', (req, res) => {
    res.sendFile('/public/index.html',{root: __dirname});
})

app.post('/ipfs', async (req, res) => {
    const text = req.body.text
    const cid = await global.IPFS.add(text);
    res.send({cid: cid.path})
  })

app.get('/ipfs', async (req, res) => {
    cid = req.query.cid
    const data = Buffer.concat(await all(global.IPFS.cat(cid)));
    res.send({data: data.toString()});
})

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`)
})