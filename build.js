var path = require('path');
var truffleFlattener = require('truffle-flattener-wrapper');

async function main() {
    var inputFolder = path.resolve(__dirname, 'contracts');
    var outputFolder = path.resolve(__dirname, 'out');
    await truffleFlattener(inputFolder, outputFolder);
}

main().catch(console.error);